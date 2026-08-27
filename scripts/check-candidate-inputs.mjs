import {createHash} from "node:crypto";
import {execFileSync} from "node:child_process";
import {readFile} from "node:fs/promises";
import {resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = fileURLToPath(new URL("../", import.meta.url));
const manifest = JSON.parse(await readFile(resolve(root, "release/candidate-inputs.json")));
const hash = async path => createHash("sha256").update(await readFile(resolve(root, path))).digest("hex");
const command = (executable, args = []) => execFileSync(executable, args, {
  cwd: root,
  encoding: "utf8",
  shell: process.platform === "win32"
}).trim();
const requireEqual = (actual, expected, label) => {
  if (actual !== expected) throw new Error(`${label}: expected ${expected}, received ${actual}`);
};

for (const [path, expected] of Object.entries(manifest.locks)) {
  requireEqual(await hash(path), expected, path);
}

const elixir = command("elixir", ["--version"]);
const mix = command("mix", ["--version"]);
const hex = command("mix", ["hex.info"]);
requireEqual(elixir.match(/Elixir ([\d.]+)/)?.[1], manifest.toolchain.elixir, "Elixir");
requireEqual(elixir.match(/Erlang\/OTP (\d+)/)?.[1], manifest.toolchain.otp, "OTP release");
requireEqual(elixir.match(/erts-([\d.]+)/)?.[1], manifest.toolchain.erts, "ERTS");
requireEqual(mix.match(/Mix ([\d.]+)/)?.[1], manifest.toolchain.mix, "Mix");
requireEqual(hex.match(/Hex:\s+([\d.]+)/)?.[1], manifest.toolchain.hex, "Hex");
requireEqual(process.version.slice(1), manifest.toolchain.node, "Node");
requireEqual(command(process.platform === "win32" ? "npm.cmd" : "npm", ["--version"]), manifest.toolchain.npm, "npm");

const rootLock = JSON.parse(await readFile(resolve(root, "package-lock.json")));
const demoLock = JSON.parse(await readFile(resolve(root, "demo/package-lock.json")));
requireEqual(rootLock.packages["node_modules/@tailwindcss/cli"].version, manifest.toolchain.tailwindcss, "Tailwind CLI");
requireEqual(demoLock.packages["node_modules/@playwright/test"].version, manifest.toolchain.playwright, "Playwright");
requireEqual(demoLock.packages["node_modules/axe-core"].version, manifest.toolchain.axeCore, "axe-core");

const rebar = process.env.MIX_REBAR3;
if (!rebar) throw new Error("MIX_REBAR3 must select the reviewed rebar3 executable");
requireEqual(createHash("sha256").update(await readFile(rebar)).digest("hex"), manifest.rebar3.sha256, "rebar3");

const evidence = JSON.parse(await readFile(resolve(root, manifest.browserEvidence)));
requireEqual(evidence.lock.playwright, manifest.toolchain.playwright, "browser evidence Playwright");
requireEqual(evidence.lock.packageLockSha256, manifest.locks["demo/package-lock.json"], "browser evidence lock");

console.log("Candidate toolchain and lock inputs match the reviewed manifest.");
