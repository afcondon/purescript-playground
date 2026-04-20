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

function renderForce(container, spec) {
  // Records nested inside a PVCtor come through still wrapped in their
  // `$record` envelope — unwrap each node/link before use. Also clone so
  // d3-force can mutate (adds x/y/vx/vy) without touching the
  // PureScript-provided records.
  const unwrap = (r) => (r && r.$record) ? r.$record : r;
  const nodes = (spec.nodes || []).map((n) => ({ ...unwrap(n) }));
  const links = (spec.links || []).map((l) => ({ ...unwrap(l) }));
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

  const sim = d3Force
    .forceSimulation(nodes)
    .force("charge", d3Force.forceManyBody().strength(-30))
    .force("link", d3Force.forceLink(links).id((d) => d.id).distance(40))
    .force("center", d3Force.forceCenter(width / 2, height / 2))
    .force("collide", d3Force.forceCollide((d) => (d.radius ?? 3) + 1))
    .on("tick", () => {
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
