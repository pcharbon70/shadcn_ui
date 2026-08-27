defmodule ShadcnUIDemo.GalleryShellTest do
  use ExUnit.Case, async: true

  test "semantic shell keeps navigation before main and uses zoom-resilient sizing" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")

    assert layout =~ ~r/gallery-masthead.*<nav.*<main/s
    assert layout =~ ~s(href="#main-content")
    assert layout =~ ~s(aria-label="Breadcrumb")
    assert layout =~ ~s(aria-label="Component navigation")
    assert layout =~ ~s(aria-label="Mobile component navigation")
    assert layout =~ ~s(<summary>Browse components</summary>)
    assert layout =~ "<.navigation_sections"
    refute layout =~ ~r/(role="(?:menu|tree|tablist)"|ResizeObserver|appendChild|insertBefore)/
    assert css =~ "minmax(12rem, 16rem)"
    assert css =~ "body { margin: 0; min-width: 0; }"
    assert css =~ "max-width: 48rem"
    assert css =~ ":focus-visible"
    assert css =~ "min-block-size: 2.75rem"
    assert css =~ ".gallery-mobile-navigation { display: none;"
    assert css =~ ".gallery-mobile-navigation { display: block;"
  end

  test "desktop and mobile navigation share every ordered ordinary destination" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")

    assert length(Regex.scan(~r/<\.navigation_sections/, layout)) == 2
    assert layout =~ ~s(<a href={category.path})
    assert layout =~ ~s(<a href={component.path})
    assert layout =~ ~s(<a href={composition.path})
    refute layout =~ ~r/(phx-click|data-on-click|pushState|replaceState|role="menu")/
  end

  test "shell renders one complete escaped build identity without support claims" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")

    assert layout =~ "data-gallery-build-identity"
    assert layout =~ "@build_identity.package_version"
    assert layout =~ "@build_identity.build_revision"
    assert layout =~ "@build_identity.catalogue_schema"
    assert layout =~ "@build_identity.upstream_revision"
    refute layout =~ ~r/(supported Electron|certified browser|deployment successful)/i
  end
end
