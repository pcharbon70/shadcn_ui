import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.progressive_navigation
// covers: shadcn_ui.gallery_presentation.responsive_article
// covers: shadcn_ui.gallery_presentation.visual_evidence

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
