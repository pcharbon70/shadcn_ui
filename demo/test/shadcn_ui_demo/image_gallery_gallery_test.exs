defmodule ShadcnUIDemo.ImageGalleryGalleryTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, Reference, MotionMediaCapabilities}

  # covers: shadcn_ui.motion_media_gallery.incremental_catalog shadcn_ui.motion_media_gallery.references
  # covers: shadcn_ui.motion_media_gallery.compositions shadcn_ui.motion_media_gallery.capability_evidence

  test "reference and substantial composition retain native lightboxes, metadata and canonical preferences",
       %{conn: conn} do
    for path <- ["/components/media/image-gallery", "/examples/image-gallery"],
        theme <- ~w(light dark),
        motion <- ~w(system reduce) do
      assert path in Catalogue.routes()

      html =
        conn |> recycle() |> get(path <> "?theme=#{theme}&motion=#{motion}") |> html_response(200)

      for value <- [
            ~s(data-shadcn-theme="#{theme}"),
            ~s(data-shadcn-motion="#{motion}"),
            ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{path}"),
            "data-shadcn-ui-image-gallery",
            ~s(command="show-modal"),
            ~s(command="close"),
            "data-shadcn-ui-gallery-destination",
            ~s(src="/media/grove.svg"),
            ~s(width="480" height="640"),
            "srcset=",
            "Intentionally unavailable landscape"
          ],
          do: assert(html =~ value)

      ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
      assert ids == Enum.uniq(ids)
      refute html =~ ~r/<dialog[^>]*\sopen(?:\s|>)/

      if String.starts_with?(path, "/components/") do
        assert html =~ "HEEX source"
        assert html =~ ~s(aria-current="page")
        assert html =~ "Trusted" or html =~ "trusted"
      else
        assert html =~ "six views of three original"
        assert html =~ "Complete caption:"
        assert html =~ "LicenseRef-LECO-Proprietary"
      end
    end
  end

  test "copyable image source compiles with defining attribute metadata" do
    source = Reference.fetch!(:image_gallery).source |> String.replace("\n", "\n    ")

    Code.compile_string("""
    defmodule ShadcnUIDemo.ImageGallerySourceFixture do
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
      apply(ShadcnUIDemo.ImageGallerySourceFixture, :render, [%{__changed__: nil}])
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "data-shadcn-ui-gallery-full"
    assert html =~ "commandfor="
  end

  test "actual origin results stay distinct from declarations and visitor detection", %{
    conn: conn
  } do
    record = MotionMediaCapabilities.image_gallery()
    assert record["decision"] == "deferred"

    for {engine, outcome} <- record["engines"] do
      assert outcome["version"] ==
               MotionMediaCapabilities.evidence()["engines"][engine]["version"]

      assert outcome["modal"]
    end

    html = conn |> get("/examples/motion-media-capabilities") |> html_response(200)
    assert html =~ "Phase 5 native gallery and deferred origin effect"
    assert html =~ "Release presentation: native snap"
  end
end
