defmodule ShadcnUI.Components.Forms.Progress do
  use ShadcnUI.Component

  @moduledoc """
  Native task-progress snapshot with explicit accessible naming.

  Omit `value` (or pass `nil`) for the native indeterminate state. The caller
  owns measurement, polling, lifecycle, announcements, and completion behavior.
  """

  alias ShadcnUI.Components.Forms.FormContract

  @not_provided {:shadcn_ui, :not_provided}

  attr :id, :string, required: true
  attr :value, :any, default: @not_provided
  attr :max, :any, default: 1
  attr :accessible_label, :string, default: nil
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :variant, :atom, values: [:default, :destructive], default: :default
  attr :class, :any, default: nil
  attr :rest, :global

  slot :label
  slot :description

  @doc "Renders one native determinate or indeterminate progress element."
  def progress(assigns) do
    id = validate_id!(assigns.id)
    validate_name!(assigns.label, assigns.accessible_label)
    max = validate_positive_number!(:max, assigns.max)
    value = validate_value!(assigns.value, max)

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:value, value)
      |> assign(:max, max)
      |> assign(:label_id, if(assigns.label == [], do: nil, else: "#{id}-label"))
      |> assign(
        :description_id,
        if(assigns.description == [], do: nil, else: "#{id}-description")
      )
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :value,
          :max,
          :aria_label,
          :aria_labelledby,
          :aria_describedby
        ])
      )
      |> assign(
        :classes,
        class_names(["shadcn-ui-progress-control", assigns.class])
      )

    ~H"""
    <div
      data-shadcn-ui
      data-shadcn-ui-progress-frame
      data-size={@size}
      data-variant={@variant}
      class="sui:grid sui:min-w-0 sui:gap-2 sui:text-foreground"
    >
      <label
        :if={@label != []}
        id={@label_id}
        for={@id}
        data-shadcn-ui
        data-shadcn-ui-progress-label
        class="sui:text-sm sui:font-medium sui:leading-snug"
      >
        {render_slot(@label)}
      </label>
      <progress
        {@safe_rest}
        id={@id}
        data-shadcn-ui
        data-shadcn-ui-progress
        data-size={@size}
        data-variant={@variant}
        value={@value}
        max={@max}
        aria-label={@label == [] && @accessible_label}
        aria-labelledby={@label_id}
        aria-describedby={@description_id}
        class={@classes}
      />
      <p
        :if={@description != []}
        id={@description_id}
        data-shadcn-ui
        data-shadcn-ui-progress-description
        class="sui:text-sm sui:text-muted-foreground"
      >
        {render_slot(@description)}
      </p>
    </div>
    """
  end

  defp validate_value!(@not_provided, _max), do: nil
  defp validate_value!(nil, _max), do: nil

  defp validate_value!(value, max) do
    value = validate_number!(:value, value)

    if value < 0 or value > max do
      raise ArgumentError, "progress value must be between 0 and max"
    end

    value
  end

  defp validate_positive_number!(key, value) do
    value = validate_number!(key, value)

    if value <= 0 do
      raise ArgumentError, "progress #{key} must be greater than zero"
    end

    value
  end

  defp validate_number!(_key, value) when is_integer(value) or is_float(value), do: value

  defp validate_number!(key, value) do
    raise ArgumentError, "progress #{key} must be a number, got: #{inspect(value)}"
  end

  defp validate_name!([], accessible_label) when is_binary(accessible_label) do
    if String.trim(accessible_label) == "" do
      raise ArgumentError, "progress accessible_label must be nonblank when label is omitted"
    end
  end

  defp validate_name!([], _accessible_label) do
    raise ArgumentError, "progress requires a visible label or accessible_label"
  end

  defp validate_name!(_label, nil), do: :ok

  defp validate_name!(_label, _accessible_label) do
    raise ArgumentError, "progress accepts either a visible label or accessible_label, not both"
  end

  defp validate_id!(id) when is_binary(id) do
    case String.trim(id) do
      "" -> raise ArgumentError, "progress id must be a nonblank string"
      normalized -> normalized
    end
  end

  defp validate_id!(_id), do: raise(ArgumentError, "progress id must be a nonblank string")
end
