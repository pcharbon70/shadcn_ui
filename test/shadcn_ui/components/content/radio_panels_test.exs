defmodule ShadcnUI.Components.Content.RadioPanelsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.content.radio_panels shadcn_ui.content.radio_not_tabs
  # covers: shadcn_ui.content.radio_fallback shadcn_ui.content.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :id, :any, default: "account-view"
    attr :name, :any, default: "account_view"
    attr :selected, :any, default: "profile"
    attr :layout, :atom, default: :vertical
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :first_key, :any, default: "profile"
    attr :first_value, :any, default: "profile"
    attr :first_label, :any, default: "Profile <unsafe>"
    attr :second_key, :any, default: "security"
    attr :second_value, :any, default: "security"
    attr :second_disabled, :any, default: true
    attr :rest, :global, default: %{}
    attr :input_rest, :map, default: %{}
    attr :panel_rest, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.radio_panels
        id={@id}
        name={@name}
        selected={@selected}
        layout={@layout}
        required={@required}
        disabled={@disabled}
        class="consumer-radio-panels"
        data-owner="application"
        {@rest}
      >
        <:legend>Account view</:legend>
        <:option
          key={@first_key}
          value={@first_value}
          label={@first_label}
          input_rest={@input_rest}
          panel_rest={@panel_rest}
        >
          <p>Profile panel <input name="display_name" /></p>
        </:option>
        <:option
          key={@second_key}
          value={@second_value}
          label="Security"
          disabled={@second_disabled}
        >
          <p>Security panel <button type="button">Review sessions</button></p>
        </:option>
      </.radio_panels>
      """
    end
  end

  test "renders one deterministic native fieldset, legend, radio group, and all panels" do
    html = render_panels()

    assert length(Regex.scan(~r/<fieldset\b/, html)) == 1
    assert length(Regex.scan(~r/<legend\b/, html)) == 1
    assert length(Regex.scan(~r/type="radio"/, html)) == 2
    assert length(Regex.scan(~r/data-shadcn-ui-radio-panel(?:\s|>)/, html)) == 2
    assert html =~ ~s(id="account-view-option-profile")
    assert html =~ ~s(for="account-view-option-profile")
    assert html =~ ~s(aria-controls="account-view-panel-profile")
    assert html =~ ~s(id="account-view-panel-profile")
    assert html =~ ~s(aria-labelledby="account-view-label-profile")
    assert html =~ "Profile &lt;unsafe&gt;"
    assert html =~ ~s(<input name="display_name")
    assert html =~ ~s(<button type="button">Review sessions</button>)
  end

  test "explicit selected value controls exactly one checked server snapshot" do
    profile = render_panels(selected: "profile")
    security = render_panels(selected: :security)

    assert length(Regex.scan(~r/\schecked(?:="")?/, profile)) == 1
    assert profile =~ ~r/value="profile"[^>]*checked/
    assert length(Regex.scan(~r/data-selected="true"/, profile)) == 1
    assert security =~ ~r/value="security"[^>]*checked/
    assert profile == render_panels(selected: "profile")
  end

  test "preserves native required, group-disabled, option-disabled, and form semantics" do
    required = render_panels(required: true, second_disabled: false)
    disabled = render_panels(disabled: true)

    assert length(Regex.scan(~r/\srequired(?:="")?/, required)) == 2
    assert length(Regex.scan(~r/name="account_view"/, required)) == 2
    assert disabled =~ ~r/<fieldset[^>]*disabled/
    assert render_panels() =~ ~r/value="security"[^>]*disabled/
  end

  test "forwards unrelated globals and protects identity, state, and relationships" do
    html =
      render_panels(
        rest: %{id: "override", role: "tablist", "data-layout": "override", title: "Preference"},
        input_rest: %{
          id: "override-input",
          name: "override-name",
          checked: false,
          tabindex: "9",
          "aria-controls": "override-panel",
          "data-owner": "input"
        },
        panel_rest: %{
          id: "override-panel",
          hidden: true,
          "aria-labelledby": "override-label",
          "data-owner": "panel"
        }
      )

    assert html =~ ~s(id="account-view")
    assert html =~ ~s(data-layout="vertical")
    assert html =~ ~s(title="Preference")
    assert html =~ ~s(data-owner="input")
    assert html =~ ~s(data-owner="panel")
    refute html =~ "override-input"
    refute html =~ "override-name"
    refute html =~ "override-panel"
    refute html =~ ~s(tabindex="9")
    refute html =~ ~s(role="tablist")
    refute html =~ " hidden"
  end

  test "rejects malformed, duplicate, unmatched, and role-overstating inputs" do
    for overrides <- [
          [id: nil],
          [id: " "],
          [name: nil],
          [name: " "],
          [selected: nil],
          [selected: %{}],
          [selected: "missing"],
          [first_key: "bad/key"],
          [first_key: :profile],
          [first_key: "same", second_key: "same"],
          [first_value: "same", second_value: "same"],
          [first_label: " "],
          [second_disabled: :yes],
          [input_rest: %{role: "tab"}],
          [panel_rest: %{role: "tabpanel"}]
        ],
        do: assert_raise(ArgumentError, fn -> render_panels(overrides) end)

    assert_raise KeyError, fn -> render_panels(layout: :tabs) end
  end

  test "publishes an honest closed API with required legend and option content" do
    metadata = ShadcnUI.Components.Content.RadioPanels.__components__().radio_panels

    assert attr_values(metadata, :layout) == [:vertical, :horizontal]
    assert Enum.find(metadata.attrs, &(&1.name == :id)).required
    assert Enum.find(metadata.attrs, &(&1.name == :name)).required
    assert Enum.find(metadata.attrs, &(&1.name == :selected)).required
    assert Enum.find(metadata.slots, &(&1.name == :legend)).required
    assert Enum.find(metadata.slots, &(&1.name == :option)).required
  end

  test "capability-gated CSS hides only unselected panels and fallback keeps all content" do
    source = File.read!("assets/shadcn_ui.css")
    css = File.read!(ShadcnUI.stylesheet_path())
    readme = File.read!("README.md")

    assert source =~ "@supports selector(:has(*))"
    assert source =~ "[data-shadcn-ui-radio-panel-option]:has(> div > input:checked)"
    assert source =~ "display: none"
    assert css =~ "data-shadcn-ui-radio-panel"
    assert readme =~ "every panel remains visible"
    assert readme =~ "not a Tab Group"
  end

  test "renders no tab widget, client state, navigation, or script contract" do
    html = render_panels()
    source = File.read!("lib/shadcn_ui/components/content/radio_panels.ex")

    refute html =~ ~r/role="(?:tablist|tab|tabpanel)"/
    refute html =~ "tabindex="
    refute html =~ ~r/(phx-keydown|data-on-keydown|aria-selected)/

    refute source =~
             ~r/(handle_event|push_event|JS\.|addEventListener|keydown|history\.|location\.|request_path|String\.to_atom|binary_to_atom|<script|javascript:)/i
  end

  defp render_panels(overrides \\ []) do
    %{
      id: "account-view",
      name: "account_view",
      selected: "profile",
      layout: :vertical,
      required: false,
      disabled: false,
      first_key: "profile",
      first_value: "profile",
      first_label: "Profile <unsafe>",
      second_key: "security",
      second_value: "security",
      second_disabled: true,
      rest: %{},
      input_rest: %{},
      panel_rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp attr_values(metadata, name),
    do: Enum.find(metadata.attrs, &(&1.name == name)).opts[:values]
end
