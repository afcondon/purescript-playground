module Playground.Server.Synthesize
  ( synthesize
  , Synthesised
  ) where

import Prelude

import Data.Array (filter, findIndex, length, mapMaybe, null) as Array
import Data.Array (mapMaybe)
import Data.Foldable (foldMap)
import Data.Maybe (Maybe(..), isJust)
import Data.String (length) as Str
import Data.String as Str
import Data.String.Pattern (Pattern(..))

import Playground.Session
  ( Cell(..)
  , CellRange(..)
  , CompileRequest(..)
  , UserModule(..)
  )

-- | The two source files produced on each compile, plus the per-cell
-- | line ranges in `Main.purs`. The frontend uses the line ranges to
-- | attribute compile errors back to the originating cell.
type Synthesised =
  { userSource :: String
  , mainSource :: String
  , cellLines :: Array CellRange
  }

synthesize :: CompileRequest -> Synthesised
synthesize (CompileRequest { "module": UserModule { source }, cells }) =
  let
    mainSource = buildMain cells
    cellLines = computeCellLines mainSource cells
  in
    { userSource: rewriteModuleHeader source
    , mainSource
    , cellLines
    }

-- | Replace the user's `module Foo where` (possibly with multi-line export
-- | list) with `module Playground.User where`. If no module header is
-- | found, prepend one. Good enough for MVP — doesn't try to parse inside
-- | strings or comments that happen to contain the literal "module" or
-- | "where".
rewriteModuleHeader :: String -> String
rewriteModuleHeader src =
  case Str.indexOf (Pattern "module") src of
    Nothing -> "module Playground.User where\n" <> src
    Just moduleIdx ->
      let afterModule = Str.drop moduleIdx src
      in case Str.indexOf (Pattern "where") afterModule of
        Nothing -> "module Playground.User where\n" <> src
        Just relWhereIdx ->
          let
            before = Str.take moduleIdx src
            endOfWhere = moduleIdx + relWhereIdx + Str.length "where"
            after = Str.drop endOfWhere src
          in before <> "module Playground.User where" <> after

-- | Build the synthesised Main.purs. Each `expr` cell becomes a top-level
-- | binding `cell_<id>` and contributes a line to `main`; each `let` cell
-- | is spliced in verbatim as a top-level binding (it must be of the form
-- | `name = expr`).
buildMain :: Array Cell -> String
buildMain cells =
  let
    exprCells = Array.filter isExpr cells
    letSources = mapMaybe letSource cells
    cellBinding (Cell c) = "cell_" <> c.id <> " = " <> c.source <> "\n"
    emitLine (Cell c) =
      "  emit \"" <> c.id <> "\" =<< toPlaygroundValue cell_" <> c.id <> "\n"
  in
    "module Main where\n\n"
      <> "import Prelude\n"
      <> "import Effect (Effect)\n"
      <> "import Playground.Runtime (class ToPlaygroundValue, emit, toPlaygroundValue)\n"
      <> "import Playground.User\n\n"
      <> "-- let-cells (spliced verbatim)\n"
      <> foldMap (\s -> s <> "\n") letSources
      <> "\n-- expr-cells (top-level bindings)\n"
      <> foldMap cellBinding exprCells
      <> "\nmain :: Effect Unit\n"
      <> "main = do\n"
      <> (if Array.null exprCells then "  pure unit\n" else foldMap emitLine exprCells)
  where
  isExpr (Cell c) = c.kind == "expr"
  letSource (Cell c) = if c.kind == "let" then Just c.source else Nothing

-- | For each expr cell, find the inclusive line range its
-- | `cell_<id> = …` binding occupies in the synthesised Main.purs.
-- | Robust against multi-line cell sources: we count newlines in the
-- | cell's source to determine endLine.
computeCellLines :: String -> Array Cell -> Array CellRange
computeCellLines source cells =
  let lines = Str.split (Pattern "\n") source
  in mapMaybe (findRange lines) cells
  where
  findRange lines (Cell c)
    | c.kind /= "expr" = Nothing
    | otherwise =
        let prefix = "cell_" <> c.id <> " = "
        in case Array.findIndex (lineStartsWith prefix) lines of
          Nothing -> Nothing
          Just idx ->
            let
              startLine = idx + 1
              -- A cell binding occupies (1 + newline-count-in-source) lines
              extraLines = newlineCount c.source
              endLine = startLine + extraLines
            in Just (CellRange { id: c.id, startLine, endLine })

  lineStartsWith p line = isJust (Str.stripPrefix (Pattern p) line)

  -- Number of newlines in a string: split-on-\n minus 1, clamped to 0.
  newlineCount s = max 0 (Array.length (Str.split (Pattern "\n") s) - 1)
