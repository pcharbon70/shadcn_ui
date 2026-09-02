defmodule ShadcnUIDemo.ScrollMediaGalleryTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, Reference, MotionMediaCapabilities}

  # covers: shadcn_ui.motion_media_gallery.incremental_catalog shadcn_ui.motion_media_gallery.references
  # covers: shadcn_ui.motion_media_gallery.compositions shadcn_ui.motion_media_gallery.capability_evidence

  test "both references and compositions render real native components in every preference", %{
    conn: conn
  } do
    for path <- [
          "/components/media/cover-flow",
          "/components/motion/scroll-indicator",
          "/examples/media-browser",
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
               ~s(rel="canonical" href="https://pcharbon70-shadcn-ui-demo.fly.dev#{path}")

      ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
      assert Enum.uniq(ids) == ids

      if String.starts_with?(path, "/components/") do
        assert html =~ "HEEX source"
        assert html =~ ~s(aria-current="page")
      else
        assert html =~ "data-shadcn-ui-cover-flow"
        assert html =~ "data-shadcn-ui-scroll-indicator"
      end
    end
  end

  test "copyable examples compile using direct public metadata" do
    for {key, module, marker} <- [
          {:cover_flow, ShadcnUIDemo.CoverSourceFixture, "cover-flow"},
          {:scroll_indicator, ShadcnUIDemo.IndicatorSourceFixture, "scroll-indicator"}
        ] do
      source = Reference.fetch!(key).source |> String.replace("\n", "\n    ")

      Code.compile_string("""
      defmodule #{inspect(module)} do
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
        apply(module, :render, [%{__changed__: nil}])
        |> Phoenix.HTML.Safe.to_iodata()
        |> IO.iodata_to_binary()

      assert html =~ "data-shadcn-ui-#{marker}"
      assert html =~ "/media/ridge.svg"
    end
  end

  test "component outcomes remain separately recorded and version locked", %{conn: conn} do
    record = MotionMediaCapabilities.scroll_media()
    assert record["schemaVersion"] == 1

    for {engine, outcome} <- record["engines"] do
      assert outcome["version"] ==
               MotionMediaCapabilities.evidence()["engines"][engine]["version"]

      assert outcome["scrollIndicator"] in ["neutral", "enhanced"]
      assert outcome["coverFlow"] in ["flat", "enhanced"]
    end

    html = conn |> get("/examples/motion-media-capabilities") |> html_response(200)
    assert html =~ "Phase 4 actual component behavior"
    assert html =~ "not declaration parsing"
  end
end
