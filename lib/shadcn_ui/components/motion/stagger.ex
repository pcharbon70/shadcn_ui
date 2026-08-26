defmodule ShadcnUI.Components.Motion.Stagger do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Media.MediaContract
  alias ShadcnUI.Components.Motion.MotionContract

  @moduledoc """
  Complete keyed caller content with optional bounded render-time presentation.

  Requires a stable `id` and keyed `item` slots. `as: :div` (default) renders
  ordinary div wrappers, not an inferred list; `:ul` / `:ol` use native li items.
  Item slots accept `class` and unrelated `rest` globals and preserve trusted
  HEEx links/forms in document order. No content is cloned.

  Effect defaults to `:none`, with opt-in `:fade` / `:rise`. Preset `:quick`
  uses 150ms duration and 50ms intervals; `:default` uses 250ms and 75ms.
  Only items whose delay plus duration fits in 1000ms animate; excess items
  immediately retain their baseline. Content starts visible (never opacity zero),
  focus cancels the effect, and removing styles restores fully visible content.

  Motion `:none`, ancestor `data-shadcn-motion="reduce"` and OS reduced motion
  override effects. Finite work may finish offscreen. There is no observer,
  viewport-enter trigger, persistent replay tracking or animation-once guarantee.
  Rendering/replacement or removing and restoring suppression can replay CSS;
  callers own patch boundaries, native form values and any restoration.
  """

  attr :id, :string, required: true
  attr :as, :atom, values: [:div, :ul, :ol], default: :div
  attr :effect, :atom, values: [:none, :fade, :rise], default: :none
  attr :preset, :atom, values: [:quick, :default], default: :default
  attr :motion, :atom, values: [:system, :none], default: :system
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :key, :string, required: true
    attr :class, :any
    attr :rest, :map
  end

  @protected ~w(id tag_name name role hidden inert aria_hidden aria_live style data_shadcn_ui data_shadcn_ui_stagger data_shadcn_ui_stagger_item data_shadcn_ui_motion data_shadcn_ui_motion_part data_shadcn_ui_effect data_shadcn_ui_animated)a

  @doc "Renders visible ordered slot content with an optional finite entrance effect."
  def stagger(assigns) do
    MediaContract.identity!(assigns.id, "root")
    MotionContract.stagger_item!(0, assigns.preset)

    unless assigns.as in [:div, :ul, :ol] and assigns.effect in [:none, :fade, :rise],
      do: raise(ArgumentError, "invalid Stagger wrapper or effect")

    unless is_list(assigns.item) and assigns.item != [],
      do: raise(ArgumentError, "Stagger requires keyed item slots")

    items =
      assigns.item
      |> Enum.with_index()
      |> Enum.map(fn {slot, index} ->
        unless Map.get(slot, :inner_block), do: raise(ArgumentError, "Stagger item requires HEEx")
        timing = MotionContract.stagger_item!(index, assigns.preset)

        %{
          slot: slot,
          id: MediaContract.identity!(assigns.id, Map.get(slot, :key)).item,
          animated: timing.animated and assigns.effect != :none,
          style:
            "--shadcn-ui-stagger-duration:#{timing.duration_ms}ms;--shadcn-ui-stagger-delay:#{timing.delay_ms}ms",
          class: Map.get(slot, :class),
          rest: protect_globals(Map.get(slot, :rest, %{}), @protected)
        }
      end)

    ids = Enum.map(items, & &1.id)
    unless ids == Enum.uniq(ids), do: raise(ArgumentError, "duplicate Stagger key")

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:tag, Atom.to_string(assigns.as))
      |> assign(:item_tag, if(assigns.as == :div, do: "div", else: "li"))
      |> assign(:list_role, if(assigns.as == :div, do: nil, else: "list"))
      |> assign(:motion_value, MotionContract.preference!(assigns.motion))
      |> assign(:safe_rest, protect_globals(assigns.rest, @protected))

    ~H"""
    <.dynamic_tag
      tag_name={@tag}
      {@safe_rest}
      id={@id}
      role={@list_role}
      data-shadcn-ui
      data-shadcn-ui-stagger
      data-shadcn-ui-motion={@motion_value}
      data-shadcn-ui-effect={@effect}
      class={class_names([@class])}
    >
      <.dynamic_tag
        :for={item <- @items}
        tag_name={@item_tag}
        {item.rest}
        id={item.id}
        class={class_names([item.class])}
        data-shadcn-ui-stagger-item
        data-shadcn-ui-motion-part="item"
        data-shadcn-ui-animated={to_string(item.animated)}
        style={item.style}
      >
        {render_slot(item.slot)}
      </.dynamic_tag>
    </.dynamic_tag>
    """
  end
end
