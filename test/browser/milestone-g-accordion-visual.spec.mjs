import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.presentation_system
// covers: shadcn_ui.gallery_presentation.responsive_article
// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.disclosure.accordion_modes

const route = "/components/disclosure/accordion";
const tolerance = {animations: "disabled", maxDiffPixelRatio: 0.0075, threshold: 0.12};

async function openAccordion(page, state) {
  await page.setViewportSize({width: state.width, height: state.height});
  await page.goto(`${route}?theme=${state.theme}&motion=reduce`);
  await page.evaluate(() => document.fonts.ready);
  await expect(page.locator("[data-gallery-component-article]")).toBeVisible();
}

for (const state of [
  {id: "desktop", width: 1440, height: 1200},
  {id: "tablet", width: 1024, height: 1366}
]) {
  for (const theme of ["light", "dark"]) {
    test(`${state.id} ${theme} article matches the approved pilot`, async ({page}) => {
      await openAccordion(page, {...state, theme});
      await expect(page).toHaveScreenshot(`accordion-${state.id}-${theme}.png`, tolerance);
      if (state.id === "desktop") {
        const support = page.locator("[data-gallery-component-support]");
        await support.scrollIntoViewIfNeeded();
        await expect(support).toHaveScreenshot(`accordion-support-${theme}.png`, tolerance);
      }
    });
  }
}

for (const theme of ["light", "dark"]) {
  test(`390px ${theme} open-panel and navigation states match the approved pilot`, async ({page}) => {
    await openAccordion(page, {width: 390, height: 844, theme});
    const specimen = page.locator('[data-gallery-specimen="accordion-primary"]');
    await specimen.scrollIntoViewIfNeeded();
    await specimen.locator("#faq-item-security summary").click();
    await expect(specimen).toHaveScreenshot(`accordion-390-panel-${theme}.png`, tolerance);

    const navigation = page.locator("[data-gallery-mobile-navigation]");
    await navigation.locator("summary").click();
    await expect(page).toHaveScreenshot(`accordion-390-navigation-${theme}.png`, tolerance);
  });

  test(`320px ${theme} long source remains bounded`, async ({page}) => {
    await openAccordion(page, {width: 320, height: 568, theme});
    const specimen = page.locator('[data-gallery-specimen="accordion-primary"]');
    await specimen.locator('label[for="accordion-primary-view-code"]').click();
    await specimen.scrollIntoViewIfNeeded();
    await expect(specimen).toHaveScreenshot(`accordion-320-source-${theme}.png`, tolerance);
  });
}
