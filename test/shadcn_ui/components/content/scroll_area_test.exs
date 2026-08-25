defmodule ShadcnUI.Components.Content.ScrollAreaTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.content.scroll_area shadcn_ui.content.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :axis, :atom, default: :vertical
    attr :size, :atom, default: :default
    attr :edge_affordance, :atom, default: :none
    attr :focusable, :any, default: false
    attr :accessible_label, :any, default: nil
    attr :labelledby, :any, default: nil
    attr :content, :string, default: "Activity <script>alert('unsafe')</script>"
    attr :rest, :global

    def render(assigns) do
      ~H"""
      <.scroll_area
        axis={@axis}
        size={@size}
        edge_affordance={@edge_affordance}
        focusable={@focusable}
        accessible_label={@accessible_label}
        labelledby={@labelledby}
        class={["consumer-scroll-area", nil, false]}
        id="activity-log"
        title="Recent events"
        data-owner="application"
        phx-mounted="restore-scroll"
        {@rest}
      >
        <p>{@content}</p>
      </.scroll_area>
      """
    end
  end

  test "renders required escaped content in one unfocusable native container by default" do
    html = render_scroll_area()

    assert html =~ ~s(<div id="activity-log")
    assert html =~ "Activity &lt;script&gt;alert(&#39;unsafe&#39;)&lt;/script&gt;"
    assert html =~ ~s(data-axis="vertical")
    assert html =~ ~s(data-size="default")
    assert html =~ ~s(data-edge-affordance="none")
    refute html =~ "tabindex="
    refute html =~ "role="
    refute html =~ "aria-label="
    assert length(Regex.scan(~r/<div\b/, html)) == 1
  end

  test "maps every axis, size, and edge value to deterministic static output" do
    expectations = [
      {:vertical, :small, :start, ~w(sui:overflow-x-hidden sui:overflow-y-auto sui:max-h-40)},
      {:horizontal, :default, :end, ~w(sui:overflow-x-auto sui:overflow-y-hidden sui:max-h-64)},
      {:both, :large, :both, ~w(sui:overflow-auto sui:max-h-96)}
    ]

    for {axis, size, edge, expected_classes} <- expectations do
      html = render_scroll_area(axis: axis, size: size, edge_affordance: edge)
      rendered_classes = classes(html)

      assert html =~ ~s(data-axis="#{axis}")
      assert html =~ ~s(data-size="#{size}")
      assert html =~ ~s(data-edge-affordance="#{edge}")
      assert Enum.all?(expected_classes, &(&1 in rendered_classes))
      assert "consumer-scroll-area" in rendered_classes
      assert html == render_scroll_area(axis: axis, size: size, edge_affordance: edge)
    end
  end

  test "focusable mode requires and protects exactly one accessible name source" do
    labelled =
      render_scroll_area(
        focusable: true,
        accessible_label: "  Recent activity  ",
        rest: %{role: "button", tabindex: "9", "aria-label": "Override"}
      )

    related = render_scroll_area(focusable: true, labelledby: "activity-heading")

    assert labelled =~ ~s(role="region")
    assert labelled =~ ~s(tabindex="0")
    assert labelled =~ ~s(aria-label="Recent activity")
    refute labelled =~ ~s(role="button")
    refute labelled =~ ~s(tabindex="9")
    refute labelled =~ ~s(aria-label="Override")

    assert related =~ ~s(role="region")
    assert related =~ ~s(tabindex="0")
    assert related =~ ~s(aria-labelledby="activity-heading")
  end

  test "rejects missing, competing, malformed, and invalid closed values" do
    for overrides <- [
          [focusable: true],
          [focusable: true, accessible_label: "  "],
          [focusable: true, accessible_label: "Activity", labelledby: "heading"],
          [focusable: :yes, accessible_label: "Activity"],
          [focusable: true, accessible_label: 42],
          [focusable: true, labelledby: [:heading]]
        ] do
      assert_raise ArgumentError, fn -> render_scroll_area(overrides) end
    end

    assert_raise KeyError, fn -> render_scroll_area(axis: :diagonal) end
    assert_raise KeyError, fn -> render_scroll_area(size: :unbounded) end
    assert_raise KeyError, fn -> render_scroll_area(edge_affordance: :automatic) end
  end

  test "forwards unrelated globals while protecting package and focus semantics" do
    html =
      render_scroll_area(
        rest: %{
          "aria-describedby": "activity-help",
          "data-shadcn-ui-scroll-area": "override",
          "data-axis": "override"
        }
      )

    assert html =~ ~s(id="activity-log")
    assert html =~ ~s(title="Recent events")
    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(phx-mounted="restore-scroll")
    assert html =~ ~s(aria-describedby="activity-help")
    assert html =~ ~s(data-axis="vertical")
    refute html =~ ~s(data-shadcn-ui-scroll-area="override")
  end

  test "publishes the closed API and required content slot" do
    metadata = ShadcnUI.Components.Content.ScrollArea.__components__().scroll_area

    assert attr_values(metadata, :axis) == [:vertical, :horizontal, :both]
    assert attr_values(metadata, :size) == [:small, :default, :large]
    assert attr_values(metadata, :edge_affordance) == [:none, :start, :end, :both]
    assert Enum.find(metadata.slots, &(&1.name == :inner_block)).required
  end

  test "records progressive CSS, forced-color fallback, provenance, and ownership" do
    source = File.read!("assets/shadcn_ui.css")
    css = File.read!(ShadcnUI.stylesheet_path())
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == "content.scroll_area"))
    readme = File.read!("README.md")

    assert source =~ "@supports (mask-image: linear-gradient"

    assert source =~
             ~s([data-shadcn-ui-scroll-area][data-axis="vertical"][data-edge-affordance="both"])

    assert source =~ "scrollbar-color: CanvasText Canvas"
    assert css =~ "scrollbar-gutter:stable"

    assert adaptation["upstreamPaths"] == [
             "src/content/components/scroll-area.mdx",
             "src/demos/scroll-area/basic.html"
           ]

    assert "lib/shadcn_ui/components/content/scroll_area.ex" in adaptation["localPaths"]
    assert readme =~ "Applications own dimensions beyond the closed presets"
    assert readme =~ "content remains available"
  end

  test "source owns no scroll runtime, custom controls, application behavior, or package JavaScript" do
    source = File.read!("lib/shadcn_ui/components/content/scroll_area.ex")

    refute source =~
             ~r/(IntersectionObserver|ResizeObserver|scrollTop|scrollLeft|addEventListener|handle_event|push_event|JS\.|GenServer|Repo\.|Ecto\.|Ash\.|HTTP|fetch\()/

    refute source =~
             ~r/(button|input type="range"|System\.unique_integer|:rand|UUID|String\.to_atom|binary_to_atom)/i

    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
    refute File.exists?("assets/scroll_area.js")
  end

  defp render_scroll_area(overrides \\ []) do
    %{
      axis: :vertical,
      size: :default,
      edge_affordance: :none,
      focusable: false,
      accessible_label: nil,
      labelledby: nil,
      content: "Activity <script>alert('unsafe')</script>",
      rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp attr_values(metadata, name) do
    Enum.find(metadata.attrs, &(&1.name == name)).opts[:values]
  end

  defp classes(html) do
    [value] = Regex.run(~r/class="([^"]*)"/, html, capture: :all_but_first)
    String.split(value)
  end
end
