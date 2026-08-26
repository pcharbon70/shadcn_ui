defmodule ShadcnUI.Components.Motion.ScrollIndicator do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract

  @moduledoc """
  A named native block scroller with optional decorative scroll-position fill.

  Requires a stable `id`, exactly one `accessible_label` or `labelledby` (existing
  heading IDs), and trusted `inner_block`. Optional `description` is escaped.
  Sizes `:small`, `:default`, `:large` cap the region at 12, 20, 32rem; short
  content does not need to overflow. The region is a native Tab stop and keeps
  caller links/forms, keyboard, wheel and touch scrolling and scroll escape.

  A deterministic named timeline belongs only to this instance. Its aria-hidden
  track has no progressbar, value, reading/completion or live-region semantics.
  Joint scroll-timeline, animation-range and timeline-scope support may fill the
  track; without it the track is neutral. Short content has no progress to show.
  No document-clock animation, listeners, observer or callback is installed.

  `motion: :none`, ancestor `data-shadcn-motion="reduce"`, OS reduced motion and
  forced colors retain native content with neutral decoration. Missing CSS
  expands the complete content in document flow. Applications own content,
  permissions, actions and scroll restoration after replacement.
  """

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :description, :string, default: nil
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @sizes %{small: "sui:max-h-48", default: "sui:max-h-80", large: "sui:max-h-128"}
  @protected ~w(id role tabindex aria_label aria_labelledby aria_describedby aria_hidden aria_live aria_roledescription aria_selected aria_current aria_valuetext aria_valuenow aria_valuemin aria_valuemax hidden inert style data_shadcn_ui data_shadcn_ui_scroll_indicator data_shadcn_ui_scroll_source data_shadcn_ui_motion data_shadcn_ui_motion_part)a

  @doc "Renders native scroll content with a neutral-first decorative track."
  def scroll_indicator(assigns) do
    identity = MediaContract.identity!(assigns.id, "scroll")
    label = text!(assigns.accessible_label)
    heading = text!(assigns.labelledby)

    unless (label && is_nil(heading)) || (heading && is_nil(label)),
      do:
        raise(
          ArgumentError,
          "Scroll Indicator requires exactly one accessible_label or labelledby"
        )

    if heading &&
         not Regex.match?(~r/^[A-Za-z][A-Za-z0-9_.:-]*(?: [A-Za-z][A-Za-z0-9_.:-]*)*$/, heading),
       do: raise(ArgumentError, "labelledby requires space-separated heading IDs")

    unless Map.has_key?(@sizes, assigns.size),
      do: raise(ArgumentError, "invalid Scroll Indicator size")

    unless is_list(assigns.inner_block) and assigns.inner_block != [],
      do: raise(ArgumentError, "Scroll Indicator requires content")

    assigns =
      assigns
      |> assign(:label, label)
      |> assign(:heading, heading)
      |> assign(:description, text!(assigns.description))
      |> assign(:description_id, identity.caption)
      |> assign(:timeline_style, "--shadcn-ui-scroll-timeline:#{identity.timeline}")
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))
      |> assign(
        :source_classes,
        class_names(["sui:overflow-auto", Map.fetch!(@sizes, assigns.size)])
      )

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-scroll-indicator
      data-shadcn-ui-motion={@motion_value}
      class={class_names([@class])}
      style={@timeline_style}
    >
      <p :if={@description} id={@description_id}>{@description}</p>
      <div aria-hidden="true" data-shadcn-ui-scroll-track>
        <span data-shadcn-ui-scroll-fill data-shadcn-ui-motion-part="fill"></span>
      </div>
      <div
        id={@id}
        role="region"
        tabindex="0"
        aria-label={@label}
        aria-labelledby={@heading}
        aria-describedby={@description && @description_id}
        class={@source_classes}
        data-shadcn-ui-scroll-source
        data-shadcn-ui-motion-part="source"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp text!(nil), do: nil

  defp text!(text) when is_binary(text) do
    unless String.valid?(text) and String.trim(text) != "",
      do: raise(ArgumentError, "expected nonblank text")

    text
  end

  defp text!(_), do: raise(ArgumentError, "expected a text string")
end
