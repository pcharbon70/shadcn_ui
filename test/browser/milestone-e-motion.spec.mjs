import { test, expect } from "../../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync } from "node:fs";
const fixture = readFileSync(new URL("../fixtures/milestone_e_motion.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../../priv/static/shadcn_ui.css", import.meta.url), "utf8");
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
