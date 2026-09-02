import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
// covers: shadcn_ui.overlay_gallery.states shadcn_ui.overlay_gallery.fallbacks
// covers: shadcn_ui.overlay_gallery.browser_behavior shadcn_ui.overlay_gallery.semantic_guidance
// covers: shadcn_ui.overlay_gallery.cross_engine_behavior shadcn_ui.overlay_gallery.capability_matrix
// covers: shadcn_ui.gallery.stable_routes shadcn_ui.gallery.semantic_shell
// covers: shadcn_ui.gallery.component_guidance shadcn_ui.gallery.theme_matrix
const evidence = JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/native_overlay_evidence.json", import.meta.url)));
const leaves = ["overlays/dialog", "overlays/alert-dialog", "overlays/drawer", "overlays/popover", "overlays/dropdown-actions", "interactive-surfaces/tooltip", "interactive-surfaces/hover-card"];
const compositions = ["settings-confirmation", "responsive-drawers", "anchored-actions", "supplemental-help"];
const routes = [...leaves.map(leaf => `/components/${leaf}`), ...compositions.map(name => `/examples/${name}`), "/examples/overlay-capabilities"];
const axePath = fileURLToPath(new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url));

async function audit(page) {
  await page.addScriptTag({ path: axePath });
  const violations = await page.evaluate(async () => (await axe.run(document, {
    runOnly: { type: "tag", values: ["wcag2a", "wcag2aa", "wcag21a", "wcag21aa", "best-practice"] }
  })).violations.map(v => ({ id: v.id, impact: v.impact, nodes: v.nodes.map(n => n.target) })));
  expect(violations, page.url()).toEqual([]);
}

test("every component route has source, current navigation, complete fallback and both themes", async ({ page }) => {
  for (const leaf of leaves) {
    for (const theme of ["light", "dark"]) {
      await page.goto(`/components/${leaf}?theme=${theme}`);
      await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", theme);
      await expect(page.getByRole("main")).toHaveCount(1);
      await expect(page.getByRole("heading", { level: 1 })).toHaveCount(1);
      await expect(page.getByRole("navigation", { name: "Component navigation", exact: true }).locator('[aria-current="page"]')).toHaveCount(1);
      await expect(page.locator("#ordinary-alternative")).toBeVisible();
      await expect(page.locator("[data-gallery-specimen-source]")).toHaveCount(1);
      expect(await page.locator("pre code").textContent()).toContain("<.");
      expect(await page.locator('link[rel="canonical"]').getAttribute("href")).toBe(`https://pcharbon70-shadcn-ui-demo.fly.dev/components/${leaf}`);
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

test("all Milestone D pages pass automated accessibility in both themes and native open states", async ({ page }) => {
  test.setTimeout(180_000);
  // Audit settled colors, not an intermediate native entry-opacity frame.
  await page.emulateMedia({ reducedMotion: "reduce" });
  for (const route of routes) {
    for (const theme of ["light", "dark"]) {
      await page.goto(`${route}?theme=${theme}`);
      await audit(page);
      expect(await page.locator("[id]").evaluateAll(nodes => nodes.map(n => n.id).filter((id, i, ids) => ids.indexOf(id) !== i))).toEqual([]);
      expect(await page.locator("[aria-labelledby], [aria-describedby], [aria-controls], [commandfor], [popovertarget]").evaluateAll(nodes => nodes.flatMap(n =>
        ["aria-labelledby", "aria-describedby", "aria-controls", "commandfor", "popovertarget"].flatMap(attr =>
          (n.getAttribute(attr) || "").split(/\s+/).filter(id => id && !document.getElementById(id))
        )
      ))).toEqual([]);
      await expect(page.locator('[role="menu"], [role="menuitem"], [role="menubar"], [interestfor], [popover="hint"]')).toHaveCount(0);
    }
  }
  for (const [route, id] of [["settings-confirmation", "settings-edit"], ["settings-confirmation", "settings-confirm"], ["responsive-drawers", "filters-end"], ["anchored-actions", "edge-popover"], ["anchored-actions", "document-actions"]]) {
    await page.goto(`/examples/${route}`);
    await page.locator(`#${id}-invoker`).click();
    await audit(page);
  }
});

test("native keyboard containment, dismissal policies and subtree replacement stay browser-owned", async ({ page }) => {
  await page.goto("/examples/settings-confirmation");
  await page.locator("#settings-edit-invoker").focus();
  await page.keyboard.press("Enter");
  await expect(page.locator("#settings-edit-initial-focus")).toBeFocused();
  for (const key of ["Tab", "Tab", "Tab", "Shift+Tab", "Shift+Tab", "Shift+Tab"]) {
    await page.keyboard.press(key);
    // Browsers may move focus to browser chrome (reported as body), never to
    // an inert background control. Do not implement a synthetic focus trap.
    expect(await page.locator("#settings-edit-surface").evaluate(el => el.contains(document.activeElement) || document.activeElement === document.body)).toBe(true);
  }
  await page.keyboard.press("Escape");
  await expect(page.locator("#settings-edit-surface")).not.toBeVisible();
  expect(await page.evaluate(() => document.activeElement.id)).toMatch(/^(settings-edit-invoker|)$/);
  await page.locator("#settings-edit-invoker").click();
  await page.locator("#settings-edit").evaluate(el => { const copy = el.cloneNode(true); copy.querySelector("dialog").removeAttribute("open"); el.replaceWith(copy); });
  await expect(page.locator("#settings-edit-surface")).not.toBeVisible();
  await page.locator("#settings-edit-invoker").click();
  await expect(page.locator("#settings-edit-surface")).toBeVisible();
  await page.goto("/components/overlays/dialog");
  await page.locator("#dialog-none-invoker").click();
  await page.keyboard.press("Escape");
  await expect(page.locator("#dialog-none-surface")).toBeVisible();
  await page.locator("#dialog-none-close").click();
  await page.locator("#dialog-any-invoker").click();
  await page.mouse.click(2, 2);
  await expect(page.locator("#dialog-any-surface")).not.toBeVisible();
});

test("wide and narrow RTL, zoom, forced colors and reduced motion retain readable exits", async ({ page }) => {
  await page.emulateMedia({ forcedColors: "active", reducedMotion: "reduce" });
  for (const width of [390, 1280]) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto("/examples/responsive-drawers?theme=dark");
    await page.locator("html").evaluate(el => { el.dir = "rtl"; el.style.zoom = "2"; });
    await page.locator("#filters-end-invoker").click();
    await expect(page.locator("#filters-end-close")).toBeInViewport();
    await expect(page.locator("#filters-end-surface")).toHaveCSS("transition-duration", "0s");
    const box = await page.locator("#filters-end-surface").boundingBox();
    expect(box.x).toBeGreaterThanOrEqual(-1);
    expect(box.x + box.width).toBeLessThanOrEqual(width + 1);
    await page.locator("#filters-end-close").click();
    await page.goto("/examples/supplemental-help");
    await page.locator("#help-translated-invoker").focus();
    await expect(page.locator("#help-translated-description")).toBeVisible();
    await expect(page.locator("#help-translated-description")).toHaveCSS("position", "static");
  }
});

test("viewport-edge Popover in a scrolling host stays bounded", async ({ page }) => {
  await page.setViewportSize({ width: 800, height: 700 });
  await page.goto("/examples/anchored-actions");
  for (const dir of ["ltr", "rtl"]) {
    await page.locator("html").evaluate((el, value) => { el.dir = value; }, dir);
    await page.locator(".gallery-action-scroll").evaluate(el => { el.scrollTop = 50; });
    await page.locator("#edge-popover-invoker").evaluate(el => { el.style.cssText = "position:fixed;right:2px;bottom:2px"; });
    await page.locator("#edge-popover-invoker").click();
    const box = await page.locator("#edge-popover-surface").boundingBox();
    expect(box.x).toBeGreaterThanOrEqual(-1);
    expect(box.y).toBeGreaterThanOrEqual(-1);
    expect(box.x + box.width).toBeLessThanOrEqual(801);
    expect(box.y + box.height).toBeLessThanOrEqual(701);
    await page.locator("#edge-popover-close").click();
  }
});

test("no script and coarse pointer retain native invocation and complete destinations", async ({ browser, baseURL }) => {
  const context = await browser.newContext({ baseURL, javaScriptEnabled: false, hasTouch: true, viewport: { width: 390, height: 844 } });
  const page = await context.newPage();
  try {
    for (const name of compositions) {
      await page.goto(`/examples/${name}`);
      await expect(page.getByRole("heading", { name: "Fallback and replacement" })).toBeVisible();
    }
    await page.locator("#help-card-invoker").tap();
    await expect(page).toHaveURL(/#help-manual$/);
    await page.goto("/examples/settings-confirmation");
    await page.locator("#settings-edit-invoker").tap();
    await expect(page.locator("#settings-edit-surface")).toBeVisible();
    await page.locator("#settings-edit-close").tap();
    await expect(page.locator("#settings-inline")).toBeVisible();
  } finally { await context.close(); }
});

test("CSS-disabled pages retain native exits and visible supplemental information", async ({ page }) => {
  await page.route("**/*.css", route => route.fulfill({ contentType: "text/css", body: "" }));
  await page.goto("/examples/settings-confirmation");
  await page.locator("#settings-edit-invoker").click();
  await expect(page.locator("#settings-edit-surface")).toBeVisible();
  await page.locator("#settings-edit-close").click();
  await expect(page.locator("#settings-inline")).toBeVisible();
  await page.goto("/examples/supplemental-help");
  await expect(page.locator("#help-tip-description")).toBeVisible();
  await expect(page.locator("#help-card-description")).toBeVisible();
  await page.locator("#help-card-invoker").click();
  await expect(page).toHaveURL(/#help-manual$/);
});

test("disabled invokers and optional CSS capabilities keep honest ordinary alternatives", async ({ page }) => {
  await page.route("**/*.css", async route => {
    const response = await route.fetch();
    const body = (await response.text()).replaceAll("(anchor-name:", "(unsupported-anchor-name:").replaceAll("(anchor-scope:", "(unsupported-anchor-scope:").replaceAll("(position-try-fallbacks:", "(unsupported-position-try-fallbacks:").replaceAll("(transition-behavior:", "(unsupported-transition-behavior:");
    await route.fulfill({ response, body });
  });
  await page.goto("/examples/anchored-actions");
  await page.locator("#edge-popover-invoker").click();
  await expect(page.locator("#edge-popover-close")).toBeInViewport();
  await page.locator("#edge-popover-close").click();
  await page.locator("[commandfor], [popovertarget]").evaluateAll(nodes => nodes.forEach(el => { el.removeAttribute("commandfor"); el.removeAttribute("popovertarget"); }));
  await page.locator("#document-actions-invoker").click();
  await expect(page.locator("#document-actions-surface")).not.toBeVisible();
  await page.getByRole("link", { name: "All actions inline" }).click();
  await expect(page).toHaveURL(/#actions-inline$/);
  await page.goto("/examples/supplemental-help");
  await page.locator("#help-card-invoker").focus();
  await expect(page.locator("#help-card-description")).toHaveCSS("position", "static");
});
