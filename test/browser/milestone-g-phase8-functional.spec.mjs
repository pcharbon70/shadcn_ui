import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.gallery_presentation.complete_migration
// covers: shadcn_ui.gallery_presentation.specimen_semantics
// covers: shadcn_ui.gallery_presentation.stable_identity

const axe = readFileSync(
  new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url),
  "utf8",
);

test("ordinary navigation, search, theme, source, and copy behavior remain complete", async ({page}) => {
  await page.goto("/components/foundation/button#button-primary");
  await expect(page.getByRole("navigation", {name: "Breadcrumb"})).toContainText("Foundation / Button");
  await expect(page.locator("#button-primary")).toBeVisible();

  await page.goto("/components/foundation/button");
  const specimen = page.locator('[data-gallery-specimen="button-primary"]');
  const code = specimen.locator('input[value="code"]');
  await code.focus();
  await page.keyboard.press("Space");
  await expect(code).toBeChecked();
  await expect(specimen.locator("[data-gallery-specimen-source]")).toBeVisible();
  await specimen.getByRole("button", {name: "Copy source"}).click();
  await expect(specimen.locator("[aria-live=polite]")).toContainText(/Copied|Select and copy/);

  await page.getByRole("button", {name: "Dark"}).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await page.reload();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");

  const search = page.getByRole("searchbox", {name: "Search components"});
  await search.fill("navigatión");
  await expect(
    page.locator("[data-gallery-catalogue] [data-gallery-search-status]"),
  ).toContainText(/components? found/);
  await expect(
    page.getByRole("navigation", {name: "Component navigation"})
      .getByRole("link", {name: "Navigation Menu", exact: true}),
  ).toBeVisible();

  await page.setViewportSize({width: 390, height: 844});
  const mobile = page.locator("[data-gallery-mobile-navigation]");
  await mobile.locator("summary").click();
  await expect(page.getByRole("navigation", {name: "Mobile component navigation"})).toBeVisible();
});

test("keyboard, axe, zoom, forced colors, reduced motion, and long content pass together", async ({browser}) => {
  const context = await browser.newContext({
    viewport: {width: 320, height: 720},
    forcedColors: "active",
    reducedMotion: "reduce",
  });
  const page = await context.newPage();
  await page.goto("/components/forms/error-summary?theme=dark&motion=reduce");
  await page.keyboard.press("Tab");
  await expect(page.getByRole("link", {name: "Skip to main content"})).toBeFocused();
  await page.keyboard.press("Enter");
  await expect(page.locator("main")).toBeFocused();

  await page.locator("html").evaluate((node) => { node.style.zoom = "2"; });
  await expect(page.getByRole("heading", {name: "Error Summary primary example"})).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);

  await page.addScriptTag({content: axe});
  const report = await page.evaluate(async () => axe.run(document, {
    rules: {"color-contrast": {enabled: false}},
    runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"]},
  }));
  expect(report.violations).toEqual([]);
  await context.close();
});

test("no-script and missing presentation assets preserve native content and destinations", async ({browser}) => {
  const context = await browser.newContext({
    javaScriptEnabled: false,
    viewport: {width: 390, height: 844},
  });
  await context.route(/\.(?:css|js)(?:\?|$)/, (route) => route.abort());
  const page = await context.newPage();
  await page.goto("/components/motion/marquee?theme=light&motion=reduce#marquee-primary-source");
  await expect(page.locator("#marquee-primary-source code")).toContainText("<.marquee");
  await expect(page.locator("#marquee-primary-preview")).toBeVisible();

  const navigation = page.locator("[data-gallery-mobile-navigation]");
  await navigation.locator("summary").click();
  await navigation.getByRole("link", {name: "Button", exact: true}).click();
  await expect(page).toHaveURL(/\/components\/foundation\/button$/);
  await expect(page.locator("#button-primary-source code")).toContainText("<.button");

  await page.goto("/components/disclosure/accordion");
  await page.locator("#faq-sections-item-support summary").click();
  await expect(page.locator("#faq-sections-item-support")).toHaveAttribute("open", "");
  await context.close();
});
