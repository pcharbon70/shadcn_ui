import { expect, test } from "@playwright/test";
import axe from "axe-core";

// covers: shadcn_ui.documentation_catalogue.stable_information_architecture
// covers: shadcn_ui.documentation_catalogue.stable_examples
// covers: shadcn_ui.documentation_catalogue.progressive_navigation
// covers: shadcn_ui.documentation_catalogue.progressive_search

const componentRoute = "/components/foundation/button";

test("desktop navigation, breadcrumbs, fragments, history, and 404s remain ordinary", async ({ page }) => {
  const response = await page.goto(`${componentRoute}#button-primary`);
  expect(response.status()).toBe(200);
  await expect(page.getByRole("navigation", { name: "Component navigation" })).toBeVisible();
  await expect(page.locator(".gallery-mobile-navigation")).toBeHidden();
  await expect(page.getByRole("navigation", { name: "Breadcrumb" })).toContainText("Foundation / Button");
  await expect(page.locator("#button-primary")).toBeVisible();
  await expect(page.getByRole("heading", { name: "Button primary example" })).toBeVisible();
  await expect(page.locator('link[rel="canonical"]')).toHaveAttribute("href", `https://leco-industries-inc.github.io/shadcn_ui${componentRoute}`);
  await expect(page.getByRole("navigation", { name: "Component navigation" }).locator('[aria-current="page"]')).toHaveCount(1);

  await page.getByRole("navigation", { name: "Related documentation" }).getByRole("link", { name: "Badge" }).click();
  await expect(page).toHaveURL(/\/components\/foundation\/badge$/);
  await page.goBack();
  await expect(page).toHaveURL(new RegExp(`${componentRoute}#button-primary$`));
  await page.goForward();
  await expect(page).toHaveURL(/\/components\/foundation\/badge$/);

  const missing = await page.goto("/components/unknown/untrusted");
  expect(missing.status()).toBe(404);
  await expect(page.getByRole("heading", { name: "Page not found" })).toBeVisible();
  await expect(page.locator('link[rel="canonical"]')).toHaveCount(0);
  await expect(page.locator("body")).not.toContainText("untrusted");
});

test("mobile disclosure exposes the same complete touch-sized destinations", async ({ browser }) => {
  const context = await browser.newContext({ viewport: { width: 390, height: 780 } });
  const page = await context.newPage();
  await page.goto(componentRoute);

  await expect(page.getByRole("navigation", { name: "Component navigation" })).toBeHidden();
  const disclosure = page.locator(".gallery-mobile-navigation");
  await expect(disclosure).toBeVisible();
  await disclosure.locator("summary").click();
  const mobile = page.getByRole("navigation", { name: "Mobile component navigation" });
  await expect(mobile.locator("[data-gallery-search-item]")).toHaveCount(41);
  await expect(mobile.locator('[aria-current="page"]')).toHaveCount(1);
  const longLink = mobile.getByRole("link", { name: "Scroll Indicator", exact: true });
  await expect(longLink).toBeVisible();
  expect((await longLink.boundingBox()).width).toBeLessThanOrEqual((await mobile.boundingBox()).width);
  const buttonBox = await mobile.getByRole("link", { name: "Button", exact: true }).boundingBox();
  expect(buttonBox.height).toBeGreaterThanOrEqual(44);
  await context.close();
});

test("progressive search announces, normalizes, resets, and never changes history", async ({ page }) => {
  await page.goto(componentRoute);
  const input = page.getByRole("searchbox", { name: "Search components" });
  const status = page.locator("[data-gallery-search-status]");
  const historyBefore = await page.evaluate(() => history.length);

  await input.fill("navigatión");
  await expect(status).toContainText(/components? found/);
  await expect(page.getByRole("navigation", { name: "Component navigation" }).getByRole("link", { name: "Navigation Menu", exact: true })).toBeVisible();

  await input.fill("<script>alert(1)</script>");
  await expect(status).toHaveText("0 components found");
  expect((await page.locator("script").allTextContents()).join(" ")).not.toContain("alert(1)");

  await input.fill("x".repeat(500));
  await expect(input).toHaveValue("x".repeat(200));
  await expect(status).toHaveText("0 components found");
  expect(await page.evaluate(() => history.length)).toBe(historyBefore);

  await page.getByRole("button", { name: "Clear" }).click();
  await expect(input).toBeFocused();
  await expect(input).toHaveValue("");
  await expect(status).toHaveText("41 components available");
});

test("no-script navigation, stable source, and search inventory stay complete", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.goto(`${componentRoute}#button-primary-source`);

  await expect(page.getByRole("searchbox", { name: "Search components" })).toBeVisible();
  await expect(page.getByRole("navigation", { name: "Component navigation" }).locator("[data-gallery-search-item]")).toHaveCount(41);
  await expect(page.locator("#button-primary-source code")).toContainText("<.button");
  await expect(page.locator("#button-primary")).toBeVisible();
  await context.close();
});

test("pinned axe, focus, reduced motion, narrow layout, long labels, and zoom pass", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 390, height: 780 },
    reducedMotion: "reduce"
  });
  const page = await context.newPage();
  await page.goto("/components/forms/error-summary");
  await page.addScriptTag({ content: axe.source });
  const result = await page.evaluate(async () => axe.run(document, { runOnly: { type: "tag", values: ["wcag2a", "wcag2aa"] } }));
  expect(result.violations).toEqual([]);

  await page.keyboard.press("Tab");
  await expect(page.getByRole("link", { name: "Skip to main content" })).toBeFocused();
  expect(await page.getByRole("link", { name: "Skip to main content" }).evaluate(element => getComputedStyle(element).outlineStyle)).not.toBe("none");

  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });
  await expect(page.locator("main")).toBeVisible();
  await expect(
    page.getByRole("heading", { name: "Error Summary primary example", exact: true }),
  ).toBeVisible();
  expect((await page.locator("body").boundingBox()).width).toBeLessThanOrEqual(390);
  await context.close();
});
