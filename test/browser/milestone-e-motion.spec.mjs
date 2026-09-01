import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
import { serveMotionMediaExport } from "./support/static-motion-media.mjs";
const fixture = readFileSync(new URL("../fixtures/milestone_e_motion.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
const axe = readFileSync(new URL("../../demo/node_modules/axe-core/axe.min.js", import.meta.url), "utf8");
const evidence = JSON.parse(readFileSync(new URL("../../demo/priv/compatibility/motion_media_evidence.json", import.meta.url), "utf8"));
const canonical = "#preview [data-shadcn-ui-marquee-list]";
const clone = "#preview [data-shadcn-ui-motion-part=clone]";
async function setup(page, styles = css) {
  await page.emulateMedia({ reducedMotion: "no-preference" });
  await page.setContent(fixture);
  await page.addStyleTag({ content: styles });
}
async function moving(page, selector = canonical) {
  return page.locator(selector).evaluate(el => {
    // Flush offscreen style sampling before reading compositor animation state.
    getComputedStyle(el).transform;
    return el.getAnimations().some(a => a.playState === "running");
  });
}
async function identity(page, selector = canonical) {
  return page.locator(selector).evaluate(el => new DOMMatrix(getComputedStyle(el).transform).isIdentity);
}

test("exact locked engines and native-only fixture", async ({browser, browserName}) => {
  expect(browser.version()).toBe(evidence.engines[browserName].version);
  expect(fixture).not.toMatch(/<script|aria-live|role="(?:tab|menu|progressbar)"/);
});

for (const theme of ["light", "dark"]) {
  test(`live ${theme} motion references: axe, narrow layout, native form reset and zoom`, async ({page}, testInfo) => {
    await page.setViewportSize({width:390,height:844});
    for (const component of ["marquee", "stagger"]) {
      await page.goto(`/components/motion/${component}?theme=${theme}&motion=reduce`);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
      await page.addScriptTag({content:axe});
      const results = await page.evaluate(() => axe.run(document, {runOnly:{type:"tag",values:["wcag2a","wcag2aa","wcag21aa"]}}));
      expect(results.violations).toEqual([]);
      const ids = await page.locator("[id]").evaluateAll(nodes => nodes.map(n=>n.id));
      expect(new Set(ids).size).toBe(ids.length);
      if (component === "marquee") {
        await expect(page.locator("#marquee-preview li").first()).toHaveCSS("border-radius", "6px");
        await expect(page.locator("#marquee-preview").getByRole("list")).toHaveCount(1);
        await expect(page.locator("#marquee-preview").getByRole("listitem")).toHaveCount(3);
        expect(await page.locator("#marquee-preview").ariaSnapshot()).not.toMatch(/Mountain walks[\s\S]*Mountain walks/);
        const image = page.locator("#marquee-preview ul img");
        await image.scrollIntoViewIfNeeded();
        await expect.poll(() => image.evaluate(el => el.complete && el.naturalWidth > 0)).toBe(true);
      } else {
        const input=page.getByRole("textbox",{name:"Local note (rise)"});
        await input.fill("Changed locally");
        await page.getByRole("button",{name:"Reset rise example"}).click();
        await expect(input).toHaveValue("A complete readable default");
      }
      await page.locator(".gallery-example").scrollIntoViewIfNeeded();
      await page.screenshot({path:testInfo.outputPath(`${component}-${theme}-narrow.png`)});
      await page.setViewportSize({width:1280,height:900});
      await page.locator("html").evaluate(el => el.style.zoom = "2");
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1)).toBe(true);
      await page.setViewportSize({width:390,height:844});
    }
  });
}

test("keyboard opt-in, sibling independence, RTL travel and fresh native reset", async ({page}) => {
  await setup(page);
  const input=page.locator("#preview input");
  await input.focus(); await page.keyboard.press("Space");
  await expect(input).toBeChecked();
  expect(await moving(page, "#five ul")).toBe(false);
  await expect.poll(() => page.locator(canonical).evaluate(el => new DOMMatrix(getComputedStyle(el).transform).m41)).toBeLessThan(0);
  await page.locator("#rtl input").check();
  await expect.poll(() => page.locator("#rtl ul").evaluate(el => new DOMMatrix(getComputedStyle(el).transform).m41)).toBeGreaterThan(0);
  const formValues = await input.evaluate(el => {const form=document.createElement("form"); el.before(form); form.append(el); return [...new FormData(form).keys()];});
  expect(formValues).toEqual([]);
  await page.setContent(fixture); await page.addStyleTag({content:css});
  await expect(input).not.toBeChecked(); expect(await moving(page)).toBe(false);
});

test("missing has gate, no-script and disabled CSS expose only complete canonical content", async ({browser,page}) => {
  await setup(page);
  // Deliberately remove the entire admitted capability bundle, not just animation.
  await page.evaluate(() => {
    function strip(sheet) {for(let i=sheet.cssRules.length-1;i>=0;i--) {
      const rule=sheet.cssRules[i];
      if (rule.conditionText?.includes(":has(")) sheet.deleteRule(i);
      else if(rule.cssRules) strip(rule);
    }}
    [...document.styleSheets].forEach(strip);
  });
  await expect(page.locator("#preview input")).toBeHidden();
  await page.locator("#preview input").evaluate(el=>el.checked=true);
  expect(await moving(page)).toBe(false); await expect(page.locator(clone)).toBeHidden();
  await expect(page.locator("#preview").getByRole("listitem")).toHaveCount(3);
  const context=await browser.newContext({javaScriptEnabled:false,reducedMotion:"no-preference"});
  try {const noScript=await context.newPage(); await noScript.setContent(fixture);
    await expect(noScript.locator("#preview input")).toBeHidden();
    await expect(noScript.locator(clone)).toBeHidden();
    await expect(noScript.locator("#stagger-rise input")).toHaveCount(20);
    // Load CSS as document markup; addStyleTag waits on scripting-dependent load hooks.
    await noScript.setContent(fixture.replace("</head>", `<style>${css}</style></head>`));
    await noScript.locator("#preview input").check();
    await expect.poll(()=>moving(noScript)).toBe(true);
    await noScript.locator("#preview input").uncheck();
    expect(await identity(noScript)).toBe(true);
  } finally {await context.close();}
});

test("forced colors and OS reduction preserve focused native content", async ({page}) => {
  await setup(page);
  await page.emulateMedia({forcedColors:"active", reducedMotion:"reduce"});
  await expect(page.locator("#preview input")).toBeHidden();
  // Media emulation resolves before every engine has applied the style update.
  await expect.poll(()=>page.locator("#stagger-rise").evaluate(el=>el.getAnimations({subtree:true}).length)).toBe(0);
  const input=page.locator("#stagger-rise input").first(); await input.focus();
  await expect(input).toBeFocused();
  await expect(input.locator("..").locator("..")).toHaveCSS("opacity","1");
  await page.emulateMedia({forcedColors:"active",reducedMotion:"no-preference"});
  await page.locator("#preview input").focus();
  expect(await page.locator("#preview input").evaluate(el=>getComputedStyle(el).outlineStyle)).not.toBe("none");
});

// covers: shadcn_ui.motion_media_gallery.accessibility_matrix shadcn_ui.motion_media_gallery.static_media
test("actual subpath export works without scripts, preserving theme and motion choices", async ({browser}) => {
  const server=await serveMotionMediaExport(["/examples/motion-preferences","/components/motion/marquee","/components/motion/stagger"]);
  const context=await browser.newContext({javaScriptEnabled:false, reducedMotion:"no-preference"});
  try {const page=await context.newPage(), remote=[];
    page.on("request",r=>{if(new URL(r.url()).hostname!=="127.0.0.1")remote.push(r.url());});
    await page.goto(server.url);
    const input=page.locator("#preferences-preview input"); await input.check();
    await expect.poll(()=>moving(page,"#preferences-preview ul")).toBe(true);
    await input.uncheck();
    await page.getByRole("link",{name:"Use dark theme",exact:true}).click();
    await page.getByRole("navigation",{name:"Motion examples preference",exact:true}).getByRole("link",{name:"Reduce motion",exact:true}).click();
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
    expect(await moving(page,"#preferences-preview ul")).toBe(false);
    await page.getByRole("textbox",{name:"Local reading note"}).fill("Different");
    await page.getByRole("button",{name:"Reset local note"}).click();
    await expect(page.getByRole("textbox",{name:"Local reading note"})).toHaveValue("Explore at your pace");
    expect(remote).toEqual([]);
  } finally {await context.close(); await server.close();}
});

test("live theme changes update both sets of native motion preference links", async ({page}) => {
  await page.goto("/examples/motion-preferences?theme=light&motion=system");
  await page.getByRole("button",{name:"Dark",exact:true}).click();
  await page.getByRole("navigation",{name:"Motion examples preference",exact:true}).getByRole("link",{name:"Reduce motion",exact:true}).click();
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme","dark");
  await expect(page.locator("html")).toHaveAttribute("data-shadcn-motion","reduce");
});

test("native touch activation can enable the preview without a gesture controller", async ({browser}) => {
  const context=await browser.newContext({hasTouch:true,reducedMotion:"no-preference",viewport:{width:390,height:844}});
  try {const page=await context.newPage();
    await page.goto("http://127.0.0.1:4107/components/motion/marquee");
    const input=page.locator("#marquee-preview input");
    await page.locator("#marquee-primary-preview").evaluate(container=>{
      const control=container.querySelector("#marquee-preview input");
      container.scrollTop+=control.getBoundingClientRect().top-container.getBoundingClientRect().top-100;
      container.scrollIntoView({block:"center"});
    });
    await input.tap(); await expect(input).toBeChecked();
    await expect.poll(()=>moving(page,"#marquee-preview ul")).toBe(true);
  } finally {await context.close();}
});

// covers: shadcn_ui.motion_components.stagger shadcn_ui.motion_components.motion_replacement
test("Stagger keeps excess items immediate and completes its actual sequence within one second", async ({ page }) => {
  await setup(page);
  const timings = await page.locator("#stagger-rise > li").evaluateAll(items => items.map(el => ({
    opacity: Number(getComputedStyle(el).opacity),
    animations: el.getAnimations().map(a => a.effect.getComputedTiming().endTime)
  })));
  expect(timings.every(t => t.opacity > 0)).toBe(true);
  expect(timings.flatMap(t => t.animations).every(t => t <= 1000)).toBe(true);
  expect(timings.some(t => t.animations.length)).toBe(true);
  expect(timings.at(-1).animations).toEqual([]);
  expect(timings.at(-1).opacity).toBe(1);
  expect(await page.locator("#stagger-none").evaluate(el => el.getAnimations({subtree:true}).length)).toBe(0);
  await expect.poll(() => page.locator("#stagger-rise").evaluate(el => {
    getComputedStyle(el.lastElementChild).opacity;
    return el.getAnimations({subtree:true}).filter(a => a.playState === "running").length;
  }), { timeout: 1500, intervals: [50] }).toBe(0);
  await expect(page.locator("#stagger-rise li")).toHaveCount(20);
});

test("Stagger focus, style interruption, replacement and nested suppression preserve native content", async ({ page }) => {
  await setup(page);
  const focused = page.locator("#stagger-rise li").nth(8);
  await focused.locator("input").focus();
  await expect(focused).toHaveCSS("opacity", "1");
  expect(await focused.evaluate(el => el.getAnimations().length)).toBe(0);
  await focused.locator("input").fill("caller state");
  expect(await page.locator("#stagger-nested").evaluate(el => el.getAnimations({subtree:true}).length)).toBe(0);
  await page.locator("style").evaluateAll(nodes => nodes.forEach(n => n.remove()));
  await expect(focused).toHaveCSS("opacity", "1");
  await expect(focused.locator("input")).toHaveValue("caller state");
  await page.setContent(fixture);
  await page.addStyleTag({content:css});
  await expect(page.locator("#stagger-rise li").nth(8).locator("input")).toHaveValue("");
  expect(await page.locator("#stagger-rise").evaluate(el => el.getAnimations({subtree:true}).length)).toBeGreaterThan(0);
});

// covers: shadcn_ui.motion_components.marquee_control shadcn_ui.motion_components.marquee_duplicates
// covers: shadcn_ui.motion_components.suppression shadcn_ui.motion_components.work_budget
test("Marquee is static, native opt-in stops after focus leaves, and explicitly replays", async ({ page }) => {
  await setup(page);
  const checkbox = page.locator("#preview input");
  await expect(checkbox).not.toBeChecked();
  expect(await moving(page)).toBe(false);
  await expect(page.locator(clone)).toBeHidden();
  await checkbox.check();
  await expect.poll(() => moving(page)).toBe(true);
  await expect.poll(() => identity(page)).toBe(false);
  await expect(page.locator(clone)).toBeVisible();
  await expect(page.locator(clone)).toHaveAttribute("inert", "");
  await expect(page.locator(clone)).toHaveAttribute("aria-hidden", "true");
  await expect(page.locator(clone).locator("[id],a,button,input,[tabindex],[name]")).toHaveCount(0);
  expect(await page.locator("#preview").ariaSnapshot()).not.toMatch(/Alpha[\s\S]*Alpha/);
  await page.locator("#after").focus();
  await checkbox.uncheck();
  expect(await moving(page)).toBe(false);
  expect(await identity(page)).toBe(true);
  await expect(page.locator(clone)).toBeHidden();
  await checkbox.check();
  await expect.poll(() => moving(page)).toBe(true);
  await expect.poll(() => moving(page), { timeout: 3500 }).toBe(false);
  expect(await identity(page)).toBe(true);
  await expect(page.locator(clone)).toBeHidden();
  await expect(checkbox).toBeChecked();
  await expect(page.locator("#preview").getByRole("list")).toHaveCount(1);
  expect(await page.locator("#preview").ariaSnapshot()).not.toMatch(/Alpha[\s\S]*Alpha/);
});

test("five second preview completes even offscreen without a repeat", async ({ page }) => {
  await setup(page);
  await page.locator("#five input").check();
  const target = "#five [data-shadcn-ui-marquee-list]";
  await expect.poll(() => moving(page, target)).toBe(true);
  const timing = await page.locator(target).evaluate(el => el.getAnimations()[0].effect.getComputedTiming());
  expect(timing.endTime).toBe(5000);
  expect(timing.iterations).toBe(1);
  await page.locator("#five").evaluate(el => el.style.marginTop = "200vh");
  await expect.poll(() => moving(page, target), { timeout: 6000, intervals: [100] }).toBe(false);
  expect(await identity(page, target)).toBe(true);
});

test("reduced motion and interruption restore static content with no exposed duplicate", async ({ page }) => {
  await setup(page);
  await page.locator("#preview input").check();
  await page.emulateMedia({ reducedMotion: "reduce" });
  expect(await moving(page)).toBe(false);
  expect(await identity(page)).toBe(true);
  await expect(page.locator(clone)).toBeHidden();
  await page.emulateMedia({ reducedMotion: "no-preference" });
  await page.locator("style").evaluateAll(nodes => nodes.forEach(n => n.remove()));
  expect(await identity(page)).toBe(true);
  await expect(page.locator(clone)).toBeHidden();
  await expect(page.locator("#preview li")).toHaveCount(3);
});

test("explicit and nested suppression cannot be re-enabled by checking", async ({ page }) => {
  await setup(page);
  for (const id of ["nested", "none"]) {
    await page.locator(`#${id} input`).evaluate(el => el.checked = true);
    expect(await moving(page, `#${id} ul`)).toBe(false);
    expect(await identity(page, `#${id} ul`)).toBe(true);
    await expect(page.locator(`#${id} [data-shadcn-ui-motion-part=clone]`)).toBeHidden();
  }
});
