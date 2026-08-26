defmodule ShadcnUI.Components.Media.Carousel do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract

  @moduledoc """
  A named native inline scroller, complete ordered list and real fragment index.

  Supply a unique `id` and exactly one of `accessible_label` or `labelledby`.
  Each `item` needs a stable string `key`, a text `label` and trusted HEEx body.
  `labelledby` references caller-owned headings that must exist in the document.
  Optional `description` is escaped text with a derived relationship.

  The region is a Tab stop; native arrow/wheel/touch scrolling and child controls
  remain browser-owned. Index links target focusable list items, not selected
  slides. There is no autoplay, previous/next controller, live announcement,
  roving focus, clone or JavaScript. All items remain in accessibility order.

  Snap is `:proximity` by default, or `:none` / `:mandatory`; alignment is
  `:start` or `:center`. Missing snap retains ordinary scrolling; without CSS
  the complete ordered list and index remain. Motion `:none`, an ancestor
  `data-shadcn-motion="reduce"`, or system reduced motion disables smooth
  scrolling. Applications own destinations, item order, child semantics and
  restoration after replacement, which can reset native scroll and focus.
  """

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :description, :string, default: nil
  attr :snap, :atom, values: [:none, :proximity, :mandatory], default: :proximity
  attr :alignment, :atom, values: [:start, :center], default: :start
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :key, :string, required: true
    attr :label, :string, required: true
    attr :class, :any
    attr :rest, :map
  end

  @protected ~w(id role tabindex aria_label aria_labelledby aria_describedby aria_roledescription aria_live aria_selected aria_current aria_hidden hidden inert data_shadcn_ui data_shadcn_ui_carousel data_shadcn_ui_carousel_item data_shadcn_ui_motion data_shadcn_ui_motion_part)a

  @doc "Renders native scrolling and a complete item index without slide state."
  def carousel(assigns) do
    label = text!(assigns.accessible_label)
    reference = text!(assigns.labelledby)

    unless (label && is_nil(reference)) || (reference && is_nil(label)),
      do: raise(ArgumentError, "Carousel requires exactly one accessible_label or labelledby")

    if reference &&
         not Regex.match?(~r/^[A-Za-z][A-Za-z0-9_.:-]*(?: [A-Za-z][A-Za-z0-9_.:-]*)*$/, reference),
       do: raise(ArgumentError, "Carousel labelledby requires valid space-separated heading IDs")

    identity = MediaContract.identity!(assigns.id, "description")

    unless assigns.snap in [:none, :proximity, :mandatory] and
             assigns.alignment in [:start, :center],
           do: raise(ArgumentError, "invalid Carousel snap or alignment")

    unless is_list(assigns.item) and assigns.item != [],
      do: raise(ArgumentError, "Carousel needs at least one item")

    items =
      Enum.map(assigns.item, fn slot ->
        name = text!(Map.get(slot, :label))

        unless name && Map.get(slot, :inner_block),
          do: raise(ArgumentError, "Carousel items need a label and HEEx body")

        %{
          slot: slot,
          label: name,
          id: MediaContract.identity!(assigns.id, Map.get(slot, :key)).item,
          rest: protect_globals(Map.get(slot, :rest, %{}), @protected),
          class: Map.get(slot, :class)
        }
      end)

    ids = Enum.map(items, & &1.id)
    unless Enum.uniq(ids) == ids, do: raise(ArgumentError, "duplicate Carousel item key")

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:name, label)
      |> assign(:heading, reference)
      |> assign(:description, text!(assigns.description))
      |> assign(:description_id, identity.caption)
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))
      |> assign(:classes, class_names([assigns.class]))

    ~H"""
    <div {@safe_rest} data-shadcn-ui data-shadcn-ui-carousel class={@classes}>
      <p :if={@description} id={@description_id}>{@description}</p>
      <div
        id={@id}
        role="region"
        tabindex="0"
        aria-label={@name}
        aria-labelledby={@heading}
        aria-describedby={@description && @description_id}
        data-shadcn-ui-carousel-scroll
        data-shadcn-ui-motion={@motion_value}
      >
        <ol role="list" data-shadcn-ui-carousel-list>
          <li
            :for={item <- @items}
            {item.rest}
            id={item.id}
            tabindex="-1"
            data-shadcn-ui-carousel-item
            class={item.class}
          >
            {render_slot(item.slot)}
          </li>
        </ol>
      </div>
      <div data-shadcn-ui-carousel-index>
        <a :for={item <- @items} href={"#" <> item.id}>{item.label}</a>
      </div>
    </div>
    """
  end

  defp text!(nil), do: nil

  defp text!(text) when is_binary(text) do
    unless String.valid?(text) and String.trim(text) != "",
      do: raise(ArgumentError, "Carousel text must be nonblank")

    String.trim(text)
  end

  defp text!(_), do: raise(ArgumentError, "Carousel text must be a string")
end
