import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.form_gallery.states
// covers: shadcn_ui.form_gallery.modes
// covers: shadcn_ui.form_gallery.select_fallback
// covers: shadcn_ui.form_gallery.content_stress
// covers: shadcn_ui.form_gallery.browser_behavior

const slugs = ["field", "label", "help", "field-errors", "error-summary", "input", "textarea", "checkbox", "radio-group", "switch", "native-select", "enhanced-select", "slider", "progress", "meter"];

test("every Forms route has stable navigation, breadcrumb, source, and relationships", async ({ page }) => {
  await page.goto("/components/forms");
  await expect(page.getByRole("navigation", { name: "Component navigation", exact: true }).locator('[aria-current="page"]')).toHaveCount(1);
  await expect(page.getByRole("navigation", { name: "Complete form examples" })).toBeVisible();

  for (const slug of slugs) {
    await page.goto(`/components/forms/${slug}`);
    await expect(page.locator("h1")).toHaveCount(1);
    await expect(page.getByRole("navigation", { name: "Component navigation", exact: true }).locator('[aria-current="page"]')).toHaveCount(1);
    await expect(page.getByRole("navigation", { name: "Breadcrumb" })).toContainText("Forms");
    await expect(page.getByRole("heading", { name: "HEEX source" })).toBeVisible();
    await expect(page.locator("pre code")).not.toBeEmpty();
    expect(await page.locator("[id]").evaluateAll((nodes) => new Set(nodes.map((node) => node.id)).size === nodes.length)).toBe(true);
  }

  await page.goto("/components/forms/not-a-component");
  await expect(page.getByRole("heading", { name: "Page not found" })).toBeVisible();
  await expect(page.locator("body")).not.toContainText("not-a-component");
});

test("profile retains native labels, radio and slider keys, constraints, reset, and submission", async ({ page }) => {
  await page.goto("/forms/profile");
  const name = page.locator("#demo_name");
  await page.getByText("A deliberately long display name", { exact: false }).click();
  await expect(name).toBeFocused();
  expect(await name.evaluate((control) => control.checkValidity())).toBe(false);
  await name.fill("Ada Lovelace");
  expect(await name.evaluate((control) => control.checkValidity())).toBe(true);

  const phone = page.locator('input[type="radio"][value="phone"]');
  await phone.focus();
  await page.keyboard.press("Space");
  await expect(phone).toBeChecked();

  const slider = page.locator('input[type="range"]');
  await slider.focus();
  await page.keyboard.press("Home");
  await expect(slider).toHaveValue("0");
  await page.keyboard.press("End");
  await expect(slider).toHaveValue("100");
  await page.keyboard.press("ArrowLeft");
  await expect(slider).toHaveValue("90");
  await page.locator("select").selectOption("us");
  await page.locator("textarea").fill("Detailed caller-owned profile notes");

  await page.getByRole("button", { name: "Reset" }).click();
  await expect(slider).toHaveValue("40");
  await name.fill("Ada Lovelace");
  await page.locator("textarea").fill("Detailed caller-owned profile notes");
  await page.getByRole("button", { name: "Inspect submitted values" }).click();
  await expect(page.getByRole("heading", { name: "Received demonstration values" })).toBeVisible();
  await expect(page.locator("[data-demo-received-values]")).toContainText("Ada Lovelace");
});

test("settings keeps native checkbox keys, repeated values, and select fallback", async ({ page }) => {
  await page.goto("/forms/settings");
  const alerts = page.locator("#demo_alerts");
  await alerts.focus();
  await page.keyboard.press("Space");
  await expect(alerts).not.toBeChecked();

  const enhanced = page.locator("select");
  await expect(enhanced).toBeVisible();
  const capability = await page.evaluate(() => CSS.supports("appearance", "base-select") && CSS.supports("selector(::picker(select))"));
  expect(await enhanced.evaluate((select) => getComputedStyle(select).appearance)).toBe(capability ? "base-select" : "auto");
  await enhanced.selectOption("us");
  await page.getByRole("button", { name: "Inspect submitted values" }).click();
  await expect(page.locator("[data-demo-received-values]")).toContainText("exports");
  await expect(page.locator("[data-demo-received-values]")).toContainText("audit");
  await expect(page.locator("[data-demo-received-values]")).toContainText("false");
  await expect(page.locator("[data-demo-received-values]")).toContainText("us");
});

test("no-script, themes, long content, narrow zoom, reduced motion, and forced colors remain usable", async ({ browser }) => {
  const context = await browser.newContext({ viewport: { width: 320, height: 720 }, javaScriptEnabled: false, reducedMotion: "reduce", forcedColors: "active" });
  const page = await context.newPage();
  await page.goto("/components/forms/input?theme=dark");
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");
  await expect(page.getByRole("navigation", { name: "Component navigation", exact: true })).toBeHidden();
  await page.locator(".gallery-mobile-navigation summary").click();
  const mobileNavigation = page.getByRole("navigation", { name: "Mobile component navigation", exact: true });
  await expect(mobileNavigation).toBeVisible();
  await expect(page.getByText("Account email", { exact: true })).toBeVisible();
  await expect(page.locator("input").first()).toBeVisible();
  await mobileNavigation.getByRole("link", { name: "Help", exact: true }).click();
  await expect(page.getByText("Guía extensa", { exact: false })).toBeVisible();
  await context.close();
});

test("explicit accessibility audit finds native names and complete references", async ({ page }) => {
  await page.goto("/forms/sign-in");
  await page.keyboard.press("Tab");
  await expect(page.getByRole("link", { name: "Back to Forms" })).toBeFocused();
  await page.keyboard.press("Tab");
  await expect(page.locator("#demo_email")).toBeFocused();

  await page.goto("/forms/profile");
  await expect(page.getByRole("textbox", { name: /display name/i })).toBeVisible();
  await expect(page.getByRole("textbox", { name: "Profile notes" })).toBeVisible();
  await expect(page.getByRole("radio", { name: "Email" })).toBeVisible();
  await expect(page.getByRole("slider", { name: "Notification volume" })).toBeVisible();

  const missing = await page.locator("[aria-describedby], [aria-labelledby]").evaluateAll((nodes) =>
    nodes.flatMap((node) => [node.getAttribute("aria-describedby"), node.getAttribute("aria-labelledby")])
      .filter(Boolean).flatMap((value) => value.split(/\s+/)).filter((id) => !document.getElementById(id))
  );
  expect(missing).toEqual([]);
});
