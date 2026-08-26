import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
// covers: shadcn_ui.popover.native_surface shadcn_ui.popover.modes
// covers: shadcn_ui.popover.positioning shadcn_ui.popover.state_ownership
// covers: shadcn_ui.popover.shared_contract
const html = readFileSync(new URL("../fixtures/milestone_d_popovers.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
async function load(page) {
  await page.setContent(html.replace("</head>", `<style>${css}</style></head>`));
  await page.emulateMedia({ reducedMotion: "reduce" });
}
const opened = el => el.matches(":popover-open");

test("native toggle, show, hide, manual persistence and nonmodal focus order", async ({ page }) => {
  await load(page);
  await expect(page.locator("#basic-surface")).not.toBeVisible();
  await page.locator("#basic-invoker").click();
  expect(await page.locator("#basic-surface").evaluate(opened)).toBe(true);
  await page.locator("#basic-invoker").focus();
  await page.keyboard.press("Tab");
  await expect(page.locator("#first-field")).toBeFocused();
  await page.keyboard.press("Shift+Tab");
  await expect(page.locator("#basic-invoker")).toBeFocused();
  await page.locator("#outside").focus();
  await expect(page.locator("#outside")).toBeFocused();
  await page.locator("#outside").click();
  expect(await page.locator("#basic-surface").evaluate(opened)).toBe(false);
  await page.locator("#basic-invoker").click();
  await page.locator("#first-field").focus();
  await page.keyboard.press("Escape");
  expect(await page.locator("#basic-surface").evaluate(opened)).toBe(false);
  expect(await page.evaluate(() => document.activeElement.id)).toMatch(/^(basic-invoker|first-field|)$/);
  await page.locator("#manual-invoker").click();
  await page.locator("#outside").click();
  await page.keyboard.press("Escape");
  expect(await page.locator("#manual-surface").evaluate(opened)).toBe(true);
  await page.locator("#manual-close").click();
  expect(await page.locator("#manual-surface").evaluate(opened)).toBe(false);
  await page.locator("#external-show").click();
  expect(await page.locator("#hide-surface").evaluate(opened)).toBe(true);
  await page.locator("#hide-invoker").click();
  expect(await page.locator("#hide-surface").evaluate(opened)).toBe(false);
});

test("logical placements flip at viewport edges in LTR and RTL", async ({ page }) => {
  await load(page);
  await page.setViewportSize({ width: 900, height: 700 });
  for (const dir of ["ltr", "rtl"]) {
    await page.locator("html").evaluate((el, dir) => { el.dir = dir; }, dir);
    for (const placement of ["block-start", "block-end", "inline-start", "inline-end"]) {
      for (const corner of ["top:4px;left:4px", "top:4px;right:4px", "bottom:4px;left:4px", "bottom:4px;right:4px"]) {
        await page.locator("#basic-invoker").evaluate((el, corner) => { el.style.cssText = `position:fixed;${corner}`; }, corner);
        await page.locator("#basic-surface").evaluate((el, placement) => { el.dataset.placement = placement; }, placement);
        await page.locator("#basic-invoker").click();
        const box = await page.locator("#basic-surface").boundingBox();
        expect(box.x).toBeGreaterThanOrEqual(-1);
        expect(box.y).toBeGreaterThanOrEqual(-1);
        expect(box.x + box.width).toBeLessThanOrEqual(901);
        expect(box.y + box.height).toBeLessThanOrEqual(701);
        await page.locator("#basic-close").click();
      }
    }
  }
});

test("nested scroll, long text, zoom, themes and replacement remain bounded", async ({ page }) => {
  await load(page);
  await page.locator("#scroll-host").evaluate(el => { el.scrollTop = 70; });
  await page.locator("#basic-invoker").click();
  await expect(page.locator("#basic-close")).toBeInViewport();
  await page.locator("#basic-close").click();
  await page.setViewportSize({ width: 390, height: 844 });
  await page.locator("html").evaluate(el => { el.style.zoom = "2"; el.dir = "rtl"; el.dataset.shadcnTheme = "dark"; });
  await page.emulateMedia({ forcedColors: "active", reducedMotion: "reduce" });
  await page.locator("#long-invoker").click();
  const surface = page.locator("#long-surface");
  expect(await surface.evaluate(el => el.scrollHeight > el.clientHeight)).toBe(true);
  await page.locator("#long-close").click();
  await page.locator("html").evaluate(el => { el.style.zoom = "1"; });
  const snapshot = await page.locator("#basic").evaluate(el => el.outerHTML);
  await page.locator("#basic-invoker").click();
  await page.locator("#basic").evaluate((el, snapshot) => { el.outerHTML = snapshot; }, snapshot);
  expect(await page.locator("#basic-surface").evaluate(opened)).toBe(false);
});

test("one Popover inside a Dialog keeps native top-layer and Escape behavior", async ({ page }) => {
  await load(page);
  await page.locator("#host-dialog-invoker").click();
  await page.locator("#nested-invoker").click();
  expect(await page.locator("#nested-surface").evaluate(opened)).toBe(true);
  await page.keyboard.press("Escape");
  expect(await page.locator("#nested-surface").evaluate(opened)).toBe(false);
  expect(await page.locator("#host-dialog-surface").evaluate(el => el.matches(":modal"))).toBe(true);
  await page.locator("#host-dialog-close").click();
});

test("CSS and script disabled, missing Popover and anchor capabilities have honest fallbacks", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, hasTouch: true });
  const page = await context.newPage();
  await page.setContent(html);
  await page.locator("#basic-invoker").click();
  await expect(page.locator("#basic-surface")).toBeVisible();
  await page.locator("#basic-close").click();
  await page.setContent(html.replace(/popovertarget="[^"]*"/g, "").replace(/popover="(?:auto|manual)"/g, "hidden"));
  await page.locator("#basic-invoker").click();
  await expect(page.locator("#basic-surface")).not.toBeVisible();
  await page.locator("#basic [data-shadcn-ui-popover-fallback] a").click();
  expect(page.url()).toContain("#fallback");
  await load(page);
  await page.evaluate(() => {
    for (const sheet of document.styleSheets) for (let i = sheet.cssRules.length - 1; i >= 0; i--) {
      const condition = sheet.cssRules[i].conditionText || "";
      if (condition.includes("position-area") || condition.includes("transition-behavior")) sheet.deleteRule(i);
    }
  });
  await page.locator("#basic-invoker").click();
  const box = await page.locator("#basic-surface").boundingBox();
  expect(box.x).toBeGreaterThan(0);
  expect(box.y).toBeGreaterThan(0);
  await page.locator("#basic-close").click();
  await context.close();
});
