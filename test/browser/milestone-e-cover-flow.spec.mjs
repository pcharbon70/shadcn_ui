import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
import {removeFeatureGate} from "./support/scroll-media-fallback.mjs";
import {serveMotionMediaExport} from "./support/static-motion-media.mjs";
// covers: shadcn_ui.motion_media_gallery.accessibility_matrix shadcn_ui.motion_media_gallery.static_media
const html=readFileSync(new URL("../fixtures/milestone_e_scroll_media.html",import.meta.url),"utf8");
const css=readFileSync(new URL("../../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const evidence=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json",import.meta.url),"utf8"));
const outcomes=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/scroll_media_evidence.json",import.meta.url),"utf8"));
const axe=readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js",import.meta.url),"utf8");
async function setup(page){await page.emulateMedia({reducedMotion:"no-preference"});await page.setContent(html);await page.addStyleTag({content:css});}
const picture=(page,id="flow")=>page.locator(`#${id} img`).first();
const transform=(page,id="flow")=>picture(page,id).evaluate(el=>{const value=getComputedStyle(el).transform;return value==="none"||new DOMMatrixReadOnly(value).isIdentity?"none":value;});
test("removing each joint view dependency leaves a flat complete list, never document-time animation",async({page})=>{
  for(const feature of ["animation-timeline","view-timeline-name","animation-range","timeline-scope","transform:"]){
    await setup(page);expect(await removeFeatureGate(page,feature)).toBeGreaterThan(0);
    await page.locator("#flow").evaluate(el=>el.scrollLeft=400);
    expect(await transform(page)).toBe("none");expect(await picture(page).evaluate(el=>el.getAnimations().length)).toBe(0);
    await expect(page.locator("#flow li")).toHaveCount(6);await expect(page.locator("#flow a")).toHaveCount(6);
  }
});
test("static no-script subpath retains images, preference links and real index navigation",async({browser})=>{
  const server=await serveMotionMediaExport(["/components/media/cover-flow"]);
  const context=await browser.newContext({javaScriptEnabled:false,viewport:{width:390,height:844}});
  try{const page=await context.newPage(),remote=[];page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    await page.goto(server.url);await page.getByRole("link",{name:"Reduce motion",exact:true}).click();await page.getByRole("link",{name:"Use dark theme"}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
    const region=page.locator("#cover-reference"),lastIndex=region.locator("..").locator("[data-shadcn-ui-carousel-index] a").last();await lastIndex.focus();await page.keyboard.press("Enter");await expect(region.locator("li").last()).toBeFocused();
    for(const img of await region.locator("img").all()){await img.scrollIntoViewIfNeeded();await expect.poll(()=>img.evaluate(el=>el.complete&&el.naturalWidth>0)).toBe(true);}
    const href=await region.locator("a").first().getAttribute("href");expect((await page.request.get(new URL(href,page.url()).href)).status()).toBe(200);
    await expect(page.locator("#cover-failure img").first()).toHaveAttribute("alt","Intentionally unavailable landscape");expect(remote).toEqual([]);
  }finally{await context.close();await server.close();}
});
test("native RTL keys and touch fragment navigation keep destinations focusable",async({browser,page})=>{
  await setup(page);await page.locator("#flow").evaluate(el=>el.dir="rtl");await page.locator("#flow").focus();await page.keyboard.press("ArrowLeft");
  await expect.poll(()=>page.locator("#flow").evaluate(el=>el.scrollLeft)).toBeLessThan(0);
  const context=await browser.newContext({hasTouch:true,viewport:{width:390,height:844}});
  try{const touch=await context.newPage();await touch.goto("http://127.0.0.1:4108/components/media/cover-flow");
    const region=touch.locator("#cover-reference");await region.locator("..").locator("[data-shadcn-ui-carousel-index] a").last().tap();
    await expect(region.locator("li").last()).toBeFocused();await expect(region.locator("li").last()).toBeInViewport();
    const link=region.locator("[data-shadcn-ui-cover-destination]").last();const href=await link.getAttribute("href");await link.tap();await expect(touch).toHaveURL(new RegExp(href.replaceAll(".","\\.")+"$"));
  }finally{await context.close();}
});
// covers: shadcn_ui.media_components.cover_flow_composition shadcn_ui.media_components.cover_flow_enhancement
test("view progress changes only images; native keys, idle and independent instances stay browser-owned",async({page,browserName})=>{
  await setup(page);
  const enhanced=evidence.engines[browserName].declarations.viewTimeline && evidence.engines[browserName].declarations.timelineScope;
  expect(outcomes.engines[browserName]).toMatchObject({version:evidence.engines[browserName].version,coverFlow:enhanced?"enhanced":"flat"});
  if(enhanced) await expect.poll(()=>transform(page)).not.toBe("none");
  else expect(await transform(page)).toBe("none");
  const initial=await transform(page),other=await transform(page,"other-flow");
  await page.locator("#flow").focus();await page.keyboard.press("ArrowRight");
  await expect.poll(()=>page.locator("#flow").evaluate(el=>el.scrollLeft)).toBeGreaterThan(0);
  await page.waitForTimeout(300); // Let the native key-scroll transaction finish before the idle sample.
  await page.locator("#flow").evaluate(el=>el.scrollTo({left:400,behavior:"instant"}));
  await expect.poll(()=>page.locator("#flow").evaluate(el=>el.scrollLeft)).toBe(400);
  if(enhanced) await expect.poll(()=>transform(page)).not.toBe(initial);
  const settled=await transform(page);await page.waitForTimeout(150);expect(await transform(page)).toBe(settled);
  expect(await transform(page,"other-flow")).toBe(other);
  for(const selector of ["figcaption","[data-shadcn-ui-cover-destination]"])
    expect(await page.locator(`#flow ${selector}`).first().evaluate(el=>getComputedStyle(el).transform)).toBe("none");
  if(enhanced) expect(await picture(page).evaluate(el=>el.getAnimations()[0].timeline.constructor.name)).not.toBe("DocumentTimeline");
});

for(const theme of ["light","dark"]) test(`real ${theme} Cover Flow page and media composition are readable and accessible`,async({page},testInfo)=>{
  await page.goto(`/components/media/cover-flow?theme=${theme}&motion=system`);
  await expect(page.locator("h1")).toHaveText("Cover Flow");
  await expect(page.locator('nav[aria-label="Component navigation"] a[aria-current="page"]')).toHaveText("Cover Flow");
  await page.setViewportSize({width:390,height:844});
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  await page.addScriptTag({content:axe});expect((await page.evaluate(()=>axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}))).violations).toEqual([]);
  const last=page.locator("#cover-long [data-shadcn-ui-cover-destination]").last();await last.focus();await expect(last).toBeInViewport();
  await page.locator("#cover-reference").scrollIntoViewIfNeeded();await page.screenshot({path:testInfo.outputPath(`cover-${theme}.png`)});
  await page.setViewportSize({width:1280,height:900});await page.locator("html").evaluate(el=>el.style.zoom="2");
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  await page.goto(`/examples/media-browser?theme=${theme}&motion=reduce`);
  for(const img of await page.locator("#media-browser-depth img").all()) {await img.scrollIntoViewIfNeeded();await expect.poll(()=>img.evaluate(el=>el.complete&&el.naturalWidth>0)).toBe(true);}
  await expect(page.locator("#media-browser-notes")).toHaveCount(1);
});
test("flat, single-image, narrow, suppressed and forced-color paths retain images and destinations",async({page})=>{
  await setup(page);
  for(const id of ["flat-flow","one-flow","nested-flow"]) expect(await transform(page,id)).toBe("none");
  await page.setViewportSize({width:375,height:812});expect(await transform(page)).toBe("none");
  await expect(page.locator("#flow img")).toHaveCount(6);
  await page.setViewportSize({width:1280,height:900});await page.emulateMedia({reducedMotion:"reduce"});expect(await transform(page)).toBe("none");
  await page.emulateMedia({reducedMotion:"no-preference",forcedColors:"active"});expect(await transform(page)).toBe("none");
});
test("image decoration cannot capture destinations, captions or focus even for oversized and broken sources",async({page})=>{
  await setup(page);
  await page.locator("#flow img").first().evaluate(el=>{el.width=12000;el.height=9000;});
  const links=page.locator("#flow [data-shadcn-ui-cover-destination]");
  for(let i=0;i<6;i++){
    const link=links.nth(i);await link.focus();await expect(link).toBeInViewport();
    await expect.poll(()=>link.evaluate(el=>{const r=el.getBoundingClientRect();return document.elementFromPoint(r.x+r.width/2,r.y+r.height/2)===el;})).toBe(true);
    expect(await link.evaluate(el=>getComputedStyle(el).outlineStyle)).not.toBe("none");
  }
  expect(await picture(page).evaluate(el=>getComputedStyle(el).pointerEvents)).toBe("none");
  await expect(page.locator("#flow img").last()).toHaveAttribute("alt","Landscape 6");
  await page.locator("style").evaluateAll(nodes=>nodes.forEach(n=>n.remove()));
  await expect(links).toHaveCount(6);await expect(page.locator("#flow ol")).toHaveCount(1);
  await page.locator("#after").focus();
  await page.addStyleTag({content:css});
  await page.locator("#flow").evaluate(el=>el.replaceWith(el.cloneNode(true)));
  await expect(page.locator("#flow")).toHaveJSProperty("scrollLeft",0);
});
