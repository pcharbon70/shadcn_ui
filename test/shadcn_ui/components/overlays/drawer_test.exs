defmodule ShadcnUI.Components.Overlays.DrawerTest do
  use ExUnit.Case, async: false
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.dialog.drawer shadcn_ui.dialog.drawer_scroll
  # covers: shadcn_ui.dialog.protected_semantics shadcn_ui.dialog.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :id, :any, default: "filters"
    attr :title?, :boolean, default: true
    attr :description?, :boolean, default: true
    attr :label, :any, default: nil
    attr :edge, :atom, default: :end
    attr :size, :atom, default: :default
    attr :dismissal, :atom, default: :close_request
    attr :focus, :atom, default: :content
    attr :globals, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.drawer
        id={@id}
        accessible_label={@label}
        edge={@edge}
        size={@size}
        dismissal={@dismissal}
        initial_focus={@focus}
        class="consumer-surface"
        trigger_rest={@globals}
        dialog_rest={@globals}
        content_rest={@globals}
        close_rest={@globals}
        data-owner="caller"
      >
        <:trigger>Open filters</:trigger>
        <:title :if={@title?}>{"Filters <unsafe>"}</:title>
        <:description :if={@description?}>Choose a filter.</:description>
        <:header>
          <p>Caller header</p>
        </:header>
        <form id="filter-form" method="get" action="/results" data-on-submit="caller">
          <label for="query">Query</label><input id="query" name="q" value="initial" />
        </form>
        <:footer><button form="filter-form" type="submit">Apply</button></:footer>
        <:close>Close</:close>
        <:fallback><a href="/filters">Open full filter page</a></:fallback>
      </.drawer>
      """
    end
  end

  test "native modal structure, deterministic naming, escaping, slots and forms" do
    html = render_drawer()
    assert length(Regex.scan(~r/<dialog\b/, html)) == 1
    assert html =~ ~s(command="show-modal" commandfor="filters-surface")
    assert html =~ ~s(command="close" commandfor="filters-surface")
    assert html =~ ~s(aria-labelledby="filters-title")
    assert html =~ ~s(aria-describedby="filters-description")
    assert html =~ "Filters &lt;unsafe&gt;"
    assert html =~ "Caller header"
    assert html =~ ~s(form="filter-form")
    assert html =~ ~s(data-on-submit="caller")
    assert html =~ ~s(href="/filters")
    assert html =~ "consumer-surface"
    assert html =~ ~s(data-owner="caller")
    refute html =~ ~r/<dialog[^>]+\s(?:open|tabindex|role)=/
    refute html =~ ~r/<(?:nav|aside)\b/
    assert render_drawer() == html
  end

  test "closed edges, sizes and dismissal policies" do
    for edge <- [:start, :end, :bottom],
        size <- [:small, :default, :large],
        {policy, value} <- [none: "none", close_request: "closerequest", any: "any"] do
      html = render_drawer(%{edge: edge, size: size, dismissal: policy})
      assert html =~ ~s(data-edge="#{edge}")
      assert html =~ ~s(data-size="#{size}")
      assert html =~ ~s(closedby="#{value}")
    end

    for attrs <- [%{edge: :left}, %{size: :full}, %{focus: :unknown}] do
      assert_raise KeyError, fn -> render_drawer(attrs) end
    end

    assert_raise ArgumentError, fn -> render_drawer(%{dismissal: :unknown}) end

    for id <- [nil, "", "bad id"] do
      assert_raise ArgumentError, fn -> render_drawer(%{id: id}) end
    end
  end

  test "required name, optional description and explicit focus choices" do
    html = render_drawer(%{title?: false, description?: false, label: "  Filter settings  "})
    assert html =~ ~s(aria-label="Filter settings")
    refute html =~ "aria-labelledby"
    refute html =~ "aria-describedby"
    assert_raise ArgumentError, fn -> render_drawer(%{title?: false}) end
    assert_raise ArgumentError, fn -> render_drawer(%{label: "Duplicate"}) end

    for {choice, id} <- [content: "filters-initial-focus", close: "filters-close"] do
      focused = render_drawer(%{focus: choice})
      assert focused =~ ~r/id="#{id}"[^>]*autofocus/
      assert length(Regex.scan(~r/\sautofocus(?:[\s=>])/, focused)) == 1
    end

    refute render_drawer(%{focus: :auto}) =~ "autofocus"
  end

  test "protected globals cannot replace semantics, focus, edge or explicit exit" do
    html =
      render_drawer(%{
        globals: %{
          "id" => "stolen",
          "role" => "navigation",
          "open" => true,
          "closedby" => "any",
          "command" => "evil",
          "commandfor" => "elsewhere",
          "aria-label" => "stolen",
          "aria-labelledby" => "stolen",
          "aria-modal" => "false",
          "autofocus" => true,
          "tabindex" => "-9",
          "data-edge" => "left",
          "data-size" => "unbounded",
          "data-shadcn-ui-drawer-surface" => "false",
          "disabled" => true,
          "data-caller" => "preserved",
          "phx-click" => "caller"
        }
      })

    [surface] = Regex.run(~r/<dialog[^>]*>/, html)

    refute surface =~
             ~r/(stolen|navigation|open|evil|elsewhere|aria-modal|autofocus|tabindex|left|unbounded)/

    assert surface =~ ~s(data-edge="end")
    assert surface =~ ~s(data-caller="preserved")
    assert surface =~ ~s(phx-click="caller")
    [close] = Regex.run(~r/<button[^>]*id="filters-close"[^>]*>/, html)
    refute close =~ "disabled"
    assert close =~ ~s(command="close")
  end

  test "required slots and singleton regions reject ambiguous structure" do
    source = ShadcnUI.Components.Overlays.Drawer.__components__().drawer
    names = Enum.map(source.slots, & &1.name)

    assert Enum.all?(
             [:trigger, :title, :description, :header, :inner_block, :footer, :close, :fallback],
             &(&1 in names)
           )

    base = %{
      id: "x",
      accessible_label: "Drawer",
      edge: :end,
      size: :default,
      dismissal: :close_request,
      initial_focus: :auto,
      trigger: [],
      title: [],
      description: [],
      header: [],
      footer: [],
      close: [],
      fallback: [],
      inner_block: []
    }

    assert_raise ArgumentError, ~r/trigger/, fn ->
      ShadcnUI.Components.Overlays.Drawer.drawer(base)
    end

    assert_raise ArgumentError, ~r/close/, fn ->
      ShadcnUI.Components.Overlays.Drawer.drawer(%{base | trigger: [%{}]})
    end

    for name <- [:title, :description, :header, :footer, :fallback] do
      attrs = base |> Map.merge(%{trigger: [%{}], close: [%{}]}) |> Map.put(name, [%{}, %{}])
      assert_raise ArgumentError, fn -> ShadcnUI.Components.Overlays.Drawer.drawer(attrs) end
    end
  end

  defp render_drawer(attrs \\ %{}),
    do: attrs |> Fixture.render() |> Safe.to_iodata() |> IO.iodata_to_binary()
end
