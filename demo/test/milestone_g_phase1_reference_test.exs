defmodule ShadcnUIDemo.MilestoneGPhase1ReferenceTest do
  use ExUnit.Case, async: true

  @manifest_path "priv/reference/milestone_g/presentation-reference.json"
  @manifest File.read!(@manifest_path) |> Jason.decode!()

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.semantic_exceptions

  test "reference identity is exact, local, and source-derived" do
    assert @manifest["schemaVersion"] == 1
    assert @manifest["evidenceType"] == "checked-source-derived-reference"
    assert @manifest["decision"] == "shadcn_ui.pinned_gallery_presentation_parity"
    assert @manifest["upstream"]["commit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"
    assert @manifest["capturePolicy"]["networkRequiredForVerification"] == false
    assert @manifest["capturePolicy"]["movingPublicSiteAuthoritative"] == false

    inputs = @manifest["upstream"]["inputs"]
    assert length(inputs) == 14
    assert Enum.uniq_by(inputs, & &1["path"]) == inputs
    assert Enum.all?(inputs, &Regex.match?(~r/^[0-9a-f]{64}$/, &1["sha256"]))
  end

  test "the complete closed viewport, theme, and mobile-open matrix is present" do
    states = @manifest["states"]
    assert length(states) == 12
    assert MapSet.size(MapSet.new(states, & &1["id"])) == 12

    assert MapSet.new(states, &{&1["viewport"]["width"], &1["viewport"]["height"]}) ==
             MapSet.new([{1440, 1200}, {1024, 1366}, {390, 844}, {320, 568}])

    for theme <- ~w(light dark), width <- [1440, 1024, 390, 320] do
      assert Enum.any?(states, &(&1["theme"] == theme and &1["viewport"]["width"] == width))
    end

    for width <- [390, 320], theme <- ~w(light dark), open <- ~w(closed open) do
      assert Enum.any?(states, fn state ->
               state["viewport"]["width"] == width and state["theme"] == theme and
                 state["shell"]["mobileNavigation"] == open
             end)
    end

    assert Enum.all?(states, &(&1["motion"] == "reduced" and &1["scale"] == 1))
  end

  test "font approval retains the OFL and maps the exact Phase 3 binary" do
    font = @manifest["fontReview"]
    notice = Path.join(Path.dirname(@manifest_path), font["licenseNotice"])

    assert font["license"] == "SIL Open Font License 1.1"
    assert font["binaryCopied"] == true

    assert font["upstreamBinarySha256"] ==
             "a97804dc9fbe5fc972a08018c5eda4dab7ef2346f64c57e61419d05e6de4ea1c"

    assert File.read!(notice) =~ "SIL OPEN FONT LICENSE Version 1.1"
    binary = Path.expand("../#{font["localBinaryPath"]}", File.cwd!())
    bytes = File.read!(binary)
    assert byte_size(bytes) == font["localBinaryBytes"]
    assert Base.encode16(:crypto.hash(:sha256, bytes), case: :lower) == font["localBinarySha256"]
  end

  test "reference artifacts contain no machine paths, timestamps, or remote runtime assets" do
    evidence =
      Path.wildcard("priv/reference/milestone_g/**/*")
      |> Enum.filter(&File.regular?/1)
      |> Enum.map_join("\n", &File.read!/1)

    refute evidence =~ ~r/[A-Z]:\\/i
    refute evidence =~ ~r/file:\/\//
    refute evidence =~ ~r/https?:\/\/(?:fonts|static)\./
    refute evidence =~ ~r/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/
  end
end
