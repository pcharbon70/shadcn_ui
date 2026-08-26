import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
import {probeGalleryOrigin} from "./support/gallery-origin-probe.mjs";
import {serveMotionMediaExport} from "./support/static-motion-media.mjs";
import {removeFeatureGate} from "./support/scroll-media-fallback.mjs";
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
    const autofocus=await dialog.getAttribute("data-initial-focus-target");
    if(autofocus) expect(await page.evaluate(()=>document.activeElement.id)).toBe(autofocus);
    await page.mouse.click(1,1);await expect(dialog).toBeVisible(); // close-request is not light dismissal.
    await page.locator("#before").evaluate(el=>el.focus());
    expect(await dialog.evaluate(el=>el.contains(document.activeElement))).toBe(true);
    // Native Tab may visit browser chrome (body is then active); it must never
    // reach a focusable element in the inert page. Do not add a focus trap.
    for(let n=0;n<3;n++){await page.keyboard.press("Tab");expect(await dialog.evaluate(el=>el.contains(document.activeElement)||document.activeElement===document.body)).toBe(true);}
    await page.keyboard.press("Escape");await expect(dialog).not.toBeVisible();await expect(trigger).toBeFocused();
    await trigger.focus();await page.keyboard.press("Enter");await dialog.getByRole("button",{name:"Close image"}).click();await expect(trigger).toBeFocused();
  }
});

// covers: shadcn_ui.media_components.media_failure shadcn_ui.motion_media_gallery.static_media
test("actual static subpath works without scripts and every image/srcset remains local",async({browser})=>{
  const server=await serveMotionMediaExport(["/examples/image-gallery","/components/media/image-gallery"]);
  const context=await browser.newContext({javaScriptEnabled:false,viewport:{width:390,height:844}});
  try {
    const page=await context.newPage(),remote=[];
    page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    await page.goto(server.url);await page.getByRole("link",{name:"Reduce motion",exact:true}).click();
    await page.getByRole("link",{name:"Use dark theme"}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
    const sources=await page.locator("[data-shadcn-ui-image-gallery] img").evaluateAll(images=>images.flatMap(img=>[img.src,...(img.getAttribute("srcset")||"").split(",").filter(Boolean).map(candidate=>new URL(candidate.trim().split(/\s+/)[0],document.baseURI).href)]));
    for(const src of new Set(sources)) {
      expect(new URL(src).pathname).toMatch(/^\/shadcn_ui\/media\//);
      expect((await page.request.get(src)).status()).toBe(src.endsWith("intentionally-missing.svg")?404:200);
    }
    const gallery=page.locator("#image-collection");
    await gallery.locator("[command='show-modal']").first().click();
    const dialog=gallery.locator("dialog[open]");await expect(dialog).toBeVisible();
    await expect.poll(()=>dialog.locator("img").evaluate(el=>el.complete&&el.naturalWidth>0)).toBe(true);
    await dialog.getByRole("button",{name:"Close image"}).click();
    const link=gallery.locator("[data-shadcn-ui-gallery-destination]").first();
    const href=await link.evaluate(el=>el.href);expect(new URL(href).pathname).toMatch(/^\/shadcn_ui\/media\//);
    await link.click();await expect(page).toHaveURL(href);
    expect(remote).toEqual([]);
  } finally {await context.close();await server.close();}
});

test("absent commands, anchors and transitions retain native or ordinary complete access",async({page})=>{
  await setup(page);await removeFeatureGate(page,"anchor");await removeFeatureGate(page,"transition-behavior");
  const trigger=page.locator("#gallery [command='show-modal']").first();await trigger.click();
  const dialog=page.locator("#gallery dialog").first();await expect(dialog).toBeVisible();await dialog.getByRole("button",{name:"Close image"}).click();
  await page.locator("[command]").evaluateAll(nodes=>nodes.forEach(el=>{el.removeAttribute("command");el.removeAttribute("commandfor");}));
  await page.locator("#gallery [data-shadcn-ui-dialog-invoker]").first().click();await expect(page.locator("dialog[open]")).toHaveCount(0);
  await expect(page.locator("#gallery [data-shadcn-ui-gallery-destination]")).toHaveCount(4);
  await page.locator("#gallery [data-shadcn-ui-gallery-destination]").first().click();await expect(page).toHaveURL(/\/media\/ridge\.svg$/);
});

test("CSS-disabled native documents preserve figures, captions, commands and destinations",async({page})=>{
  await setup(page);await page.locator("style,link[rel='stylesheet']").evaluateAll(nodes=>nodes.forEach(n=>n.remove()));
  await expect(page.locator("#gallery > ul > li")).toHaveCount(4);
  await expect(page.locator("#gallery [data-shadcn-ui-gallery-destination]")).toHaveCount(4);
  await page.locator("#gallery [command='show-modal']").nth(3).click();
  const dialog=page.locator("#gallery dialog[open]");await expect(dialog).toBeVisible();
  await expect(dialog).toHaveAccessibleName("intentionally-missing");
  await expect(dialog.locator("img")).toHaveAttribute("alt","Landscape intentionally-missing");
  await expect(dialog.locator("figcaption")).toHaveText("Caption for intentionally-missing");
  await dialog.getByRole("button",{name:"Close image"}).click();await expect(page.locator("dialog[open]")).toHaveCount(0);
});

test("OS, ancestor and explicit suppression plus forced colors keep bounded visible native dialogs",async({page})=>{
  for(const mode of ["os","ancestor","explicit","forced"]) {
    await setup(page);await page.emulateMedia({reducedMotion:mode==="os"?"reduce":"no-preference",forcedColors:mode==="forced"?"active":"none"});
    if(mode==="ancestor") await page.locator("html").evaluate(el=>el.dataset.shadcnMotion="reduce");
    const root=page.locator(mode==="explicit"?"#reduced":"#gallery");
    await root.locator("[command='show-modal']").first().focus();await page.keyboard.press("Enter");const dialog=root.locator("dialog[open]");
    await expect(dialog).toBeVisible();await expect(dialog).toHaveCSS("opacity","1");
    if(mode!=="forced") expect(await dialog.evaluate(el=>el.getAnimations().length)).toBe(0);
    expect(await dialog.evaluate(el=>{const t=getComputedStyle(el).transform;return t==="none"||new DOMMatrixReadOnly(t).isIdentity;})).toBe(true);
    await dialog.getByRole("button",{name:"Close image"}).focus();
    expect(await dialog.getByRole("button",{name:"Close image"}).evaluate(el=>getComputedStyle(el).outlineStyle)).not.toBe("none");
    await page.keyboard.press("Enter");await expect(root.locator("dialog[open]")).toHaveCount(0);
  }
});

test("fresh server snapshot closes rather than restoring modal state and keeps other instances independent",async({page})=>{
  await setup(page);const snapshot=await page.locator("#gallery").evaluate(el=>el.outerHTML);
  await page.locator("#gallery [command='show-modal']").first().click();await expect(page.locator("#gallery dialog[open]")).toHaveCount(1);
  await expect(page.locator("#second dialog[open]")).toHaveCount(0);
  await page.locator("#gallery").evaluate((el,snapshot)=>el.outerHTML=snapshot,snapshot);
  await expect(page.locator("dialog[open]")).toHaveCount(0);
  await page.locator("#second [command='show-modal']").click();await expect(page.locator("#second dialog[open]")).toHaveCount(1);
  await page.keyboard.press("Escape");await page.locator("#gallery [command='show-modal']").nth(1).click();
  await expect(page.locator("#gallery dialog[open]")).toHaveAccessibleName("harbor");
});

test("touch and RTL keep thumbnail and explicit close hit targets reachable without overflow",async({browser})=>{
  const context=await browser.newContext({hasTouch:true,viewport:{width:390,height:844}});
  try {
    const page=await context.newPage();await page.goto("http://127.0.0.1:4109/examples/image-gallery?theme=dark&motion=reduce");
    await page.locator("html").evaluate(el=>el.dir="rtl");
    const root=page.locator("#image-collection"),trigger=root.locator("[command='show-modal']").nth(5);
    expect((await trigger.boundingBox()).height).toBeGreaterThanOrEqual(44);
    await trigger.tap();const dialog=root.locator("dialog[open]");await expect(dialog).toBeVisible();
    const close=dialog.getByRole("button",{name:"Close image"});await close.scrollIntoViewIfNeeded();
    const box=await close.boundingBox();expect(box.width).toBeGreaterThanOrEqual(24);expect(box.height).toBeGreaterThanOrEqual(24);
    await close.tap();await expect(root.locator("dialog[open]")).toHaveCount(0);
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    const ids=await page.locator("[id]").evaluateAll(nodes=>nodes.map(n=>n.id));expect(new Set(ids).size).toBe(ids.length);
    await expect(page.locator("button a, button button, dialog dialog")).toHaveCount(0);
  } finally {await context.close();}
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
    await trigger.click();const zoomed=page.locator("dialog[open]");await expect(zoomed).toBeVisible();
    const bounds=await zoomed.boundingBox();expect(bounds.x).toBeGreaterThanOrEqual(-1);expect(bounds.y).toBeGreaterThanOrEqual(-1);
    expect(bounds.x+bounds.width).toBeLessThanOrEqual(1281);expect(bounds.y+bounds.height).toBeLessThanOrEqual(901);
    await zoomed.getByRole("button",{name:"Close image"}).click();await expect(zoomed).toHaveCount(0);
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
