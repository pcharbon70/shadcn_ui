defmodule ShadcnUI.Components.Overlays.DropdownActionsTest do
  use ExUnit.Case, async: false
  alias Phoenix.HTML.Safe
  alias ShadcnUI.Components.Overlays.DropdownActions

  # covers: shadcn_ui.popover.dropdown_actions shadcn_ui.popover.not_menu
  # covers: shadcn_ui.popover.protected_semantics shadcn_ui.popover.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    def render(assigns) do
      ~H"""
      <.dropdown_actions id="record-actions" accessible_label="Record actions" data-owner="caller">
        <:trigger>Actions</:trigger>
        <:group_label key="record" label="Record <tools>" />
        <:action
          key="view"
          kind={:link}
          label="View <record>"
          destination="/records/42"
          target="_blank"
          rel="noopener"
          current={:page}
          group="record"
        />
        <:action
          key="download"
          kind={:link}
          label="Download"
          destination="/records/42.csv"
          download="record.csv"
          group="record"
        />
        <:action
          key="save"
          label="Save"
          type="submit"
          name="intent"
          value="save"
          form="record-form"
          rest={%{"phx-click" => "save", "data-on-click" => "caller"}}
        />
        <:action key="pending" label="Pending" disabled />
        <:separator after_key="save" />
        <:action key="delete" label="Delete" destructive />
        <:separator after_key="pending" decorative />
        <:fallback><a href="/records/42/actions">All actions</a></:fallback>
      </.dropdown_actions>
      """
    end
  end

  test "composes auto Popover with native links, buttons, stable groups and separators" do
    html = render_fixture()
    assert html =~ ~s(popover="auto")
    assert html =~ ~s(id="record-actions-action-view")
    assert html =~ ~s(aria-describedby="record-actions-group-record")
    assert html =~ "Record &lt;tools&gt;"
    assert html =~ "View &lt;record&gt;"
    assert html =~ ~s(href="/records/42" target="_blank" rel="noopener")
    assert html =~ ~s(aria-current="page")
    assert html =~ ~s(download="record.csv")
    assert html =~ ~s(type="submit" name="intent" value="save" form="record-form")
    assert html =~ ~s(phx-click="save")
    assert html =~ ~s(data-on-click="caller")
    assert html =~ ~r/id="record-actions-action-pending"[^>]*disabled/
    assert html =~ ~s(data-destructive="true")
    assert html =~ ~r/<hr[^>]*data-shadcn-ui-dropdown-separator/
    assert html =~ ~r/<div aria-hidden="true" data-shadcn-ui-dropdown-separator/
    assert length(Regex.scan(~r/id="record-actions-group-record"/, html)) == 1
    assert render_fixture() == html
  end

  test "retains action-slot source order without menu roles or runtime handlers" do
    html = render_fixture()

    offsets =
      Enum.map(~w(view download save pending delete), fn key ->
        {offset, _} = :binary.match(html, ~s(id="record-actions-action-#{key}"))
        offset
      end)

    assert offsets == Enum.sort(offsets)

    refute html =~
             ~r/(role="(?:menu|menubar|menuitem)"|tabindex=|onkeydown|aria-haspopup|<script)/

    source = File.read!("lib/shadcn_ui/components/overlays/dropdown_actions.ex")

    refute source =~
             ~r/(addEventListener|\.focus\(|ArrowDown|ArrowUp|setTimeout|handle_event|String\.to_atom|hidePopover\()/
  end

  test "rejects nested labels, duplicate keys and invalid groups or separators" do
    action = %{key: "save", label: "Save"}

    for attrs <- [
          %{action: []},
          %{action: [action, action]},
          %{action: [%{action | label: " "}]},
          %{action: [Map.put(action, :inner_block, fn _, _ -> "<button>bad</button>" end)]},
          %{action: [Map.put(action, :group, "missing")]},
          %{group_label: [%{key: "unused", label: "Unused"}]},
          %{separator: [%{after_key: "unknown"}]},
          %{separator: [%{after_key: "save"}, %{after_key: "save"}]},
          %{group_label: [%{key: "g", label: "A"}, %{key: "g", label: "B"}]},
          %{
            group_label: [%{key: "g", label: "Group"}],
            action: [
              %{key: "a", label: "A", group: "g"},
              %{key: "b", label: "B"},
              %{key: "c", label: "C", group: "g"}
            ]
          }
        ] do
      assert_raise ArgumentError, fn -> render_direct(attrs) end
    end
  end

  test "rejects invalid URLs, contradictory native fields and protected globals" do
    for destination <- [
          "",
          "javascript:alert(1)",
          "data:text/html,bad",
          "//evil.example",
          "https:/missing-host",
          "bad\\path",
          "bad\npath",
          "java%0ascript:bad"
        ] do
      assert_raise ArgumentError, fn ->
        render_direct(%{
          action: [%{key: "link", label: "Link", kind: :link, destination: destination}]
        })
      end
    end

    for destination <- [
          "/records",
          "records/42",
          "#details",
          "https://example.test/records",
          "mailto:user@example.test",
          "tel:123"
        ] do
      assert render_direct(%{
               action: [%{key: "link", label: "Link", kind: :link, destination: destination}]
             }) =~ "href="
    end

    for action <- [
          %{key: "a", label: "A", type: "invalid"},
          %{key: "a", label: "A", kind: :menu},
          %{key: "a", label: "A", destination: "/wrong"},
          %{key: "a", label: "A", kind: :link, destination: "/valid", disabled: true},
          %{key: "a", label: "A", disabled: "false"},
          %{key: "a", label: "A", rest: %{role: "menuitem"}},
          %{key: "a", label: "A", rest: %{"aria_current" => "page"}},
          %{key: "a", label: "A", rest: %{popovertarget: "submenu"}},
          %{key: "a", label: "A", rest: %{command: "--delete"}},
          %{key: "bad key", label: "A"}
        ] do
      assert_raise ArgumentError, fn -> render_direct(%{action: [action]}) end
    end
  end

  defp render_fixture, do: Fixture.render(%{}) |> Safe.to_iodata() |> IO.iodata_to_binary()

  defp render_direct(attrs) do
    Map.merge(
      %{
        __changed__: nil,
        id: "test",
        accessible_label: "Actions",
        placement: :block_end,
        class: nil,
        trigger_class: nil,
        rest: %{},
        trigger_rest: %{},
        surface_rest: %{},
        trigger: [%{__slot__: :trigger, inner_block: fn _, _ -> "Actions" end}],
        fallback: [],
        action: [%{key: "save", label: "Save"}],
        group_label: [],
        separator: []
      },
      attrs
    )
    |> DropdownActions.dropdown_actions()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
