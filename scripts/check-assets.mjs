import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { compileStylesheet } from "./compile-assets.mjs";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const temporaryDirectory = mkdtempSync(join(tmpdir(), "shadcn-ui-assets-"));
const temporaryOutput = join(temporaryDirectory, "shadcn_ui.css");

try {
  compileStylesheet(root, temporaryOutput);

  const committed = readFileSync(join(root, "priv", "static", "shadcn_ui.css"));
  const generated = readFileSync(temporaryOutput);

  if (!committed.equals(generated)) {
    process.stderr.write(
      "priv/static/shadcn_ui.css is stale. Run npm run assets:build and commit the result.\n"
    );
    process.exit(1);
  }

  process.stdout.write("Compiled stylesheet matches the committed artifact.\n");
} catch (error) {
  process.stderr.write(`${error.stack || error.message || error}\n`);
  process.exit(1);
} finally {
  rmSync(temporaryDirectory, { recursive: true, force: true });
}
