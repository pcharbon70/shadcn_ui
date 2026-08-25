defmodule ShadcnUI.MilestoneCAcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.content_gallery.catalog shadcn_ui.content_gallery.states
  # covers: shadcn_ui.content_gallery.compositions
  # covers: shadcn_ui.content_gallery.semantic_guidance
  # covers: shadcn_ui.content_gallery.fallbacks
  # covers: shadcn_ui.content_gallery.content_stress
  # covers: shadcn_ui.content_gallery.browser_behavior
  # covers: shadcn_ui.content_gallery.release_boundary

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
