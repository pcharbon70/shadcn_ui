defmodule ShadcnUI.StylesheetTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.stylesheet.canonical_asset shadcn_ui.stylesheet.pinned_build
  # covers: shadcn_ui.stylesheet.explicit_sources shadcn_ui.stylesheet.prefixed_isolation
  # covers: shadcn_ui.stylesheet.semantic_tokens shadcn_ui.stylesheet.scoped_dark_theme
  # covers: shadcn_ui.stylesheet.consumer_overrides shadcn_ui.stylesheet.asset_path
  # covers: shadcn_ui.stylesheet.reduced_motion shadcn_ui.stylesheet.no_runtime_assets
  # covers: shadcn_ui.stylesheet.reproducible_output
  # covers: shadcn_ui.stylesheet.form_fallbacks shadcn_ui.stylesheet.form_resilience
  # covers: shadcn_ui.stylesheet.content_fallbacks shadcn_ui.stylesheet.content_resilience

  @stylesheet Path.expand("../../priv/static/shadcn_ui.css", __DIR__)
  @source Path.expand("../../assets/shadcn_ui.css", __DIR__)

  test "distributes one nonempty canonical minified stylesheet" do
    assert File.regular?(@stylesheet)
    css = File.read!(@stylesheet)
    assert byte_size(css) > 100
    refute css =~ "\n\n"
  end

  test "pins Tailwind and its CLI in both npm manifests" do
    package = Jason.decode!(File.read!("package.json"))
    lock = Jason.decode!(File.read!("package-lock.json"))

    assert package["devDependencies"] == %{
             "@tailwindcss/cli" => "4.3.3",
             "tailwindcss" => "4.3.3"
           }

    assert lock["packages"][""]["devDependencies"] == package["devDependencies"]
    assert lock["packages"]["node_modules/tailwindcss"]["version"] == "4.3.3"
    assert lock["packages"]["node_modules/@tailwindcss/cli"]["version"] == "4.3.3"
  end

  test "uses explicit package sources and excludes Preflight" do
    source = File.read!(@source)

    assert source =~ ~s(@source "../lib/**/*.ex")
    assert source =~ ~s(@source "./**/*.css")
    assert source =~ "@import \"tailwindcss/theme.css\" prefix(sui)"
    assert source =~ "@import \"tailwindcss/utilities.css\" prefix(sui)"
    refute source =~ "preflight.css"
    refute source =~ ~s(@import "tailwindcss")
  end

  test "keeps every authored foundation selector opt-in" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)

    assert source =~ "[data-shadcn-ui]"
    refute source =~ ~r/(^|\n)\s*(?:\*|html|body|button|input|select|textarea)\s*[{,]/
    refute css =~ ~r/(^|})\s*(?:\*|html|body|button|input|select|textarea)\s*[{,]/
  end

  test "contains prefixed utilities without hidden runtime assets" do
    css = File.read!(@stylesheet)

    assert css =~ ".sui\\:inline-flex"
    assert css =~ ".sui\\:h-9"
    refute css =~ ~r/\.inline-flex(?:[,{])/
    refute css =~ "--tw-"
    assert css =~ "--sui-tw-"
    refute css =~ ~r/@import\s+(?:url\()?['\"]?https?:/i
    refute css =~ ~r/url\(['\"]?https?:/i
    refute css =~ ~r/<script|javascript:/i
  end

  test "coexists with Bulma and supports a stylesheet-only consumer fixture" do
    coexistence = File.read!("test/fixtures/coexistence.html")
    consumer = File.read!("test/fixtures/stylesheet_consumer.html")

    assert coexistence =~ ~s(class="button is-primary")
    assert coexistence =~ ~s(class="sui:inline-flex sui:h-9")
    assert consumer =~ ~s(href="shadcn_ui.css")
    refute consumer =~ ~r/<script|node_modules|tailwind/i
  end

  test "defines complete namespaced light defaults and scoped dark values" do
    source = File.read!(@source)

    for token <- ~w(
      background foreground card card-foreground popover popover-foreground
      primary primary-foreground secondary secondary-foreground muted
      muted-foreground accent accent-foreground destructive
      destructive-foreground border input ring radius-sm radius-md radius-lg
      radius-xl motion-fast motion-normal motion-slow ease-standard
    ) do
      assert source =~ "--shadcn-ui-#{token}:"
    end

    assert source =~ ~s([data-shadcn-theme="light"])
    assert source =~ ~s([data-shadcn-theme="dark"])
    refute source =~ ".dark"
    refute source =~ "color-scheme:"
    refute source =~ ~r/--(?:background|foreground|primary|ring):/
  end

  test "maps semantic tokens through a progressive color enhancement" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)

    assert source =~ "@supports (color: oklch(1 0 0))"
    assert source =~ "--color-primary: var(--shadcn-ui-primary)"
    assert source =~ "--color-ring: var(--shadcn-ui-ring)"
    assert css =~ "var(--shadcn-ui-primary)"
    assert css =~ "var(--shadcn-ui-ring)"
    assert css =~ ".sui\\:bg-primary"
  end

  test "supports nested theme scopes and consumer token overrides" do
    fixture = File.read!("test/fixtures/theme_scopes.html")

    assert fixture =~ ~s(data-shadcn-theme="light")
    assert fixture =~ ~s(data-shadcn-theme="dark")
    assert fixture =~ ~s(data-shadcn-theme="unsupported")
    assert fixture =~ "--shadcn-ui-primary: rebeccapurple"
  end

  test "provides visible focus and a scoped reduced-motion fallback" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)
    focus = ShadcnUI.Component.classes_for(:focus, :default)

    assert "sui:focus-visible:outline-2" in focus
    assert "sui:focus-visible:ring-2" in focus
    assert "sui:focus-visible:outline-ring" in focus
    assert source =~ "@media (prefers-reduced-motion: reduce)"
    assert source =~ "animation-duration: 0.01ms !important"
    assert source =~ "transition-duration: 0.01ms !important"
    assert css =~ "prefers-reduced-motion:reduce"
  end

  test "preserves focus and disabled state in forced colors" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)

    assert source =~ "@media (forced-colors: active)"
    assert source =~ "[data-shadcn-ui]:focus-visible"
    assert source =~ "outline-color: Highlight"
    assert source =~ "[data-shadcn-ui][disabled]"
    assert source =~ "color: GrayText"
    assert source =~ "opacity: 1"

    assert css =~ "forced-colors:active"
    assert css =~ "outline-color:highlight"
    assert css =~ "color:graytext"
  end

  test "keeps content affordances capability-gated with native forced-color fallbacks" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)

    assert source =~ "@supports (mask-image: linear-gradient(black, black))"
    assert source =~ "[data-shadcn-ui-scroll-area]"
    assert source =~ "scrollbar-gutter: stable"
    assert source =~ "mask-image: none !important"
    assert source =~ "scrollbar-color: CanvasText Canvas"
    assert source =~ "[data-shadcn-ui-separator]"
    assert source =~ "background: CanvasText"

    assert css =~ "scrollbar-gutter:stable"
    assert css =~ "mask-image:none!important"
    assert css =~ "scrollbar-color:CanvasText Canvas"
  end
end
