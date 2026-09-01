defmodule ShadcnUI.MilestoneGPhase8VisualTest do
  use ExUnit.Case, async: true

  @evidence "demo/priv/reference/milestone_g/phase-08-section-1-visual-evidence.json"

  # covers: shadcn_ui.gallery_presentation.deterministic_visual_evidence
  # covers: shadcn_ui.gallery_presentation.visual_matrix

  test "final visual evidence binds every reviewed golden to pinned capture inputs" do
    evidence = @evidence |> File.read!() |> Jason.decode!()

    assert evidence["status"] == "passed"
    assert evidence["exceptions"] == []
    assert evidence["matrix"]["goldenCount"] == 52
    assert Enum.map(evidence["matrix"]["groups"], & &1["count"]) == [4, 12, 36]
    assert length(evidence["matrix"]["families"]) == 9

    assert evidence["capture"]["themes"] == ~w(light dark)
    assert evidence["capture"]["deviceScaleFactor"] == 1
    assert evidence["capture"]["motion"] == "reduce"

    assert evidence["capture"]["viewports"] == [
             %{"width" => 1440, "height" => 1200},
             %{"width" => 1024, "height" => 1366},
             %{"width" => 390, "height" => 844},
             %{"width" => 320, "height" => 568}
           ]

    assert evidence["determinism"]["remoteRuntimeRequired"] == false
    assert evidence["determinism"]["movingPublicSiteAuthoritative"] == false

    assert evidence["determinism"]["duplicateCaptureRuns"] ==
             "passed-from-identical-local-inputs"
  end

  test "the deterministic checker rejects missing, changed, or unrecorded golden bytes" do
    {output, status} =
      System.cmd("node", ["scripts/check-milestone-g-visual-evidence.mjs", "--check"],
        stderr_to_stdout: true
      )

    assert status == 0
    assert output =~ "Verified 52 locked Milestone G goldens."
  end
end
