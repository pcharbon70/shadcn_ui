import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.dialog.native_modal
// covers: shadcn_ui.dialog.dismissal_policy
// covers: shadcn_ui.dialog.initial_focus
// covers: shadcn_ui.dialog.alert_dialog
// covers: shadcn_ui.dialog.alert_ownership
// covers: shadcn_ui.dialog.protected_semantics
// covers: shadcn_ui.dialog.shared_contract
// covers: shadcn_ui.stylesheet.overlay_fallbacks
// covers: shadcn_ui.stylesheet.overlay_resilience

const fixture = readFileSync(
  new URL("../fixtures/milestone_d_dialogs.html", import.meta.url),
  "utf8"
);
const stylesheet = readFileSync(
  new URL("../../priv/static/shadcn_ui.css", import.meta.url),
  "utf8"
);

async function loadFixture(page, { css = true, html = fixture } = {}) {
  await page.setContent(html);
  if (css) await page.addStyleTag({ content: stylesheet });
}

async function clickBackdrop(page, selector) {
  const box = await page.locator(selector).boundingBox();
  expect(box).not.toBeNull();
  await page.mouse.click(Math.max(1, box.x - 8), Math.max(1, box.y - 8));
}

test("Dialog uses native modality, initial focus, containment, and explicit close", async ({ page }) => {
  await loadFixture(page);
  const dialog = page.locator("#basic-dialog-surface");

  await page.locator("#basic-dialog-invoker").click();
  await expect(dialog).toHaveAttribute("open", "");
  expect(await dialog.evaluate((element) => element.matches(":modal"))).toBe(true);
  await expect(page.locator("#basic-dialog-initial-focus")).toBeFocused();

  await page.locator("#dialog-fallback").focus();
  expect(await page.evaluate(() => document.querySelector("#basic-dialog-surface").contains(document.activeElement)))
    .toBe(true);

  for (const key of ["Tab", "Tab", "Tab", "Shift+Tab", "Shift+Tab"]) {
    await page.keyboard.press(key);
    expect(await page.evaluate(() => document.querySelector("#basic-dialog-surface").contains(document.activeElement)))
      .toBe(true);
  }

  await page.locator("#basic-dialog-close").click();
  await expect(dialog).not.toHaveAttribute("open", "");
  expect(["", "basic-dialog-invoker", "basic-dialog-close", "basic-dialog-surface", "basic-dialog-initial-focus"]).toContain(
    await page.evaluate(() => document.activeElement.id)
  );
});

test("closedby policies preserve native Escape, light dismiss, and explicit exits", async ({ page }) => {
  await loadFixture(page);

  await page.locator("#basic-dialog-invoker").click();
  await page.keyboard.press("Escape");
  await expect(page.locator("#basic-dialog-surface")).not.toHaveAttribute("open", "");

  await page.locator("#none-dialog-invoker").click();
  await page.keyboard.press("Escape");
  await expect(page.locator("#none-dialog-surface")).toHaveAttribute("open", "");
  await clickBackdrop(page, "#none-dialog-surface");
  await expect(page.locator("#none-dialog-surface")).toHaveAttribute("open", "");
  await page.locator("#none-dialog-close").click();

  await page.locator("#any-dialog-invoker").click();
  await clickBackdrop(page, "#any-dialog-surface");
  await expect(page.locator("#any-dialog-surface")).not.toHaveAttribute("open", "");
});

test("form method dialog and one nested Popover retain native behavior", async ({ page }) => {
  await loadFixture(page);
  const dialog = page.locator("#basic-dialog-surface");

  await page.locator("#basic-dialog-invoker").click();
  await page.locator("#dialog-popover-invoker").click();
  expect(await page.locator("#dialog-popover").evaluate((element) => element.matches(":popover-open")))
    .toBe(true);
  await page.locator("#dialog-popover-invoker").click();

  await page.locator("#dialog-form-submit").click();
  await expect(dialog).not.toHaveAttribute("open", "");
  await expect(dialog).toHaveJSProperty("returnValue", "saved");
  await expect(dialog.locator("dialog")).toHaveCount(0);
});

test("long, narrow, zoomed, RTL, forced-color, and reduced-motion Dialog stays bounded", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 480 },
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await loadFixture(page);
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });
  await page.locator("#long-dialog-invoker").click();

  const dialog = page.locator("#long-dialog-surface");
  const dimensions = await dialog.evaluate((element) => ({
    width: element.clientWidth,
    height: element.clientHeight,
    scrollHeight: element.scrollHeight
  }));
  expect(dimensions.width).toBeLessThanOrEqual(320);
  expect(dimensions.height).toBeLessThanOrEqual(480);
  expect(dimensions.scrollHeight).toBeLessThanOrEqual(480);
  await expect(dialog.locator('[dir="rtl"]')).toContainText("Scrollable translated content");
  await page.evaluate(() => document.documentElement.setAttribute("data-shadcn-theme", "dark"));
  const darkBackground = await page.evaluate(() =>
    getComputedStyle(document.documentElement).getPropertyValue("--shadcn-ui-background")
  );
  await page.evaluate(() => document.documentElement.setAttribute("data-shadcn-theme", "light"));
  const lightBackground = await page.evaluate(() =>
    getComputedStyle(document.documentElement).getPropertyValue("--shadcn-ui-background")
  );
  expect(darkBackground).not.toBe(lightBackground);
  expect(await dialog.evaluate((element) => getComputedStyle(element).transitionDuration))
    .toMatch(/^(0s|0\.00001s)(, 0s|, 0\.00001s)*$/);
  await context.close();
});

test("CSS-disabled, no-script, disabled-feature, and replacement outcomes remain honest", async ({ browser }) => {
  const noScriptContext = await browser.newContext({ javaScriptEnabled: false });
  const noScriptPage = await noScriptContext.newPage();
  await loadFixture(noScriptPage, { css: false });
  await noScriptPage.locator("#basic-dialog-invoker").click();
  await expect(noScriptPage.locator("#basic-dialog-surface")).toHaveAttribute("open", "");
  await noScriptPage.locator("#basic-dialog-close").click();
  await expect(noScriptPage.locator("#dialog-fallback")).toBeVisible();
  await noScriptContext.close();

  const page = await browser.newPage();
  const disabled = fixture.replaceAll(/ command="(?:show-modal|close)" commandfor="[^"]+"/g, "");
  await loadFixture(page, { css: false, html: disabled });
  await page.locator("#basic-dialog-invoker").click();
  await expect(page.locator("#basic-dialog-surface")).not.toHaveAttribute("open", "");
  await page.locator("#dialog-fallback").click();
  await expect(page).toHaveURL(/#dialog-fallback-content$/);

  await loadFixture(page);
  await page.locator("#basic-dialog-invoker").click();
  await page.locator("#basic-dialog-surface").evaluate((surface) => {
    surface.outerHTML = '<dialog id="basic-dialog-surface"><p>Replacement snapshot</p></dialog>';
  });
  await expect(page.locator("#basic-dialog-surface")).not.toHaveAttribute("open", "");
  await expect(page.getByText("Replacement snapshot")).not.toBeVisible();
  await page.close();
});

test("Alert Dialog fixes consequence semantics, cancel focus, Escape, and rejected light dismiss", async ({ page }) => {
  await loadFixture(page);
  const alert = page.locator("#delete-alert-surface");

  await page.locator("#delete-alert-invoker").click();
  await expect(alert).toHaveAttribute("open", "");
  await expect(alert).toHaveAttribute("role", "alertdialog");
  await expect(page.locator("#delete-alert-cancel")).toBeFocused();
  await clickBackdrop(page, "#delete-alert-surface");
  await expect(alert).toHaveAttribute("open", "");
  await page.keyboard.press("Escape");
  await expect(alert).not.toHaveAttribute("open", "");
});

test("Alert action, server error, pending, cancellation, fallback, and replacement stay caller-owned", async ({ page }) => {
  await loadFixture(page);
  const alert = page.locator("#delete-alert-surface");

  await page.locator("#delete-alert-invoker").click();
  await page.locator("#delete-alert-action").click();
  await expect(alert).toHaveAttribute("open", "");
  await expect(page.locator("#delete-alert-error")).toContainText("Server rejection snapshot");
  await page.locator("#delete-alert-cancel").click();
  await expect(alert).not.toHaveAttribute("open", "");
  expect(["", "delete-alert-invoker", "delete-alert-cancel", "delete-alert-surface"]).toContain(
    await page.evaluate(() => document.activeElement.id)
  );

  await page.locator("#discard-alert-invoker").click();
  await expect(page.locator("#discard-alert-action")).toBeDisabled();
  await expect(page.locator("#discard-alert-action")).toHaveAttribute("aria-busy", "true");
  await page.keyboard.press("Escape");

  await page.locator("#alert-dialog-fallback").click();
  await expect(page).toHaveURL(/#alert-dialog-fallback-content$/);

  await page.locator("#delete-alert-invoker").click();
  await alert.evaluate((surface) => {
    surface.outerHTML = '<dialog id="delete-alert-surface" role="alertdialog"><p>Rejected replacement</p></dialog>';
  });
  await expect(page.locator("#delete-alert-surface")).not.toHaveAttribute("open", "");
  await expect(page.getByText("Rejected replacement")).not.toBeVisible();
  await expect(page.locator("script")).toHaveCount(0);
});
