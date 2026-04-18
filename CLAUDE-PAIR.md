# Claude-pair API

*An experimental surface so a second Claude session can drive
Atelier alongside the human.*

This document is the brief another Claude should read when dropped
into a project where Atelier is running. It describes what Atelier
is, what it can do for you, and how to interact with it.

## What this is for

Atelier is a typed PureScript scratchpad framed as **a REPL for
agents with a window for humans**. Three-column browser UI (module
editor | cells | values+types gutter) backed by a local HTTP server
that drives the PureScript toolchain. The human's browser is a
transparent observation pane; you, the agent, are the primary
driver via HTTP. Both clients *can* write, but the expectation is
that you do most of the authoring and the human observes, steers,
vetoes — or sketches pseudo-signatures and intent that you realise.
Auto-compile reflects your changes live in their window.

Your value proposition: you can propose typed sketches, probe
behaviours, and answer questions with live witnesses instead of
text — and the human sees everything happen in a surface they're
already looking at.

(The codebase is still called `purescript-playground` on disk and
the PureScript namespace is `Playground.*` — those are historical;
the product is "Atelier.")

## Running assumptions

- Backend at `http://localhost:3050`, frontend at
  `http://localhost:3051`. The human's browser points at the
  frontend; you talk HTTP to the backend.
- Three runtime adapters are available (browser Worker, Node child,
  Purerl BEAM). The session carries a `runtime` field you should
  respect when proposing code.
- The Playground auto-compiles ~400ms after any edit. Every change
  you make via the API triggers a recompile; you get types, values,
  and errors back in the response.
- Session state is not persisted across server restarts. This is a
  workspace, not a database.

## Workflows you should reach for

1. **"Sketch an implementation."** Use `POST /session/module` to
   define a function; `POST /session/cells` to add probes that
   exercise it; read `/session` on the next turn to see types +
   results. Iterate without round-tripping through the human's
   attention.

2. **"What's the type of X?"** Use `POST /ide/type` with a name —
   faster than reasoning about the code, authoritative.

3. **"Find a function with this signature."** Use `POST /ide/search`
   with a type signature string — `purs ide` has the lookup; don't
   guess names.

4. **"Observe what the human is trying."** `GET /session` before
   answering a question. Cells they've added, errors they're hitting
   — all right there.

5. **"Propose a data model."** Write `data` decls via
   `POST /session/module`, add cells that construct values, read
   back the inferred types. The types make the model concrete.

6. **"Port a snippet."** Write it directly into the module editor.
   Iterate on compile errors without bothering the human. Hand off
   once it builds.

7. **"Explain a library function."** Add a cell with a canonical
   example. The human sees it evaluate. Beats a prose explanation.

## API

All endpoints serve JSON (`Content-Type: application/json`). CORS
is `*`. There is no auth — this is a local-only tool for now.

### Read

`GET /session` — current session snapshot. Returns:

```json
{
  "runtime": "browser" | "node" | "purerl",
  "module": { "source": "module Scratch where\n..." },
  "cells": [ { "id": "c1", "kind": "expr", "source": "..." }, ... ],
  "types":  [ { "id": "c1", "signature": "Int" }, ... ],
  "cellLines": [ { "id": "c1", "startLine": 18, "endLine": 18 }, ... ],
  "errors":   [ { "code": "...", "filename": "...", "position": {...}, "message": "..." }, ... ],
  "warnings": [ ... ],
  "js":     null | "<bundled JS>",
  "emits":  [ { "id": "c1", "value": "<JSON-encoded PlaygroundValue>" }, ... ],
  "runtimeLabel": "Browser (Web Worker)" | ...
}
```

Note: `GET /session` returns the last compiled state. It does NOT
force a recompile. To force a recompile, use `POST /session/compile`.

### Emit wire format

Each entry in `emits` is `{ id, value }` where `value` is a JSON **string** containing an encoded `PlaygroundValue`. The envelope is always a primitive, an array, or one of these tagged objects:

```
null
true/false
42 / 3.14
"hello"
[ <value>, ... ]
{ "$ctor": "Just",   "args": [ <value> ] }   // structured constructor
{ "$ctor": "Africa", "args": [] }            // nullary constructor
{ "$record": { "field1": <value>, ... } }    // record
{ "$raw":   "SomeShowOutput" }               // fallback — couldn't decompose
```

What gets what:

- **Scalars** (Int, Number, Boolean, String, Char, Unit) → primitive JSON.
- **Array, Maybe, Either, Tuple** → `PVArray` / `PVCtor`. These are hand-written instances.
- **Records** → `{ "$record": { ... } }`. Automatic via `RowToList` — no user work needed.
- **Nullary constructors** (e.g. `Africa`, `LT`, `None`) → `{ "$ctor": name, "args": [] }`. The runtime inspects the Show output; if it's a bare capitalised identifier it treats it as a nullary ctor.
- **Multi-arg user ADTs** without a hand-written `ToPlaygroundValue` instance → `{ "$raw": "..." }` (surface-syntax string). This is the one "still dumb" case — if you want structure, write or derive the instance. (A `Generic`-based fallback is planned.)

So an `emits` entry for a cell returning `Array { avgDensity :: Number, name :: String }` comes through as a parseable JSON tree you can walk field-by-field. Cell-composes-with-cell works because the runtime values do, and now the JSON surface agrees.

`POST /ide/type` — body `{ "query": "map" }` → `{ "hits": [ { "identifier", "moduleName", "typeSignature" }, ... ] }`. Useful for "what's the type of map?"

`POST /ide/complete` — same shape; returns prefix-completion candidates.

`POST /ide/search` — NEW. Body `{ "query": "Array a -> Maybe a" }` → `{ "hits": [...] }`. Finds functions by (approximate) type signature.

### Write — session shape

Every write triggers a recompile. The response body is the full new session snapshot (same shape as `GET /session`), so you can observe the outcome in one round-trip.

`POST /session/module` — replace the module source entirely. Body:
```json
{ "source": "module Scratch where\nimport Prelude\n\nfoo :: Int\nfoo = 42\n" }
```

`POST /session/cells` — append a cell. Body:
```json
{ "source": "foo + 1", "kind": "expr" }
```
Returns the new session including the added cell's id.

`PATCH /session/cells/:id` — edit a cell. Body: partial record, e.g.:
```json
{ "source": "foo * 2" }
{ "kind": "let" }
{ "source": "xs = [1,2,3]", "kind": "let" }
```

`DELETE /session/cells/:id` — remove a cell.

`POST /session/runtime` — switch adapter. Body `{ "runtime": "node" }`.

`POST /session/compile` — force a recompile with the current state. Useful after a runtime switch or if you just want fresh types.

### Write — dry-run / preview

Every write endpoint accepts a `?preview=true` query parameter. With preview, the server evaluates the write against the current session and returns what the compile result would be, but **does not apply** the change. Use this when you want to validate a sketch before disturbing the human's editor.

### Push — live updates to the UI

`GET /session/events` — Server-Sent Events stream. The frontend subscribes on mount; any state change (from the human OR from you) emits a `session-updated` event whose data is the new snapshot.

This means: when you write via the API, the human sees your edit appear in the browser ~immediately. That's the core of the pair-programming vibe.

## Etiquette

- **Don't thrash the module editor while the human is typing there.** If you're about to make a large edit, consider `?preview=true` first, or tell the human what you're about to do.
- **Prefer adding cells over editing the module.** Cells are cheap experiments; the module is their codebase-in-miniature.
- **If the human has set a runtime (especially Purerl), stay in its package set.** Don't add an `import Effect.Aff` to a Purerl module — it won't compile.
- **Errors are signal, not failure.** Your write endpoint can produce a response with errors; the human sees them on the squiggle line. If your proposal fails to compile, read the error and iterate, don't just post again.

## Caveats this document won't catch

- The Playground hasn't been run against a large real project yet. Package-set binding is designed but not yet shipped. Full-project binding (cells importing user modules) is further out.
- `purs ide` is a subprocess of the backend; the first type query after backend boot has a ~2s warm-up. Subsequent queries are ~50ms.
- The `js` field in a session snapshot is large (kilobytes) for a non-trivial compile. If you're round-tripping state a lot, consider a narrower GET endpoint.

## The evaluation the human and I are trying to run

A fresh Claude session should be given a PureScript project and this document, and asked to do real work — read the human's intent, propose sketches, verify types, hand off to them. We want to know:

- Which of the 7 workflows above actually helped? Which didn't?
- What felt natural? What felt clunky?
- What couldn't you do that you wanted to?
- What would you add to this API after a session?

Report back to the human. That's the feedback loop.
