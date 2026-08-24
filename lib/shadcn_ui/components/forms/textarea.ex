defmodule ShadcnUI.Components.Forms.Textarea do
  use ShadcnUI.Component

  @moduledoc """
  Native multiline input composed through the shared form contract.

  Textarea keeps its normalized value as escaped element content. Native resize
  remains the fallback; explicit content sizing is a CSS capability enhancement.
  The caller owns parsing, validation, measurement-driven growth, persistence,
  submission, and request lifecycle.
  """

  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.Field, only: [field: 1]

  @not_provided {:shadcn_ui, :not_provided}

  @resize_classes %{
    vertical: "sui:resize-y",
    horizontal: "sui:resize-x",
    both: "sui:resize",
    fixed: "sui:resize-none"
  }

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
  attr :rows, :integer, default: nil
  attr :cols, :integer, default: nil
  attr :minlength, :integer, default: nil
  attr :maxlength, :integer, default: nil
  attr :placeholder, :string, default: nil
  attr :autocomplete, :string, default: nil
  attr :form, :string, default: nil
  attr :resize, :atom, values: [:vertical, :horizontal, :both, :fixed], default: :vertical
  attr :sizing, :atom, values: [:fixed, :content], default: :fixed
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :field_class, :any, default: nil
  attr :rest, :global, include: ~w(autocapitalize autofocus spellcheck wrap)

  slot :label, required: true
  slot :help

  @doc "Renders one native textarea with deterministic field relationships."
  def textarea(assigns) do
    resize_class = Map.fetch!(@resize_classes, assigns.resize)

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
          :aria_label,
          :required,
          :disabled,
          :readonly,
          :rows,
          :cols,
          :minlength,
          :maxlength,
          :placeholder,
          :autocomplete,
          :form,
          :data_pending,
          :data_sizing
        ])
      )
      |> assign(
        :classes,
        class_names([
          "sui:flex sui:w-full sui:min-w-0 sui:min-h-24 sui:rounded-md sui:border sui:border-input",
          "sui:bg-background sui:px-3 sui:py-2 sui:text-sm sui:text-foreground sui:shadow-xs",
          "sui:outline-none sui:transition-[color,box-shadow,border-color]",
          "sui:placeholder:text-muted-foreground sui:focus-visible:border-ring",
          "sui:focus-visible:ring-2 sui:focus-visible:ring-ring sui:focus-visible:ring-offset-2",
          "sui:focus-visible:ring-offset-background sui:disabled:pointer-events-none",
          "sui:disabled:cursor-not-allowed sui:disabled:opacity-50",
          "sui:read-only:bg-muted sui:read-only:text-muted-foreground",
          normalized.errors_visible? && "sui:border-destructive sui:ring-destructive/20",
          normalized.pending? && "sui:cursor-progress",
          resize_class,
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
        <textarea
          {@safe_rest}
          data-shadcn-ui
          data-shadcn-ui-textarea
          data-sizing={@sizing}
          data-pending={@normalized.pending? && "true"}
          id={control.id}
          name={control.name}
          required={@required}
          disabled={@disabled}
          readonly={@readonly}
          rows={@rows}
          cols={@cols}
          minlength={@minlength}
          maxlength={@maxlength}
          placeholder={@placeholder}
          autocomplete={@autocomplete}
          form={@form}
          aria-describedby={control.aria_describedby}
          aria-invalid={control.aria_invalid}
          class={@classes}
        >{control.value}</textarea>
      </:control>
      <:help :if={@help != []}>{render_slot(@help)}</:help>
    </.field>
    """
  end
end
