import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
// covers: shadcn_ui.supplemental.tooltip shadcn_ui.supplemental.tooltip_fallback
// covers: shadcn_ui.supplemental.css_behavior shadcn_ui.supplemental.no_interest_claim
// covers: shadcn_ui.stylesheet.overlay_fallbacks shadcn_ui.stylesheet.overlay_resilience
// covers: shadcn_ui.supplemental.hover_card shadcn_ui.supplemental.hover_card_boundary
const html = readFileSync(new URL("../fixtures/milestone_d_supplemental_surfaces.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
async function load(page, styles = css) {
  await page.setContent(html.replace("</head>", `<style>${styles}</style></head>`));
}
const description = "The manual contains all required instructions. A local copy is also retained.";

test("Tooltip description survives hidden presentation; keyboard focus and activation stay native", async ({ page }) => {
  await load(page);
  const trigger = page.locator("#tip-invoker"), bubble = page.locator("#tip-description");
  await expect(bubble).not.toBeVisible();
  await expect(trigger).toHaveAccessibleName("Read the manual");
  await expect(trigger).toHaveAccessibleDescription(description);
  await trigger.focus();
  await expect(bubble).toBeVisible();
  expect(await bubble.evaluate(el => el.tabIndex)).toBe(-1);
  await page.keyboard.press("Tab");
  await expect(page.locator("#after")).toBeFocused();
  await expect(bubble).not.toBeVisible();
  await trigger.focus();
  await page.keyboard.press("Enter");
  await expect(page).toHaveURL(/#destination$/);
  await expect(page.locator("#disabled-invoker")).toBeDisabled();
});

test("Tooltip fine-pointer hover, exit and clipped-container activation", async ({ page }) => {
  await load(page);
  await page.locator("#tip-invoker").hover();
  await expect(page.locator("#tip-description")).toBeVisible();
  await page.locator("#before").hover();
  await expect(page.locator("#tip-description")).not.toBeVisible();
  await page.locator("#clipped-invoker").click();
  await expect(page).toHaveURL(/#destination$/);
  await expect(page.locator("#clipped-invoker")).toHaveAccessibleDescription("Optional description inside a clipped container.");
});

test("Tooltip CSS-disabled and unsupported anchors preserve content and operation", async ({ page }) => {
  await load(page, "");
  await expect(page.locator("#tip-description")).toBeVisible();
  await expect(page.locator("#tip-invoker")).toHaveAccessibleDescription(description);
  // Disable the complete enhancement query, exercising the authored fallback.
  await load(page, css.replaceAll("(anchor-scope:", "(unsupported-anchor-scope:"));
  await page.locator("#tip-invoker").focus();
  await expect(page.locator("#tip-description")).toHaveCSS("position", "static");
  const t = await page.locator("#tip-invoker").boundingBox(), b = await page.locator("#tip-description").boundingBox();
  expect(b.y).toBeGreaterThanOrEqual(t.y + t.height - 1);
});

test("Tooltip narrow zoom, long RTL text, themes and motion remain readable", async ({ page }) => {
  await page.setViewportSize({ width: 360, height: 800 });
  await page.emulateMedia({ reducedMotion: "reduce", forcedColors: "active" });
  await load(page);
  await page.locator("body").evaluate(el => { el.style.zoom = "2"; });
  await page.locator("#long-invoker").focus();
  const bubble = page.locator("#long-description");
  await expect(bubble).toBeVisible();
  await expect(bubble).toHaveCSS("position", "static");
  await expect(bubble).toHaveCSS("transition-duration", "0s");
  await expect(bubble).toHaveCSS("border-top-style", "solid");
  expect(await bubble.evaluate(el => el.scrollWidth <= el.clientWidth + 1)).toBe(true);
  await expect(page.locator("#long")).toHaveCSS("direction", "rtl");
  for (const theme of ["light", "dark"]) {
    await page.locator("#translated").evaluate((el, value) => el.dataset.shadcnTheme = value, theme);
    await expect(bubble).toBeVisible();
  }
});

test("Tooltip no-script coarse-pointer/no-hover falls back to ordinary navigation", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, hasTouch: true, viewport: { width: 390, height: 844 } });
  const page = await context.newPage();
  await load(page);
  expect(await page.evaluate(() => matchMedia("(hover: none)").matches)).toBe(true);
  await expect(page.locator("#tip-description")).not.toBeVisible();
  await expect(page.locator("#tip-invoker")).toHaveAccessibleDescription(description);
  await page.locator("#tip-invoker").tap();
  await expect(page).toHaveURL(/#destination$/);
  await context.close();
});

test("Hover Card pointer transition, pointer exit and native context menu leave navigation intact", async ({ page }) => {
  await load(page);
  const link = page.locator("#card-invoker"), preview = page.locator("#card-description");
  await expect(preview).not.toBeVisible();
  await expect(link).toHaveAccessibleName("Read the complete manual");
  await link.hover();
  await expect(preview).toBeVisible();
  await preview.hover();
  await expect(preview).toBeVisible();
  await page.locator("#after-card").hover();
  await expect(preview).not.toBeVisible();
  // Test-only observer verifies that package markup does not cancel contextmenu.
  await link.evaluate(el => el.addEventListener("contextmenu", event => {
    queueMicrotask(() => { el.dataset.contextCancelled = String(event.defaultPrevented); });
  }));
  await link.click({ button: "right" });
  await expect(link).toHaveAttribute("data-context-cancelled", "false");
  await page.keyboard.press("Escape");
  await link.click();
  await expect(page).toHaveURL(/#destination$/);
});

test("Hover Card keyboard focus, Enter, preview nonfocusability and stable replacement", async ({ page }) => {
  await load(page);
  const link = page.locator("#card-invoker"), preview = page.locator("#card-description");
  await link.focus();
  await expect(preview).toBeVisible();
  expect(await preview.locator("a,button,input,select,textarea,[tabindex],[contenteditable]").count()).toBe(0);
  await page.keyboard.press("Tab");
  await expect(page.locator("#after-card")).toBeFocused();
  await expect(preview).not.toBeVisible();
  const markup = await page.locator("#card").evaluate(el => el.outerHTML);
  await page.locator("#card").evaluate((el, html) => { el.outerHTML = html; }, markup);
  await expect(link).toHaveAttribute("aria-describedby", "card-description");
  await link.focus();
  await page.keyboard.press("Enter");
  await expect(page).toHaveURL(/#destination$/);
});

test("Hover Card CSS-disabled, no-anchor and no-hover/focus enhancements preserve destination", async ({ page }) => {
  await load(page, "");
  await expect(page.locator("#card-description")).toBeVisible();
  await page.locator("#card-invoker").click();
  await expect(page).toHaveURL(/#destination$/);
  await load(page, css.replaceAll("(anchor-scope:", "(unsupported-anchor-scope:"));
  await page.locator("#card-invoker").focus();
  await expect(page.locator("#card-description")).toHaveCSS("position", "static");
  await load(page, css.replaceAll(":hover", ":unsupported-hover").replaceAll(":focus-within", ":unsupported-focus-within"));
  await page.locator("#card-invoker").click();
  await expect(page).toHaveURL(/#destination$/);
});

test("Hover Card no-script touch follows a complete ordinary destination", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, hasTouch: true, viewport: { width: 390, height: 844 } });
  const page = await context.newPage();
  await load(page);
  await page.locator("#card-invoker").tap();
  await expect(page).toHaveURL(/#destination$/);
  await expect(page.locator("#destination")).toContainText("All required task information");
  await context.close();
});

test("scoped LTR anchors and RTL flow fallback keep every placement off its trigger", async ({ page }) => {
  await load(page);
  const supports = await page.evaluate(() => CSS.supports("anchor-scope: --shadcn-ui-supplemental") && CSS.supports("position-area: self-inline-start") && CSS.supports("position-try-fallbacks: flip-block"));
  for (const id of ["tip", "card"]) {
    await page.locator(`#${id}`).evaluate(el => { el.style.cssText = "position:fixed;left:45%;top:45%"; });
    for (const dir of ["ltr", "rtl"]) {
      for (const placement of ["block-start", "block-end", "inline-start", "inline-end"]) {
        await page.locator(`#${id}`).evaluate((el, values) => { el.dir = values.dir; el.dataset.placement = values.placement; }, { dir, placement });
        await page.locator(`#${id}-invoker`).focus();
        await expect(page.locator(`#${id}-description`)).toBeVisible();
        const t = await page.locator(`#${id}-invoker`).boundingBox(), b = await page.locator(`#${id}-description`).boundingBox();
        if (supports && dir === "ltr") {
          expect(b.x + b.width <= t.x + 1 || b.x >= t.x + t.width - 1 || b.y + b.height <= t.y + 1 || b.y >= t.y + t.height - 1).toBe(true);
          if (placement === "block-start") expect(b.y + b.height).toBeLessThanOrEqual(t.y + 1);
          if (placement === "block-end") expect(b.y).toBeGreaterThanOrEqual(t.y + t.height - 1);
          if (placement === "inline-start" && dir === "ltr" || placement === "inline-end" && dir === "rtl") expect(b.x + b.width).toBeLessThanOrEqual(t.x + 1);
          if (placement === "inline-end" && dir === "ltr" || placement === "inline-start" && dir === "rtl") expect(b.x).toBeGreaterThanOrEqual(t.x + t.width - 1);
        } else {
          await expect(page.locator(`#${id}-description`)).toHaveCSS("position", "static");
        }
      }
    }
    await page.locator(`#${id}`).evaluate(el => el.removeAttribute("style"));
  }
});

test("Hover Card long translated preview survives narrow zoom, color and motion preferences", async ({ page }) => {
  await page.setViewportSize({ width: 360, height: 800 });
  await page.emulateMedia({ reducedMotion: "reduce", forcedColors: "active" });
  await load(page);
  await page.locator("#card").evaluate(el => { el.dir = "rtl"; el.dataset.shadcnTheme = "dark"; el.style.zoom = "2"; });
  await page.locator("#card-description p").evaluate(el => { el.textContent = "Zusätzliche Informationen — معلومات إضافية. ".repeat(12); });
  await page.locator("#card-invoker").focus();
  const preview = page.locator("#card-description");
  await expect(preview).toBeVisible();
  await expect(preview).toHaveCSS("position", "static");
  await expect(preview).toHaveCSS("transition-duration", "0s");
  await expect(preview).toHaveCSS("border-top-style", "solid");
  expect(await preview.evaluate(el => el.scrollWidth <= el.clientWidth + 1)).toBe(true);
  await page.emulateMedia({ forcedColors: "none" });
  for (const theme of ["dark", "light"]) {
    await page.locator("#card").evaluate((el, theme) => el.dataset.shadcnTheme = theme, theme);
    const colors = await preview.evaluate(el => ({ fg: getComputedStyle(el).color, bg: getComputedStyle(el).backgroundColor }));
    expect(colors.fg).not.toBe(colors.bg);
  }
  await page.keyboard.press("Enter");
  await expect(page).toHaveURL(/#destination$/);
});

test("supplemental rendering adds no runtime, fetch, interest or focusable preview", async ({ page }) => {
  const requests = [];
  page.on("request", request => requests.push(request.url()));
  await load(page);
  await page.locator("#tip-invoker").hover();
  await page.locator("#card-invoker").hover();
  expect(requests).toEqual([]);
  expect(await page.locator("script,[interestfor],[popover],[onmouseover],[onfocus],[phx-hook]").count()).toBe(0);
  expect(await page.locator("[data-shadcn-ui-supplemental-surface] a,[data-shadcn-ui-supplemental-surface] button,[data-shadcn-ui-supplemental-surface] [tabindex]").count()).toBe(0);
  await expect(page.locator("#help")).toBeVisible();
  await expect(page.locator("#destination")).toContainText("All required task information");
});
