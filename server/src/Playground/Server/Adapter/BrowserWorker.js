import { execFile } from 'child_process';
import { mkdir, readFile, writeFile } from 'fs/promises';
import { dirname, resolve as pathResolve } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Compiled foreign.js for this adapter lives at
// <repo>/output/Playground.Server.Adapter.BrowserWorker/foreign.js —
// repo root is exactly 2 levels up. (Modern spago flattens the nested
// module namespace in its output dir to a dot-joined folder name.)
const REPO_ROOT = pathResolve(__dirname, '..', '..');
const WORKSPACE = pathResolve(REPO_ROOT, 'runtime-workspace');
const MAIN_PATH = pathResolve(WORKSPACE, 'src', 'Main.purs');
const USER_PATH = pathResolve(WORKSPACE, 'src', 'Playground', 'User.purs');
const BUNDLE_PATH = pathResolve(WORKSPACE, 'output', 'bundle.js');

// ---- spago invocations ----

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

// Drop warnings that are artefacts of synthesis, not user intent. Two
// cases: warnings in the Main.purs preamble (lines 1-12 — our module
// header, common imports, section comments) and MissingTypeDeclaration
// for cell_<id> bindings (we can't give them signatures because the
// type isn't known until the compiler infers it).
function keepWarning(w) {
  if (w.filename && w.filename.endsWith('Main.purs')) {
    if (w.position && w.position.startLine <= 12) return false;
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

function extractCellIds(mainSource) {
  const ids = [];
  const re = /^cell_([A-Za-z0-9_]+)\s*=/gm;
  let m;
  while ((m = re.exec(mainSource)) !== null) {
    ids.push(m[1]);
  }
  return ids;
}

// ---- public FFI ----

export const _bundle = (userSource) => (mainSource) => () =>
  new Promise(async (resolve) => {
    const nothing = { js: null, warnings: [], errors: [], cellIds: [] };

    try {
      await mkdir(dirname(USER_PATH), { recursive: true });
      await Promise.all([
        writeFile(USER_PATH, userSource, 'utf8'),
        writeFile(MAIN_PATH, mainSource, 'utf8'),
      ]);
    } catch (e) {
      return resolve({
        ...nothing,
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
      });
    }

    const bundle = await runBundle();
    if (!bundle.ok) {
      return resolve({
        js: null,
        warnings: diag.warnings,
        errors: [transportError(`bundle failed: ${bundle.message}`)],
        cellIds: [],
      });
    }

    let js;
    try {
      js = await readFile(BUNDLE_PATH, 'utf8');
    } catch (e) {
      return resolve({
        js: null,
        warnings: diag.warnings,
        errors: [transportError(`bundle read failed: ${e.message}`)],
        cellIds: [],
      });
    }
    resolve({
      js,
      warnings: diag.warnings,
      errors: [],
      cellIds: extractCellIds(mainSource),
    });
  });
