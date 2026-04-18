export const _emit = (id) => (value) => () => {
  if (typeof globalThis.__playground_emit === 'function') {
    globalThis.__playground_emit(id, value);
  }
};
