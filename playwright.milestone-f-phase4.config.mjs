import {defineConfig, devices} from "./demo/node_modules/@playwright/test/index.mjs";
import {fileURLToPath} from "node:url";

export default defineConfig({
  testDir: "./test/browser",
  testMatch: "milestone-f-compatibility.spec.mjs",
  outputDir: "./test-results/milestone-f-phase4",
  workers: 1,
  reporter: "line",
  timeout: 240_000,
  projects: [
    {name: "chromium", use: {...devices["Desktop Chrome"]}},
    {name: "firefox", use: {...devices["Desktop Firefox"]}},
    {name: "webkit", use: {...devices["Desktop Safari"]}}
  ],
  use: {headless: true, baseURL: "http://127.0.0.1:4111", trace: "retain-on-failure"},
  webServer: {
    command: "mix gallery.export && mix phx.server",
    cwd: fileURLToPath(new URL("./demo", import.meta.url)),
    url: "http://127.0.0.1:4111",
    env: {...process.env, MIX_ENV: "test", PHX_SERVER: "true", PORT: "4111"},
    reuseExistingServer: false,
    timeout: 180_000
  }
});
