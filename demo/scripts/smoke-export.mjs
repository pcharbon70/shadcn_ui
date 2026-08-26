// Verify the exact static artifact under a repository-site subpath, without Phoenix.
import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
import { createHash } from "node:crypto";

const root = new URL("../export/", import.meta.url);
const manifest = JSON.parse(await readFile(new URL("route-manifest.json", root), "utf8"));
const files = new Map();
for (const entry of manifest.routes) {
  const bytes = await readFile(new URL(entry.file, root));
  const path = `/shadcn_ui/${entry.file}`;
  files.set(path, { bytes, status: entry.status, type: "text/html" });
  if (path.endsWith("index.html")) {
    files.set(path.slice(0, -10), files.get(path));
    files.set(path.slice(0, -11), files.get(path));
  }
}
for (const asset of Object.keys(manifest.assets)) {
  files.set(`/shadcn_ui/assets/${asset}`, { bytes: await readFile(new URL(`assets/${asset}`, root)), status: 200, type: asset.endsWith(".css") ? "text/css" : "text/javascript" });
}
const server = createServer((req, res) => {
  // Serve only the loaded manifest; request input can never select a file path.
  const file = files.get(new URL(req.url, "http://127.0.0.1").pathname) || files.get("/shadcn_ui/404.html");
  res.writeHead(file.status, { "Content-Type": file.type });
  res.end(file.bytes);
});
await new Promise(resolve => server.listen(0, "127.0.0.1", resolve));
const base = `http://127.0.0.1:${server.address().port}/shadcn_ui/`;
try {
  for (const entry of manifest.routes) {
    const path = entry.file.replace(/index\.html$/, "");
    const response = await fetch(new URL(path, base), { redirect: "error" });
    const body = await response.text();
    if (response.status !== entry.status || createHash("sha256").update(body).digest("hex") !== entry.sha256) throw new Error(`static route drift: ${path}`);
    for (const match of body.matchAll(/(?:src|href)="([^"]+\.(?:css|js))"/g)) {
      const url = new URL(match[1], response.url);
      if (!url.href.startsWith(base) || !(await fetch(url)).ok) throw new Error(`broken subpath asset: ${url}`);
    }
  }
  const missing = await fetch(new URL("components/unknown/untrusted", base));
  if (missing.status !== 404 || (await missing.text()).includes("untrusted")) throw new Error("invalid static 404");
  console.log(`Static subpath smoke passed: ${manifest.routes.length} routes and ${Object.keys(manifest.assets).length} local assets.`);
} finally {
  await new Promise((resolve, reject) => server.close(error => error ? reject(error) : resolve()));
}
