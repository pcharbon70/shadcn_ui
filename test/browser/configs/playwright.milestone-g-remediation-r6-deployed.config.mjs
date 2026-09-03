import {defineConfig, devices} from "../../../demo/node_modules/@playwright/test/index.mjs";

const baseURL = process.env.SHADCN_UI_DEPLOYED_ORIGIN;

if (!baseURL?.startsWith("https://")) {
  throw new Error("SHADCN_UI_DEPLOYED_ORIGIN must be an HTTPS URL");
}

export default defineConfig({
  testDir: "..",
  testMatch: "milestone-g-remediation-r6-deployed.spec.mjs",
  outputDir: "../../../test-results/milestone-g-remediation-r6-deployed",
  workers: 1,
  reporter: "line",
  timeout: 120_000,
  expect: {timeout: 10_000},
  projects: [
    {name: "chromium", use: {...devices["Desktop Chrome"]}}
  ],
  use: {
    headless: true,
    baseURL,
    trace: "retain-on-failure"
  }
});
