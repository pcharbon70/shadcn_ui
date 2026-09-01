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
const fill=(page,id)=>page.locator(`#${id}`).locator("..").locator("[data-shadcn-ui-scroll-fill]");
async function width(page,id){return fill(page,id).evaluate(el=>parseFloat(getComputedStyle(el).width));}
test("removing any joint scroll dependency retains neutral, complete native content",async({page})=>{
  for(const feature of ["animation-timeline","scroll-timeline-name","animation-range","timeline-scope"]){
    await setup(page);expect(await removeFeatureGate(page,feature)).toBeGreaterThan(0);
    await page.locator("#first").evaluate(el=>el.scrollTop=el.scrollHeight);
    expect(await width(page,"first")).toBe(0);
    expect(await fill(page,"first").evaluate(el=>el.getAnimations().length)).toBe(0);
    await expect(page.locator("#first input")).toHaveCount(12);
    await expect(page.getByRole("progressbar")).toHaveCount(0);
  }
});
test("static subpath works without scripts, including preferences and native form reset",async({browser})=>{
  const server=await serveMotionMediaExport(["/components/motion/scroll-indicator"]);
  const context=await browser.newContext({javaScriptEnabled:false,viewport:{width:390,height:844}});
  try{const page=await context.newPage();const remote=[];page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    await page.goto(server.url);await page.getByRole("link",{name:"Reduce motion",exact:true}).click();await page.getByRole("link",{name:"Use dark theme"}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
    const region=page.locator("#indicator-small");await region.focus();await page.keyboard.press("End");await expect.poll(()=>region.evaluate(el=>el.scrollTop)).toBeGreaterThan(0);
    const form=region.locator("form"),reset=form.getByRole("button");await form.getByRole("textbox").fill("Changed");await reset.focus();await page.keyboard.press("Enter");await expect(form.getByRole("textbox")).toHaveValue("A local draft");
    expect(await width(page,"indicator-small")).toBe(0);expect(remote).toEqual([]);
  }finally{await context.close();await server.close();}
});
test("touch controls, RTL scroll keys and the accessibility tree preserve native meaning",async({browser,page})=>{
  await setup(page);await page.locator("#first").evaluate(el=>el.dir="rtl");await page.locator("#first").focus();await page.keyboard.press("PageDown");
  await expect.poll(()=>page.locator("#first").evaluate(el=>el.scrollTop)).toBeGreaterThan(0);
  expect(await page.locator("#first").ariaSnapshot()).toContain('region "Notes first"');
  expect(await page.locator("main").ariaSnapshot()).not.toMatch(/progressbar|percentage/);
  const context=await browser.newContext({hasTouch:true,viewport:{width:390,height:844}});
  try{const touch=await context.newPage();await touch.goto("http://127.0.0.1:4108/components/motion/scroll-indicator");
    const form=touch.locator("#indicator-small form");await form.getByRole("textbox").fill("Touch draft");await form.getByRole("button").tap();await expect(form.getByRole("textbox")).toHaveValue("A local draft");
  }finally{await context.close();}
});
// covers: shadcn_ui.motion_components.indicator shadcn_ui.motion_components.timeline_fallback shadcn_ui.motion_components.work_budget
test("named source changes only its own decoration and stationary progress never uses the document clock",async({page,browserName,browser})=>{
  await setup(page); expect(browser.version()).toBe(evidence.engines[browserName].version);
  const enhanced=evidence.engines[browserName].declarations.scrollTimeline && evidence.engines[browserName].declarations.timelineScope;
  expect(outcomes.engines[browserName]).toMatchObject({version:browser.version(),scrollIndicator:enhanced?"enhanced":"neutral"});
  expect(await width(page,"first")).toBe(0);
  await page.locator("#first").focus(); await page.keyboard.press("End");
  await expect.poll(()=>page.locator("#first").evaluate(el=>Math.abs(el.scrollHeight-el.clientHeight-el.scrollTop))).toBeLessThan(1);
  if(enhanced) await expect.poll(()=>width(page,"first")).toBeGreaterThan(100);
  else expect(await width(page,"first")).toBe(0);
  expect(await width(page,"second")).toBe(0);expect(await width(page,"short")).toBe(0);
  const previous=await width(page,"first");await page.waitForTimeout(150);
  expect(await width(page,"first")).toBeCloseTo(previous,0);
  if(enhanced) expect(await fill(page,"first").evaluate(el=>el.getAnimations()[0].timeline.constructor.name)).not.toBe("DocumentTimeline");
  await expect(page.getByRole("progressbar")).toHaveCount(0);
});

for(const theme of ["light","dark"]) test(`real ${theme} Scroll Indicator page and composition remain accessible`,async({page},testInfo)=>{
  await page.goto(`/components/motion/scroll-indicator?theme=${theme}&motion=system`);
  await expect(page.locator("h1")).toHaveText("Scroll Indicator");
  await expect(page.locator('nav[aria-label="Component navigation"] a[aria-current="page"]')).toHaveText("Scroll Indicator");
  await page.setViewportSize({width:390,height:844});
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  await page.addScriptTag({content:axe});
  expect((await page.evaluate(()=>axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}))).violations).toEqual([]);
  const form=page.locator("#indicator-small form");await form.getByRole("textbox").fill("Edited");await form.getByRole("button").click();
  await expect(form.getByRole("textbox")).toHaveValue("A local draft");
  await page.locator("#indicator-small").scrollIntoViewIfNeeded();await page.screenshot({path:testInfo.outputPath(`indicator-${theme}.png`)});
  await page.setViewportSize({width:1280,height:900});await page.locator("html").evaluate(el=>el.style.zoom="2");
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  await page.goto(`/examples/motion-preferences?theme=${theme}&motion=reduce`);
  await expect(page.locator("#preferences-scroll")).toHaveCount(1);await expect(page.locator("#preferences-depth")).toHaveCount(1);
  await expect(page.getByRole("progressbar")).toHaveCount(0);
});
test("suppression, forced colors and CSS interruption keep neutral content",async({page})=>{
  await setup(page);
  for(const id of ["nested","none"]){await page.locator(`#${id}`).evaluate(el=>el.scrollTop=el.scrollHeight);expect(await width(page,id)).toBe(0);}
  await page.locator("#first").evaluate(el=>el.scrollTop=el.scrollHeight);
  await page.emulateMedia({reducedMotion:"reduce"});expect(await width(page,"first")).toBe(0);
  await page.emulateMedia({reducedMotion:"no-preference",forcedColors:"active"});expect(await width(page,"first")).toBe(0);
  await page.locator("style").evaluateAll(nodes=>nodes.forEach(n=>n.remove()));
  await expect(page.locator("#first").getByRole("link")).toHaveCount(12);
  expect(await page.locator("#first").evaluate(el=>el.scrollHeight<=el.clientHeight)).toBe(true);
});
test("native wheel, focused children, short content and replacement preserve usable scrolling",async({page})=>{
  await setup(page);await page.locator("#first").hover();await page.mouse.wheel(0,400);
  await expect.poll(()=>page.locator("#first").evaluate(el=>el.scrollTop)).toBeGreaterThan(0);
  await page.locator("#first input").last().focus();await expect(page.locator("#first input").last()).toBeInViewport();
  await page.keyboard.press("Tab");await expect(page.locator("#first input").last()).not.toBeFocused();
  await page.setContent(html);await page.addStyleTag({content:css});
  await expect(page.locator("#first")).toHaveJSProperty("scrollTop",0);
});
