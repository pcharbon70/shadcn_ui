defmodule ShadcnUI.MotionIntegrationTest do
  use ExUnit.Case, async: true
  # covers: shadcn_ui.motion_components.work_budget shadcn_ui.motion_components.marquee_duplicates
  # covers: shadcn_ui.motion_media_contract.distribution shadcn_ui.motion_media_contract.runtime_boundary
  # covers: shadcn_ui.motion_media_contract.css_exceptions shadcn_ui.provenance.component_mapping

  test "both public defining APIs preserve metadata and scoped finite CSS with pinned provenance" do
    imports = File.read!("lib/shadcn_ui.ex")
    compiled = File.read!(ShadcnUI.stylesheet_path())
    assert File.read!("assets/marquee.css") =~ "var(--shadcn-ui-radius-md)"
    manifest = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))

    for {name, module, ledger} <- [
          {"marquee", ShadcnUI.Components.Motion.Marquee, "E-03"},
          {"stagger", ShadcnUI.Components.Motion.Stagger, "E-04"}
        ] do
      assert imports =~ inspect(module)
      source = File.read!("lib/shadcn_ui/components/motion/#{name}.ex")
      css = File.read!("assets/#{name}.css")
      assert compiled =~ "data-shadcn-ui-#{name}"
      assert css =~ "@keyframes shadcn-ui-#{name}"
      assert File.read!("assets/engineering/motion-media-css-exceptions.md") =~ ledger
      refute css =~ ~r/(infinite|opacity:\s*0[;} ]|animation-fill-mode:\s*(both|forwards)|url\()/

      refute source =~
               ~r/(<script|addEventListener|String\.to_atom|GenServer|Process\.|phx-hook|IntersectionObserver|requestAnimationFrame)/

      mapping = Enum.find(manifest["adaptations"], &(&1["id"] == "motion.#{name}"))
      assert "assets/#{name}.css" in mapping["localPaths"]
      assert "src/demos/#{name}/basic.html" in mapping["upstreamPaths"]

      assert Enum.any?(
               module.__components__() |> Map.values() |> Enum.flat_map(& &1.attrs),
               &(&1.name == :id and &1.required)
             )
    end
  end

  test "real HEEx fixture has no duplicate IDs, scripts or distributed gallery machinery" do
    fixture = File.read!("test/fixtures/milestone_e_motion.html")
    ids = Regex.scan(~r/\sid="([^"]+)"/, fixture, capture: :all_but_first) |> List.flatten()
    assert Enum.uniq(ids) == ids
    refute fixture =~ "<script"
    assert fixture =~ "data-shadcn-ui-marquee"
    assert fixture =~ "data-shadcn-ui-stagger"
    allowlist = Mix.Project.config()[:package][:files]
    refute Enum.any?(allowlist, &String.starts_with?(&1, ["demo", "test", "scripts"]))
  end
end
