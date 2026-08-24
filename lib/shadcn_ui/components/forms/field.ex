defmodule ShadcnUI.Components.Forms.Field do
  use ShadcnUI.Component

  @moduledoc """
  Relationship-aware layout for one caller-owned native form control.

  `field` normalizes identity, values, errors, and presentation state, then
  passes the protected control attributes to the required `control` slot. It
  does not create a form, changeset, validation lifecycle, or submission.
  """

  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.FieldErrors, only: [field_errors: 1]
  import ShadcnUI.Components.Forms.Help, only: [help: 1]
  import ShadcnUI.Components.Forms.Label, only: [label: 1]

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
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :label, required: true
  slot :control, required: true
  slot :help

  @doc """
  Renders label, caller-owned control, optional help, and visible field errors.

  The control slot receives a map containing `id`, `name`, `value`,
  `aria_describedby`, `aria_invalid`, `required`, `disabled`, and `pending`.
  """
  def field(assigns) do
    validate_requirement_state!(assigns)

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

    relationships =
      FormContract.relationships(normalized,
        help: assigns.help != [],
        describedby: assigns.describedby
      )

    context = %{
      id: normalized.id,
      name: normalized.name,
      value: normalized.value,
      aria_describedby: relationships.describedby,
      aria_invalid: relationships.aria_invalid,
      required: assigns.required,
      disabled: assigns.disabled,
      pending: normalized.pending?
    }

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(:relationships, relationships)
      |> assign(:context, context)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:id, :data_shadcn_ui, :data_invalid, :data_pending])
      )
      |> assign(
        :classes,
        class_names([
          "sui:grid sui:min-w-0 sui:gap-2 sui:border-l-2 sui:border-transparent sui:pl-3",
          "sui:text-foreground",
          normalized.errors_visible? && "sui:border-destructive",
          assigns.disabled && "sui:opacity-60",
          normalized.pending? && "sui:cursor-progress",
          assigns.class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-field
      data-invalid={@normalized.errors_visible? && "true"}
      data-pending={@normalized.pending? && "true"}
      data-disabled={@disabled && "true"}
      data-required={@required && "true"}
      class={@classes}
    >
      <.label
        id={@relationships.label_id}
        for={@normalized.id}
        required={@required}
        optional={@optional}
      >
        {render_slot(@label)}
      </.label>
      <div data-shadcn-ui-field-control>{render_slot(@control, @context)}</div>
      <.help :if={@help != []} id={@relationships.help_id}>{render_slot(@help)}</.help>
      <.field_errors errors={@normalized.errors} ids={@relationships.error_ids} />
    </div>
    """
  end

  defp validate_requirement_state!(%{required: true, optional: true}) do
    raise ArgumentError, "field cannot be both required and optional"
  end

  defp validate_requirement_state!(_assigns), do: :ok
end
