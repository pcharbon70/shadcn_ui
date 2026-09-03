import {readFileSync} from "node:fs";
import {dirname, join, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const acceptance = readJson(
  "demo/priv/reference/milestone_g/remediation-r6-acceptance-evidence.json",
);
const deployment = readJson(
  "demo/priv/reference/milestone_g/remediation-r6-deployment-evidence.json",
);
const candidate = readJson("release/candidate-status.json");
const plan = readFileSync(
  join(
    root,
    ".spec/planning/milestone-g-unscripted-style-gallery-presentation-parity/live-visual-review-remediation.md",
  ),
  "utf8",
);

function readJson(path) {
  return JSON.parse(readFileSync(join(root, path), "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

assert(
  acceptance.status === "r6-remediation-delivery-evidence-complete-candidate-blocked",
  "R6.4 acceptance state drifted",
);
assert(acceptance.exactSourceRevision === null, "containing commit claims its own revision");
assert(
  Object.values(acceptance.sections).every((section) =>
    ["complete", "recorded-in-containing-commit"].includes(section.status)
  ),
  "an R6 section is incomplete",
);
assert(Object.keys(acceptance.reviewIssues).length === 11, "review issue inventory drifted");
assert(acceptance.reviewIssues["VR-11"] === "manual-risk-accepted-pending", "VR-11 was promoted");
assert(acceptance.workflow.passingRun.status === "passed", "initial PR CI is not passing");
assert(acceptance.workflow.finalEvidenceRevisionCi === "pending-after-containing-commit", "final CI was invented");
assert(acceptance.workflow.merge === "owner-authorized-pending-final-ci", "merge state drifted");
assert(acceptance.deployment.canonicalSmoke === "passed", "deployed canonical smoke failed");
assert(acceptance.deployment.deployedBrowser.failures === 0, "deployed browser failures remain");
assert(acceptance.manualAccessibility.pending === 6, "manual scenario count drifted");
assert(acceptance.manualAccessibility.passed === 0, "manual evidence was promoted");
assert(acceptance.visualAndFunctionalResult.unresolvedReachabilityFocusSemanticReducedMotionOrPinnedParityFailures.length === 0, "an unresolved automated deployment blocker remains");
assert(acceptance.planReconciliation.milestoneG === "open", "Milestone G was promoted");
assert(acceptance.planReconciliation.candidateQualification === "blocked", "candidate was promoted");
assert(acceptance.remainingMandatoryCandidateBlockers.length === 4, "candidate blocker inventory drifted");

assert(candidate.qualification.status === "blocked", "candidate qualification is not blocked");
assert(candidate.qualification.qualified === false, "candidate was qualified");
assert(candidate.evidence.deployedRevision === acceptance.deployment.sourceRevision, "candidate deployment revision drifted");
assert(
  candidate.gates.find((gate) => gate.id === "manual-accessibility")?.status === "pending",
  "candidate manual gate was promoted",
);
assert(
  candidate.gates.find((gate) => gate.id === "ci-final-revision")?.status === "pending",
  "candidate final CI was promoted",
);
assert(
  candidate.gates.find((gate) => gate.id === "deployment-source-review")?.status === "pending",
  "candidate source review was promoted",
);

assert(deployment.status === "passed-reviewed-workflow-deployment-and-smoke", "R6.3 is not passing");
assert(deployment.source.deployedRevision === acceptance.deployment.sourceRevision, "R6 evidence revisions differ");
assert(plan.includes("- [x] R6 Phase"), "R6 phase is not reconciled");
assert(plan.includes("- [x] R6.3 Section"), "R6.3 is not reconciled");
assert(plan.includes("- [x] R6.4 Section"), "R6.4 is not reconciled");

console.log("Verified R6.4 acceptance with candidate and Milestone G still blocked.");
