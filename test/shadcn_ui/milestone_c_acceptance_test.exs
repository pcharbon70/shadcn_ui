defmodule ShadcnUI.MilestoneCAcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.content_gallery.catalog shadcn_ui.content_gallery.states
  # covers: shadcn_ui.content_gallery.compositions
  # covers: shadcn_ui.content_gallery.semantic_guidance
  # covers: shadcn_ui.content_gallery.fallbacks
  # covers: shadcn_ui.content_gallery.content_stress
  # covers: shadcn_ui.content_gallery.browser_behavior
  # covers: shadcn_ui.content_gallery.release_boundary
  # covers: shadcn_ui.component.classes_and_globals shadcn_ui.component.closed_values
  # covers: shadcn_ui.component.deterministic_identity shadcn_ui.component.honest_interaction_names
  # covers: shadcn_ui.component.native_semantics shadcn_ui.component.presentation_snapshot
  # covers: shadcn_ui.component.progressive_floor shadcn_ui.component.protected_accessibility
  # covers: shadcn_ui.component.safe_content shadcn_ui.component.slots
  # covers: shadcn_ui.component.stateless_heex
  # covers: shadcn_ui.content.edge_fallback shadcn_ui.content.radio_fallback
  # covers: shadcn_ui.content.radio_not_tabs shadcn_ui.content.radio_panels
  # covers: shadcn_ui.content.scroll_area shadcn_ui.content.scroll_focus
  # covers: shadcn_ui.content.scroll_ownership shadcn_ui.content.separator
  # covers: shadcn_ui.content.shared_contract
  # covers: shadcn_ui.disclosure.accordion_modes shadcn_ui.disclosure.accordion_native
  # covers: shadcn_ui.disclosure.deterministic_identity shadcn_ui.disclosure.fallback
  # covers: shadcn_ui.disclosure.open_snapshot shadcn_ui.disclosure.ownership
  # covers: shadcn_ui.disclosure.protected_semantics shadcn_ui.disclosure.shared_contract
  # covers: shadcn_ui.gallery.closed_catalog shadcn_ui.gallery.component_guidance
  # covers: shadcn_ui.gallery.controller_rendered shadcn_ui.gallery.demo_only_script
  # covers: shadcn_ui.gallery.deterministic_assets shadcn_ui.gallery.excluded_from_package
  # covers: shadcn_ui.gallery.no_application_frameworks shadcn_ui.gallery.online_publication
  # covers: shadcn_ui.gallery.safe_resolution shadcn_ui.gallery.semantic_shell
  # covers: shadcn_ui.gallery.separate_application shadcn_ui.gallery.stable_routes
  # covers: shadcn_ui.gallery.static_export shadcn_ui.gallery.theme_matrix
  # covers: shadcn_ui.navigation.current_location shadcn_ui.navigation.destination_ownership
  # covers: shadcn_ui.navigation.header shadcn_ui.navigation.link_semantics
  # covers: shadcn_ui.navigation.menu shadcn_ui.navigation.protected_semantics
  # covers: shadcn_ui.navigation.section_header shadcn_ui.navigation.shared_contract
  # covers: shadcn_ui.navigation.sticky_fallback
  # covers: shadcn_ui.provenance.component_mapping shadcn_ui.provenance.independent_identity
  # covers: shadcn_ui.provenance.mit_notice shadcn_ui.provenance.no_upstream_runtime
  # covers: shadcn_ui.provenance.pinned_revision shadcn_ui.provenance.site_assets_excluded
  # covers: shadcn_ui.stylesheet.content_fallbacks shadcn_ui.stylesheet.content_resilience
  # covers: shadcn_ui.stylesheet.no_runtime_assets shadcn_ui.stylesheet.reduced_motion
  # covers: shadcn_ui.stylesheet.scoped_dark_theme shadcn_ui.stylesheet.semantic_tokens

  @milestone_components ~w(accordion navigation-menu header section-header scroll-area separator radio-panels)

  test "the closed catalogue, compositions, and live browser suite form one acceptance surface" do
    catalogue = File.read!("demo/lib/shadcn_ui_demo/catalogue.ex")
    compositions = File.read!("demo/lib/shadcn_ui_demo_web/content_navigation_compositions.ex")
    browser = File.read!("test/browser/milestone-c-content-navigation.spec.mjs")

    for category <- ~w(disclosure navigation content-surfaces),
        do: assert(catalogue =~ ~s(slug: "#{category}"))

    for component <- @milestone_components,
        do: assert(catalogue =~ ~s(slug: "#{component}"))

    for composition <- ~w(documentation settings application-shell) do
      assert catalogue =~ ~s(path: "/examples/#{composition}")
      assert compositions =~ ~s(data-gallery-composition="#{composition}")
    end

    assert browser =~ "javaScriptEnabled: false"
    assert browser =~ "forcedColors"
    assert browser =~ "reducedMotion"
    assert browser =~ "ArrowRight"
    assert browser =~ ~s([role=\"menu\"])
  end

  test "public guidance states semantics, ownership, fallback, and deferred-widget boundaries" do
    reference = File.read!("demo/lib/shadcn_ui_demo/reference.ex")
    readme = File.read!("README.md")
    release = File.read!("RELEASE.md")

    for heading <- [
          "Choosing navigation and interaction semantics",
          "Milestone C requires no package JavaScript",
          "With no CSS",
          "Reduced motion removes nonessential transitions",
          "forced colors",
          "explicit boundaries"
        ],
        do: assert(readme =~ heading)

    assert reference =~ "Radio Panels"
    assert reference =~ "tab widget"
    assert reference =~ "caller"
    assert release =~ "Milestone C acceptance"
    assert release =~ "package"
    assert release =~ "JavaScript remain absent"
  end

  test "release allowlists exclude gallery behavior while provenance covers every adaptation" do
    package_files = Mix.Project.config()[:package][:files]
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptations = provenance["adaptations"]

    refute Enum.any?(package_files, &(&1 in ["demo", "test", ".spec", "scripts", ".github"]))

    for id <- [
          "disclosure.accordion",
          "navigation.navigation_menu",
          "navigation.header",
          "navigation.section_header",
          "content.scroll_area",
          "content.separator",
          "content.radio_panels"
        ] do
      assert Enum.any?(adaptations, &(&1["id"] == id))
    end

    runtime =
      ["lib/**/*.ex", "assets/shadcn_ui.css"]
      |> Enum.flat_map(&Path.wildcard/1)
      |> Enum.map_join("\n", &File.read!/1)

    refute runtime =~
             ~r/(<script|javascript:|role=\"(?:tab|tablist|tabpanel|menu|menubar)\"|handle_event|push_event)/
  end
end
