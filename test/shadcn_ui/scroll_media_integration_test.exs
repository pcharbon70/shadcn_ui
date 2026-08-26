defmodule ShadcnUI.ScrollMediaIntegrationTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.motion_media_contract.distribution shadcn_ui.motion_media_contract.runtime_boundary
  # covers: shadcn_ui.motion_media_contract.css_exceptions shadcn_ui.provenance.component_mapping
  # covers: shadcn_ui.motion_components.timeline_fallback shadcn_ui.media_components.cover_flow_enhancement

  test "both defining APIs and compiled scoped CSS have complete pinned provenance" do
    imports = File.read!("lib/shadcn_ui.ex")
    compiled = File.read!(ShadcnUI.stylesheet_path())
    mappings = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))["adaptations"]

    for {kind, name, module, ledger} <- [
          {"motion", "scroll-indicator", ShadcnUI.Components.Motion.ScrollIndicator, "E-05"},
          {"media", "cover-flow", ShadcnUI.Components.Media.CoverFlow, "E-06"}
        ] do
      assert imports =~ inspect(module)
      css = File.read!("assets/#{name}.css")
      assert compiled =~ "data-shadcn-ui-#{name}"
      assert css =~ "@supports"
      assert css =~ "animation-range:"
      assert css =~ "timeline-scope:"
      assert css =~ "forced-colors: none"
      assert css =~ "prefers-reduced-motion: no-preference"
      refute css =~ ~r/(^|\n)\s*(?:\*|html|body|img|figure|a)\s*[{,]/
      refute css =~ ~r/(infinite|url\(|z-index|animation-duration:\s*\d)/
      assert File.read!("docs/motion-media-css-exceptions.md") =~ ledger
      mapping = Enum.find(mappings, &(&1["id"] == "#{kind}.#{name}"))
      assert "assets/#{name}.css" in mapping["localPaths"]
      assert "src/demos/#{name}/basic.html" in mapping["upstreamPaths"]
      source = File.read!("lib/shadcn_ui/components/#{kind}/#{String.replace(name, "-", "_")}.ex")

      refute source =~
               ~r/(<script|addEventListener|String\.to_atom|GenServer|Process\.|phx-hook|IntersectionObserver|requestAnimationFrame|setInterval)/
    end
  end

  test "complete actual fixture has unique identities and no synthetic state or release machinery" do
    fixture = File.read!("test/fixtures/milestone_e_scroll_media.html")
    ids = Regex.scan(~r/\sid="([^"]+)"/, fixture, capture: :all_but_first) |> List.flatten()
    assert Enum.uniq(ids) == ids

    for marker <- ["scroll-indicator", "cover-flow", "carousel-index"],
        do: assert(fixture =~ "data-shadcn-ui-#{marker}")

    refute fixture =~
             ~r/(<script|role="progressbar"|aria-valuenow|aria-selected|aria-live|data-shadcn-ui-motion-part="clone")/

    refute Enum.any?(
             Mix.Project.config()[:package][:files],
             &String.starts_with?(&1, ["demo", "test", "scripts", "assets"])
           )
  end
end
