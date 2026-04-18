import { EditorView, keymap, lineNumbers, drawSelection, hoverTooltip } from '@codemirror/view';
import { EditorState } from '@codemirror/state';
import { defaultKeymap, history, historyKeymap, indentWithTab } from '@codemirror/commands';
import { bracketMatching, indentOnInput, StreamLanguage } from '@codemirror/language';
import { haskell } from '@codemirror/legacy-modes/mode/haskell';

// Address of the backend's /ide/type endpoint. Hard-coded for MVP;
// centralise when we introduce a runtime config surface.
const IDE_TYPE_URL = 'http://localhost:3050/ide/type';

// Characters that are part of a PureScript identifier (word or operator).
// We stay conservative: only plain word chars — operator tooltips can
// come later once the grammar we're using disambiguates them reliably.
function isWordChar(ch) {
  return /[A-Za-z0-9_']/.test(ch);
}

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

// CM6 hover-tooltip extension. Extracts the word at the hover point,
// POSTs to /ide/type, shows the first hit's identifier :: type. Prefers
// a Main or Playground.User origin so local bindings win over library
// shadowing.
const typeHover = hoverTooltip(async (view, pos, side) => {
  const line = view.state.doc.lineAt(pos);
  const text = line.text;
  let start = pos;
  let end = pos;
  while (start > line.from && isWordChar(text[start - line.from - 1])) start--;
  while (end < line.to && isWordChar(text[end - line.from])) end++;
  if (start === end && side < 0) return null;
  const word = text.slice(start - line.from, end - line.from);
  if (!word || !isWordChar(word[0])) return null;

  let hits = [];
  try {
    const resp = await fetch(IDE_TYPE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query: word }),
    });
    const json = await resp.json();
    hits = json.hits || [];
  } catch (_) {
    return null;
  }
  if (hits.length === 0) return null;

  // Prefer local scopes.
  const hit =
    hits.find((h) => h.moduleName === 'Main' || h.moduleName === 'Playground.User') ||
    hits[0];

  return {
    pos: start,
    end,
    above: true,
    create() {
      const dom = document.createElement('div');
      dom.className = 'cm-tooltip-type';
      dom.innerHTML =
        '<div class="cm-tooltip-sig">' +
          '<span class="cm-tooltip-name">' + escapeHtml(hit.identifier) + '</span>' +
          ' <span class="cm-tooltip-dcolon">::</span> ' +
          '<span class="cm-tooltip-ty">' + escapeHtml(hit.typeSignature) + '</span>' +
        '</div>' +
        (hit.moduleName
          ? '<div class="cm-tooltip-module">' + escapeHtml(hit.moduleName) + '</div>'
          : '');
      return { dom };
    },
  };
});

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
        typeHover,
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
