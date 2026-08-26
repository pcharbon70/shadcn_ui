import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
const html=readFileSync(new URL("../fixtures/milestone_e_scroll_media.html",import.meta.url),"utf8");
const css=readFileSync(new URL("../../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const evidence=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json",import.meta.url),"utf8"));
async function setup(page){await page.emulateMedia({reducedMotion:"no-preference"});await page.setContent(html);await page.addStyleTag({content:css});}
const picture=(page,id="flow")=>page.locator(`#${id} img`).first();
const transform=(page,id="flow")=>picture(page,id).evaluate(el=>{const value=getComputedStyle(el).transform;return value==="none"||new DOMMatrixReadOnly(value).isIdentity?"none":value;});
// covers: shadcn_ui.media_components.cover_flow_composition shadcn_ui.media_components.cover_flow_enhancement
test("view progress changes only images; native keys, idle and independent instances stay browser-owned",async({page,browserName})=>{
  await setup(page);
  const enhanced=evidence.engines[browserName].declarations.viewTimeline && evidence.engines[browserName].declarations.timelineScope;
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
