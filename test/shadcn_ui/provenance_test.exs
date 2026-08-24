defmodule ShadcnUI.ProvenanceTest do
  use ExUnit.Case, async: true

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
    readme = File.read!("README.md")

    assert readme =~ "independent Phoenix adaptation"
    assert readme =~ "Reviewing a later upstream revision"
    assert readme =~ "does not automatically synchronize"
  end

  defp manifest, do: Jason.decode!(File.read!(@manifest_path))
end
