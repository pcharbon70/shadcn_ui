import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";

// covers: shadcn_ui.gallery_presentation.pinned_reference
// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.presentation_system
// covers: shadcn_ui.gallery_presentation.article_hierarchy
// covers: shadcn_ui.gallery_presentation.stable_identity
// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.accessibility_matrix

const evidence = JSON.parse(
  readFileSync(
    new URL(
      "../../demo/priv/reference/milestone_g/remediation-r5-comparison-evidence.json",
      import.meta.url,
    ),
    "utf8",
  ),
);
const referenceRoute = `http://127.0.0.1:4132${evidence.routes.reference}`;
const localRoute = evidence.routes.local;
const visualTolerance = {animations: "disabled", maxDiffPixelRatio: 0.0075, threshold: 0.12};
const states = [
  {id: "1440-light", theme: "light", width: 1440, height: 1200},
  {id: "1440-dark", theme: "dark", width: 1440, height: 1200},
  {id: "1024-light", theme: "light", width: 1024, height: 1366},
  {id: "1024-dark", theme: "dark", width: 1024, height: 1366},
  {id: "390-light", theme: "light", width: 390, height: 844},
  {id: "390-dark", theme: "dark", width: 390, height: 844},
  {id: "320-light", theme: "light", width: 320, height: 568},
  {id: "320-dark", theme: "dark", width: 320, height: 568},
];

async function openPair(browser, state) {
  const options = {
    viewport: {width: state.width, height: state.height},
    reducedMotion: "reduce",
    colorScheme: state.theme,
  };
  const referenceContext = await browser.newContext(options);
  const localContext = await browser.newContext(options);
  const remoteRequests = [];

  await referenceContext.addInitScript((theme) => localStorage.setItem("theme", theme), state.theme);
  referenceContext.on("request", (request) => {
    if (!request.url().startsWith("http://127.0.0.1:4132/")) remoteRequests.push(request.url());
  });

  const reference = await referenceContext.newPage();
  const local = await localContext.newPage();
  await reference.goto(referenceRoute);
  await local.goto(`${localRoute}?theme=${state.theme}&motion=reduce`);
  await Promise.all([
    reference.evaluate(() => document.fonts.ready),
    local.evaluate(() => document.fonts.ready),
  ]);

  return {reference, local, referenceContext, localContext, remoteRequests};
}

async function metrics(page, kind) {
  return page.evaluate((pageKind) => {
    const one = (selector) => document.querySelector(selector);
    const box = (element) => {
      const rect = element.getBoundingClientRect();
      const style = getComputedStyle(element);
      return {
        top: rect.top,
        left: rect.left,
        right: rect.right,
        width: rect.width,
        height: rect.height,
        fontSize: style.fontSize,
        fontWeight: style.fontWeight,
        lineHeight: style.lineHeight,
        borderRadius: style.borderRadius,
        backgroundColor: style.backgroundColor,
      };
    };

    const reference = pageKind === "reference";
    const header = one(reference ? "body > header" : "[data-gallery-product-header]");
    const shell = one(reference ? "body > header + div" : "[data-gallery-documentation-grid]");
    const catalogue = one(reference ? "body > header + div > aside" : "[data-gallery-catalogue]");
    const main = one(reference ? "body > header + div > main" : "[data-gallery-main]");
    const title = one(reference ? "main article h1" : "[data-gallery-main] > h1");
    const description = one(
      reference ? "main article > header > p:first-of-type" : ".gallery-reference__description",
    );
    const specimen = one(reference ? "main article figure" : '[data-gallery-specimen="accordion-primary"]');
    const accordion = reference
      ? one('details[name="acc-faq"]')?.parentElement
      : one('[data-gallery-specimen="accordion-primary"] [data-shadcn-ui-accordion]');
    const summary = accordion.querySelector("summary");

    return {
      viewport: {width: innerWidth, scrollWidth: document.documentElement.scrollWidth},
      header: box(header),
      shell: box(shell),
      catalogue: box(catalogue),
      main: box(main),
      title: box(title),
      description: box(description),
      specimen: box(specimen),
      accordion: box(accordion),
      summary: box(summary),
      catalogueVisible: getComputedStyle(catalogue).display !== "none",
    };
  }, kind);
}

async function pixelDifference(page, referenceBytes, localBytes) {
  return page.evaluate(async ({referenceSource, localSource}) => {
    const load = (source) => new Promise((resolve, reject) => {
      const image = new Image();
      image.onload = () => resolve(image);
      image.onerror = reject;
      image.src = source;
    });
    const [referenceImage, localImage] = await Promise.all([
      load(referenceSource),
      load(localSource),
    ]);
    const width = Math.min(referenceImage.width, localImage.width);
    const height = Math.min(referenceImage.height, localImage.height);
    const referenceOffset = {
      x: Math.floor((referenceImage.width - width) / 2),
      y: Math.floor((referenceImage.height - height) / 2),
    };
    const localOffset = {
      x: Math.floor((localImage.width - width) / 2),
      y: Math.floor((localImage.height - height) / 2),
    };
    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    const context = canvas.getContext("2d", {willReadFrequently: true});
    context.drawImage(
      referenceImage,
      referenceOffset.x,
      referenceOffset.y,
      width,
      height,
      0,
      0,
      width,
      height,
    );
    const referencePixels = context.getImageData(0, 0, canvas.width, canvas.height).data;
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.drawImage(
      localImage,
      localOffset.x,
      localOffset.y,
      width,
      height,
      0,
      0,
      width,
      height,
    );
    const localPixels = context.getImageData(0, 0, canvas.width, canvas.height).data;
    let changed = 0;
    const threshold = 0.12 * 255;
    for (let index = 0; index < referencePixels.length; index += 4) {
      const delta = Math.max(
        Math.abs(referencePixels[index] - localPixels[index]),
        Math.abs(referencePixels[index + 1] - localPixels[index + 1]),
        Math.abs(referencePixels[index + 2] - localPixels[index + 2]),
      );
      if (delta > threshold) changed += 1;
    }
    return {
      comparable: true,
      reference: {width: referenceImage.width, height: referenceImage.height},
      local: {width: localImage.width, height: localImage.height},
      referenceOffset,
      localOffset,
      width: canvas.width,
      height: canvas.height,
      changed,
      ratio: changed / (canvas.width * canvas.height),
    };
  }, {
    referenceSource: `data:image/png;base64,${referenceBytes.toString("base64")}`,
    localSource: `data:image/png;base64,${localBytes.toString("base64")}`,
  });
}

for (const state of states) {
  test(`${state.id} captures and compares the pinned reference with the local Accordion`, async ({browser}) => {
    const pair = await openPair(browser, state);
    const referenceMetrics = await metrics(pair.reference, "reference");
    const localMetrics = await metrics(pair.local, "local");

    expect(pair.remoteRequests).toEqual([]);
    expect(new URL(pair.reference.url()).pathname).toBe("/components/accordion/");
    expect(new URL(pair.local.url()).pathname).toBe(localRoute);
    expect(referenceMetrics.viewport.scrollWidth).toBeLessThanOrEqual(state.width + 1);
    expect(localMetrics.viewport.scrollWidth).toBeLessThanOrEqual(state.width + 1);
    expect(Math.abs(referenceMetrics.header.height - 56)).toBeLessThanOrEqual(2);
    expect(Math.abs(localMetrics.header.height - 56)).toBeLessThanOrEqual(2);
    expect(Math.abs(referenceMetrics.header.height - localMetrics.header.height)).toBeLessThanOrEqual(2);
    expect(referenceMetrics.title.fontSize).toBe("30px");
    expect(localMetrics.title.fontSize).toBe("30px");
    expect(referenceMetrics.title.fontWeight).toBe("700");
    expect(localMetrics.title.fontWeight).toBe("700");
    const accordionWidthDifference = Math.abs(
      referenceMetrics.accordion.width - localMetrics.accordion.width,
    );
    if (state.width >= 1024) {
      expect(accordionWidthDifference).toBeLessThanOrEqual(4);
    } else {
      // The reviewed local zoom/narrow exception retains 15px specimen padding
      // instead of the pin's 32px, yielding 34px more usable Accordion width.
      expect(Math.abs(accordionWidthDifference - 34)).toBeLessThanOrEqual(2);
    }
    expect(Math.abs(referenceMetrics.summary.height - localMetrics.summary.height)).toBeLessThanOrEqual(4);
    expect(Math.abs(referenceMetrics.specimen.borderRadius.replace("px", "") - 12)).toBeLessThanOrEqual(2);
    expect(Math.abs(localMetrics.specimen.borderRadius.replace("px", "") - 12)).toBeLessThanOrEqual(2);

    if (state.width >= 1024) {
      expect(referenceMetrics.catalogueVisible).toBe(true);
      expect(localMetrics.catalogueVisible).toBe(true);
      expect(referenceMetrics.catalogue.width).toBe(220);
      expect(localMetrics.catalogue.width).toBe(220);
      expect(Math.abs(referenceMetrics.main.left - referenceMetrics.catalogue.right)).toBe(40);
      expect(Math.abs(localMetrics.main.left - localMetrics.catalogue.right)).toBe(40);
    } else {
      expect(referenceMetrics.catalogueVisible).toBe(false);
      expect(localMetrics.catalogueVisible).toBe(false);
      expect(referenceMetrics.title.left).toBeGreaterThanOrEqual(19);
      expect(localMetrics.title.left).toBeGreaterThanOrEqual(19);
    }

    await expect(pair.reference).toHaveScreenshot(`r5-reference-${state.id}.png`, visualTolerance);
    await expect(pair.local).toHaveScreenshot(`r5-local-${state.id}.png`, visualTolerance);

    const referenceAccordion = pair.reference.locator('details[name="acc-faq"]').first().locator("..");
    const localAccordion = pair.local.locator(
      '[data-gallery-specimen="accordion-primary"] [data-shadcn-ui-accordion]',
    );
    const comparison = await pixelDifference(
      pair.local,
      await referenceAccordion.screenshot({animations: "disabled"}),
      await localAccordion.screenshot({animations: "disabled"}),
    );
    const recorded = evidence.states.find(({id}) => id === state.id).accordionRegion;
    expect(comparison.comparable).toBe(true);
    expect([comparison.width, comparison.height]).toEqual(recorded.comparedPixels);
    expect([comparison.reference.width, comparison.reference.height]).toEqual(recorded.referencePixels);
    expect([comparison.local.width, comparison.local.height]).toEqual(recorded.localPixels);
    expect(Math.abs(comparison.ratio - recorded.reviewedDifferenceRatio)).toBeLessThanOrEqual(0.002);
    expect(comparison.ratio).toBeLessThanOrEqual(recorded.maximumDifferenceRatio);

    await pair.referenceContext.close();
    await pair.localContext.close();
  });
}

test("code, focus and find-in-page remain comparable without scripted disclosure ownership", async ({browser}) => {
  const pair = await openPair(browser, states[0]);
  const referenceFigure = pair.reference.locator("main article figure").first();
  const localSpecimen = pair.local.locator('[data-gallery-specimen="accordion-primary"]');

  await referenceFigure.locator('label[for="view-accordion-basic-code"]').click();
  await localSpecimen.locator('label[for="accordion-primary-view-code"]').click();
  const [referenceSource, localSource] = await Promise.all([
    referenceFigure.locator("[data-code-pane]").evaluate((element) => ({
      background: getComputedStyle(element).backgroundColor,
      radius: getComputedStyle(element).borderRadius,
    })),
    localSpecimen.locator("[data-gallery-specimen-source]").evaluate((element) => ({
      background: getComputedStyle(element).backgroundColor,
      radius: getComputedStyle(element).borderRadius,
    })),
  ]);
  expect(referenceSource.background).toBe(localSource.background);

  await referenceFigure.locator('label[for="view-accordion-basic-preview"]').click();
  await localSpecimen.locator('label[for="accordion-primary-view-preview"]').click();
  const referenceSummary = referenceFigure.locator("summary").first();
  const localSummary = localSpecimen.locator("summary").first();
  await referenceSummary.focus();
  await localSummary.focus();
  const referenceOutline = Number.parseFloat(
    await referenceSummary.evaluate((element) => getComputedStyle(element).outlineWidth),
  );
  const localOutline = Number.parseFloat(
    await localSummary.evaluate((element) => getComputedStyle(element).outlineWidth),
  );
  expect(referenceOutline).toBeGreaterThanOrEqual(2);
  expect(localOutline).toBeGreaterThanOrEqual(2);
  expect(Math.abs(referenceOutline - localOutline)).toBeLessThanOrEqual(1);

  const openText = "content stays in the DOM for crawlers and find-in-page";
  const closedText = "No measuring, no JavaScript";
  expect(await pair.reference.evaluate((text) => window.find(text), openText)).toBe(true);
  expect(await pair.local.evaluate((text) => window.find(text), openText)).toBe(true);
  expect(await pair.reference.evaluate((text) => window.find(text), closedText)).toBe(true);
  expect(await pair.local.evaluate((text) => window.find(text), closedText)).toBe(true);

  expect(await pair.local.locator('[data-gallery-specimen="accordion-primary"] details[open]').count()).toBe(1);
  await pair.referenceContext.close();
  await pair.localContext.close();
});

test("Foundation category has dedicated desktop and mobile visual states", async ({page}) => {
  for (const state of [states[0], states[1], states[4], states[5]]) {
    await page.setViewportSize({width: state.width, height: state.height});
    await page.goto(`/components/foundation?theme=${state.theme}&motion=reduce`);
    await page.evaluate(() => document.fonts.ready);
    expect(new URL(page.url()).pathname).toBe("/components/foundation");
    await expect(page.getByRole("heading", {level: 1, name: "Foundation"})).toBeVisible();
    await expect(page).toHaveScreenshot(`r5-foundation-category-${state.id}.png`, visualTolerance);
  }
});
