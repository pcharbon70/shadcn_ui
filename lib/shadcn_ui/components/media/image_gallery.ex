defmodule ShadcnUI.Components.Media.ImageGallery do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract
  alias ShadcnUI.Components.Overlays.{Dialog, OverlayContract}

  @moduledoc """
  A named responsive list of caller-owned image figures and complete destinations.

  Require a unique `id`, exactly one `accessible_label`/`labelledby` and nonempty
  `images`. Shared atom-keyed image records require stable key, src, explicit alt,
  positive width/height; optional name, caption, href, srcset/sizes, loading,
  decoding and full-size metadata are validated without fetching or processing.
  Decorative images require empty alt, decorative: true and an independent name.
  The ordinary link uses explicit href, else full.src, else the supplied src.

  Columns are two/three/four (three default), density compact/comfortable, fit
  cover/contain. Layout collapses to one column in narrow containers. Caption
  slots are keyed, trusted noninteractive HEEx; a slot overrides its plain record
  caption. Do not place controls, dialogs or unscoped IDs in caption content.
  A caption slot receives `%{key: key, context: :thumbnail | :full}`; it is
  rendered in both presentations, so keep it presentation-only and scope any IDs.

  `lightbox` is `:dialog` (default) or `:none`. Each native Dialog has its own
  thumbnail invoker, visible title and close control, with no current-image state.
  `initial_focus` is `:auto`, `:content` or `:close`; dismissal is `:close_request`,
  `:none` or `:any`. Declare `context: :dialog` when embedded in a modal: only
  `lightbox: :none` is permitted there. The package cannot infer ancestor HEEx.
  Enlarged images use full metadata when supplied, otherwise the same source;
  they always use bounded contain sizing. Origin transitions are not shipped.

  Native loading/decoding are hints, not deferred-fetch or privacy guarantees.
  Applications own rights, CSP/origin policy, URL authorization, meaningful text,
  dimensions, responsive candidates, destinations and replacement/restoration.
  Image failures keep native alt, complete captions and ordinary links. No loader,
  current-image state, uploads, transformation or runtime is provided.
  """

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :description, :string, default: nil
  attr :images, :list, required: true
  attr :columns, :atom, values: [:two, :three, :four], default: :three
  attr :density, :atom, values: [:compact, :comfortable], default: :comfortable
  attr :fit, :atom, values: [:cover, :contain], default: :cover
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :lightbox, :atom, values: [:none, :dialog], default: :dialog
  attr :context, :atom, values: [:root, :dialog], default: :root
  attr :initial_focus, :atom, values: [:auto, :content, :close], default: :auto
  attr :dismissal, :atom, values: [:none, :close_request, :any], default: :close_request
  attr :close_label, :string, default: "Close image"
  attr :class, :any, default: nil
  attr :rest, :global

  slot :caption do
    attr :key, :string, required: true
  end

  @columns %{
    two: "sui:@sm/gallery:grid-cols-2",
    three: "sui:@sm/gallery:grid-cols-2 sui:@2xl/gallery:grid-cols-3",
    four: "sui:@sm/gallery:grid-cols-2 sui:@2xl/gallery:grid-cols-4"
  }
  @density %{compact: "sui:gap-3", comfortable: "sui:gap-6"}
  @fit %{cover: "sui:object-cover", contain: "sui:object-contain"}
  @protected ~w(id role tabindex style hidden inert aria_hidden aria_live aria_label aria_labelledby aria_describedby aria_selected aria_current aria_roledescription data_shadcn_ui data_shadcn_ui_image_gallery data_shadcn_ui_motion data_shadcn_ui_motion_part)a

  @doc "Renders validated responsive figures and separate complete image links."
  def image_gallery(assigns) do
    identity = MediaContract.identity!(assigns.id, "description")
    images = MediaContract.entries!(assigns.images, assigns.id)
    unless images != [], do: raise(ArgumentError, "Image Gallery needs at least one image")
    label = text!(assigns.accessible_label)
    heading = text!(assigns.labelledby)

    unless (label && is_nil(heading)) || (heading && is_nil(label)),
      do:
        raise(ArgumentError, "Image Gallery requires exactly one accessible_label or labelledby")

    if heading &&
         not Regex.match?(~r/^[A-Za-z][A-Za-z0-9_.:-]*(?: [A-Za-z][A-Za-z0-9_.:-]*)*$/, heading),
       do: raise(ArgumentError, "labelledby requires existing heading IDs")

    for {value, choices} <- [
          {assigns.columns, @columns},
          {assigns.density, @density},
          {assigns.fit, @fit}
        ] do
      unless Map.has_key?(choices, value),
        do: raise(ArgumentError, "invalid Image Gallery layout value")
    end

    slots = caption_slots!(assigns.caption, images)

    for {value, choices} <- [
          {assigns.lightbox, [:none, :dialog]},
          {assigns.context, [:root, :dialog]},
          {assigns.initial_focus, [:auto, :content, :close]},
          {assigns.dismissal, [:none, :close_request, :any]}
        ] do
      unless value in choices, do: raise(ArgumentError, "invalid Image Gallery lightbox value")
    end

    if assigns.lightbox == :dialog,
      do: OverlayContract.validate_nesting!(assigns.context, :dialog)

    close_label =
      text!(assigns.close_label) || raise(ArgumentError, "close_label must be nonblank")

    entries =
      Enum.map(images, fn entry ->
        entry
        |> Map.put(:caption_slot, Map.get(slots, entry.key, []))
        |> Map.put(:destination, entry.href || (entry.full && entry.full.src) || entry.src)
        |> Map.put(:enlarged, entry.full || entry)
      end)

    assigns =
      assigns
      |> assign(:entries, entries)
      |> assign(:close_label, close_label)
      |> assign(:label, label)
      |> assign(:heading, heading)
      |> assign(:description, text!(assigns.description))
      |> assign(:description_id, identity.caption <> "-gallery-description")
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))
      |> assign(
        :grid_classes,
        class_names([
          "sui:grid sui:grid-cols-1 sui:list-none sui:m-0 sui:p-0",
          @columns[assigns.columns],
          @density[assigns.density]
        ])
      )
      |> assign(
        :image_classes,
        class_names([
          "sui:block sui:w-full sui:h-auto sui:max-w-full sui:aspect-[4/3] sui:rounded-lg",
          @fit[assigns.fit]
        ])
      )

    ~H"""
    <section
      {@safe_rest}
      id={@id}
      aria-label={@label}
      aria-labelledby={@heading}
      aria-describedby={@description && @description_id}
      data-shadcn-ui
      data-shadcn-ui-image-gallery
      data-shadcn-ui-motion={@motion_value}
      class={class_names(["sui:@container/gallery sui:min-w-0 sui:max-w-full", @class])}
    >
      <p :if={@description} id={@description_id}>{@description}</p>
      <ul role="list" class={@grid_classes}>
        <li
          :for={entry <- @entries}
          id={entry.identity.item}
          class="sui:min-w-0 sui:wrap-anywhere"
          data-shadcn-ui-gallery-item
        >
          <figure class="sui:m-0 sui:grid sui:gap-3">
            <img
              :if={@lightbox == :none}
              src={entry.src}
              srcset={entry.srcset}
              sizes={entry.sizes}
              alt={entry.alt}
              width={entry.width}
              height={entry.height}
              loading={entry.loading}
              decoding={entry.decoding}
              class={@image_classes}
              data-shadcn-ui-gallery-thumbnail
            />
            <Dialog.dialog
              :if={@lightbox == :dialog}
              id={entry.identity.dialog}
              initial_focus={@initial_focus}
              dismissal={@dismissal}
              size={:large}
              class="sui:max-h-[calc(100%-2rem)]! sui:overflow-auto!"
              content_class="sui:max-h-none! sui:overflow-visible!"
              trigger_class="sui:flex-col sui:w-full sui:gap-2"
              close_class="sui:text-foreground"
              dialog_rest={
                %{
                  "data-shadcn-ui-gallery-lightbox" => "",
                  "data-shadcn-ui-motion-part" => "gallery-dialog"
                }
              }
            >
              <:trigger>
                <img
                  src={entry.src}
                  srcset={entry.srcset}
                  sizes={entry.sizes}
                  alt={entry.alt}
                  aria-hidden="true"
                  width={entry.width}
                  height={entry.height}
                  loading={entry.loading}
                  decoding={entry.decoding}
                  class={@image_classes}
                  data-shadcn-ui-gallery-thumbnail
                />
                <span>Enlarge {entry.name}</span>
              </:trigger>
              <:title>{entry.name}</:title>
              <:description>Enlarged image. Close to return to the thumbnail.</:description>
              <figure class="sui:m-0 sui:grid sui:gap-3">
                <img
                  src={entry.enlarged.src}
                  srcset={entry.enlarged.srcset}
                  sizes={entry.enlarged.sizes}
                  alt={entry.alt}
                  width={entry.enlarged.width}
                  height={entry.enlarged.height}
                  loading={entry.loading}
                  decoding={entry.decoding}
                  class="sui:block sui:w-full sui:h-auto sui:max-w-full sui:max-h-[60dvb] sui:object-contain"
                  data-shadcn-ui-gallery-full
                />
                <figcaption :if={entry.caption || entry.caption_slot != []}>
                  <%= if entry.caption_slot != [] do %>
                    {render_slot(entry.caption_slot, %{key: entry.key, context: :full})}
                  <% else %>
                    {entry.caption}
                  <% end %>
                </figcaption>
              </figure>
              <:close>{@close_label}</:close>
            </Dialog.dialog>
            <a
              href={entry.destination}
              data-shadcn-ui-gallery-destination
              class="sui:inline-flex sui:min-h-11 sui:items-center sui:underline"
            >Open image: {entry.name}</a>
            <figcaption :if={entry.caption || entry.caption_slot != []} id={entry.identity.caption}>
              <%= if entry.caption_slot != [] do %>
                {render_slot(entry.caption_slot, %{key: entry.key, context: :thumbnail})}
              <% else %>
                {entry.caption}
              <% end %>
            </figcaption>
          </figure>
        </li>
      </ul>
    </section>
    """
  end

  defp caption_slots!(slots, images) when is_list(slots) do
    keys = Enum.map(images, & &1.key)

    result =
      Enum.reduce(slots, %{}, fn slot, acc ->
        key = Map.get(slot, :key)

        unless key in keys and Map.has_key?(slot, :inner_block) and not Map.has_key?(acc, key),
          do: raise(ArgumentError, "caption slots need a unique existing image key and HEEx body")

        Map.put(acc, key, [slot])
      end)

    result
  end

  defp caption_slots!(_, _), do: raise(ArgumentError, "caption slots must be a list")
  defp text!(nil), do: nil

  defp text!(value) when is_binary(value) do
    unless String.valid?(value) and String.trim(value) != "",
      do: raise(ArgumentError, "text must be nonblank")

    value
  end

  defp text!(_), do: raise(ArgumentError, "text must be a string")
end
