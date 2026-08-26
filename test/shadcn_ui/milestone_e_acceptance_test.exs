defmodule ShadcnUI.MilestoneEAcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.motion_media_gallery.release_acceptance
  # covers: shadcn_ui.motion_media_contract.runtime_boundary
  # covers: shadcn_ui.motion_media_contract.css_exceptions shadcn_ui.motion_media_contract.distribution
  # covers: shadcn_ui.package.public_import_surface shadcn_ui.provenance.component_mapping
  @modules [
    {ShadcnUI.Components.Media.Carousel, :carousel, "media.carousel"},
    {ShadcnUI.Components.Media.CoverFlow, :cover_flow, "media.cover-flow"},
    {ShadcnUI.Components.Media.ImageGallery, :image_gallery, "media.image-gallery"},
    {ShadcnUI.Components.Motion.Marquee, :marquee, "motion.marquee"},
    {ShadcnUI.Components.Motion.Stagger, :stagger, "motion.stagger"},
    {ShadcnUI.Components.Motion.ScrollIndicator, :scroll_indicator, "motion.scroll-indicator"}
  ]

  test "all six defining APIs preserve metadata and reviewed source mappings" do
    entry = File.read!("lib/shadcn_ui.ex")
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    assert provenance["upstream"]["commit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"

    for {module, function, id} <- @modules do
      assert entry =~ inspect(module)
      assert entry =~ "quote(do: import(unquote(&1)))"
      Code.ensure_loaded!(module)
      assert function_exported?(module, function, 1)
      metadata = module.__components__()[function]
      assert Enum.any?(metadata.attrs, &(&1.name == :id && &1.required))
      assert Enum.any?(metadata.attrs, &(&1.name == :rest && &1.type == :global))
      motion = Enum.find(metadata.attrs, &(&1.name == :motion))
      assert motion.opts[:values] == [:system, :none]
      assert motion.opts[:default] == :system
      mapping = Enum.find(provenance["adaptations"], &(&1["id"] == id))
      assert mapping && mapping["localChanges"] != ""
      assert mapping["upstreamPaths"] != []
      for path <- mapping["localPaths"], do: assert(File.regular?(path))
    end
  end

  test "authored CSS ledger accounts for each family without a package runtime" do
    ledger = File.read!("docs/motion-media-css-exceptions.md")

    for name <- ~w(motion-media carousel marquee stagger scroll-indicator cover-flow) do
      assert ledger =~ "assets/#{name}.css"
      css = File.read!("assets/#{name}.css")
      refute css =~ ~r/(?:https?:|url\(|@import|animation[^;]*infinite)/
    end

    sources = Path.wildcard("lib/shadcn_ui/components/{media,motion}/*.ex")
    assert length(sources) == 8

    for path <- sources do
      refute File.read!(path) =~
               ~r/(<script|addEventListener|String\.to_atom|GenServer|Process\.|phx-hook|IntersectionObserver|ResizeObserver|requestAnimationFrame|setInterval|use Phoenix\.LiveView|Req\.|HTTPoison)/
    end

    assert Path.wildcard("priv/**/*.{js,mjs,svg}") == []
    files = Mix.Project.config()[:package][:files]

    for excluded <- ~w(demo docs test scripts assets node_modules test-results .spec),
        do: refute(excluded in files)

    assert "priv/compatibility" in files
    assert "priv/static/shadcn_ui.css" in files
  end

  test "exact engine records, finite budgets and actual fixtures agree without certifying manual work" do
    manifest = Jason.decode!(File.read!("priv/compatibility/motion_media.json"))

    budget =
      Jason.decode!(File.read!("demo/priv/compatibility/motion_media_budget_evidence.json"))

    fixtures = Jason.decode!(File.read!("test/fixtures/milestone_e_budgets.json"))
    assert Enum.sort(Map.keys(fixtures)) == ~w(1 24 8)

    for {engine, version} <- budget["engines"] do
      assert manifest["verificationEvidence"]["engines"][engine]["version"] == version
    end

    for {count, sample} <- budget["samples"] do
      assert sample["clones"] == 1
      assert sample["cloneItems"] == String.to_integer(count)
      assert sample["staggerMaxMs"] <= 1000

      ids =
        Regex.scan(~r/\sid="([^"]+)"/, fixtures[count], capture: :all_but_first) |> List.flatten()

      assert ids == Enum.uniq(ids)

      for [target] <-
            Regex.scan(~r/commandfor="([^"]+)"/, fixtures[count], capture: :all_but_first),
          do: assert(target in ids)

      refute fixtures[count] =~ ~r/(<script|aria-selected|role="(?:tab|menu|progressbar)")/
    end

    assert budget["compiledCssBytes"] == byte_size(File.read!("priv/static/shadcn_ui.css"))
    assert budget["marqueeMaxMs"] <= 5000
    assert File.read!("docs/milestone-e-acceptance.md") =~ "pending, not performed"
  end
end
