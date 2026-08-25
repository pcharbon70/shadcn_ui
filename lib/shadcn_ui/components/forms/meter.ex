defmodule ShadcnUI.Components.Forms.Meter do
  use ShadcnUI.Component

  @moduledoc """
  Native scalar measurement within a known range.

  Meter preserves native threshold semantics without deciding what the
  measurement means. It is not task progress and owns no polling, measurement,
  threshold decision, announcement, or lifecycle behavior.
  """

  alias ShadcnUI.Components.Forms.FormContract

  attr :id, :string, required: true
  attr :value, :any, required: true
  attr :min, :any, default: 0
  attr :max, :any, default: 1
  attr :low, :any, default: nil
  attr :high, :any, default: nil
  attr :optimum, :any, default: nil
  attr :accessible_label, :string, default: nil
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :class, :any, default: nil
  attr :rest, :global

  slot :label
  slot :description

  @doc "Renders one native meter with caller-supplied range and thresholds."
  def meter(assigns) do
    id = validate_id!(assigns.id)
    validate_name!(assigns.label, assigns.accessible_label)
    range = validate_range!(assigns)

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:range, range)
      |> assign(:label_id, if(assigns.label == [], do: nil, else: "#{id}-label"))
      |> assign(
        :description_id,
        if(assigns.description == [], do: nil, else: "#{id}-description")
      )
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :value,
          :min,
          :max,
          :low,
          :high,
          :optimum,
          :aria_label,
          :aria_labelledby,
          :aria_describedby
        ])
      )
      |> assign(:classes, class_names(["shadcn-ui-meter-control", assigns.class]))

    ~H"""
    <div
      data-shadcn-ui
      data-shadcn-ui-meter-frame
      data-size={@size}
      class="sui:grid sui:min-w-0 sui:gap-2 sui:text-foreground"
    >
      <label
        :if={@label != []}
        id={@label_id}
        for={@id}
        data-shadcn-ui
        data-shadcn-ui-meter-label
        class="sui:text-sm sui:font-medium sui:leading-snug"
      >
        {render_slot(@label)}
      </label>
      <meter
        {@safe_rest}
        id={@id}
        data-shadcn-ui
        data-shadcn-ui-meter
        data-size={@size}
        value={@range.value}
        min={@range.min}
        max={@range.max}
        low={@range.low}
        high={@range.high}
        optimum={@range.optimum}
        aria-label={@label == [] && @accessible_label}
        aria-labelledby={@label_id}
        aria-describedby={@description_id}
        class={@classes}
      />
      <p
        :if={@description != []}
        id={@description_id}
        data-shadcn-ui
        data-shadcn-ui-meter-description
        class="sui:text-sm sui:text-muted-foreground"
      >
        {render_slot(@description)}
      </p>
    </div>
    """
  end

  defp validate_range!(assigns) do
    range = %{
      value: validate_number!(:value, assigns.value),
      min: validate_number!(:min, assigns.min),
      max: validate_number!(:max, assigns.max),
      low: validate_optional_number!(:low, assigns.low),
      high: validate_optional_number!(:high, assigns.high),
      optimum: validate_optional_number!(:optimum, assigns.optimum)
    }

    if range.min > range.max, do: raise(ArgumentError, "meter min must not exceed max")

    for key <- [:value, :low, :high, :optimum], value = Map.fetch!(range, key), value != nil do
      if value < range.min or value > range.max do
        raise ArgumentError, "meter #{key} must be between min and max"
      end
    end

    if range.low != nil and range.high != nil and range.low > range.high do
      raise ArgumentError, "meter low must not exceed high"
    end

    range
  end

  defp validate_optional_number!(_key, nil), do: nil
  defp validate_optional_number!(key, value), do: validate_number!(key, value)

  defp validate_number!(_key, value) when is_integer(value) or is_float(value), do: value

  defp validate_number!(key, value) do
    raise ArgumentError, "meter #{key} must be a number, got: #{inspect(value)}"
  end

  defp validate_name!([], accessible_label) when is_binary(accessible_label) do
    if String.trim(accessible_label) == "" do
      raise ArgumentError, "meter accessible_label must be nonblank when label is omitted"
    end
  end

  defp validate_name!([], _accessible_label) do
    raise ArgumentError, "meter requires a visible label or accessible_label"
  end

  defp validate_name!(_label, nil), do: :ok

  defp validate_name!(_label, _accessible_label) do
    raise ArgumentError, "meter accepts either a visible label or accessible_label, not both"
  end

  defp validate_id!(id) when is_binary(id) do
    case String.trim(id) do
      "" -> raise ArgumentError, "meter id must be a nonblank string"
      normalized -> normalized
    end
  end

  defp validate_id!(_id), do: raise(ArgumentError, "meter id must be a nonblank string")
end
