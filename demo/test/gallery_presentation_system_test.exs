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
    catalogue = File.read!("lib/shadcn_ui_demo/presentation_catalogue.ex")
    page = File.read!("lib/shadcn_ui_demo_web/controllers/page_html/gallery.html.heex")
    css = File.read!("assets/gallery.css")

    assert component =~ ~s(<figure)
    assert component =~ ~s(<fieldset class="gallery-specimen__views">)
    assert component =~ ~s(type="radio")
    assert component =~ ~s(data-gallery-specimen-preview)
    assert component =~ ~s(data-gallery-specimen-source)
    assert component =~ ~s(data-gallery-copy)
    assert component =~ ~s(tabindex="0")
    assert component =~ "@layouts PresentationCatalogue.layout_identities()"
    assert component =~ "PresentationCatalogue.layout_class!(assigns.layout)"

    for layout <- ~w(centered start constrained tall overflow composition) do
      assert catalogue =~ ~s("#{layout}" => "gallery-specimen--#{layout}")
    end

    assert component =~ "Phoenix.HTML.html_escape()"
    assert component =~ "highlight_heex"
    refute component =~ ~r/(role="(?:tab|tablist|tabpanel)"|phx-click)/
    assert page =~ "<.specimen"
    assert css =~ "@media print"
    assert css =~ ".gallery-specimen__panel:target"
  end

  test "motion inspection is declarative and ancestor scoped" do
    root = File.read!("lib/shadcn_ui_demo_web/components/layouts/root.html.heex")
    css = File.read!("../assets/shadcn_ui.css")

    assert root =~ ~s(data-shadcn-motion={assigns[:motion] || "system"})

    assert css =~
             ~s|:is([data-shadcn-motion="reduce"], [data-shadcn-ui-motion="none"])|

    assert css =~ "[data-shadcn-ui-accordion-summary]::after"
    assert css =~ "[data-shadcn-ui-accordion-item]::details-content"
    assert css =~ "transition: none !important"
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

  test "checked presentation evidence hashes locked local goldens" do
    evidence =
      "priv/reference/milestone_g/phase-03-presentation-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["evidenceType"] == "local-automated-presentation-evidence"
    assert evidence["states"]["localAutomated"] == "passed"
    assert evidence["states"]["ci"] == "not-run"
    assert evidence["states"]["manualAccessibility"] == "not-run"
    assert evidence["states"]["deployment"] == "not-run"
    assert length(evidence["goldens"]) == 4

    for golden <- evidence["goldens"] do
      bytes = File.read!(Path.expand("../#{golden["file"]}", File.cwd!()))
      assert Base.encode16(:crypto.hash(:sha256, bytes), case: :lower) == golden["sha256"]
    end
  end

  test "presentation primitives stay demo-only without an unrestricted reset" do
    css = File.read!("assets/gallery.css")
    package = File.read!("../mix.exs")
    archive = File.read!("../scripts/check-release-archive.exs")

    refute css =~ ~r/(^|,\s*)\*\s*\{/m
    refute css =~ ~r/^html\s*\{/m
    refute css =~ ~r/@import|https?:\/\//
    refute package =~ ~r/"demo"\s*,/
    assert archive =~ ~s("demo/")
    refute File.exists?("../priv/static/bricolage-grotesque-wght.woff2")
  end
end
