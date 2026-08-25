import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.overlay.native_invocation
// covers: shadcn_ui.overlay.state_ownership
// covers: shadcn_ui.overlay.focus_ownership
// covers: shadcn_ui.overlay.dismissal
// covers: shadcn_ui.overlay.dom_replacement
// covers: shadcn_ui.overlay.nesting_boundary
// covers: shadcn_ui.overlay.web_fallback
// covers: shadcn_ui.stylesheet.overlay_fallbacks
// covers: shadcn_ui.stylesheet.overlay_resilience

const fixture = readFileSync(
  new URL("../fixtures/milestone_d_overlay_contract.html", import.meta.url),
  "utf8"
);
const stylesheet = readFileSync(
  new URL("../../priv/static/shadcn_ui.css", import.meta.url),
  "utf8"
);

async function loadFixture(page, { css = true, html = fixture } = {}) {
  await page.setContent(html);
  if (css) await page.addStyleTag({ content: stylesheet });
}

test("native commands open and close Dialog and its one nested Popover", async ({ page }) => {
  await loadFixture(page);

  const dialog = page.locator("#dialog-surface");
  const popover = page.locator("#nested-popover");

  await page.locator("#dialog-invoker").click();
  await expect(dialog).toHaveAttribute("open", "");
  await expect(page.locator("body")).toHaveJSProperty("inert", false);

  await page.locator("#nested-popover-invoker").click();
  await expect(popover).toBeVisible();
  expect(await popover.evaluate((element) => element.matches(":popover-open"))).toBe(true);

  await page.locator("#nested-popover-invoker").click();
  await page.locator("#dialog-close").click();
  await expect(dialog).not.toHaveAttribute("open", "");
  // Restoration differs across engines; the package deliberately does not normalize it.
  expect(["", "dialog-invoker", "dialog-close", "dialog-surface"]).toContain(
    await page.evaluate(() => document.activeElement.id)
  );
});

test("DOM replacement honestly loses browser-local open state", async ({ page }) => {
  await loadFixture(page);
  await page.locator("#dialog-invoker").click();
  await expect(page.locator("#dialog-surface")).toHaveAttribute("open", "");

  await page.locator("#dialog-surface").evaluate((surface) => {
    surface.outerHTML = '<dialog id="dialog-surface" closedby="any"><p>Replacement snapshot</p></dialog>';
  });

  await expect(page.locator("#dialog-surface")).not.toHaveAttribute("open", "");
  await expect(page.getByText("Replacement snapshot")).not.toBeVisible();
});

test("a deliberately disabled invoker retains its ordinary fallback destination", async ({ page }) => {
  const disabled = fixture
    .replace(' command="show-modal" commandfor="dialog-surface"', "")
    .replace(' popovertarget="nested-popover"', "");

  await loadFixture(page, { css: false, html: disabled });
  await page.locator("#dialog-invoker").click();
  await expect(page.locator("#dialog-surface")).not.toHaveAttribute("open", "");

  await page.locator("#ordinary-fallback").click();
  await expect(page).toHaveURL(/#fallback-content$/);
  await expect(page.locator("#fallback-content")).toContainText("Visible ordinary fallback");
});

test("CSS-disabled and no-script operation keeps native controls and visible fallback", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await loadFixture(page, { css: false });

  await expect(page.locator("#ordinary-fallback")).toBeVisible();
  await page.locator("#dialog-invoker").click();
  await expect(page.locator("#dialog-surface")).toHaveAttribute("open", "");
  await page.locator("#dialog-close").click();
  await expect(page.locator("#dialog-surface")).not.toHaveAttribute("open", "");
  await context.close();
});

test("bounded placement, reduced motion, forced colors, and nesting exclusions survive", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 480 },
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await loadFixture(page);
  await page.locator("#dialog-invoker").click();

  const dialog = page.locator("#dialog-surface");
  const box = await dialog.boundingBox();
  expect(box.width).toBeLessThanOrEqual(320);
  expect(box.height).toBeLessThanOrEqual(480);
  expect(await dialog.evaluate((element) => getComputedStyle(element).transitionDuration))
    .toMatch(/^(0s|0\.00001s)(, 0s|, 0\.00001s)*$/);
  await expect(dialog.locator("dialog")).toHaveCount(0);
  await expect(page.locator("script")).toHaveCount(0);
  await context.close();
});
