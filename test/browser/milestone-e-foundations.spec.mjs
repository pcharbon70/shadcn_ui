import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
import { serveMotionMediaExport } from "./support/static-motion-media.mjs";
// covers: shadcn_ui.motion_media_contract.motion_preference
// covers: shadcn_ui.motion_media_contract.css_exceptions
// covers: shadcn_ui.motion_media_gallery.motion_inspection
// covers: shadcn_ui.motion_media_gallery.capability_evidence
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
const axe = readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url), "utf8");
test("actual static subpath preferences and media work without scripts or remote loads", async ({ browser }, testInfo) => {
  const server = await serveMotionMediaExport();
  const context = await browser.newContext({ javaScriptEnabled: false, viewport: { width: 390, height: 844 } });
  try {
    const page = await context.newPage(), remote = [];
    page.on("request", request => { if (new URL(request.url()).hostname !== "127.0.0.1") remote.push(request.url()); });
    await page.goto(server.url);
    await page.getByRole("link", { name: "Reduce motion", exact: true }).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
    expect(page.url()).toContain("/_preferences/light/reduce/");
    await page.getByRole("link", { name: "Use dark theme" }).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
    for (const img of await page.locator(".gallery-media-fixtures img").all()) {
      await img.scrollIntoViewIfNeeded();
      await expect.poll(() => img.evaluate(e => e.complete && e.naturalWidth > 0)).toBe(true);
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await page.locator("h1").scrollIntoViewIfNeeded();
    await page.screenshot({ path: testInfo.outputPath("capabilities.png") });
    expect(remote).toEqual([]);
  } finally { await context.close(); await server.close(); }
});
const probe = (scope = "system", own = "system") => `<!doctype html><html lang="en"><title>Suppression contract</title><style>${css}</style><style>
  @keyframes test-only-travel { from { transform:translateX(10px); } to { transform:translateX(20px); } }
  .witness { animation:test-only-travel 2s linear; opacity:0.4; }
</style><body data-shadcn-ui><main data-shadcn-motion="${scope}">
  <h1>Foundation fixture, not a component</h1>
  <section data-shadcn-ui-motion="${own}"><div data-shadcn-ui-motion="system">
    <button class="witness" data-shadcn-ui-motion-part>Canonical content</button>
    <span data-shadcn-ui-motion-part="clone" hidden inert aria-hidden="true">Duplicate</span>
  </div></section><p class="witness" id="unrelated">Caller animation</p>
</main></body></html>`;
for (const [scope, own] of [["reduce", "system"], ["system", "none"]]) {
  test("nested suppression cannot re-enable " + scope + "/" + own, async ({ page }) => {
    await page.setContent(probe(scope, own));
    const content = page.getByRole("button");
    await expect(content).toHaveCSS("animation-name", "none");
    // The pinned CSS optimizer may serialize "none" as an identity transform.
    expect(await content.evaluate(e => {
      const value = getComputedStyle(e).transform;
      return value === "none" || new DOMMatrixReadOnly(value).isIdentity;
    })).toBe(true);
    await expect(content).toHaveCSS("opacity", "1");
    await expect(page.locator("#unrelated")).toHaveCSS("animation-name", "test-only-travel");
    await content.focus(); await expect(content).toBeFocused();
    await expect(content).toHaveCSS("outline-style", "solid");
    await expect(page.locator('[data-shadcn-ui-motion-part="clone"]')).toBeHidden();
  });
}
test("system preference changes stop motion and forced colors retain focus", async ({ page }) => {
  await page.setContent(probe());
  await expect(page.getByRole("button")).toHaveCSS("animation-name", "test-only-travel");
  await page.emulateMedia({ reducedMotion: "reduce", forcedColors: "active" });
  await expect(page.getByRole("button")).toHaveCSS("animation-name", "none");
  await page.getByRole("button").focus();
  await expect(page.getByRole("button")).toHaveCSS("outline-style", "solid");
});
test("independent system instance and CSS-disabled content survive", async ({ page }) => {
  await page.setContent(probe("reduce") + '<section data-shadcn-ui-motion="system"><p class="witness" id="independent">Other instance</p></section>');
  await expect(page.locator("#independent")).toHaveCSS("animation-name", "test-only-travel");
  await page.locator("style").evaluateAll(elements => elements.forEach(e => e.remove()));
  await expect(page.getByRole("button")).toBeVisible();
  await expect(page.locator('[data-shadcn-ui-motion-part="clone"]')).toBeHidden();
});
for (const theme of ["light", "dark"]) {
  test("real capability page, native images and motion links in " + theme, async ({ page }) => {
    await page.goto("/examples/motion-media-capabilities?theme=" + theme);
    await expect(page.locator("h1")).toHaveText("Motion and media capabilities");
    await page.getByRole("link", { name: "Reduce motion", exact: true }).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", theme);
    for (const img of await page.locator(".gallery-media-fixtures img").all()) {
      await img.scrollIntoViewIfNeeded();
      await expect.poll(() => img.evaluate(e => e.complete && e.naturalWidth > 0)).toBe(true);
    }
    await page.addScriptTag({ content: axe });
    const results = await page.evaluate(() => axe.run(document, { rules: { "color-contrast": { enabled: true } } }));
    expect(results.violations.map(v => v.id)).toEqual([]);
  });
}
test("no-script preferences, CSS-disabled page and missing image remain useful", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  try {
    const page = await context.newPage();
    await page.goto("http://127.0.0.1:4105/examples/motion-media-capabilities?theme=dark");
    await page.getByRole("link", { name: "Reduce motion", exact: true }).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
    await page.getByRole("link", { name: "Use light theme" }).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
    await page.locator('link[rel="stylesheet"]').evaluateAll(elements => elements.forEach(e => e.remove()));
    await page.getByText("Inspect intentional image failure", { exact: true }).click();
    await expect(page.getByText("This image is intentionally missing.", { exact: false })).toBeVisible();
    await expect(page.getByRole("link", { name: "open an available landscape" })).toBeVisible();
  } finally { await context.close(); }
});
test("theme buttons update motion destinations and explicit choices beat stored state", async ({ page }) => {
  await page.goto("/examples/motion-media-capabilities");
  await page.getByRole("button", { name: "Dark", exact: true }).click();
  await page.getByRole("link", { name: "Reduce motion", exact: true }).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
  await page.goto("/examples/motion-media-capabilities?theme=light&motion=reduce");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion", "reduce");
});
