defmodule ShadcnUI.Components.Motion.Marquee do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract

  @moduledoc """
  A complete static list with an optional, explicitly enabled finite preview.

  Requires `id`, `accessible_label` and nonempty `items` maps with unique string
  `key`, nonblank `text` and optional `image`. Images accept only `src`, `alt`,
  `width`, `height`, `srcset`, `sizes`, `loading` and `decoding`; empty alt means
  decoration accompanying the required text. No slots, links or actions are
  cloned. Text is escaped, image metadata uses the shared media validation.

  Mode defaults to `:static`. `:preview` adds an initially unchecked, unnamed
  checkbox. Check to enable one traversal, uncheck to stop/reset, then check to
  replay. Checked is enablement, not observed playback. `:brief` lasts 2.5s;
  `:default` lasts 5s, with no delay or repeat. Direction is `:inline_start`
  (default) or `:inline_end`, following inherited writing direction.

  One inert, aria-hidden, ID-free decorative duplicate is visible only during
  the finite preview. Completion restores the complete canonical list. Missing
  CSS or joint capabilities, `motion: :none`, ancestor
  `data-shadcn-motion="reduce"`, and OS reduced motion keep static content.
  Native checkbox state may reset on replacement; callers own persistence.
  No runtime, visibility observer, autoplay or perpetual offscreen work ships.
  """

  attr :id, :string, required: true
  attr :accessible_label, :string, required: true
  attr :items, :list, required: true
  attr :mode, :atom, values: [:static, :preview], default: :static
  attr :direction, :atom, values: [:inline_start, :inline_end], default: :inline_start
  attr :duration, :atom, values: [:brief, :default], default: :default
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :class, :any, default: nil
  attr :rest, :global

  @protected ~w(id role tabindex aria_label aria_labelledby aria_describedby aria_hidden aria_live hidden inert style data_shadcn_ui data_shadcn_ui_marquee data_shadcn_ui_motion data_shadcn_ui_motion_part data_shadcn_ui_direction data_shadcn_ui_duration)a
  @image_fields ~w(src alt width height srcset sizes loading decoding)a

  @doc "Renders structured presentation items and an optional native finite-preview control."
  def marquee(assigns) do
    identity = MediaContract.identity!(assigns.id, "preview")
    label = text!(assigns.accessible_label)
    MotionContract.marquee_duration!(assigns.duration)

    unless assigns.mode in [:static, :preview] and
             assigns.direction in [:inline_start, :inline_end],
           do: raise(ArgumentError, "invalid Marquee mode or direction")

    unless is_list(assigns.items) and assigns.items != [],
      do: raise(ArgumentError, "Marquee requires nonempty structured items")

    entries = Enum.map(assigns.items, &entry!(&1, assigns.id))
    keys = Enum.map(entries, & &1.id)
    unless keys == Enum.uniq(keys), do: raise(ArgumentError, "duplicate Marquee key")

    assigns =
      assigns
      |> assign(:entries, entries)
      |> assign(:label, label)
      |> assign(:control_id, identity.invoker)
      |> assign(:instructions_id, identity.caption)
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))

    ~H"""
    <div
      {@safe_rest}
      id={@id}
      data-shadcn-ui
      data-shadcn-ui-marquee
      data-shadcn-ui-motion={@motion_value}
      data-shadcn-ui-direction={@direction}
      data-shadcn-ui-duration={@duration}
      class={class_names([@class])}
    >
      <div :if={@mode == :preview} data-shadcn-ui-marquee-control hidden>
        <label for={@control_id}>
          <input id={@control_id} type="checkbox" aria-describedby={@instructions_id} />
          Enable one finite preview: {@label}
        </label>
      </div>
      <p :if={@mode == :preview} id={@instructions_id}>
        Check to preview once; uncheck to stop and reset, then check again to replay.
        Checked means enabled, not currently playing. Reduced motion or unavailable CSS keeps the complete static list.
      </p>
      <div data-shadcn-ui-marquee-viewport>
        <ul
          role="list"
          aria-label={@label}
          data-shadcn-ui-marquee-list
          data-shadcn-ui-motion-part="canonical"
        >
          <li :for={entry <- @entries} id={entry.id}>
            <.presentation_image :if={entry.image} image={entry.image} />
            <span>{entry.text}</span>
          </li>
        </ul>
        <div
          :if={@mode == :preview}
          hidden
          inert
          aria-hidden="true"
          data-shadcn-ui-motion-part="clone"
        >
          <span :for={entry <- @entries}>
            <.presentation_image :if={entry.image} image={entry.image} duplicate={true} />
            <span>{entry.text}</span>
          </span>
        </div>
      </div>
    </div>
    """
  end

  attr :image, :map, required: true
  attr :duplicate, :boolean, default: false

  defp presentation_image(assigns) do
    ~H"""
    <img
      src={@image.src}
      alt={if @duplicate, do: "", else: @image.alt}
      width={@image.width}
      height={@image.height}
      srcset={@image.srcset}
      sizes={@image.sizes}
      loading={@image.loading}
      decoding={@image.decoding}
    />
    """
  end

  defp entry!(entry, id) when is_map(entry) and not is_struct(entry) do
    if Map.keys(entry) -- [:key, :text, :image] != [],
      do: raise(ArgumentError, "Marquee items accept only key, text and image")

    text = text!(Map.get(entry, :text))
    identity = MediaContract.identity!(id, Map.get(entry, :key))
    image = image!(Map.get(entry, :image), entry.key, text)
    %{id: identity.item, text: text, image: image}
  end

  defp entry!(_, _), do: raise(ArgumentError, "Marquee items must be presentation maps")

  defp image!(nil, _, _), do: nil

  defp image!(image, key, text) when is_map(image) and not is_struct(image) do
    if Map.keys(image) -- @image_fields != [],
      do: raise(ArgumentError, "Marquee image must not contain actions or unknown fields")

    image
    |> Map.merge(%{key: key, name: text, decorative: Map.get(image, :alt) == ""})
    |> MediaContract.image!()
  end

  defp image!(_, _, _), do: raise(ArgumentError, "invalid Marquee image")

  defp text!(text) when is_binary(text) do
    unless String.valid?(text) and String.trim(text) != "",
      do: raise(ArgumentError, "Marquee requires nonblank text")

    text
  end

  defp text!(_), do: raise(ArgumentError, "Marquee requires text strings")
end
