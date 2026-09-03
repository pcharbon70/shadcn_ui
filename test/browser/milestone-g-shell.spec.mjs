import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.progressive_navigation
// covers: shadcn_ui.gallery_presentation.stable_identity
// covers: shadcn_ui.gallery_presentation.accessibility_matrix

const axe = readFileSync(
  new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url),
  "utf8"
);
const componentRoute = "/components/foundation/button";
const representativeRoutes = [
  "/",
  "/components/foundation",
  componentRoute,
  "/examples/documentation"
];

async function expectCoreShell(page) {
  await expect(page.locator("[data-gallery-product-header]")).toBeVisible();
  await expect(page.locator("[data-gallery-breadcrumb]")).toBeVisible();
  await expect(page.locator("[data-gallery-main]")).toHaveCount(1);
  await expect(page.locator("[data-gallery-metadata]")).toHaveCount(1);
  await expect(page.getByRole("link", {name: "Skip to main content"})).toHaveCount(1);
  await expect(page.locator('link[rel="canonical"]')).toHaveCount(1);
}

test("the accepted desktop and tablet shell geometry survives every route kind", async ({page}) => {
  await page.setViewportSize({width: 1440, height: 900});

  for (const route of representativeRoutes) {
    const response = await page.goto(route);
    expect(response.status()).toBe(200);
    await expectCoreShell(page);
    await expect(page.locator("[data-gallery-desktop-catalogue]")).toBeVisible();
    await expect(page.locator("[data-gallery-mobile-navigation]")).toBeHidden();
  }

  await page.goto(componentRoute);
  const desktop = await page.evaluate(() => {
    const header = document.querySelector("[data-gallery-product-header]").getBoundingClientRect();
    const grid = document.querySelector("[data-gallery-documentation-grid]").getBoundingClientRect();
    const catalogue = document.querySelector("[data-gallery-catalogue]").getBoundingClientRect();
    const main = document.querySelector("[data-gallery-main]").getBoundingClientRect();
    return {headerHeight: header.height, gridWidth: grid.width, catalogueWidth: catalogue.width, gap: main.left - catalogue.right};
  });
  expect(desktop.headerHeight).toBe(56);
  expect(desktop.gridWidth).toBe(1152);
  expect(desktop.catalogueWidth).toBe(220);
  expect(desktop.gap).toBe(40);

  await page.setViewportSize({width: 1024, height: 768});
  await expect(page.locator("[data-gallery-desktop-catalogue]")).toBeVisible();
  await expect(page.locator("[data-gallery-mobile-navigation]")).toBeHidden();
  await expect(page.locator("[data-gallery-main]")).toBeVisible();
});

test("desktop catalogue remains sticky, independently scrollable, current, and searchable", async ({page}) => {
  await page.setViewportSize({width: 1440, height: 640});
  await page.goto("/components/motion/scroll-indicator");

  const catalogue = page.locator("[data-gallery-catalogue]");
  const navigation = page.locator("[data-gallery-desktop-catalogue]");
  await expect(navigation.locator('[aria-current="page"]')).toHaveCount(1);
  await expect(navigation.locator('[aria-current="page"]')).toHaveText("Scroll Indicator");

  const scrolling = await navigation.evaluate((element) => ({
    clientHeight: element.clientHeight,
    scrollHeight: element.scrollHeight,
    overflowY: getComputedStyle(element).overflowY
  }));
  expect(scrolling.scrollHeight).toBeGreaterThan(scrolling.clientHeight);
  expect(scrolling.overflowY).toBe("auto");

  const before = await catalogue.boundingBox();
  await page.evaluate(() => scrollTo(0, 600));
  const after = await catalogue.boundingBox();
  expect(Math.abs(after.y - before.y)).toBeLessThanOrEqual(1);

  const input = page.getByRole("searchbox", {name: "Search components"});
  const status = catalogue.locator("[data-gallery-search-status]");
  await input.fill("navigatión");
  await expect(status).toContainText(/components? found/);
  await expect(navigation.getByRole("link", {name: "Navigation Menu", exact: true})).toBeVisible();

  await input.fill("<script>alert(1)</script>");
  await expect(status).toHaveText("0 components found");
  expect((await page.locator("script").allTextContents()).join(" ")).not.toContain("alert(1)");

  await page.getByRole("button", {name: "Clear"}).click();
  await expect(input).toBeFocused();
  await expect(status).toHaveText("41 components available");
});

test("mobile disclosure is touch-sized, complete, and resilient at 320px and zoom", async ({browser}) => {
  const context = await browser.newContext({
    hasTouch: true,
    viewport: {width: 320, height: 720},
    reducedMotion: "reduce"
  });
  const page = await context.newPage();
  await page.goto("/components/forms/error-summary");

  await expect(page.locator("[data-gallery-desktop-catalogue]")).toBeHidden();
  const disclosure = page.locator("[data-gallery-mobile-navigation]");
  await expect(disclosure).toBeVisible();
  await disclosure.locator("summary").tap();

  const mobile = page.getByRole("navigation", {name: "Mobile component navigation"});
  await expect(page.getByRole("searchbox", {name: "Search components"})).toBeVisible();
  await expect(mobile.locator("[data-gallery-search-item]")).toHaveCount(41);
  await expect(mobile.locator('[aria-current="page"]')).toHaveText("Error Summary");

  for (const link of [
    mobile.getByRole("link", {name: "Error Summary", exact: true}),
    mobile.getByRole("link", {name: "Scroll Indicator", exact: true})
  ]) {
    const box = await link.boundingBox();
    expect(box.height).toBeGreaterThanOrEqual(44);
    expect(box.x).toBeGreaterThanOrEqual(0);
    expect(box.x + box.width).toBeLessThanOrEqual(320);
  }

  await page.keyboard.press("Escape");
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });
  await expect(page.locator("[data-gallery-main]")).toBeVisible();
  const mainBox = await page.locator("[data-gallery-main]").boundingBox();
  expect(mainBox.x).toBeGreaterThanOrEqual(0);
  expect(mainBox.x + mainBox.width).toBeLessThanOrEqual(320);
  expect((await page.locator("body").boundingBox()).width).toBeLessThanOrEqual(320);

  await page.reload();
  await page.keyboard.press("Tab");
  const skip = page.getByRole("link", {name: "Skip to main content"});
  await expect(skip).toBeFocused();
  expect(await skip.evaluate((element) => getComputedStyle(element).outlineStyle)).not.toBe("none");
  await context.close();
});

test("theme, mobile destinations, and source identity remain progressive without script", async ({browser}) => {
  const scripted = await browser.newPage({viewport: {width: 390, height: 844}});
  await scripted.goto(componentRoute);
  await scripted.getByRole("button", {name: "Dark"}).click();
  await expect(scripted.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await scripted.locator("[data-gallery-mobile-navigation] summary").click();
  await scripted.getByRole("navigation", {name: "Mobile component navigation"})
    .getByRole("link", {name: "Accordion", exact: true}).click();
  await expect(scripted).toHaveURL(/\/components\/disclosure\/accordion$/);
  await expect(scripted.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await scripted.close();

  const context = await browser.newContext({
    javaScriptEnabled: false,
    hasTouch: true,
    viewport: {width: 390, height: 844}
  });
  const page = await context.newPage();
  await page.goto(`${componentRoute}#button-primary-source`);
  await expectCoreShell(page);
  const mobileSearch = page.locator(
    '[data-gallery-search-scope="mobile"] [data-gallery-search-input]'
  );
  await expect(mobileSearch).toBeHidden();
  await page.locator("[data-gallery-mobile-navigation] summary").click();
  await expect(mobileSearch).toBeVisible();
  const mobile = page.getByRole("navigation", {name: "Mobile component navigation"});
  await expect(mobile.locator("[data-gallery-search-item]")).toHaveCount(41);
  await mobile.getByRole("link", {name: "Accordion", exact: true}).click();
  await expect(page).toHaveURL(/\/components\/disclosure\/accordion$/);
  await expect(page.getByRole("navigation", {name: "Theme links"})).toBeVisible();
  await context.close();
});

test("semantic hooks, hostile routes, pinned axe, and ordinary history stay stable", async ({page}) => {
  await page.goto(`${componentRoute}#button-primary`);
  await expect(page.locator("[data-gallery-product-header]")).toHaveCount(1);
  await expect(page.locator("[data-gallery-documentation-grid]")).toHaveCount(1);
  await expect(page.locator("[data-gallery-main]")).toHaveCount(1);
  await expect(page.locator("[data-gallery-package-version]")).toHaveText("Package 1.0.0");
  await expect(page.getByRole("navigation", {name: "Breadcrumb"})).toContainText("Foundation / Button");

  await page.addScriptTag({content: axe});
  const report = await page.evaluate(async () => axe.run(document, {
    runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"]}
  }));
  expect(report.violations).toEqual([]);

  const missing = await page.goto("/components/%3Cscript%3E/untrusted");
  expect(missing.status()).toBe(404);
  await expect(page.getByRole("heading", {name: "Page not found"})).toBeVisible();
  await expect(page.locator('link[rel="canonical"]')).toHaveCount(0);
  await expect(page.locator("body")).not.toContainText("untrusted");
  await expect(page.locator("body")).not.toContainText("<script>");
});
