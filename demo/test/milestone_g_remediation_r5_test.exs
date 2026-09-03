defmodule ShadcnUIDemo.MilestoneGRemediationR5Test do
  use ExUnit.Case, async: true

  @reference_root "priv/reference/milestone_g/pinned-reference"
  @manifest File.read!(Path.join(@reference_root, "manifest.json")) |> Jason.decode!()
  @comparison File.read!("priv/reference/milestone_g/remediation-r5-comparison-evidence.json")
              |> Jason.decode!()
  @integration File.read!("priv/reference/milestone_g/remediation-r5-integration-evidence.json")
               |> Jason.decode!()
  @repo_root Path.expand("../..", __DIR__)

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  test "R5.1 closes the old host failure with two identical pinned builds" do
    reproduction = @manifest["buildReproduction"]

    assert @manifest["status"] == "passed-rendered-and-reviewed-r5.2"
    assert @manifest["upstream"]["commit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"
    assert @manifest["upstream"]["route"] == "/components/accordion/"
    assert reproduction["toolchain"]["npm"] == "10.9.2"
    assert reproduction["cleanBuilds"] == 2
    assert reproduction["fullBuildFiles"] == 53
    assert reproduction["fullBuildTreeSha256"] =~ ~r/^[0-9a-f]{64}$/

    assert reproduction["priorLimitation"]["result"] == "exit_handler_never_called"

    assert reproduction["priorLimitation"]["reproduction"] ==
             "not-reproduced-on-linux-with-the-same-npm-version"

    assert reproduction["priorLimitation"]["diagnosis"] ==
             "phase-1-host-process-exit-limitation-not-pinned-source-or-lockfile"

    assert reproduction["result"] ==
             "passed-identical-builds-and-current-npm-cross-check"

    assert @manifest["captureContract"]["states"] == 12
    assert @manifest["captureContract"]["themes"] == ~w(light dark)
    assert @manifest["captureContract"]["motion"] == "reduced"
    assert @manifest["captureContract"]["mobileNavigation"] == ~w(closed open)
    assert @manifest["comparisonStatus"] == "passed-reviewed-r5.2"
  end

  test "R5.1 reference inventory is closed, hashed, local and licensed" do
    recorded = @manifest["harness"]["files"]

    actual =
      Path.wildcard(Path.join(@reference_root, "**/*"))
      |> Enum.filter(&File.regular?/1)
      |> Enum.map(&Path.relative_to(&1, @reference_root))
      |> Enum.reject(&(&1 == "manifest.json"))
      |> Enum.sort()

    assert actual == Enum.sort(Enum.map(recorded, & &1["path"]))
    assert @manifest["harness"]["networkRequiredForVerification"] == false
    assert @manifest["harness"]["movingPublicSiteAuthoritative"] == false

    for file <- recorded do
      bytes = File.read!(Path.join(@reference_root, file["path"]))
      assert byte_size(bytes) == file["bytes"]
      assert Base.encode16(:crypto.hash(:sha256, bytes), case: :lower) == file["sha256"]
    end

    html = File.read!(Path.join(@reference_root, "site/components/accordion/index.html"))
    refute html =~ ~r/\bsrc=["']https?:\/\//i
    refute html =~ "static.cloudflareinsights.com"
    assert html =~ "Exclusive open, animated height auto"

    assert File.read!(Path.join(@reference_root, "LICENSE.unscripted-ui.txt")) =~
             "Copyright (c) 2026 Ján Timoranský"

    assert File.read!("priv/reference/milestone_g/licenses/bricolage-grotesque-OFL.txt") =~
             "SIL OPEN FONT LICENSE Version 1.1"
  end

  test "R5.2 locks eight paired states and a dedicated Foundation category matrix" do
    assert @comparison["status"] == "passed-reviewed-r5.2"
    assert @comparison["upstreamCommit"] == @manifest["upstream"]["commit"]
    assert @comparison["networkRequiredForVerification"] == false
    assert @comparison["movingPublicSiteAuthoritative"] == false
    assert @comparison["routes"]["reference"] == "/components/accordion/"
    assert @comparison["routes"]["local"] == "/components/disclosure/accordion"
    assert @comparison["routes"]["foundationCategory"] == "/components/foundation"
    assert length(@comparison["states"]) == 8
    assert length(@comparison["foundationCategoryCaptures"]) == 4
    assert length(@comparison["reviewedExceptions"]) == 5

    assert MapSet.new(@comparison["states"], &{&1["viewport"]["width"], &1["theme"]}) ==
             MapSet.new(
               for width <- [1440, 1024, 390, 320], theme <- ~w(light dark), do: {width, theme}
             )

    captures =
      Enum.flat_map(@comparison["states"], &[&1["reference"], &1["local"]]) ++
        @comparison["foundationCategoryCaptures"]

    assert length(captures) == 20

    for capture <- captures do
      bytes = File.read!(Path.join(@repo_root, capture["file"]))
      assert Base.encode16(:crypto.hash(:sha256, bytes), case: :lower) == capture["sha256"]
    end

    assert Enum.all?(@comparison["states"], fn state ->
             state["accordionRegion"]["reviewedDifferenceRatio"] <=
               state["accordionRegion"]["maximumDifferenceRatio"]
           end)

    assert @comparison["coverage"]["findInPage"] == %{
             "openAnswer" => "passed-without-state-change",
             "closedAnswer" => "passed-without-state-change"
           }
  end

  test "R5.3 closes deterministic visual and distribution integration" do
    assert @integration["status"] == "passed-remediation-r5-complete"
    assert @integration["baseRevision"] == "6c461681163fbdf8b227edc3085f2470711f3eed"
    assert @integration["upstreamCommit"] == @manifest["upstream"]["commit"]
    assert @integration["determinism"]["captureRuns"] == 2
    assert @integration["determinism"]["snapshotCount"] == 20

    assert @integration["determinism"]["snapshotSetSha256"] ==
             "5efd76fb51c2579540e2001bb29006f4e2a856a8d8d186f589c27a181ed5bba7"

    assert @integration["verification"]["packageTests"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 419
           }

    assert @integration["verification"]["demoTests"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 164
           }

    assert @integration["distribution"]["archiveEntries"] == 63
    assert @integration["distribution"]["exportRoutes"] == 634
    assert @integration["distribution"]["exportAssets"] == 4
    assert @integration["specLed"]["errors"] == 0
    assert @integration["specLed"]["warnings"] == 0
  end
end
