import { createServer } from "node:http";
import { readFileSync } from "node:fs";
export async function serveMotionMediaExport(paths = ["/examples/motion-media-capabilities"]) {
  const root = new URL("../../../demo/export/", import.meta.url);
  const manifest = JSON.parse(readFileSync(new URL("route-manifest.json", root), "utf8"));
  const files = new Map();
  for (const entry of manifest.routes.filter(e => paths.includes(e.request.split("?")[0]) || e.status === 404)) {
    const record = { bytes: readFileSync(new URL(entry.file, root)), type: "text/html", status: entry.status };
    const path = "/shadcn_ui/" + entry.file;
    files.set(path, record);
    if (path.endsWith("index.html")) {
      files.set(path.slice(0, -10), record);
      // Directory hosts redirect before resolving relative CSS/media references.
      files.set(path.slice(0, -11), { redirect: path.slice(0, -10) });
    }
  }
  for (const file of Object.keys(manifest.assets)) files.set("/shadcn_ui/assets/" + file,
    { bytes: readFileSync(new URL("assets/" + file, root)), type: file.endsWith(".js") ? "text/javascript" : "text/css", status: 200 });
  for (const [file, record] of Object.entries(manifest.media)) files.set("/shadcn_ui/media/" + file,
    { bytes: readFileSync(new URL("media/" + file, root)), type: record.mime, status: 200 });
  const server = createServer((req, res) => {
    const file = files.get(new URL(req.url, "http://localhost").pathname) || files.get("/shadcn_ui/404.html");
    if (file.redirect) { res.writeHead(301, { Location: file.redirect }); res.end(); return; }
    res.writeHead(file.status, { "Content-Type": file.type }); res.end(file.bytes);
  });
  await new Promise(resolve => server.listen(0, "127.0.0.1", resolve));
  return {
    url: "http://127.0.0.1:" + server.address().port + "/shadcn_ui" + paths[0] + "/",
    close: () => new Promise((resolve, reject) => server.close(error => error ? reject(error) : resolve()))
  };
}
