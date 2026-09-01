const base = process.env.SHADCN_UI_GALLERY_URL;
if (!base?.startsWith("https://")) throw new Error("SHADCN_UI_GALLERY_URL must be an HTTPS URL");

const expectedRevision = process.env.SHADCN_UI_EXPECTED_REVISION;
if (!/^[0-9a-f]{40}$/.test(expectedRevision ?? "")) {
  throw new Error("SHADCN_UI_EXPECTED_REVISION must be a full revision");
}

const get = async (path, type) => {
  const response = await fetch(new URL(path, base), {redirect: "error", cache: "no-store"});
  if (!response.ok) throw new Error(`${path} returned ${response.status}`);
  if (type && !response.headers.get("content-type")?.includes(type)) {
    throw new Error(`${path} returned an invalid content type`);
  }
  return response;
};

const health = await (await get("healthz", "application/json")).json();
if (health.status !== "ok") throw new Error("health status is not ok");
if (health.identity.buildRevision !== expectedRevision) throw new Error("deployed revision drift");
if (health.identity.canonicalUrl !== base) throw new Error("canonical origin drift");

const assets = new Set();

for (const path of [
  "",
  "components/foundation/button",
  "components/forms/error-summary",
  "components/disclosure/accordion",
  "components/overlays/dialog",
  "components/media/image-gallery",
  "components/motion/marquee",
  "examples/application-shell",
]) {
  const response = await get(path, "text/html");
  const html = await response.text();
  const canonical = new URL(path, base).href;
  if (!html.includes('aria-label="ShadcnUI home"')) {
    throw new Error(`invalid gallery response: ${path}`);
  }
  if (!html.includes(`rel="canonical" href="${canonical}"`)) {
    throw new Error(`invalid canonical response: ${path}`);
  }
  for (const match of html.matchAll(/(?:href|src)="(\/assets\/[^"]+)"/g)) {
    assets.add(match[1]);
  }
}

if (assets.size !== 4) throw new Error(`invalid local asset inventory: ${assets.size}`);
for (const asset of assets) await get(asset);

const missing = await fetch(new URL("__fly_unknown__", base), {redirect: "manual", cache: "no-store"});
if (missing.status !== 404 || (await missing.text()).includes("__fly_unknown__")) {
  throw new Error("invalid non-reflecting 404");
}

console.log(`Fly gallery smoke passed for ${expectedRevision}.`);
