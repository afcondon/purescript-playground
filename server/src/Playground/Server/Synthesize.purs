module Playground.Server.Synthesize
  ( synthesize
  , Synthesised
  ) where

import Prelude

import Data.Array (filter, mapMaybe, null)
import Data.Foldable (foldMap)
import Data.Maybe (Maybe(..))
import Data.String (length) as Str
import Data.String as Str
import Data.String.Pattern (Pattern(..))

import Playground.Session
  ( Cell(..)
  , CompileRequest(..)
  , UserModule(..)
  )

-- | The two source files produced on each compile: the user's module
-- | (renamed to `Playground.User`) and the synthesised `Main.purs` that
-- | binds every cell and emits their rendered values.
type Synthesised = { userSource :: String, mainSource :: String }

synthesize :: CompileRequest -> Synthesised
synthesize (CompileRequest { "module": UserModule { source }, cells }) =
  { userSource: rewriteModuleHeader source
  , mainSource: buildMain cells
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
    exprCells = filter isExpr cells
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
      <> (if null exprCells then "  pure unit\n" else foldMap emitLine exprCells)
  where
  isExpr (Cell c) = c.kind == "expr"
  letSource (Cell c) = if c.kind == "let" then Just c.source else Nothing
