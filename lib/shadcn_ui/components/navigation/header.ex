defmodule ShadcnUI.Components.Navigation.Header do
  use ShadcnUI.Component

  @moduledoc """
  A responsive native header composition for caller-owned page regions.

  Header arranges optional brand, primary navigation, utilities, and actions
  without inventing headings, navigation names, destinations, commands, or
  application state. Sticky presentation is a CSS snapshot with normal-flow
  fallback.
  """

  @width_classes %{
    full: "sui:w-full",
    contained: "sui:mx-auto sui:w-full sui:max-w-7xl",
    narrow: "sui:mx-auto sui:w-full sui:max-w-5xl"
  }
  @density_classes %{
    compact: "sui:px-3 sui:py-2",
    default: "sui:px-4 sui:py-3",
    comfortable: "sui:px-6 sui:py-4"
  }
  @wrap_classes %{
    wrap: "sui:flex-wrap",
    nowrap: "sui:flex-nowrap",
    responsive: "sui:flex-wrap sui:md:flex-nowrap"
  }
  @border_classes %{
    none: nil,
    bottom: "sui:border-b sui:border-border",
    all: "sui:rounded-lg sui:border sui:border-border"
  }
  @presentation_classes %{
    static: nil,
    sticky: "sui:sticky sui:top-0 sui:z-40"
  }

  attr :width, :atom, values: [:full, :contained, :narrow], default: :contained
  attr :density, :atom, values: [:compact, :default, :comfortable], default: :default
  attr :wrap, :atom, values: [:wrap, :nowrap, :responsive], default: :responsive
  attr :border, :atom, values: [:none, :bottom, :all], default: :bottom
  attr :presentation, :atom, values: [:static, :sticky], default: :static
  attr :class, :any, default: nil
  attr :rest, :global

  slot :brand do
    attr :class, :any
    attr :rest, :map
  end

  slot :primary_navigation do
    attr :class, :any
    attr :rest, :map
  end

  slot :utilities do
    attr :class, :any
    attr :rest, :map
  end

  slot :actions do
    attr :class, :any
    attr :rest, :map
  end

  @doc "Renders a native header around optional caller-owned semantic regions."
  def header(assigns) do
    assigns =
      assigns
      |> assign(:safe_rest, protect_header_globals(assigns.rest))
      |> assign(:brand, normalize_region!(assigns.brand, :brand))
      |> assign(
        :primary_navigation,
        normalize_region!(assigns.primary_navigation, :primary_navigation)
      )
      |> assign(:utilities, normalize_region!(assigns.utilities, :utilities))
      |> assign(:actions, normalize_region!(assigns.actions, :actions))
      |> assign(
        :classes,
        class_names([
          "sui:bg-background sui:text-foreground",
          Map.fetch!(@width_classes, assigns.width),
          Map.fetch!(@density_classes, assigns.density),
          Map.fetch!(@border_classes, assigns.border),
          Map.fetch!(@presentation_classes, assigns.presentation),
          assigns.class
        ])
      )
      |> assign(
        :inner_classes,
        class_names([
          "sui:flex sui:min-w-0 sui:items-center sui:gap-3",
          Map.fetch!(@wrap_classes, assigns.wrap)
        ])
      )

    ~H"""
    <header
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-header
      data-width={@width}
      data-density={@density}
      data-wrap={@wrap}
      data-border={@border}
      data-presentation={@presentation}
      class={@classes}
    >
      <div data-shadcn-ui-header-inner class={@inner_classes}>
        <div
          :for={region <- @brand}
          {region.rest}
          data-shadcn-ui-header-brand
          class={class_names(["sui:min-w-0 sui:shrink-0", region.class])}
        >
          {render_slot(region)}
        </div>
        <div
          :for={region <- @primary_navigation}
          {region.rest}
          data-shadcn-ui-header-primary
          class={class_names(["sui:min-w-0 sui:flex-1", region.class])}
        >
          {render_slot(region)}
        </div>
        <div
          :for={region <- @utilities}
          {region.rest}
          data-shadcn-ui-header-utilities
          class={class_names(["sui:min-w-0 sui:shrink-0", region.class])}
        >
          {render_slot(region)}
        </div>
        <div
          :for={region <- @actions}
          {region.rest}
          data-shadcn-ui-header-actions
          class={
            class_names([
              "sui:flex sui:min-w-0 sui:shrink-0 sui:items-center sui:gap-2",
              region.class
            ])
          }
        >
          {render_slot(region)}
        </div>
      </div>
    </header>
    """
  end

  defp normalize_region!(regions, owner) when is_list(regions) do
    Enum.map(regions, fn region ->
      rest = Map.get(region, :rest, %{})

      if not (is_map(rest) and not is_struct(rest)),
        do: raise(ArgumentError, "Header #{owner} rest must be a plain map")

      Map.merge(region, %{
        class: Map.get(region, :class),
        rest:
          protect_globals(rest, [
            :role,
            :data_shadcn_ui_header_brand,
            :data_shadcn_ui_header_primary,
            :data_shadcn_ui_header_utilities,
            :data_shadcn_ui_header_actions
          ])
      })
    end)
  end

  defp protect_header_globals(globals) do
    protect_globals(globals, [
      :role,
      :data_shadcn_ui,
      :data_shadcn_ui_header,
      :data_width,
      :data_density,
      :data_wrap,
      :data_border,
      :data_presentation
    ])
  end
end
