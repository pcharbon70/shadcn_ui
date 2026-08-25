defmodule ShadcnUI.Components.Navigation.SectionHeader do
  use ShadcnUI.Component

  @moduledoc """
  A page-section heading composition that preserves caller heading semantics.

  The required heading slot must contain the caller's chosen heading element.
  ShadcnUI does not infer a level, handle actions, observe scrolling, or own
  section state. Sticky and anchor effects are optional CSS presentation.
  """

  @presentation_classes %{
    static: nil,
    sticky: "sui:sticky sui:top-0 sui:z-30"
  }
  @density_classes %{
    compact: "sui:gap-1 sui:py-2",
    default: "sui:gap-2 sui:py-3",
    comfortable: "sui:gap-3 sui:py-4"
  }
  @anchor_classes %{
    none: nil,
    offset: "sui:scroll-mt-20",
    accent: "sui:scroll-mt-20"
  }

  attr :presentation, :atom, values: [:static, :sticky], default: :static
  attr :density, :atom, values: [:compact, :default, :comfortable], default: :default
  attr :anchor_effect, :atom, values: [:none, :offset, :accent], default: :offset
  attr :border, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  slot :heading, required: true
  slot :description
  slot :actions

  @doc "Renders a section header without manufacturing a heading level."
  def section_header(assigns) do
    assigns =
      assigns
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :role,
          :data_shadcn_ui,
          :data_shadcn_ui_section_header,
          :data_presentation,
          :data_anchor_effect
        ])
      )
      |> assign(
        :classes,
        class_names([
          "sui:grid sui:min-w-0 sui:grid-cols-1 sui:bg-background sui:text-foreground",
          "sui:sm:grid-cols-[minmax(0,1fr)_auto] sui:sm:items-start",
          Map.fetch!(@presentation_classes, assigns.presentation),
          Map.fetch!(@density_classes, assigns.density),
          Map.fetch!(@anchor_classes, assigns.anchor_effect),
          assigns.border && "sui:border-b sui:border-border",
          assigns.anchor_effect == :accent && "shadcn-ui-section-header-accent",
          assigns.class
        ])
      )

    ~H"""
    <header
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-section-header
      data-presentation={@presentation}
      data-anchor-effect={@anchor_effect}
      class={@classes}
    >
      <div data-shadcn-ui-section-header-copy class="sui:min-w-0">
        <div data-shadcn-ui-section-header-heading class="sui:min-w-0 sui:break-words">
          {render_slot(@heading)}
        </div>
        <div
          :if={@description != []}
          data-shadcn-ui-section-header-description
          class="sui:mt-1 sui:min-w-0 sui:break-words sui:text-sm sui:text-muted-foreground"
        >
          {render_slot(@description)}
        </div>
      </div>
      <div
        :if={@actions != []}
        data-shadcn-ui-section-header-actions
        class="sui:flex sui:min-w-0 sui:flex-wrap sui:items-center sui:gap-2 sui:sm:justify-self-end"
      >
        {render_slot(@actions)}
      </div>
    </header>
    """
  end
end
