import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.complete_migration
// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.accessibility_matrix

const axe = readFileSync(
  new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url),
  "utf8"
);

const families = [
  ["foundation", "/components/foundation/button"],
  ["forms", "/components/forms/error-summary"],
  ["disclosure", "/components/disclosure/accordion"],
  ["navigation", "/components/navigation/navigation-menu"],
  ["content-surfaces", "/components/content-surfaces/scroll-area"],
  ["overlays", "/components/overlays/dialog"],
  ["interactive-surfaces", "/components/interactive-surfaces/tooltip"],
  ["media", "/components/media/carousel"],
  ["motion", "/components/motion/scroll-indicator"]
];

const routes = [
  "/",
  ...families.map(([family]) => `/components/${family}`),
  ...families.map(([, route]) => route),
  "/examples/documentation",
  "/examples/settings",
  "/examples/image-gallery",
  "/examples/motion-preferences"
];

test("representative migrated routes retain keyboard source access and pass pinned axe", async ({page}) => {
  await page.emulateMedia({forcedColors: "active", reducedMotion: "reduce"});

  for (const [, route] of families) {
    await page.goto(`${route}?theme=dark&motion=reduce`);
    await expect(page.locator("[data-gallery-product-header]")).toBeVisible();
    const specimen = page.locator("[data-gallery-example]").first().locator("[data-gallery-specimen]");
    const code = specimen.locator('input[value="code"]');
    await code.focus();
    await page.keyboard.press("Space");
    await expect(code).toBeChecked();
    await expect(specimen.locator("[data-gallery-specimen-source]")).toBeVisible();

    await page.addScriptTag({content: axe});
    const report = await page.evaluate(async () => axe.run(document, {
      rules: {"color-contrast": {enabled: false}},
      runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag21aa"]}
    }));
    expect(report.violations, route).toEqual([]);
  }
});

test("zoomed mobile discovery and composition routes stay complete without script", async ({browser}) => {
  const context = await browser.newContext({
    javaScriptEnabled: false,
    viewport: {width: 390, height: 844},
    reducedMotion: "reduce"
  });
  const page = await context.newPage();

  for (const route of routes) {
    await page.goto(`${route}?theme=light&motion=reduce`);
    await page.locator("html").evaluate(node => { node.style.zoom = "2"; });
    await expect(page.locator("[data-gallery-main]")).toBeVisible();
    await expect(page.getByRole("heading", {level: 1})).toBeVisible();
    await expect(page.locator("[data-gallery-main] a").first()).toBeVisible();
  }

  await context.close();
});

for (const state of [
  {id: "desktop-light", theme: "light", width: 1440, height: 1200},
  {id: "desktop-dark", theme: "dark", width: 1440, height: 1200},
  {id: "mobile-light", theme: "light", width: 390, height: 844},
  {id: "mobile-dark", theme: "dark", width: 390, height: 844}
]) {
  test(`${state.id} non-disclosure family specimens match locked migration goldens`, async ({page}) => {
    await page.setViewportSize({width: state.width, height: state.height});

    for (const [family, route] of families.filter(([family]) => family !== "disclosure")) {
      await page.goto(`${route}?theme=${state.theme}&motion=reduce`);
      await page.evaluate(() => document.fonts.ready);
      const specimen = page.locator("[data-gallery-example]").first().locator("[data-gallery-specimen]");
      await specimen.scrollIntoViewIfNeeded();
      await expect(specimen).toHaveScreenshot(
        `phase7-${family}-${state.id}.png`,
        {animations: "disabled", maxDiffPixelRatio: 0.0075, threshold: 0.12}
      );
    }
  });

  test(`${state.id} disclosure specimen matches the R4-reviewed migration golden`, async ({page}) => {
    await page.setViewportSize({width: state.width, height: state.height});
    await page.goto(`/components/disclosure/accordion?theme=${state.theme}&motion=reduce`);
    await page.evaluate(() => document.fonts.ready);
    const specimen = page.locator("[data-gallery-example]").first().locator("[data-gallery-specimen]");
    await specimen.scrollIntoViewIfNeeded();
    await expect(specimen).toHaveScreenshot(
      `phase7-disclosure-${state.id}.png`,
      {animations: "disabled", maxDiffPixelRatio: 0.0075, threshold: 0.12}
    );
  });
}
