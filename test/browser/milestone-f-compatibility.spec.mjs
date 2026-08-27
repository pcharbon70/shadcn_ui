import {expect, test} from "../../demo/node_modules/@playwright/test/index.mjs";
import {serveMotionMediaExport} from "./support/static-motion-media.mjs";

const canonical = "https://leco-industries-inc.github.io/shadcn_ui";
const overlayRoutes = new Set([
  "/components/overlays/dialog", "/components/overlays/alert-dialog",
  "/components/overlays/drawer", "/components/overlays/popover",
  "/components/overlays/dropdown-actions", "/components/interactive-surfaces/tooltip",
  "/components/interactive-surfaces/hover-card"
]);

async function componentRoutes(page) {
  await page.goto("/components/foundation/button");
  const routes = await page.locator('[data-gallery-search-item] a[href^="/components/"]').evaluateAll(nodes => [...new Set(nodes.map(node => node.getAttribute("href")))]);
  expect(routes).toHaveLength(41);
  return routes;
}

// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
test("all 41 public pages retain honest semantics, relationships, identity, and both themes", async ({page}) => {
  const routes = await componentRoutes(page);
  for (const [index, route] of routes.entries()) {
    const theme = index % 2 ? "dark" : "light";
    await page.goto(`${route}?theme=${theme}&motion=reduce`);
    await expect(page.locator("html")).toHaveAttribute("data-shadcn-theme", theme);
    await expect(page.getByRole("main")).toHaveCount(1);
    await expect(page.getByRole("heading", {level: 1})).toHaveCount(1);
    await expect(page.locator('link[rel="canonical"]')).toHaveAttribute("href", canonical + route);
    await expect(page.getByRole("navigation", {name: "Component navigation"}).locator('[aria-current="page"]')).toHaveCount(1);
    for (const heading of ["What it is", "Application responsibilities", "Accessibility", "Native baseline", "Fallback", "Provenance", "HEEX source"]) {
      await expect(page.getByRole("heading", {name: heading, exact: true})).toBeVisible();
    }
    const ids = await page.locator("[id]").evaluateAll(nodes => nodes.map(node => node.id));
    expect(new Set(ids).size, route).toBe(ids.length);
    await expect(page.locator('main [role="menu"],main [role="menubar"],main [role="tab"],main [role="tablist"],main [role="tabpanel"],main [role="tree"],main [role="treeitem"],main [aria-selected]')).toHaveCount(0);
    if (overlayRoutes.has(route)) await expect(page.locator("#ordinary-alternative")).toBeVisible();
  }
});

// covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
test("representative native controls preserve focus, keyboard, dismissal, scrolling, and snapshots", async ({page}) => {
  await page.goto("/components/foundation/button");
  const button = page.locator("[data-gallery-example] button").first();
  await button.focus();
  await expect(button).toBeFocused();

  await page.goto("/components/forms/input");
  const input = page.locator("[data-gallery-example] input").first();
  await input.focus();
  await input.fill("native value");
  await expect(input).toHaveValue("native value");

  await page.goto("/components/disclosure/accordion");
  const details = page.locator("#gallery-independent-item-closed");
  const summary = details.locator("summary");
  await summary.focus(); await page.keyboard.press("Enter");
  await expect(details).toHaveAttribute("open", "");

  await page.goto("/components/overlays/dialog");
  const dialogInvoker = page.locator("[data-shadcn-ui-dialog-invoker]").first();
  await dialogInvoker.focus(); await page.keyboard.press("Enter");
  await expect(page.locator("dialog[open]")).toHaveCount(1);
  await page.keyboard.press("Escape");
  await expect(dialogInvoker).toBeFocused();

  await page.goto("/components/overlays/popover");
  const popoverInvoker = page.locator("button[popovertarget]").first();
  await popoverInvoker.focus(); await page.keyboard.press("Enter");
  await expect(page.locator("[popover]:popover-open")).toHaveCount(1);
  await page.keyboard.press("Escape");
  await expect(popoverInvoker).toBeFocused();

  await page.goto("/components/media/carousel?motion=reduce");
  const index = page.locator('[data-shadcn-ui-carousel-index] a[href^="#"]').first();
  const target = await index.getAttribute("href"); await index.click();
  await expect(page.locator(target)).toBeFocused();

  await page.goto("/examples/settings-confirmation?theme=dark&motion=reduce");
  const instanceIds = await page.locator("[id]").evaluateAll(nodes => nodes.map(node => node.id));
  expect(new Set(instanceIds).size).toBe(instanceIds.length);
  await expect(page.locator("main")).toContainText("Nothing is saved or deleted.");
});

// covers: shadcn_ui.compatibility_accessibility.fallback_evidence
// covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
test("missing CSS, script, media, optional presentation, and constrained layouts keep complete operations", async ({browser}) => {
  const context = await browser.newContext({javaScriptEnabled: false, viewport: {width: 640, height: 844}, reducedMotion: "reduce", forcedColors: "active"});
  const page = await context.newPage();
  await page.route("**/*", route => route.request().resourceType() === "image" ? route.abort() : route.continue());
  for (const route of [
    "/components/forms/enhanced-select", "/components/content-surfaces/radio-panels",
    "/components/overlays/dialog", "/components/overlays/popover",
    "/components/media/image-gallery", "/components/motion/marquee"
  ]) {
    await page.goto(`${route}?theme=dark&motion=reduce`);
    await page.locator("html").evaluate(node => { node.style.zoom = "2"; node.dir = "rtl"; });
    const example = page.locator("[data-gallery-example]").first();
    await expect(example).toBeVisible();
    const bounds = await example.boundingBox();
    expect(bounds.x).toBeGreaterThanOrEqual(0);
    expect(bounds.x + bounds.width).toBeLessThanOrEqual(640);
    await page.locator('link[rel="stylesheet"]').evaluateAll(nodes => nodes.forEach(node => node.remove()));
    await expect(page.getByRole("heading", {level: 1})).toBeVisible();
    await expect(page.getByRole("heading", {name: "Fallback", exact: true})).toBeVisible();
    if (overlayRoutes.has(route)) await expect(page.locator("#ordinary-alternative")).toBeVisible();
  }
  await page.goto("/components/media/image-gallery");
  await expect(page.locator("main img").first()).toHaveAttribute("alt", /.+/);
  await expect(page.locator("[data-shadcn-ui-gallery-destination]").first()).toBeVisible();
  await context.close();
});

// covers: shadcn_ui.compatibility_accessibility.fallback_evidence
test("repository-subpath export is complete without script, CSS, or remote runtime requests", async ({browser}) => {
  const livePage = await browser.newPage();
  const routes = await componentRoutes(livePage);
  await livePage.close();
  const server = await serveMotionMediaExport(routes);
  const context = await browser.newContext({javaScriptEnabled: false, viewport: {width: 390, height: 844}});
  const page = await context.newPage();
  const remote = [];
  page.on("request", request => { if (new URL(request.url()).hostname !== "127.0.0.1") remote.push(request.url()); });
  try {
    const origin = new URL(server.url).origin;
    for (const route of routes) {
      await page.goto(`${origin}/shadcn_ui${route}/`);
      await expect(page.locator('link[rel="canonical"]')).toHaveAttribute("href", canonical + route);
      await page.locator('link[rel="stylesheet"]').evaluateAll(nodes => nodes.forEach(node => node.remove()));
      await expect(page.getByRole("heading", {level: 1})).toBeVisible();
      await expect(page.getByRole("heading", {name: "HEEX source", exact: true})).toBeVisible();
    }
    expect(remote).toEqual([]);
  } finally {
    await context.close(); await server.close();
  }
});
