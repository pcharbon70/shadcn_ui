const base = process.env.SHADCN_UI_GALLERY_URL;
if (!base?.startsWith("https://")) throw new Error("SHADCN_UI_GALLERY_URL must be an HTTPS URL");

const routes = ["", "components/foundation/", ...["button", "badge", "alert", "card", "avatar", "skeleton"].map((slug) => `components/foundation/${slug}/`)];
for (const route of routes) {
  const response = await fetch(new URL(route, base), { redirect: "error" });
  if (!response.ok) throw new Error(`${route || "/"} returned ${response.status}`);
  const html = await response.text();
  if (!html.includes("ShadcnUI Gallery") || !html.includes("bd8f403")) throw new Error(`invalid gallery response: ${route}`);
}
