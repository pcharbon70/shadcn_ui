defmodule ShadcnUI.Components.Content.SeparatorTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.content.separator shadcn_ui.content.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :mode, :atom, default: :semantic
    attr :orientation, :atom, default: :horizontal
    attr :rest, :global

    def render(assigns) do
      ~H"""
      <.separator
        mode={@mode}
        orientation={@orientation}
        class={["consumer-separator", nil, false]}
        id="section-boundary"
        title="Section boundary"
        data-owner="application"
        phx-mounted="observe"
        {@rest}
      />
      """
    end
  end

  test "renders semantic mode as one native hr with protected meaning" do
    html = render_separator(rest: %{role: "presentation", "aria-hidden": "true"})

    assert html =~ "<hr"
    assert html =~ ~s(aria-orientation="horizontal")
    assert html =~ ~s(data-orientation="horizontal")
    assert html =~ ~s(id="section-boundary")
    assert html =~ ~s(title="Section boundary")
    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(phx-mounted="observe")
    refute html =~ ~s(role="presentation")
    refute html =~ ~s(aria-hidden="true")
    refute html =~ "<div"
  end

  test "renders decorative mode as one aria-hidden nonsemantic element" do
    html =
      render_separator(
        mode: :decorative,
        orientation: :vertical,
        rest: %{"aria-hidden": "false", "aria-orientation": "horizontal", role: "separator"}
      )

    assert html =~ "<div"
    assert html =~ ~s(aria-hidden="true")
    assert html =~ ~s(data-orientation="vertical")
    refute html =~ "<hr"
    refute html =~ ~s(role="separator")
    refute html =~ ~s(aria-orientation="horizontal")
  end

  test "maps both orientations to complete deterministic static classes" do
    horizontal = render_separator() |> classes()
    vertical = render_separator(orientation: :vertical) |> classes()

    for common <- ~w(sui:shrink-0 sui:border-0 sui:bg-border consumer-separator) do
      assert common in horizontal
      assert common in vertical
    end

    assert Enum.all?(~w(sui:h-px sui:w-full), &(&1 in horizontal))
    assert Enum.all?(~w(sui:h-full sui:min-h-4 sui:w-px), &(&1 in vertical))
    assert render_separator() == render_separator()
  end

  test "publishes closed mode, orientation, class, global, and empty-slot metadata" do
    metadata = ShadcnUI.Components.Content.Separator.__components__().separator
    mode = Enum.find(metadata.attrs, &(&1.name == :mode))
    orientation = Enum.find(metadata.attrs, &(&1.name == :orientation))

    assert mode.opts[:values] == [:semantic, :decorative]
    assert orientation.opts[:values] == [:horizontal, :vertical]
    assert metadata.slots == []

    assert_raise KeyError, fn -> render_separator(orientation: :diagonal) end
    assert_raise KeyError, fn -> render_separator(mode: :unknown) end
  end

  test "records token, forced-color, coexistence, provenance, and ownership contracts" do
    source = File.read!("assets/shadcn_ui.css")
    css = File.read!(ShadcnUI.stylesheet_path())
    coexistence = File.read!("test/fixtures/coexistence.html")
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == "content.separator"))

    assert source =~ "[data-shadcn-ui-separator]"
    assert source =~ "background: var(--shadcn-ui-border)"
    assert source =~ "background: CanvasText"
    assert css =~ "[data-shadcn-ui-separator]"
    assert css =~ "var(--shadcn-ui-border)"
    assert coexistence =~ ~s(class="has-background-grey")
    assert coexistence =~ "data-shadcn-ui-separator"
    assert "lib/shadcn_ui/components/content/separator.ex" in adaptation["localPaths"]
    assert adaptation["upstreamPaths"] == ["src/styles/global.css"]
    guide = File.read!("docs/guides/content-surfaces.md")
    assert guide =~ "`mode={:semantic}` renders meaningful separation"
    assert guide =~ "`mode={:decorative}` hides the boundary from the accessibility tree"
  end

  test "source owns no component runtime, application behavior, or raw HTML" do
    source = File.read!("lib/shadcn_ui/components/content/separator.ex")

    refute source =~
             ~r/(push_event|handle_event|JS\.|System\.cmd|Task\.|GenServer|Repo\.|Ecto\.|Ash\.|HTTP|fetch\()/

    refute source =~ ~r/(System\.unique_integer|:rand|UUID|String\.to_atom|binary_to_atom)/i
    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
  end

  defp render_separator(overrides \\ []) do
    %{
      mode: :semantic,
      orientation: :horizontal,
      rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp classes(html) do
    [value] = Regex.run(~r/class="([^"]*)"/, html, capture: :all_but_first)
    String.split(value)
  end
end
