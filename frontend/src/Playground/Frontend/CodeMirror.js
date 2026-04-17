import { EditorView, keymap, lineNumbers, drawSelection } from '@codemirror/view';
import { EditorState } from '@codemirror/state';
import { defaultKeymap, history, historyKeymap, indentWithTab } from '@codemirror/commands';
import { bracketMatching, indentOnInput, StreamLanguage } from '@codemirror/language';
import { haskell } from '@codemirror/legacy-modes/mode/haskell';

// Creates a CodeMirror 6 view mounted into `parent`. `onChange` fires
// every time the document is edited, with the full new document content.
// Returns the EditorView so callers can query/destroy it later.
export const _createEditor = (parent) => (initialDoc) => (onChange) => () => {
  const view = new EditorView({
    parent,
    state: EditorState.create({
      doc: initialDoc,
      extensions: [
        lineNumbers(),
        drawSelection(),
        history(),
        bracketMatching(),
        indentOnInput(),
        keymap.of([...defaultKeymap, ...historyKeymap, indentWithTab]),
        // Haskell's lexer is close enough for PureScript for now; a
        // dedicated PureScript grammar lands as a later upgrade.
        StreamLanguage.define(haskell),
        EditorView.updateListener.of((update) => {
          // onChange is an EffectFn1 — call once, no trailing thunk.
          if (update.docChanged) {
            onChange(update.state.doc.toString());
          }
        }),
        EditorView.theme({
          '&': { height: '100%' },
          '.cm-scroller': { fontFamily: 'var(--mono)', fontSize: '13px', lineHeight: '1.5' },
          '.cm-content': { padding: '6px 0' },
        }),
      ],
    }),
  });
  return view;
};

export const _getContent = (view) => () => view.state.doc.toString();

export const _setContent = (view) => (content) => () => {
  view.dispatch({
    changes: { from: 0, to: view.state.doc.length, insert: content },
  });
};

export const _destroy = (view) => () => view.destroy();
