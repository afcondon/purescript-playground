import { execFile, spawn } from 'child_process';
import { mkdir, readFile, writeFile } from 'fs/promises';
import { dirname, resolve as pathResolve } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Compiled foreign.js lives at <repo>/output/Playground.Server.Compile/
// so repo root is exactly 2 levels up.
const REPO_ROOT = pathResolve(__dirname, '..', '..');
const WORKSPACE = pathResolve(REPO_ROOT, 'runtime-workspace');
const OUTPUT_DIR = pathResolve(REPO_ROOT, 'output');
const MAIN_PATH = pathResolve(WORKSPACE, 'src', 'Main.purs');
const USER_PATH = pathResolve(WORKSPACE, 'src', 'Playground', 'User.purs');
const BUNDLE_PATH = pathResolve(WORKSPACE, 'output', 'bundle.js');

// ---------- purs ide sidecar ----------

let ideServerProc = null;
let ideServerReady = null;

function startIdeServer() {
  if (ideServerProc) return;
  ideServerProc = spawn(
    'purs',
    ['ide', 'server', '--output-directory', OUTPUT_DIR],
    { stdio: ['ignore', 'pipe', 'pipe'] }
  );
  ideServerProc.on('exit', () => {
    ideServerProc = null;
    ideServerReady = null;
  });
  ideServerReady = pollUntilReady();
  const killSidecar = () => {
    if (ideServerProc) {
      try { ideServerProc.kill('SIGTERM'); } catch (_) {}
    }
  };
  process.once('exit', killSidecar);
  process.once('SIGINT', () => { killSidecar(); process.exit(130); });
  process.once('SIGTERM', () => { killSidecar(); process.exit(143); });
}

async function pollUntilReady() {
  const deadline = Date.now() + 10_000;
  while (Date.now() < deadline) {
    try {
      const r = await idecli({ command: 'cwd' });
      if (r && r.resultType === 'success') return;
    } catch (_) { /* retry */ }
    await sleep(100);
  }
  throw new Error('purs ide server did not become ready within 10s');
}

function idecli(cmd) {
  return new Promise((resolve, reject) => {
    const proc = spawn('purs', ['ide', 'client'], {
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    let stdout = '';
    let stderr = '';
    proc.stdout.on('data', (d) => { stdout += d; });
    proc.stderr.on('data', (d) => { stderr += d; });
    proc.on('error', (e) => reject(e));
    proc.on('exit', (code) => {
      if (code !== 0) {
        reject(new Error(`purs ide client exit ${code}: ${stderr.trim()}`));
        return;
      }
      try {
        resolve(JSON.parse(stdout));
      } catch (e) {
        reject(new Error(`purs ide client: invalid JSON response: ${stdout}`));
      }
    });
    proc.stdin.write(JSON.stringify(cmd) + '\n');
    proc.stdin.end();
  });
}

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

// ---------- spago invocations ----------

// Runs `spago build --json-errors -p playground-runtime` and returns
// {errors, warnings} in our structured shape. Errors from the purs
// compiler carry filename + position; if spago itself fails we fall
// back to a single 'Transport' error.
function runBuildJsonErrors() {
  return new Promise((resolve) => {
    execFile(
      'spago',
      ['build', '-p', 'playground-runtime', '--json-errors'],
      { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
      (_err, stdout, stderr) => {
        // spago wraps purs output with its own status lines; the JSON
        // line is the one starting with '{' and containing "errors":.
        const jsonLine = stdout.split('\n').find((l) => l.startsWith('{') && l.includes('"errors"'));
        if (!jsonLine) {
          // No structured output — either spago itself errored or
          // everything's clean but quiet. Surface stderr if non-empty
          // as a Transport error; otherwise call it clean.
          const trimmed = (stderr || '').trim();
          if (trimmed) {
            return resolve({
              errors: [transportError(trimmed)],
              warnings: [],
              clean: false,
            });
          }
          return resolve({ errors: [], warnings: [], clean: true });
        }
        try {
          const parsed = JSON.parse(jsonLine);
          const errors = (parsed.errors || []).map(toStructured);
          const warnings = (parsed.warnings || [])
            .map(toStructured)
            .filter(keepWarning);
          resolve({ errors, warnings, clean: errors.length === 0 });
        } catch (e) {
          resolve({
            errors: [transportError(`failed to parse --json-errors output: ${e.message}`)],
            warnings: [],
            clean: false,
          });
        }
      }
    );
  });
}

// Drop warnings that are artefacts of synthesis, not user intent.
// Two cases:
//   1. Warnings in the synthesised Main.purs preamble (lines 1-8 —
//      our imports, header, section comments). These fire every
//      compile regardless of what the user wrote.
//   2. MissingTypeDeclaration for `cell_<id>` bindings. We can't give
//      them signatures because we don't know the type until the
//      compiler infers it, but the user shouldn't be warned about a
//      binding they didn't write.
// Module-level warnings (in Playground/User.purs) always pass through.
function keepWarning(w) {
  if (w.filename && w.filename.endsWith('Main.purs')) {
    if (w.position && w.position.startLine <= 8) return false;
    if (w.code === 'MissingTypeDeclaration' && /\bcell_[A-Za-z0-9_]+\b/.test(w.message)) return false;
  }
  return true;
}

function toStructured(pe) {
  const pos = pe.position
    ? {
        startLine: pe.position.startLine,
        startColumn: pe.position.startColumn,
        endLine: pe.position.endLine,
        endColumn: pe.position.endColumn,
      }
    : null;
  return {
    code: pe.errorCode || 'Unknown',
    filename: pe.filename || null,
    position: pos,
    message: (pe.message || '').trim(),
  };
}

function transportError(msg) {
  return { code: 'Transport', filename: null, position: null, message: msg };
}

function runBundle() {
  return new Promise((resolve) => {
    execFile(
      'spago',
      ['bundle', '-p', 'playground-runtime', '--quiet'],
      { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
      (err, _stdout, stderr) => {
        if (err) return resolve({ ok: false, message: stderr || err.message });
        resolve({ ok: true });
      }
    );
  });
}

// ---------- type queries ----------

function extractCellIds(mainSource) {
  const ids = [];
  const re = /^cell_([A-Za-z0-9_]+)\s*=/gm;
  let m;
  while ((m = re.exec(mainSource)) !== null) {
    ids.push(m[1]);
  }
  return ids;
}

async function queryTypes(cellIds) {
  if (cellIds.length === 0) return [];
  try {
    await ideServerReady;
    await idecli({ command: 'load' });
    const results = [];
    for (const id of cellIds) {
      try {
        const r = await idecli({
          command: 'type',
          params: { search: 'cell_' + id, filters: [] },
        });
        const hits = (r && r.result) || [];
        const hit = hits.find((h) => h.module === 'Main') || hits[0];
        if (hit && hit.type) results.push({ id, signature: hit.type });
      } catch (_) { /* skip this cell's type */ }
    }
    return results;
  } catch (_) {
    return [];
  }
}

// ---------- public FFI ----------

// Writes both synthesised sources, runs spago build --json-errors for
// structured diagnostics, then spago bundle for JS (if clean), then
// purs ide for types. Always resolves with a JSON-encoded
// CompileResponse.
export const _compileSourcesPromise = (userSource) => (mainSource) => (cellLinesJson) => () =>
  new Promise((resolve) => {
    startIdeServer();

    let cellLines;
    try { cellLines = JSON.parse(cellLinesJson); } catch (_) { cellLines = []; }

    const respond = (payload) =>
      resolve(JSON.stringify({ ...payload, cellLines }));
    const fail = (msg) =>
      respond({
        js: null,
        warnings: [],
        errors: [transportError(msg)],
        types: [],
      });

    (async () => {
      try {
        await mkdir(dirname(USER_PATH), { recursive: true });
        await Promise.all([
          writeFile(USER_PATH, userSource, 'utf8'),
          writeFile(MAIN_PATH, mainSource, 'utf8'),
        ]);
      } catch (e) {
        return fail(`writeFile failed: ${e.message}`);
      }

      const diag = await runBuildJsonErrors();
      if (!diag.clean) {
        return respond({
          js: null,
          warnings: diag.warnings,
          errors: diag.errors,
          types: [],
        });
      }

      const bundle = await runBundle();
      if (!bundle.ok) {
        return respond({
          js: null,
          warnings: diag.warnings,
          errors: [transportError(`bundle failed: ${bundle.message}`)],
          types: [],
        });
      }

      let js;
      try {
        js = await readFile(BUNDLE_PATH, 'utf8');
      } catch (e) {
        return fail(`bundle read failed: ${e.message}`);
      }
      const cellIds = extractCellIds(mainSource);
      const types = await queryTypes(cellIds);
      respond({ js, warnings: diag.warnings, errors: [], types });
    })();
  });
