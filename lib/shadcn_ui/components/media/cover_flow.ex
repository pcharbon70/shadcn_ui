defmodule ShadcnUI.Components.Media.CoverFlow do
  use ShadcnUI.Component
  import ShadcnUI.Components.Media.Carousel, only: [carousel: 1]
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract

  @moduledoc """
  Structured image figures over the complete native Carousel list and index.

  Supply a unique `id`, exactly one `accessible_label`/`labelledby`, and nonempty
  `images`: atom-keyed records with stable `key`, `src`, explicit `alt`, positive
  intrinsic `width`/`height`, optional `name`, escaped `caption`, `href`, width
  `srcset` candidates plus `sizes`, `loading` and `decoding`. Decorative images
  need empty alt, `decorative: true` and an independent name. Applications own
  sources, meaningful names, image rights and navigation. There is no fetching
  or image processing in this package. Broken images retain alt and destinations.

  `presentation: :enhanced` (default) only permits a CSS enhancement. Multiple
  images, a container at least 40rem wide, joint native view timeline/range/scope
  and 3D support, no forced colors and no motion suppression are required. Other
  cases remain flat. `:flat` explicitly opts out. Only bounded images transform;
  captions and ordinary named destination links remain outside the effect.

  `snap`, `alignment`, names and description follow Carousel. Native scrolling,
  fragment index and focus remain browser-owned. No selected image, autoplay,
  drag/swipe handler, clones, generated controls or document-clock fallback.
  Replacement may reset native position/focus; applications own restoration.
  """

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :description, :string, default: nil
  attr :images, :list, required: true
  attr :presentation, :atom, values: [:flat, :enhanced], default: :enhanced
  attr :snap, :atom, values: [:none, :proximity, :mandatory], default: :proximity
  attr :alignment, :atom, values: [:start, :center], default: :start
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :class, :any, default: nil
  attr :rest, :global

  @protected ~w(id role tabindex style hidden inert aria_hidden aria_live aria_selected aria_current aria_label aria_labelledby aria_describedby data_shadcn_ui data_shadcn_ui_cover_flow data_shadcn_ui_presentation data_shadcn_ui_motion data_shadcn_ui_motion_part)a

  @doc "Renders complete native figures with optional image-only depth."
  def cover_flow(assigns) do
    images = MediaContract.entries!(assigns.images, assigns.id)
    unless images != [], do: raise(ArgumentError, "Cover Flow needs at least one image")

    unless assigns.presentation in [:flat, :enhanced],
      do: raise(ArgumentError, "invalid Cover Flow presentation")

    assigns =
      assigns
      |> assign(:entries, images)
      |> assign(
        :presentation_value,
        if(length(images) > 1, do: assigns.presentation, else: :flat)
      )
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))
      |> assign(:classes, class_names([assigns.class]))

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-cover-flow
      data-shadcn-ui-presentation={@presentation_value}
      data-shadcn-ui-motion={@motion_value}
      class={@classes}
    >
      <.carousel
        id={@id}
        accessible_label={@accessible_label}
        labelledby={@labelledby}
        description={@description}
        snap={@snap}
        alignment={@alignment}
        motion={@motion}
      >
        <:item :for={entry <- @entries} key={entry.key} label={entry.name}>
          <figure data-shadcn-ui-cover-figure>
            <div
              data-shadcn-ui-cover-depth
              style={"--shadcn-ui-cover-timeline:#{entry.identity.timeline}"}
            >
              <img
                src={entry.src}
                alt={entry.alt}
                width={entry.width}
                height={entry.height}
                srcset={entry.srcset}
                sizes={entry.sizes}
                loading={entry.loading}
                decoding={entry.decoding}
                data-shadcn-ui-cover-image
                data-shadcn-ui-motion-part="image"
              />
            </div>
            <figcaption :if={entry.caption} id={entry.identity.caption}>{entry.caption}</figcaption>
            <a :if={entry.href} href={entry.href} data-shadcn-ui-cover-destination>{entry.name}</a>
          </figure>
        </:item>
      </.carousel>
    </div>
    """
  end
end
