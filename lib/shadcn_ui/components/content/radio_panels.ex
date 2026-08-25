defmodule ShadcnUI.Components.Content.RadioPanels do
  use ShadcnUI.Component

  @moduledoc """
  Native radio selection paired with caller-owned panel content.

  Radio Panels is deliberately not a tab widget. It renders one fieldset and
  native radio group, submits an ordinary scalar form value, and exposes no tab
  roles, roving tabindex, focus management, history, or package-owned state.
  Capability-gated CSS may reduce panel density; without it every panel remains
  visible in source order.
  """

  @key_pattern ~r/^[A-Za-z0-9][A-Za-z0-9_.-]*$/u
  @layout_classes %{
    vertical: "sui:grid sui:gap-3",
    horizontal: "sui:grid sui:gap-3 sui:md:grid-cols-2"
  }

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :selected, :any, required: true
  attr :layout, :atom, values: [:vertical, :horizontal], default: :vertical
  attr :required, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :form, :string, default: nil
  attr :class, :any, default: nil
  attr :legend_class, :any, default: nil
  attr :option_class, :any, default: nil
  attr :rest, :global

  slot :legend, required: true

  slot :option, required: true do
    attr :key, :string, required: true
    attr :value, :string, required: true
    attr :label, :string, required: true
    attr :disabled, :boolean
    attr :class, :any
    attr :input_rest, :map
    attr :panel_rest, :map
  end

  @doc "Renders a native radio group and deterministically related panel content."
  def radio_panels(assigns) do
    id = require_nonblank!(assigns.id, :id)
    name = require_nonblank!(assigns.name, :name)
    selected = validate_selected!(assigns.selected)
    options = normalize_options!(assigns.option, id, selected)

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:name, name)
      |> assign(:selected, selected)
      |> assign(:options, options)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :id,
          :role,
          :disabled,
          :form,
          :data_shadcn_ui,
          :data_shadcn_ui_radio_panels,
          :data_layout
        ])
      )
      |> assign(
        :classes,
        class_names([
          "sui:min-w-0 sui:rounded-lg sui:border sui:border-border sui:p-4",
          "sui:bg-background sui:text-foreground",
          assigns.disabled && "sui:opacity-60",
          assigns.class
        ])
      )
      |> assign(
        :options_classes,
        class_names([
          "sui:mt-3",
          Map.fetch!(@layout_classes, assigns.layout)
        ])
      )

    ~H"""
    <fieldset
      {@safe_rest}
      id={@id}
      disabled={@disabled}
      form={@form}
      data-shadcn-ui
      data-shadcn-ui-radio-panels
      data-layout={@layout}
      class={@classes}
    >
      <legend
        id={"#{@id}-legend"}
        class={
          class_names(["sui:max-w-full sui:break-words sui:text-sm sui:font-semibold", @legend_class])
        }
      >
        {render_slot(@legend)}
      </legend>
      <div data-shadcn-ui-radio-panels-options class={@options_classes}>
        <div
          :for={option <- @options}
          data-shadcn-ui-radio-panel-option
          data-option-key={option.key}
          data-selected={option.selected && "true"}
          class={
            class_names([
              "sui:min-w-0 sui:rounded-md sui:border sui:border-border",
              @option_class,
              option.class
            ])
          }
        >
          <div class="sui:flex sui:min-w-0 sui:items-start sui:gap-2 sui:p-3">
            <input
              {option.input_rest}
              data-shadcn-ui
              data-shadcn-ui-radio-panel-control
              type="radio"
              id={option.input_id}
              name={@name}
              value={option.value}
              checked={option.selected}
              disabled={option.disabled}
              required={@required}
              form={@form}
              aria-controls={option.panel_id}
              class="sui:mt-0.5 sui:size-4 sui:shrink-0 sui:accent-primary"
            />
            <label
              id={option.label_id}
              for={option.input_id}
              data-shadcn-ui-radio-panel-label
              class="sui:min-w-0 sui:cursor-pointer sui:break-words sui:text-sm sui:font-medium"
            >
              {option.label}
            </label>
          </div>
          <div
            {option.panel_rest}
            id={option.panel_id}
            aria-labelledby={option.label_id}
            data-shadcn-ui-radio-panel
            class="sui:min-w-0 sui:border-t sui:border-border sui:p-3 sui:text-sm"
          >
            {render_slot(option)}
          </div>
        </div>
      </div>
    </fieldset>
    """
  end

  defp normalize_options!(options, id, selected) when is_list(options) and options != [] do
    options = Enum.map(options, &normalize_option!(&1, id, selected))
    ensure_unique!(options, :key)
    ensure_unique!(options, :value)

    if Enum.any?(options, & &1.selected),
      do: options,
      else: raise(ArgumentError, "Radio Panels selected value must match one option value")
  end

  defp normalize_options!([], _id, _selected),
    do: raise(ArgumentError, "Radio Panels requires at least one option")

  defp normalize_options!(other, _id, _selected),
    do:
      raise(ArgumentError, "Radio Panels options must be a nonempty list, got: #{inspect(other)}")

  defp normalize_option!(option, id, selected) when is_map(option) do
    key = option |> fetch_option!(:key) |> validate_key!()
    value = option |> fetch_option!(:value) |> require_nonblank!(:value)
    label = option |> fetch_option!(:label) |> require_nonblank!(:label)
    input_rest = option |> Map.get(:input_rest, %{}) |> validate_globals!(:input_rest)
    panel_rest = option |> Map.get(:panel_rest, %{}) |> validate_globals!(:panel_rest)
    reject_role!(input_rest, :input_rest)
    reject_role!(panel_rest, :panel_rest)

    %{
      inner_block: fetch_option!(option, :inner_block),
      key: key,
      value: value,
      label: label,
      disabled: validate_boolean!(Map.get(option, :disabled, false), :disabled),
      selected: same_value?(selected, value),
      class: Map.get(option, :class),
      input_id: "#{id}-option-#{key}",
      label_id: "#{id}-label-#{key}",
      panel_id: "#{id}-panel-#{key}",
      input_rest:
        protect_globals(input_rest, [
          :id,
          :name,
          :value,
          :type,
          :checked,
          :disabled,
          :required,
          :form,
          :tabindex,
          :aria_controls,
          :data_shadcn_ui,
          :data_shadcn_ui_radio_panel_control
        ]),
      panel_rest:
        protect_globals(panel_rest, [
          :id,
          :aria_labelledby,
          :hidden,
          :data_shadcn_ui_radio_panel
        ])
    }
  end

  defp normalize_option!(option, _id, _selected),
    do: raise(ArgumentError, "Radio Panels options must be slot entries, got: #{inspect(option)}")

  defp fetch_option!(option, field) do
    case Map.fetch(option, field) do
      {:ok, value} ->
        value

      :error ->
        raise ArgumentError, "each Radio Panels option requires key, value, label, and content"
    end
  end

  defp validate_key!(key) when is_binary(key) do
    key = String.trim(key)

    if Regex.match?(@key_pattern, key),
      do: key,
      else: raise(ArgumentError, "Radio Panels option key must be a stable URL-safe string")
  end

  defp validate_key!(key),
    do:
      raise(
        ArgumentError,
        "Radio Panels option key must be a stable string, got: #{inspect(key)}"
      )

  defp require_nonblank!(value, field) when is_binary(value) do
    value = String.trim(value)
    if value == "", do: raise(ArgumentError, "#{field} must be a nonblank string"), else: value
  end

  defp require_nonblank!(value, field),
    do: raise(ArgumentError, "#{field} must be a nonblank string, got: #{inspect(value)}")

  defp validate_selected!(value)
       when is_binary(value) or is_atom(value) or is_integer(value) or is_float(value),
       do: value

  defp validate_selected!(value),
    do: raise(ArgumentError, "selected must be a scalar value, got: #{inspect(value)}")

  defp validate_boolean!(value, _field) when is_boolean(value), do: value

  defp validate_boolean!(value, field),
    do: raise(ArgumentError, "#{field} must be boolean, got: #{inspect(value)}")

  defp validate_globals!(value, _field) when is_map(value) and not is_struct(value), do: value

  defp validate_globals!(value, field),
    do: raise(ArgumentError, "#{field} must be a plain map, got: #{inspect(value)}")

  defp reject_role!(globals, field) do
    if Map.has_key?(globals, :role) or Map.has_key?(globals, "role"),
      do: raise(ArgumentError, "Radio Panels #{field} does not accept a caller role")
  end

  defp ensure_unique!(options, field) do
    values = Enum.map(options, &Map.fetch!(&1, field))

    if length(values) != length(Enum.uniq(values)),
      do: raise(ArgumentError, "Radio Panels option #{field} values must be unique")
  end

  defp same_value?(selected, value), do: to_string(selected) == value
end
