defmodule ShadcnUI.ImageGalleryIntegrationTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.motion_media_contract.distribution shadcn_ui.motion_media_contract.runtime_boundary
  # covers: shadcn_ui.motion_media_contract.css_exceptions shadcn_ui.provenance.component_mapping

  test "defining API composes existing Dialog with pinned provenance and no image or overlay runtime" do
    source = File.read!("lib/shadcn_ui/components/media/image_gallery.ex")
    assert File.read!("lib/shadcn_ui.ex") =~ "ShadcnUI.Components.Media.ImageGallery"
    assert source =~ "<Dialog.dialog"
    assert source =~ "OverlayContract.validate_nesting!"
    assert source =~ "sui:max-h-[60dvb] sui:object-contain"
    assert source =~ "sui:max-h-[calc(100%-2rem)]! sui:overflow-auto!"
    assert source =~ "sui:max-h-none! sui:overflow-visible!"

    refute source =~
             ~r/(<script|addEventListener|String\.to_atom|GenServer|Process\.|phx-hook|IntersectionObserver|requestAnimationFrame|setInterval|Phoenix.LiveView|Req\.|HTTPoison)/

    mappings = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))["adaptations"]
    mapping = Enum.find(mappings, &(&1["id"] == "media.image-gallery"))
    assert mapping["localPaths"] == ["lib/shadcn_ui/components/media/image_gallery.ex"]

    assert mapping["upstreamPaths"] == [
             "src/content/components/gallery.mdx",
             "src/demos/gallery/basic.html"
           ]

    assert mapping["localChanges"] =~ "Defer optional"

    assert File.read!("assets/engineering/motion-media-css-exceptions.md") =~
             "Phase 5 — no additional CSS exception"
  end

  test "origin evidence, generated fixture and release exclusion remain distinct from normative policy" do
    fixture = File.read!("test/fixtures/milestone_e_image_gallery.html")
    ids = Regex.scan(~r/\sid="([^"]+)"/, fixture, capture: :all_but_first) |> List.flatten()
    assert ids == Enum.uniq(ids)

    for [target] <- Regex.scan(~r/commandfor="([^"]+)"/, fixture, capture: :all_but_first),
        do: assert(target in ids)

    refute fixture =~
             ~r/(<script|aria-selected|aria-live|onerror|onclick|<dialog[^>]*\sopen(?:\s|>))/

    record = Jason.decode!(File.read!("demo/priv/compatibility/image_gallery_evidence.json"))
    manifest = Jason.decode!(File.read!("priv/compatibility/motion_media.json"))
    assert record["decision"] == "deferred"
    assert manifest["bundles"]["galleryOrigin"]["fallback"] =~ "deferred after Phase 5"

    for {engine, result} <- record["engines"] do
      assert result["version"] == manifest["verificationEvidence"]["engines"][engine]["version"]
      assert result["modal"]
    end

    refute Enum.any?(
             Mix.Project.config()[:package][:files],
             &String.starts_with?(&1, ["demo", "test", "scripts", "assets"])
           )

    assert File.read!("scripts/check-release-archive.exs") =~ "image_gallery_evidence"
  end
end
