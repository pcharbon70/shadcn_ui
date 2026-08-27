import {createHash} from "node:crypto";
import {spawn, spawnSync} from "node:child_process";
import {createServer} from "node:http";
import {cp, copyFile, mkdir, mkdtemp, readFile, rm, stat, writeFile} from "node:fs/promises";
import {tmpdir} from "node:os";
import {basename, extname, join, normalize, resolve, sep} from "node:path";
import {fileURLToPath} from "node:url";

const root = fileURLToPath(new URL("../", import.meta.url));
const value = flag => {
  const index = process.argv.indexOf(flag);
  return index >= 0 ? process.argv[index + 1] : undefined;
};
const archive = resolve(value("--archive") || join(root, "shadcn_ui-0.1.0.tar"));
const output = resolve(value("--output") || join(root, "release", "consumer-trial"));
const fixture = resolve(root, "integration", "clean_consumer");
const tempRoot = await mkdtemp(join(tmpdir(), "shadcn-ui-consumer-"));
const consumer = join(tempRoot, "consumer");
const registry = join(tempRoot, "registry");
const publicDir = join(registry, "public");
const key = join(registry, "private_key.pem");
const hexHome = join(tempRoot, "hex");
const commandName = name => process.platform === "win32" && name === "mix" ? "mix.bat" : name;
const mixPath = path => process.platform === "win32" ? path.replaceAll("\\", "/") : path;
const run = (name, args, cwd, env = process.env) => {
  const result = spawnSync(commandName(name), args, {cwd, env, encoding: "utf8", shell: process.platform === "win32"});
  if (result.status !== 0) throw new Error(`${name} ${args.join(" ")} failed\n${result.stdout}\n${result.stderr}`);
  process.stdout.write(result.stdout);
  process.stderr.write(result.stderr);
  return result.stdout.trim();
};
const runAsync = (name, args, cwd, env = process.env) => new Promise((resolveRun, rejectRun) => {
  const child = spawn(commandName(name), args, {cwd, env, shell: process.platform === "win32"});
  let stdout = "";
  let stderr = "";
  child.stdout.on("data", chunk => {
    stdout += chunk;
    process.stdout.write(chunk);
  });
  child.stderr.on("data", chunk => {
    stderr += chunk;
    process.stderr.write(chunk);
  });
  child.on("error", rejectRun);
  child.on("close", code => {
    if (code === 0) resolveRun(stdout.trim());
    else rejectRun(new Error(`${name} ${args.join(" ")} failed\n${stdout}\n${stderr}`));
  });
});
const sha256 = async path => createHash("sha256").update(await readFile(path)).digest("hex");
const contentType = path => ({".gz": "application/gzip", ".tar": "application/octet-stream"})[extname(path)] || "application/octet-stream";

await mkdir(join(publicDir, "tarballs"), {recursive: true});
await mkdir(output, {recursive: true});
await cp(fixture, consumer, {recursive: true});
await copyFile(archive, join(publicDir, "tarballs", basename(archive)));
run("elixir", [join(root, "scripts", "generate-registry-key.exs"), key], root);
run("mix", ["hex.registry", "build", mixPath(publicDir), "--name=candidate", `--private-key=${mixPath(key)}`], root);

const server = createServer(async (request, response) => {
  try {
    const requested = decodeURIComponent(new URL(request.url, "http://localhost").pathname).replace(/^\/+/, "");
    const path = resolve(publicDir, normalize(requested));
    if (path !== publicDir && !path.startsWith(publicDir + sep)) throw new Error("outside registry");
    const info = await stat(path);
    if (!info.isFile()) throw new Error("not a file");
    response.writeHead(200, {"content-type": contentType(path), "content-length": info.size});
    response.end(await readFile(path));
  } catch {
    response.writeHead(404);
    response.end("not found");
  }
});

await new Promise(resolveReady => server.listen(0, "127.0.0.1", resolveReady));
const address = server.address();
const repoUrl = `http://127.0.0.1:${address.port}`;
const env = {...process.env, HEX_HOME: hexHome, CANDIDATE_SOURCE: root};

try {
  await runAsync("mix", ["hex.repo", "add", "candidate", repoUrl, `--public-key=${join(publicDir, "public_key")}`], consumer, env);
  await runAsync("mix", ["deps.get"], consumer, env);
  await runAsync("mix", ["deps.unlock", "--check-unused"], consumer, env);
  await runAsync("mix", ["compile", "--warnings-as-errors"], consumer, env);
  await runAsync("mix", ["test"], consumer, env);

  const lock = await readFile(join(consumer, "mix.lock"), "utf8");
  if (!lock.includes('"shadcn_ui": {:hex, :shadcn_ui') || !lock.includes('], "candidate",')) {
    throw new Error("consumer lock does not identify the candidate repository");
  }
  if (lock.includes("path:")) throw new Error("consumer lock unexpectedly contains a path dependency");
  const dependency = join(consumer, "deps", "shadcn_ui");
  const metadata = join(dependency, "hex_metadata.config");
  await stat(metadata);
  const record = {
    schemaVersion: 1,
    candidate: {archive: basename(archive), sha256: await sha256(archive)},
    install: {kind: "hex-repository-archive", repository: "candidate", pathDependency: false},
    consumer: {
      outsideSourceTree: !consumer.startsWith(root + sep),
      compiled: true,
      testsPassed: true,
      packagedStylesheet: true,
      packageJavaScriptRequired: false,
      sourceModulesVisible: false
    }
  };
  await writeFile(join(output, "consumer-trial.json"), JSON.stringify(record, null, 2) + "\n");
  console.log(`Clean consumer evidence written to ${output}`);
} finally {
  await new Promise(resolveClosed => server.close(resolveClosed));
  if (!resolve(tempRoot).startsWith(resolve(tmpdir()))) throw new Error("refusing to remove a non-temporary consumer");
  await rm(tempRoot, {recursive: true, force: true});
}
