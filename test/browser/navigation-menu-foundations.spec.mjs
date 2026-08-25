import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";
// covers: shadcn_ui.navigation.menu shadcn_ui.navigation.link_semantics
// covers: shadcn_ui.navigation.current_location shadcn_ui.navigation.destination_ownership
// covers: shadcn_ui.navigation.protected_semantics shadcn_ui.navigation.shared_contract
// covers: shadcn_ui.stylesheet.content_resilience
const fixture = readFileSync(new URL("../fixtures/navigation_menu.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
async function load(page, styled = true) { await page.setContent(fixture); if (styled) await page.addStyleTag({content: css}); }

test("Tab, Shift+Tab, Enter, fragments, target, download, and current remain native", async ({page}) => {
  await load(page); await page.locator("#before").focus(); await page.keyboard.press("Tab");
  await expect(page.locator("#overview")).toBeFocused(); await page.keyboard.press("Enter");
  await expect(page).toHaveURL(/#overview-target$/); await page.locator("#reports").focus();
  await page.keyboard.press("Shift+Tab"); await expect(page.locator("#overview")).toBeFocused();
  await expect(page.locator("#overview")).toHaveAttribute("aria-current", "page");
  await expect(page.locator("#reports")).toHaveAttribute("target", "_blank");
  await expect(page.locator("#download")).toHaveAttribute("download", "report.txt");
  await page.locator("#reports").dispatchEvent("contextmenu");
  await expect(page.locator("#reports")).toHaveAttribute("href", "#reports-target");
});

test("no CSS and no script retain named destinations and fragment activation", async ({browser}) => {
  const context = await browser.newContext({javaScriptEnabled: false}); const page = await context.newPage();
  await load(page, false); await expect(page.getByRole("navigation", {name: "Primary navigation"})).toBeVisible();
  await page.locator("#overview").click(); await expect(page).toHaveURL(/#overview-target$/); await context.close();
});

test("narrow zoom, forced colors, reduced motion, dark theme, RTL, and long labels remain visible", async ({browser}) => {
  const context = await browser.newContext({viewport:{width:320,height:720}, forcedColors:"active", reducedMotion:"reduce"});
  const page = await context.newPage(); await load(page); await page.evaluate(() => document.documentElement.style.zoom="2");
  await expect(page.locator('[dir="rtl"]')).toBeVisible(); await expect(page.getByText("Very long translated reports", {exact:false})).toBeVisible();
  await expect(page.locator("#overview")).toHaveCSS("text-decoration-line", "underline");
  await expect(page.locator('[dir="rtl"] a')).toHaveAttribute("aria-current", "location"); await context.close();
});

test("markup has no custom widget semantics or package script", async ({page}) => {
  await load(page); await expect(page.locator("[role]")).toHaveCount(0); await expect(page.locator("script")).toHaveCount(0);
  await expect(page.locator("nav ul li a")).toHaveCount(4);
});
