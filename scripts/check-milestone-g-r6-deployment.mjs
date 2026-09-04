import {createHash} from "node:crypto";
import {readFileSync} from "node:fs";
import {dirname, join, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const evidence = readJson(
  "demo/priv/reference/milestone_g/remediation-r6-deployment-evidence.json",
);
const release = readJson("release/fly-deployment-evidence.json");

function readJson(path) {
  return JSON.parse(readFileSync(join(root, path), "utf8"));
}

function sha256(path) {
  return createHash("sha256").update(readFileSync(join(root, path))).digest("hex");
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

const revision = evidence.source.deployedRevision;

assert(
  evidence.status === "passed-reviewed-workflow-deployment-and-smoke",
  "R6.3 deployment evidence is not passing",
);
assert(/^[0-9a-f]{40}$/.test(revision), "deployed revision is not immutable");
assert(evidence.authorization.manualAccessibilityWaiverIsNotDeploymentAuthorization, "waiver authorized deployment");
assert(evidence.source.cleanDetachedWorktree, "deployment did not use a clean detached worktree");
assert(evidence.source.pullRequest.number === 43, "deployment pull request drifted");
assert(evidence.source.pullRequest.headRevision === revision, "PR head and deployed revision differ");
assert(evidence.source.ci.status === "passed", "pre-deploy CI did not pass");
assert(evidence.source.ci.runId === 33751442399, "pre-deploy CI run drifted");

assert(evidence.release.status === "complete", "Fly release is incomplete");
assert(evidence.release.version === 3, "Fly release version drifted");
assert(/^rel_[a-z0-9]+$/.test(evidence.release.flyMachineReleaseId), "Fly Machine release ID is invalid");
assert(/^sha256:[0-9a-f]{64}$/.test(evidence.release.imageDigest), "Fly image digest is invalid");
assert(evidence.release.serviceChecks === "1-passing", "Fly service check did not pass");
assert(evidence.priorRelease.retainedInFlyReleaseHistory, "prior release was not retained");
assert(!evidence.priorRelease.eligibleRollbackCandidate, "unreviewed prior release was promoted");
assert(evidence.rollback.priorReviewedSmokeVerifiedFlyRelease === null, "invented rollback candidate");

assert(evidence.canonicalSmoke.status === "passed", "canonical Fly smoke failed");
assert(evidence.canonicalSmoke.expectedRevision === revision, "canonical smoke revision drifted");
assert(
  sha256(evidence.canonicalSmoke.verifier.path) === evidence.canonicalSmoke.verifier.sha256,
  "canonical smoke verifier drifted",
);

assert(evidence.deployedBrowser.status === "passed", "deployed browser smoke failed");
assert(evidence.deployedBrowser.tests === 2, "deployed browser test count drifted");
assert(evidence.deployedBrowser.failures === 0, "deployed browser failures were recorded");
assert(
  evidence.deployedBrowser.config.relocation.revision ===
    "23598d7072a507264c0d032375b5f42165c70ddf",
  "deployed browser config relocation revision drifted",
);
assert(
  sha256(evidence.deployedBrowser.config.path) ===
    evidence.deployedBrowser.config.relocation.sha256,
  "deployed browser config drifted",
);
assert(
  sha256(evidence.deployedBrowser.test.path) === evidence.deployedBrowser.test.sha256,
  "deployed browser test drifted",
);
assert(evidence.responseHashes.length === 7, "deployed response hash inventory drifted");
assert(
  evidence.responseHashes.every(
    (response) => response.status === 200 && /^[0-9a-f]{64}$/.test(response.sha256),
  ),
  "a deployed response is not a hashed success",
);

const retainedR6Release = release.rollback.retainedPriorOperationalRelease;
assert(retainedR6Release.sourceRevision === revision, "retained R6 release revision drifted");
assert(
  retainedR6Release.flyReleaseId === evidence.release.flyMachineReleaseId,
  "retained R6 Fly release IDs disagree",
);
assert(
  retainedR6Release.imageDigest === evidence.release.imageDigest,
  "retained R6 Fly image digests disagree",
);
assert(
  release.health.reportedSourceRevision === release.release.sourceRevision,
  "current health revision drifted",
);
assert(release.canonicalSmoke.status === "passed", "release canonical smoke failed");
assert(release.deployedBrowserSmoke.status === "passed", "release browser smoke failed");
assert(release.rollback.priorReviewedSmokeVerifiedFlyRelease === null, "release record invents rollback");

assert(
  evidence.separateGates.manualAccessibility === "pending-risk-accepted-for-r6-progression",
  "manual accessibility was promoted",
);
assert(evidence.separateGates.candidateQualification === "blocked", "candidate was qualified");

console.log(`Verified R6.3 Fly release ${evidence.release.flyMachineReleaseId} at ${revision}.`);
