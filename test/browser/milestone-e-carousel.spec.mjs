import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
import { serveMotionMediaExport } from "./support/static-motion-media.mjs";
// covers: shadcn_ui.media_components.carousel_structure
// covers: shadcn_ui.media_components.carousel_controls
// covers: shadcn_ui.media_components.carousel_layout
// covers: shadcn_ui.motion_media_gallery.accessibility_matrix
// covers: shadcn_ui.motion_media_gallery.static_media
const html = readFileSync(new URL("../fixtures/milestone_e_carousel.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
const axe = readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url), "utf8");
const evidence = JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json", import.meta.url), "utf8"));
test("exact browser lock and runtime-free deterministic fixture", async ({browser, browserName}) => {
  expect(browser.version()).toBe(evidence.engines[browserName].version);
  expect(html).not.toMatch(/<script|aria-roledescription|aria-selected|aria-live|role="(?:tab|menu|listbox)"/);
});
for (const theme of ["light", "dark"]) {
  test(`actual ${theme} reference is accessible at narrow and 200 percent zoom`, async ({page}, testInfo) => {
    await page.setViewportSize({width:390,height:844});
    await page.goto(`/components/media/carousel?theme=${theme}&motion=reduce`);
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    await page.addScriptTag({content:axe});
    const results=await page.evaluate(()=>axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}));
    expect(results.violations).toEqual([]);
    const ids=await page.locator("[id]").evaluateAll(es=>es.map(e=>e.id));
    expect(new Set(ids).size).toBe(ids.length);
    await expect(page.locator("#reference-images").getByRole("list")).toHaveCount(1);
    await expect(page.locator("#reference-images").getByRole("listitem")).toHaveCount(3);
    await page.getByRole("heading",{name:"Original local images"}).scrollIntoViewIfNeeded();
    await page.screenshot({path:testInfo.outputPath(`narrow-${theme}.png`)});
    await page.setViewportSize({width:1280,height:900});
    await page.locator("html").evaluate(e=>e.style.zoom="2");
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    const far=page.getByRole("link",{name:"Open harbor at the far edge",exact:true});
    await far.focus(); await expect(far).toBeInViewport();
    await expect(page.locator("#reference-long")).toHaveCSS("scroll-snap-type","none");
  });
}
test("wheel, touch index, native form submission and DOM replacement", async ({browser, page}) => {
  await fixture(page);
  const region=page.locator("#carousel-none");
  await region.hover(); await page.mouse.wheel(400,0);
  await expect.poll(()=>region.evaluate(e=>e.scrollLeft)).toBeGreaterThan(0);
  await page.route("**/fixture-submit?*",route=>route.fulfill({contentType:"text/html",body:"<h1>Native fixture submission</h1>"}));
  // Test-only destination: no production handler or operation.
  await page.locator("form").first().evaluate(e=>e.action="http://127.0.0.1:4106/fixture-submit");
  await page.locator("form").first().getByRole("textbox").fill("Caller value");
  await page.locator("form").first().getByRole("button").click();
  await expect(page).toHaveURL(/fixture-submit\?note=Caller\+value/);
  await fixture(page); await region.evaluate(e=>{e.scrollLeft=400;});
  await page.setContent(html); await expect(region).toHaveJSProperty("scrollLeft",0);
  const context=await browser.newContext({hasTouch:true,viewport:{width:390,height:844}});
  try {const touch=await context.newPage();await fixture(touch);
    const link=touch.locator("#carousel-none").locator("..").locator("[data-shadcn-ui-carousel-index] a").last();
    const target=await link.getAttribute("href"); await link.tap();
    await expect(touch.locator(target)).toBeFocused(); await expect(touch.locator(target)).toBeInViewport();
  } finally {await context.close();}
});
test("actual static subpath Carousel and media remain operable without JavaScript", async ({browser}) => {
  const server=await serveMotionMediaExport(["/components/media/carousel","/examples/media-browser"]);
  const context=await browser.newContext({javaScriptEnabled:false,viewport:{width:390,height:844}});
  try {const page=await context.newPage(),remote=[];
    page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    await page.goto(server.url);
    await page.getByRole("link",{name:"Reduce motion",exact:true}).click();
    await page.getByRole("link",{name:"Use dark theme"}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
    const region=page.locator("#reference-images");
    await region.locator("..").locator("[data-shadcn-ui-carousel-index] a").last().click();
    await expect(region.locator("li").last()).toBeFocused();
    await page.getByRole("link",{name:"Open the complete media browser",exact:true}).click();
    await expect(page.locator("h1")).toHaveText("Media browser");
    for (const img of await page.locator("#media-browser img").all()) {
      await img.scrollIntoViewIfNeeded(); await expect.poll(()=>img.evaluate(e=>e.complete && e.naturalWidth>0)).toBe(true);
    }
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    expect(remote).toEqual([]);
    const destination=page.locator("#media-browser a").first();
    expect((await page.request.get(new URL(await destination.getAttribute("href"),page.url()).href)).status()).toBe(200);
  } finally {await context.close();await server.close();}
});
for (const theme of ["light", "dark"]) {
  test(`actual gallery and media browser in ${theme} retain images, controls and preferences`, async ({page}, testInfo) => {
    await page.goto(`/components/media/carousel?theme=${theme}&motion=reduce`);
    await expect(page.locator('nav[aria-label="Component navigation"] a[aria-current="page"]')).toHaveText("Carousel");
    await expect(page.locator("h1")).toHaveText("Carousel");
    const form=page.locator("#reference-controls form");
    await form.getByRole("textbox").fill("Edited locally");
    await form.getByRole("checkbox").check(); await form.getByRole("button",{name:"Reset local preferences"}).click();
    await expect(form.getByRole("textbox")).toHaveValue("A landscape"); await expect(form.getByRole("checkbox")).not.toBeChecked();
    const region=page.locator("#reference-images");
    await region.locator("..").locator("[data-shadcn-ui-carousel-index] a").last().click();
    await expect(region.locator("li").last()).toBeFocused();
    await page.setViewportSize({width:1024,height:850});
    await page.getByRole("heading",{name:"Original local images"}).scrollIntoViewIfNeeded();
    await page.screenshot({path:testInfo.outputPath(`carousel-${theme}.png`)});
    await page.getByRole("link",{name:"Open the complete media browser",exact:true}).click();
    await expect(page.locator("h1")).toHaveText("Media browser");
    for (const img of await page.locator("#media-browser img").all()) {
      await img.scrollIntoViewIfNeeded();
      await expect.poll(()=>img.evaluate(e=>e.complete && e.naturalWidth>0)).toBe(true);
    }
    await page.getByRole("link",{name:"Reduce motion",exact:true}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
    await expect(page.locator("#media-browser")).toHaveCSS("scroll-behavior","auto");
  });
}
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
