import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.article_hierarchy
// covers: shadcn_ui.gallery_presentation.specimen_semantics
// covers: shadcn_ui.gallery_presentation.stable_identity
// covers: shadcn_ui.gallery_presentation.accessibility_matrix

const axe = readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url), "utf8");

test("representative article permutations keep stable requirement-level structure", async ({page}) => {
  for (const route of [
    "/components/forms/error-summary",
    "/components/forms/enhanced-select",
    "/components/overlays/dialog"
  ]) {
    await page.goto(`${route}?theme=dark&motion=reduce`);
    await expect(page.getByRole("heading", {level: 1})).toHaveCount(1);
    await expect(page.locator("[data-gallery-component-article]")).toHaveCount(1);
    await expect(page.locator("[data-gallery-example]")).toHaveCount(1);
    await expect(page.locator("[data-gallery-how-it-works]")).toBeVisible();
    await expect(page.locator("[data-gallery-component-support]")).toBeVisible();
    await expect(page.locator("[data-gallery-ownership]")).toBeVisible();
    await expect(page.getByRole("navigation", {name: "Related documentation"})).toBeVisible();
    await expect(page.locator("[data-gallery-provenance]")).toContainText("Catalogue identity");
    await expect(page.locator("main [role=tab], main [role=tabpanel], main [role=menu]")).toHaveCount(0);
  }

  await page.goto("/components/forms/enhanced-select");
  await expect(page.locator("[data-gallery-ownership]")).toContainText("Choosing the related control");
  await page.goto("/components/overlays/dialog");
  await expect(page.locator('[data-gallery-capability="progressive-enhancement"]')).toBeVisible();
  await expect(page.locator("#ordinary-alternative")).toBeVisible();
  await page.goto("/examples/documentation");
  expect(await page.locator("[data-gallery-presentation-fixture] [data-gallery-specimen]").count()).toBeGreaterThan(1);
});

test("preview and source fragments focus useful regions and create history entries", async ({page}) => {
  await page.goto("/components/forms/error-summary");
  const example = page.locator('[data-gallery-example="reference:error_summary"]');
  const source = example.locator("[data-gallery-specimen-source]");
  const preview = example.locator("[data-gallery-specimen-preview]");
  const initialHistory = await page.evaluate(() => history.length);

  await expect(preview).toBeVisible();
  await expect(source).toBeHidden();
  await example.getByRole("link", {name: "Code link"}).click();
  await expect(page).toHaveURL(/#error-summary-primary-source$/);
  await expect(source).toBeFocused();
  await expect(source).toBeVisible();
  await expect(source.locator("code")).toHaveText('<.error_summary id="errors" heading="Review the form" errors={[{"email", "Enter an email"}]} />');
  expect(await page.evaluate(() => history.length)).toBe(initialHistory + 1);

  await example.getByRole("link", {name: "Preview link"}).click();
  await expect(page).toHaveURL(/#error-summary-primary$/);
  await expect(example).toBeFocused();
  await expect(preview).toBeVisible();
  await expect(source).toBeHidden();
  await page.goBack();
  await expect(page).toHaveURL(/#error-summary-primary-source$/);
  await expect(source).toBeVisible();

  await expect(example.getByRole("button", {name: "Copy source"})).toHaveAttribute("data-gallery-copy", "error-summary-primary-code");
  await expect(page.getByRole("navigation", {name: "Related documentation"}).locator("a")).not.toHaveCount(0);
});

test("no-script, print, keyboard, axe, zoom, and long source preserve access", async ({browser, page}) => {
  await page.goto("/components/media/image-gallery?theme=dark&motion=reduce");
  const example = page.locator("[data-gallery-example]");
  const codeRadio = example.locator('input[value="code"]');
  await codeRadio.focus();
  await page.keyboard.press("Space");
  await expect(codeRadio).toBeChecked();
  const pre = example.locator("pre");
  expect(await pre.evaluate(node => node.scrollWidth)).toBeGreaterThanOrEqual(await pre.evaluate(node => node.clientWidth));

  await page.emulateMedia({media: "print"});
  await expect(example.locator("[data-gallery-specimen-preview]")).toBeVisible();
  await expect(example.locator("[data-gallery-specimen-source]")).toBeVisible();
  await page.emulateMedia({media: "screen"});

  await page.setViewportSize({width: 320, height: 720});
  await page.locator("html").evaluate(node => { node.style.zoom = "2"; });
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
  await page.addScriptTag({content: axe});
  const violations = await page.evaluate(async () => (await axe.run(document, {
    rules: {"color-contrast": {enabled: false}},
    runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"]}
  })).violations.map(({id, nodes}) => ({id, targets: nodes.map(node => node.target)})));
  expect(violations).toEqual([]);

  const context = await browser.newContext({javaScriptEnabled: false, viewport: {width: 390, height: 844}});
  const noScriptPage = await context.newPage();
  await noScriptPage.goto("/components/forms/error-summary");
  const noScriptExample = noScriptPage.locator("[data-gallery-example]");
  await noScriptExample.locator('label[for="error-summary-primary-view-code"]').click();
  await expect(noScriptExample.locator("[data-gallery-specimen-source]")).toBeVisible();
  await expect(noScriptExample.locator("code")).toContainText("<.error_summary");
  await context.close();
});
