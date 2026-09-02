import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.shell
// covers: shadcn_ui.gallery_presentation.progressive_navigation
// covers: shadcn_ui.gallery_presentation.presentation_system
// covers: shadcn_ui.gallery_presentation.specimen_semantics
// covers: shadcn_ui.gallery_presentation.visual_evidence
// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
// covers: shadcn_ui.compatibility_accessibility.fallback_evidence
// covers: shadcn_ui.disclosure.accordion_native
// covers: shadcn_ui.disclosure.fallback
// covers: shadcn_ui.stylesheet.reduced_motion
// covers: shadcn_ui.stylesheet.content_resilience

const route = "/components/disclosure/accordion";
const epsilon = 2;

async function openAccordion(page, {width, height, zoom = 1, motion = "reduce"}) {
  await page.setViewportSize({width, height});
  await page.goto(`${route}?theme=light&motion=${motion}`);
  await page.evaluate(() => document.fonts.ready);
  if (zoom !== 1) {
    await page.locator("html").evaluate((node, value) => { node.style.zoom = String(value); }, zoom);
  }
  await expect(page.locator('[data-gallery-specimen="accordion-primary"]')).toBeVisible();
}

function seconds(value) {
  const number = Number.parseFloat(value);
  return value.trim().endsWith("ms") ? number / 1000 : number;
}

test("VR-03 summaries and focus paint stay inside their details and specimen", async ({page}) => {
  const violations = [];
  for (const state of [
    {id: "desktop", width: 1440, height: 1200},
    {id: "mobile-390", width: 390, height: 844},
    {id: "mobile-320", width: 320, height: 568},
    {id: "zoom-200", width: 320, height: 720, zoom: 2}
  ]) {
    await openAccordion(page, state);
    const specimen = page.locator('[data-gallery-specimen="accordion-primary"]');
    await specimen.scrollIntoViewIfNeeded();
    const summaries = specimen.locator("[data-shadcn-ui-accordion-summary]");

    for (const direction of ["ltr", "rtl"]) {
      await specimen.evaluate((element, value) => { element.dir = value; }, direction);

      for (let index = 0; index < await summaries.count(); index += 1) {
        const summary = summaries.nth(index);
        await summary.focus();
        const geometry = await summary.evaluate((element) => {
          const details = element.closest("details");
          const preview = element.closest("[data-gallery-specimen-preview]");
          const summaryRect = element.getBoundingClientRect();
          const detailsRect = details.getBoundingClientRect();
          const previewRect = preview.getBoundingClientRect();
          return {
            summary: {left: summaryRect.left, right: summaryRect.right},
            details: {left: detailsRect.left, right: detailsRect.right, clientWidth: details.clientWidth},
            preview: {left: previewRect.left, right: previewRect.right},
            summaryScrollWidth: element.scrollWidth,
            active: document.activeElement === element
          };
        });

        if (geometry.summary.left < geometry.details.left - epsilon ||
            geometry.summary.right > geometry.details.right + epsilon ||
            geometry.summaryScrollWidth > geometry.details.clientWidth + epsilon ||
            geometry.summary.left - 4 < geometry.preview.left - epsilon ||
            geometry.summary.right + 4 > geometry.preview.right + epsilon ||
            !geometry.active) {
          violations.push({state: state.id, direction, index, geometry});
        }
      }
    }
  }

  expect(violations).toEqual([]);
});

test("VR-02 every mobile destination can be fully revealed and visibly focused", async ({page}) => {
  test.fail(true, "R3 will remove the expected-failure marker after viewport containment lands.");

  const violations = [];
  for (const state of [
    {id: "mobile-320", width: 320, height: 568},
    {id: "mobile-390", width: 390, height: 844}
  ]) {
    await openAccordion(page, state);
    const disclosure = page.locator("[data-gallery-mobile-navigation]");
    await disclosure.locator("summary").click();
    const panel = page.locator("[data-gallery-mobile-navigation-panel]");
    const finalLink = page.getByRole("navigation", {name: "Mobile component navigation"})
      .getByRole("link", {name: "Application shell composition", exact: true});
    await panel.evaluate(element => { element.scrollTop = element.scrollHeight; });
    await finalLink.focus();

    const geometry = await finalLink.evaluate((element) => {
      const panel = element.closest("[data-gallery-mobile-navigation-panel]");
      const linkRect = element.getBoundingClientRect();
      const panelRect = panel.getBoundingClientRect();
      return {
        viewportHeight: innerHeight,
        link: {top: linkRect.top, bottom: linkRect.bottom},
        panel: {top: panelRect.top, bottom: panelRect.bottom},
        active: document.activeElement === element,
        atMaximumScroll: Math.abs(panel.scrollTop + panel.clientHeight - panel.scrollHeight) <= 1
      };
    });

    if (geometry.link.top < -epsilon ||
        geometry.link.bottom + 4 > geometry.viewportHeight + epsilon ||
        geometry.panel.bottom > geometry.viewportHeight + epsilon ||
        !geometry.active ||
        !geometry.atMaximumScroll) {
      violations.push({state: state.id, geometry});
    }
  }

  expect(violations).toEqual([]);
});

test("VR-04 and VR-07 expose the pinned Accordion affordance and row treatment", async ({page}) => {
  await openAccordion(page, {width: 1440, height: 1200, motion: "system"});
  const accordion = page.locator("#faq");
  const details = accordion.locator("details").first();
  const summary = details.locator("summary");
  const content = details.locator("[data-shadcn-ui-accordion-content]");
  await summary.hover();

  const closed = await details.evaluate(element => {
    const probe = document.createElement("span");
    probe.style.color = "var(--shadcn-ui-muted-foreground)";
    document.body.append(probe);
    const mutedColor = getComputedStyle(probe).color;
    probe.remove();
    const item = getComputedStyle(element);
    const summary = element.querySelector("summary");
    const summaryStyle = getComputedStyle(summary);
    const after = getComputedStyle(summary, "::after");
    const content = getComputedStyle(element.querySelector("[data-shadcn-ui-accordion-content]"));
    const wrapper = getComputedStyle(element.parentElement);
    return {
      rowGap: wrapper.rowGap,
      borders: [item.borderTopWidth, item.borderRightWidth, item.borderBottomWidth, item.borderLeftWidth],
      radius: item.borderRadius,
      paddingInline: [summaryStyle.paddingLeft, summaryStyle.paddingRight],
      paddingBlock: [summaryStyle.paddingTop, summaryStyle.paddingBottom],
      textDecoration: summaryStyle.textDecorationLine,
      contentColor: content.color,
      mutedColor,
      after: {content: after.content, width: after.width, height: after.height, transform: after.transform},
      transitionDuration: getComputedStyle(element, "::details-content").transitionDuration
    };
  });

  await expect(content).toBeVisible();
  await summary.click();
  await expect.poll(() => summary.evaluate(element => getComputedStyle(element, "::after").transform))
    .not.toBe(closed.after.transform);
  const openTransform = await summary.evaluate(element => getComputedStyle(element, "::after").transform);

  expect(closed.rowGap).toBe("0px");
  expect(closed.borders).toEqual(["0px", "0px", "1px", "0px"]);
  expect(closed.radius).toBe("0px");
  expect(closed.paddingInline).toEqual(["0px", "0px"]);
  expect(closed.paddingBlock).toEqual(["16px", "16px"]);
  expect(closed.textDecoration).toContain("underline");
  expect(closed.contentColor).toBe(closed.mutedColor);
  expect(["\"\"", "''"]).toContain(closed.after.content);
  expect(closed.after.width).toBe("10px");
  expect(closed.after.height).toBe("10px");
  expect(closed.after.transform).not.toBe(openTransform);
  expect(closed.transitionDuration.split(",").map(seconds)).toContain(0.25);
});

test("VR-05 direct source fragments agree with the native radio selection", async ({page}) => {
  test.fail(true, "R3 will remove the expected-failure marker after fragment/radio synchronization lands.");

  await page.goto(`${route}?theme=light&motion=reduce#accordion-primary-source`);
  await expect(page.locator("#accordion-primary-source")).toBeVisible();
  await expect(page.locator("#accordion-primary-view-code")).toBeChecked();
  await expect(page.locator("#accordion-primary-view-preview")).not.toBeChecked();

  await page.goto(`${route}?theme=light&motion=reduce#accordion-primary-preview`);
  await expect(page.locator("#accordion-primary-preview")).toBeVisible();
  await expect(page.locator("#accordion-primary-view-preview")).toBeChecked();
  await expect(page.locator("#accordion-primary-view-code")).not.toBeChecked();
});

test("VR-06 explicit and operating-system reduced motion both suppress Accordion transitions", async ({browser}) => {
  const violations = [];
  for (const state of [
    {id: "operating-system", reducedMotion: "reduce", query: "system"},
    {id: "explicit-gallery", reducedMotion: "no-preference", query: "reduce"}
  ]) {
    const context = await browser.newContext({
      reducedMotion: state.reducedMotion,
      viewport: {width: 390, height: 844}
    });
    const page = await context.newPage();
    await page.goto(`${route}?theme=light&motion=${state.query}`);
    const details = page.locator("#faq-item-billing");
    const durations = await details.evaluate(element =>
      getComputedStyle(element, "::details-content").transitionDuration
        .split(",")
        .map(value => value.trim())
    );
    await details.locator("summary").click();
    await expect(details).not.toHaveAttribute("open", "");
    if (!durations.every(value => seconds(value) <= 0.00001)) {
      violations.push({state: state.id, durations});
    }
    await context.close();
  }

  expect(violations).toEqual([]);
});

test("direct fragments and authored regions remain reachable without script or CSS", async ({browser}) => {
  const noScript = await browser.newContext({
    javaScriptEnabled: false,
    viewport: {width: 390, height: 844}
  });
  const noScriptPage = await noScript.newPage();
  await noScriptPage.goto(`${route}#accordion-primary-source`);
  await expect(noScriptPage.locator("#accordion-primary-source")).toBeVisible();
  await noScriptPage.goto(`${route}#accordion-primary-preview`);
  await expect(noScriptPage.locator("#accordion-primary-preview")).toBeVisible();
  await noScript.close();

  const cssDisabled = await browser.newContext({viewport: {width: 390, height: 844}});
  const page = await cssDisabled.newPage();
  await page.goto(`${route}#accordion-primary-source`);
  await page.evaluate(() => {
    for (const sheet of document.styleSheets) sheet.disabled = true;
  });
  await expect(page.locator("#accordion-primary-preview")).toBeVisible();
  await expect(page.locator("#accordion-primary-source")).toBeVisible();
  await cssDisabled.close();
});
