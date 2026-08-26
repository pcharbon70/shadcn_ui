defmodule ShadcnUI.Components.Motion.ScrollIndicatorTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Motion.ScrollIndicator
  # covers: shadcn_ui.motion_components.indicator shadcn_ui.motion_components.timeline_fallback
  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "reading",
        accessible_label: "Read <notes>",
        labelledby: nil,
        description: "Native & complete",
        size: :default,
        motion: :system,
        class: "caller",
        rest: %{},
        inner_block: [
          %{
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(
                ~s(<h2>Notes</h2><a href="/read">Read</a><form><label>Note<input name="note"></label><button>Save</button></form>)
              )
            end
          }
        ]
      },
      attrs
    )
    |> ScrollIndicator.scroll_indicator()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "one named focusable region preserves content and adds only hidden decoration" do
    html = render()
    assert html == render()
    assert html =~ ~s(role="region" tabindex="0" aria-label="Read &lt;notes&gt;")
    assert html =~ "Native &amp; complete"
    assert html =~ ~s(aria-hidden="true" data-shadcn-ui-scroll-track)
    assert html =~ ~s(name="note")
    assert html =~ "--shadcn-ui-scroll-timeline:--shadcn-ui-media-"
    refute html =~ ~r/(progressbar|aria-value|aria-live|<script|percent|on-scroll)/
    refute render(%{id: "other"}) =~ "--shadcn-ui-media-72656164696e67-"
  end

  test "all bounded sizes and heading naming work while invalid inputs fail" do
    for size <- [:small, :default, :large], motion <- [:system, :none] do
      assert render(%{
               size: size,
               motion: motion,
               accessible_label: nil,
               labelledby: "heading other",
               description: nil
             }) =~ ~s(aria-labelledby="heading other")
    end

    for attrs <- [
          %{id: "bad id"},
          %{accessible_label: nil},
          %{accessible_label: " "},
          %{labelledby: "heading"},
          %{accessible_label: nil, labelledby: "#heading"},
          %{size: :huge},
          %{motion: :force},
          %{description: 1},
          %{inner_block: []},
          %{inner_block: nil}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "globals cannot replace identities, semantics or timeline source" do
    html =
      render(%{
        rest: %{
          id: "bad",
          role: "progressbar",
          style: "timeline-scope:--outside",
          hidden: true,
          "aria-valuenow": 40,
          "aria-valuetext": "Reading complete",
          "aria-selected": "true",
          "aria-current": "step",
          "aria-roledescription": "progress",
          "data-owner": "caller",
          "phx-mounted": "caller"
        }
      })

    refute html =~
             ~r/(id="bad"|progressbar|outside|aria-value|aria-selected|aria-current|aria-roledescription| hidden)/

    assert html =~ ~s(data-owner="caller")
    assert html =~ ~s(phx-mounted="caller")
  end
end
