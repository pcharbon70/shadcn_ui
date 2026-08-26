import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
// covers: shadcn_ui.overlay_gallery.states shadcn_ui.overlay_gallery.fallbacks
// covers: shadcn_ui.overlay_gallery.browser_behavior shadcn_ui.overlay_gallery.semantic_guidance
// covers: shadcn_ui.overlay_gallery.cross_engine_behavior shadcn_ui.overlay_gallery.capability_matrix
// covers: shadcn_ui.gallery.stable_routes shadcn_ui.gallery.semantic_shell
// covers: shadcn_ui.gallery.component_guidance shadcn_ui.gallery.theme_matrix
const evidence = JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/native_overlay_evidence.json", import.meta.url)));
const leaves = ["overlays/dialog", "overlays/alert-dialog", "overlays/drawer", "overlays/popover", "overlays/dropdown-actions", "interactive-surfaces/tooltip", "interactive-surfaces/hover-card"];
const compositions = ["settings-confirmation", "responsive-drawers", "anchored-actions", "supplemental-help"];

test("every component route has source, current navigation, complete fallback and both themes", async ({ page }) => {
  for (const leaf of leaves) {
    for (const theme of ["light", "dark"]) {
      await page.goto(`/components/${leaf}?theme=${theme}`);
      await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", theme);
      await expect(page.getByRole("main")).toHaveCount(1);
      await expect(page.getByRole("heading", { level: 1 })).toHaveCount(1);
      await expect(page.getByRole("navigation", { name: "Component navigation", exact: true }).locator('[aria-current="page"]')).toHaveCount(1);
      await expect(page.locator("#ordinary-alternative")).toBeVisible();
      await expect(page.getByRole("heading", { name: "HEEX source", exact: true })).toBeVisible();
      expect(await page.locator("pre code").textContent()).toContain("<.");
      expect(await page.locator('link[rel="canonical"]').getAttribute("href")).toBe(`https://leco-industries-inc.github.io/shadcn_ui/components/${leaf}`);
    }
  }
});

test("capability matrix renders exact observed evidence and deliberately excluded policy", async ({ page, browser, browserName }) => {
  expect(browser.version()).toBe(evidence.engines[browserName].version);
  await page.goto("/examples/overlay-capabilities");
  for (const record of Object.values(evidence.engines)) await expect(page.getByRole("columnheader", { name: new RegExp(record.version.replaceAll(".", "\\.")) })).toBeVisible();
  await expect(page.locator('[data-capability="interestInvokers"]')).toContainText("Deliberately excluded");
  await expect(page.locator('[data-capability="interestInvokers"] td')).toHaveText(["Deliberately excluded", "Detected", "Not detected", "Not detected", "Not emitted, even where detected. Supplemental CSS and ordinary links are the fallback."]);
  expect(await page.locator('a[href^="https://html.spec.whatwg.org/"]').count()).toBeGreaterThan(0);
});

test("settings composition preserves validation, modal focus, cancellation and local-only completion", async ({ page }) => {
  await page.goto("/examples/settings-confirmation");
  await page.locator("#settings-edit-invoker").click();
  const dialog = page.locator("#settings-edit-surface");
  await expect(dialog).toBeVisible();
  expect(await dialog.evaluate(el => el.matches(":modal"))).toBe(true);
  await page.locator("#settings-finish").click();
  await expect(dialog).toBeVisible();
  expect(await page.locator("#settings-name").evaluate(el => el.validity.valueMissing)).toBe(true);
  await page.locator("#settings-name").fill("Local reader");
  await page.locator("#settings-finish").click();
  await expect(dialog).not.toBeVisible();
  await page.locator("#settings-confirm-invoker").click();
  await expect(page.getByRole("alertdialog", { name: "Discard this sample draft?" })).toBeVisible();
  await expect(page.locator("#settings-confirm-close")).toBeFocused();
  await page.keyboard.press("Escape");
  await expect(page.locator("#settings-confirm-surface")).not.toBeVisible();
  await page.locator("#settings-rejected-invoker").click();
  await expect(page.locator("#settings-rejected-surface")).toContainText("Example rejection");
  await page.locator("#settings-rejected-close").click();
  await expect(page.locator("#settings-inline")).toBeVisible();
});

test("responsive drawer composition keeps one nested Popover, native scrolling and exit", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/examples/responsive-drawers");
  for (const edge of ["start", "end", "bottom"]) {
    await page.locator(`#filters-${edge}-invoker`).click();
    await expect(page.locator(`#filters-${edge}-surface`)).toBeVisible();
    await page.locator(`#filter-help-${edge}-invoker`).click();
    await expect(page.locator(`#filter-help-${edge}-surface`)).toBeVisible();
    await page.keyboard.press("Escape");
    await expect(page.locator(`#filter-help-${edge}-surface`)).not.toBeVisible();
    await expect(page.locator(`#filters-${edge}-surface`)).toBeVisible();
    await page.locator(`#filters-${edge}-initial-focus`).evaluate(el => { el.scrollTop = el.scrollHeight; });
    await page.locator(`#filters-${edge}-close`).click();
    await expect(page.locator(`#filters-${edge}-surface`)).not.toBeVisible();
  }
});

test("actions composition preserves ordinary reset, disabled snapshots and manual close", async ({ page }) => {
  await page.goto("/examples/anchored-actions");
  await page.locator('#document-draft input').fill("Edited locally");
  await page.locator("#document-actions-invoker").click();
  await page.locator("#document-actions-action-reset").click();
  await expect(page.locator('#document-draft input')).toHaveValue("Original draft");
  await expect(page.locator("#document-actions-action-pending")).toBeDisabled();
  await page.keyboard.press("Escape");
  await page.locator("#manual-actions-invoker").click();
  await page.keyboard.press("Escape");
  await expect(page.locator("#manual-actions-surface")).toBeVisible();
  await page.locator("#manual-actions-close").click();
  await expect(page.locator("#manual-actions-surface")).not.toBeVisible();
});

test("supplemental composition keeps full labels, optional descriptions and ordinary destinations", async ({ page }) => {
  await page.goto("/examples/supplemental-help");
  await page.locator("#help-tip-invoker").focus();
  await expect(page.locator("#help-tip-description")).toBeVisible();
  await expect(page.locator("#help-tip-invoker")).toHaveAccessibleName("Read the complete manual");
  await expect(page.locator("#help-tip-invoker")).toHaveAccessibleDescription("The manual is also available as plain text.");
  await page.locator("#help-card-invoker").hover();
  await expect(page.locator("#help-card-description")).toBeVisible();
  await page.locator("#help-card-invoker").click();
  await expect(page).toHaveURL(/#help-manual$/);
  await expect(page.locator("#help-manual")).toContainText("Save your work");
});
