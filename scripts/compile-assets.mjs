import { readFileSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { spawnSync } from "node:child_process";

export function compileStylesheet(root, output) {
  const rawOutput = `${output}.tailwind`;
  const cli = join(root, "node_modules", "@tailwindcss", "cli", "dist", "index.mjs");

  try {
    const result = spawnSync(
      process.execPath,
      [cli, "-i", join(root, "assets", "shadcn_ui.css"), "-o", rawOutput, "--minify"],
      { cwd: root, encoding: "utf8" }
    );

    if (result.status !== 0) {
      throw result.error || new Error(result.stderr || result.stdout || "Tailwind build failed.");
    }

    const isolated = readFileSync(rawOutput, "utf8").replaceAll("--tw-", "--sui-tw-");
    writeFileSync(output, isolated);
  } finally {
    rmSync(rawOutput, { force: true });
  }
}
