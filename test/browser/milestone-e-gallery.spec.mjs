import {test,expect} from "../../demo/node_modules/@playwright/test/index.mjs";
import {readFileSync} from "node:fs";
import {serveMotionMediaExport} from "./support/static-motion-media.mjs";
const leaves=["media/carousel","media/cover-flow","media/image-gallery","motion/marquee","motion/stagger","motion/scroll-indicator"];
const routes=[...leaves.map(leaf=>`/components/${leaf}`),...["media-browser","image-gallery","motion-preferences","motion-media-capabilities"].map(slug=>`/examples/${slug}`)];
const axe=readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js",import.meta.url),"utf8");
const evidence=JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json",import.meta.url),"utf8"));
const canonical="https://leco-industries-inc.github.io/shadcn_ui";
test.setTimeout(120_000);

// covers: shadcn_ui.motion_media_gallery.references shadcn_ui.motion_media_gallery.compositions
// covers: shadcn_ui.motion_media_gallery.accessibility_matrix
for(const theme of ["light","dark"]) test(`${theme}: all E references and compositions have accessible native content`,async({page},testInfo)=>{
  for(const path of routes) {
    await page.setViewportSize({width:390,height:844});
    await page.goto(`${path}?theme=${theme}&motion=reduce`);
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme",theme);
    expect(await page.getByRole("navigation",{name:"Motion inspection",exact:true}).evaluate(el=>parseFloat(getComputedStyle(el).gap))).toBeGreaterThan(0);
    await expect(page.getByRole("main")).toHaveCount(1);
    await expect(page.getByRole("heading",{level:1})).toHaveCount(1);
    const nav=page.getByRole("navigation",{name:"Component navigation",exact:true});
    await expect(nav.locator('[aria-current="page"]')).toHaveCount(1);
    await expect(nav.locator('[aria-current="page"]')).toHaveAttribute("href",path);
    await expect(page.locator('link[rel="canonical"]')).toHaveAttribute("href",canonical+path);
    if(path.startsWith("/components/")) {
      await expect(page.getByRole("heading",{name:"HEEX source",exact:true})).toBeVisible();
      expect(await page.locator("pre code").last().textContent()).toContain("<.");
    } else await expect(page.getByRole("navigation",{name:"Breadcrumb"})).toContainText(await page.locator("h1").textContent());
    const ids=await page.locator("[id]").evaluateAll(nodes=>nodes.map(n=>n.id));expect(new Set(ids).size).toBe(ids.length);
    expect(await page.locator("main img").evaluateAll(images=>images.every(img=>img.hasAttribute("alt")&&img.width>0&&img.height>0))).toBe(true);
    await expect(page.locator('main [role="tab"],main [role="menu"],main [role="progressbar"],main [aria-selected]')).toHaveCount(0);
    await page.addScriptTag({content:axe});
    const violations=await page.evaluate(async()=> (await axe.run(document,{runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}})).violations.map(v=>({id:v.id,nodes:v.nodes.map(n=>n.target)})));
    expect(violations,path).toEqual([]);
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
    await page.setViewportSize({width:1280,height:900});
    await page.locator("html").evaluate(el=>el.style.zoom="2");
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1)).toBe(true);
  }
  await page.screenshot({path:testInfo.outputPath(`capabilities-${theme}-zoom.png`)});
});

// covers: shadcn_ui.motion_media_gallery.capability_evidence shadcn_ui.motion_media_gallery.motion_inspection
test("exact evidence and native preferences never override operating-system reduction",async({page,browser,browserName})=>{
  expect(browser.version()).toBe(evidence.engines[browserName].version);
  await page.goto("/examples/motion-media-capabilities");
  for(const engine of Object.values(evidence.engines)) await expect(page.getByRole("columnheader",{name:new RegExp(engine.version.replaceAll(".","\\."))})).toBeVisible();
  await expect(page.locator("main")).toContainText("Release presentation: native snap");
  await expect(page.locator("main")).toContainText("Generated scroll controls");
  await page.emulateMedia({reducedMotion:"reduce"});
  await page.goto("/examples/motion-preferences?theme=dark&motion=system");
  await expect(page.locator("#preferences-preview input")).toBeHidden();
  await expect.poll(()=>page.locator("#preferences-stagger").evaluate(el=>el.getAnimations({subtree:true}).length)).toBe(0);
  await page.getByRole("navigation",{name:"Motion inspection",exact:true}).getByRole("link",{name:"Reduce motion",exact:true}).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
  await page.goto("/examples/motion-preferences?theme=untrusted&motion=force");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","light");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","system");
  await expect(page.locator("#preferences-preview input")).toBeHidden();
});

// covers: shadcn_ui.motion_media_gallery.compositions shadcn_ui.motion_media_gallery.accessibility_matrix
test("real compositions perform native index, modal close and local reset operations",async({page})=>{
  await page.goto("/examples/media-browser?motion=reduce");
  const index=page.locator('a[href^="#shadcn-ui-"]').first();
  const target=await index.getAttribute("href");await index.click();
  await expect(page.locator(target)).toBeFocused();
  await page.goto("/examples/image-gallery?motion=reduce");
  const invoker=page.locator('#image-collection [command="show-modal"]').first();
  await invoker.focus();await page.keyboard.press("Enter");
  const modal=page.locator("dialog[open]");await expect(modal).toHaveCount(1);
  expect(await modal.evaluate(el=>el.matches(":modal"))).toBe(true);
  await page.keyboard.press("Escape");await expect(invoker).toBeFocused();
  await invoker.press("Enter");await page.locator("dialog[open]").getByRole("button",{name:"Close image",exact:true}).click();
  await expect(invoker).toBeFocused();
  await page.goto("/examples/motion-preferences");
  const input=page.locator("#preferences-preview input");await input.focus();await page.keyboard.press("Space");await expect(input).toBeChecked();
  await page.keyboard.press("Space");await expect(input).not.toBeChecked();
  await page.getByRole("textbox",{name:"Local reading note"}).fill("Unsaved local state");
  await page.getByRole("button",{name:"Reset local note",exact:true}).click();
  await expect(page.getByRole("textbox",{name:"Local reading note"})).toHaveValue("Explore at your pace");
});

// covers: shadcn_ui.motion_media_gallery.static_media shadcn_ui.motion_media_gallery.motion_inspection
test("all E static subpaths retain no-script theme links and complete CSS-disabled content",async({browser})=>{
  const server=await serveMotionMediaExport(routes);
  const context=await browser.newContext({javaScriptEnabled:false,viewport:{width:390,height:844}});
  try {
    const page=await context.newPage(),remote=[];
    page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    const origin=new URL(server.url).origin;
    for(const path of routes) {
      await page.goto(origin+"/shadcn_ui"+path+"/");
      await expect(page.locator('link[rel="canonical"]')).toHaveAttribute("href",canonical+path);
      await page.getByRole("link",{name:"Use dark theme",exact:true}).click();
      await page.getByRole("navigation",{name:"Motion inspection",exact:true}).getByRole("link",{name:"Reduce motion",exact:true}).click();
      await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
      await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
      await page.locator('link[rel="stylesheet"]').evaluateAll(nodes=>nodes.forEach(n=>n.remove()));
      await expect(page.locator("h1")).toBeVisible();
      const clones=page.locator('[data-shadcn-ui-motion-part="clone"]');
      for(const clone of await clones.all()) await expect(clone).toBeHidden();
      const links=await page.locator('main a[href*="media/"]').evaluateAll(nodes=>nodes.map(n=>n.href));
      for(const link of links) expect(new URL(link).origin).toBe(origin);
    }
    expect(remote).toEqual([]);
  } finally {await context.close();await server.close();}
});
