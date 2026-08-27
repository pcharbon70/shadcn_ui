defmodule ShadcnUI.MotionMediaDocsTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.motion_media_gallery.references shadcn_ui.package.public_import_surface
  test "the ExDoc guide compiles all six defining imports with intact metadata" do
    guide = File.read!("docs/motion-media-guide.md")
    [_, example] = Regex.run(~r/```heex\n(.*?)\n```/s, guide)
    example = String.replace(example, "\n", "\n    ")

    Code.compile_string("""
    defmodule ShadcnUI.MotionMediaGuideFixture do
      use Phoenix.Component
      use ShadcnUI
      def render(assigns) do
        ~H\"\"\"
        #{example}
        \"\"\"
      end
    end
    """)

    html =
      apply(ShadcnUI.MotionMediaGuideFixture, :render, [%{__changed__: nil}])
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    for marker <- ~w(carousel cover-flow image-gallery marquee stagger scroll-indicator),
        do: assert(html =~ "data-shadcn-ui-#{marker}")

    for {module, fun} <- [
          {ShadcnUI.Components.Media.Carousel, :carousel},
          {ShadcnUI.Components.Media.CoverFlow, :cover_flow},
          {ShadcnUI.Components.Media.ImageGallery, :image_gallery},
          {ShadcnUI.Components.Motion.Marquee, :marquee},
          {ShadcnUI.Components.Motion.Stagger, :stagger},
          {ShadcnUI.Components.Motion.ScrollIndicator, :scroll_indicator}
        ] do
      metadata = module.__components__()[fun]
      assert Enum.any?(metadata.attrs, &(&1.name == :id && &1.required))
      assert Enum.any?(metadata.attrs, &(&1.name == :motion && &1.opts[:default] == :system))
      {:docs_v1, _, _, _, _, _, entries} = Code.fetch_docs(module)

      assert Enum.any?(entries, fn {id, _, _, doc, _} ->
               id == {:function, fun, 1} && is_map(doc)
             end)

      assert module in List.flatten(
               Keyword.values(Mix.Project.config()[:docs][:groups_for_modules])
             )
    end
  end
end
