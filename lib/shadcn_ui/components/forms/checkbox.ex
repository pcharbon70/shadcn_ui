defmodule ShadcnUI.Components.Forms.Checkbox do
  use ShadcnUI.Component

  @moduledoc """
  Native checkbox with explicit boolean or repeated-value submission semantics.

  Boolean mode emits Phoenix's same-name hidden unchecked sentinel immediately
  before the visible checkbox. Multiple mode normalizes the name to `[]`, uses
  the explicit option value, and emits no sentinel. Checked state is a rendered
  snapshot; the browser and consuming application own changes and submission.
  """

  alias Phoenix.HTML.{Form, FormField}
  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.FieldErrors, only: [field_errors: 1]
  import ShadcnUI.Components.Forms.Help, only: [help: 1]
  import ShadcnUI.Components.Forms.Label, only: [label: 1]

  @not_provided {:shadcn_ui, :not_provided}

  attr :field, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :mode, :atom, values: [:boolean, :multiple], default: :boolean
  attr :value, :any, default: @not_provided
  attr :checked, :boolean, default: nil
  attr :checked_value, :string, default: "true"
  attr :unchecked_value, :string, default: "false"
  attr :errors, :any, default: @not_provided
  attr :error_mode, :atom, values: [:used_input, :always, :hidden], default: :used_input
  attr :used, :boolean, default: false
  attr :translate_error, :any, default: nil
  attr :pending, :boolean, default: false
  attr :required, :boolean, default: false
  attr :optional, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :form, :string, default: nil
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :field_class, :any, default: nil
  attr :label_class, :any, default: nil
  attr :rest, :global, include: ~w(autofocus)

  slot :label, required: true
  slot :help

  @doc "Renders one native boolean or repeated-value checkbox field."
  def checkbox(assigns) do
    name = normalized_name(assigns)

    normalized =
      FormContract.normalize!(
        field: assigns.field,
        id: assigns.id,
        name: name,
        value: normalized_field_value(assigns),
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

    checked_value = require_nonblank!(assigns.checked_value, :checked_value)
    unchecked_value = require_nonblank!(assigns.unchecked_value, :unchecked_value)
    option_value = option_value!(assigns, checked_value)
    checked? = checked?(assigns, normalized.value, option_value)

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(:relationships, relationships)
      |> assign(:checked?, checked?)
      |> assign(:option_value, option_value)
      |> assign(:unchecked_value, unchecked_value)
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :aria_label,
          :checked,
          :disabled,
          :required,
          :value,
          :form,
          :data_pending
        ])
      )
      |> assign(
        :field_classes,
        class_names([
          "sui:grid sui:min-w-0 sui:gap-2 sui:border-l-2 sui:border-transparent sui:pl-3",
          "sui:text-foreground",
          normalized.errors_visible? && "sui:border-destructive",
          assigns.disabled && "sui:opacity-60",
          normalized.pending? && "sui:cursor-progress",
          assigns.field_class
        ])
      )
      |> assign(
        :control_classes,
        class_names([
          "sui:size-4 sui:shrink-0 sui:rounded sui:border sui:border-input sui:accent-primary",
          "sui:bg-background sui:text-primary sui:outline-none",
          "sui:focus-visible:ring-2 sui:focus-visible:ring-ring sui:focus-visible:ring-offset-2",
          "sui:focus-visible:ring-offset-background sui:disabled:cursor-not-allowed",
          "sui:disabled:opacity-50 sui:checked:border-primary",
          normalized.errors_visible? && "sui:border-destructive",
          assigns.class
        ])
      )

    ~H"""
    <div
      data-shadcn-ui
      data-shadcn-ui-field
      data-shadcn-ui-checkbox-field
      data-invalid={@normalized.errors_visible? && "true"}
      data-pending={@normalized.pending? && "true"}
      data-disabled={@disabled && "true"}
      data-required={@required && "true"}
      class={@field_classes}
    >
      <div class="sui:flex sui:min-w-0 sui:items-start sui:gap-2">
        <input
          :if={@mode == :boolean}
          type="hidden"
          name={@normalized.name}
          value={@unchecked_value}
          disabled={@disabled}
          form={@form}
        />
        <input
          {@safe_rest}
          data-shadcn-ui
          data-shadcn-ui-checkbox
          data-pending={@normalized.pending? && "true"}
          type="checkbox"
          id={@normalized.id}
          name={@normalized.name}
          value={@option_value}
          checked={@checked?}
          required={@required}
          disabled={@disabled}
          form={@form}
          aria-describedby={@relationships.describedby}
          aria-invalid={@relationships.aria_invalid}
          class={@control_classes}
        />
        <.label
          id={@relationships.label_id}
          for={@normalized.id}
          required={@required}
          optional={@optional}
          class={[
            "sui:flex-1 sui:cursor-pointer",
            @disabled && "sui:cursor-not-allowed",
            @label_class
          ]}
        >
          {render_slot(@label)}
        </.label>
      </div>
      <.help :if={@help != []} id={@relationships.help_id}>{render_slot(@help)}</.help>
      <.field_errors errors={@normalized.errors} ids={@relationships.error_ids} />
    </div>
    """
  end

  defp normalized_name(%{name: explicit_name, field: field, mode: mode}) do
    name = explicit_name || field_value(field, :name)

    if mode == :multiple and is_binary(name) and not String.ends_with?(name, "[]") do
      name <> "[]"
    else
      name
    end
  end

  defp normalized_field_value(%{mode: :multiple, field: field}),
    do: field_value(field, :value)

  defp normalized_field_value(%{mode: :boolean, value: value}), do: value

  defp option_value!(%{mode: :boolean}, checked_value), do: checked_value

  defp option_value!(%{mode: :multiple, value: value}, _checked_value),
    do: require_nonblank!(value, :value)

  defp checked?(%{checked: checked}, _field_value, _option_value) when is_boolean(checked),
    do: checked

  defp checked?(%{mode: :boolean}, field_value, checked_value) do
    Form.normalize_value("checkbox", field_value) or same_value?(field_value, checked_value)
  end

  defp checked?(%{mode: :multiple}, nil, _option_value), do: false

  defp checked?(%{mode: :multiple}, values, option_value) when is_list(values),
    do: Enum.any?(values, &same_value?(&1, option_value))

  defp checked?(%{mode: :multiple}, value, _option_value) do
    raise ArgumentError,
          "multiple checkbox FormField value must be a list or nil, got: #{inspect(value)}"
  end

  defp require_nonblank!(value, key) when is_binary(value) do
    if String.trim(value) == "" do
      raise ArgumentError, "#{key} must be a nonblank string"
    end

    value
  end

  defp require_nonblank!(value, key) do
    raise ArgumentError, "#{key} must be a nonblank string, got: #{inspect(value)}"
  end

  defp same_value?(left, right)
       when is_binary(left) or is_atom(left) or is_integer(left) or is_float(left),
       do: to_string(left) == right

  defp same_value?(_left, _right), do: false

  defp field_value(nil, _key), do: nil
  defp field_value(%FormField{} = field, key), do: Map.fetch!(field, key)

  defp field_value(other, _key) do
    raise ArgumentError,
          "field must be a Phoenix.HTML.FormField or nil, got: #{inspect(other)}"
  end
end
