defmodule ShadcnUI.PublicHexReleasePhase2Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @evidence_path Path.join(@root, "release/preliminary-candidate-evidence.json")
  @evidence @evidence_path |> File.read!() |> Jason.decode!()
  @candidate Path.join(@root, "release/candidate-status.json") |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.clean_consumer_trial
  # covers: shadcn_ui.release_publication.deterministic_export
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.release_publication.truthful_gates

  test "section 2.1 binds two equivalent builds to one exact preliminary revision" do
    preliminary = @evidence["preliminaryCandidate"]
    builds = preliminary["builds"]
    comparison = preliminary["comparison"]

    assert preliminary["sourceRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert Enum.map(builds, & &1["id"]) == ["premerge-a", "premerge-b"]

    assert Enum.uniq(Enum.map(builds, & &1["archiveSha256"])) == [
             "547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da"
           ]

    assert Enum.all?(builds, &(&1["archiveBytes"] == 90_112))
    assert comparison["status"] == "passed"
    assert comparison["equivalent"]
    assert comparison["archiveEntries"] == 63
    assert comparison["galleryFiles"] == 646
    assert comparison["documentationFiles"] == 147
  end

  test "section 2.1 records the explicit archive audit without storing the archive" do
    audit = @evidence["preliminaryCandidate"]["archiveAudit"]
    custody = @evidence["evidenceCustody"]

    assert audit["status"] == "passed"
    assert audit["explicitAllowlist"]

    for required <- [
          "requiredLicense",
          "requiredThirdPartyNotices",
          "requiredDocumentation",
          "requiredCompiledStylesheet",
          "requiredPublicModules",
          "requiredMixMetadata"
        ] do
      assert audit[required]
    end

    refute custody["generatedArchivesCommitted"]
    refute custody["generatedDocumentationCommitted"]
    refute custody["credentialsCommitted"]
  end

  test "section 2.2 consumes the same archive through an isolated Hex repository" do
    preliminary = @evidence["preliminaryCandidate"]
    consumer = @evidence["isolatedConsumer"]
    install = consumer["install"]

    assert consumer["status"] == "passed"
    assert consumer["archiveSha256"] == hd(preliminary["builds"])["archiveSha256"]

    assert install == %{
             "kind" => "hex-repository-archive",
             "pathDependency" => false,
             "repository" => "candidate"
           }

    assert consumer["outsideSourceTree"]
    assert consumer["compiled"]
    assert consumer["testsPassed"] == 3
    assert consumer["browserPassed"]
    assert consumer["packagedStylesheet"]
    refute consumer["consumerNodeRequired"]
    refute consumer["consumerTailwindRequired"]
    refute consumer["remoteAssetsRequired"]
    refute consumer["packageJavaScriptRequired"]
    refute consumer["sourceModulesVisible"]
  end

  test "preliminary evidence does not pre-claim final release gates" do
    boundaries = @evidence["boundaries"]
    gates = Map.new(@candidate["gates"], &{&1["id"], &1["status"]})

    assert boundaries["preliminary"]
    refute boundaries["releaseShaSelected"]
    refute boundaries["finalCleanCandidateGateSatisfied"]
    refute boundaries["finalArchiveConsumerGateSatisfied"]
    refute boundaries["publishedToHex"]
    refute boundaries["tagCreated"]
    assert gates["clean-candidate"] == "passed"
    assert gates["actual-archive-consumer"] == "pending"
    assert gates["public-release-phase-2-premerge"] == "passed"
    assert gates["hex-publication"] == "pending"
    assert gates["public-version-tag"] == "pending"
    refute @candidate["qualification"]["qualified"]
  end

  test "section 2.3 records complete pre-merge verification" do
    verification = @evidence["qualificationVerification"]

    assert verification["status"] == "passed"

    assert verification["packagePrecommit"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 435
           }

    assert verification["demoPrecommit"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 169
           }

    assert verification["documentation"]["warnings"] == 0
    assert verification["archiveAudit"]["entries"] == 63
    assert verification["galleryExport"]["routes"] == 634
    assert verification["browserAcceptance"]["testInvocations"] == 552

    assert verification["browserAcceptance"]["engines"] == [
             "chromium",
             "firefox",
             "webkit"
           ]

    assert verification["releaseEvidenceChecks"]["status"] == "passed"

    assert verification["specLed"] == %{
             "base" => "origin/main",
             "branchFindings" => 0,
             "errors" => 0,
             "status" => "passed",
             "warnings" => 0
           }

    assert verification["diffCheck"] == "passed"
  end

  test "the execution plan distinguishes pre-merge completion from final release" do
    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert plan =~ "- [x] 2 Phase - Prove the candidate before merge."
    assert plan =~ "- [x] 2.1 Section - Produce preliminary clean candidate evidence."
    assert plan =~ "- [x] 2.2 Section - Prove preliminary isolated consumption."
    assert plan =~ "- [x] 2.3 Section - Complete the qualification PR."
    assert plan =~ "- [x] 3.1 Section - Resolve independent source-review disposition."
    assert plan =~ "- [x] 3.2 Section - Merge and identify `RELEASE_SHA`."
    assert plan =~ "- [x] 3.3 Section - Require CI on the exact merged revision."
    assert plan =~ "- [x] 4.1 Section - Build `RELEASE_SHA` twice from clean checkouts."
    assert plan =~ "- [ ] 4.2 Section - Consume the final archive in isolation."
  end
end
