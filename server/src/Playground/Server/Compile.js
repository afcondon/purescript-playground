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

// Keep a single purs ide server alive for the lifetime of the backend.
// The first type query pays a ~2–3s warm-up; subsequent ones are ~50ms.
let ideServerProc = null;
let ideServerReady = null; // Promise<void>

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
  // Kill the sidecar when the backend exits.
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

// Extract cell ids from the synthesised Main.purs by scanning for lines
// of the form `cell_<id> = ...`. Using the source of truth we just wrote
// (rather than re-parsing the request) keeps types aligned with the
// actual bindings the compiler sees.
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
        // Prefer a Main-module hit so we don't accidentally pick up a
        // collision with a library binding of the same name.
        const hits = (r && r.result) || [];
        const hit = hits.find((h) => h.module === 'Main') || hits[0];
        if (hit && hit.type) {
          results.push({ id, signature: hit.type });
        }
      } catch (_) { /* skip this cell's type */ }
    }
    return results;
  } catch (_) {
    return [];
  }
}

// Writes both synthesised sources, bundles, and queries types. Always
// resolves — failures go into the errors array so the caller's Aff
// stays on the happy path.
export const _compileSourcesPromise = (userSource) => (mainSource) => () =>
  new Promise((resolve) => {
    startIdeServer();
    const respond = (payload) => resolve(JSON.stringify(payload));
    const fail = (msg) =>
      respond({ js: null, warnings: [], errors: [msg], types: [] });

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

      execFile(
        'spago',
        ['bundle', '-p', 'playground-runtime', '--quiet'],
        { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
        async (err, _stdout, stderr) => {
          if (err) {
            return respond({
              js: null,
              warnings: [],
              errors: [stderr || err.message],
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
          respond({ js, warnings: [], errors: [], types });
        }
      );
    })();
  });
