import {defineConfig,devices} from "./demo/node_modules/@playwright/test/index.mjs";
import {fileURLToPath} from "node:url";
export default defineConfig({
  testDir:"./test/browser",testMatch:["milestone-e-budgets.spec.mjs","milestone-e-gallery.spec.mjs"],
  outputDir:"./test-results/milestone-e-phase6",workers:1,reporter:"line",
  projects:[{name:"chromium",use:{...devices["Desktop Chrome"]}},
    {name:"firefox",use:{...devices["Desktop Firefox"]}},{name:"webkit",use:{...devices["Desktop Safari"]}}],
  use:{headless:true,baseURL:"http://127.0.0.1:4110"},
  webServer:{command:"mix phx.server",cwd:fileURLToPath(new URL("./demo",import.meta.url)),
    url:"http://127.0.0.1:4110",env:{...process.env,MIX_ENV:"test",PHX_SERVER:"true",PORT:"4110"},
    reuseExistingServer:false,timeout:120_000}
});
