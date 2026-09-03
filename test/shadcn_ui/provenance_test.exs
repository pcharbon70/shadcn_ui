defmodule ShadcnUI.ProvenanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.provenance.pinned_revision shadcn_ui.provenance.component_mapping
  # covers: shadcn_ui.provenance.mit_notice shadcn_ui.provenance.no_upstream_runtime
  # covers: shadcn_ui.provenance.site_assets_excluded
  # covers: shadcn_ui.provenance.independent_identity

  @manifest_path "priv/provenance/unscripted_ui.json"
  @schema_path "priv/provenance/unscripted_ui.schema.json"
  @commit "bd8f403030c8d1f46804da6eda733fde7e908e63"
  @foundation_ids MapSet.new(~w(
    foundation.alert
    foundation.avatar
    foundation.badge
    foundation.button
    foundation.card
    foundation.skeleton
  ))

  test "pins the reviewed repository, commit, and MIT notice" do
    manifest = manifest()
    notice = File.read!("THIRD_PARTY_NOTICES.md")

    assert manifest["upstream"] == %{
             "name" => "unscripted/ui",
             "repository" => "https://github.com/timoransky/unscripted-ui",
             "commit" => @commit,
             "license" => "MIT",
             "licenseNoticeFile" => "THIRD_PARTY_NOTICES.md"
           }

    assert notice =~ "Copyright (c) 2026 Ján Timoranský"
    assert notice =~ "Permission is hereby granted, free of charge"
    assert notice =~ "THE SOFTWARE IS PROVIDED \"AS IS\""
    assert notice =~ @commit
  end

  test "provides a closed schema-shaped manifest" do
    manifest = manifest()
    schema = Jason.decode!(File.read!(@schema_path))

    assert manifest["schemaVersion"] == 1
    assert schema["properties"]["schemaVersion"]["const"] == 1
    assert schema["additionalProperties"] == false

    assert Enum.sort(schema["required"]) ==
             Enum.sort(~w(adaptations excludedSiteMaterial schemaVersion upstream))

    assert Enum.all?(manifest["adaptations"], fn adaptation ->
             adaptation |> Map.keys() |> Enum.sort() ==
               Enum.sort(~w(id localChanges localPaths upstreamPaths))
           end)
  end

  test "maps every Milestone A component and CSS foundation to existing local sources" do
    adaptations = manifest()["adaptations"]
    ids = adaptations |> Enum.map(& &1["id"]) |> MapSet.new()

    assert MapSet.subset?(@foundation_ids, ids)
    assert "stylesheet.semantic-foundation" in ids

    for adaptation <- adaptations,
        local_path <- adaptation["localPaths"] do
      assert File.exists?(local_path), "missing local provenance path: #{local_path}"
    end

    for adaptation <- adaptations,
        upstream_path <- adaptation["upstreamPaths"] do
      assert String.starts_with?(upstream_path, "src/")
      refute String.contains?(upstream_path, ["..", "http://", "https://"])
    end
  end

  test "maps Button to the exact reviewed component and variant sources" do
    button =
      Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.button"))

    assert button["localPaths"] == ["lib/shadcn_ui/components/foundation/button.ex"]

    assert button["upstreamPaths"] == [
             "src/content/components/button.mdx",
             "src/demos/button/variants.html"
           ]

    assert button["localChanges"] =~ "native HEEX button semantics"
    assert button["localChanges"] =~ "caller-owned activation"
  end

  test "maps Badge to the exact reviewed component and variant sources" do
    badge = Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.badge"))

    assert badge["localPaths"] == ["lib/shadcn_ui/components/foundation/badge.ex"]

    assert badge["upstreamPaths"] == [
             "src/content/components/badge.mdx",
             "src/demos/badge/variants.html"
           ]

    assert badge["localChanges"] =~ "closed noninteractive HEEX component contract"
  end

  test "maps Alert to the exact reviewed component and variant sources" do
    alert = Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.alert"))

    assert alert["localPaths"] == ["lib/shadcn_ui/components/foundation/alert.ex"]

    assert alert["upstreamPaths"] == [
             "src/content/components/alert.mdx",
             "src/demos/alert/variants.html"
           ]

    assert alert["localChanges"] =~ "explicit announcement semantics"
    assert alert["localChanges"] =~ "caller-owned lifecycle"
  end

  test "maps Card to the exact reviewed component and basic demo sources" do
    card = Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.card"))

    assert card["localPaths"] == ["lib/shadcn_ui/components/foundation/card.ex"]

    assert card["upstreamPaths"] == [
             "src/content/components/card.mdx",
             "src/demos/card/basic.html"
           ]

    assert card["localChanges"] =~ "composable semantic HEEX regions"
    assert card["localChanges"] =~ "without assigning workflow behavior"
  end

  test "maps Avatar to the exact reviewed component and basic demo sources" do
    avatar = Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.avatar"))

    assert avatar["localPaths"] == ["lib/shadcn_ui/components/foundation/avatar.ex"]

    assert avatar["upstreamPaths"] == [
             "src/content/components/avatar.mdx",
             "src/demos/avatar/basic.html"
           ]

    assert avatar["localChanges"] =~ "initials-first HEEX fallback"
    assert avatar["localChanges"] =~ "caller-owned image loading"
  end

  test "maps Skeleton to the exact reviewed component and basic demo sources" do
    skeleton = Enum.find(manifest()["adaptations"], &(&1["id"] == "foundation.skeleton"))

    assert skeleton["localPaths"] == ["lib/shadcn_ui/components/foundation/skeleton.ex"]

    assert skeleton["upstreamPaths"] == [
             "src/content/components/skeleton.mdx",
             "src/demos/skeleton/basic.html"
           ]

    assert skeleton["localChanges"] =~ "decorative HEEX placeholder"
    assert skeleton["localChanges"] =~ "reduced-motion-safe snapshot"
  end

  test "maps the Milestone B Label adaptation to the reviewed native sources" do
    label = Enum.find(manifest()["adaptations"], &(&1["id"] == "forms.label"))

    assert label["localPaths"] == ["lib/shadcn_ui/components/forms/label.ex"]

    assert label["upstreamPaths"] == [
             "src/content/components/label.mdx",
             "src/demos/label/basic.html"
           ]

    assert label["localChanges"] =~ "protected HEEX relationship primitive"
  end

  test "maps the first Milestone C content surfaces to exact reviewed sources" do
    adaptations = manifest()["adaptations"]
    separator = Enum.find(adaptations, &(&1["id"] == "content.separator"))
    scroll_area = Enum.find(adaptations, &(&1["id"] == "content.scroll_area"))

    assert separator["upstreamPaths"] == ["src/styles/global.css"]
    assert separator["localChanges"] =~ "native HEEX hr contract"

    assert scroll_area["upstreamPaths"] == [
             "src/content/components/scroll-area.mdx",
             "src/demos/scroll-area/basic.html"
           ]

    assert scroll_area["localChanges"] =~ "native HEEX scroll container"
    assert scroll_area["localChanges"] =~ "without custom controls or scroll state"
  end

  test "maps native Accordion to the exact reviewed component and demo sources" do
    accordion = Enum.find(manifest()["adaptations"], &(&1["id"] == "disclosure.accordion"))

    assert accordion["localPaths"] == [
             "lib/shadcn_ui/components/disclosure/accordion.ex",
             "assets/shadcn_ui.css"
           ]

    assert accordion["upstreamPaths"] == [
             "src/content/components/accordion.mdx",
             "src/demos/accordion/basic.html"
           ]

    assert accordion["localChanges"] =~ "native details and summary HEEX items"
    assert accordion["localChanges"] =~ "without package state or JavaScript"
  end

  test "keeps upstream infrastructure out of dependencies and release files" do
    dependency_text = File.read!("mix.exs") <> File.read!("package.json")
    files = Mix.Project.config() |> Keyword.fetch!(:package) |> Keyword.fetch!(:files)

    refute dependency_text =~ "timoransky/unscripted-ui"
    refute File.exists?(".gitmodules")
    refute File.dir?("vendor/unscripted-ui")
    refute File.dir?("priv/vendor/unscripted-ui")
    assert "priv/provenance" in files

    refute Enum.any?(files, fn file ->
             String.contains?(file, ["public/fonts", "analytics", "src/scripts/site.ts"])
           end)
  end

  test "documents independent identity and explicit update review" do
    provenance = File.read!("docs/provenance.md")

    assert provenance =~ "independent Phoenix/HEEX adaptation"
    assert provenance =~ "To review a later upstream revision"
    assert provenance =~ "no mutable branch or remote runtime"
  end

  defp manifest, do: Jason.decode!(File.read!(@manifest_path))
end
