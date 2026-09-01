import {defineConfig, devices} from "./demo/node_modules/@playwright/test/index.mjs";
import {fileURLToPath} from "node:url";

export default defineConfig({
  testDir: "./test/browser",
  testMatch: "milestone-g-phase7-migration.spec.mjs",
  outputDir: "./test-results/milestone-g-phase7",
  snapshotPathTemplate: "{testDir}/{testFilePath}-snapshots/{arg}-{projectName}{ext}",
  workers: 1,
  reporter: "line",
  timeout: 180_000,
  expect: {timeout: 10_000},
  projects: [{name: "chromium", use: {...devices["Desktop Chrome"]}}],
  use: {
    headless: true,
    baseURL: "http://127.0.0.1:4117",
    trace: "retain-on-failure"
  },
  webServer: {
    command: "mix phx.server",
    cwd: fileURLToPath(new URL("./demo", import.meta.url)),
    url: "http://127.0.0.1:4117",
    env: {...process.env, MIX_ENV: "test", PHX_SERVER: "true", PORT: "4117"},
    reuseExistingServer: false,
    timeout: 120_000
  }
});
