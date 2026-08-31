import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.presentation_system
// covers: shadcn_ui.gallery_presentation.specimen_semantics
// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.accessibility_matrix

const axe = readFileSync(
  new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url),
  "utf8"
);
const route = "/examples/documentation";
const layouts = ["centered", "start", "constrained", "tall", "overflow", "composition"];

async function openFixture(page, query = "?theme=light&motion=reduce") {
  await page.goto(`${route}${query}`);
  await page.evaluate(() => document.fonts.ready);
  const fixture = page.locator("[data-gallery-presentation-fixture]");
  await expect(fixture).toBeVisible();
  return fixture;
}

test("fixtures cover prose, every closed specimen layout, badges, support rows, and empty actions", async ({page}) => {
  const fixture = await openFixture(page);
  await expect(fixture.locator("[data-gallery-prose-fixture]")).toContainText("العربية");
  await expect(fixture.locator("[data-gallery-specimen]")).toHaveCount(6);

  for (const layout of layouts) {
    await expect(fixture.locator(`[data-gallery-specimen-layout="${layout}"]`)).toHaveCount(1);
  }

  await expect(fixture.locator("[data-gallery-capability]")).toHaveCount(4);
  await expect(fixture.locator("[data-gallery-support-table] tbody tr")).toHaveCount(2);
  await expect(fixture.locator('[data-gallery-specimen="presentation-fixture-start"] .gallery-specimen__actions')).toHaveCount(0);
  await expect(fixture.locator('[data-gallery-specimen="presentation-fixture-centered"] .gallery-specimen__actions')).toHaveCount(1);
});

test("native Preview and Code controls preserve source, copy feedback, fragments, print, and CSS-disabled access", async ({page}) => {
  await openFixture(page);
  const specimen = page.locator('[data-gallery-specimen="presentation-fixture-centered"]');
  const preview = specimen.locator("[data-gallery-specimen-preview]");
  const source = specimen.locator("[data-gallery-specimen-source]");

  await expect(preview).toBeVisible();
  await expect(source).toBeHidden();
  await specimen.locator('label[for="presentation-fixture-centered-view-code"]').click();
  await expect(source).toBeVisible();
  await expect(preview).toBeHidden();
  await expect(source.locator("code")).toContainText("deterministic-long-identifier");

  await specimen.getByRole("button", {name: "Copy source"}).click();
  await expect(specimen.locator("[aria-live=polite]")).toContainText(/Copied|Select and copy/);

  await page.goto(`${route}?theme=dark&motion=reduce#presentation-fixture-centered-source`);
  await expect(page.locator("#presentation-fixture-centered-source")).toBeVisible();

  await page.emulateMedia({media: "print"});
  await expect(page.locator("#presentation-fixture-centered-preview")).toBeVisible();
  await expect(page.locator("#presentation-fixture-centered-source")).toBeVisible();
  await page.emulateMedia({media: "screen"});

  await page.evaluate(() => {
    for (const sheet of document.styleSheets) sheet.disabled = true;
  });
  await expect(page.locator("#presentation-fixture-centered-preview")).toBeVisible();
  await expect(page.locator("#presentation-fixture-centered-source")).toBeVisible();
});

test("keyboard, zoom, forced colors, reduced motion, axe, and bounded source overflow remain usable", async ({page}) => {
  await page.emulateMedia({forcedColors: "active", reducedMotion: "reduce"});
  const fixture = await openFixture(page, "?theme=dark&motion=reduce");
  await page.evaluate(() => { document.documentElement.style.zoom = "2"; });

  const codeRadio = fixture.locator('#presentation-fixture-overflow-view-code');
  await codeRadio.focus();
  await page.keyboard.press("Space");
  await expect(codeRadio).toBeChecked();
  await expect(fixture.locator("#presentation-fixture-overflow-source")).toBeVisible();

  const source = fixture.locator("#presentation-fixture-overflow-source pre");
  const overflow = await source.evaluate(element => ({
    clientWidth: element.clientWidth,
    scrollWidth: element.scrollWidth,
    overflowX: getComputedStyle(element).overflowX
  }));
  expect(overflow.scrollWidth).toBeGreaterThanOrEqual(overflow.clientWidth);
  expect(["auto", "scroll"]).toContain(overflow.overflowX);

  await page.addScriptTag({content: axe});
  const report = await page.evaluate(async () => axe.run(document, {
    rules: {"color-contrast": {enabled: false}},
    runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"]}
  }));
  expect(report.violations).toEqual([]);
});

test("light and dark desktop and mobile presentation states match locked goldens", async ({page}) => {
  for (const state of [
    {theme: "light", width: 1440, height: 1200},
    {theme: "dark", width: 1440, height: 1200},
    {theme: "light", width: 390, height: 844},
    {theme: "dark", width: 390, height: 844}
  ]) {
    await page.setViewportSize({width: state.width, height: state.height});
    const fixture = await openFixture(page, `?theme=${state.theme}&motion=reduce`);
    await fixture.scrollIntoViewIfNeeded();
    await expect(page).toHaveScreenshot(
      `presentation-${state.width}-${state.theme}.png`,
      {animations: "disabled", maxDiffPixelRatio: 0.0075, threshold: 0.12}
    );
  }
});

test("radio selection and complete source remain available with JavaScript disabled", async ({browser}) => {
  const context = await browser.newContext({javaScriptEnabled: false, viewport: {width: 390, height: 844}});
  const page = await context.newPage();
  await openFixture(page);
  const specimen = page.locator('[data-gallery-specimen="presentation-fixture-constrained"]');
  await specimen.locator('label[for="presentation-fixture-constrained-view-code"]').click();
  await expect(specimen.locator("[data-gallery-specimen-source]")).toBeVisible();
  await expect(specimen.locator("code")).toContainText("Save translated preferences safely");
  await context.close();
});
