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

// Drop all warnings that live in the synthesised Main.purs. Reasons:
//   - preamble warnings are synthesis artefacts,
//   - mirrored user imports would generate duplicates of warnings
//     the user already sees from Playground/User.purs,
//   - MissingTypeDeclaration on cell_<id> bindings is inherent to
//     the synthesis (we don't know the type until inference).
// The user's own warnings still flow through from User.purs. If we
// later want fine-grained cell-specific warnings we'll thread cellLines
// in and keep warnings that fall inside a cell's range.
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

function runBundle() {
  return new Promise((resolve) => {
    execFile(
      'spago',
      ['bundle', '-p', 'playground-runtime'],
      { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
      (err, stdout, stderr) => {
        if (err) return resolve({ ok: false, message: formatBundleFailure(err, stdout, stderr) });
        resolve({ ok: true });
      }
    );
  });
}

function formatBundleFailure(err, stdout, stderr) {
  const parts = [];
  const serr = (stderr || '').trim();
  const sout = (stdout || '').trim();
  if (serr) parts.push('stderr:\n' + serr);
  if (sout) parts.push('stdout:\n' + sout);
  if (!parts.length) parts.push(err.message);
  return parts.join('\n\n');
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

// Module-level queue: serialises _bundle invocations so that two
// concurrent callers (e.g. Session.purs under its lock + an /ide/*
// query or a stray external spago) can't race on runtime-workspace's
// src/ and output/ files. The Session already holds a write lock, so
// this is belt-and-braces against anything the server doesn't control.
let bundleQueue = Promise.resolve();

export const _bundle = (userSource) => (mainSource) => () => {
  const task = bundleQueue.then(() => runBundlePipeline(userSource, mainSource));
  // Swallow errors in the queue's view so a rejection from one call
  // doesn't poison the chain for the next; callers see their own task.
  bundleQueue = task.catch(() => {});
  return task;
};

function runBundlePipeline(userSource, mainSource) {
  return new Promise(async (resolve) => {
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

    const bundle = await runBundle();
    if (!bundle.ok) {
      return resolve({
        js: null,
        warnings: diag.warnings,
        errors: [transportError(`bundle failed: ${bundle.message}`)],
        cellIds: [],
        emits: [],
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
        emits: [],
      });
    }
    resolve({
      js,
      warnings: diag.warnings,
      errors: [],
      cellIds: extractCellIds(mainSource),
      emits: [],
    });
  });
}
