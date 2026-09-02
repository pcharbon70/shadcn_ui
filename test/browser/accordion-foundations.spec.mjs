import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.disclosure.accordion_native
// covers: shadcn_ui.disclosure.accordion_modes
// covers: shadcn_ui.disclosure.fallback
// covers: shadcn_ui.disclosure.shared_contract
// covers: shadcn_ui.stylesheet.content_fallbacks
// covers: shadcn_ui.stylesheet.content_resilience

const fixture = readFileSync(new URL("../fixtures/accordion.html", import.meta.url), "utf8");
const stylesheet = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");

async function loadFixture(page, { css = true } = {}) {
  await page.setContent(fixture);

  if (css) {
    await page.addStyleTag({ content: stylesheet });
  }
}

test("native summary supports pointer, Enter, Space, focus, and nested controls", async ({ page }) => {
  await loadFixture(page);
  const details = page.locator("#independent-item-billing");
  const summary = page.getByText("Billing", { exact: true });

  await expect(details).toHaveAttribute("open", "");
  await summary.click();
  await expect(details).not.toHaveAttribute("open", "");

  await summary.focus();
  await expect(summary).toBeFocused();
  await page.keyboard.press("Enter");
  await expect(details).toHaveAttribute("open", "");
  await expect(summary).toHaveCSS("outline-style", "solid");

  await page.locator("#nested-action").click();
  await expect(details).toHaveAttribute("open", "");

  await summary.focus();
  await page.keyboard.press("Space");
  await expect(details).not.toHaveAttribute("open", "");
});

test("exclusive name uses native grouping where supported and remains independent otherwise", async ({ page }) => {
  await loadFixture(page);
  const first = page.locator("#exclusive-item-one");
  const second = page.locator("#exclusive-item-two");
  const supportsExclusive = await page.evaluate(() => "name" in document.createElement("details"));

  await second.locator("summary").click();
  await expect(second).toHaveAttribute("open", "");

  if (supportsExclusive) {
    await expect(first).not.toHaveAttribute("open", "");
  } else {
    await expect(first).toHaveAttribute("open", "");
  }
});

test("no-CSS and no-script mode retains summaries, content, and native activation", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await loadFixture(page, { css: false });

  await expect(page.getByText("Security", { exact: true })).toBeVisible();
  await expect(page.locator("body")).toContainText("Security fragment destination remains reachable.");
  await page.getByText("Security", { exact: true }).click();
  await expect(page.locator("#independent-item-security")).toHaveAttribute("open", "");
  await context.close();
});

test("themes, narrow zoom, reduced motion, and forced colors preserve state and access", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 720 },
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await loadFixture(page);
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  await expect(page.locator('[data-shadcn-theme="dark"]')).toBeVisible();
  await expect(page.getByText("First exclusive content.", { exact: true })).toBeVisible();
  await expect(page.locator("#independent-item-billing")).toHaveCSS("border-top-style", "solid");

  for (const direction of ["ltr", "rtl"]) {
    await page.locator("#independent").evaluate((element, value) => { element.dir = value; }, direction);
    const summary = page.locator("#independent-item-billing-summary");
    await summary.focus();
    const geometry = await summary.evaluate((element) => {
      const item = element.closest("details");
      const summaryRect = element.getBoundingClientRect();
      const itemRect = item.getBoundingClientRect();
      return {
        summaryLeft: summaryRect.left,
        summaryRight: summaryRect.right,
        itemLeft: itemRect.left,
        itemRight: itemRect.right,
        summaryScrollWidth: element.scrollWidth,
        itemClientWidth: item.clientWidth
      };
    });

    expect(geometry.summaryLeft).toBeGreaterThanOrEqual(geometry.itemLeft - 1);
    expect(geometry.summaryRight).toBeLessThanOrEqual(geometry.itemRight + 1);
    expect(geometry.summaryScrollWidth).toBeLessThanOrEqual(geometry.itemClientWidth + 1);
    await expect(summary).toBeFocused();
  }

  const transitionDuration = await page.locator("#independent-item-billing").evaluate((details) =>
    getComputedStyle(details, "::details-content").transitionDuration
  );

  expect(["0s", "0.00001s"]).toContain(transitionDuration);
  await context.close();
});

test("fragment and source-order content remain reachable without package routing", async ({ page }) => {
  await loadFixture(page);
  await page.evaluate(() => { location.hash = "security-fragment"; });

  await expect(page.locator("#security-fragment")).toHaveText(
    "Security fragment destination remains reachable."
  );
  await expect(page.locator("script")).toHaveCount(0);
  expect(await page.locator("[id]").evaluateAll((nodes) =>
    new Set(nodes.map((node) => node.id)).size === nodes.length
  )).toBe(true);
});
