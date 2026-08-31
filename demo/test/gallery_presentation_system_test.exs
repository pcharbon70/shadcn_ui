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

  test "specimens keep honest radio semantics, source order, and closed layouts" do
    component = File.read!("lib/shadcn_ui_demo_web/components/presentation_components.ex")
    page = File.read!("lib/shadcn_ui_demo_web/controllers/page_html/gallery.html.heex")
    css = File.read!("assets/gallery.css")

    assert component =~ ~s(<figure)
    assert component =~ ~s(<fieldset class="gallery-specimen__views">)
    assert component =~ ~s(type="radio")
    assert component =~ ~s(data-gallery-specimen-preview)
    assert component =~ ~s(data-gallery-specimen-source)
    assert component =~ ~s(data-gallery-copy)
    assert component =~ ~s(tabindex="0")
    assert component =~ "@layouts ~w(centered start constrained tall overflow composition)"
    assert component =~ "Phoenix.HTML.html_escape()"
    assert component =~ "highlight_heex"
    refute component =~ ~r/(role="(?:tab|tablist|tabpanel)"|phx-click)/
    assert page =~ "<.specimen"
    assert css =~ "@media print"
    assert css =~ ".gallery-specimen__panel:target"
  end

  test "capability badges and support tables keep authored policy distinct" do
    component = File.read!("lib/shadcn_ui_demo_web/components/presentation_components.ex")
    css = File.read!("assets/gallery.css")

    assert component =~ "@capability_identities"
    assert component =~ ~s(data-gallery-capability={@identity})
    assert component =~ ~s(data-gallery-support-table)
    assert component =~ "Locked-engine evidence"
    assert component =~ "When missing"
    assert component =~ ~s(scope="col")
    assert component =~ ~s(scope="row")
    assert css =~ "@supports (color: color-mix"
    assert css =~ "@media (forced-colors: active)"
    refute component =~ ~r/(navigator|userAgent|CSS\.supports)/
  end
end
