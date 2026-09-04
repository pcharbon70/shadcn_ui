# Public `1.0.0` immutable-source selection

## Section 3.1 - Independent-review disposition

Qualification PR #52 has no review or approval. Its author and merger was
`pcharbon70`, and its exact head was
`fa56572ca9e72c04c29ae17b6df4821c1835ebd4`. Automated checks do not substitute
for independent source review.

At `2026-09-04T14:29:58Z`, the release owner recorded a signed GitHub comment
explicitly waiving the independent-source-review gate for `1.0.0` only and
accepting the resulting review risk. The waiver is recorded in
`.spec/decisions/waive-independent-review-for-1-0-0.md` and remains `waived`,
non-mandatory, and visibly unperformed. It is not a pass or approval.

No review findings exist because no review was performed; that absence is not
represented as a successful review. The waiver changes no automated, archive,
consumer, publication, verification, or tag requirement. Sections 3.2 and 3.3
remain pending until their exact merge and CI facts are recorded.

## Section 3.2 - Merge and `RELEASE_SHA`

Qualification PR #52's required `ShadcnUI gallery / verify` check completed
successfully before merge. GitHub merged the PR through its normal merge-commit
path at `2026-09-04T14:05:50Z`, producing
`aa6a2d35474a51ea63248131631ace2b113b99a4`. That full commit is selected as
`RELEASE_SHA`.

The qualification head and merge commit both resolve to tree
`6dc1d3f056196d13be1ec7529fbe2f9d4e59e4e7`; their content diff has zero
changed files. Local `main` was synchronized to the same revision with a clean
working tree. This proves that the merged candidate content is the content that
passed the PR workflow, while the independent-review disposition remains the
explicit `1.0.0` waiver recorded in Section 3.1.

This evidence/governance branch does not replace `RELEASE_SHA`: it changes no
package module, packaged CSS, package metadata, dependency lock, or archive
input. Phase 4 will build the selected SHA from detached clean checkouts.
Section 3.3 remains pending until the already completed exact-main workflow is
recorded separately.
