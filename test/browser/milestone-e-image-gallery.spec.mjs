import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
import {probeGalleryOrigin} from "./support/gallery-origin-probe.mjs";
const html=readFileSync(new URL("../fixtures/milestone_e_image_gallery.html",import.meta.url),"utf8");
const css=readFileSync(new URL("../../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const axe=readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js",import.meta.url),"utf8");
const evidence=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/image_gallery_evidence.json",import.meta.url),"utf8"));
async function setup(page){await page.goto("/");await page.setContent(html);await page.addStyleTag({content:css});}
// covers: shadcn_ui.media_components.gallery_dialog shadcn_ui.media_components.gallery_origin
test("native command opens a named modal, contains focus and restores its own thumbnail",async({page})=>{
  await setup(page);
  for(const id of ["gallery","second","close-focus"]) {
    const trigger=page.locator(`#${id} [command='show-modal']`).first(),dialog=page.locator(`#${id} dialog`).first();
    await trigger.focus();await page.keyboard.press("Enter");await expect(dialog).toBeVisible();await expect(dialog).toHaveAccessibleName("ridge");
    await expect(dialog).toHaveAccessibleDescription("Enlarged image. Close to return to the thumbnail.");
    expect(await dialog.evaluate(el=>el.matches(":modal"))).toBe(true);
    expect(await dialog.evaluate(el=>el.contains(document.activeElement))).toBe(true);
    await page.locator("#before").evaluate(el=>el.focus());
    expect(await dialog.evaluate(el=>el.contains(document.activeElement))).toBe(true);
    // Native Tab may visit browser chrome (body is then active); it must never
    // reach a focusable element in the inert page. Do not add a focus trap.
    for(let n=0;n<3;n++){await page.keyboard.press("Tab");expect(await dialog.evaluate(el=>el.contains(document.activeElement)||document.activeElement===document.body)).toBe(true);}
    await page.keyboard.press("Escape");await expect(dialog).not.toBeVisible();await expect(trigger).toBeFocused();
    await trigger.focus();await page.keyboard.press("Enter");await dialog.getByRole("button",{name:"Close image"}).click();await expect(trigger).toBeFocused();
  }
});

// covers: shadcn_ui.motion_media_gallery.accessibility_matrix
for(const theme of ["light","dark"]) test(`real ${theme} reference and substantial composition are accessible and usable`,async({page},testInfo)=>{
  for(const path of ["/components/media/image-gallery","/examples/image-gallery"]) {
    await page.goto(`${path}?theme=${theme}&motion=system`);
    await expect(page.locator("h1")).toHaveText(path.startsWith("/components")?"Image Gallery":"Image gallery");
    if(path.startsWith("/components")) await expect(page.locator('nav[aria-label="Component navigation"] a[aria-current="page"]')).toHaveText("Image Gallery");
    await page.setViewportSize({width:390,height:844});
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    await page.addScriptTag({content:axe});
    expect((await page.evaluate(()=>axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}))).violations).toEqual([]);
    const trigger=page.locator("[data-shadcn-ui-image-gallery] [command='show-modal']").first();
    await trigger.click();const dialog=page.locator("dialog[open]");await expect(dialog).toBeVisible();
    await expect(dialog).toHaveCSS("opacity","1");
    expect((await page.evaluate(()=>axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}))).violations).toEqual([]);
    await page.screenshot({path:testInfo.outputPath(`${theme}-${path.startsWith("/components")?"reference":"composition"}.png`)});
    await dialog.getByRole("button",{name:"Close image"}).click();await expect(dialog).toHaveCount(0);
    await page.setViewportSize({width:1280,height:900});await page.locator("html").evaluate(el=>el.style.zoom="2");
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  }
});
test("scoped anchor and discrete transition experiment matches reviewed component evidence",async({page,browserName,browser})=>{
  await setup(page);const result=await probeGalleryOrigin(page);
  expect({version:browser.version(),...result}).toEqual(evidence.engines[browserName]);
});
test("responsive figures keep complete destinations; full images contain without nested controls",async({page})=>{
  await setup(page);
  expect(await page.locator("#gallery > ul").evaluate(el=>getComputedStyle(el).gridTemplateColumns.split(" ").length)).toBe(3);
  await page.setViewportSize({width:375,height:812});
  expect(await page.locator("#gallery > ul").evaluate(el=>getComputedStyle(el).gridTemplateColumns.split(" ").length)).toBe(1);
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  await expect(page.locator("#plain button, #plain dialog, button a, button button, dialog dialog")).toHaveCount(0);
  const trigger=page.locator("#gallery [command='show-modal']").nth(2),dialog=page.locator("#gallery dialog").nth(2);
  await trigger.focus();await page.keyboard.press("Enter");await expect(dialog.locator("figcaption")).toContainText("Complete long caption.");
  const full=dialog.locator("img");expect(await full.evaluate(el=>getComputedStyle(el).objectFit)).toBe("contain");
  expect((await full.boundingBox()).height).toBeLessThanOrEqual(812*.6+1);
  await dialog.getByRole("button",{name:"Close image"}).click();await expect(trigger).toBeFocused();
  await expect(page.locator("#gallery [data-shadcn-ui-gallery-destination]")).toHaveCount(4);
});
