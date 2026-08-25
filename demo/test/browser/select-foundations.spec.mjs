import path from "node:path";
import { fileURLToPath } from "node:url";
import { expect, test } from "@playwright/test";

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const stylesheet = path.resolve(currentDirectory, "../../../priv/static/shadcn_ui.css");

const fixture = `
  <form id="profile">
    <label for="native-country">Country</label>
    <select
      data-shadcn-ui
      data-shadcn-ui-select
      id="native-country"
      name="profile[country]"
      required
    >
      <option value="" disabled selected>Choose a country</option>
      <optgroup label="North America">
        <option value="ca">Canada</option>
        <option value="us">United States</option>
      </optgroup>
      <optgroup label="Europe">
        <option value="fr">France</option>
        <option value="de">Germany</option>
      </optgroup>
    </select>

    <label for="enhanced-country">Timezone reference country</label>
    <select
      data-shadcn-ui
      data-shadcn-ui-select
      data-shadcn-ui-enhanced-select="true"
      id="enhanced-country"
      name="profile[timezone]"
    >
      <button data-shadcn-ui-select-button><selectedcontent></selectedcontent></button>
      <option value="ca" selected>Canada</option>
      <option value="fr">France</option>
    </select>

    <label for="enhanced-regions">Operational regions</label>
    <select
      data-shadcn-ui
      data-shadcn-ui-select
      data-shadcn-ui-enhanced-select="true"
      id="enhanced-regions"
      name="profile[regions][]"
      multiple
    >
      <option value="ca" selected>Canada</option>
      <option value="us">United States</option>
      <option value="fr" selected>France</option>
    </select>

    <button type="reset">Reset</button>
    <button type="submit">Submit</button>
  </form>
`;

test.beforeEach(async ({ page }) => {
  await page.setContent(fixture);
  await page.addStyleTag({ path: stylesheet });
});

test("native labels, keys, validation, reset, and submitted values remain authoritative", async ({ page }) => {
  const native = page.locator("#native-country");
  await page.getByText("Country", { exact: true }).click();
  await expect(native).toBeFocused();
  expect(await native.evaluate((select) => select.checkValidity())).toBe(false);

  await native.click();
  await page.keyboard.press("Escape");
  await expect(native).toBeFocused();

  await page.keyboard.press("ArrowDown");
  await expect(native).toHaveValue("ca");
  expect(await native.evaluate((select) => select.checkValidity())).toBe(true);

  await page.locator("#enhanced-country").click();
  await page.keyboard.press("Escape");
  await page.locator("#enhanced-country").selectOption("fr");
  await page.locator("#enhanced-regions").selectOption(["us", "fr"]);

  const submitted = await page.locator("form").evaluate((form) =>
    Array.from(new FormData(form).entries())
  );

  expect(submitted).toEqual([
    ["profile[country]", "ca"],
    ["profile[timezone]", "fr"],
    ["profile[regions][]", "us"],
    ["profile[regions][]", "fr"]
  ]);

  await page.getByRole("button", { name: "Reset" }).click();
  await expect(native).toHaveValue("");
  await expect(page.locator("#enhanced-country")).toHaveValue("ca");
  await expect(page.locator("#enhanced-regions")).toHaveValues(["ca", "fr"]);
});

test("enhancement follows capability detection and CSS-disabled fallback stays visible", async ({ page }) => {
  const capability = await page.evaluate(() =>
    CSS.supports("appearance", "base-select") &&
      CSS.supports("selector(::picker(select))")
  );

  const appearance = await page.locator("#enhanced-country").evaluate(
    (select) => getComputedStyle(select).appearance
  );

  expect(appearance).toBe(capability ? "base-select" : "auto");
  await expect(page.locator("#enhanced-country")).toBeVisible();
  await expect(page.locator("#enhanced-regions")).toBeVisible();

  await page.setContent(fixture);
  await expect(page.locator("#enhanced-country")).toBeVisible();
  await page.locator("#enhanced-country").focus();
  await expect(page.locator("#enhanced-country")).toBeFocused();
  await page.locator("#enhanced-country").selectOption("fr");
  await expect(page.locator("#enhanced-country")).toHaveValue("fr");
});

test("themes, forced colors, narrow layout, and zoom retain visible native controls", async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 320, height: 720 },
    forcedColors: "active"
  });
  const page = await context.newPage();
  await page.setContent(`<div data-shadcn-theme="dark">${fixture}</div>`);
  await page.addStyleTag({ path: stylesheet });
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  for (const selector of ["#native-country", "#enhanced-country", "#enhanced-regions"]) {
    await expect(page.locator(selector)).toBeVisible();
  }

  await page.locator("#enhanced-country").focus();
  await expect(page.locator("#enhanced-country")).toBeFocused();
  await context.close();
});
