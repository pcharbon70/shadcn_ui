import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "test/browser",
  fullyParallel: true,
  workers: 4,
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? "github" : "list",
  use: {
    baseURL: "http://127.0.0.1:4102",
    browserName: "chromium",
    trace: "retain-on-failure"
  },
  webServer: {
    command: "mix phx.server",
    url: "http://127.0.0.1:4102",
    env: { ...process.env, MIX_ENV: "test", PHX_SERVER: "true", PORT: "4102" },
    reuseExistingServer: !process.env.CI,
    timeout: 120_000
  }
});
