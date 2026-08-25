defmodule ShadcnUI.Components.Content.ScrollArea do
  use ShadcnUI.Component

  @moduledoc """
  A bounded native overflow container with explicit focus policy.

  Scroll Area does not measure content, observe the viewport, restore position,
  virtualize children, load data, or add custom scroll controls. Applications
  own dimensions beyond the closed size presets and every scroll-driven policy.
  """

  @base_classes [
    "sui:relative",
    "sui:max-w-full",
    "sui:rounded-md",
    "sui:border",
    "sui:border-border",
    "sui:bg-background",
    "sui:text-foreground",
    "sui:p-3"
  ]

  @axis_classes %{
    vertical: ["sui:overflow-x-hidden", "sui:overflow-y-auto"],
    horizontal: ["sui:overflow-x-auto", "sui:overflow-y-hidden"],
    both: ["sui:overflow-auto"]
  }

  @size_classes %{
    small: ["sui:max-h-40"],
    default: ["sui:max-h-64"],
    large: ["sui:max-h-96"]
  }

  @edge_affordances %{none: true, start: true, end: true, both: true}

  attr :axis, :atom, values: [:vertical, :horizontal, :both], default: :vertical
  attr :size, :atom, values: [:small, :default, :large], default: :default

  attr :edge_affordance, :atom,
    values: [:none, :start, :end, :both],
    default: :none

  attr :focusable, :boolean, default: false
  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders one native overflow container around required caller content."
  def scroll_area(assigns) do
    accessible_label = normalize_name(assigns.accessible_label, :accessible_label)
    labelledby = normalize_name(assigns.labelledby, :labelledby)
    validate_focus_policy!(assigns.focusable, accessible_label, labelledby)
    _ = Map.fetch!(@edge_affordances, assigns.edge_affordance)

    assigns =
      assigns
      |> assign(:normalized_accessible_label, accessible_label)
      |> assign(:normalized_labelledby, labelledby)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :role,
          :tabindex,
          :aria_label,
          :aria_labelledby,
          :data_shadcn_ui,
          :data_shadcn_ui_scroll_area,
          :data_axis,
          :data_size,
          :data_edge_affordance
        ])
      )
      |> assign(
        :classes,
        class_names([
          @base_classes,
          Map.fetch!(@axis_classes, assigns.axis),
          Map.fetch!(@size_classes, assigns.size),
          assigns.focusable && classes_for(:focus, :default),
          assigns.class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-scroll-area
      data-axis={@axis}
      data-size={@size}
      data-edge-affordance={@edge_affordance}
      role={@focusable && "region"}
      tabindex={@focusable && "0"}
      aria-label={@normalized_accessible_label}
      aria-labelledby={@normalized_labelledby}
      class={@classes}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp normalize_name(nil, _field), do: nil

  defp normalize_name(value, _field) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      normalized -> normalized
    end
  end

  defp normalize_name(value, field) do
    raise ArgumentError, "#{field} must be a string or nil, got: #{inspect(value)}"
  end

  defp validate_focus_policy!(focusable, accessible_label, labelledby)
       when is_boolean(focusable) do
    cond do
      accessible_label && labelledby ->
        raise ArgumentError,
              "Scroll Area accepts either accessible_label or labelledby, not both"

      focusable && is_nil(accessible_label) && is_nil(labelledby) ->
        raise ArgumentError,
              "focusable Scroll Area requires a nonblank accessible_label or labelledby"

      true ->
        :ok
    end
  end

  defp validate_focus_policy!(focusable, _accessible_label, _labelledby) do
    raise ArgumentError, "focusable must be a boolean, got: #{inspect(focusable)}"
  end
end
