module Playground.Frontend.CodeMirror
  ( EditorView
  , createEditor
  , getContent
  , setContent
  , destroy
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Web.DOM (Element)

foreign import data EditorView :: Type

foreign import _createEditor
  :: Element -> String -> EffectFn1 String Unit -> Effect EditorView

foreign import _getContent :: EditorView -> Effect String

foreign import _setContent :: EditorView -> String -> Effect Unit

foreign import _destroy :: EditorView -> Effect Unit

createEditor
  :: Element
  -> String
  -> (String -> Effect Unit)
  -> Effect EditorView
createEditor el initialDoc onChange =
  _createEditor el initialDoc (mkEffectFn1 onChange)

getContent :: EditorView -> Effect String
getContent = _getContent

setContent :: EditorView -> String -> Effect Unit
setContent = _setContent

destroy :: EditorView -> Effect Unit
destroy = _destroy
