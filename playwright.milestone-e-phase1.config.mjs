import { defineConfig, devices } from "./demo/node_modules/@playwright/test/index.mjs";
export default defineConfig({
  testDir: "./test/browser", testMatch: /milestone-e-(?:capabilities|foundations)\.spec\.mjs/,
  outputDir: "./test-results/milestone-e-phase1", workers: 1, reporter: "line",
  projects: [
    { name: "chromium", use: { ...devices["Desktop Chrome"] } },
    { name: "firefox", use: { ...devices["Desktop Firefox"] } },
    { name: "webkit", use: { ...devices["Desktop Safari"] } }
  ], use: { headless: true }
});
