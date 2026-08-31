defmodule ShadcnUIDemo.GalleryPresentationSystemTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.gallery_presentation.presentation_system
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.accessibility_matrix

  test "typography and prose are gallery-scoped with deterministic fallbacks" do
    css = File.read!("assets/gallery.css")
    root = File.read!("lib/shadcn_ui_demo_web/components/layouts/root.html.heex")
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")

    assert css =~ ~s(@font-face)
    assert css =~ ~s(font-family: "Bricolage Grotesque")
    assert css =~ ~s(font-display: swap)
    assert css =~ ~s(--gallery-font-display:)
    assert css =~ ~s(--gallery-font-body:)
    assert css =~ ~s(--gallery-font-mono:)
    assert css =~ ".gallery-article :is(p, ul, ol, blockquote)"
    assert css =~ "max-inline-size: 72ch"
    assert css =~ ".gallery-article [id]"
    assert root =~ ~s(rel="preload")
    assert root =~ ~s(as="font")
    assert layout =~ ~s(class="gallery-article")
    refute css =~ ~r/^h[1-6]\s*\{/m
    refute css =~ ~r/^p\s*\{/m
  end
end
