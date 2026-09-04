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

    for id <- ["hex-publication", "public-version-tag"] do
      assert gates[id]["status"] == "pending"
      assert gates[id]["mandatory"]
    end

    for id <- [
          "clean-candidate",
          "actual-archive-consumer",
          "specled-main-head",
          "ci-final-revision",
          "merge"
        ] do
      assert gates[id]["status"] == "passed"
      assert gates[id]["mandatory"]
    end

    refute @candidate["qualification"]["qualified"]
  end

  test "section 3.3 binds successful main CI and retained logs to RELEASE_SHA" do
    ci = @evidence["section3_3"]
    workflow = ci["workflow"]
    retention = ci["retention"]
    release_sha = @evidence["section3_2"]["merge"]["releaseSha"]

    assert @evidence["release"]["status"] == "passed"
    assert ci["status"] == "passed"
    assert ci["sourceRevision"] == release_sha
    assert workflow["event"] == "push"
    assert workflow["runId"] == 33_881_762_954
    assert workflow["jobId"] == 101_051_845_295
    assert workflow["status"] == "completed"
    assert workflow["conclusion"] == "success"
    assert workflow["sourceMatchesReleaseSha"]
    assert workflow["allRequiredStepsPassed"]

    assert ci["toolchain"] == %{
             "dependencies" => "locked",
             "elixir" => "1.20.3",
             "node" => "22.13.1",
             "otp" => "29.0"
           }

    assert retention["kind"] == "github-actions-run-and-job-logs"
    assert retention["days"] == 90
    refute retention["namedArtifactProduced"]
    refute ci["contentChangedAfterCi"]
    assert @evidence["boundaries"]["exactMainCiSatisfied"]
    assert @candidate["evidence"]["publicReleasePhase3"]["exactMainCi"] == "passed"
  end

  test "section 3.2 selects the exact merge whose tree matches the qualification head" do
    merge = @evidence["section3_2"]
    pr = merge["qualificationPullRequest"]
    result = merge["merge"]

    assert merge["status"] == "passed"
    assert pr["requiredCheck"]["conclusion"] == "success"
    assert pr["requiredCheck"]["runId"] == 33_879_936_369
    assert pr["requiredCheck"]["jobId"] == 101_045_836_895
    assert result["releaseSha"] == "aa6a2d35474a51ea63248131631ace2b113b99a4"
    assert result["releaseTree"] == pr["headTree"]
    assert result["treeMatchesQualificationHead"]
    assert result["changedFilesAgainstQualificationHead"] == 0

    {head_tree, 0} =
      System.cmd("git", ["rev-parse", "#{pr["headRevision"]}^{tree}"], cd: @root)

    {release_tree, 0} =
      System.cmd("git", ["rev-parse", "#{result["releaseSha"]}^{tree}"], cd: @root)

    {changed_files, 0} =
      System.cmd("git", ["diff", "--name-only", pr["headRevision"], result["releaseSha"]],
        cd: @root
      )

    assert String.trim(head_tree) == pr["headTree"]
    assert String.trim(release_tree) == result["releaseTree"]
    assert changed_files == ""
    assert merge["localMain"]["revision"] == result["releaseSha"]
    assert merge["localMain"]["synchronizedWithOrigin"]
    assert merge["localMain"]["workingTreeClean"]
    assert @candidate["evidence"]["currentSourceRevision"] == result["releaseSha"]
  end

  test "the decision and plan expose the unreviewed state" do
    decision =
      File.read!(Path.join(@root, ".spec/decisions/waive-independent-review-for-1-0-0.md"))

    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert decision =~ "waived and non-mandatory for `1.0.0`"
    assert decision =~ "No independent review was performed"
    assert plan =~ "- [x] 3.1 Section - Resolve independent source-review disposition."
    assert plan =~ "- [x] 3.2 Section - Merge and identify `RELEASE_SHA`."
    assert plan =~ "- [x] 3.3 Section - Require CI on the exact merged revision."
    assert plan =~ "- [x] 3 Phase - Resolve review, merge, and select the immutable source."
    assert plan =~ "- [x] 4.1 Section - Build `RELEASE_SHA` twice from clean checkouts."
    assert plan =~ "- [x] 4.2 Section - Consume the final archive in isolation."
    assert plan =~ "- [x] 4.3 Section - Make the final go/no-go packet."
  end
end
