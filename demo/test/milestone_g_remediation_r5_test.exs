defmodule ShadcnUIDemo.MilestoneGRemediationR5Test do
  use ExUnit.Case, async: true

  @reference_root "priv/reference/milestone_g/pinned-reference"
  @manifest File.read!(Path.join(@reference_root, "manifest.json")) |> Jason.decode!()

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  test "R5.1 closes the old host failure with two identical pinned builds" do
    reproduction = @manifest["buildReproduction"]

    assert @manifest["status"] == "renderable-awaiting-r5.2-comparison"
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
end
