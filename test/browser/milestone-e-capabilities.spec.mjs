import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
import { fixture, manifest, observe } from "./support/motion-media-probe.mjs";
// covers: shadcn_ui.motion_media_contract.capability_manifest
const evidence = JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json", import.meta.url), "utf8"));
test("observed platform behavior and exact lock match the recorded evidence", async ({ page, browser, browserName }) => {
  expect(browser.version()).toBe(evidence.engines[browserName].version);
  expect(await observe(page)).toEqual({ declarations:evidence.engines[browserName].declarations, behavior:evidence.engines[browserName].behavior });
});
for (const disabled of [[], ["has"], ["scrollTimeline"], ["animationRange"], ["timelineScope"], ["viewTimeline"], ["transform3d"], ["scrollSnap"]]) {
  test("complete native fallback with disabled " + disabled.join(", "), async ({ page }) => {
    await page.setContent(fixture(disabled));
    await expect(page.getByRole("listitem")).toHaveCount(2);
    await page.getByRole("region").focus();
    await expect(page.getByRole("region")).toBeFocused();
    await page.keyboard.press("ArrowDown");
    await expect.poll(() => page.locator("#scroll").evaluate(e => e.scrollTop)).toBeGreaterThan(0);
    await page.locator("#preview").check();
    if (disabled.includes("has")) await expect(page.locator("#gate")).toHaveCSS("color", "rgb(0, 0, 0)");
    for (const [bundle, selector] of [["scrollIndicator", "#indicator"], ["coverFlow", "#view"]]) {
      if (manifest.bundles[bundle].enhancements.some(f => disabled.includes(f))) await expect(page.locator(selector)).toHaveCSS("animation-name", "none");
    }
    await expect(page.getByRole("link", { name: "Ordinary image destination" })).toBeVisible();
    await expect(page.locator('[role="progressbar"],[role="tab"],[role="menu"]')).toHaveCount(0);
  });
}
test("CSS-disabled and no-script native content is complete", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  try {
    const page = await context.newPage(); await page.setContent(fixture([], false));
    await expect(page.getByRole("listitem")).toHaveCount(2);
    await expect(page.getByRole("link", { name: "First item", exact: true })).toBeVisible();
    await page.getByRole("checkbox").check(); await expect(page.getByRole("checkbox")).toBeChecked();
  } finally { await context.close(); }
});
test("DOM replacement resets browser-local state", async ({ page }) => {
  await page.setContent(fixture()); await page.getByRole("checkbox").check();
  await page.locator("#scroll").evaluate(e => { e.scrollTop=100; });
  await page.setContent(fixture());
  await expect(page.getByRole("checkbox")).not.toBeChecked();
  expect(await page.locator("#scroll").evaluate(e => e.scrollTop)).toBe(0);
});
