defmodule ShadcnUI.PublicHexReleasePhase4Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @evidence Path.join(@root, "release/public-release-phase-4.json")
            |> File.read!()
            |> Jason.decode!()
  @candidate Path.join(@root, "release/candidate-status.json") |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.deterministic_export
  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.clean_consumer_trial
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates

  test "section 4.1 binds two equivalent actual archives to RELEASE_SHA" do
    section = @evidence["section4_1"]
    builds = section["builds"]
    comparison = section["comparison"]

    assert section["status"] == "passed"
    assert length(builds) == 2
    assert Enum.map(builds, & &1["id"]) == ["build-a", "build-b"]
    assert Enum.all?(builds, &(&1["sourceRevision"] == @evidence["releaseSha"]))
    assert Enum.all?(builds, &(&1["actualArchiveAudit"] == "passed"))

    assert Enum.uniq(Enum.map(builds, & &1["archiveSha256"])) == [
             "547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da"
           ]

    assert comparison["status"] == "passed"
    assert comparison["equivalent"]
    assert comparison["actualArchivesByteIdentical"]
    assert comparison["archiveEntries"] == 63
    assert comparison["documentationFiles"] == 147
    assert comparison["galleryFiles"] == 646
    assert comparison["sourceRevision"] == @evidence["releaseSha"]
  end

  test "section 4.1 records pinned inputs and retained uncommitted evidence" do
    section = @evidence["section4_1"]
    toolchain = section["toolchain"]
    custody = section["evidenceCustody"]

    assert toolchain["elixir"] == "1.20.3"
    assert toolchain["otp"] == "29.0.5"
    assert toolchain["node"] == "22.13.1"

    assert toolchain["rebar3Sha256"] ==
             "8dead71212b8008ec830c085607c23ec2997ab1c36a3c91901ac42c9814ee08c"

    assert section["execution"]["detachedTemporaryWorktrees"] == 2
    assert section["execution"]["temporaryWorktreesRemoved"]
    assert custody["externalEvidenceDirectory"] =~ "/tmp/shadcn-ui-phase4."
    refute custody["generatedArtifactsCommitted"]
  end

  test "section 4.2 consumes the exact selected archive and removes its workspace" do
    gates = Map.new(@candidate["gates"], &{&1["id"], &1})
    consumer = @evidence["section4_2"]

    assert gates["clean-candidate"]["status"] == "passed"
    assert gates["clean-candidate"]["mandatory"]
    assert gates["actual-archive-consumer"]["status"] == "passed"
    assert gates["actual-archive-consumer"]["mandatory"]
    assert consumer["status"] == "passed"
    assert consumer["archiveSha256"] == @evidence["section4_1"]["comparison"]["archiveSha256"]
    assert consumer["archiveMatchesComparison"]
    assert consumer["install"]["signedRepository"]
    refute consumer["install"]["pathDependency"]
    assert consumer["consumer"]["outsideSourceTree"]
    assert consumer["consumer"]["compiled"]
    assert consumer["consumer"]["testsPassed"] == 3
    assert consumer["consumer"]["browserPassed"]
    assert consumer["consumer"]["packagedStylesheet"]
    refute consumer["consumer"]["consumerNodeRequired"]
    refute consumer["consumer"]["consumerTailwindRequired"]
    refute consumer["consumer"]["remoteAssetsRequired"]
    refute consumer["consumer"]["packageJavaScriptRequired"]
    assert consumer["cleanup"]["disposableConsumerRemoved"]
    assert consumer["cleanup"]["temporaryWorktreesRemaining"] == 0
    assert @evidence["boundaries"]["finalCleanCandidateGateSatisfied"]
    assert @evidence["boundaries"]["finalArchiveConsumerGateSatisfied"]
    refute @candidate["qualification"]["qualified"]
  end

  test "the plan marks Phase 4 sections 4.1 and 4.2 complete" do
    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert plan =~ "- [x] 4.1 Section - Build `RELEASE_SHA` twice from clean checkouts."
    assert plan =~ "- [x] 4.2 Section - Consume the final archive in isolation."
    assert plan =~ "- [ ] 4.3 Section - Make the final go/no-go packet."
  end
end
