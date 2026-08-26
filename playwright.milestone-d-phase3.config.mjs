import { defineConfig, devices } from "./demo/node_modules/@playwright/test/index.mjs";

export default defineConfig({
  testDir: "./test/browser",
  testMatch: "milestone-d-drawers.spec.mjs",
  fullyParallel: false,
  workers: 1,
  reporter: "line",
  outputDir: "test-results/milestone-d-phase3",
  use: { headless: true },
  projects: [
    { name: "chromium", use: { ...devices["Desktop Chrome"] } },
    { name: "firefox", use: { ...devices["Desktop Firefox"] } },
    { name: "webkit", use: { ...devices["Desktop Safari"] } },
  ],
});
