import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join, relative } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const demo = fileURLToPath(new URL("../", import.meta.url));
const exportRoot = fileURLToPath(new URL("../export/", import.meta.url));

const runExport = () => {
  const executable = process.platform === "win32" ? "mix.bat" : "mix";
  const result = spawnSync(executable, ["gallery.export"], {
    cwd: demo,
    encoding: "utf8",
    shell: process.platform === "win32"
  });
  if (result.status !== 0) throw new Error(result.stderr || result.stdout || "gallery export failed");
};

const snapshot = async () => {
  const files = [];
  const visit = async (directory) => {
    for (const entry of await readdir(directory, { withFileTypes: true })) {
      const path = join(directory, entry.name);
      if (entry.isDirectory()) await visit(path);
      else files.push(path);
    }
  };
  await visit(exportRoot);
  files.sort();
  const result = {};
  for (const path of files) {
    result[relative(exportRoot, path).replaceAll("\\", "/")] =
      createHash("sha256").update(await readFile(path)).digest("hex");
  }
  return result;
};

runExport();
const first = await snapshot();
runExport();
const second = await snapshot();

if (JSON.stringify(first) !== JSON.stringify(second)) {
  throw new Error("two clean gallery exports produced different file inventories or hashes");
}
