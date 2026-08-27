import {readFile, writeFile} from "node:fs/promises";
import {resolve} from "node:path";

const value = flag => {
  const index = process.argv.indexOf(flag);
  return index >= 0 ? process.argv[index + 1] : undefined;
};
const first = resolve(value("--first") || "");
const second = resolve(value("--second") || "");
const output = value("--output");
if (!value("--first") || !value("--second")) throw new Error("--first and --second evidence directories are required");

const load = async directory => JSON.parse(await readFile(resolve(directory, "candidate-build.json")));
const left = await load(first);
const right = await load(second);
const comparable = record => ({
  schemaVersion: record.schemaVersion,
  candidateVersion: record.candidateVersion,
  sourceRevision: record.sourceRevision,
  inputsSha256: record.inputsSha256,
  provenanceSha256: record.provenanceSha256,
  outputs: record.outputs
});
const leftText = JSON.stringify(comparable(left));
const rightText = JSON.stringify(comparable(right));
if (leftText !== rightText) {
  const keys = ["sourceRevision", "inputsSha256", "provenanceSha256", "outputs"];
  const different = keys.filter(key => JSON.stringify(left[key]) !== JSON.stringify(right[key]));
  throw new Error(`candidate builds differ: ${different.join(", ")}`);
}

const result = {
  schemaVersion: 1,
  equivalent: true,
  sourceRevision: left.sourceRevision,
  candidateVersion: left.candidateVersion,
  archiveSha256: left.outputs.archive.sha256,
  compiledCssSha256: left.outputs.compiledCss.sha256,
  galleryFiles: left.outputs.galleryExport.files,
  documentationFiles: left.outputs.documentation.files,
  archiveEntries: Object.keys(left.outputs.archive.inventory).length
};
if (output) await writeFile(resolve(output), JSON.stringify(result, null, 2) + "\n");
console.log(`Candidate builds are equivalent at ${left.sourceRevision}.`);
