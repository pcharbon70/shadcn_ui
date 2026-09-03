import {createServer} from "node:http";
import {readFileSync, statSync} from "node:fs";
import {extname, join, normalize, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(
  fileURLToPath(new URL("../demo/priv/reference/milestone_g/pinned-reference/site", import.meta.url)),
);
const port = Number.parseInt(process.env.REFERENCE_PORT ?? "4132", 10);
const contentTypes = new Map([
  [".css", "text/css; charset=utf-8"],
  [".gif", "image/gif"],
  [".html", "text/html; charset=utf-8"],
  [".svg", "image/svg+xml; charset=utf-8"],
  [".woff2", "font/woff2"],
]);

function resolveRequest(pathname) {
  const requested = pathname === "/components/accordion" ? "/components/accordion/" : pathname;
  const relative = requested.endsWith("/") ? `${requested}index.html` : requested;
  const path = normalize(join(root, relative));
  return path.startsWith(`${root}/`) ? path : null;
}

const server = createServer((request, response) => {
  const url = new URL(request.url ?? "/", `http://${request.headers.host ?? "127.0.0.1"}`);
  const path = resolveRequest(url.pathname);

  try {
    if (!path || !statSync(path).isFile()) throw new Error("not found");
    response.writeHead(200, {
      "cache-control": "no-store",
      "content-type": contentTypes.get(extname(path)) ?? "application/octet-stream",
    });
    response.end(readFileSync(path));
  } catch {
    response.writeHead(404, {"content-type": "text/plain; charset=utf-8"});
    response.end("Not found\n");
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`Pinned reference listening on http://127.0.0.1:${port}`);
});

for (const signal of ["SIGINT", "SIGTERM"]) {
  process.on(signal, () => server.close(() => process.exit(0)));
}
