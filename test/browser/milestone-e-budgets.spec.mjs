import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
import {createHash} from "node:crypto";
const fixtures=JSON.parse(readFileSync(new URL("../fixtures/milestone_e_budgets.json",import.meta.url),"utf8"));
const css=readFileSync(new URL("../../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const manifest=JSON.parse(readFileSync(new URL("../../demo/priv/media/fixtures.json",import.meta.url),"utf8"));
const engines=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json",import.meta.url),"utf8")).engines;
const measured=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_budget_evidence.json",import.meta.url),"utf8"));

// covers: shadcn_ui.motion_components.work_budget shadcn_ui.motion_components.marquee_duplicates
// covers: shadcn_ui.motion_media_gallery.fixture_manifest shadcn_ui.motion_media_gallery.accessibility_matrix
for(const count of [1,8,24]) test(`${count} items: measured DOM, closed media and finite offscreen work`,async({page,browser,browserName},testInfo)=>{
  expect(browser.version()).toBe(engines[browserName].version);
  const requests=new Set();
  page.on("request",request=>requests.add(request.url()));
  await page.emulateMedia({reducedMotion:"no-preference"});
  await page.route("**/budget-fixture",route=>route.fulfill({contentType:"text/html",body:fixtures[count].replace("</head>",`<style>${css}</style></head>`)}));
  await page.goto("/budget-fixture");
  await expect.poll(()=>page.locator("img").evaluateAll(imgs=>imgs.every(img=>img.complete && img.naturalWidth>0))).toBe(true);
  const record=await page.evaluate(()=>{
    const size=selector=>document.querySelectorAll(selector).length;
    return {elements:size("*"),images:size("img"),dialogs:size("dialog"),
      carouselItems:size("[data-shadcn-ui-carousel-item]"),
      staggerItems:size("[data-shadcn-ui-stagger-item]"),
      clones:size("[data-shadcn-ui-motion-part=clone]"),
      cloneItems:size("[data-shadcn-ui-motion-part=clone] > span"),
      animatedStagger:size('[data-shadcn-ui-stagger-item][data-shadcn-ui-animated="true"]')};
  });
  expect(record.images).toBe(count*5); // Cover Flow + thumbnail/full + canonical/clone.
  expect(record.dialogs).toBe(count);
  expect(record.carouselItems).toBe(count*2);
  expect(record.staggerItems).toBe(count);
  expect(record.clones).toBe(1);expect(record.cloneItems).toBe(count);
  expect(record.animatedStagger).toBe(Math.min(count,11));
  const clone=page.locator('[data-shadcn-ui-motion-part=clone]');
  await expect(clone).toBeHidden();await expect(clone).toHaveAttribute("inert","");
  await expect(clone).toHaveAttribute("aria-hidden","true");
  await expect(clone.locator("[id],a,input,button,[tabindex]")).toHaveCount(0);
  expect(await clone.locator("img").evaluateAll(imgs=>imgs.every(i=>i.alt===""))).toBe(true);
  const ids=await page.locator("[id]").evaluateAll(nodes=>nodes.map(n=>n.id));
  expect(new Set(ids).size).toBe(ids.length);
  const media=[...requests].filter(url=>new URL(url).pathname.startsWith("/media/"));
  expect(media.length).toBe(Math.min(count,3));
  for(const url of requests) {
    expect(new URL(url).origin).toBe(new URL(page.url()).origin);
    expect(new URL(url).pathname).toMatch(/^\/(?:budget-fixture|media\/(?:ridge|harbor|grove)\.svg)$/);
  }
  let mediaBytes=0;
  for(const url of media) {
    const entry=manifest.entries.find(e=>url.endsWith("/"+e.file));expect(entry).toBeTruthy();
    const response=await page.request.get(url), bytes=await response.body();
    expect(response.ok()).toBe(true);expect(bytes.length).toBe(entry.bytes);
    expect(createHash("sha256").update(bytes).digest("hex")).toBe(entry.sha256);
    mediaBytes+=bytes.length;
  }
  // Actual durations, not wall-clock renderer speed promises. Scroll-driven
  // animations have percentage time and are separately checked in Phase 4.
  const budgets=await page.locator("#budget-stagger > *").evaluateAll(nodes=>nodes.map(el=>{
    const s=getComputedStyle(el);return {end:parseFloat(s.animationDuration)*1000+parseFloat(s.animationDelay)*1000,opacity:parseFloat(s.opacity)};
  }));
  expect(budgets.every(b=>b.end<=1000 && b.opacity>=0.49)).toBe(true);
  const input=page.locator("#budget-marquee input");await input.check();
  const timings=await page.locator("#budget-marquee ul").evaluate(el=>el.getAnimations().map(a=>a.effect.getComputedTiming()));
  expect(timings.length).toBe(1);expect(timings[0].endTime).toBeLessThanOrEqual(5000);
  expect(timings[0].iterations).toBe(1);
  // Move it genuinely offscreen; the finite effect is allowed to finish there.
  await page.locator("#budget-marquee").evaluate(el=>el.style.marginTop="200vh");
  await page.evaluate(()=>scrollTo(0,0));
  await expect.poll(()=>page.locator("#budget-marquee ul").evaluate(el=>{
    getComputedStyle(el).transform;return el.getAnimations().filter(a=>a.playState==="running").length;
  }),{timeout:6500}).toBe(0);
  await expect(clone).toBeHidden();await expect(input).toBeChecked();
  await input.uncheck();await expect(input).not.toBeChecked();
  expect(await page.locator("#budget-stagger > *").evaluateAll(nodes=>nodes.every(el=>parseFloat(getComputedStyle(el).opacity)===1))).toBe(true);
  const evidence={engine:browserName,version:browser.version(),count,...record,
    compiledCssBytes:Buffer.byteLength(css),uniqueMediaRequests:media.length,uniqueMediaBytes:mediaBytes,
    marqueeMaxMs:timings[0].endTime,staggerMaxMs:Math.max(...budgets.map(b=>b.end))};
  expect(evidence).toEqual({engine:browserName,version:measured.engines[browserName],count,
    ...measured.samples[count],compiledCssBytes:measured.compiledCssBytes,marqueeMaxMs:measured.marqueeMaxMs});
  await testInfo.attach("budget-evidence",{body:JSON.stringify(evidence,null,2),contentType:"application/json"});
  console.log("BUDGET",JSON.stringify(evidence));
});
