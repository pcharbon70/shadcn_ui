defmodule ShadcnUIDemo.MotionGalleryTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, Reference}

  # covers: shadcn_ui.motion_media_gallery.incremental_catalog shadcn_ui.motion_media_gallery.references
  # covers: shadcn_ui.motion_media_gallery.compositions shadcn_ui.motion_media_gallery.motion_inspection

  test "Motion references and preferences have complete closed themed routes", %{conn: conn} do
    assert Enum.map(Catalogue.components("motion"), & &1.render) == [
             :marquee,
             :stagger,
             :scroll_indicator
           ]

    for path <- [
          "/components/motion/marquee",
          "/components/motion/stagger",
          "/examples/motion-preferences"
        ],
        theme <- ~w(light dark),
        motion <- ~w(system reduce) do
      assert path in Catalogue.routes()

      html =
        conn |> recycle() |> get(path <> "?theme=#{theme}&motion=#{motion}") |> html_response(200)

      assert html =~ ~s(data-shadcn-theme="#{theme}")
      assert html =~ ~s(data-shadcn-motion="#{motion}")

      assert html =~
               ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{path}")

      assert html =~ "data-shadcn-ui-motion"

      if String.starts_with?(path, "/components/") do
        assert html =~ "Attributes and item slots"
        assert html =~ "HEEX source"
        assert html =~ ~s(aria-current="page")
      else
        assert html =~ ~s(href="/examples/motion-preferences?theme=#{theme}&amp;motion=reduce")
        assert html =~ "Reset local note"
      end
    end
  end

  test "copyable motion HEEx compiles through direct public imports" do
    for {component, fixture} <- [
          {:marquee, ShadcnUIDemo.MarqueeSourceFixture},
          {:stagger, ShadcnUIDemo.StaggerSourceFixture}
        ] do
      source = Reference.fetch!(component).source |> String.replace("\n", "\n    ")

      Code.compile_string("""
      defmodule #{inspect(fixture)} do
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
        apply(fixture, :render, [%{__changed__: nil}])
        |> Phoenix.HTML.Safe.to_iodata()
        |> IO.iodata_to_binary()

      assert html =~ "data-shadcn-ui-#{component}"
      assert html =~ "/media/ridge.svg"
    end
  end

  test "mismatched and future leaves stay nonreflecting", %{conn: conn} do
    for path <- [
          "/components/media/marquee",
          "/components/media/scroll-indicator",
          "/examples/untrusted-motion"
        ] do
      html = conn |> recycle() |> get(path) |> html_response(404)
      refute html =~ "untrusted-motion"
      refute html =~ ~s(rel="canonical")
    end

    html =
      conn
      |> recycle()
      |> get("/examples/motion-preferences?theme=dark&motion=force")
      |> html_response(200)

    assert html =~ ~s(data-shadcn-theme="dark")
    assert html =~ ~s(data-shadcn-motion="system")
  end
end
