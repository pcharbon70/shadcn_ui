import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";

// covers: shadcn_ui.dialog.drawer shadcn_ui.dialog.shared_contract
// covers: shadcn_ui.dialog.drawer_scroll
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

test("one native body scroll keeps heading, close and footer reachable", async ({ page }) => {
  await load(page);
  await page.setViewportSize({ width: 390, height: 680 });
  await page.locator("#edit-details-invoker").click();
  const body = page.locator("#edit-details-initial-focus");
  const close = page.locator("#edit-details-close");
  const title = page.locator("#edit-details-title");
  const before = await close.boundingBox();
  await expect(body).toBeFocused();
  expect(await body.evaluate(el => el.scrollHeight > el.clientHeight)).toBe(true);
  await page.keyboard.press("End");
  await expect.poll(() => body.evaluate(el => el.scrollTop)).toBeGreaterThan(0);
  expect(await close.boundingBox()).toEqual(before);
  await expect(title).toBeInViewport();
  await expect(page.locator("#save-record")).toBeInViewport();
  expect(await page.locator("#edit-details-surface").evaluate(el => el.scrollTop)).toBe(0);
  const overscroll = await body.evaluate(el => ({
    supported: CSS.supports("overscroll-behavior-y", "contain"),
    value: getComputedStyle(el).getPropertyValue("overscroll-behavior-y"),
  }));
  expect(overscroll.value).toBe(overscroll.supported ? "contain" : "");
  expect(await body.evaluate(el => getComputedStyle(el).outlineStyle)).not.toBe("none");

  // Application-selected validation focus uses ordinary native scroll-into-view.
  await page.locator("#validation-target").focus();
  await expect(page.locator("#validation-target")).toBeFocused();
  await expect(page.locator("#validation-target")).toBeInViewport();
  const field = await page.locator("#validation-target").boundingBox();
  const footer = await page.locator("[data-shadcn-ui-drawer-footer]").boundingBox();
  expect(field.y + field.height).toBeLessThanOrEqual(footer.y + 1);
  await close.click();
});

test("caller forms, validation, disclosure, radios and nested Popover remain native", async ({ page }) => {
  await load(page);
  await page.locator("#edit-details-invoker").click();
  await page.locator("#save-record").click();
  await expect(page.locator("#edit-details-surface")).toBeVisible();
  await expect(page.locator("#record-reference")).toBeFocused();
  await page.locator("#record-reference").fill("REF-42");
  await page.getByText("Reference guidance", { exact: true }).click();
  await expect(page.locator("#record-help details")).toHaveAttribute("open", "");
  await page.getByRole("radio", { name: "Complete", exact: true }).check();
  expect(await page.locator("#edit-form").evaluate(el => new FormData(el).get("mode"))).toBe("complete");
  await page.getByRole("button", { name: "Show note", exact: true }).click();
  expect(await page.locator("#record-note").evaluate(el => el.matches(":popover-open"))).toBe(true);
  await page.getByRole("button", { name: "Hide note", exact: true }).click();
  await page.locator("#save-record").click();
  await expect(page.locator("#edit-details-surface")).not.toBeVisible();
  expect(await page.locator("#edit-details-surface").evaluate(el => el.returnValue)).toBe("saved");
});

test("no scripts or CSS and unsupported invokers retain ordinary destinations", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.setContent(html);
  await page.locator("#drawer-start-invoker").click();
  await expect(page.locator("#drawer-start-surface")).toBeVisible();
  await page.locator("#drawer-start-close").click();
  // Deliberately omit invoker support; never supply a script/polyfill fallback.
  await page.setContent(html.replace(/command="show-modal"/g, ""));
  await page.locator("#drawer-start-invoker").click();
  await expect(page.locator("#drawer-start-surface")).not.toBeVisible();
  await page.locator("#drawer-start [data-shadcn-ui-drawer-fallback] a").click();
  expect(page.url()).toContain("#fallback-content");
  await expect(page.locator("#fallback-content")).toBeInViewport();
  await context.close();
});

test("touch activation and disabled transitions keep long content and exit usable", async ({ browser }) => {
  const context = await browser.newContext({ hasTouch: true, viewport: { width: 390, height: 680 } });
  const page = await context.newPage();
  await load(page);
  await page.addStyleTag({ content: "[data-shadcn-ui-overlay-surface] { transition: none !important; transform: none !important; }" });
  await page.locator("#edit-details-invoker").tap();
  await expect(page.locator("#edit-details-surface")).toBeVisible();
  await expect(page.locator("#edit-details-close")).toBeInViewport();
  await page.locator("#edit-details-close").tap();
  await expect(page.locator("#edit-details-surface")).not.toBeVisible();
  await context.close();
});

test("disabled logical layout and transitions leave a bounded ordinary modal", async ({ page }) => {
  await load(page);
  await page.setViewportSize({ width: 800, height: 600 });
  await page.evaluate(() => {
    for (const sheet of document.styleSheets) {
      for (let i = sheet.cssRules.length - 1; i >= 0; i--) {
        const condition = sheet.cssRules[i].conditionText || "";
        if (condition.includes("inset-inline-start") || condition.includes("transition-behavior")) sheet.deleteRule(i);
      }
    }
  });
  await page.locator("#drawer-start-invoker").click();
  const dialog = page.locator("#drawer-start-surface");
  expect(await dialog.evaluate(el => el.matches(":modal"))).toBe(true);
  const box = await dialog.boundingBox();
  expect(box.x).toBeGreaterThan(0);
  expect(box.y).toBeGreaterThan(0);
  expect(box.width).toBeLessThan(800);
  expect(box.height).toBeLessThan(600);
  expect(await dialog.evaluate(el => getComputedStyle(el).opacity)).toBe("1");
  await page.locator("#drawer-start-close").click();
  await expect(dialog).not.toBeVisible();
});

test("replacement is a closed snapshot with no package restoration or persistence", async ({ page }) => {
  await load(page);
  const snapshot = await page.locator("#edit-details").evaluate(el => el.outerHTML);
  await page.locator("#edit-details-invoker").click();
  await page.locator("#record-reference").fill("unsaved draft");
  await page.locator("#edit-details-initial-focus").evaluate(el => { el.scrollTop = 700; });
  await page.locator("#edit-details").evaluate((el, replacement) => { el.outerHTML = replacement; }, snapshot);
  await expect(page.locator("#edit-details-surface")).not.toBeVisible();
  expect(await page.locator("#edit-details-surface").evaluate(el => el.matches(":modal"))).toBe(false);
  await page.locator("#edit-details-invoker").click();
  await expect(page.locator("#record-reference")).toHaveValue("");
  expect(await page.locator("#edit-details-initial-focus").evaluate(el => el.scrollTop)).toBe(0);
  await page.locator("#edit-details-close").click();
});

test("all sizes and long-content zoom preserve the fixed regions and native scroll", async ({ page }) => {
  await load(page);
  for (const size of ["small", "default", "large"]) {
    await page.locator("#drawer-start-surface").evaluate((el, value) => { el.dataset.size = value; }, size);
    await page.locator("#drawer-start-invoker").click();
    const width = await page.locator("#drawer-start-surface").evaluate(el => el.clientWidth);
    expect(width).toBeLessThanOrEqual({ small: 384, default: 512, large: 768 }[size]);
    await page.locator("#drawer-start-close").click();
  }
  await page.setViewportSize({ width: 390, height: 844 });
  await page.locator("html").evaluate(el => { el.style.zoom = "2"; el.dir = "rtl"; });
  await page.locator("#edit-details-invoker").click();
  const body = page.locator("#edit-details-initial-focus");
  expect(await body.evaluate(el => el.clientHeight)).toBeGreaterThan(30);
  await expect(page.locator("#edit-details-close")).toBeInViewport();
  await expect(page.locator("#save-record")).toBeInViewport();
  await page.locator("#edit-details-close").click();
});
