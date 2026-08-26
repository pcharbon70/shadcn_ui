import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";

// covers: shadcn_ui.dialog.drawer shadcn_ui.dialog.shared_contract
// covers: shadcn_ui.stylesheet.overlay_fallbacks shadcn_ui.stylesheet.overlay_resilience
const html = readFileSync(new URL("../fixtures/milestone_d_drawers.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");

async function load(page) {
  await page.setContent(html);
  await page.addStyleTag({ content: css });
  await page.emulateMedia({ reducedMotion: "reduce" });
}

test("logical edges follow direction and orientation with bounded sizes", async ({ page }) => {
  await load(page);
  for (const viewport of [{ width: 1100, height: 800 }, { width: 320, height: 640 }, { width: 640, height: 320 }]) {
    await page.setViewportSize(viewport);
    for (const dir of ["ltr", "rtl"]) {
      await page.locator("html").evaluate((el, value) => { el.dir = value; }, dir);
      for (const edge of ["start", "end", "bottom"]) {
        await page.locator(`#drawer-${edge}-invoker`).click();
        const dialog = page.locator(`#drawer-${edge}-surface`);
        await expect(dialog).toBeVisible();
        expect(await dialog.evaluate(el => el.matches(":modal"))).toBe(true);
        const box = await dialog.boundingBox();
        expect(box.width).toBeLessThanOrEqual(viewport.width + 1);
        expect(box.height).toBeLessThanOrEqual(viewport.height + 1);
        if (edge === "bottom") expect(Math.abs(box.y + box.height - viewport.height)).toBeLessThan(2);
        else if ((edge === "start") === (dir === "ltr")) expect(Math.abs(box.x)).toBeLessThan(2);
        else expect(Math.abs(box.x + box.width - viewport.width)).toBeLessThan(2);
        await page.locator(`#drawer-${edge}-close`).click();
        await expect(dialog).not.toBeVisible();
      }
    }
  }
});

test("native focus containment, dismissal and explicit exit", async ({ page }) => {
  await load(page);
  await page.locator("#drawer-end-invoker").click();
  await expect(page.locator("#drawer-end-initial-focus")).toBeFocused();
  await page.locator("#outside").evaluate(el => el.focus());
  expect(await page.evaluate(() => document.querySelector("#drawer-end-surface").contains(document.activeElement))).toBe(true);
  for (let i = 0; i < 8; i++) {
    await page.keyboard.press(i % 2 ? "Shift+Tab" : "Tab");
    expect(await page.evaluate(() => document.querySelector("#drawer-end-surface").contains(document.activeElement))).toBe(true);
  }
  await page.keyboard.press("Escape");
  await expect(page.locator("#drawer-end-surface")).not.toBeVisible();
  // Native engines differ in which prior element remains active after close.
  expect(await page.evaluate(() => document.activeElement.id)).toMatch(/^(|drawer-end-(invoker|close|surface|initial-focus))$/);
  await page.locator("#policy-none-invoker").click();
  await expect(page.locator("#policy-none-close")).toBeFocused();
  await page.keyboard.press("Escape");
  await page.mouse.click(2, 2);
  await expect(page.locator("#policy-none-surface")).toBeVisible();
  await page.locator("#policy-none-close").click();
  await page.locator("#policy-any-invoker").click();
  await page.mouse.click(2, 2);
  await expect(page.locator("#policy-any-surface")).not.toBeVisible();
});

test("zoom, themes, forced colors and reduced motion preserve native exit", async ({ page }) => {
  await load(page);
  await page.setViewportSize({ width: 320, height: 640 });
  for (const theme of ["light", "dark"]) {
    await page.locator("html").evaluate((el, value) => { el.dataset.shadcnTheme = value; el.style.zoom = "2"; }, theme);
    await page.emulateMedia({ forcedColors: "active", reducedMotion: "reduce" });
    await page.locator("#drawer-bottom-invoker").click();
    const dialog = page.locator("#drawer-bottom-surface");
    expect(await dialog.evaluate(el => el.clientWidth)).toBeLessThanOrEqual(320);
    expect(await dialog.evaluate(el => el.clientHeight)).toBeLessThanOrEqual(640);
    expect(await dialog.evaluate(el => getComputedStyle(el).transitionDuration)).toBe("0s");
    await expect(page.locator("#drawer-bottom-close")).toBeVisible();
    await page.locator("#drawer-bottom-close").click();
  }
});
