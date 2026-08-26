// Test-only upstream-inspired experiment on the actual generated native Dialog.
// Geometry is observed, never assigned; no probe code or CSS ships in the package.
export async function probeGalleryOrigin(page) {
  const declarations=await page.evaluate(()=>({
    anchor:CSS.supports("anchor-name: --gallery-probe"),
    scope:CSS.supports("anchor-scope: --gallery-probe"),
    position:CSS.supports("left: anchor(center)"),
    discrete:CSS.supports("transition-behavior: allow-discrete"),
    overlay:CSS.supports("overlay: auto")
  }));
  await page.addStyleTag({content:`
    #gallery [data-shadcn-ui-dialog] {anchor-scope: --gallery-probe;}
    #gallery [data-shadcn-ui-dialog-invoker] {anchor-name: --gallery-probe;}
    #gallery dialog {position-anchor: --gallery-probe; position: fixed; inset: auto;
      left: 50%; top: 50%; margin: 0; translate: -50% -50%;
      transition: left 2s linear, top 2s linear, display 2s allow-discrete, overlay 2s allow-discrete;}
    @starting-style {#gallery dialog[open] {left: anchor(center); top: anchor(center);}}
  `});
  const trigger=page.locator("#gallery [command='show-modal']").first();
  const dialog=page.locator("#gallery dialog").first();
  await trigger.scrollIntoViewIfNeeded();
  const thumb=await trigger.boundingBox();
  await trigger.click();
  const observation=await dialog.evaluate(el=>{
    const animations=el.getAnimations().filter(a=>["left","top"].includes(a.transitionProperty));
    // Hold the CSS transition at its native start for reproducible observation.
    for(const animation of animations){animation.pause();animation.currentTime=0;}
    const r=el.getBoundingClientRect();
    return {modal:el.matches(":modal"),axes:animations.map(a=>a.transitionProperty).sort(),center:{x:r.x+r.width/2,y:r.y+r.height/2}};
  });
  const originMatches=Math.abs(observation.center.x-(thumb.x+thumb.width/2))<3 && Math.abs(observation.center.y-(thumb.y+thumb.height/2))<3;
  await dialog.locator("[command='close']").click();
  return {declarations,modal:observation.modal,axes:observation.axes,originMatches};
}
