defmodule ShadcnUI.Components.Overlays.PopoverTest do
  use ExUnit.Case, async: false
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.popover.native_surface shadcn_ui.popover.modes
  # covers: shadcn_ui.popover.positioning shadcn_ui.popover.state_ownership
  # covers: shadcn_ui.popover.protected_semantics shadcn_ui.popover.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI
    attr :id, :any, default: "settings"
    attr :mode, :atom, default: :auto
    attr :action, :atom, default: :toggle
    attr :placement, :atom, default: :block_end
    attr :title?, :boolean, default: true
    attr :label, :any, default: nil
    attr :labelledby, :any, default: nil
    attr :optional?, :boolean, default: true
    attr :globals, :map, default: %{}
    attr :wrapper_globals, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.popover
        {@wrapper_globals}
        id={@id}
        mode={@mode}
        action={@action}
        placement={@placement}
        accessible_label={@label}
        labelledby={@labelledby}
        trigger_rest={@globals}
        surface_rest={@globals}
        close_rest={@globals}
        class="caller"
        data-owner="caller"
      >
        <:trigger>Settings</:trigger>
        <:title :if={@title?}>{"Settings <unsafe>"}</:title>
        <:description :if={@optional?}>Adjust the dimensions.</:description>
        <input name="width" aria-label="Width" />
        <:close :if={@optional?}>Close</:close>
        <:fallback :if={@optional?}><a href="/settings">Full settings</a></:fallback>
      </.popover>
      """
    end
  end

  test "native nonmodal invoker, names, optional slots, escaping and stable output" do
    html = render_popover()
    assert html =~ ~s(id="settings-invoker" type="button" popovertarget="settings-surface")
    assert html =~ ~s(popover="auto")
    assert html =~ ~s(aria-labelledby="settings-title")
    assert html =~ ~s(aria-describedby="settings-description")
    assert html =~ ~s(popovertargetaction="hide")
    assert html =~ ~s(href="/settings")
    assert html =~ "Settings &lt;unsafe&gt;"
    assert html =~ ~s(name="width")
    assert html =~ "caller"

    refute html =~
             ~r/(aria-expanded|aria-details|aria-haspopup|aria-modal|autofocus|<dialog|role="menu)/

    assert render_popover() == html
    minimal = render_popover(%{optional?: false})
    refute minimal =~ ~r/(settings-close|aria-describedby|data-shadcn-ui-popover-fallback)/
  end

  test "every closed mode, action and placement maps without atom creation" do
    for mode <- [:auto, :manual],
        action <- [:toggle, :show, :hide],
        {placement, rendered} <- [
          block_start: "block-start",
          block_end: "block-end",
          inline_start: "inline-start",
          inline_end: "inline-end"
        ] do
      html = render_popover(%{mode: mode, action: action, placement: placement})
      assert html =~ ~s(popover="#{mode}")
      assert html =~ ~s(popovertargetaction="#{action}")
      assert html =~ ~s(data-placement="#{rendered}")
    end

    for attrs <- [%{id: ""}, %{mode: :hint}, %{action: :open}, %{placement: :left}] do
      assert_raise ArgumentError, fn -> render_popover(attrs) end
    end
  end

  test "exactly one nonblank accessible naming source is required" do
    assert render_popover(%{title?: false, label: "Options"}) =~ ~s(aria-label="Options")

    assert render_popover(%{title?: false, labelledby: "external heading"}) =~
             ~s(aria-labelledby="external heading")

    for attrs <- [
          %{title?: false},
          %{label: "Conflict"},
          %{label: " "},
          %{title?: false, labelledby: "bad/id"}
        ] do
      assert_raise ArgumentError, fn -> render_popover(attrs) end
    end
  end

  test "conflicting globals cannot replace native semantics or implicit relationships" do
    html =
      render_popover(%{
        globals: %{
          "id" => "stolen",
          "role" => "menu",
          "popover" => "manual",
          "popovertarget" => "elsewhere",
          "popovertargetaction" => "show",
          "aria-expanded" => "true",
          "aria-details" => "false",
          "aria-labelledby" => "stolen",
          "data-placement" => "bad",
          "autofocus" => true,
          "open" => true,
          "hidden" => true,
          "data-owner" => "caller",
          "phx-click" => "caller"
        }
      })

    [surface] = Regex.run(~r/<section[^>]*>/, html)

    refute surface =~
             ~r/(stolen|role=|manual|elsewhere|data-placement="bad"|autofocus|\shidden|\sopen)/

    assert surface =~ ~s(phx-click="caller")
    [trigger] = Regex.run(~r/<button[^>]*>/, html)
    refute trigger =~ ~r/(aria-expanded|aria-details|stolen|elsewhere)/
    assert trigger =~ ~s(popovertargetaction="toggle")
  end

  test "public slot metadata and source boundaries" do
    metadata = ShadcnUI.Components.Overlays.Popover.__components__().popover
    assert Enum.find(metadata.slots, &(&1.name == :trigger)).required
    assert Enum.find(metadata.slots, &(&1.name == :inner_block)).required
    source = File.read!("lib/shadcn_ui/components/overlays/popover.ex")

    refute source =~
             ~r/(addEventListener|beforetoggle=|ontoggle=|getBoundingClientRect|ResizeObserver|setTimeout|\.focus\(|String\.to_atom|<script)/
  end

  test "globals cannot introduce a second popover on a wrapper or button" do
    html = render_popover(%{globals: %{popover: "manual"}, wrapper_globals: %{popover: "manual"}})
    assert length(Regex.scan(~r/\spopover="/, html)) == 1
    assert html =~ ~s(popover="auto")

    mixed_case =
      render_popover(%{
        globals: %{
          "ID" => "stolen",
          "ROLE" => "menu",
          "POPOVER" => "manual",
          "Aria-Labelledby" => "stolen"
        },
        wrapper_globals: %{"POPOVER" => "manual"}
      })

    refute mixed_case =~ ~r/(stolen|ROLE=|POPOVER=)/
    assert length(Regex.scan(~r/\spopover="/, mixed_case)) == 1
  end

  test "ambiguous slot counts and malformed globals fail explicitly" do
    slot = %{inner_block: fn _, _ -> "Content" end}

    base = %{
      __changed__: nil,
      id: "p",
      mode: :auto,
      action: :toggle,
      placement: :block_end,
      accessible_label: "Popover",
      labelledby: nil,
      trigger: [slot],
      title: [],
      description: [],
      close: [],
      fallback: [],
      inner_block: [slot],
      class: nil,
      trigger_class: nil,
      close_class: nil,
      rest: %{},
      trigger_rest: %{},
      surface_rest: %{},
      close_rest: %{}
    }

    for name <- [:trigger, :title, :description, :close, :fallback] do
      assert_raise ArgumentError, fn ->
        ShadcnUI.Components.Overlays.Popover.popover(Map.put(base, name, [slot, slot]))
      end
    end

    assert_raise ArgumentError, fn ->
      ShadcnUI.Components.Overlays.Popover.popover(%{base | trigger: []})
    end

    for name <- [:trigger_rest, :surface_rest, :close_rest] do
      assert_raise ArgumentError, fn ->
        ShadcnUI.Components.Overlays.Popover.popover(Map.put(base, name, %URI{}))
      end
    end
  end

  defp render_popover(attrs \\ %{}),
    do: attrs |> Fixture.render() |> Safe.to_iodata() |> IO.iodata_to_binary()
end
