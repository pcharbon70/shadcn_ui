defmodule ShadcnUI.Components.Foundation.Card do
  use ShadcnUI.Component

  @moduledoc """
  Neutral content surfaces with caller-authored semantic regions.

  Card supplies layout only. Applications own data, destinations, selection,
  submission, loading, commands, and outcomes. Headings, links, forms, and
  controls supplied in slots retain their native meaning and behavior.
  """

  @base_classes [
    "sui:w-full",
    "sui:max-w-full",
    "sui:rounded-xl",
    "sui:border",
    "sui:border-border",
    "sui:bg-card",
    "sui:text-card-foreground",
    "sui:shadow-sm"
  ]

  attr :class, :any, default: nil
  attr :rest, :global

  slot :header
  slot :title
  slot :description
  slot :actions
  slot :inner_block, required: true
  slot :footer

  @doc """
  Renders one bordered surface around required primary content.

  Optional regions are omitted entirely when absent. Their deterministic DOM
  order is header, title, description, actions, primary content, then footer.
  Card adds no destination, click handler, selected state, or workflow role.
  """
  def card(assigns) do
    has_heading_region =
      Enum.any?(
        [assigns.header, assigns.title, assigns.description, assigns.actions],
        &(&1 != [])
      )

    assigns =
      assigns
      |> assign(:has_heading_region, has_heading_region)
      |> assign(:safe_rest, protect_globals(assigns.rest, [:data_shadcn_ui]))
      |> assign(:classes, class_names([@base_classes, assigns.class]))
      |> assign(
        :content_classes,
        class_names([
          "sui:min-w-0",
          "sui:px-6",
          !has_heading_region && "sui:pt-6",
          assigns.footer == [] && "sui:pb-6"
        ])
      )

    ~H"""
    <div {@safe_rest} data-shadcn-ui class={@classes}>
      <div
        :if={@has_heading_region}
        data-shadcn-ui-slot="header-region"
        class="sui:min-w-0 sui:p-6 sui:pb-4"
      >
        <div :if={@header != []} data-shadcn-ui-slot="header" class="sui:mb-4 sui:min-w-0">
          {render_slot(@header)}
        </div>
        <div
          :if={@title != []}
          data-shadcn-ui-slot="title"
          class="sui:min-w-0 sui:font-semibold sui:tracking-tight"
        >
          {render_slot(@title)}
        </div>
        <div
          :if={@description != []}
          data-shadcn-ui-slot="description"
          class="sui:mt-0.5 sui:min-w-0 sui:break-words sui:text-sm sui:text-muted-foreground"
        >
          {render_slot(@description)}
        </div>
        <div
          :if={@actions != []}
          data-shadcn-ui-slot="actions"
          class="sui:mt-4 sui:flex sui:flex-wrap sui:items-center sui:gap-2"
        >
          {render_slot(@actions)}
        </div>
      </div>
      <div data-shadcn-ui-slot="content" class={@content_classes}>
        {render_slot(@inner_block)}
      </div>
      <div :if={@footer != []} data-shadcn-ui-slot="footer" class="sui:p-6 sui:pt-5">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end
end
