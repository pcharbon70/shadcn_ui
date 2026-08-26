import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
const html=readFileSync(new URL("../fixtures/milestone_e_scroll_media.html",import.meta.url),"utf8");
const css=readFileSync(new URL("../../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const evidence=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json",import.meta.url),"utf8"));
async function setup(page){await page.emulateMedia({reducedMotion:"no-preference"});await page.setContent(html);await page.addStyleTag({content:css});}
const fill=(page,id)=>page.locator(`#${id}`).locator("..").locator("[data-shadcn-ui-scroll-fill]");
async function width(page,id){return fill(page,id).evaluate(el=>parseFloat(getComputedStyle(el).width));}
// covers: shadcn_ui.motion_components.indicator shadcn_ui.motion_components.timeline_fallback shadcn_ui.motion_components.work_budget
test("named source changes only its own decoration and stationary progress never uses the document clock",async({page,browserName,browser})=>{
  await setup(page); expect(browser.version()).toBe(evidence.engines[browserName].version);
  const enhanced=evidence.engines[browserName].declarations.scrollTimeline && evidence.engines[browserName].declarations.timelineScope;
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
