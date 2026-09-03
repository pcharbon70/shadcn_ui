import { defineConfig, devices } from "../../../demo/node_modules/@playwright/test/index.mjs";
import { fileURLToPath } from "node:url";
export default defineConfig({
  testDir: "..", testMatch: "milestone-d-gallery.spec.mjs",
  outputDir: "../../../test-results/milestone-d-gallery", workers: 1, reporter: "line",
  forbidOnly: Boolean(process.env.CI), retries: process.env.CI ? 1 : 0,
  use: { baseURL: "http://127.0.0.1:4104", headless: true, trace: "retain-on-failure" },
  projects: [
    { name: "chromium", use: { ...devices["Desktop Chrome"], browserName: "chromium" } },
    { name: "firefox", use: { ...devices["Desktop Firefox"], browserName: "firefox" } },
    { name: "webkit", use: { ...devices["Desktop Safari"], browserName: "webkit" } },
  ],
  webServer: { command: "mix phx.server", cwd: fileURLToPath(new URL("../../../demo", import.meta.url)),
    url: "http://127.0.0.1:4104", env: { ...process.env, MIX_ENV: "test", PHX_SERVER: "true", PORT: "4104" }, reuseExistingServer: false, timeout: 120_000 },
});
