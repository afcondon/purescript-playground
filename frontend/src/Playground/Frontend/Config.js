// Resolve the backend URL from the current page's origin so the same
// bundle works whether it's loaded from http://localhost:3051 or from
// a Tailscale hostname (phone/other device on the tailnet) or a
// production hostname later on. Backend port is still :3050 for now.
export const backendUrl =
  typeof window !== 'undefined' && window.location && window.location.hostname
    ? `http://${window.location.hostname}:3050`
    : 'http://localhost:3050';

export const nowMs = () => Date.now();
