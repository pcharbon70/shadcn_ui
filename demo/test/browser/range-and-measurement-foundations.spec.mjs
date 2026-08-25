import path from "node:path";
import { fileURLToPath } from "node:url";
import { expect, test } from "@playwright/test";

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const stylesheet = path.resolve(currentDirectory, "../../../priv/static/shadcn_ui.css");

const fixture = `
  <form id="capacity-settings">
    <label for="allocation">Allocation</label>
    <input
      data-shadcn-ui
      data-shadcn-ui-slider
      id="allocation"
      name="capacity[allocation]"
      type="range"
      value="40"
      min="0"
      max="100"
      step="10"
    />
    <p id="allocation-description">Choose a percentage.</p>

    <label for="report-progress">Report generation</label>
    <progress
      data-shadcn-ui
      data-shadcn-ui-progress
      id="report-progress"
      value="4"
      max="10"
    ></progress>

    <label for="storage-meter">Storage use</label>
    <meter
      data-shadcn-ui
      data-shadcn-ui-meter
      id="storage-meter"
      value="72"
      min="0"
      max="100"
      low="60"
      high="85"
      optimum="40"
    ></meter>

    <button type="reset">Reset</button>
  </form>
`;

test.beforeEach(async ({ page }) => {
  await page.setContent(fixture);
  await page.addStyleTag({ path: stylesheet });
});

test("range keeps native label, keyboard, reset, and submission behavior", async ({ page }) => {
  const slider = page.locator("#allocation");
  await page.getByText("Allocation", { exact: true }).click();
  await expect(slider).toBeFocused();

  await page.keyboard.press("Home");
  await expect(slider).toHaveValue("0");
  await page.keyboard.press("End");
  await expect(slider).toHaveValue("100");
  await page.keyboard.press("ArrowLeft");
  await expect(slider).toHaveValue("90");
  await page.keyboard.press("ArrowRight");
  await expect(slider).toHaveValue("100");
  await page.keyboard.press("PageDown");
  expect(Number(await slider.inputValue())).toBeLessThan(100);
  const afterPageDown = Number(await slider.inputValue());
  await page.keyboard.press("PageUp");
  expect(Number(await slider.inputValue())).toBeGreaterThan(afterPageDown);

  const submitted = await page.locator("form").evaluate((form) =>
    Array.from(new FormData(form).entries())
  );
  expect(submitted).toEqual([["capacity[allocation]", await slider.inputValue()]]);

  await page.getByRole("button", { name: "Reset" }).click();
  await expect(slider).toHaveValue("40");
});

test("range keeps native pointer operation and a visible CSS-disabled floor", async ({ page }) => {
  const slider = page.locator("#allocation");
  const box = await slider.boundingBox();
  expect(box).not.toBeNull();
  await page.mouse.click(box.x + box.width * 0.75, box.y + box.height / 2);
  expect(Number(await slider.inputValue())).toBeGreaterThan(40);

  await page.setContent(fixture);
  await expect(page.locator("#allocation")).toBeVisible();
  await page.locator("#allocation").focus();
  await expect(page.locator("#allocation")).toBeFocused();
  await page.keyboard.press("ArrowRight");
  await expect(page.locator("#allocation")).toHaveValue("50");
});

test("progress and meter retain distinct native value semantics", async ({ page }) => {
  const progress = page.locator("#report-progress");
  const meter = page.locator("#storage-meter");

  await expect(progress).toHaveAttribute("value", "4");
  await expect(progress).toHaveAttribute("max", "10");
  await expect(progress).not.toHaveAttribute("low", /.*/);
  await expect(progress).not.toHaveAttribute("optimum", /.*/);

  await expect(meter).toHaveAttribute("value", "72");
  await expect(meter).toHaveAttribute("low", "60");
  await expect(meter).toHaveAttribute("high", "85");
  await expect(meter).toHaveAttribute("optimum", "40");
  expect(await page.locator("progress").count()).toBe(1);
  expect(await page.locator("meter").count()).toBe(1);
});

test("themes, RTL, forced colors, reduced motion, narrow width, and zoom remain operable", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 720 },
    forcedColors: "active",
    reducedMotion: "reduce"
  });
  const page = await context.newPage();
  await page.setContent(`<div dir="rtl" data-shadcn-theme="dark">${fixture}</div>`);
  await page.addStyleTag({ path: stylesheet });
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  for (const selector of ["#allocation", "#report-progress", "#storage-meter"]) {
    await expect(page.locator(selector)).toBeVisible();
  }

  await page.locator("#allocation").focus();
  await expect(page.locator("#allocation")).toBeFocused();
  await page.keyboard.press("ArrowLeft");
  await expect(page.locator("#allocation")).not.toHaveValue("40");
  await context.close();
});
