defmodule ShadcnUI.Components.Forms.Input do
  use ShadcnUI.Component

  @moduledoc """
  Native text-like input composed through the shared form contract.

  Input keeps browser value, focus, autofill, constraint validation, and form
  submission behavior intact. The caller owns parsing, validation, pending
  lifecycle, duplicate prevention, persistence, authorization, and outcomes.
  """

  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.Field, only: [field: 1]

  @not_provided {:shadcn_ui, :not_provided}
  @types ~w(text email password search tel url number date datetime-local month week time)
  @inputmodes ~w(none text decimal numeric tel search email url)
  @text_constraint_types ~w(text email password search tel url)
  @range_constraint_types ~w(number date datetime-local month week time)

  @size_classes %{
    small: "sui:min-h-8 sui:px-2 sui:py-1 sui:text-xs",
    default: "sui:min-h-9 sui:px-3 sui:py-2 sui:text-sm",
    large: "sui:min-h-10 sui:px-3 sui:py-2 sui:text-base"
  }

  attr :type, :string, values: @types, default: "text"
  attr :size, :atom, values: [:small, :default, :large], default: :default
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
  attr :readonly, :boolean, default: false
  attr :autocomplete, :string, default: nil
  attr :inputmode, :string, values: [nil | @inputmodes], default: nil
  attr :placeholder, :string, default: nil
  attr :minlength, :integer, default: nil
  attr :maxlength, :integer, default: nil
  attr :pattern, :string, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :step, :any, default: nil
  attr :form, :string, default: nil
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :field_class, :any, default: nil
  attr :rest, :global, include: ~w(autocapitalize autofocus list spellcheck)

  slot :label, required: true
  slot :help
  slot :leading
  slot :trailing

  @doc "Renders one native text-like input with deterministic field relationships."
  def input(assigns) do
    validate_type!(assigns.type)
    validate_constraints!(assigns)
    size_classes = Map.fetch!(@size_classes, assigns.size)

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

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :value,
          :aria_label,
          :required,
          :disabled,
          :readonly,
          :autocomplete,
          :inputmode,
          :placeholder,
          :minlength,
          :maxlength,
          :pattern,
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
          "sui:flex sui:w-full sui:min-w-0 sui:rounded-md sui:border sui:border-input",
          "sui:bg-background sui:text-foreground sui:shadow-xs sui:outline-none",
          "sui:transition-[color,box-shadow,border-color] sui:placeholder:text-muted-foreground",
          "sui:focus-visible:border-ring sui:focus-visible:ring-2 sui:focus-visible:ring-ring",
          "sui:focus-visible:ring-offset-2 sui:focus-visible:ring-offset-background",
          "sui:disabled:pointer-events-none sui:disabled:cursor-not-allowed sui:disabled:opacity-50",
          "sui:read-only:bg-muted sui:read-only:text-muted-foreground",
          normalized.errors_visible? && "sui:border-destructive sui:ring-destructive/20",
          normalized.pending? && "sui:cursor-progress",
          assigns.leading != [] && "sui:pl-9",
          assigns.trailing != [] && "sui:pr-9",
          size_classes,
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
        <div data-shadcn-ui-input-frame class="sui:relative sui:min-w-0">
          <span
            :if={@leading != []}
            data-shadcn-ui-input-leading
            class="sui:pointer-events-none sui:absolute sui:inset-y-0 sui:left-0 sui:flex sui:w-9 sui:items-center sui:justify-center sui:text-muted-foreground"
          >
            {render_slot(@leading)}
          </span>
          <input
            {@safe_rest}
            data-shadcn-ui
            data-shadcn-ui-input
            data-pending={@normalized.pending? && "true"}
            id={control.id}
            name={control.name}
            type={@type}
            value={control.value}
            required={@required}
            disabled={@disabled}
            readonly={@readonly}
            autocomplete={@autocomplete}
            inputmode={@inputmode}
            placeholder={@placeholder}
            minlength={@minlength}
            maxlength={@maxlength}
            pattern={@pattern}
            min={@min}
            max={@max}
            step={@step}
            form={@form}
            aria-describedby={control.aria_describedby}
            aria-invalid={control.aria_invalid}
            class={@classes}
          />
          <span
            :if={@trailing != []}
            data-shadcn-ui-input-trailing
            class="sui:pointer-events-none sui:absolute sui:inset-y-0 sui:right-0 sui:flex sui:w-9 sui:items-center sui:justify-center sui:text-muted-foreground"
          >
            {render_slot(@trailing)}
          </span>
        </div>
      </:control>
      <:help :if={@help != []}>{render_slot(@help)}</:help>
    </.field>
    """
  end

  defp validate_type!(type) when type in @types, do: :ok

  defp validate_type!(other) do
    raise ArgumentError,
          "input type must be one of #{inspect(@types)}, got: #{inspect(other)}"
  end

  defp validate_constraints!(assigns) do
    validate_constraint_group!(
      assigns,
      [:minlength, :maxlength, :pattern],
      @text_constraint_types,
      "text constraints"
    )

    validate_constraint_group!(
      assigns,
      [:min, :max, :step],
      @range_constraint_types,
      "range constraints"
    )
  end

  defp validate_constraint_group!(assigns, attributes, allowed_types, label) do
    supplied = Enum.filter(attributes, &(Map.fetch!(assigns, &1) != nil))

    if supplied != [] and assigns.type not in allowed_types do
      raise ArgumentError,
            "#{label} #{inspect(supplied)} are not valid for input type #{inspect(assigns.type)}"
    end
  end
end
