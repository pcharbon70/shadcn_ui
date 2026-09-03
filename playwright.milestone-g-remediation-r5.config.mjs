import {defineConfig, devices} from "./demo/node_modules/@playwright/test/index.mjs";
import {fileURLToPath} from "node:url";

export default defineConfig({
  testDir: "./test/browser",
  testMatch: "milestone-g-remediation-r5.spec.mjs",
  outputDir: "./test-results/milestone-g-remediation-r5",
  workers: 1,
  reporter: "line",
  timeout: 120_000,
  expect: {timeout: 10_000},
  projects: [{name: "chromium", use: {...devices["Desktop Chrome"]}}],
  use: {
    headless: true,
    baseURL: "http://127.0.0.1:4131",
    trace: "retain-on-failure",
  },
  webServer: [
    {
      command: "mix phx.server",
      cwd: fileURLToPath(new URL("./demo", import.meta.url)),
      url: "http://127.0.0.1:4131",
      env: {...process.env, MIX_ENV: "test", PHX_SERVER: "true", PORT: "4131"},
      reuseExistingServer: false,
      timeout: 120_000,
    },
    {
      command: "node scripts/serve-milestone-g-pinned-reference.mjs",
      cwd: fileURLToPath(new URL(".", import.meta.url)),
      url: "http://127.0.0.1:4132/components/accordion/",
      env: {...process.env, REFERENCE_PORT: "4132"},
      reuseExistingServer: false,
      timeout: 30_000,
    },
  ],
});
