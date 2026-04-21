export const _emit = (id) => (value) => () => {
  if (typeof globalThis.__playground_emit === 'function') {
    globalThis.__playground_emit(id, value);
  }
};

export const done = () => {
  if (typeof globalThis.__playground_done === 'function') {
    globalThis.__playground_done();
  }
};
