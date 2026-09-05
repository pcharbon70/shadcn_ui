defmodule ShadcnUI.PublicHexReleasePhase5Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @evidence Path.join(@root, "release/public-release-phase-5.json")
            |> File.read!()
            |> Jason.decode!()
  @candidate Path.join(@root, "release/candidate-status.json") |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates

  test "section 5.1 binds the final dry run to the immutable approved archive" do
    section = @evidence["section5_1"]
    checkout = section["checkout"]
    build = section["build"]

    assert section["status"] == "passed"
    assert checkout["detached"]
    assert checkout["sourceRevision"] == @evidence["releaseSha"]
    refute checkout["trackedChanges"]
    assert checkout["retainedForAuthorizedPublication"]

    assert build["status"] == "passed"
    assert build["archiveAudit"] == "passed"
    assert build["archiveEntries"] == 63
    assert build["archiveSha256"] == build["approvedArchiveSha256"]
    assert build["byteIdenticalToApprovedArchive"]
    assert build["archiveSha256"] == @candidate["evidence"]["currentArchiveSha256"]
  end

  test "the supported Hex dry run records the exact public package metadata" do
    section = @evidence["section5_1"]
    dry_run = section["publishDryRun"]
    package = dry_run["package"]

    assert section["hexIdentity"] == %{
             "authenticatedOwner" => "pcharbon70",
             "command" => "mix hex.user whoami",
             "organization" => nil,
             "repository" => "hexpm",
             "status" => "passed"
           }

    assert dry_run["status"] == "passed"
    assert dry_run["command"] == "mix hex.publish --dry-run --yes"
    assert dry_run["nonPublishing"]
    assert package["app"] == "shadcn_ui"
    assert package["name"] == "shadcn_ui"
    assert package["version"] == "1.0.0"
    assert package["licenses"] == ["MIT"]
    assert package["buildTools"] == ["mix"]
    assert package["elixir"] == "~> 1.17"

    assert package["dependencies"] == [
             %{"name" => "phoenix_html", "requirement" => "~> 4.1"},
             %{"name" => "phoenix_live_view", "requirement" => "~> 1.2"}
           ]

    assert dry_run["documentation"]["generated"]
  end

  test "section 5.2 records one exact publication authorization without publishing" do
    absence = @evidence["section5_1"]["publicHexAbsence"]
    authorization = @evidence["section5_2"]
    action = authorization["authorizedAction"]
    boundaries = @evidence["boundaries"]
    gates = Map.new(@candidate["gates"], &{&1["id"], &1})

    assert absence["status"] == "absent"
    assert absence["checkedAfterDryRun"]
    assert absence["result"] == "No package with name shadcn_ui"
    assert boundaries["dryRunPassed"]
    assert authorization["status"] == "authorized"
    assert authorization["response"] == "yes you are authorized"
    assert action["command"] == "mix hex.publish --yes"
    assert action["repository"] == "hexpm"
    assert action["organization"] == nil
    assert action["package"] == "shadcn_ui"
    assert action["version"] == "1.0.0"
    assert action["owner"] == "pcharbon70"
    assert action["releaseSha"] == @evidence["releaseSha"]
    assert action["archiveSha256"] == @candidate["evidence"]["currentArchiveSha256"]
    assert action["packageAndDocumentation"]
    assert action["executeExactlyOnce"]
    assert boundaries["publicationAuthorizationRecorded"]
    assert boundaries["hexPublishAuthorized"]
    refute boundaries["publishedToHex"]
    refute boundaries["tagCreated"]
    assert gates["hex-publication"]["status"] == "pending"
    assert gates["public-version-tag"]["status"] == "pending"
    refute @candidate["qualification"]["qualified"]
  end

  test "the plan marks Sections 5.1 and 5.2 complete" do
    plan = File.read!(Path.join(@root, ".spec/planning/public-hex-1-0-0-release/README.md"))

    assert plan =~ "- [x] 5.1 Section - Perform the final dry run."
    assert plan =~ "- [x] 5.2 Section - Obtain irreversible-action authorization."
    assert plan =~ "- [ ] 5.3 Section - Publish exactly once."
  end
end
