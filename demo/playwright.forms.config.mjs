import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "test/browser",
  testMatch: "select-foundations.spec.mjs",
  fullyParallel: true,
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? "github" : "list",
  use: {
    browserName: "chromium",
    trace: "retain-on-failure"
  }
});
