# PureScript Playground

**Status:** Idea → Planning
**Slug:** `papa-whiskey-uniform-lima` (marginalia id 158)
**Location:** `/Users/afc/work/afc-work/purescript-playground` (own repo, TBD remote)
**Parent in marginalia:** WebApps (`victor-xray-golf-bravo`)
**Related:** `ShapedSteer` (stepping stone — sibling showcase, not a subsystem), `GitHub/trypurescript` (reference only — we used to plan to proxy its compile server; now we drive `purs` ourselves, see the "Compile service — why not trypurescript" note below)

## Vision

A browser-based PureScript scratchpad modelled on Manuel Chakravarty's
*Haskell for Mac*. Three text surfaces in a single live session:

```
┌──────────────────────┬───────────────────────┬──────────────┐
│                      │                       │              │
│   User module        │   Playground cells    │  Inline      │
│   (arbitrary name;   │   (bare expressions   │  result +    │
│    imports, types,   │    and let-bindings;  │  type per    │
│    bindings)         │    cumulative scope,  │  cell,       │
│                      │    sees the module's  │  aligned to  │
│                      │    top-levels)        │  the cell    │
│                      │                       │              │
└──────────────────────┴───────────────────────┴──────────────┘
```

Not a REPL. Everything is in scope of everything else and re-evaluated
continuously as you type. A cell can `let x = …` and the next cell sees
`x`. The user module's top-level bindings are visible to every cell.

Intended audience: two-headed.

1. **Learners** — a better landing than try.purescript.org because you
   can write supporting code in the LHS module and explore it via
   multiple expressions in the playground, all live.
2. **Practised PureScripters** — a REPL-shaped scratchpad that beats the
   actual REPL for working ideas out. Full package set available
   locally; no hunting for the right `import` incantations.

Why it earns its own repo: it's not a visualization showcase, not a
Hylograph lib, and not obviously a subsystem of any other project. It
touches compiler tooling (sidecar for types), package-set hosting, and a
continuous-eval UX — those concerns don't want to live under a sibling.

## Non-goals (for now)

- Not the full Bret Victor surface (no sliders on numbers, no inline
  chart widgets, no direct-manipulation of literals).
- Not a replacement for a PureScript IDE. No go-to-definition, no
  completion, no refactors. Just: edit, eval, see results.
- Not a multi-module project manager. MVP has exactly one user module
  and one playground.
- Not a sharing platform. URL-encoded state is a Phase 3 add-on, not
  MVP.
- Not a tests/QuickCheck runner. HfM shows QuickCheck output because
  Haskell-land leans on it; we can add once the core scratchpad works.

## Relationship to ShapedSteer

ShapedSteer will eventually need very similar infrastructure — a cell
model with results, types, and live re-evaluation. The Playground is
a good place to figure out the **synthesis + scope + result-capture**
pattern without also having to think about typed DAG edges, multiple
executors, and the grid/notebook/timeline views.

We build the Playground standalone. We do **not** invest in making the
playground-eval machinery a shared library. If ShapedSteer wants those
patterns later, we refactor then. Well-structured PureScript refactors
cheaply.

## Architecture

### Components

```
┌────────────────────────────────────────────────────────────────┐
│                         Browser                                │
│                                                                │
│   Halogen app                                                  │
│   ┌────────────────┐  ┌───────────────┐  ┌─────────────────┐   │
│   │ Module editor  │  │  Playground   │  │  Result gutter  │   │
│   │ (CodeMirror 6) │  │  cells editor │  │  (Sigil types,  │   │
│   │                │  │  (CM6)        │  │   Show values)  │   │
│   └────────┬───────┘  └───────┬───────┘  └───────▲─────────┘   │
│            └─────────┬────────┘                  │             │
│                      ▼                           │             │
│              [debounced submit]            [results via        │
│                      │                      postMessage]       │
│                      │                           │             │
│                      │           ┌───────────────┴───────┐     │
│                      │           │     Web Worker        │     │
│                      │           │  (runs compiled JS,   │     │
│                      │           │   timeout-bounded)    │     │
│                      │           └───────────────────────┘     │
└──────────────────────┼─────────────────────────────────────────┘
                       ▼
┌────────────────────────────────────────────────────────────────┐
│                    Playground backend                          │
│                (HTTPurple, Node, own process)                  │
│                                                                │
│   POST /session/compile                                        │
│     ├─ synthesize Main.purs from (module + cells)              │
│     ├─ write into runtime-workspace/src/Main.purs              │
│     ├─ shell out to `spago bundle` against that workspace      │
│     ├─ (Phase 2) ask purs-ide sidecar for cell types           │
│     └─ return { js, warnings, errors, types }                  │
│                                                                │
│   GET  /output/:module/(index.js|foreign.js)                   │
│     └─ static route over runtime-workspace/output/ so the      │
│        Worker's require shim resolves library modules          │
└────────┬───────────────────────────────────┬───────────────────┘
         │                                   │
         ▼                                   ▼
┌──────────────────────────┐    ┌───────────────────────────┐
│ runtime-workspace/       │    │  Type sidecar (Phase 2)   │
│                          │    │                           │
│  spago.yaml pinned to    │    │  purs ide server rooted   │
│  registry: 73.3.0        │    │  at runtime-workspace/ +  │
│  src/Main.purs is the    │    │  purescript-language-     │
│  synthesised module,     │    │  cst-parser for cell      │
│  rewritten on every POST │    │  identifier extraction    │
│  output/ served statically│   └───────────────────────────┘
└──────────────────────────┘
```

Backend and frontend follow the Minard / Marginalia pattern: HTTPurple
backend in its own process, Halogen frontend in its own process, wired
together over HTTP + CORS. We run `spago` / `purs` ourselves against a
modern-tooling workspace checked in at `runtime-workspace/` — no
external compile server, no legacy Dhall tooling in the hot path.

### Compile service — why not trypurescript?

We briefly planned to proxy trypurescript's compile server (a Haskell
binary that wraps `purs` and returns `{ js, warnings }` or `{ errors }`).
Two things changed that plan:

1. Upstream trypurescript (last commit 2023-12-22) still uses
   pre-registry spago with `spago.dhall` / `packages.dhall`. Modern
   `spago` can't build its `staging/` package set, so we'd need a
   modernisation PR just to stand the server up locally.
2. Our backend was already going to own a `purs ide` sidecar, the
   `Main.purs` synthesis, the source-map, and the Worker protocol. The
   trypurescript binary's remaining contribution (spawning `purs`,
   static-serving output, CORS, timeouts) is small in our Node/HTTPurple
   backend.

So we absorbed the compile-server role. A modernisation PR against
upstream trypurescript is now a potential good-citizen follow-up (see
"Stretch — upstream contributions"), not a dependency.

### Compile flow (MVP)

1. User edits the module or any cell.
2. After a ~400ms debounce, the frontend POSTs `{ module, cells }` to
   the backend.
3. Backend synthesizes a single `Main.purs` (see "Synthesis design"
   below) and writes it into `runtime-workspace/src/Main.purs`.
4. Backend shells out to `spago bundle -p playground-runtime --platform browser`
   (or an equivalent `purs compile` + post-processing) against the
   workspace; captures the bundle JS, warnings, and errors.
5. Backend returns `{ js, warnings, errors }` to the frontend.
6. Frontend posts the JS into a Web Worker. The Worker runs it with a
   (say) 3-second timeout and pushes cell-result events back via
   `postMessage`.
7. Frontend renders each cell's result in the gutter, aligned to the
   cell's position.
8. If compilation failed, show the error(s) prominently somewhere
   (MVP = single panel, post-MVP = inline on the originating cell/line).

### Execution model

Web Worker is the execution sandbox. Reasons:

- Infinite loops don't freeze the main thread.
- We can terminate the worker on new compilations or on timeout.
- The `spago bundle` output is a single self-contained browser module;
  no `require` shim needed to pull in library JS at runtime. (If we
  later switch to `purs compile` without bundling for finer control,
  we'll serve `/output/:module/…` as static files over HTTPurple and
  wire up a require-1k shim in the Worker.)

The Worker receives the compiled JS + a list of cell ids. The
synthesized `main` calls a side-channel function we inject (e.g.
`__playground_emit(id, value)`) to publish each cell's result.

## Synthesis design (the core trick)

We compile one module, named `Main`, per keystroke-batch. The trick is
mapping (user module + playground cells) onto that single module such
that:

- Scope semantics match the HfM screenshot (cells see each other and
  the module; later cells see earlier cells).
- Each cell has a stable top-level binding we can evaluate and emit.
- The synthesis is reversible enough for error messages to be mapped
  back to user coordinates.

### Input shape

Frontend submits:

```json
{
  "module": {
    "source": "module Foo where\n\nimport Prelude\n\ndouble x = x * 2\n"
  },
  "cells": [
    { "id": "c1", "kind": "let",  "source": "let quick = quickCheckPure 100" },
    { "id": "c2", "kind": "expr", "source": "double 21" },
    { "id": "c3", "kind": "expr", "source": "map double [1,2,3]" }
  ]
}
```

Cell kinds:

- `expr` — a bare expression, evaluated for its value and type.
- `let` — `let name = rhs` or `name :: T; name = rhs`; binds a name
  visible to later cells but is not itself emitted as a result.

### Synthesised Main.purs

```purescript
module Main where

-- Import user's module verbatim. Its module name gets rewritten to
-- `Playground.User` by the synthesiser so it can always be imported
-- unambiguously regardless of what the user typed at the top of the
-- LHS editor.
import Playground.User

-- (plus whatever `import` lines the user wrote, which we propagate)

import Effect (Effect)
import Effect.Console (log) as PG

-- Foreign runtime hook — provided by the Web Worker environment.
foreign import __playground_emit :: String -> String -> Effect Unit

-- `let`-cells become top-level bindings (kept simple; type inference
-- fills in the signature).
quick = quickCheckPure 100   -- from cell c1

-- `expr`-cells become top-level bindings named by cell id.
cell_c2 = double 21
cell_c3 = map double [1,2,3]

main :: Effect Unit
main = do
  toPlaygroundValue cell_c2 >>= __playground_emit "c2"
  toPlaygroundValue cell_c3 >>= __playground_emit "c3"
```

Notes:

- **User module renamed**: whatever the user typed at the top of the
  LHS editor (`module Foo where`, `module MyExperiment where`, …) is
  rewritten on the server to `module Playground.User where`. User never
  sees this. Keeps the backend deterministic.
- **Cell ids are stable**: frontend assigns them; backend uses them as
  binding names (prefixed `cell_` to dodge keywords).
- **Imports**: module's imports are preserved in the synthesised
  `Main`. Playground cells don't get to `import` — keep the module as
  the place to declare intent.
- **`let` cells** become top-level bindings *without* a synthesised
  `main`-line entry. Their binding is available to later cells.
- **`expr` cells** become top-level bindings AND get a line in `main`
  that shows + emits them.
- **`ToPlaygroundValue` class** dispatches rendering from day one. The
  `main` block above calls `toPlaygroundValue` (returns `Effect String`),
  not bare `show`. That gives us the hook we need to special-case
  `Effect a` values without a two-compile dance.

### Source mapping (Phase 2, but design-aware now)

Compiler errors come back with line/col in the *synthesised* `Main.purs`.
To map back to the user's coordinates we need, per synthesis:

- Per-line map: synthesised line → (surface, line in that surface). A
  surface is "module editor" or "cell c2" etc.
- Column offsets for `let` cells (since we may prefix with `cell_` etc.).

We build this during synthesis and hand it back in the response so the
frontend can attribute errors. MVP can skip this (just show errors in
a panel); implementing it is a Phase 2 task.

### ToPlaygroundValue — the class that makes effects and values look the same

The synthesised `main` calls `toPlaygroundValue` on every cell, never
`show` directly. The class lives in a small `Playground.Runtime` module
that's injected into every compile:

```purescript
class ToPlaygroundValue a where
  toPlaygroundValue :: a -> Effect String

instance ToPlaygroundValue (Effect a) where
  toPlaygroundValue eff = do
    r <- eff
    toPlaygroundValue r
else instance Show a => ToPlaygroundValue a where
  toPlaygroundValue = pure <<< show
```

Instance-chain ordering (`else instance`) resolves the overlap: an
`Effect a` cell runs its effect and recursively renders the result; any
other value with `Show` goes through `show`. HfM's `quickCheck'
prop_revRev` case — a cell of type `Effect String` that should display
`"+++ OK, passed 100 tests."` — is handled by this chain without any
type-directed synthesis gymnastics on the backend.

In Phase 2 we extend `ToPlaygroundValue` with richer instances (records,
arrays of structured data, `Maybe`/`Either`, etc.) rendered via Sigil
rather than plain `show`. The class is the extension point — we're not
locked into `String` forever; `toPlaygroundValue` can return a
`Sigil`-renderable intermediate once Phase 2 is in flight.

## Type rendering

Types are rendered via **purescript-sigil**. It takes a PureScript type
signature string and produces a typographically nice DOM rendering
(see `/Users/afc/work/afc-work/purescript-hylograph-libs/purescript-sigil/`).

The type sidecar is a long-lived **`purs ide server`** subprocess,
managed by the backend:

- On startup, backend launches `purs ide server` pointed at a
  workspace directory.
- On each compile, the synthesised `Main.purs` is written to that
  workspace so `purs ide` sees it.
- Backend queries `purs ide` for the type of each `cell_cN` binding
  (and for the names of `let`-cells) via the standard
  `{ "command": "type", ... }` protocol.
- `purescript-language-cst-parser` is used on the synthesised module to
  enumerate cell identifiers authoritatively, so the backend doesn't
  have to trust its own synthesis record.

This is heavier than reading externs, but `purs ide` is the same
infrastructure we'd want for hover-types, completion, and
go-to-definition later — it pays forward. Sidecar returns
`{ types: { c2: "Int", c3: "Array Int", … } }` to the frontend; the
frontend hands each type string to Sigil.

Because we're committing to `purs ide` from day one, we should decide
whether inline types land in Phase 1 (if the sidecar is running
anyway) or stay Phase 2. See Open Decisions.

## Phase 1 — MVP

**Goal:** the scratchpad works end-to-end and looks like HfM —
a module, a column of cells, and a gutter that shows both the value
and the inferred type for each cell, all updating live.

- Edit a module and a sequence of cells.
- See each cell's rendered value (via `ToPlaygroundValue`) update live.
- See each cell's inferred type rendered by Sigil in the gutter.
- `Effect a` cells auto-run and display the result.
- See compile errors in a panel when the code doesn't compile.

**In scope:**

- Halogen frontend, CM6 editors (two: module, cells).
- HTTPurple backend that synthesises `Main.purs`, shells out to `spago
  bundle` against `runtime-workspace/`, and manages a `purs ide`
  subprocess for type queries.
- `purescript-language-cst-parser` on the backend to enumerate cell
  identifiers for type lookup.
- Web Worker execution with timeout.
- `ToPlaygroundValue` class injected into every compile (instance
  chain: `Effect a` first, `Show a` second).
- Sigil rendering of each cell's inferred type in the gutter.
- `show`-based (via `ToPlaygroundValue`) result rendering alongside
  types in the gutter.
- `expr` cells and `let` cells.
- Single user module, hard-coded starter content on first load.
- Full package set in `runtime-workspace/spago.yaml`, pinned to
  `registry: 73.3.0`, curated on our own cadence. Broad starter deps
  (`prelude`, `effect`, `console`, `aff`, `arrays`, `foldable-traversable`,
  `maybe`, `tuples`, `strings`, `integers`, `numbers`, `ordered-collections`,
  `random`, plus a dose of `halogen`-adjacent stuff if we want UI demos).

**Out of scope (Phase 1):**

- No inline error attribution (just show the error text in a panel).
- No richer value rendering (plain `show`-style strings for values;
  Sigil-rendered records/arrays/etc. is Phase 2).
- No URL sharing, no multi-module, no file tree.
- No login, no persistence.

## Phase 2 — Inline error attribution, richer value rendering

- Source map so compiler errors get attributed to the originating
  surface (module / which cell).
- `ToPlaygroundValue` instances for richer structures (records, arrays
  of records, `Maybe`/`Either`, nested data) that render via Sigil
  rather than plain `show`.
- Sigil integration for value rendering, not just type rendering.
- Warnings surfaced inline (not just errors).
- Hover-type popovers on identifiers inside the editors (the `purs
  ide` subprocess is already running, so this is close to free).

## Phase 3 — Broaden

- URL-encoded state for sharing (compressed — the same trick
  trypurescript uses for its `code=` query parameter).
- File tree in the left margin: multiple user modules, cross-references
  allowed.
- Persistence of sessions (probably filesystem-first, SQLite later).
- Export: save session as a runnable PureScript project.
- Starter galleries (e.g. "Hylograph-libs walkthrough", "PureScript
  101").

## Phase 4 — The Claude panel

A fourth surface in the UI: a conversational pane on the right where
Claude can observe the session and collaborate with the user. Not
committed to before Phase 3, but worth designing around now so we
don't foreclose it.

```
┌──────────────┬──────────────┬────────────┬──────────────────┐
│ Module       │ Playground   │ Value+type │ Claude panel     │
│ editor       │ cells        │ gutter     │ (chat +          │
│              │              │            │  proposed edits) │
└──────────────┴──────────────┴────────────┴──────────────────┘
```

What Claude gets to see (via Anthropic API, one backend-mediated
endpoint):

- The user module source.
- The full cell list (ids + kind + source).
- Per-cell inferred types (already computed by the `purs ide` sidecar).
- Per-cell rendered values (already emitted by the Web Worker).
- The current set of compile errors and warnings, in the same JSON
  shape the compiler produces.
- A conversation history scoped to this session.

What Claude can do:

- **Explain** an error or a type, grounded in the actual current code.
- **Propose cells** — e.g. "five small examples of `Data.Array.fold`"
  — that the user can accept into the playground as real cells.
- **Propose edits** to the module or an existing cell, surfaced as a
  diff the user accepts or rejects. Edits round-trip through the
  normal compile/eval loop, so the user sees the new value+type before
  committing.
- **Teach** — for the learner audience, walk through what's happening,
  suggest next exercises, calibrate to the user's stated level.

### Why this isn't just "a chat sidebar"

The thing that makes the Claude panel distinctive in the Playground
context is that Claude has the **compiler's view** of the code — every
cell's actual inferred type and actual runtime value — not just the
source text. That's a richer grounding than a normal IDE assistant has.
Suggestions can be calibrated against what the code *currently does*,
not what it *textually says*.

The corollary: the session-state shape we're building for Phase 1
(module + cells + types + values + errors) is already the right
payload for this. No retrofit needed. Prompt caching works naturally:
the cached block is (module source + imports + package set context),
the turn-varying block is (cells + results + user message).

### Design principles to preserve now

These don't change any Phase 1 work; they're just things we keep in
mind so Phase 4 isn't a rewrite:

- **Session state is a serialisable value, not UI state scattered
  across Halogen components.** Already true given the backend round-trip
  model; keep it so.
- **Compile results carry structured errors**, not just rendered
  strings. `purs`'s `--json-errors` format gives us this; don't throw
  it away on the way to the frontend.
- **Cell ids are stable across edits.** Already a commitment for type
  correlation; the Claude panel leans on the same property.
- **Edits-via-tool-use**: when we add the panel, Claude's edit
  proposals land via a tool-use protocol (structured `{surface, cell,
  newSource}`), not free-text diffs. Cleaner UX and safer to apply.

## Starter content

What the user sees on first load (hard-coded in the frontend for MVP):

**Module editor**

```purescript
module Scratch where

import Prelude

double :: Int -> Int
double x = x * 2
```

**Playground cells**

```
double 21
map double [1, 2, 3, 4, 5]
let xs = 1..10
sum (map double xs)
```

Zero library imports beyond `Prelude`. `double 21` is the liveness
smoke test — change the `2` in the module to `3`, see the cell jump
to `63`. `let xs = 1..10` demonstrates a `let`-cell binding visible
to the cell below it. Enough shape to communicate the model in a
single screen; nothing the user has to install or understand first.

## Positioning beyond MVP

Captured 2026-04-18 — the framing that crystallised once the MVP was
in front of us in Chrome. This is forward-looking; what's actually
implemented is the MVP described in Phase 1.

### Two practitioner use cases (no learners)

We initially imagined a learner audience alongside the practitioner
one. Dropping that. Both modes assume PureScript fluency and target
practitioners:

- **(A) Live scratchpad** — the HfM-modelled environment we shipped:
  module + cells + per-cell types + per-cell values, live recompile,
  Web Worker execution, dedicated error panel.
- **(B) AI collaboration around design-by-types** — the Claude-panel
  direction (Phase 4 below). Not "AI helps you write code." The
  framing that emerged in conversation: PureScript starts to feel
  like a *high-level assembly language* — Claude writes the
  implementations, the human operates at the type-design level. Types
  become the negotiation surface; cells become design probes that
  ground the design in concrete behaviour.

Dropping the learner framing frees up real things: we can show full
structural error output, surface `purs ide` features verbatim
(hover, completion, search-by-type), assume `Show` and the type
system are vocabulary the user already has.

### Rapid development environment with AI-mediated lift

The historical killer of scratchpad culture (Smalltalk workspaces,
Lisp listeners, IPython, even REPL-driven workflows) was the *transfer
tax*: figure something out interactively, then rewrite it in the real
codebase with proper structure, types, tests, naming. AI capabilities
make that tax near-zero — a sketched cell can be promoted into a
properly-shaped module in some target project, named per project
conventions, with tests stubbed and deps added to that project's
`spago.yaml`. The Playground becomes a *staging surface*, not a
terminal destination.

Architectural consequences worth designing toward now:

- A **promote** affordance: select cells → pick a target project →
  lift code into that project's source tree. Probably Claude-mediated
  (it has the context to do project-aware naming and placement).
- **Project-context binding** — a Playground instance can attach to a
  project: package set drawn from that project's `spago.yaml`,
  top-level identifiers from that project in scope, promote landing
  by default in that project. Without this, the Playground is a
  sandbox; with it, it's an extension of an existing codebase.

### Runtime substrate is pluggable

Today: `spago bundle` for browser, executed in a Web Worker. But the
synthesis pipeline (module + cells → `Main.purs`) is runtime-agnostic.
Two natural alternates:

- **Node host** — same JS bundle, run in a Node `child_process`
  instead of a Worker. Now user code can hit FS, sockets, DBs, native
  modules. A scratchpad for backend-PS development. Emit protocol can
  be richer (capture stdout, stream long-running effects).
- **Purerl host** — different spago backend (`purerl`), bundles to
  BEAM, backend supervises an Erlang process. A typed scratchpad with
  real OTP execution — interactive design for fault-tolerant systems.

Either is "swap the runtime adapter," not a rewrite. The right move
during Phase 2: **make `Compile.js`'s runtime adapter explicit** so
the swap is mechanical when we want it. Today the browser/Worker
shape is implicit in the bundling step + the worker plumbing.

### Edges of the system as the AI-collaboration sweet spot

Where the AI-collaboration mode pays the most: the *edges* of a
system, not the pure-internal logic. Sockets, DBs, FS, AJAX, GraphQL,
SQL — places where the human wants to supervise the interpretation
of stuff coming in from outside. Those edges are also where types do
their best work (parsing, schema, codecs). Likely runtime-workspace
deps to add as we move that direction:

- `argonaut` / `codec-argonaut` — JSON codecs (already in)
- `affjax` — HTTP client
- `node-fs` — filesystem (Node host only)
- `httpurple` — HTTP server (Node host)
- A typed Postgres client — Mark Eibes' `postgres-om` (or whatever
  the current name is) for SQL with compile-time schema checks
- `purescript-graphql` if/when GraphQL becomes interesting

The pattern is consistent: a typed interface on top of a messy edge,
exercised through cells that probe the edge's behaviour, with Claude
proposing and refining types as the boundary's shape becomes clearer.

## Trajectory — replace trypurescript.org

Updated stance (2026-04-18). Rather than filing a modernisation PR
against the legacy trypurescript repo, the Playground grows into its
successor. Reasons: it starts with all the things trypurescript needs
anyway (modern spago, registry-pinned package set, structured JSON
response, typed client), plus the things trypurescript doesn't have
(per-cell types + values, Sigil-rendered signatures, Web Worker
sandbox, AI-collaboration substrate). Core-team reception is
expected to be supportive given the project is open-source and fills
the same role with a better foundation.

What this requires beyond MVP:

- **Performance parity-or-better with trypurescript's hot-path
  compile**. Today we shell `spago bundle` on every edit; that's
  ~100ms warm but grows with imports. The "compile Main only + link
  precompiled library chunks" model trypurescript uses (a `require`
  shim in the Worker pulling `/output/:module/…` served statically)
  is the right target. Bundle size stays fixed, only Main.purs +
  Playground.User.purs recompile per keystroke.
- **Feature parity with trypurescript's public surface**: URL-encoded
  shareable state (`code=`), GitHub gist + repo loading (`gist=`,
  `github=`), view-mode switching (code / output / both),
  JS-code-generation toggle (`js=true`). Most of these live in the
  Phase 3 block; the successor framing moves them from "nice to
  have" to "table stakes."
- **A hosted instance at a production-quality URL** — either taking
  over `try.purescript.org` (core-team conversation) or launching at
  a Hylograph-owned URL first and earning the redirect.
- **Operational hygiene**: rate limits, sandboxed compile pool,
  auth-free but abuse-resistant. The backend already owns the
  compile invocations, so this is a backend-layer concern.

None of this blocks us from shipping the practitioner + AI-collab
modes for local use; it's what turns the local tool into a hosted
successor.

### Original trypurescript — what still makes sense

- **Lessons flow outward, not back**: if the Playground's synthesis
  pipeline or `ToPlaygroundValue` design is useful elsewhere, we lift
  it to a library (likely in `purescript-hylograph-libs`) rather than
  patching the legacy repo.
- **A courtesy PR** to trypurescript pointing at the successor once
  it's ready, probably in the README, so folks finding the old repo
  know where to go.

## Stretch — the Bret Victor corner

If and only if Phases 1–3 land and still want more:

- Hover over an `Int` literal → slider to scrub values and see results
  update live.
- Hover over a list/array of numbers → small plot inline.
- Hover over a typed function value → table of inputs/outputs.
- None of this is committed-to; it's where the "useful contribution to
  the ecosystem" idea can reach further.

## Decisions

Locked in (2026-04-17):

- **Effect-cell handling** — `ToPlaygroundValue` class with an
  instance chain (`Effect a` first, `Show a` second). Dispatch from
  day one; cells of type `Effect a` auto-run and render the result.
- **Type sidecar** — `purs ide server` subprocess managed by the
  backend. Heavier than externs-file reads, but reusable for hover
  types, completion, and go-to-definition in later phases.
- **Editor framework** — CodeMirror 6. More client plumbing than
  lifting an existing Ace-based editor, but the inline-widget APIs
  are essential for the result gutter.
- **Backend process model** — one Playground backend process (HTTPurple,
  Node), which owns the compile workspace and shells out to `spago` /
  `purs` on demand. No separate compile-server sibling process.
- **Inline types in Phase 1** — yes. Since the `purs ide` sidecar is
  running from day one, the MVP shows the cell's inferred type in the
  gutter (rendered by Sigil) alongside the value.
- **Starter content** — a minimal `double x = x * 2` module and three
  cells that exercise it. Prelude-only, no library imports. Loads fast
  and demonstrates shared-scope liveness in the first keystroke.
- **Package set + compile service** — `runtime-workspace/` inside this
  repo is a modern-tooling spago workspace pinned to
  `packageSet: { registry: 73.3.0 }`. The Playground backend drives
  `purs` / `spago` against it directly. trypurescript is no longer a
  runtime dependency; the upstream repo is reference material only,
  and modernising it is a potential good-citizen PR (Stretch).
- **Repo layout** — `frontend/` + `server/` + `shared/` + `runtime-workspace/`
  at the root, matching Minard conventions for the first three. Root
  `Makefile` for orchestration.
- **Visibility** — public GitHub repo from day one, but unadvertised
  (not linked from the polyglot site, blog, Discord, etc.) until MVP
  ships. Rough commits are fine; they just don't get promoted.

## Open decisions

(None remaining. All pre-implementation decisions are locked above.
New questions will land here as they surface during M0–M6.)

## Task list / rough milestones

**M0 — scaffolding (half day)**

- [x] Initialise public (but unadvertised) git repo on GitHub.
- [x] `frontend/` (Halogen + CM6), `server/` (HTTPurple), `shared/`
      (codecs/types) skeletons at the root, matching Minard. Root
      `Makefile` orchestrates builds.
- [x] Register marginalia server entries for the frontend and backend
      processes once each has a known-good start command.
- [ ] Scaffold `runtime-workspace/`: modern `spago.yaml` pinned to
      `registry: 73.3.0`, a broad starter-dependency list, and a
      placeholder `src/Main.purs` (covered by M1's first task).

**M1 — compile round-trip (1–2 days)**

- [x] Runtime workspace: hard-coded `Main.purs` that prints
      `"hello from runtime-workspace"`; verify `spago bundle -p
      playground-runtime --platform browser` produces a runnable
      browser bundle.
- [x] Backend `/session/compile` that, for now, ignores the request
      body, rewrites a fixed `Main.purs` into `runtime-workspace/src/Main.purs`,
      shells out to `spago bundle`, and returns `{ js, warnings, errors }`.
- [x] Verify the workspace's full package set is reachable: a compile
      that `import`s e.g. `Data.Array` should succeed.
- [x] Frontend posts a fixed payload and renders the JS as text in a
      pane. No execution yet.

**M2 — synthesis from user input (2–3 days)**

- [x] Two CM6 editors on the frontend (module + cells).
- [x] Cell list data model + add/remove cell UI (single column for
      now, one cell per editor instance).
- [x] `Playground.Runtime` module shipped with every compile, defining
      `ToPlaygroundValue` with the `Effect a` / `Show a` instance chain
      and the `__playground_emit` foreign import. (Lives in
      `runtime-workspace/src/Playground/Runtime.purs`; imported by
      every synthesised Main.)
- [x] Backend synthesiser: user module → `Playground.User`, cells →
      top-level bindings, synthesised `main` calling
      `toPlaygroundValue` + `__playground_emit`.
- [x] End-to-end: edit, debounce, submit, compile, display JS.

**M3 — execution in a Worker (2 days)**

- [x] Web Worker that accepts compiled JS, executes `main`,
      collects emissions via a registered `__playground_emit` hook.
      (Spun up from a Blob URL — no static `/worker.js` file needed.)
- [x] Require-shim skipped — `spago bundle` produces a single
      self-contained IIFE, so no library JS needs to be pulled in at
      runtime.
- [x] Timeout + worker termination. (3s default; kills + unsubscribes
      on every new compile.)
- [x] Frontend renders result-per-cell in a gutter column (values
      only for now; types arrive in M4).

**M4 — type sidecar + Sigil rendering (2–3 days)**

- [x] Backend launches and supervises a `purs ide server` subprocess
      pointed at a workspace that includes the synthesised module.
      (Lazy-spawned on first compile; killed on backend SIGINT/SIGTERM.)
- [x] After each compile, backend queries `purs ide` for the type of
      each `cell_cN` binding. (Cell ids extracted by regex on the
      synthesised Main.purs we wrote; language-cst-parser remains an
      option for richer identifier handling later.)
- [x] `/session/compile` response extended with `{ types: [{ id, signature }] }`.
- [x] Frontend hands each cell's type string to purescript-sigil and
      renders it in the gutter beside the value.
- [x] Handle the "type not yet known" case gracefully — the frontend
      shows "—" and falls back to the Halogen text node if Sigil can't
      parse the string.

**M5 — error panel, compile-state display (1 day)**

- [x] Errors from `purs` (via the backend) surface in a dedicated
      bottom panel.
- [x] "Compiling…" indicator on the Compile button while a request is
      in flight.
- [x] Last-good values + types stay visible (faded via a
      `.is-compiling` class) while a new compile is pending.

**M6 — MVP polish (1 day)**

- [ ] Keyboard UX: add cell, remove cell, focus next/prev.
      (Deferred — CM6 + inter-cell focus wiring is bigger than MVP
      needs; the buttons do the job for now.)
- [x] Starter content — `Scratch` module with `double` and three cells
      demonstrating liveness + shared scope.
- [x] Deploy recipe — `make start` / `make stop` registered in
      marginalia; `make build` only touches the three workspace
      packages we maintain so stale scratch code can't wedge bootstrap.

**After MVP** — Phase 2 milestones (inline error attribution,
richer Sigil-rendered values, hover types) to be detailed after M6.

## References

- `/Users/afc/work/afc-work/GitHub/trypurescript/` — reference for
  package-set composition, JSON error format expectations, URL-encoded
  sharing. No longer a runtime dependency; see "Compile service — why
  not trypurescript" in Architecture.
- `/Users/afc/work/afc-work/purescript-hylograph-libs/purescript-sigil/`
  — type-signature renderer for Phase 2.
- Haskell for Mac: <http://haskellformac.com/> (product inspiration).
- Bret Victor, "Learnable Programming":
  <http://worrydream.com/LearnableProgramming/>.
- marginalia project id 158, slug `papa-whiskey-uniform-lima`.
