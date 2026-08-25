defmodule ShadcnUI.Components.Forms.Slider do
  use ShadcnUI.Component

  @moduledoc """
  Native range input composed through the shared form contract.

  Slider preserves the browser's value normalization, keyboard and pointer
  operation, constraint validation, reset, and form submission. The caller
  owns domain parsing, value display updates, validation, and request lifecycle.
  """

  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.Field, only: [field: 1]

  @not_provided {:shadcn_ui, :not_provided}

  attr :field, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :any, default: @not_provided
  attr :errors, :any, default: @not_provided
  attr :error_mode, :atom, values: [:used_input, :always, :hidden], default: :used_input
  attr :used, :boolean, default: false
  attr :translate_error, :any, default: nil
  attr :pending, :boolean, default: false
  attr :required, :boolean, default: false
  attr :optional, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :step, :any, default: nil
  attr :form, :string, default: nil
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :field_class, :any, default: nil
  attr :rest, :global, include: ~w(autofocus list)

  slot :label, required: true
  slot :help
  slot :value_description

  @doc "Renders one native range input with deterministic field relationships."
  def slider(assigns) do
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

    value_description_id =
      if assigns.value_description == [], do: nil, else: "#{normalized.id}-value-description"

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(:value_description_id, value_description_id)
      |> assign(:field_describedby, [assigns.describedby, value_description_id])
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :value,
          :aria_label,
          :required,
          :disabled,
          :min,
          :max,
          :step,
          :form,
          :data_pending
        ])
      )
      |> assign(
        :classes,
        class_names([
          "shadcn-ui-slider-control",
          "sui:block sui:w-full sui:min-w-0 sui:accent-primary sui:outline-none",
          "sui:focus-visible:ring-2 sui:focus-visible:ring-ring",
          "sui:focus-visible:ring-offset-2 sui:focus-visible:ring-offset-background",
          normalized.errors_visible? && "shadcn-ui-slider-invalid",
          normalized.pending? && "sui:cursor-progress",
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
      describedby={@field_describedby}
      class={@field_class}
    >
      <:label>{render_slot(@label)}</:label>
      <:control :let={control}>
        <input
          {@safe_rest}
          data-shadcn-ui
          data-shadcn-ui-slider
          data-pending={@normalized.pending? && "true"}
          id={control.id}
          name={control.name}
          type="range"
          value={control.value}
          required={@required}
          disabled={@disabled}
          min={@min}
          max={@max}
          step={@step}
          form={@form}
          aria-describedby={control.aria_describedby}
          aria-invalid={control.aria_invalid}
          class={@classes}
        />
        <p
          :if={@value_description != []}
          id={@value_description_id}
          data-shadcn-ui
          data-shadcn-ui-slider-value-description
          class="sui:mt-2 sui:text-sm sui:text-muted-foreground"
        >
          {render_slot(@value_description)}
        </p>
      </:control>
      <:help :if={@help != []}>{render_slot(@help)}</:help>
    </.field>
    """
  end
end
