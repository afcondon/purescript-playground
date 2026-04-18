import { execFile, spawn } from 'child_process';
import { mkdir, readFile, writeFile } from 'fs/promises';
import { dirname, resolve as pathResolve } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Compiled foreign.js for this adapter lives at
// <repo>/output/Playground.Server.Adapter.NodeProcess/foreign.js —
// repo root is exactly 2 levels up.
const REPO_ROOT = pathResolve(__dirname, '..', '..');
const WORKSPACE = pathResolve(REPO_ROOT, 'runtime-workspace');
const MAIN_PATH = pathResolve(WORKSPACE, 'src', 'Main.purs');
const USER_PATH = pathResolve(WORKSPACE, 'src', 'Playground', 'User.purs');
const BUNDLE_PATH = pathResolve(WORKSPACE, 'output', 'bundle-node.js');

// Node runner wrapper — installed around the compiled bundle before
// it's executed. Overrides globalThis.__playground_emit so that cell
// emissions turn into stdout JSONL, which the parent reads back.
const NODE_WRAPPER = `
globalThis.__playground_emit = (id, value) => {
  process.stdout.write(JSON.stringify({ type: 'emit', id: id, value: value }) + '\\n');
};
process.on('uncaughtException', (e) => {
  process.stdout.write(JSON.stringify({
    type: 'error',
    message: String(e && e.stack || e),
  }) + '\\n');
  process.exit(1);
});
`;

// ---- spago invocations (identical diagnostic path to BrowserWorker;
// ---- duplicated here so adapters stay independent.) ----

function runBuildJsonErrors() {
  return new Promise((resolve) => {
    execFile(
      'spago',
      ['build', '-p', 'playground-runtime', '--json-errors'],
      { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
      (_err, stdout, stderr) => {
        const jsonLine = stdout
          .split('\n')
          .find((l) => l.startsWith('{') && l.includes('"errors"'));
        if (!jsonLine) {
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
            errors: [transportError(`failed to parse --json-errors: ${e.message}`)],
            warnings: [],
            clean: false,
          });
        }
      }
    );
  });
}

function keepWarning(w) {
  if (w.filename && w.filename.endsWith('Main.purs')) return false;
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

function runBundleForNode() {
  return new Promise((resolve) => {
    execFile(
      'spago',
      [
        'bundle',
        '-p', 'playground-runtime',
        '--platform', 'node',
        '--outfile', 'output/bundle-node.js',
        '--quiet',
      ],
      { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
      (err, _stdout, stderr) => {
        if (err) return resolve({ ok: false, message: stderr || err.message });
        resolve({ ok: true });
      }
    );
  });
}

function extractCellIds(mainSource) {
  const ids = [];
  const re = /^cell_([A-Za-z0-9_]+)\s*=/gm;
  let m;
  while ((m = re.exec(mainSource)) !== null) {
    ids.push(m[1]);
  }
  return ids;
}

// Run the bundle in a node child, collect emit events from stdout.
// Resolves (never rejects) with { emits, runtimeError? }.
function runInNode(bundleText) {
  return new Promise((resolve) => {
    const child = spawn('node', ['--input-type=module', '-'], {
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    const emits = [];
    let stderrBuf = '';
    let runtimeError = null;
    let stdoutBuf = '';

    child.stdout.on('data', (chunk) => {
      stdoutBuf += chunk;
      let newlineIdx;
      while ((newlineIdx = stdoutBuf.indexOf('\n')) !== -1) {
        const line = stdoutBuf.slice(0, newlineIdx);
        stdoutBuf = stdoutBuf.slice(newlineIdx + 1);
        if (!line) continue;
        try {
          const msg = JSON.parse(line);
          if (msg.type === 'emit') {
            emits.push({ id: msg.id, value: msg.value });
          } else if (msg.type === 'error') {
            runtimeError = msg.message;
          }
        } catch (_) { /* ignore non-JSON lines */ }
      }
    });
    child.stderr.on('data', (chunk) => { stderrBuf += chunk; });
    child.on('error', (e) => {
      runtimeError = runtimeError || `failed to spawn node: ${e.message}`;
      resolve({ emits, runtimeError });
    });
    child.on('exit', (code) => {
      if (code !== 0 && !runtimeError) {
        runtimeError = `node exited ${code}; stderr: ${stderrBuf.trim()}`;
      }
      resolve({ emits, runtimeError });
    });

    // Kill runaway after 5 seconds.
    const killTimer = setTimeout(() => {
      try { child.kill('SIGTERM'); } catch (_) {}
      runtimeError = runtimeError || 'node runtime exceeded 5s';
    }, 5000);
    child.on('exit', () => clearTimeout(killTimer));

    child.stdin.write(NODE_WRAPPER + '\n' + bundleText);
    child.stdin.end();
  });
}

// ---- public FFI ----

export const _bundle = (userSource) => (mainSource) => () =>
  new Promise(async (resolve) => {
    const empty = { js: null, warnings: [], errors: [], cellIds: [], emits: [] };

    try {
      await mkdir(dirname(USER_PATH), { recursive: true });
      await Promise.all([
        writeFile(USER_PATH, userSource, 'utf8'),
        writeFile(MAIN_PATH, mainSource, 'utf8'),
      ]);
    } catch (e) {
      return resolve({
        ...empty,
        errors: [transportError(`writeFile failed: ${e.message}`)],
      });
    }

    const diag = await runBuildJsonErrors();
    if (!diag.clean) {
      return resolve({
        js: null,
        warnings: diag.warnings,
        errors: diag.errors,
        cellIds: [],
        emits: [],
      });
    }

    const bundle = await runBundleForNode();
    if (!bundle.ok) {
      return resolve({
        js: null,
        warnings: diag.warnings,
        errors: [transportError(`node bundle failed: ${bundle.message}`)],
        cellIds: [],
        emits: [],
      });
    }

    let bundleText;
    try {
      bundleText = await readFile(BUNDLE_PATH, 'utf8');
    } catch (e) {
      return resolve({
        ...empty,
        errors: [transportError(`bundle read failed: ${e.message}`)],
        warnings: diag.warnings,
      });
    }

    // Node's ESM stdin reader doesn't tolerate a shebang line, but
    // spago bundle adds one for platform=node. Strip it.
    if (bundleText.startsWith('#!')) {
      const nl = bundleText.indexOf('\n');
      bundleText = nl === -1 ? '' : bundleText.slice(nl + 1);
    }

    const { emits, runtimeError } = await runInNode(bundleText);

    const errors = runtimeError
      ? [{ code: 'Runtime', filename: null, position: null, message: runtimeError }]
      : [];

    resolve({
      js: null,
      warnings: diag.warnings,
      errors,
      cellIds: extractCellIds(mainSource),
      emits,
    });
  });
