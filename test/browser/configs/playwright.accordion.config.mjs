import { defineConfig } from "../../../demo/node_modules/@playwright/test/index.mjs";

export default defineConfig({
  testDir: "..",
  testMatch: "accordion-foundations.spec.mjs",
  outputDir: "../../../test-results/accordion",
  fullyParallel: false,
  workers: 1,
  reporter: "line",
  use: {
    browserName: "chromium",
    headless: true
  }
});
