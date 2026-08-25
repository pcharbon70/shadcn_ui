import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.navigation.header shadcn_ui.navigation.section_header
// covers: shadcn_ui.navigation.sticky_fallback shadcn_ui.navigation.protected_semantics
// covers: shadcn_ui.navigation.shared_contract
// covers: shadcn_ui.content.radio_panels shadcn_ui.content.radio_not_tabs
// covers: shadcn_ui.content.radio_fallback shadcn_ui.content.shared_contract
// covers: shadcn_ui.stylesheet.content_fallbacks
// covers: shadcn_ui.stylesheet.content_resilience

const template = readFileSync(new URL("../fixtures/phase4_headers_radio_panels.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");

function fixture(selected = "summary") {
  return template
    .replace("%%SUMMARY_SELECTED%%", selected === "summary" ? "true" : "false")
    .replace("%%ACTIVITY_SELECTED%%", selected === "activity" ? "true" : "false")
    .replace("%%SUMMARY_CHECKED%%", selected === "summary" ? "checked" : "")
    .replace("%%ACTIVITY_CHECKED%%", selected === "activity" ? "checked" : "");
}

async function load(page, { styled = true, selected = "summary" } = {}) {
  await page.setContent(fixture(selected));
  if (styled) await page.addStyleTag({ content: css });
}

test("headers preserve caller landmarks, headings, links, forms, and commands", async ({ page }) => {
  await load(page);
  await expect(page.locator("header").first()).toBeVisible();
  await expect(page.getByRole("navigation", { name: "Primary" })).toBeVisible();
  await expect(page.getByRole("heading", { level: 2, name: "Account overview" })).toBeVisible();
  await expect(page.getByRole("button", { name: "Create" })).toBeVisible();
  await expect(page.locator("#search")).toHaveAttribute("name", "query");
  await expect(page.locator("#overview")).toHaveAttribute("data-presentation", "sticky");
});

test("native radio arrows, disabled state, relationships, and submission remain browser-owned", async ({ page }) => {
  await load(page);
  const summary = page.locator("#views-option-summary");
  const activity = page.locator("#views-option-activity");
  await summary.focus();
  await page.keyboard.press("ArrowRight");
  await expect(activity).toBeFocused();
  await expect(activity).toBeChecked();
  await expect(page.locator("#views-option-disabled")).toBeDisabled();
  await expect(activity).toHaveAttribute("aria-controls", "views-panel-activity");
  expect(await page.evaluate(() => new FormData(document.querySelector("#preferences")).get("view"))).toBe("activity");
});

test("server replacement snapshot selects the matching panel without package state", async ({ page }) => {
  await load(page, { selected: "summary" });
  await expect(page.locator("#views-panel-summary")).toBeVisible();
  await expect(page.locator("#views-panel-activity")).toBeHidden();
  await load(page, { selected: "activity" });
  await expect(page.locator("#views-option-activity")).toBeChecked();
  await expect(page.locator("#views-panel-activity")).toBeVisible();
  await expect(page.locator("#views-panel-summary")).toBeHidden();
});

test("no CSS and no script retain every radio, label, panel, and nested form", async ({ browser }) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await load(page, { styled: false });
  await expect(page.getByRole("radio")).toHaveCount(3);
  await expect(page.locator("[data-shadcn-ui-radio-panel]")).toHaveCount(3);
  for (const panel of await page.locator("[data-shadcn-ui-radio-panel]").all()) await expect(panel).toBeVisible();
  await expect(page.locator("#panel-filter")).toBeVisible();
  await context.close();
});

test("narrow zoom, forced colors, reduced motion, dark theme, and long content remain usable", async ({ browser }) => {
  const context = await browser.newContext({ viewport: { width: 320, height: 720 }, forcedColors: "active", reducedMotion: "reduce" });
  const page = await context.newPage();
  await load(page);
  await page.evaluate(() => { document.documentElement.dataset.shadcnTheme = "dark"; document.documentElement.style.zoom = "2"; });
  await expect(page.getByText("Activity with an exceptionally long translated option label")).toBeVisible();
  await page.locator("#views-option-summary").focus();
  await expect(page.locator("#views-option-summary")).toHaveCSS("outline-style", "solid");
  await expect(page.locator("#overview")).toBeVisible();
  await context.close();
});

test("markup exposes no tabs, menus, key handlers, scripts, or duplicate identities", async ({ page }) => {
  await load(page);
  await expect(page.locator('[role="tablist"], [role="tab"], [role="tabpanel"], [role="menu"], [role="menubar"]')).toHaveCount(0);
  await expect(page.locator("[tabindex], [onkeydown], [data-on-keydown], script")).toHaveCount(0);
  expect(await page.locator("[id]").evaluateAll((nodes) => new Set(nodes.map((node) => node.id)).size === nodes.length)).toBe(true);
});
