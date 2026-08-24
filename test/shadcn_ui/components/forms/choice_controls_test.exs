defmodule ShadcnUI.Components.Forms.ChoiceControlsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.checkbox shadcn_ui.forms.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :field, :any, default: nil
    attr :id, :string, default: nil
    attr :name, :string, default: nil
    attr :mode, :atom, default: :boolean
    attr :value, :any, default: {:shadcn_ui, :not_provided}
    attr :checked, :boolean, default: nil
    attr :checked_value, :string, default: "enabled"
    attr :unchecked_value, :string, default: "disabled"
    attr :errors, :any, default: {:shadcn_ui, :not_provided}
    attr :error_mode, :atom, default: :used_input
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false

    def checkbox_fixture(assigns) do
      ~H"""
      <.checkbox
        field={@field}
        id={@id}
        name={@name}
        mode={@mode}
        value={@value}
        checked={@checked}
        checked_value={@checked_value}
        unchecked_value={@unchecked_value}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        form="settings"
        describedby="caller-help caller-help"
        class="consumer-checkbox"
        field_class="consumer-field"
        label_class="consumer-label"
        autofocus
        aria-label="Wrong label"
        aria-invalid="false"
        data-state="ready"
        phx-click="caller-owned"
        data-on:change="$changed()"
      >
        <:label>Enable reports</:label>
        <:help>Reports can be changed later.</:help>
      </.checkbox>
      """
    end
  end

  test "boolean mode emits an ordered same-name sentinel and native checkbox" do
    html =
      render_checkbox(
        id: "settings_reports",
        name: "settings[reports]",
        value: "enabled",
        checked_value: "enabled",
        unchecked_value: "disabled",
        checked: true,
        required: true
      )

    hidden = ~s(<input type="hidden" name="settings[reports]" value="disabled" form="settings">)
    visible = ~s(type="checkbox")
    assert html =~ hidden
    assert html =~ ~s(type="checkbox")
    assert html =~ ~s(name="settings[reports]")
    assert html =~ ~s(value="enabled")
    assert html =~ " checked"
    assert html =~ " required"
    assert position(html, hidden) < position(html, visible)
    assert length(Regex.scan(~r/name="settings\[reports\]"/, html)) == 2
  end

  test "boolean mode derives documented Phoenix truth values and permits explicit precedence" do
    for value <- [true, "true"] do
      assert render_checkbox(id: "truth", name: "truth", value: value) =~ " checked"
    end

    for value <- [false, "false", nil, "on", 1] do
      refute render_checkbox(id: "falsey", name: "falsey", value: value) =~ " checked"
    end

    assert render_checkbox(id: "override", name: "override", value: false, checked: true) =~
             " checked"

    refute render_checkbox(id: "override", name: "override", value: true, checked: false) =~
             " checked"
  end

  test "multiple mode normalizes repeated names, derives membership, and emits no sentinel" do
    field = form_field(:features, ["reports", "exports"])

    checked = render_checkbox(field: field, mode: :multiple, value: "reports")
    assert checked =~ ~s(id="settings_features")
    assert checked =~ ~s(name="settings[features][]")
    assert checked =~ ~s(value="reports")
    assert checked =~ " checked"
    refute checked =~ ~s(type="hidden")

    unchecked = render_checkbox(field: field, mode: :multiple, value: "audit")
    refute unchecked =~ " checked"
    refute unchecked =~ ~s(type="hidden")

    explicit =
      render_checkbox(
        id: "feature_exports",
        name: "features[]",
        mode: :multiple,
        value: "exports",
        checked: true
      )

    assert explicit =~ ~s(name="features[]")
    refute explicit =~ "[][]"
  end

  test "mirrors disabled and form semantics on the boolean sentinel" do
    html = render_checkbox(id: "disabled", name: "disabled", disabled: true)

    assert html =~ ~r/<input[^>]*type="hidden"[^>]* disabled[^>]*>/
    assert html =~ ~r/<input[^>]*type="checkbox"[^>]* disabled[^>]*>/
    assert length(Regex.scan(~r/form="settings"/, html)) == 2
    assert html =~ ~s(data-disabled="true")
    refute html =~ ~s(data-pending="true")

    pending = render_checkbox(id: "pending", name: "pending", pending: true)
    assert pending =~ ~s(data-pending="true")
    refute pending =~ " disabled"
  end

  test "keeps labels, help, repeated errors, and protected globals deterministic" do
    html =
      render_checkbox(
        id: "reports",
        name: "reports",
        errors: ["Choose again", "Choose again"],
        error_mode: :always
      )

    assert html =~ ~s(for="reports")
    assert html =~ ~s(id="reports-label")
    assert html =~ ~s(id="reports-help")
    assert html =~ ~s(id="reports-error-1")
    assert html =~ ~s(id="reports-error-2")
    assert html =~ ~s(aria-describedby="caller-help reports-help reports-error-1 reports-error-2")
    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-click="caller-owned")
    assert html =~ "data-on:change=\"$changed()\""
    refute html =~ "Wrong label"
    refute html =~ ~s(aria-invalid="false")
  end

  test "rejects invalid repeated values and exposes no structural or behavior API" do
    assert_raise ArgumentError, ~r/value must be a nonblank string/, fn ->
      render_checkbox(id: "feature", name: "features", mode: :multiple)
    end

    assert_raise ArgumentError, ~r/must be a list or nil/, fn ->
      render_checkbox(field: form_field(:features, "reports"), mode: :multiple, value: "reports")
    end

    metadata = ShadcnUI.Components.Forms.Checkbox.__components__().checkbox
    mode = Enum.find(metadata.attrs, &(&1.name == :mode))
    assert mode.opts[:values] == [:boolean, :multiple]

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:as, :html, :raw_html, :on_change, :toggle, :submit]
           end)

    source = File.read!("lib/shadcn_ui/components/forms/checkbox.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|role="checkbox")/
  end

  defp render_checkbox(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      mode: :boolean,
      value: {:shadcn_ui, :not_provided},
      checked: nil,
      checked_value: "enabled",
      unchecked_value: "disabled",
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.checkbox_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp form_field(key, value) do
    form = Phoenix.Component.to_form(%{Atom.to_string(key) => value}, as: "settings")
    %FormField{} = form[key]
  end

  defp position(html, pattern) do
    {index, _length} = :binary.match(html, pattern)
    index
  end
end
