import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.progressive_navigation
// covers: shadcn_ui.gallery_presentation.presentation_system
// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.semantic_exceptions
// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
// covers: shadcn_ui.content_gallery.content_stress
// covers: shadcn_ui.content_gallery.browser_behavior
// covers: shadcn_ui.gallery.controller_rendered
// covers: shadcn_ui.gallery.semantic_shell
// covers: shadcn_ui.gallery.component_guidance
// covers: shadcn_ui.gallery.theme_matrix
// covers: shadcn_ui.gallery.demo_only_script

const route = "/components/disclosure/accordion";

test("R4.2 desktop and tablet preserve the pinned article grid and typography", async ({page}) => {
  for (const width of [1440, 1024]) {
    await page.setViewportSize({width, height: 1000});
    await page.goto(`${route}?theme=light&motion=reduce`);
    await page.evaluate(() => document.fonts.ready);

    const geometry = await page.evaluate(() => {
      const grid = document.querySelector("[data-gallery-documentation-grid]").getBoundingClientRect();
      const catalogue = document.querySelector("[data-gallery-catalogue]").getBoundingClientRect();
      const main = document.querySelector("[data-gallery-main]").getBoundingClientRect();
      const title = document.querySelector("[data-gallery-main] > h1");
      const description = document.querySelector(".gallery-reference__description");
      const titleStyle = getComputedStyle(title);
      const descriptionStyle = getComputedStyle(description);
      return {
        gridWidth: grid.width,
        catalogueWidth: catalogue.width,
        gap: main.left - catalogue.right,
        titleFontSize: titleStyle.fontSize,
        titleFontWeight: titleStyle.fontWeight,
        descriptionFontSize: descriptionStyle.fontSize,
        descriptionLineHeight: descriptionStyle.lineHeight,
        descriptionWidth: description.getBoundingClientRect().width,
        mainWidth: main.width
      };
    });

    expect(geometry.catalogueWidth).toBe(220);
    expect(geometry.gap).toBe(40);
    expect(geometry.gridWidth).toBe(Math.min(width, 1152));
    expect(geometry.titleFontSize).toBe("30px");
    expect(geometry.titleFontWeight).toBe("700");
    expect(geometry.descriptionFontSize).toBe("14px");
    expect(geometry.descriptionLineHeight).toBe("21px");
    expect(geometry.descriptionWidth).toBeLessThan(geometry.mainWidth);
  }
});

test("R4.2 narrow layouts keep search in the closed disclosure and bound discovery delay", async ({page}) => {
  const failures = [];

  for (const width of [320, 390]) {
    for (const theme of ["light", "dark"]) {
      await page.setViewportSize({width, height: 844});
      await page.goto(`${route}?theme=${theme}&motion=reduce`);
      await page.evaluate(() => document.fonts.ready);

      const title = page.getByRole("heading", {level: 1, name: "Accordion"});
      const firstItem = page.locator("#faq-item-accessibility");
      const disclosure = page.locator("[data-gallery-mobile-navigation]");
      const desktopCatalogue = page.locator("[data-gallery-catalogue]");
      const mobileSearch = page.locator(
        '[data-gallery-search-scope="mobile"] [data-gallery-search-input]'
      );

      await expect(disclosure).toBeVisible();
      await expect(desktopCatalogue).toBeHidden();
      await expect(mobileSearch).toBeHidden();

      const geometry = await page.evaluate(() => {
        const title = document.querySelector("[data-gallery-main] > h1").getBoundingClientRect();
        const item = document.querySelector("#faq-item-accessibility").getBoundingClientRect();
        return {
          title: {top: title.top, left: title.left},
          item: {top: item.top, left: item.left, right: item.right},
          scrollWidth: document.documentElement.scrollWidth,
          viewportWidth: innerWidth
        };
      });

      if (geometry.title.top > 110 ||
          geometry.item.top > 500 ||
          geometry.title.left < 15 ||
          geometry.item.left < 15 ||
          geometry.item.right > width - 15 ||
          geometry.scrollWidth > geometry.viewportWidth + 1) {
        failures.push({width, theme, geometry});
      }

      await expect(title).toBeVisible();
      await disclosure.locator("summary").click();
      const mobileNavigation = page.getByRole("navigation", {name: "Mobile component navigation"});
      await expect(mobileSearch).toBeVisible();
      await mobileSearch.fill("accordion");
      await expect(
        page.locator('[data-gallery-search-scope="mobile"] [data-gallery-search-status]')
      ).toHaveText("1 component found");
      await expect(mobileNavigation.locator('[aria-current="page"]')).toHaveText("Accordion");
    }
  }

  expect(failures).toEqual([]);
});

test("R4.3 visible exceptions keep local identity and native semantics", async ({page}) => {
  await page.setViewportSize({width: 1440, height: 1000});
  await page.goto(`${route}?theme=light&motion=reduce`);

  await expect(page.locator(".gallery-wordmark")).toHaveText("ShadcnUI/gallery");
  await expect(page.getByText(/script bytes shipped/i)).toHaveCount(0);
  await expect(page.locator('[data-gallery-capability-policy="authored"]')).not.toHaveCount(0);
  await expect(page.locator('[data-gallery-source-language="heex"]')).toHaveCount(2);
  await expect(page.locator('[role="tablist"], [role="tab"], [role="tabpanel"]')).toHaveCount(0);
  await expect(page.locator('.gallery-specimen__views input[type="radio"]')).toHaveCount(4);
  await expect(page.locator("#faq-sections details[open]")).toHaveCount(2);

  const specimen = page.locator('[data-gallery-specimen="accordion-primary"]');
  await specimen.locator('label[for="accordion-primary-view-code"]').click();
  const sourceStyle = await specimen.locator("[data-gallery-specimen-source]").evaluate(element => ({
    backgroundColor: getComputedStyle(element).backgroundColor,
    color: getComputedStyle(element).color,
    language: element.dataset.gallerySourceLanguage
  }));
  expect(sourceStyle).toEqual({
    backgroundColor: "rgb(36, 41, 46)",
    color: "rgb(246, 248, 250)",
    language: "heex"
  });

  await page.setViewportSize({width: 390, height: 844});
  const mobile = page.locator("[data-gallery-mobile-navigation]");
  await expect(mobile).toBeVisible();
  expect(await mobile.evaluate(element => element.tagName)).toBe("DETAILS");
  await expect(mobile.locator(":scope > summary")).toHaveText("Navigation");
});
