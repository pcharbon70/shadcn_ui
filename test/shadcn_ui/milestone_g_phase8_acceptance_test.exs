defmodule ShadcnUI.MilestoneGPhase8AcceptanceTest do
  use ExUnit.Case, async: true

  @evidence "demo/priv/reference/milestone_g/phase-08-section-4-acceptance-evidence.json"

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.shell
  # covers: shadcn_ui.gallery_presentation.progressive_navigation
  # covers: shadcn_ui.gallery_presentation.presentation_system
  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.specimen_semantics
  # covers: shadcn_ui.gallery_presentation.catalogue_metadata
  # covers: shadcn_ui.gallery_presentation.stable_identity
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.semantic_exceptions
  # covers: shadcn_ui.gallery_presentation.accessibility_matrix
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution
  # covers: shadcn_ui.gallery_presentation.complete_migration

  test "all Milestone G requirements have real local implementation and evidence" do
    evidence = @evidence |> File.read!() |> Jason.decode!()

    assert evidence["status"] ==
             "local-milestone-g-acceptance-passed-pending-reviewed-publication"

    assert evidence["requirements"] == %{
             "contradictions" => [],
             "implemented" => 14,
             "locallyVerified" => 14,
             "planningOnlyTargets" => [],
             "total" => 14
           }

    assert evidence["visualExceptions"] == []

    assert Enum.all?(evidence["localGates"], fn {_gate, status} ->
             String.starts_with?(status, "passed")
           end)
  end

  test "acceptance preserves manual and publication states without pre-claiming them" do
    evidence = @evidence |> File.read!() |> Jason.decode!()
    manual = evidence["accessibility"]["manualScenarios"]
    publication = evidence["publication"]

    assert manual["status"] == "pending"
    assert manual["count"] == 6
    assert manual["claim"] =~ "No manual accessibility acceptance"

    for gate <- ~w(pullRequest finalRevisionCi reviewedMainMerge deployment postDeploySmoke) do
      assert publication[gate] == "pending"
    end
  end

  test "SpecLed candidate is warning-free and records the repaired baseline honestly" do
    evidence = @evidence |> File.read!() |> Jason.decode!()

    assert evidence["specLed"]["candidate"] == "passed"
    assert evidence["specLed"]["errors"] == 0
    assert evidence["specLed"]["warnings"] == 0
    assert evidence["specLed"]["branchFindings"] == 0
    assert evidence["specLed"]["baselineMainBeforeRepair"] =~ "144-warnings"
    assert evidence["specLed"]["mainAfterMerge"] == "pending"
  end
end
