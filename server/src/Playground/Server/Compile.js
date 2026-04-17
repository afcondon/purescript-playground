import { execFile } from 'child_process';
import { mkdir, readFile, writeFile } from 'fs/promises';
import { dirname, resolve as pathResolve } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Compiled foreign.js lives at <repo>/output/Playground.Server.Compile/
// so repo root is exactly 2 levels up.
const REPO_ROOT = pathResolve(__dirname, '..', '..');
const WORKSPACE = pathResolve(REPO_ROOT, 'runtime-workspace');
const MAIN_PATH = pathResolve(WORKSPACE, 'src', 'Main.purs');
const USER_PATH = pathResolve(WORKSPACE, 'src', 'Playground', 'User.purs');
const BUNDLE_PATH = pathResolve(WORKSPACE, 'output', 'bundle.js');

// Writes the synthesised userSource into Playground/User.purs and
// mainSource into Main.purs, then runs `spago bundle -p playground-runtime`
// in the workspace. Returns a Promise that resolves to a JSON string of
// { js, warnings, errors, types }. We never reject — every failure is
// routed into the `errors` array so the caller's Aff stays on the happy
// path.
export const _compileSourcesPromise = (userSource) => (mainSource) => () =>
  new Promise((resolve) => {
    const respond = (payload) => resolve(JSON.stringify(payload));
    const fail = (msg) =>
      respond({ js: null, warnings: [], errors: [msg], types: [] });

    mkdir(dirname(USER_PATH), { recursive: true })
      .then(() =>
        Promise.all([
          writeFile(USER_PATH, userSource, 'utf8'),
          writeFile(MAIN_PATH, mainSource, 'utf8'),
        ])
      )
      .then(() => {
        execFile(
          'spago',
          ['bundle', '-p', 'playground-runtime', '--quiet'],
          { cwd: WORKSPACE, maxBuffer: 16 * 1024 * 1024 },
          (err, _stdout, stderr) => {
            if (err) {
              respond({
                js: null,
                warnings: [],
                errors: [stderr || err.message],
                types: [],
              });
              return;
            }
            readFile(BUNDLE_PATH, 'utf8')
              .then((js) =>
                respond({ js, warnings: [], errors: [], types: [] })
              )
              .catch((e) => fail(`bundle read failed: ${e.message}`));
          }
        );
      })
      .catch((e) => fail(`writeFile failed: ${e.message}`));
  });
