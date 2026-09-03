import { defineConfig, devices } from "../../../demo/node_modules/@playwright/test/index.mjs";
export default defineConfig({
  testDir: "..", testMatch: "milestone-d-popovers.spec.mjs",
  outputDir: "../../../test-results/milestone-d-phase4", workers: 1, reporter: "line",
  use: { headless: true },
  projects: [
    { name: "chromium", use: { ...devices["Desktop Chrome"], browserName: "chromium" } },
    { name: "firefox", use: { ...devices["Desktop Firefox"], browserName: "firefox" } },
    { name: "webkit", use: { ...devices["Desktop Safari"], browserName: "webkit" } },
  ],
});
