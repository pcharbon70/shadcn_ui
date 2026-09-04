defmodule ShadcnUI.PublicHexReleasePhase1Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @preflight_path Path.join(@root, "release/public-release-preflight.json")
  @preflight @preflight_path |> File.read!() |> Jason.decode!()
  @candidate Path.join(@root, "release/candidate-status.json") |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.deployment_workflow
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates
  # covers: shadcn_ui.release_publication.version_identity

  test "section 1.1 records the exact synchronized release boundary" do
    release = @preflight["release"]
    boundary = @preflight["sourceBoundary"]
    authority = @preflight["authority"]

    assert release["package"] == "shadcn_ui"
    assert release["version"] == Mix.Project.config()[:version]
    assert release["qualificationBranch"] == "codex/public-1-0-0-release-phase-1"
    assert release["branchBaseRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert authority["releaseOwner"] == "pcharbon70"
    assert authority["intendedHexAccount"] == "pcharbon70"
    assert authority["hexOrganization"] == nil
    assert authority["reviewMethod"] == "approving GitHub review"
    assert authority["independentReviewerRequired"]

    assert boundary["deployedRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert boundary["comparedThroughRevision"] == release["branchBaseRevision"]
    assert boundary["commitCount"] == 7
    assert boundary["changedFileCount"] == length(boundary["changedFiles"])
    assert boundary["changedFilesSha256"] =~ ~r/^[0-9a-f]{64}$/
  end

  test "section 1.1 inventory is reproducible and excludes material deployment changes" do
    boundary = @preflight["sourceBoundary"]
    range = "#{boundary["deployedRevision"]}..#{boundary["comparedThroughRevision"]}"

    {files, 0} = System.cmd("git", ["diff", "--name-only", range], cd: @root)
    changed_files = files |> String.split("\n", trim: true)
    digest = :crypto.hash(:sha256, files) |> Base.encode16(case: :lower)

    assert changed_files == boundary["changedFiles"]
    assert digest == boundary["changedFilesSha256"]

    material_paths = [
      "lib/",
      "priv/static/",
      "demo/lib/",
      "demo/assets/",
      "mix.exs",
      "package.json",
      "package-lock.json",
      "demo/package.json",
      "demo/package-lock.json"
    ]

    refute Enum.any?(changed_files, fn path ->
             Enum.any?(material_paths, &String.starts_with?(path, &1))
           end)

    refute boundary["materialGalleryOrPackageChange"]
    refute boundary["replacementFlyDeploymentRequired"]
  end

  test "section 1.1 retains a secret-free clean-worktree policy" do
    working_tree = @preflight["workingTree"]

    assert working_tree["cleanAtSectionStart"]
    refute working_tree["generatedArchivesTracked"]
    refute working_tree["generatedDocsTracked"]
    refute working_tree["credentialsTracked"]
    refute working_tree["evidenceSecretsTracked"]
  end

  test "section 1.2 binds consistent package metadata without claiming publication" do
    metadata = @preflight["metadataAndToolchain"]["metadata"]
    project = Mix.Project.config()
    readme = File.read!(Path.join(@root, "README.md"))
    changelog = File.read!(Path.join(@root, "CHANGELOG.md"))
    release = File.read!(Path.join(@root, "RELEASE.md"))
    notices = File.read!(Path.join(@root, "THIRD_PARTY_NOTICES.md"))

    assert metadata["mixProjectVersion"] == project[:version]
    assert project[:package][:licenses] == ["MIT"]
    assert project[:package][:links]["Gallery"] == metadata["links"]["gallery"]
    assert project[:package][:links]["GitHub"] == metadata["links"]["github"]
    assert readme =~ "Version `1.0.0` is being prepared"
    assert readme =~ "is not\n> published yet"
    assert changelog =~ "## 1.0.0 — unreleased"
    assert release =~ "pending and unassessed"
    assert release =~ "waived and\nnon-mandatory for `1.0.0`"
    assert notices =~ "MIT License"
    assert File.exists?(Path.join(@root, "priv/provenance/unscripted_ui.json"))
  end

  test "section 1.2 records authenticated new-package authority without credentials" do
    authority = @preflight["authority"]
    encoded = Jason.encode!(@preflight)

    assert authority["hexIdentityVerification"]["status"] == "passed"
    assert authority["hexIdentityVerification"]["authenticatedIdentity"] == "pcharbon70"
    assert authority["hexPackageAvailability"]["status"] == "absent"
    assert authority["hexPackageAvailability"]["result"] == "No package with name shadcn_ui"

    assert authority["permissionAssessment"]["status"] ==
             "passed-for-new-personal-package-preflight"

    refute encoded =~ "api_key"
    refute encoded =~ "apiKey"
    refute encoded =~ "token"
    refute encoded =~ "secret"
  end

  test "section 1.2 pins the active toolchain, locks, and browser input relationship" do
    inputs =
      @root |> Path.join("release/candidate-inputs.json") |> File.read!() |> Jason.decode!()

    observed = @preflight["metadataAndToolchain"]
    browser_path = Path.join(@root, inputs["browserEvidence"])
    browser = browser_path |> File.read!() |> Jason.decode!()

    assert observed["status"] == "passed"
    assert observed["candidateInputCheck"] == "passed"
    assert observed["toolchain"]["rebar3Sha256"] == inputs["rebar3"]["sha256"]

    for {name, expected} <- inputs["toolchain"] do
      assert observed["toolchain"][name] == expected
    end

    for {relative, expected} <- inputs["locks"] do
      actual =
        @root
        |> Path.join(relative)
        |> File.read!()
        |> then(&:crypto.hash(:sha256, &1))
        |> Base.encode16(case: :lower)

      assert actual == expected
      assert observed["locks"][relative] == expected
    end

    assert browser["evidenceType"] == "release-browser-input-linkage-not-browser-outcome"
    assert browser["lock"]["playwright"] == inputs["toolchain"]["playwright"]
    assert browser["lock"]["packageLockSha256"] == inputs["locks"]["demo/package-lock.json"]
    refute browser["lockRelationship"]["browserDependencyGraphChanged"]
    refute browser["lockRelationship"]["runtimeOrGalleryBehaviorChanged"]
    assert browser["qualificationBoundary"]["finalBrowserAcceptance"] == "pending-phase-2"
  end

  test "section 1.3 reconciles Phase 1 while every later mandatory gate stays separate" do
    reconciliation = @preflight["ledgerReconciliation"]
    gates = Map.new(@candidate["gates"], &{&1["id"], &1})

    assert reconciliation["status"] == "passed"
    assert reconciliation["qualification"] == "blocked"

    assert reconciliation["verification"]["focusedReleaseTests"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 20
           }

    assert reconciliation["verification"]["specLed"] == %{
             "base" => "origin/main",
             "branchFindings" => 0,
             "errors" => 0,
             "status" => "passed",
             "warnings" => 0
           }

    assert gates["public-release-phase-1-preflight"]["status"] == "passed"
    assert gates["public-release-phase-1-preflight"]["mandatory"]

    resolved = [
      "clean-candidate",
      "deployment-source-review",
      "merge",
      "specled-main-head",
      "ci-final-revision"
    ]

    for id <- reconciliation["pendingMandatoryGates"] -- resolved do
      assert gates[id]["status"] == "pending"
      assert gates[id]["mandatory"]
    end

    assert "deployment-source-review" in reconciliation["pendingMandatoryGates"]
    assert gates["deployment-source-review"]["status"] == "waived"
    refute gates["deployment-source-review"]["mandatory"]
    assert "merge" in reconciliation["pendingMandatoryGates"]
    assert gates["merge"]["status"] == "passed"
    assert gates["merge"]["mandatory"]

    for id <- ["specled-main-head", "ci-final-revision"] do
      assert id in reconciliation["pendingMandatoryGates"]
      assert gates[id]["status"] == "passed"
      assert gates[id]["mandatory"]
    end

    assert "clean-candidate" in reconciliation["pendingMandatoryGates"]
    assert gates["clean-candidate"]["status"] == "passed"
    assert gates["clean-candidate"]["mandatory"]

    manual = reconciliation["manualAccessibility"]
    assert manual["evidence"] == "pending"
    refute manual["mandatory"]
    assert manual["status"] == "waived"
    assert gates["manual-accessibility"]["status"] == "waived"
    refute gates["manual-accessibility"]["mandatory"]
    refute @candidate["qualification"]["qualified"]
    assert @candidate["qualification"]["status"] == "blocked"
  end

  test "section 1.3 keeps Phase 1 evidence discoverable and publication absent" do
    preflight = @candidate["evidence"]["publicReleasePreflight"]
    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert preflight["path"] == "release/public-release-preflight.json"
    assert preflight["status"] == "passed-phase-1"
    refute preflight["replacementFlyDeploymentRequired"]
    assert plan =~ "- [x] 1 Phase - Establish release authority and freeze inputs."
    assert plan =~ "- [x] 1.3 Section - Reconcile the pre-publication ledger."
    assert plan =~ "- [x] 2.1 Section - Produce preliminary clean candidate evidence."
    assert plan =~ "- [x] 2.2 Section - Prove preliminary isolated consumption."
    assert plan =~ "- [x] 2.3 Section - Complete the qualification PR."

    assert Map.new(@candidate["gates"], &{&1["id"], &1["status"]})["hex-publication"] ==
             "pending"
  end
end
