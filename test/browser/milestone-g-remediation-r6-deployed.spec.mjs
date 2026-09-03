import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.progressive_navigation
// covers: shadcn_ui.gallery_presentation.stable_identity
// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
// covers: shadcn_ui.disclosure.accordion_native
// covers: shadcn_ui.release_publication.deployed_runtime

const expectedRevision = process.env.SHADCN_UI_EXPECTED_REVISION;
const route = "/components/disclosure/accordion";
const epsilon = 2;

if (!/^[0-9a-f]{40}$/.test(expectedRevision ?? "")) {
  throw new Error("SHADCN_UI_EXPECTED_REVISION must be a full revision");
}

test("deployed 320px navigation and Accordion geometry match the reviewed revision", async ({page}) => {
  await page.setViewportSize({width: 320, height: 720});

  const health = await (await page.request.get("/healthz")).json();
  expect(health.status).toBe("ok");
  expect(health.identity.buildRevision).toBe(expectedRevision);

  await page.goto(`${route}?theme=light&motion=reduce`);
  await page.evaluate(() => document.fonts.ready);
  await expect(page.getByRole("heading", {level: 1, name: "Accordion"})).toBeVisible();

  const disclosure = page.locator("[data-gallery-mobile-navigation]");
  await expect(disclosure).toBeVisible();
  await disclosure.locator(":scope > summary").click();

  const navigation = page.getByRole("navigation", {name: "Mobile component navigation"});
  const finalLink = navigation.getByRole("link", {
    name: "Application shell composition",
    exact: true
  });
  const panel = page.locator("[data-gallery-mobile-navigation-panel]");

  await expect(navigation.locator("[data-gallery-search-item]")).toHaveCount(41);
  await panel.evaluate(element => { element.scrollTop = element.scrollHeight; });
  await finalLink.focus();

  const navigationGeometry = await finalLink.evaluate(element => {
    const panel = element.closest("[data-gallery-mobile-navigation-panel]");
    const linkRect = element.getBoundingClientRect();
    const panelRect = panel.getBoundingClientRect();
    return {
      viewportHeight: innerHeight,
      linkTop: linkRect.top,
      linkBottom: linkRect.bottom,
      panelBottom: panelRect.bottom,
      active: document.activeElement === element,
      atMaximumScroll: Math.abs(panel.scrollTop + panel.clientHeight - panel.scrollHeight) <= 1
    };
  });

  expect(navigationGeometry.linkTop).toBeGreaterThanOrEqual(-epsilon);
  expect(navigationGeometry.linkBottom + 4).toBeLessThanOrEqual(
    navigationGeometry.viewportHeight + epsilon
  );
  expect(navigationGeometry.panelBottom).toBeLessThanOrEqual(
    navigationGeometry.viewportHeight + epsilon
  );
  expect(navigationGeometry.active).toBe(true);
  expect(navigationGeometry.atMaximumScroll).toBe(true);

  await page.keyboard.press("Escape");
  const specimen = page.locator('[data-gallery-specimen="accordion-primary"]');
  await specimen.scrollIntoViewIfNeeded();
  const summary = specimen.locator("[data-shadcn-ui-accordion-summary]").first();
  await summary.focus();

  const accordionGeometry = await summary.evaluate(element => {
    const details = element.closest("details");
    const preview = element.closest("[data-gallery-specimen-preview]");
    const summaryRect = element.getBoundingClientRect();
    const detailsRect = details.getBoundingClientRect();
    const previewRect = preview.getBoundingClientRect();
    return {
      summaryLeft: summaryRect.left,
      summaryRight: summaryRect.right,
      detailsLeft: detailsRect.left,
      detailsRight: detailsRect.right,
      previewLeft: previewRect.left,
      previewRight: previewRect.right,
      summaryScrollWidth: element.scrollWidth,
      detailsClientWidth: details.clientWidth,
      documentScrollWidth: document.documentElement.scrollWidth,
      viewportWidth: innerWidth,
      active: document.activeElement === element
    };
  });

  expect(accordionGeometry.summaryLeft).toBeGreaterThanOrEqual(
    accordionGeometry.detailsLeft - epsilon
  );
  expect(accordionGeometry.summaryRight).toBeLessThanOrEqual(
    accordionGeometry.detailsRight + epsilon
  );
  expect(accordionGeometry.summaryScrollWidth).toBeLessThanOrEqual(
    accordionGeometry.detailsClientWidth + epsilon
  );
  expect(accordionGeometry.summaryLeft - 4).toBeGreaterThanOrEqual(
    accordionGeometry.previewLeft - epsilon
  );
  expect(accordionGeometry.summaryRight + 4).toBeLessThanOrEqual(
    accordionGeometry.previewRight + epsilon
  );
  expect(accordionGeometry.documentScrollWidth).toBeLessThanOrEqual(
    accordionGeometry.viewportWidth + 1
  );
  expect(accordionGeometry.active).toBe(true);
});

test("deployed category, themes, and direct Accordion views remain addressable", async ({page}) => {
  await page.setViewportSize({width: 390, height: 844});

  await page.goto("/components/foundation?theme=dark&motion=reduce");
  await expect(page.getByRole("heading", {level: 1, name: "Foundation"})).toBeVisible();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "dark");

  await page.goto(`${route}?theme=dark&motion=reduce#accordion-primary-source`);
  await expect(page.locator("#accordion-primary-source")).toBeVisible();
  await expect(page.locator("#accordion-primary-view-code")).toBeChecked();
  await expect(page.locator("#accordion-primary-view-preview")).not.toBeChecked();

  await page.locator('label[for="accordion-primary-view-preview"]').click();
  await expect(page.locator("#accordion-primary-view-preview")).toBeChecked();
  await expect(page).toHaveURL(/#accordion-primary-preview$/);

  await page.goto(`${route}?theme=dark&motion=reduce#accordion-primary-preview`);
  await expect(page.locator("#accordion-primary-preview")).toBeVisible();
  await expect(page.locator("#accordion-primary-view-preview")).toBeChecked();
  await expect(page.locator("#accordion-primary-view-code")).not.toBeChecked();

  await page.getByRole("button", {name: "Light"}).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");

  await page.goto(`${route}?theme=light&motion=reduce#accordion-primary-preview`);
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", "light");
  await expect(page.locator("#accordion-primary-preview")).toBeVisible();
});
