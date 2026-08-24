defmodule ShadcnUI.Components.Foundation.CardTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.card shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :regions, :map, required: true
    attr :content, :string, default: "Required content"

    def render(assigns) do
      ~H"""
      <.card
        class={["consumer-card", nil, false]}
        aria-labelledby="card-title"
        data-record-id="42"
        phx-mounted="observe"
      >
        <:header :if={@regions.header}>
          <p data-region="header">Eyebrow</p>
        </:header>
        <:title :if={@regions.title}>
          <h3 id="card-title">Caller heading</h3>
        </:title>
        <:description :if={@regions.description}>{"Description <unsafe>"}</:description>
        <:actions :if={@regions.actions}><a href="/details">Details</a></:actions>
        <form action="/preferences" method="post">
          <label>Preference <input name="preference" /></label>
          <span>{@content}</span>
        </form>
        <:footer :if={@regions.footer}><button type="submit">Save</button></:footer>
      </.card>
      """
    end
  end

  test "renders every optional region combination around required primary content" do
    keys = [:header, :title, :description, :actions, :footer]

    for mask <- 0..31 do
      regions =
        keys
        |> Enum.with_index()
        |> Map.new(fn {key, bit} -> {key, Bitwise.band(mask, Bitwise.bsl(1, bit)) != 0} end)

      html = render_card(regions: regions)

      assert html =~ ~s(data-shadcn-ui-slot="content")
      assert html =~ ~s(<form action="/preferences" method="post">)

      for key <- keys do
        marker = ~s(data-shadcn-ui-slot="#{key}")
        assert html =~ marker == Map.fetch!(regions, key)
      end

      assert html =~ ~s(data-shadcn-ui-slot="header-region") ==
               Enum.any?([:header, :title, :description, :actions], &Map.fetch!(regions, &1))
    end
  end

  test "preserves caller headings, links, forms, controls, globals, and escaping" do
    html = render_card(content: "Value <unsafe>")

    assert html =~ ~s(<h3 id="card-title">Caller heading</h3>)
    assert html =~ ~s(<a href="/details">Details</a>)
    assert html =~ ~s(<form action="/preferences" method="post">)
    assert html =~ ~s(<input name="preference">)
    assert html =~ ~s(<button type="submit">Save</button>)
    assert html =~ ~s(aria-labelledby="card-title")
    assert html =~ ~s(data-record-id="42")
    assert html =~ ~s(phx-mounted="observe")
    assert html =~ "Description &lt;unsafe&gt;"
    assert html =~ "Value &lt;unsafe&gt;"
    refute html =~ "<unsafe>"
  end

  test "keeps deterministic region order" do
    html = render_card()

    assert html =~
             ~r/slot="header".*slot="title".*slot="description".*slot="actions".*slot="content".*slot="footer"/s
  end

  test "uses token-driven surface and deterministic sparse spacing" do
    dense = render_card()
    sparse = render_card(regions: empty_regions())

    for class <- ~w(
          sui:w-full sui:max-w-full sui:rounded-xl sui:border sui:border-border
          sui:bg-card sui:text-card-foreground sui:shadow-sm consumer-card
        ) do
      assert dense =~ class
    end

    assert dense =~ "sui:p-6"
    assert dense =~ "sui:pb-4"
    assert dense =~ "sui:px-6"
    assert dense =~ "sui:pt-5"
    refute dense =~ "sui:pt-6"
    assert sparse =~ "sui:pt-6"
    assert sparse =~ "sui:pb-6"
  end

  test "adds no click, destination, selection, or workflow semantics" do
    html = render_card(regions: empty_regions())

    refute html =~ ~r/<(?:a|button)\b/
    refute html =~ ~r/\s(?:role|href|aria-selected|aria-current|tabindex|phx-click)=/

    metadata = ShadcnUI.Components.Foundation.Card.__components__().card
    inner_block = Enum.find(metadata.slots, &(&1.name == :inner_block))

    assert inner_block.required

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [
               :href,
               :navigate,
               :selected,
               :on_click,
               :loading,
               :record,
               :command,
               :html,
               :raw_html
             ]
           end)
  end

  test "source owns no workflow, event handling, data model, or raw HTML" do
    source = File.read!("lib/shadcn_ui/components/foundation/card.ex")

    refute source =~
             ~r/(push_event|handle_event|JS\.|System\.cmd|Task\.|GenServer|Repo\.|Ecto\.|Ash\.|HTTP|fetch\()/

    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
  end

  defp render_card(overrides \\ []) do
    %{
      regions: %{header: true, title: true, description: true, actions: true, footer: true},
      content: "Required content",
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp empty_regions do
    %{header: false, title: false, description: false, actions: false, footer: false}
  end
end
