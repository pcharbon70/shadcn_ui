defmodule ShadcnUI.Components.Overlays.HoverCardTest do
  use ExUnit.Case, async: false
  alias ShadcnUI.Components.Overlays.HoverCard

  # covers: shadcn_ui.supplemental.hover_card shadcn_ui.supplemental.hover_card_boundary
  # covers: shadcn_ui.supplemental.css_behavior shadcn_ui.supplemental.no_interest_claim
  # covers: shadcn_ui.supplemental.protected_semantics shadcn_ui.supplemental.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    def preview(assigns) do
      ~H"""
      <div class="summary" lang="en">
        <h3>Manual</h3><p>{@text}</p><time datetime="2026-08-26">August 26</time>
      </div>
      """
    end

    def invalid(assigns) do
      ~H"""
      <div>
        <.dynamic_tag tag_name={@tag} {@attributes}>Forbidden</.dynamic_tag>
      </div>
      """
    end

    def consumer(assigns) do
      ~H"""
      <.hover_card id="consumer">
        <:trigger label="Manual" href="/manual" />
        <p>Supplemental context, also in the manual.</p>
      </.hover_card>
      """
    end
  end

  defp render(attrs) do
    slot = %{inner_block: fn _, _ -> Fixture.preview(%{text: "Optional <context>"}) end}

    Map.merge(
      %{
        __changed__: nil,
        id: "manual",
        describedby: nil,
        placement: :block_end,
        class: ["caller", [nil, "preview"]],
        rest: %{},
        trigger: [
          %{
            label: "Manual",
            href: "/manual",
            target: "_blank",
            rel: "noopener noreferrer",
            download: "manual.html",
            current: "page",
            rest: %{"data-on-click" => "app"}
          }
        ],
        inner_block: [slot]
      },
      attrs
    )
    |> HoverCard.hover_card()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "trusted presentation, link policy, protected IDs, escaping and deterministic rendering" do
    html = render(%{describedby: "help help manual-description"})

    for expected <- [
          ~s(id="manual-invoker" href="/manual"),
          ~s(target="_blank"),
          ~s(rel="noopener noreferrer"),
          ~s(download="manual.html"),
          ~s(aria-current="page"),
          ~s(aria-describedby="help manual-description"),
          ~s(id="manual-description"),
          ~s(data-on-click="app"),
          "Optional &lt;context&gt;",
          "caller preview"
        ],
        do: assert(html =~ expected)

    assert html == render(%{describedby: "help help manual-description"})
    refute html =~ ~r/(role=|tabindex|interestfor|popover|<script|aria-expanded|aria-haspopup)/

    assert Fixture.consumer(%{}) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary() =~
             "Supplemental context"
  end

  test "closed logical placement and unrelated wrapper globals" do
    for placement <- [:block_start, :block_end, :inline_start, :inline_end] do
      html =
        render(%{
          placement: placement,
          rest: %{
            "ID" => "bad",
            "ROLE" => "menu",
            "TABINDEX" => "0",
            "aria_describedby" => "bad",
            "data-owner" => "caller"
          }
        })

      assert html =~ ~s(data-placement="#{String.replace(to_string(placement), "_", "-")}")
      assert html =~ ~s(data-owner="caller")
      refute html =~ "bad"
      refute html =~ "TABINDEX"
    end
  end

  test "forbids interactive, focusable, fetching, scripted or stateful preview markup" do
    for {tag, attributes} <- [
          {"a", %{href: "/action"}},
          {"button", %{}},
          {"form", %{}},
          {"details", %{}},
          {"div", %{tabindex: "0"}},
          {"div", %{contenteditable: "true"}},
          {"span", %{role: "status"}},
          {"div", %{"data-on-click" => "app"}},
          {"div", %{onclick: "alert(1)"}},
          {"div", %{style: "background:url(/fetch)"}},
          {"video", %{}},
          {"script", %{}},
          {"svg", %{}},
          {"iframe", %{}},
          {"select", %{}}
        ] do
      slot = %{inner_block: fn _, _ -> Fixture.invalid(%{tag: tag, attributes: attributes}) end}

      assert_raise ArgumentError, ~r/noninteractive presentation/, fn ->
        render(%{inner_block: [slot]})
      end
    end
  end

  test "rejects absent, duplicate, raw preview and invalid or nested triggers" do
    for attrs <- [
          %{id: "invalid id"},
          %{placement: :top},
          %{inner_block: []},
          %{inner_block: [%{}, %{}]},
          %{inner_block: [%{inner_block: fn _, _ -> "<p>raw</p>" end}]},
          %{inner_block: [%{inner_block: fn _, _ -> {:safe, "<p>raw</p>"} end}]},
          %{trigger: []},
          %{trigger: [%{label: "Manual"}]},
          %{trigger: [%{label: "", href: "/"}]},
          %{trigger: [%{label: "Manual", href: "javascript:alert(1)"}]},
          %{trigger: [%{label: "Manual", href: "/", inner_block: fn _, _ -> "nested" end}]}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "no package behavior or implicit loading is authored" do
    source = File.read!("lib/shadcn_ui/components/overlays/hover_card.ex")

    refute source =~
             ~r/(<script|interestfor=|popover=|addEventListener|setTimeout|Phoenix.HTML.raw|fetch\()/
  end
end
