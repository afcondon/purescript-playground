import * as d3Force from "d3-force";

const SVG_NS = "http://www.w3.org/2000/svg";

// Active force simulations keyed by their container element, so we can
// stop the previous one before mounting a new render into the same slot.
const sims = new WeakMap();

function stopSim(el) {
  const s = sims.get(el);
  if (s) {
    s.stop();
    sims.delete(el);
  }
}

export const _renderInto = (el) => (rawJson) => () => {
  stopSim(el);

  if (!rawJson || rawJson.trim() === "") {
    el.innerHTML = "";
    return;
  }

  let v;
  try {
    v = JSON.parse(rawJson);
  } catch (_e) {
    el.innerHTML = "";
    return;
  }

  // Static SVG string (PVString starting with <svg or <?xml)
  if (typeof v === "string") {
    const trimmed = v.trimStart();
    if (trimmed.startsWith("<svg") || trimmed.startsWith("<?xml")) {
      el.innerHTML = v;
      return;
    }
    el.innerHTML = "";
    return;
  }

  // ForceRender: { $ctor: "ForceRender", args: [ { $record: { nodes, links, width, height } } ] }
  if (
    v &&
    v.$ctor === "ForceRender" &&
    Array.isArray(v.args) &&
    v.args[0] &&
    v.args[0].$record
  ) {
    renderForce(el, v.args[0].$record);
    return;
  }

  // Unrecognised shape — leave blank so the column stays honest about
  // which cells have a visual rendering vs. which don't.
  el.innerHTML = "";
};

export const _cleanup = (el) => () => {
  stopSim(el);
  el.innerHTML = "";
};

// Records nested inside a PVCtor come through wrapped in `$record`;
// constructor values come through as { $ctor, args: [...] }. Unwrap
// one level in either direction.
const unwrapRecord = (r) => (r && r.$record) ? r.$record : r;

// Translate one AtelierForceSpec constructor value into the d3-force
// call that realises it. Returns null for unknown constructors so the
// caller can skip without aborting the whole setup.
function applyForceSpec(sim, links, spec) {
  if (!spec || !spec.$ctor || !Array.isArray(spec.args) || !spec.args[0]) return;
  const cfg = unwrapRecord(spec.args[0]);
  const name = cfg.name;
  switch (spec.$ctor) {
    case "ManyBody":
      sim.force(name, d3Force.forceManyBody().strength(cfg.strength));
      return;
    case "Collide":
      sim.force(name, d3Force.forceCollide(cfg.radius).strength(cfg.strength));
      return;
    case "Link":
      sim.force(
        name,
        d3Force
          .forceLink(links)
          .id((d) => d.id)
          .distance(cfg.distance)
          .strength(cfg.strength),
      );
      return;
    case "Center":
      sim.force(name, d3Force.forceCenter(cfg.x, cfg.y));
      return;
    case "PositionX":
      sim.force(name, d3Force.forceX(cfg.x).strength(cfg.strength));
      return;
    case "PositionY":
      sim.force(name, d3Force.forceY(cfg.y).strength(cfg.strength));
      return;
    // Unknown constructor: silently skip. A newer Runtime.purs may
    // emit specs this frontend doesn't yet understand.
  }
}

function renderForce(container, spec) {
  const nodes = (spec.nodes || []).map((n) => ({ ...unwrapRecord(n) }));
  const links = (spec.links || []).map((l) => ({ ...unwrapRecord(l) }));
  const forces = spec.forces || [];
  const width = typeof spec.width === "number" ? spec.width : 400;
  const height = typeof spec.height === "number" ? spec.height : 400;

  const svg = document.createElementNS(SVG_NS, "svg");
  svg.setAttribute("viewBox", `0 0 ${width} ${height}`);
  svg.setAttribute("preserveAspectRatio", "xMidYMid meet");
  svg.setAttribute("class", "render-force-svg");

  const linkG = document.createElementNS(SVG_NS, "g");
  linkG.setAttribute("class", "render-force-links");
  svg.appendChild(linkG);
  const linkEls = links.map(() => {
    const line = document.createElementNS(SVG_NS, "line");
    line.setAttribute("stroke", "#bbb");
    line.setAttribute("stroke-width", "1");
    linkG.appendChild(line);
    return line;
  });

  const nodeG = document.createElementNS(SVG_NS, "g");
  nodeG.setAttribute("class", "render-force-nodes");
  svg.appendChild(nodeG);
  const nodeEls = nodes.map((n) => {
    const circle = document.createElementNS(SVG_NS, "circle");
    circle.setAttribute("r", n.radius ?? 3);
    circle.setAttribute("fill", n.fill || "#69b3a2");
    circle.setAttribute("fill-opacity", "0.8");
    circle.setAttribute("stroke", "#333");
    circle.setAttribute("stroke-width", "0.5");
    const title = document.createElementNS(SVG_NS, "title");
    title.textContent = n.label || n.id;
    circle.appendChild(title);
    nodeG.appendChild(circle);
    return circle;
  });

  container.innerHTML = "";
  container.appendChild(svg);

  const sim = d3Force.forceSimulation(nodes);
  for (const f of forces) applyForceSpec(sim, links, f);
  sim.on("tick", () => {
    for (let i = 0; i < nodeEls.length; i++) {
      nodeEls[i].setAttribute("cx", nodes[i].x);
      nodeEls[i].setAttribute("cy", nodes[i].y);
    }
    for (let i = 0; i < linkEls.length; i++) {
      const l = links[i];
      linkEls[i].setAttribute("x1", l.source.x ?? 0);
      linkEls[i].setAttribute("y1", l.source.y ?? 0);
      linkEls[i].setAttribute("x2", l.target.x ?? 0);
      linkEls[i].setAttribute("y2", l.target.y ?? 0);
    }
  });

  sims.set(container, sim);
}
