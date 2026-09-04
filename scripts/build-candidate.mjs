import {createHash} from "node:crypto";
import {spawnSync} from "node:child_process";
import {copyFile, mkdir, readFile, readdir, writeFile} from "node:fs/promises";
import {basename, join, relative, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = fileURLToPath(new URL("../", import.meta.url));
const outputFlag = process.argv.indexOf("--output");
if (outputFlag < 0 || !process.argv[outputFlag + 1]) throw new Error("--output DIRECTORY is required");
const output = resolve(process.argv[outputFlag + 1]);
await mkdir(output, {recursive: true});

const executable = name => {
  if (process.platform !== "win32") return name;
  if (name === "npm") return "npm.cmd";
  if (name === "mix") return "mix.bat";
  return name;
};
const run = (name, args, cwd = root, extraEnv = {}) => {
  const result = spawnSync(executable(name), args, {
    cwd,
    stdio: "inherit",
    env: {...process.env, ...extraEnv},
    shell: process.platform === "win32"
  });
  if (result.status !== 0) throw new Error(`${name} ${args.join(" ")} failed with ${result.status}`);
};
const capture = (name, args, cwd = root) => {
  const result = spawnSync(executable(name), args, {cwd, encoding: "utf8", env: process.env, shell: process.platform === "win32"});
  if (result.status !== 0) throw new Error(result.stderr || result.stdout);
  return result.stdout.trim();
};
const digest = bytes => createHash("sha256").update(bytes).digest("hex");
const snapshot = async directory => {
  const files = [];
  const visit = async current => {
    for (const entry of await readdir(current, {withFileTypes: true})) {
      const path = join(current, entry.name);
      if (entry.isDirectory()) await visit(path);
      else files.push(path);
    }
  };
  await visit(directory);
  files.sort();
  return Object.fromEntries(await Promise.all(files.map(async path => [relative(directory, path).replaceAll("\\", "/"), digest(await readFile(path))])));
};

run("node", ["scripts/check-candidate-inputs.mjs"]);
run("npm", ["run", "assets:build"]);
run("npm", ["run", "assets:check"]);
run("mix", ["precommit"]);
run("mix", ["run", "scripts/build-deterministic-docs.exs"]);
run("mix", ["hex.build"]);
run("mix", ["run", "scripts/check-release-archive.exs"]);
const demo = resolve(root, "demo");
run("npm", ["run", "assets:build"], demo);
run("npm", ["run", "assets:check"], demo);
run("mix", ["gallery.export"], demo, {MIX_ENV: "test"});
run("npm", ["run", "export:check"], demo);
run("npm", ["run", "export:smoke"], demo);

const version = JSON.parse(await readFile(resolve(root, "release/candidate-inputs.json"))).candidateVersion;
const archive = resolve(root, `shadcn_ui-${version}.tar`);
const archiveInventory = resolve(output, "archive-inventory.json");
run("mix", ["run", "scripts/candidate-archive-inventory.exs", archiveInventory]);
const archiveCopy = resolve(output, basename(archive));
await copyFile(archive, archiveCopy);
const docs = await snapshot(resolve(root, "doc"));
const exportFiles = await snapshot(resolve(demo, "export"));
const css = await readFile(resolve(root, "priv/static/shadcn_ui.css"));
const inputs = await readFile(resolve(root, "release/candidate-inputs.json"));
const provenance = await readFile(resolve(root, "priv/provenance/unscripted_ui.json"));
const archiveBytes = await readFile(archiveCopy);

const record = {
  schemaVersion: 1,
  candidateVersion: version,
  sourceRevision: capture("git", ["rev-parse", "HEAD"]),
  inputsSha256: digest(inputs),
  provenanceSha256: digest(provenance),
  outputs: {
    compiledCss: {bytes: css.length, sha256: digest(css)},
    galleryExport: {files: Object.keys(exportFiles).length, inventory: exportFiles},
    documentation: {files: Object.keys(docs).length, inventory: docs},
    archive: {bytes: archiveBytes.length, sha256: digest(archiveBytes), inventory: JSON.parse(await readFile(archiveInventory))}
  }
};
await writeFile(resolve(output, "candidate-build.json"), JSON.stringify(record, null, 2) + "\n");
console.log(`Candidate evidence written to ${output}`);
