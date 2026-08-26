defmodule ShadcnUIDemo.CarouselGalleryTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, Reference}
  # covers: shadcn_ui.motion_media_gallery.incremental_catalog
  # covers: shadcn_ui.motion_media_gallery.references
  # covers: shadcn_ui.motion_media_gallery.compositions
  # covers: shadcn_ui.motion_media_gallery.motion_inspection

  test "Carousel and the real composition have closed themed routes and complete local media", %{
    conn: conn
  } do
    for path <- ["/components/media/carousel", "/examples/media-browser"],
        theme <- ~w(light dark),
        motion <- ~w(system reduce) do
      assert path in Catalogue.routes()

      html =
        conn |> recycle() |> get(path <> "?theme=#{theme}&motion=#{motion}") |> html_response(200)

      assert html =~ ~s(data-shadcn-theme="#{theme}")
      assert html =~ ~s(data-shadcn-motion="#{motion}")

      assert html =~
               ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{path}")

      assert html =~ "data-shadcn-ui-carousel-scroll"
      assert html =~ ~s(src="/media/ridge.svg")
      if path == "/components/media/carousel", do: assert(html =~ "aria-current=\"page\"")
    end

    html = conn |> recycle() |> get("/components/media/carousel") |> html_response(200)
    assert html =~ "Attributes and item slots"
    assert html =~ "&lt;.carousel"
    assert html =~ "Reset local preferences"
    assert html =~ "Oversized card"
  end

  test "inert authored Carousel source compiles through public defining imports" do
    source = Reference.fetch!(:carousel).source |> String.replace("\n", "\n    ")

    Code.compile_string("""
    defmodule ShadcnUIDemo.CarouselSourceFixture do
      use Phoenix.Component
      use ShadcnUI
      def render(assigns) do
        ~H\"\"\"
        #{source}
        \"\"\"
      end
    end
    """)

    html =
      apply(ShadcnUIDemo.CarouselSourceFixture, :render, [%{}])
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ ~s(role="region")
    assert html =~ ~s(href="/media/ridge.svg")
  end

  test "mismatched and unfinished media pages are nonreflecting", %{conn: conn} do
    for path <- [
          "/components/forms/carousel",
          "/components/media/image-gallery",
          "/examples/untrusted-media"
        ] do
      html = conn |> recycle() |> get(path) |> html_response(404)
      refute html =~ ~s(rel="canonical")
      refute html =~ "untrusted-media"
    end
  end
end
