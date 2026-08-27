import {spawnSync} from "node:child_process";
import {mkdtemp, rm} from "node:fs/promises";
import {resolve} from "node:path";
import {tmpdir} from "node:os";
import {join} from "node:path";

const root = process.cwd();
const value = flag => {
  const index = process.argv.indexOf(flag);
  return index >= 0 ? process.argv[index + 1] : undefined;
};
const ref = value("--ref") || "HEAD";
const output = value("--output");
if (!output) throw new Error("--output DIRECTORY is required");
const tempRoot = await mkdtemp(join(tmpdir(), "shadcn-ui-candidate-"));
const checkout = join(tempRoot, "source");
let worktreeAdded = false;
const run = (name, args, cwd = root) => {
  const command = process.platform === "win32" && name === "npm"
    ? "npm.cmd"
    : process.platform === "win32" && name === "mix"
      ? "mix.bat"
      : name;
  const result = spawnSync(command, args, {cwd, stdio: "inherit", env: process.env, shell: process.platform === "win32"});
  if (result.status !== 0) throw new Error(`${name} ${args.join(" ")} failed with ${result.status}`);
};

try {
  run("git", ["worktree", "add", "--detach", checkout, ref]);
  worktreeAdded = true;
  run("mix", ["deps.get", "--locked"], checkout);
  run("mix", ["deps.get", "--locked"], resolve(checkout, "demo"));
  run("npm", ["ci"], checkout);
  run("npm", ["ci"], resolve(checkout, "demo"));
  run("node", ["scripts/build-candidate.mjs", "--output", resolve(output)], checkout);
} finally {
  if (!resolve(tempRoot).startsWith(resolve(tmpdir()))) throw new Error("refusing to clean a non-temporary checkout");
  if (worktreeAdded) run("git", ["worktree", "remove", "--force", checkout]);
  await rm(tempRoot, {recursive: true, force: true});
}
