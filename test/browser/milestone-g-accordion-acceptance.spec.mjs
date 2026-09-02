import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.gallery_presentation.article_hierarchy
// covers: shadcn_ui.gallery_presentation.specimen_semantics
// covers: shadcn_ui.gallery_presentation.stable_identity
// covers: shadcn_ui.gallery_presentation.accessibility_matrix
// covers: shadcn_ui.gallery_presentation.semantic_exceptions
// covers: shadcn_ui.compatibility_accessibility.capability_policy
// covers: shadcn_ui.compatibility_accessibility.fallback_evidence
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
// covers: shadcn_ui.compatibility_accessibility.evidence_separation
// covers: shadcn_ui.disclosure.accordion_native
// covers: shadcn_ui.disclosure.accordion_modes
// covers: shadcn_ui.disclosure.fallback

const route = "/components/disclosure/accordion";

test("article exposes both exact specimens, guidance, ownership, and provenance", async ({page}) => {
  await page.goto(`${route}?theme=dark&motion=reduce`);
  await expect(page.locator('[data-gallery-example="reference:accordion:exclusive"]')).toHaveCount(1);
  await expect(page.locator('[data-gallery-example="reference:accordion:independent"]')).toHaveCount(1);
  await expect(page.locator("[data-gallery-capability]")).toHaveCount(5);
  await expect(page.locator("[data-gallery-support-table] tbody tr")).toHaveCount(3);
  await expect(page.locator("[data-gallery-ownership]")).toContainText("persistence across navigation");
  await expect(page.locator("[data-gallery-provenance]")).toContainText("disclosure.accordion");
  await expect(page.getByRole("navigation", {name: "Related documentation"})).toBeVisible();

  await page.goto(`${route}?theme=dark&motion=reduce#accordion-independent-source`);
  const source = page.locator("#accordion-independent-source");
  await expect(source).toBeVisible();
  await expect(source.locator("code")).toContainText('<.accordion id="faq-sections" mode={:independent}>');
  await expect(page.locator("#accordion-independent-preview")).toBeHidden();
});

test("native activation preserves exclusive and independent grouping contracts", async ({page}) => {
  await page.goto(`${route}?theme=light&motion=reduce`);
  const billing = page.locator("#faq-item-accessibility");
  const security = page.locator("#faq-item-animation");
  const summary = security.locator("summary");
  const supportsExclusive = await page.evaluate(() => "name" in document.createElement("details"));

  await expect(billing).toHaveAttribute("open", "");
  await summary.focus();
  await expect(summary).toBeFocused();
  await page.keyboard.press("Enter");
  await expect(security).toHaveAttribute("open", "");
  if (supportsExclusive) await expect(billing).not.toHaveAttribute("open", "");
  else await expect(billing).toHaveAttribute("open", "");

  await expect(page.locator("#faq-sections-item-account")).toHaveAttribute("open", "");
  await expect(page.locator("#faq-sections-item-privacy")).toHaveAttribute("open", "");
  await page.locator("#faq-sections-item-support summary").click();
  await expect(page.locator("#faq-sections-item-support")).toHaveAttribute("open", "");
  await expect(page.locator("#faq-sections-item-account")).toHaveAttribute("open", "");
});

test("reduced motion, forced colors, zoom, CSS-disabled, and no-script states remain native", async ({browser}) => {
  const context = await browser.newContext({
    viewport: {width: 320, height: 720},
    reducedMotion: "reduce",
    forcedColors: "active"
  });
  const page = await context.newPage();
  await page.goto(`${route}?theme=dark&motion=reduce`);
  await page.locator("html").evaluate(node => { node.style.zoom = "2"; });
  await expect(page.locator("#faq-item-accessibility summary")).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
  const duration = await page.locator("#faq-item-accessibility").evaluate(details =>
    getComputedStyle(details, "::details-content").transitionDuration
  );
  expect(["0s", "0.00001s"]).toContain(duration);

  await page.evaluate(() => {
    for (const sheet of document.styleSheets) sheet.disabled = true;
  });
  await page.locator("#faq-item-animation summary").click();
  await expect(page.locator("#faq-item-animation")).toHaveAttribute("open", "");
  await context.close();

  const noScriptContext = await browser.newContext({
    javaScriptEnabled: false,
    viewport: {width: 390, height: 844}
  });
  const noScriptPage = await noScriptContext.newPage();
  await noScriptPage.goto(`${route}#accordion-primary-source`);
  await expect(noScriptPage.locator("#accordion-primary-source")).toBeVisible();
  await noScriptPage.goto(`${route}#accordion-primary`);
  await noScriptPage.locator("#faq-item-animation summary").click();
  await expect(noScriptPage.locator("#faq-item-animation")).toHaveAttribute("open", "");
  await noScriptContext.close();
});
