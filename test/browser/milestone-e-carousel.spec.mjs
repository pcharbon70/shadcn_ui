import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
// covers: shadcn_ui.media_components.carousel_structure
// covers: shadcn_ui.media_components.carousel_controls
// covers: shadcn_ui.media_components.carousel_layout
const html = readFileSync(new URL("../fixtures/milestone_e_carousel.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
async function fixture(page, styles = true) {
  await page.setContent(html);
  if (styles) await page.addStyleTag({ content: css + ".fixture-wide{flex-basis:74rem !important}" });
}
for (const width of [1280, 390]) {
  test(`native scrolling, index and child focus at ${width}px`, async ({ page }) => {
    await page.setViewportSize({width, height: 800}); await fixture(page);
    const region = page.locator("#carousel-proximity");
    await region.focus(); await page.keyboard.press("ArrowRight");
    await expect.poll(() => region.evaluate(e => e.scrollLeft)).toBeGreaterThan(0);
    const link = region.locator("..").locator("[data-shadcn-ui-carousel-index] a").last();
    const target = await link.getAttribute("href"); await link.click();
    await expect(page.locator(target)).toBeFocused();
    await page.keyboard.press("Tab");
    // Native keyboard preferences may skip links and enter the form instead.
    await expect.poll(() => page.locator(target).evaluate(e => e.contains(document.activeElement))).toBe(true);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
    await expect(page.locator("#carousel-none")).toHaveJSProperty("scrollLeft", 0);
  });
}
test("logical snap choices, RTL and deliberately missing snap keep native content", async ({ page }) => {
  await fixture(page);
  await expect(page.locator("#carousel-none")).toHaveCSS("scroll-snap-type", "none");
  // Proximity is the initial strictness and may be omitted from CSSOM serialization.
  expect(["inline", "inline proximity"]).toContain(await page.locator("#carousel-proximity").evaluate(e => getComputedStyle(e).scrollSnapType));
  expect(await page.locator("#carousel-mandatory").evaluate(e => getComputedStyle(e).scrollSnapType)).toContain("mandatory");
  const rtl = page.locator("#rtl"); await rtl.focus(); await page.keyboard.press("ArrowLeft");
  await expect.poll(() => rtl.evaluate(e => Math.abs(e.scrollLeft))).toBeGreaterThan(0);
  await page.addStyleTag({content:"[data-shadcn-ui-carousel-scroll]{scroll-snap-type:none!important}"});
  await expect(rtl).toHaveCSS("scroll-snap-type", "none");
  await expect(rtl.getByRole("listitem")).toHaveCount(4);
});
test("oversized item and nested layout retain far-edge focus and escape", async ({ page }) => {
  await page.setViewportSize({width:390,height:800}); await fixture(page);
  await page.locator("#far-edge").focus(); await expect(page.locator("#far-edge")).toBeInViewport();
  await page.keyboard.press("Tab");
  await expect.poll(() => page.locator("#far-edge").locator("..").evaluate(e=>e.contains(document.activeElement))).toBe(false);
  await page.getByRole("link", {name:"Exit record"}).focus();
  await expect(page.getByRole("link", {name:"Exit record"})).toBeInViewport();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
});
test("ancestor and system motion suppression preserves scrolling and forced-color focus", async ({page}) => {
  await fixture(page);
  await page.locator("body").evaluate(e=>e.dataset.shadcnMotion="reduce");
  await expect(page.locator("#carousel-proximity")).toHaveCSS("scroll-behavior","auto");
  await page.locator("body").evaluate(e=>delete e.dataset.shadcnMotion);
  await page.emulateMedia({reducedMotion:"reduce", forcedColors:"active"});
  await expect(page.locator("#carousel-proximity")).toHaveCSS("scroll-behavior","auto");
  await page.locator("#carousel-proximity").focus();
  await expect(page.locator("#carousel-proximity")).toHaveCSS("outline-style","solid");
});
test("CSS-disabled list and no-script index retain every native operation", async ({browser}) => {
  const context = await browser.newContext({javaScriptEnabled:false});
  try { const page=await context.newPage(); await fixture(page,false);
    await expect(page.locator("#carousel-proximity").getByRole("listitem")).toHaveCount(6);
    await expect(page.getByRole("link",{name:"Read record 6",exact:true}).nth(1)).toBeVisible();
    await page.locator("#carousel-proximity").locator("..").getByRole("link",{name:"Record 6",exact:true}).click();
    await page.keyboard.press("Tab");
    await expect.poll(() => page.locator("#carousel-proximity li").last().evaluate(e=>e.contains(document.activeElement))).toBe(true);
  } finally {await context.close();}
});
