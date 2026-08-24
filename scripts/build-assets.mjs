import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { compileStylesheet } from "./compile-assets.mjs";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
compileStylesheet(root, join(root, "priv", "static", "shadcn_ui.css"));
process.stdout.write("Built priv/static/shadcn_ui.css.\n");
