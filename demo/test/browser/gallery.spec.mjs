import { expect, test } from "@playwright/test";

const componentPaths = ["button", "badge", "alert", "card", "avatar", "skeleton"]
  .map((slug) => `/components/foundation/${slug}`);

test.beforeEach(async ({ page }) => {
  await page.goto("/");
  await page.evaluate(() => localStorage.clear());
});

test("keyboard navigation exposes the skip link and direct component routes", async ({ page }) => {
  await page.goto(componentPaths[0]);
  await page.keyboard.press("Tab");
  await expect(page.getByRole("link", { name: "Skip to main content" })).toBeFocused();
  await page.keyboard.press("Enter");
  await expect(page.locator("main")).toBeFocused();

  for (const path of componentPaths) {
    await page.goto(path);
    await expect(page.locator("h1")).toHaveCount(1);
    await expect(page.getByRole("navigation", { name: "Component navigation" }))
      .toBeVisible();
    await expect(page.getByRole("navigation", { name: "Component navigation" }).locator('[aria-current="page"]')).toHaveCount(1);
    await expect(page.getByRole("heading", { name: "HEEX source" })).toBeVisible();
    await expect(page.locator("pre code")).not.toBeEmpty();
  }
});

test("theme controls persist explicit light and dark scopes", async ({ page }) => {
  await page.goto(componentPaths[0]);
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");
  await page.getByRole("button", { name: "Dark" }).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await page.reload();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await page.getByRole("button", { name: "Light" }).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");
});

test("source and navigation remain useful without script", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.goto(componentPaths[3]);
  await expect(page.getByRole("heading", { name: "Card", exact: true })).toBeVisible();
  await expect(page.locator("pre code")).not.toBeEmpty();
  await page.getByRole("link", { name: "Avatar" }).click();
  await expect(page.getByRole("heading", { name: "Avatar", exact: true })).toBeVisible();
  await context.close();
});

test("layout survives accessibility preferences, narrow width, and 200 percent zoom", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 720 },
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await page.goto(componentPaths[0]);
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  await expect(page.getByRole("navigation", { name: "Component navigation" }))
    .toBeHidden();
  await expect(page.locator("[data-gallery-mobile-navigation]")).toBeVisible();
  await expect(page.locator("[data-gallery-mobile-navigation] summary")).toHaveText("Navigation");
  await expect(page.getByRole("main")).toBeVisible();
  await expect(page.getByText("A deliberately long default action", { exact: false }))
    .toBeVisible();
  await expect(page.locator("body")).toHaveCSS("min-width", "0px");
  expect((await page.locator("body").boundingBox()).width).toBeLessThanOrEqual(391);
  await context.close();
});
