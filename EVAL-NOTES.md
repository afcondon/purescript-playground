# Claude-pair evaluation — design ideas

Running log of design ideas surfacing while a second Claude drives
Atelier over the HTTP API. Kept separate from PLAN.md because these
are raw observations: some may contradict each other, some may be
abandoned after reflection. Review all at the end of the evaluation,
fold the surviving ones into PLAN.md.

(Originally captured while the tool was still called "PureScript
Playground." Renamed to Atelier 2026-04-18.)

**Primary artefact:** [CLAUDE-PAIR-EVAL-2026-04-18.md](./CLAUDE-PAIR-EVAL-2026-04-18.md)
— the evaluating Claude's write-up. This file here captures the
*live-observed* design ideas (raised by the human watching the browser
while the eval ran); the artefact file captures the *practitioner-POV*
ideas (raised by the Claude actually using the API).

## 2026-04-18

### Scratch mode vs Project mode

**Observation trigger:** first live Claude-pair session, with other
Claude working on a small self-contained data-viz project (world map
bubbles, slug `echo-foxtrot-zulu-lima`).

**Idea:** distinguish two top-level modes:

- **Scratch mode** (what we have today): single synthesized module +
  cells, starter dropdown, runtime is freely switchable across
  browser/node/purerl.
- **Project mode:** bind to a real PureScript project on disk.
  - "Pick and stick" a backend — runtime is locked by the project's
    spago workspace (you don't get to toggle browser/node/purerl
    against a project that only builds one target).
  - The **starter dropdown is replaced by a module selector** — either
    a list of the project's existing modules or a file picker rooted
    at the project's src/.
  - Presumably the Module column shows the selected project module
    (read from disk) and the Cells column lets you experiment against
    whatever scope that module exports.

**Relationship to existing deferred work:** overlaps with
"project-context binding (Phase 1)" in the compacted plan, which was
scoped to package-set binding only. This proposal goes further — not
just "use the project's dependencies" but "navigate the project's
modules as the primary surface."

**Open questions (to resolve on review):**

- In Project mode, is the Cells column cells-against-a-module, or
  does it become something closer to a REPL transcript?
- Does Project mode allow *editing* project modules and writing them
  back, or is it read-only + scratch-cells?
- How does the Claude-pair API distinguish project-mode writes from
  scratch-mode writes? (Different endpoints? Or a mode field on the
  session?)

### Session mutex needs bracket semantics + IDE-query timeout

**Observation trigger:** backend POSTs hung indefinitely mid-session.
GET remained fast (doesn't take the lock). Root cause: the shared
`purs ide server` subprocess got into a bad state where new `purs ide
client` queries would connect but never get a response. The
compile-time type-query step in `Ide.js` has no timeout, so
`compileNow` in `Session.withUpdate` never returned — `AVar.put`
never fired — mutex held forever — all subsequent writes queued
behind it.

Unwedged manually by killing the stuck ide server + client, which
the `on('exit')` handler in `Ide.js` correctly respawns. Session
state was preserved because we didn't restart the backend.

**Real fixes (deferred until after eval):**

1. `Ide.js`'s `clientCall` needs a timeout (e.g. 5s). On timeout,
   kill the subprocess and reject — the caller already has a
   try/catch that returns `[]`, so the compile completes with no
   inline types rather than wedging the whole session.
2. `Session.withUpdate` needs bracket/finally semantics so the
   `AVar.put` releases the lock even when `compileNow` throws or
   hangs indefinitely.
3. Possibly: health-check or ping the ide server periodically and
   respawn it proactively on unresponsiveness, rather than relying
   on individual query timeouts to surface the problem.

These are reliability fixes, not feature work; safe to land
whenever.

### Landed: records + nullary ADTs serialise structurally

Wire format now includes `{"$record":{...}}` for records (via
`RowToList` — automatic for any record type) and `{"$ctor":name,"args":[]}`
for nullary constructors (via a Show-output heuristic — bare
upper-case identifiers get treated as nullary ctors).

**Still `$raw` for now:** multi-arg user ADTs that don't have a
hand-written `ToPlaygroundValue` instance. `Maybe`, `Either`, and
`Tuple` are hand-written and structured. For other user ADTs, a
`Generic`-based fallback would complete the picture — but PureScript
instance chains don't fall through on constraint failure, so we'd
need either (a) a Generic instance ordered before Show that
constraint-fails for non-Generic types (requires verifying
instance-chain semantics empirically), or (b) an explicit escape
hatch like `fromGeneric` that users wire into a bespoke
`ToPlaygroundValue` instance. Worth revisiting if this shows up as
a real friction in evaluation.
