import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join } from "node:path";

const root = new URL("../export/", import.meta.url);
const manifest = JSON.parse(await readFile(new URL("route-manifest.json", root), "utf8"));
if (manifest.schemaVersion !== 1) throw new Error("unsupported route manifest");
if (!/^search-index-[a-f0-9]{16}\.json$/.test(manifest.search.file) ||
    manifest.search.schemaVersion !== "1" || manifest.search.records !== 41) throw new Error("invalid search manifest");
const searchBytes = await readFile(new URL(manifest.search.file, root));
if (createHash("sha256").update(searchBytes).digest("hex") !== manifest.search.sha256) throw new Error("stale search document hash");
const search = JSON.parse(searchBytes);
if (search.schemaVersion !== "1" || search.records.length !== 41) throw new Error("invalid search document");
const searchKeys = ["category", "keywords", "name", "route", "summary", "url"];
if (new Set(search.records.map(record => record.url)).size !== search.records.length) throw new Error("duplicate search URL");
for (const record of search.records) {
  if (JSON.stringify(Object.keys(record).sort()) !== JSON.stringify(searchKeys) ||
      record.url !== `/shadcn_ui${record.route}` ||
      !record.route.startsWith("/components/") ||
      /<%|<script|javascript:|Elixir\./i.test(JSON.stringify(record))) throw new Error("unsafe search record");
}
const sitemap = await readFile(new URL("sitemap.xml", root), "utf8");
const fixtures = JSON.parse(await readFile(new URL("../priv/media/fixtures.json", import.meta.url), "utf8"));
const expectedMedia = fixtures.entries.map(entry => entry.file).sort();
if (JSON.stringify(Object.keys(manifest.media).sort()) !== JSON.stringify(expectedMedia) ||
    JSON.stringify((await readdir(new URL("media/", root))).sort()) !== JSON.stringify(expectedMedia)) throw new Error("unlisted media inventory");
for (const entry of fixtures.entries) {
  const content = await readFile(new URL("media/" + entry.file, root));
  if (content.length !== entry.bytes || createHash("sha256").update(content).digest("hex") !== entry.sha256 ||
      manifest.media[entry.file].sha256 !== entry.sha256 || manifest.media[entry.file].mime !== entry.mime) throw new Error("stale media fixture: " + entry.file);
}
if (!sitemap.includes("<loc>https://leco-industries-inc.github.io/shadcn_ui/examples/motion-media-capabilities</loc>")) throw new Error("missing motion/media route");
const overlayRoutes = [
  "/components/overlays", "/components/interactive-surfaces",
  ...["dialog", "alert-dialog", "drawer", "popover", "dropdown-actions"].map(name => `/components/overlays/${name}`),
  ...["tooltip", "hover-card"].map(name => `/components/interactive-surfaces/${name}`),
  ...["overlay-capabilities", "settings-confirmation", "responsive-drawers", "anchored-actions", "supplemental-help"].map(name => `/examples/${name}`)
];
const galleryRoutes = ["/components/media/image-gallery", "/examples/image-gallery"];
const mediaRoutes = ["/components/media", "/components/media/carousel", "/components/media/cover-flow", "/examples/media-browser", ...galleryRoutes];
const motionRoutes = ["/components/motion", "/components/motion/marquee", "/components/motion/stagger", "/components/motion/scroll-indicator", "/examples/motion-preferences"];
for (const route of [...mediaRoutes, ...motionRoutes]) {
  if (!sitemap.includes(`<loc>https://leco-industries-inc.github.io/shadcn_ui${route}</loc>`)) throw new Error(`missing media route: ${route}`);
  for (const theme of ["light", "dark"]) for (const motion of ["system", "reduce", "unexpected"]) {
    if (!manifest.routes.some(e=>e.request===`${route}?theme=${theme}&motion=${motion}` && e.status===200)) throw new Error("missing media preference variant");
  }
}
for (const route of overlayRoutes) {
  if (!sitemap.includes(`<loc>https://leco-industries-inc.github.io/shadcn_ui${route}</loc>`)) throw new Error(`missing sitemap route: ${route}`);
  for (const suffix of ["", "?theme=light", "?theme=dark", "?theme=minty"]) {
    if (!manifest.routes.some(entry => entry.request === route + suffix && entry.status === 200)) throw new Error(`missing route variant: ${route}${suffix}`);
  }
}
if (new Set(manifest.routes.map(entry => entry.request)).size !== manifest.routes.length) throw new Error("duplicate export requests");

for (const entry of manifest.routes) {
  const content = await readFile(new URL(entry.file, root));
  const hash = createHash("sha256").update(content).digest("hex");
  if (hash !== entry.sha256) throw new Error(`stale route hash: ${entry.file}`);
  const html = content.toString("utf8");
  // Preference links must resolve to concrete static files, not ignored queries.
  for (const match of html.matchAll(/(?:href|data-gallery-light-href|data-gallery-dark-href)="([^"]*_preferences[^"]*)"/g)) {
    const target = new URL(match[1], new URL(entry.file, root));
    if (!target.href.startsWith(root.href)) throw new Error("escaping preference path");
    await readFile(target);
  }
  for (const match of html.matchAll(/(?:src|srcset)="([^"]*media\/[^"]*)"/g)) {
    for (const candidate of match[1].split(",")) {
      const target = new URL(candidate.trim().split(/\s+/)[0], new URL(entry.file, root));
      if (!target.href.startsWith(new URL("media/", root).href)) throw new Error("escaping media path");
      if (fixtures.failures.some(failure => target.pathname.endsWith(failure.src))) continue;
      if (!expectedMedia.includes(target.pathname.split("/").pop())) throw new Error("unknown media reference");
      await readFile(target);
    }
  }
  if (!html.includes("<main") || (!html.includes("Component navigation") && !html.includes("data-demo-form"))) throw new Error(`missing landmarks: ${entry.file}`);
  const runtime = html.replace(/<a\b[^>]*>/gi, "").replace(/<link\s+rel="canonical"\s+href="https:\/\/leco-industries-inc\.github\.io\/shadcn_ui[^"]*"\s*\/?\s*>/gi, "");
  if (/(?:src|href|srcset)="(?:https?:)?\/\//i.test(runtime)) throw new Error(`remote runtime URL: ${entry.file}`);
  const route = entry.request.split("?")[0];
  if (motionRoutes.includes(route)) {
    const ids = [...html.matchAll(/\sid="([^"]+)"/g)].map(m=>m[1]);
    if (new Set(ids).size !== ids.length) throw new Error("duplicate motion identity");
    if (route !== "/components/motion" && !html.includes("data-shadcn-ui-motion")) throw new Error("missing real motion example");
    if (route.startsWith("/components/motion/") && !html.includes("HEEX source")) throw new Error("missing motion reference");
    for (const input of html.matchAll(/<input[^>]*type="checkbox"[^>]*>/g)) {
      if (/\b(?:checked|name)=/.test(input[0])) throw new Error("motion preview autostarts or owns a form value");
    }
    for (const duplicate of html.matchAll(/<div[^>]*data-shadcn-ui-motion-part="clone"[^>]*>(.*?)<\/div>/gs)) {
      if (!/hidden inert aria-hidden="true"/.test(duplicate[0]) || /\bid=|<a\b|<input|<button|tabindex/.test(duplicate[1])) throw new Error("unsafe motion duplicate");
    }
  }
  if (mediaRoutes.includes(route)) {
    const ids=[...html.matchAll(/\sid="([^"]+)"/g)].map(m=>m[1]);
    if (new Set(ids).size!==ids.length) throw new Error("duplicate media identity");
    if (route!=="/components/media" && !galleryRoutes.includes(route) && !html.includes("data-shadcn-ui-carousel-scroll")) throw new Error("missing actual Carousel");
    if (galleryRoutes.includes(route)) {
      if (!html.includes("data-shadcn-ui-image-gallery") || !html.includes("data-shadcn-ui-gallery-destination")) throw new Error("missing real Image Gallery");
      for (const match of html.matchAll(/commandfor="([^"]+)"/g)) if (!ids.includes(match[1])) throw new Error("broken gallery Dialog relationship");
      if (/<dialog[^>]*\sopen(?:\s|>)/.test(html)) throw new Error("gallery autostarts a modal");
    }
    for (const fragment of html.matchAll(/href="#(shadcn-ui-media-[^"]+)"/g)) if (!ids.includes(fragment[1])) throw new Error("broken Carousel index");
  }
  if (overlayRoutes.includes(route)) {
    if (!html.includes(`rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui${route}"`)) throw new Error(`missing canonical URL: ${entry.file}`);
    const ids = [...html.matchAll(/\sid="([^"]+)"/g)].map(match => match[1]);
    if (new Set(ids).size !== ids.length) throw new Error(`duplicate identity: ${entry.file}`);
    if (route.startsWith("/components/") && route.split("/").length === 4 && (!html.includes("HEEX source") || !html.includes('id="ordinary-alternative"'))) throw new Error(`missing reference: ${entry.file}`);
    if (/role="(?:menu|menuitem|menubar)"|interestfor=|popover="hint"/.test(html)) throw new Error(`unsupported semantics: ${entry.file}`);
  }
  if (entry.status === 404 && /rel="canonical"|__gallery-not-found__/.test(html)) throw new Error("404 reflects input or claims a canonical route");
}

const assets = await readdir(new URL("assets/", root));
if (assets.length !== 3 || Object.keys(manifest.assets).length !== 3) throw new Error("export must contain exactly three selected assets");
for (const asset of assets) {
  const content = await readFile(new URL(`assets/${asset}`, root));
  const hash = createHash("sha256").update(content).digest("hex");
  if (manifest.assets[asset] !== hash) throw new Error(`stale asset hash: ${asset}`);
}
const rootFiles = (await readdir(root)).filter(file => file.startsWith("search-index-"));
if (rootFiles.length !== 1 || rootFiles[0] !== manifest.search.file) throw new Error("unexpected search document inventory");
