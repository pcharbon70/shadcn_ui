import { defineConfig } from "./demo/node_modules/@playwright/test/index.mjs";

export default defineConfig({
  testDir: "./test/browser",
  testMatch: "phase4-headers-radio-panels.spec.mjs",
  outputDir: "./test-results/phase4",
  workers: 1,
  reporter: "line",
  use: { browserName: "chromium", headless: true }
});
