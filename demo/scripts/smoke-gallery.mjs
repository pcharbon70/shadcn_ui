const base = process.env.SHADCN_UI_GALLERY_URL;
if (!base?.startsWith("https://")) throw new Error("SHADCN_UI_GALLERY_URL must be an HTTPS URL");

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
for (const url of media) {
  if (!url.startsWith(new URL("media/", base).href)) throw new Error(`media escaped canonical gallery: ${url}`);
  const response = await fetch(url, { redirect: "error" });
  if (url.endsWith("/intentionally-missing.svg")) {
    if (response.status !== 404) throw new Error("intentional missing image did not return 404");
  } else if (!response.ok || !response.headers.get("content-type")?.includes("image/svg+xml")) {
    throw new Error(`media returned an invalid response: ${url}`);
  }
}
