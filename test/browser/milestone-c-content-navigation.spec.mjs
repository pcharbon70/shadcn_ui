import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.content_gallery.states
// covers: shadcn_ui.content_gallery.fallbacks
// covers: shadcn_ui.content_gallery.content_stress
// covers: shadcn_ui.content_gallery.browser_behavior
// covers: shadcn_ui.gallery.component_guidance shadcn_ui.gallery.semantic_shell
// covers: shadcn_ui.gallery.stable_routes shadcn_ui.gallery.theme_matrix

const categories = [
  ["disclosure", "Disclosure"],
  ["navigation", "Navigation"],
  ["content-surfaces", "Content Surfaces"]
];

const components = [
  ["disclosure", "accordion", "Accordion"],
  ["navigation", "navigation-menu", "Navigation Menu"],
  ["navigation", "header", "Header"],
  ["navigation", "section-header", "Section Header"],
  ["content-surfaces", "scroll-area", "Scroll Area"],
  ["content-surfaces", "separator", "Separator"],
  ["content-surfaces", "radio-panels", "Radio Panels"]
];

test("closed Milestone C routes expose navigation, breadcrumbs, source, and 404s", async ({ page }) => {
  for (const [slug, label] of categories) {
    const response = await page.goto(`/components/${slug}`);
    expect(response.status()).toBe(200);
    await expect(page.getByRole("heading", { level: 1, name: label })).toBeVisible();
    await expect(page.getByRole("link", { name: label, exact: true }).first()).toHaveAttribute("aria-current", "page");
  }

  for (const [category, slug, label] of components) {
    const response = await page.goto(`/components/${category}/${slug}`);
    expect(response.status()).toBe(200);
    await expect(page.getByRole("heading", { level: 1, name: label })).toBeVisible();
    await expect(page.getByRole("navigation", { name: "Breadcrumb" })).toContainText(label);
    await expect(page.getByRole("link", { name: label, exact: true }).first()).toHaveAttribute("aria-current", "page");
    expect(await page.locator("[data-gallery-specimen-source]").count()).toBeGreaterThan(0);
    await expect(page.locator("pre code").first()).not.toBeEmpty();
  }

  const response = await page.goto("/components/navigation/not-a-component");
  expect(response.status()).toBe(404);
  await expect(page.getByRole("heading", { name: "Page not found" })).toBeVisible();
});

test("native disclosure, links, fragments, scrolling, and radio keys remain browser-owned", async ({ page }) => {
  await page.goto("/components/disclosure/accordion");
  const independent = page.locator("#faq-sections-item-support");
  await independent.locator("summary").click();
  await expect(independent).toHaveAttribute("open", "");

  const exclusiveOne = page.locator("#faq-item-billing");
  const exclusiveTwo = page.locator("#faq-item-security");
  await exclusiveTwo.locator("summary").click();
  await expect(exclusiveTwo).toHaveAttribute("open", "");
  if (await page.evaluate(() => "name" in document.createElement("details"))) {
    await expect(exclusiveOne).not.toHaveAttribute("open", "");
  }

  await page.goto("/components/navigation/navigation-menu");
  await page.getByRole("link", { name: "A deliberately long translated destination label" }).click();
  await expect(page).toHaveURL(/#long-destination$/);
  await expect(page.locator("#long-destination")).toBeVisible();

  await page.goto("/components/content-surfaces/scroll-area");
  const scroll = page.getByRole("region", { name: "Long activity example" });
  await scroll.focus();
  await expect(scroll).toBeFocused();
  await scroll.evaluate((node) => { node.scrollTop = node.scrollHeight; });
  expect(await scroll.evaluate((node) => node.scrollTop)).toBeGreaterThan(0);

  await page.goto("/components/content-surfaces/radio-panels");
  const summary = page.locator("#gallery-views-option-summary");
  const activity = page.locator("#gallery-views-option-activity");
  await summary.focus();
  await page.keyboard.press("ArrowRight");
  await expect(activity).toBeFocused();
  await expect(activity).toBeChecked();
  await expect(activity).toHaveAttribute("name", "view");
  await expect(activity).toHaveAttribute("value", "activity");
});

test("substantial compositions preserve landmarks, snapshots, overflow, and RTL", async ({ page }) => {
  for (const slug of ["documentation", "settings", "application-shell"]) {
    const response = await page.goto(`/examples/${slug}`);
    expect(response.status()).toBe(200);
    await expect(page.locator(`[data-gallery-composition="${slug}"]`)).toBeVisible();
  }

  await page.goto("/examples/documentation");
  await expect(page.getByRole("navigation", { name: "Documentation sections" })).toBeVisible();
  await page.getByRole("link", { name: "Detailed guidance" }).click();
  await expect(page).toHaveURL(/#docs-details$/);
  await expect(page.getByText("Esta documentación permanece disponible", { exact: false })).toBeVisible();

  await page.goto("/examples/settings?view=security&state=invalid");
  await expect(page.getByRole("radio", { name: "Security" })).toBeChecked();
  await expect(page.getByText("Review the settings", { exact: true })).toBeVisible();
  await expect(page.locator("form[data-gallery-static-form]")).toHaveCount(1);

  await page.goto("/examples/application-shell");
  await expect(page.locator('[data-gallery-composition="application-shell"]')).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("navigation", { name: "Primary application navigation" })).toBeVisible();
  await expect(page.getByRole("navigation", { name: "Secondary application navigation" })).toBeVisible();
  await expect(page.getByRole("region", { name: "Application content" })).toBeVisible();
});

test("no-script and CSS-disabled pages retain all authored content and native controls", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  await context.route(/\.(css|js)(\?|$)/, (route) => route.abort());
  const page = await context.newPage();
  await page.goto("/components/content-surfaces/radio-panels");

  await expect(page.locator("[data-shadcn-ui-radio-panels]").getByRole("radio")).toHaveCount(3);
  for (const panel of await page.locator("[data-shadcn-ui-radio-panel]").all()) {
    await expect(panel).toBeVisible();
  }
  await expect(page.locator("script")).toHaveCount(1);
  await expect(page.getByText("Disabled choice explanation remains readable.")).toBeVisible();

  await page.goto("/components/disclosure/accordion");
  await page.getByText("Support guidance", { exact: true }).click();
  await expect(page.locator("#faq-sections-item-support")).toHaveAttribute("open", "");
  await context.close();
});

test("accessibility preferences, themes, zoom, and forbidden roles keep semantics intact", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 720 },
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await page.goto("/examples/application-shell?theme=dark");
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await expect(page.getByRole("main")).toBeVisible();
  await expect(page.getByRole("heading", { level: 1 })).toHaveCount(1);
  await expect(page.locator('[role="menu"], [role="menubar"], [role="tab"], [role="tablist"], [role="tabpanel"]')).toHaveCount(0);
  await expect(page.locator("[onkeydown], [data-on-keydown]")).toHaveCount(0);
  expect(await page.locator("[id]").evaluateAll((nodes) => new Set(nodes.map((node) => node.id)).size === nodes.length)).toBe(true);

  await page.goto("/components/navigation/section-header");
  await expect(page.locator("#section-sticky")).toBeVisible();
  await expect(page.getByRole("heading", { name: "Sticky section" })).toBeVisible();
  await context.close();
});
