import { readFileSync } from "node:fs";
import { expect, test } from "../../demo/node_modules/@playwright/test/index.mjs";

// covers: shadcn_ui.overlay.browser_matrix
// covers: shadcn_ui.overlay.native_invocation
// covers: shadcn_ui.overlay.focus_ownership
// covers: shadcn_ui.overlay.dismissal

const manifest = JSON.parse(
  readFileSync(new URL("../../priv/compatibility/native_overlays.json", import.meta.url), "utf8")
);

test("locked engine version matches the authored evidence", async ({ browser, browserName }) => {
  const evidence = manifest.verificationEvidence.engines[browserName];

  expect(evidence).toBeDefined();
  expect(browser.version()).toBe(evidence.version);
});

test("required native overlay capabilities are present without browser-name branching", async ({ page }) => {
  await page.setContent("<!doctype html><button></button><dialog></dialog><div></div>");

  const capabilities = await page.evaluate(() => ({
    dialog: typeof HTMLDialogElement.prototype.showModal === "function",
    dialogInvokerCommands: "commandForElement" in HTMLButtonElement.prototype,
    dialogClosedBy: "closedBy" in HTMLDialogElement.prototype,
    popover: "popover" in HTMLElement.prototype,
    popoverTarget: "popoverTargetElement" in HTMLButtonElement.prototype,
    anchorPositioning: CSS.supports("anchor-name: --shadcn-ui-test"),
    positionFallbacks: CSS.supports("position-try-fallbacks: flip-block"),
    discreteTransitions: CSS.supports("transition-behavior: allow-discrete"),
    interestInvokers: "interestForElement" in HTMLButtonElement.prototype
  }));

  for (const capability of manifest.componentCapabilitySets.dialogFamily) {
    expect(capabilities[capability], `${capability} capability`).toBe(true);
  }

  for (const capability of manifest.componentCapabilitySets.popoverFamily) {
    expect(capabilities[capability], `${capability} capability`).toBe(true);
  }

  for (const enhancement of [
    ...manifest.componentCapabilitySets.anchoredPopoverPresentation,
    ...manifest.componentCapabilitySets.overlayMotion
  ]) {
    expect(typeof capabilities[enhancement]).toBe("boolean");
  }

  expect(manifest.capabilities.interestInvokers.status).toBe("excluded");
});
