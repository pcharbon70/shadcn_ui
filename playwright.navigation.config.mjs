import { defineConfig } from "./demo/node_modules/@playwright/test/index.mjs";
export default defineConfig({testDir:"./test/browser",testMatch:"navigation-menu-foundations.spec.mjs",outputDir:"./test-results/navigation",workers:1,reporter:"line",use:{browserName:"chromium",headless:true}});
