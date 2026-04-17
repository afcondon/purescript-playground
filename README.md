# PureScript Playground

A browser-based PureScript scratchpad modelled on Manuel Chakravarty's
*Haskell for Mac*: a user module on the left, a column of playground
cells in the middle, and a gutter showing the inferred type and rendered
value for each cell, all updating live as you type.

See [`PLAN.md`](./PLAN.md) for the full design and milestones.

Status: Phase 1 scaffolding (M0).

## Prereqs

- `purs` and `spago` on your `PATH` (PureScript tooling).
- Node 18+.
- A running local copy of
  [trypurescript](https://github.com/purescript/trypurescript) — the
  Playground backend proxies to its compile server. The expected
  location is `../../GitHub/trypurescript` relative to this repo.
  Start it via the marginalia-registered command.

## Running locally

```
make bootstrap   # one-time build of frontend + backend
make start       # start the Playground backend (3050) and frontend (3051)
make stop        # stop both
```

The Playground backend depends on the trypurescript compile server
running at `http://localhost:8081`. Start that separately via its own
marginalia-registered start command.

## Layout

```
frontend/   Halogen + CodeMirror 6 + Sigil
server/     HTTPurple backend (proxies trypurescript, manages purs ide)
shared/     Request/response codecs used by both sides
spago.yaml  Workspace root (pins registry package set)
Makefile    Orchestration
```
