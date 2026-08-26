defmodule ShadcnUI.Components.Overlays.TooltipTest do
  use ExUnit.Case, async: false
  alias ShadcnUI.Components.Overlays.Tooltip

  # covers: shadcn_ui.supplemental.tooltip shadcn_ui.supplemental.tooltip_fallback
  # covers: shadcn_ui.supplemental.css_behavior shadcn_ui.supplemental.no_interest_claim
  # covers: shadcn_ui.supplemental.protected_semantics shadcn_ui.supplemental.shared_contract

  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "save-tip",
        text: "Saved <locally> & safely",
        describedby: nil,
        placement: :block_end,
        class: ["caller", [nil, "bubble"]],
        rest: %{},
        surface_rest: %{},
        trigger: [%{label: "Save"}]
      },
      attrs
    )
    |> Tooltip.tooltip()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "one escaped nonfocusable description preserves a complete native button" do
    html = render(%{describedby: "help help save-tip-description"})
    assert html =~ ~s(id="save-tip-invoker" type="button")
    assert html =~ ~s(aria-describedby="help save-tip-description")
    assert html =~ ~s(id="save-tip-description" role="tooltip")
    assert html =~ "Saved &lt;locally&gt; &amp; safely"
    assert html =~ ">Save</button>"
    assert html =~ "caller bubble"
    assert render() == render()
    refute html =~ ~r/(tabindex|interestfor|popover|<script|aria-expanded|aria-haspopup)/
  end

  test "native submission, disabled snapshot, destination and transport pass unchanged" do
    html =
      render(%{
        trigger: [
          %{
            label: "Save",
            type: "submit",
            disabled: true,
            form: "editor",
            name: "intent",
            value: "save",
            rest: %{"phx-click" => "save", "data-owner" => "caller"}
          }
        ]
      })

    for value <- [
          ~s(type="submit"),
          " disabled",
          ~s(form="editor"),
          ~s(name="intent"),
          ~s(value="save"),
          ~s(phx-click="save"),
          ~s(data-owner="caller")
        ],
        do: assert(html =~ value)

    link =
      render(%{
        trigger: [
          %{
            kind: :link,
            label: "Manual",
            href: "/manual",
            target: "_blank",
            rel: "noopener",
            download: "manual.txt",
            current: "page"
          }
        ]
      })

    for value <- [
          ~s(href="/manual"),
          ~s(target="_blank"),
          ~s(rel="noopener"),
          ~s(download="manual.txt"),
          ~s(aria-current="page")
        ],
        do: assert(link =~ value)
  end

  test "case-insensitive conflicting globals cannot replace semantic identity" do
    globals = %{
      "ID" => "wrong",
      "ROLE" => "button",
      "ARIA-HASPOPUP" => "menu",
      "aria-expanded" => "true",
      "tabindex" => "0",
      "aria_describedby" => "wrong",
      "ARIA-HIDDEN" => "true",
      "contenteditable" => "true",
      "data-on-click" => "app",
      "data-owner" => "caller"
    }

    html =
      render(%{rest: globals, surface_rest: globals, trigger: [%{label: "Save", rest: globals}]})

    refute html =~ "wrong"
    refute html =~ ~r/(tabindex|ARIA-HIDDEN|ARIA-HASPOPUP|aria-expanded|contenteditable)/
    assert html =~ ~s(data-owner="caller")
    assert html =~ ~s(data-on-click="app")
  end

  test "closed placement and malformed content validation" do
    for placement <- [:block_start, :block_end, :inline_start, :inline_end] do
      assert render(%{placement: placement}) =~
               ~s(data-placement="#{String.replace(to_string(placement), "_", "-")}")
    end

    for attrs <- [
          %{id: ""},
          %{text: " "},
          %{text: {:safe, "<b>raw</b>"}},
          %{placement: :left},
          %{describedby: 123},
          %{trigger: []},
          %{trigger: [%{label: "a"}, %{label: "b"}]},
          %{trigger: [%{label: " "}]},
          %{trigger: [%{label: "a", inner_block: fn _, _ -> "<input>" end}]},
          %{trigger: [%{label: "a", kind: :input}]},
          %{trigger: [%{label: "a", type: "menu"}]},
          %{trigger: [%{label: "a", disabled: "false"}]},
          %{trigger: [%{label: "a", href: "/mixed"}]},
          %{trigger: [%{label: "a", kind: :link, href: "javascript:alert(1)"}]},
          %{trigger: [%{label: "a", kind: :link, href: "/ok", disabled: false}]}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "native source contains no behavior or raw string conversion" do
    source = File.read!("lib/shadcn_ui/components/overlays/tooltip.ex")

    refute source =~
             ~r/(Phoenix.HTML.raw|<script|interestfor=|popover=|addEventListener|setTimeout)/

    css = File.read!("assets/shadcn_ui.css")

    for rule <- [
          ":focus-visible +",
          "(hover: hover) and (pointer: fine)",
          "anchor-scope:",
          "prefers-reduced-motion",
          "forced-colors"
        ],
        do: assert(css =~ rule)
  end
end
