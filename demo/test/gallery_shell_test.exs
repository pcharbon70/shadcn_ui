defmodule ShadcnUIDemo.GalleryShellTest do
  use ExUnit.Case, async: true

  test "semantic shell keeps navigation before main and uses zoom-resilient sizing" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")

    assert layout =~ ~r/gallery-masthead.*<nav.*<main/s
    assert layout =~ ~s(href="#main-content")
    assert layout =~ ~s(aria-label="Breadcrumb")
    assert layout =~ ~s(aria-label="Component navigation")
    refute layout =~ ~r/(role="(?:menu|tree|tablist)"|ResizeObserver|appendChild|insertBefore)/
    assert css =~ "minmax(12rem, 16rem)"
    assert css =~ "body { margin: 0; min-width: 0; }"
    assert css =~ "max-width: 48rem"
    assert css =~ ":focus-visible"
  end
end
