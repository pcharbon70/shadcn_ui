defmodule ShadcnUI.PublicHexReleasePhase3Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @evidence Path.join(@root, "release/public-release-phase-3.json")
            |> File.read!()
            |> Jason.decode!()
  @candidate Path.join(@root, "release/candidate-status.json") |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates

  test "section 3.1 records an exact release-scoped waiver without claiming review" do
    review = @evidence["section3_1"]
    pr = review["qualificationPullRequest"]
    waiver = review["ownerWaiver"]

    assert review["status"] == "waived"
    refute review["mandatory"]
    refute review["independentReviewPerformed"]
    refute review["approvalRecorded"]
    assert pr["number"] == 52
    assert pr["author"] == "pcharbon70"
    assert pr["headRevision"] == "fa56572ca9e72c04c29ae17b6df4821c1835ebd4"
    assert pr["reviewCount"] == 0
    assert pr["approvingReviewCount"] == 0
    assert waiver["status"] == "accepted-risk"
    assert waiver["scope"] == "1.0.0-only"
    assert waiver["url"] =~ "pull/52#issuecomment-5541919512"
  end

  test "the review waiver changes no technical or publication gate" do
    gates = Map.new(@candidate["gates"], &{&1["id"], &1})
    review = gates["deployment-source-review"]

    assert review["status"] == "waived"
    refute review["mandatory"]

    for id <- [
          "clean-candidate",
          "actual-archive-consumer",
          "specled-main-head",
          "ci-final-revision",
          "merge",
          "hex-publication",
          "public-version-tag"
        ] do
      assert gates[id]["status"] == "pending"
      assert gates[id]["mandatory"]
    end

    refute @candidate["qualification"]["qualified"]
  end

  test "the decision and plan expose the unreviewed state" do
    decision =
      File.read!(Path.join(@root, ".spec/decisions/waive-independent-review-for-1-0-0.md"))

    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert decision =~ "waived and non-mandatory for `1.0.0`"
    assert decision =~ "No independent review was performed"
    assert plan =~ "- [x] 3.1 Section - Resolve independent source-review disposition."
    assert plan =~ "- [ ] 3.2 Section - Merge and identify `RELEASE_SHA`."
    assert plan =~ "- [ ] 3.3 Section - Require CI on the exact merged revision."
  end
end
