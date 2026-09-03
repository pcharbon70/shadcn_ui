import {readFileSync} from "node:fs";
import {dirname, join, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const evidence = readJson(
  "demo/priv/reference/milestone_g/remediation-r6-manual-risk-evidence.json",
);
const candidate = readJson("release/candidate-status.json");
const ledger = readFileSync(join(root, "release/records/accessibility-review.md"), "utf8");

function readJson(path) {
  return JSON.parse(readFileSync(join(root, path), "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

assert(
  evidence.status === "risk-accepted-manual-review-pending",
  "R6.1 risk acceptance is not recorded",
);
assert(evidence.authorization.doesNotAuthorizeDeployment, "waiver authorizes deployment");
assert(evidence.authorization.doesNotQualifyCandidate, "waiver qualifies the candidate");
assert(evidence.authorization.doesNotClaimConformance, "waiver claims conformance");
assert(evidence.scenarios.length === 4, "R6 manual scenario inventory drifted");
assert(
  evidence.scenarios.every(
    (scenario) => scenario.status === "PENDING" && scenario.disposition === "risk-accepted-not-run",
  ),
  "an unexecuted R6 scenario was promoted to a pass",
);
assert(evidence.gateEffect.manualAccessibility === "pending", "manual gate is not pending");
assert(evidence.gateEffect.candidateQualification === "blocked", "candidate is not blocked");
assert(evidence.gateEffect.wcagCertification === "not-claimed", "WCAG certification is claimed");
assert(candidate.qualification.qualified === false, "candidate was incorrectly qualified");
assert(candidate.qualification.status === "blocked", "candidate qualification is not blocked");
assert(
  candidate.gates.find((gate) => gate.id === "manual-accessibility")?.status === "pending",
  "candidate manual-accessibility gate was promoted",
);

for (let scenario = 1; scenario <= 6; scenario += 1) {
  const section = ledger.match(
    new RegExp(`### MAN-0${scenario} —[\\s\\S]*?(?=\\n### MAN-|\\n## Qualification gate)`),
  )?.[0];
  assert(section, `MAN-0${scenario} is missing from the ledger`);
  assert(section.includes("- Status: PENDING"), `MAN-0${scenario} is not pending`);
}

assert(/does\s+not authorize a Fly deployment/.test(ledger), "deployment boundary is missing");
assert(/not a\s+manual pass/.test(ledger), "manual non-pass boundary is missing");

console.log("Verified scoped R6 manual-accessibility risk acceptance without gate promotion.");
