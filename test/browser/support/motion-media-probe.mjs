// Test-only platform probes, not public components or production polyfills.
import { readFileSync } from "node:fs";
export const manifest = JSON.parse(readFileSync(new URL("../../../priv/compatibility/motion_media.json", import.meta.url), "utf8"));
export function fixture(disabled = [], css = true) {
  const rule = (features, selector, declarations) => features.some(f => disabled.includes(f)) ? "" :
    `@supports ${features.map(f => manifest.capabilities[f].probe.startsWith("selector(") ? manifest.capabilities[f].probe : "(" + manifest.capabilities[f].probe + ")").join(" and ")} { ${selector} { ${declarations} } }`;
  return `<!doctype html><html lang="en"><title>Motion/media platform probe</title>${css ? `<style>
    #scroll { overflow:auto; width:240px; height:100px; border:2px solid; }
    #scroll ol { margin:0; padding:0; } #scroll li { min-height:200px; }
    #indicator { width:20px; height:10px; background:currentColor; }
    #view { display:block; width:30px; height:20px; background:currentColor; }
    #gate { color:rgb(0,0,0); }
    @keyframes shadcn-ui-probe { from { opacity:0.25; } to { opacity:1; } }
    ${rule(["scrollSnap"], "#scroll", "scroll-snap-type: block proximity;")}
    ${rule(["has"], "#gate:has(input:checked)", "color:rgb(1,2,3);")}
    ${rule(manifest.bundles.scrollIndicator.enhancements, "#indicator", "animation:shadcn-ui-probe linear both; animation-timeline:scroll(nearest block); animation-range:0% 100%;")}
    ${rule(manifest.bundles.coverFlow.enhancements, "#view", "animation:shadcn-ui-probe linear both; animation-timeline:view(block); animation-range:entry 0% exit 100%; transform:perspective(400px) rotateY(20deg);")}
  </style>` : ""}
  <main><h1>Platform fixture, not a component preview</h1>
  <label id="gate"><input id="preview" type="checkbox">Enable finite preview</label>
  <div id="scroll" role="region" aria-label="Native media list" tabindex="0">
    <div id="indicator" aria-hidden="true"></div>
    <ol><li id="one"><a href="#two">Second item</a></li><li id="two"><span id="view">Two</span><a href="#one">First item</a></li></ol>
  </div>
  <button id="open" command="show-modal" commandfor="dialog" type="button">Open image</button>
  <dialog id="dialog" aria-label="Image detail" closedby="closerequest"><p>Complete caption</p><button command="close" commandfor="dialog" type="button">Close</button></dialog>
  <a href="#one">Ordinary image destination</a></main></html>`;
}
export async function observe(page) {
  await page.setContent(fixture());
  const declarations = await page.evaluate(capabilities => Object.fromEntries(Object.entries(capabilities).map(([name, { probe }]) => [name,
    name === "nativeScroll" ? "scrollTop" in Element.prototype :
    name === "dialogCommands" ? "commandForElement" in HTMLButtonElement.prototype && "closedBy" in HTMLDialogElement.prototype :
    CSS.supports(probe)])), manifest.capabilities);
  await page.locator("#preview").check();
  const checkboxGate = await page.locator("#gate").evaluate(e => getComputedStyle(e).color === "rgb(1, 2, 3)");
  await page.waitForTimeout(100);
  const initial = await page.locator("#indicator").evaluate(e => getComputedStyle(e).opacity);
  await page.locator("#scroll").evaluate(e => { e.scrollTop = e.scrollHeight; });
  // Allow asynchronous scroll-driven style sampling, without a component runtime.
  await page.waitForTimeout(100);
  const scrolled = await page.locator("#indicator").evaluate(e => getComputedStyle(e).opacity);
  const nativeScroll = await page.locator("#scroll").evaluate(e => e.scrollTop > 0);
  await page.locator("#open").click();
  const dialogOpened = await page.locator("#dialog").evaluate(e => e.open);
  if (dialogOpened) await page.keyboard.press("Escape");
  return { declarations, behavior: {
    nativeScroll, checkboxGate, dialogOpened,
    dialogDismissed: !(await page.locator("#dialog").evaluate(e => e.open)),
    scrollTimelineChanges: initial !== scrolled,
    coverFlowTransform: await page.locator("#view").evaluate(e => getComputedStyle(e).transform !== "none"),
    originTransition: "deferred-phase-5", generatedControls: "deferred"
  } };
}
