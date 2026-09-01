defmodule ShadcnUIDemo.MotionMediaCatalogTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, GalleryPreferences}
  # covers: shadcn_ui.motion_media_gallery.incremental_catalog
  # covers: shadcn_ui.motion_media_gallery.motion_inspection
  # covers: shadcn_ui.motion_media_gallery.references
  test "adds an actual foundation composition without advertising unfinished components", %{
    conn: conn
  } do
    assert "/examples/motion-media-capabilities" in Catalogue.routes()
    html = conn |> get("/examples/motion-media-capabilities") |> html_response(200)
    assert html =~ "The shared foundations"
    assert {:ok, %{render: :marquee}} = Catalogue.lookup_component("motion", "marquee")
    assert {:ok, %{render: :stagger}} = Catalogue.lookup_component("motion", "stagger")

    assert {:ok, %{render: :scroll_indicator}} =
             Catalogue.lookup_component("motion", "scroll-indicator")

    assert {:ok, %{render: :cover_flow}} = Catalogue.lookup_component("media", "cover-flow")
    assert html =~ "Observed behavior"
    assert html =~ "151.0.7922.34"
    assert html =~ "153.0"
    assert html =~ "26.5"

    assert html =~
             ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui/examples/motion-media-capabilities")

    assert {:ok, %{render: :carousel}} = Catalogue.lookup_component("media", "carousel")
    assert {:ok, %{render: :image_gallery}} = Catalogue.lookup_component("media", "image-gallery")
  end

  test "closed preferences preserve independent theme and motion choices", %{conn: conn} do
    for theme <- ~w(light dark), motion <- ~w(system reduce) do
      path = GalleryPreferences.link("/components/foundation/button", theme, motion)
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ ~s(data-shadcn-theme="#{theme}")
      assert html =~ ~s(data-shadcn-motion="#{motion}")
      assert html =~ "theme=#{theme}&amp;motion=reduce"
      assert html =~ "<noscript>"
    end

    html = conn |> recycle() |> get("/?theme=untrusted&motion=force") |> html_response(200)
    assert html =~ ~s(data-shadcn-motion="system")
    refute html =~ "untrusted"
    assert GalleryPreferences.link("/untrusted", "bad", "force") == "/?theme=light&motion=system"
    assert GalleryPreferences.motion(%{"motion" => ["reduce"]}) == "system"
  end

  test "unknown compositions remain nonreflecting", %{conn: conn} do
    html = conn |> get("/examples/untrusted-composition?motion=force") |> html_response(404)
    refute html =~ "untrusted-composition"
    refute html =~ ~s(rel="canonical")
  end
end
