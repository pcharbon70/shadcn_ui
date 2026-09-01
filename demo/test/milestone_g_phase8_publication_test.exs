defmodule ShadcnUIDemo.MilestoneGPhase8PublicationTest do
  use ExUnit.Case, async: true

  @evidence "priv/reference/milestone_g/phase-08-section-3-publication-evidence.json"

  # covers: shadcn_ui.gallery_presentation.deterministic_distribution
  # covers: shadcn_ui.release_publication.deployment_workflow
  # covers: shadcn_ui.release_publication.post_deploy_and_rollback

  test "qualified artifact records complete immutable identity and repository-subpath proof" do
    evidence = @evidence |> File.read!() |> Jason.decode!()

    assert evidence["status"] == "locally-qualified-pending-reviewed-main-publication"
    assert evidence["artifact"]["files"] == 646
    assert evidence["artifact"]["routes"] == 634
    assert evidence["artifact"]["assets"] == 4
    assert evidence["artifact"]["searchRecords"] == 41
    assert evidence["artifact"]["treeSha256"] =~ ~r/^[0-9a-f]{64}$/
    assert length(evidence["artifact"]["manifests"]) == 5
    assert evidence["verification"]["duplicateExports"] == "byte-identical"
    assert evidence["verification"]["repositorySubpath"] == "passed"
    assert evidence["verification"]["remoteRuntimeAssets"] == []
  end

  test "publication states stay separate and rollback does not invent prior success" do
    evidence = @evidence |> File.read!() |> Jason.decode!()

    assert evidence["workflow"] == %{
             "artifactRetentionDays" => 30,
             "deployment" => "pending",
             "postDeploySmoke" => "pending",
             "pullRequestVerification" => "pending",
             "reviewedMainMerge" => "pending"
           }

    assert evidence["recovery"]["status"] == "reviewed"
    assert evidence["recovery"]["priorVerifiedArtifact"] == nil
    assert evidence["recovery"]["firstPublicationPolicy"] =~ "never invent"
  end

  test "reviewed workflow deploys only verified main and runs the complete canonical smoke" do
    workflow = File.read!("../.github/workflows/gallery.yml")
    operations = File.read!("../docs/gallery-operations.md")

    assert workflow =~ "github.event_name == 'push'"
    assert workflow =~ "github.ref == 'refs/heads/main'"
    assert workflow =~ "needs: verify"
    assert workflow =~ "Deploy exact verified artifact"
    assert workflow =~ "Smoke test canonical gallery"
    assert workflow =~ "SHADCN_UI_EXPECTED_REVISION"
    assert operations =~ "first reviewed publication"
    assert operations =~ "never nominate an older failed"
  end
end
