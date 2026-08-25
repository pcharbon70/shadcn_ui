defmodule ShadcnUI.Components.Forms.Select do
  use ShadcnUI.Component

  @moduledoc false

  alias ShadcnUI.Components.Forms.FormContract
  alias ShadcnUI.Components.Forms.SelectOptions
  import ShadcnUI.Components.Forms.Field, only: [field: 1]

  @size_classes %{
    small: "sui:min-h-8 sui:px-2 sui:py-1 sui:text-xs",
    default: "sui:min-h-9 sui:px-3 sui:py-2 sui:text-sm",
    large: "sui:min-h-10 sui:px-3 sui:py-2 sui:text-base"
  }

  def render(assigns, presentation) when presentation in [:native, :enhanced] do
    normalized =
      FormContract.normalize!(
        field: assigns.field,
        id: assigns.id,
        name: assigns.name,
        value: assigns.value,
        errors: assigns.errors,
        error_mode: assigns.error_mode,
        used: assigns.used,
        translate_error: assigns.translate_error,
        pending: assigns.pending
      )

    normalized = %{normalized | name: repeated_name(normalized.name, assigns.multiple)}
    options = SelectOptions.normalize!(assigns.options, normalized.id)
    selected = SelectOptions.selected!(normalized.value, assigns.multiple)

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(:options, options)
      |> assign(:selected, selected)
      |> assign(:presentation, presentation)
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :value,
          :aria_label,
          :required,
          :disabled,
          :multiple,
          :form,
          :data_pending,
          :data_shadcn_ui_select,
          :data_shadcn_ui_enhanced_select
        ])
      )
      |> assign(
        :classes,
        class_names([
          "sui:flex sui:w-full sui:min-w-0 sui:rounded-md sui:border sui:border-input",
          "sui:bg-background sui:text-foreground sui:shadow-xs sui:outline-none",
          "sui:focus-visible:border-ring sui:focus-visible:ring-2 sui:focus-visible:ring-ring",
          "sui:focus-visible:ring-offset-2 sui:focus-visible:ring-offset-background",
          "sui:disabled:cursor-not-allowed sui:disabled:opacity-50",
          normalized.errors_visible? && "sui:border-destructive sui:ring-destructive/20",
          normalized.pending? && "sui:cursor-progress",
          assigns.multiple && "sui:min-h-24 sui:py-2",
          Map.fetch!(@size_classes, assigns.size),
          assigns.class
        ])
      )

    ~H"""
    <.field
      id={@normalized.id}
      name={@normalized.name}
      value={@normalized.value}
      errors={@normalized.errors}
      error_mode={:always}
      pending={@normalized.pending?}
      required={@required}
      optional={@optional}
      disabled={@disabled}
      describedby={@describedby}
      class={@field_class}
    >
      <:label>{render_slot(@label)}</:label>
      <:control :let={control}>
        <select
          {@safe_rest}
          data-shadcn-ui
          data-shadcn-ui-select
          data-shadcn-ui-enhanced-select={@presentation == :enhanced && "true"}
          data-pending={@normalized.pending? && "true"}
          id={control.id}
          name={control.name}
          required={@required}
          disabled={@disabled}
          multiple={@multiple}
          form={@form}
          aria-describedby={control.aria_describedby}
          aria-invalid={control.aria_invalid}
          class={@classes}
        >
          <button :if={@presentation == :enhanced and not @multiple} data-shadcn-ui-select-button>
            <selectedcontent></selectedcontent>
          </button>
          <%= for item <- @options do %>
            <option
              :if={item.kind == :option}
              data-shadcn-ui
              data-shadcn-ui-select-option
              id={item.id}
              value={item.value}
              selected={SelectOptions.selected?(@selected, item.value)}
              disabled={item.disabled}
            >
              {item.label}
            </option>
            <optgroup
              :if={item.kind == :group}
              data-shadcn-ui
              data-shadcn-ui-select-group
              id={item.id}
              label={item.label}
              disabled={item.disabled}
            >
              <option
                :for={option <- Map.get(item, :options, [])}
                data-shadcn-ui
                data-shadcn-ui-select-option
                id={option.id}
                value={option.value}
                selected={SelectOptions.selected?(@selected, option.value)}
                disabled={option.disabled}
              >
                {option.label}
              </option>
            </optgroup>
          <% end %>
        </select>
      </:control>
      <:help :if={@help != []}>{render_slot(@help)}</:help>
    </.field>
    """
  end

  defp repeated_name(name, true) do
    if String.ends_with?(name, "[]"), do: name, else: name <> "[]"
  end

  defp repeated_name(name, false) do
    if String.ends_with?(name, "[]") do
      raise ArgumentError, "single select name must not use repeated-value [] notation"
    end

    name
  end
end
