const base = process.env.SHADCN_UI_GALLERY_URL;
if (!base?.startsWith("https://")) throw new Error("SHADCN_UI_GALLERY_URL must be an HTTPS URL");
const expectedRevision = process.env.SHADCN_UI_EXPECTED_REVISION;
if (expectedRevision && !/^[0-9a-f]{40}$/.test(expectedRevision)) throw new Error("SHADCN_UI_EXPECTED_REVISION must be a full revision");

const get = async (path, type) => {
  const response = await fetch(new URL(path, base), {redirect: "error", cache: "no-store"});
  if (!response.ok) throw new Error(`${path} returned ${response.status}`);
  if (type && !response.headers.get("content-type")?.includes(type)) throw new Error(`${path} returned an invalid content type`);
  return response;
};
const release = await (await get("release.json", "application/json")).json();
const health = await (await get("health.json", "application/json")).json();
const routeManifest = await (await get("route-manifest.json", "application/json")).json();
if (release.identity.canonicalUrl !== base || health.canonicalUrl !== base ||
    routeManifest.release.buildRevision !== release.identity.buildRevision) throw new Error("deployed publication identity drift");
if (expectedRevision && release.identity.buildRevision !== expectedRevision) throw new Error("deployed revision does not match the workflow revision");
if (health.checks.routes.expected !== routeManifest.routes.length) throw new Error("deployed route inventory is incomplete");
await get("sitemap.xml", "application/xml");
await get(health.checks.search.file, "application/json");

const forms = ["field", "label", "help", "field-errors", "error-summary", "input", "textarea", "checkbox", "radio-group", "switch", "native-select", "enhanced-select", "slider", "progress", "meter"];
const milestoneC = ["components/disclosure/", "components/disclosure/accordion/", "components/navigation/", ...["navigation-menu", "header", "section-header"].map((slug) => `components/navigation/${slug}/`), "components/content-surfaces/", ...["scroll-area", "separator", "radio-panels"].map((slug) => `components/content-surfaces/${slug}/`), "examples/documentation/", "examples/settings/", "examples/application-shell/"];
const routes = ["", "components/foundation/", ...["button", "badge", "alert", "card", "avatar", "skeleton"].map((slug) => `components/foundation/${slug}/`), "components/forms/", ...forms.map((slug) => `components/forms/${slug}/`), ...milestoneC];
const assets = new Set();
const media = new Set();
routes.push("components/media/", ...["carousel", "cover-flow", "image-gallery"].map(slug => `components/media/${slug}/`));
routes.push("components/motion/", ...["marquee", "stagger", "scroll-indicator"].map(slug => `components/motion/${slug}/`));
routes.push(...["media-browser", "image-gallery", "motion-preferences", "motion-media-capabilities"].map(slug => `examples/${slug}/`));
routes.push(...["overlay-capabilities", "settings-confirmation", "responsive-drawers", "anchored-actions", "supplemental-help"].map(slug => `examples/${slug}/`));
routes.push("components/overlays/", ...["dialog", "alert-dialog", "drawer", "popover", "dropdown-actions"].map(slug => `components/overlays/${slug}/`), "components/interactive-surfaces/", ...["tooltip", "hover-card"].map(slug => `components/interactive-surfaces/${slug}/`));
for (const route of routes) {
  const response = await fetch(new URL(route, base), { redirect: "error" });
  if (!response.ok) throw new Error(`${route || "/"} returned ${response.status}`);
  const html = await response.text();
  if (!html.includes("ShadcnUI Gallery") || !html.includes("bd8f403")) throw new Error(`invalid gallery response: ${route}`);
  if (!html.includes("Component navigation") || !html.includes('data-shadcn-theme="light"')) throw new Error(`invalid shell: ${route}`);
  const canonical = html.match(/<link\s+rel="canonical"\s+href="([^"]+)"/);
  const expectedCanonical = new URL(route.replace(/\/$/, ""), base).href;
  if (canonical?.[1] !== expectedCanonical) throw new Error(`invalid canonical: ${route}`);
  for (const match of html.matchAll(/(?:href|src)="([^"]+\.(?:css|js))"/g)) assets.add(new URL(match[1], response.url).href);
  for (const match of html.matchAll(/(?:src|srcset)="([^"]*media\/[^"]*)"/g)) {
    for (const candidate of match[1].split(",")) media.add(new URL(candidate.trim().split(/\s+/)[0], response.url).href);
  }
}

if (assets.size !== 3) throw new Error(`expected three local fingerprinted assets, found ${assets.size}`);
for (const url of assets) {
  if (!url.startsWith(base)) throw new Error(`asset escaped canonical gallery origin: ${url}`);
  const response = await fetch(url, { redirect: "error" });
  if (!response.ok) throw new Error(`asset returned ${response.status}: ${url}`);
}
for (const check of health.checks.assets) {
  const response = await get(check.file, check.contentType);
  const bytes = Buffer.from(await response.arrayBuffer());
  const actual = (await import("node:crypto")).createHash("sha256").update(bytes).digest("hex");
  if (actual !== check.sha256) throw new Error(`deployed asset hash drift: ${check.file}`);
}
for (const url of media) {
  if (!url.startsWith(new URL("media/", base).href)) throw new Error(`media escaped canonical gallery: ${url}`);
  const response = await fetch(url, { redirect: "error" });
  if (url.endsWith("/intentionally-missing.svg")) {
    if (response.status !== 404) throw new Error("intentional missing image did not return 404");
  } else if (!response.ok || !response.headers.get("content-type")?.includes("image/svg+xml")) {
    throw new Error(`media returned an invalid response: ${url}`);
  }
}
const missing = await fetch(new URL("__phase6_unknown__", base), {redirect: "manual", cache: "no-store"});
if (missing.status !== 404 || (await missing.text()).includes("__phase6_unknown__")) throw new Error("invalid deployed 404 behavior");
console.log(`Canonical gallery smoke passed for ${release.identity.buildRevision}.`);
