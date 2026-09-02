defmodule ShadcnUIDemo.GalleryShellTest do
  use ExUnit.Case, async: true

  test "semantic shell keeps navigation before main and uses zoom-resilient sizing" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")

    assert layout =~ ~r/data-gallery-product-header.*<nav.*<main/s
    assert layout =~ ~s(href="#main-content")
    assert layout =~ ~s(aria-label="Breadcrumb")
    assert layout =~ ~s(aria-label="Component navigation")
    assert layout =~ ~s(aria-label="Mobile component navigation")
    assert layout =~ ~s(<summary>Navigation</summary>)
    assert layout =~ "<.navigation_sections"
    assert layout =~ "data-gallery-documentation-grid"
    assert layout =~ "data-gallery-desktop-catalogue"
    assert layout =~ "data-gallery-main"
    refute layout =~ ~r/(role="(?:menu|tree|tablist)"|ResizeObserver|appendChild|insertBefore)/
    assert css =~ "13.75rem minmax(0, 1fr)"
    assert css =~ "body { margin: 0; min-width: 0; }"
    assert css =~ "max-width: 63.999rem"
    assert css =~ ":focus-visible"
    assert css =~ "min-block-size: 2.75rem"
    assert css =~ ".gallery-mobile-navigation { display: none;"
    assert css =~ ".gallery-mobile-navigation { display: block;"
  end

  test "desktop documentation grid and persistent catalogue use the pinned geometry" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")

    assert layout =~
             ~r/data-gallery-documentation-grid.*data-gallery-desktop-catalogue.*data-gallery-main/s

    assert layout =~ ~s(data-gallery-breadcrumb)
    assert layout =~ ~s(data-gallery-showcase)

    assert css =~ "grid-template-columns: 13.75rem minmax(0, 1fr)"
    assert css =~ "gap: 2.5rem"
    assert css =~ "max-inline-size: 72rem"
    assert css =~ "padding-inline: 1.25rem"
    assert css =~ ".gallery-catalogue { position: sticky; inset-block-start: 5rem"
    assert css =~ "max-block-size: calc(100dvh - 6rem)"
    assert css =~ ".gallery-navigation { min-block-size: 0; overflow-y: auto"
    assert css =~ "scrollbar-gutter: stable"
    assert css =~ "overscroll-behavior: contain"
    assert css =~ "box-shadow: inset .125rem 0 0 currentColor"
    refute css =~ "scrollbar-width: none"
  end

  test "compact product header exposes truthful primary destinations and theme controls" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")

    assert layout =~ ~s(data-gallery-product-header)
    assert layout =~ ~s(aria-label="ShadcnUI home")
    assert layout =~ ~s(aria-label="Primary navigation")
    assert layout =~ ~s(href="/examples/documentation")
    assert layout =~ ~s(href="/components/foundation")
    assert layout =~ ~s(href="https://github.com/pcharbon70/shadcn_ui")
    assert layout =~ ~s(role="group" aria-label="Theme")
    assert layout =~ ~s(data-gallery-metadata)

    [header] =
      Regex.run(~r/<header[^>]*data-gallery-product-header[^>]*>.*?<\/header>/s, layout)

    refute header =~ "data-gallery-package-version"

    refute layout =~ ~r/(script bytes shipped: 0|ships zero JavaScript)/i

    assert css =~ "position: sticky"
    assert css =~ "block-size: calc(3.5rem - 1px)"
    assert css =~ "max-inline-size: 72rem"
    assert css =~ "padding-inline: 1.25rem"
    assert css =~ "backdrop-filter: blur(8px)"
    assert css =~ "@media (forced-colors: active)"
  end

  test "desktop and mobile navigation share every ordered ordinary destination" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")

    assert length(Regex.scan(~r/<\.navigation_sections/, layout)) == 2
    assert layout =~ ~s(<a href={category.path})
    assert layout =~ ~s(<a href={component.path})
    assert layout =~ ~r/<a[^>]*href={composition.path}/
    refute layout =~ ~r/(phx-click|data-on-click|pushState|replaceState|role="menu")/
  end

  test "native mobile navigation, catalogue search, and footer metadata stay progressive" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")
    javascript = File.read!("assets/gallery.js")

    assert layout =~
             ~s(<details class="gallery-mobile-navigation" data-gallery-mobile-navigation>)

    assert layout =~ ~s(<summary>Navigation</summary>)
    assert layout =~ ~s(aria-label="Mobile primary navigation")
    assert layout =~ ~s(<search class="gallery-search" data-gallery-search>)

    assert layout =~
             ~r/data-gallery-catalogue.*data-gallery-search.*data-gallery-desktop-catalogue/s

    assert layout =~ ~r/data-gallery-main.*<footer[^>]*data-gallery-metadata/s
    refute layout =~ "data-gallery-secondary-tools"

    assert css =~ "max-block-size: calc(100dvh - 4.5rem)"
    assert css =~ "env(safe-area-inset-left)"
    assert css =~ "env(safe-area-inset-right)"
    assert css =~ "overscroll-behavior: contain"
    assert css =~ "min-block-size: 2.75rem"

    refute layout =~ ~r/(role="(?:dialog|menu)"|aria-modal|popovertarget|commandfor)/
    refute javascript =~ ~r/(fetch\(|XMLHttpRequest|pushState|replaceState|location\s*=)/
  end

  test "shell footer renders only the package version without deployment identifiers" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")

    assert layout =~ "data-gallery-package-version"
    assert layout =~ "@build_identity.package_version"
    refute layout =~ "@build_identity.build_revision"
    refute layout =~ "@build_identity.catalogue_schema"
    refute layout =~ "@build_identity.upstream_revision"
    refute layout =~ ~r/(supported Electron|certified browser|deployment successful)/i
  end

  test "progressive search filters existing links without routing or remote data" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    javascript = File.read!("assets/gallery.js")

    assert layout =~ ~s(label for="gallery-component-search")
    assert layout =~ ~s(maxlength="200")
    assert layout =~ "data-gallery-search-item"
    assert layout =~ "DocumentationCatalogue.search_texts()"
    assert layout =~ "Map.fetch!(@search_texts, component.path)"
    assert javascript =~ "item.hidden = !visible"
    assert javascript =~ "searchStatus.textContent"
    assert javascript =~ "new Set()"
    refute javascript =~ ~r/(fetch\(|XMLHttpRequest|pushState|replaceState|innerHTML)/
  end
end
