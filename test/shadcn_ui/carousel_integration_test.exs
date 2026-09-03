defmodule ShadcnUI.CarouselIntegrationTest do
  use ExUnit.Case, async: true
  # covers: shadcn_ui.media_components.carousel_structure
  # covers: shadcn_ui.media_components.carousel_controls
  # covers: shadcn_ui.media_components.carousel_layout
  # covers: shadcn_ui.motion_media_contract.distribution
  # covers: shadcn_ui.motion_media_contract.css_exceptions
  # covers: shadcn_ui.provenance.component_mapping

  test "actual public component and scoped CSS have pinned provenance and no controller" do
    source = File.read!("lib/shadcn_ui/components/media/carousel.ex")
    css = File.read!("assets/carousel.css")
    compiled = File.read!(ShadcnUI.stylesheet_path())
    assert File.read!("lib/shadcn_ui.ex") =~ "ShadcnUI.Components.Media.Carousel"
    assert compiled =~ "data-shadcn-ui-carousel-scroll"
    assert css =~ "scroll-padding-inline"
    assert css =~ "forced-colors"
    assert File.read!("assets/engineering/motion-media-css-exceptions.md") =~ "E-02"

    refute css =~
             ~r/(scrollbar-width|overscroll-behavior|::scroll-button|::scroll-marker|@keyframes|url\()/

    refute source =~ ~r/(<script|addEventListener|String\.to_atom|GenServer|Process\.|phx-hook)/
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    mapping = Enum.find(provenance["adaptations"], &(&1["id"] == "media.carousel"))
    assert "assets/carousel.css" in mapping["localPaths"]
    assert "src/demos/carousel/basic.html" in mapping["upstreamPaths"]
    assert mapping["localChanges"] =~ "Omit reviewed generated"
  end

  test "real HEEx fixture and release allowlist keep every item while excluding demo infrastructure" do
    fixture = File.read!("test/fixtures/milestone_e_carousel.html")
    assert length(Regex.scan(~r/<li\b/, fixture)) == 24
    ids = Regex.scan(~r/\sid="([^"]+)"/, fixture, capture: :all_but_first) |> List.flatten()
    assert Enum.uniq(ids) == ids

    for [id] <- Regex.scan(~r/href="#(shadcn-ui-media-[^"]+)"/, fixture, capture: :all_but_first),
        do: assert(id in ids)

    allowlist = Mix.Project.config()[:package][:files]
    assert "lib" in allowlist
    refute Enum.any?(allowlist, &String.starts_with?(&1, ["demo", "test", "scripts"]))
  end
end
