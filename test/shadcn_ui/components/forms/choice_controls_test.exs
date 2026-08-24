defmodule ShadcnUI.Components.Forms.ChoiceControlsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.checkbox shadcn_ui.forms.radio_group shadcn_ui.forms.switch
  # covers: shadcn_ui.forms.shared_contract

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

    attr :field, :any, default: nil
    attr :id, :string, default: nil
    attr :name, :string, default: nil
    attr :selected, :any, default: {:shadcn_ui, :not_provided}
    attr :options, :list, required: true
    attr :errors, :any, default: {:shadcn_ui, :not_provided}
    attr :error_mode, :atom, default: :used_input
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :layout, :atom, default: :vertical

    def radio_fixture(assigns) do
      ~H"""
      <.radio_group
        field={@field}
        id={@id}
        name={@name}
        selected={@selected}
        options={@options}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        layout={@layout}
        form="settings"
        describedby="caller-help caller-help"
        class="consumer-group"
        options_class="consumer-options"
        option_class="consumer-option"
        legend_class="consumer-legend"
        aria-label="Wrong legend"
        aria-labelledby="wrong-label"
        aria-invalid="false"
        data-state="ready"
        phx-change="caller-owned"
      >
        <:legend>Preferred contact method</:legend>
        <:help>Choose one available method.</:help>
      </.radio_group>
      """
    end

    attr :field, :any, default: nil
    attr :id, :string, default: nil
    attr :name, :string, default: nil
    attr :value, :any, default: {:shadcn_ui, :not_provided}
    attr :checked, :boolean, default: nil
    attr :errors, :any, default: {:shadcn_ui, :not_provided}
    attr :error_mode, :atom, default: :used_input
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :label_visibility, :atom, default: :visible
    attr :accessible_label, :string, default: nil

    def switch_fixture(assigns) do
      ~H"""
      <.switch
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        checked={@checked}
        checked_value="enabled"
        unchecked_value="disabled"
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        form="settings"
        label_visibility={@label_visibility}
        accessible_label={@accessible_label}
        describedby="caller-help"
        class="consumer-switch"
        field_class="consumer-field"
        label_class="consumer-label"
        autofocus
        aria-invalid="false"
        data-state="ready"
        phx-click="caller-owned"
      >
        <:label>Email notifications</:label>
        <:help>Receive operational updates.</:help>
      </.switch>
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

  test "radio group renders one native fieldset, legend, and stable native options" do
    html =
      render_radio(
        id: "settings_contact",
        name: "settings[contact]",
        selected: "phone",
        options: radio_options(),
        required: true
      )

    assert html =~ ~s(<fieldset)
    assert html =~ ~s(id="settings_contact")
    assert html =~ ~s(<legend id="settings_contact-label")
    assert html =~ "Preferred contact method"
    assert length(Regex.scan(~r/type="radio"/, html)) == 3
    assert length(Regex.scan(~r/name="settings\[contact\]"/, html)) == 3
    assert length(Regex.scan(~r/ required/, html)) >= 3
    assert length(Regex.scan(~r/ checked/, html)) == 1
    assert html =~ ~s(value="phone" checked)

    ids = Regex.scan(~r/id="(settings_contact-option-[^"]+)"/, html, capture: :all_but_first)
    assert length(ids) == 3
    assert length(Enum.uniq(ids)) == 3

    for [id] <- ids do
      assert html =~ ~s(for="#{id}")
    end
  end

  test "radio group derives FormField selection with explicit precedence and stable reorder IDs" do
    field = form_field(:contact, "email")
    derived = render_radio(field: field, options: radio_options())
    assert derived =~ ~s(id="settings_contact")
    assert derived =~ ~s(name="settings[contact]")
    assert derived =~ ~s(value="email" checked)

    explicit = render_radio(field: field, selected: "sms", options: radio_options())
    assert explicit =~ ~s(value="sms" checked)
    refute explicit =~ ~s(value="email" checked)

    reordered = render_radio(field: field, options: Enum.reverse(radio_options()))

    original_ids = Regex.scan(~r/id="(settings_contact-option-[^"]+)"/, derived)
    reordered_ids = Regex.scan(~r/id="(settings_contact-option-[^"]+)"/, reordered)
    assert Enum.sort(original_ids) == Enum.sort(reordered_ids)
  end

  test "radio group supports group and option disabled states without readonly semantics" do
    html =
      render_radio(
        id: "contact",
        name: "contact",
        options: radio_options(),
        disabled: true
      )

    assert html =~ ~r/<fieldset[^>]* disabled[^>]*>/
    assert html =~ ~s(value="sms" disabled)
    refute html =~ " readonly"

    enabled = render_radio(id: "contact", name: "contact", options: radio_options())
    refute enabled =~ ~r/<fieldset[^>]* disabled[^>]*>/
    assert length(Regex.scan(~r/type="radio"[^>]* disabled/, enabled)) == 1
  end

  test "radio group connects shared descriptions and protects fieldset semantics" do
    html =
      render_radio(
        id: "contact",
        name: "contact",
        options: radio_options(),
        errors: ["Choose a method", "Choose a method"],
        error_mode: :always,
        pending: true
      )

    assert html =~ ~s(aria-labelledby="contact-label")
    assert html =~ ~s(aria-describedby="caller-help contact-help contact-error-1 contact-error-2")
    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~s(data-pending="true")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-change="caller-owned")
    refute html =~ "Wrong legend"
    refute html =~ "wrong-label"
    refute html =~ ~s(aria-invalid="false")
    refute html =~ ~s(role="radiogroup")
  end

  test "radio group rejects invalid, duplicate, or executable option structures" do
    invalid_options = [
      [],
      [%{key: "email", value: "email"}],
      [%{key: "email", value: "", label: "Email"}],
      [%{key: %{request: true}, value: "email", label: "Email"}],
      [%{key: "email", value: "email", label: "Email", execute: fn -> :bad end}],
      [
        %{key: "duplicate", value: "email", label: "Email"},
        %{key: "duplicate", value: "phone", label: "Phone"}
      ],
      [
        %{key: "email", value: "same", label: "Email"},
        %{key: "phone", value: "same", label: "Phone"}
      ]
    ]

    for options <- invalid_options do
      assert_raise ArgumentError, fn ->
        render_radio(id: "contact", name: "contact", options: options)
      end
    end

    assert_raise ArgumentError, ~r/scalar or nil/, fn ->
      render_radio(id: "contact", name: "contact", selected: ["email"], options: radio_options())
    end

    metadata = ShadcnUI.Components.Forms.RadioGroup.__components__().radio_group
    refute Enum.any?(metadata.attrs, &(&1.name in [:readonly, :on_change, :select, :html]))

    source = File.read!("lib/shadcn_ui/components/forms/radio_group.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|role="radio")/
  end

  test "switch reuses one native boolean checkbox and sentinel submission model" do
    html =
      render_switch(
        id: "settings_notifications",
        name: "settings[notifications]",
        value: "enabled",
        checked: true,
        required: true
      )

    assert html =~ ~s(data-shadcn-ui-switch)
    assert html =~ ~s(type="hidden")
    assert html =~ ~s(type="checkbox")
    assert length(Regex.scan(~r/name="settings\[notifications\]"/, html)) == 2
    assert html =~ ~s(value="disabled")
    assert html =~ ~s(value="enabled" checked)
    assert html =~ "shadcn-ui-switch-control"
    assert html =~ "Email notifications"
    assert html =~ ~s(for="settings_notifications")
    refute html =~ ~s(role="switch")
  end

  test "switch FormField and explicit states match Checkbox relationships" do
    field = form_field(:notifications, true)
    derived = render_switch(field: field, errors: ["Review setting"], error_mode: :always)

    assert derived =~ ~s(id="settings_notifications")
    assert derived =~ ~s(name="settings[notifications]")
    assert derived =~ " checked"

    assert derived =~
             ~s(aria-describedby="caller-help settings_notifications-help settings_notifications-error-1")

    assert derived =~ ~s(aria-invalid="true")

    explicit =
      render_switch(
        id: "alerts",
        name: "alerts",
        checked: false,
        disabled: true,
        pending: true
      )

    refute explicit =~ " checked"
    assert explicit =~ ~r/<input[^>]*type="hidden"[^>]* disabled[^>]*>/
    assert explicit =~ ~r/<input[^>]*type="checkbox"[^>]* disabled[^>]*>/
    assert explicit =~ ~s(data-pending="true")
  end

  test "switch requires a nonblank explicit accessible label only when visually hidden" do
    visible = render_switch(id: "visible", name: "visible")
    assert visible =~ "Email notifications"
    refute visible =~ "sui:sr-only"

    hidden =
      render_switch(
        id: "hidden",
        name: "hidden",
        label_visibility: :hidden,
        accessible_label: "Enable email notifications"
      )

    assert hidden =~ "Enable email notifications"
    assert hidden =~ "sui:sr-only"
    refute hidden =~ ">Email notifications<"

    for label <- [nil, "", "   "] do
      assert_raise ArgumentError, ~r/accessible_label must be a nonblank string/, fn ->
        render_switch(
          id: "unnamed",
          name: "unnamed",
          label_visibility: :hidden,
          accessible_label: label
        )
      end
    end
  end

  test "switch CSS provides track, thumb, focus, reduced-motion, and forced-color fallback" do
    css = File.read!("assets/shadcn_ui.css")

    assert css =~ "[data-shadcn-ui-switch] .shadcn-ui-switch-control"
    assert css =~ ".shadcn-ui-switch-control::before"
    assert css =~ ".shadcn-ui-switch-control:checked::before"
    assert css =~ "transform: translateX(1rem)"
    assert css =~ ".shadcn-ui-switch-control:focus-visible"
    assert css =~ "outline: 2px solid var(--shadcn-ui-ring)"
    assert css =~ "@media (prefers-reduced-motion: reduce)"
    assert css =~ "@media (forced-colors: active)"
    assert css =~ "appearance: auto"

    metadata = ShadcnUI.Components.Forms.Switch.__components__().switch

    refute Enum.any?(
             metadata.attrs,
             &(&1.name in [:mode, :on_toggle, :toggle, :transition_state])
           )

    source = File.read!("lib/shadcn_ui/components/forms/switch.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|role="switch")/
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

  defp render_radio(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      selected: {:shadcn_ui, :not_provided},
      options: radio_options(),
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      layout: :vertical,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.radio_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render_switch(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      checked: nil,
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      label_visibility: :visible,
      accessible_label: nil,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.switch_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp radio_options do
    [
      %{key: "email-key", value: "email", label: "Email"},
      %{key: :phone_key, value: "phone", label: "Phone"},
      %{key: 3, value: "sms", label: "SMS", disabled: true}
    ]
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
