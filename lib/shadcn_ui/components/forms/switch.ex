defmodule ShadcnUI.Components.Forms.Switch do
  use ShadcnUI.Component

  @moduledoc """
  Switch presentation of the native boolean Checkbox contract.

  Switch delegates identity, checked state, hidden sentinel, relationships, and
  submission to Checkbox. It adds only track-and-thumb presentation. There is
  no role-only substitute, event API, synchronized state, or toggle method.
  """

  import ShadcnUI.Components.Forms.Checkbox, only: [checkbox: 1]

  @not_provided {:shadcn_ui, :not_provided}

  attr :field, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, default: nil
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
  attr :label_visibility, :atom, values: [:visible, :hidden], default: :visible
  attr :accessible_label, :string, default: nil
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :field_class, :any, default: nil
  attr :label_class, :any, default: nil
  attr :rest, :global, include: ~w(autofocus)

  slot :label, required: true
  slot :help

  @doc "Renders a native boolean checkbox with switch presentation."
  def switch(assigns) do
    validate_accessible_label!(assigns)

    assigns =
      assigns
      |> assign(
        :control_classes,
        class_names(["shadcn-ui-switch-control", assigns.class])
      )
      |> assign(
        :resolved_label_class,
        class_names([
          assigns.label_visibility == :hidden && "sui:sr-only",
          assigns.label_class
        ])
      )

    ~H"""
    <div data-shadcn-ui data-shadcn-ui-switch>
      <.checkbox
        {@rest}
        field={@field}
        id={@id}
        name={@name}
        mode={:boolean}
        value={@value}
        checked={@checked}
        checked_value={@checked_value}
        unchecked_value={@unchecked_value}
        errors={@errors}
        error_mode={@error_mode}
        used={@used}
        translate_error={@translate_error}
        pending={@pending}
        required={@required}
        optional={@optional}
        disabled={@disabled}
        form={@form}
        describedby={@describedby}
        class={@control_classes}
        field_class={@field_class}
        label_class={@resolved_label_class}
      >
        <:label>
          <span :if={@label_visibility == :visible}>{render_slot(@label)}</span>
          <span :if={@label_visibility == :hidden}>{@accessible_label}</span>
        </:label>
        <:help :if={@help != []}>{render_slot(@help)}</:help>
      </.checkbox>
    </div>
    """
  end

  defp validate_accessible_label!(%{label_visibility: :visible}), do: :ok

  defp validate_accessible_label!(%{label_visibility: :hidden, accessible_label: value})
       when is_binary(value) do
    if String.trim(value) == "" do
      raise ArgumentError,
            "accessible_label must be a nonblank string when the switch label is hidden"
    end
  end

  defp validate_accessible_label!(%{label_visibility: :hidden}) do
    raise ArgumentError,
          "accessible_label must be a nonblank string when the switch label is hidden"
  end
end
