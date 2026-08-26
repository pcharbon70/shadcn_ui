import {readFileSync,writeFileSync} from "node:fs";
import {chromium,firefox,webkit} from "../demo/node_modules/playwright/index.mjs";
import {probeGalleryOrigin} from "../test/browser/support/gallery-origin-probe.mjs";
const html=readFileSync(new URL("../test/fixtures/milestone_e_image_gallery.html",import.meta.url),"utf8");
const css=readFileSync(new URL("../priv/static/shadcn_ui.css",import.meta.url),"utf8");
const output={schemaVersion:1,decision:"deferred",reason:"Chromium starts at the scoped thumbnail; Firefox and WebKit expose anchor/discrete declarations but no origin transition in this actual-modal probe. Defer the optional effect across this release; all engines use existing native snap Dialog.",engines:{}};
for(const [name,engine] of Object.entries({chromium,firefox,webkit})) {
  const browser=await engine.launch();
  try {const page=await browser.newPage({viewport:{width:1280,height:900}});
    await page.setContent(html);await page.addStyleTag({content:css});
    output.engines[name]={version:browser.version(),...await probeGalleryOrigin(page)};
  } finally {await browser.close();}
}
const path=new URL("../demo/priv/compatibility/image_gallery_evidence.json",import.meta.url);
const data=JSON.stringify(output,null,2)+"\n";
if(process.argv.includes("--check")) {
  if(readFileSync(path,"utf8").replaceAll("\r\n","\n")!==data) throw new Error("Gallery origin evidence changed; review before updating");
} else writeFileSync(path,data);
console.log(data);
