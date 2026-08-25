defmodule ShadcnUI.MilestoneCDocumentationTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.content_gallery.semantic_guidance
  # covers: shadcn_ui.content_gallery.fallbacks shadcn_ui.content_gallery.release_boundary
  # covers: shadcn_ui.provenance.component_mapping shadcn_ui.provenance.pinned_revision

  test "public guidance documents every Milestone C API and ownership boundary" do
    readme = File.read!("README.md")

    for heading <- [
          "Navigation Menu",
          "Header and Section Header",
          "Accordion",
          "Separator",
          "Scroll Area",
          "Radio Panels",
          "Choosing navigation and interaction semantics"
        ],
        do: assert(readme =~ "### #{heading}")

    for boundary <- [
          "normal document flow",
          "Panels panel is visible",
          "no package JavaScript",
          "True tabs",
          "Menus and menubars",
          "forced colors",
          "Reduced motion"
        ],
        do: assert(readme =~ boundary)
  end

  test "every Milestone C adaptation is pinned and mapped to released source" do
    manifest = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    ids = Enum.map(manifest["adaptations"], & &1["id"])

    assert manifest["upstream"]["commit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"

    for id <- [
          "content.separator",
          "content.scroll_area",
          "content.radio_panels",
          "disclosure.accordion",
          "navigation.navigation_menu",
          "navigation.header",
          "navigation.section_header"
        ],
        do: assert(id in ids)

    for adaptation <- Enum.filter(manifest["adaptations"], &(&1["id"] in ids)) do
      assert adaptation["localPaths"] != []
      assert adaptation["upstreamPaths"] != []
      assert is_binary(adaptation["localChanges"])
    end
  end

  test "candidate and gallery documentation record release and rollback evidence" do
    changelog = File.read!("CHANGELOG.md")
    release = File.read!("RELEASE.md")
    gallery = File.read!("demo/README.md")
    deployment = File.read!("demo/DEPLOYMENT.md")
    smoke = File.read!("demo/scripts/smoke-gallery.mjs")
    package_files = Mix.Project.config()[:package][:files]

    assert changelog =~ "Complete Milestone C"
    assert release =~ "Milestone C acceptance record"
    assert gallery =~ "Content Surfaces"
    assert deployment =~ "Rollback"
    assert smoke =~ "components/content-surfaces/"
    assert smoke =~ "radio-panels"
    refute "demo" in package_files
    refute ".spec" in package_files
  end
end
