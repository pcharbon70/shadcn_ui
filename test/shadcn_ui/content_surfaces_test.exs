defmodule ShadcnUI.ContentSurfacesTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.content.scroll_area shadcn_ui.content.scroll_focus
  # covers: shadcn_ui.content.scroll_ownership shadcn_ui.content.edge_fallback
  # covers: shadcn_ui.content.separator shadcn_ui.content.shared_contract
  # covers: shadcn_ui.stylesheet.content_fallbacks shadcn_ui.stylesheet.content_resilience

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :instance, :string, required: true
    attr :theme, :string, required: true

    def render(assigns) do
      ~H"""
      <section
        id={"surface-#{@instance}"}
        data-shadcn-theme={@theme}
        class="bulma-consumer-section"
      >
        <h2 id={"heading-#{@instance}"}>Activity {@instance}</h2>
        <.separator class="has-background-grey" />
        <.separator orientation={:vertical} mode={:decorative} />
        <.scroll_area
          id={"events-#{@instance}"}
          size={:small}
          edge_affordance={:both}
          focusable
          labelledby={"heading-#{@instance}"}
          class="consumer-overflow"
        >
          <p>First event for {@instance}</p>
          <p id={"final-#{@instance}"}>Final event for {@instance}</p>
        </.scroll_area>
      </section>
      """
    end
  end

  test "repeated light and dark compositions remain deterministic and caller-identified" do
    light = render("light", "light")
    dark = render("dark", "dark")

    assert light == render("light", "light")
    assert dark == render("dark", "dark")
    assert light =~ ~s(data-shadcn-theme="light")
    assert dark =~ ~s(data-shadcn-theme="dark")
    assert light =~ ~s(aria-labelledby="heading-light")
    assert dark =~ ~s(aria-labelledby="heading-dark")

    ids =
      [light, dark]
      |> Enum.join()
      |> then(&Regex.scan(~r/\sid="([^"]+)"/, &1, capture: :all_but_first))
      |> List.flatten()

    assert length(ids) == length(Enum.uniq(ids))
  end

  test "content surfaces coexist with consumer and Bulma-shaped classes" do
    html = render("coexistence", "light")

    assert html =~ "bulma-consumer-section"
    assert html =~ "has-background-grey"
    assert html =~ "consumer-overflow"
    assert html =~ "sui:bg-border"
    assert html =~ "sui:overflow-y-auto"
    assert length(Regex.scan(~r/data-shadcn-ui-separator/, html)) == 2
    assert length(Regex.scan(~r/data-shadcn-ui-scroll-area/, html)) == 1
  end

  test "no-CSS fixture preserves native structure, focus, fragments, and all content" do
    fixture = File.read!("test/fixtures/content_surfaces_no_css.html")

    refute fixture =~ ~r/<link[^>]+stylesheet/i
    refute fixture =~ ~r/<script/i
    assert fixture =~ "<hr"
    assert fixture =~ ~s(role="region")
    assert fixture =~ ~s(tabindex="0")
    assert fixture =~ ~s(aria-label="Recent activity")
    assert fixture =~ ~s(href="#final-event")
    assert fixture =~ ~s(id="final-event")
    assert fixture =~ "First event remains readable."
    assert fixture =~ "Final fragment target remains reachable."
  end

  test "forced colors removes decorative masks and preserves native scrollbars" do
    source = File.read!("assets/shadcn_ui.css")
    forced_colors = source |> String.split("@media (forced-colors: active)") |> List.last()

    assert forced_colors =~ "[data-shadcn-ui-separator]"
    assert forced_colors =~ "background: CanvasText"
    assert forced_colors =~ "[data-shadcn-ui-scroll-area]"
    assert forced_colors =~ "mask-image: none !important"
    assert forced_colors =~ "scrollbar-color: CanvasText Canvas"
  end

  test "phase sources contain no observers, scroll handlers, custom controls, or application dependencies" do
    source =
      [
        "lib/shadcn_ui/components/content/scroll_area.ex",
        "lib/shadcn_ui/components/content/separator.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~
             ~r/(IntersectionObserver|ResizeObserver|MutationObserver|addEventListener|onscroll|scrollTop|scrollLeft|handle_event|push_event|JS\.|Phoenix\.LiveView|Ecto|Ash\.|Repo\.|Dstar|Datastar|Electron|GenServer|Task\.)/

    refute source =~ ~r/(<button|<input|role="scrollbar"|aria-valuenow)/i
    refute source =~ ~r/(<script|javascript:|raw_html|HTML\.raw)/i
    refute File.exists?("assets/scroll_area.js")
    refute File.exists?("assets/separator.js")
  end

  test "compiled package integration contains both primitives and no application surface" do
    css = File.read!(ShadcnUI.stylesheet_path())
    docs = Mix.Project.config()[:docs]
    content_modules = Keyword.fetch!(docs[:groups_for_modules], :"Content components")

    assert css =~ "data-shadcn-ui-separator"
    assert css =~ "data-shadcn-ui-scroll-area"
    assert ShadcnUI.Components.Content.Separator in content_modules
    assert ShadcnUI.Components.Content.ScrollArea in content_modules

    refute File.dir?("lib/shadcn_ui_web")
    refute File.exists?("lib/shadcn_ui/router.ex")
  end

  defp render(instance, theme) do
    %{instance: instance, theme: theme, __changed__: nil}
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
