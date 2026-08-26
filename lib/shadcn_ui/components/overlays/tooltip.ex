defmodule ShadcnUI.Components.Overlays.Tooltip do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Overlays.{OverlayContract, SupplementalContract}
  import SupplementalContract, only: [native_trigger: 1]

  @moduledoc """
  CSS-first supplemental description for one ordinary button or link.

  Use one self-closing `trigger` slot with a complete text `label`. The caller
  selects its native kind, type or destination and application attributes; the
  component only derives identity and merges `describedby` references. Disabled
  buttons remain disabled, so essential help must always be visible elsewhere.

  `text` is escaped plain text, never markup. Required labels, errors,
  instructions, status and task information belong in visible Help, Alert or
  page content. This is not an interest invoker or an Escape-dismissable overlay.
  CSS may reveal the bubble on keyboard focus or fine-pointer hover; no script,
  focus movement, touch emulation or top-layer behavior is installed.
  """

  attr :id, :string, required: true
  attr :text, :string, required: true
  attr :describedby, :string, default: nil

  attr :placement, :atom,
    values: [:block_start, :block_end, :inline_start, :inline_end],
    default: :block_end

  attr :class, :any, default: nil
  attr :rest, :global
  attr :surface_rest, :map, default: %{}

  slot :trigger, required: true do
    attr :label, :string, required: true
    attr :kind, :atom, values: [:button, :link]
    attr :type, :string
    attr :disabled, :boolean
    attr :name, :string
    attr :value, :string
    attr :form, :string
    attr :href, :string
    attr :target, :string
    attr :rel, :string
    attr :download, :any
    attr :current, :string
    attr :class, :any
    attr :rest, :map
  end

  @doc "Renders one nonfocusable tooltip and a complete caller-selected native trigger."
  def tooltip(assigns) do
    identity = OverlayContract.identity!(assigns.id)

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(:content, SupplementalContract.text!(assigns.text))
      |> assign(:native, SupplementalContract.trigger!(assigns.trigger, [:button, :link]))
      |> assign(
        :description_ids,
        SupplementalContract.descriptions!(assigns.describedby, identity.description_id)
      )
      |> assign(:placement_value, OverlayContract.placement!(assigns.placement))
      |> assign(:safe_rest, SupplementalContract.globals!(assigns.rest))
      |> assign(:safe_surface_rest, SupplementalContract.globals!(assigns.surface_rest))
      |> assign(:classes, class_names(["sui:text-xs", assigns.class]))

    ~H"""
    <span
      {@safe_rest}
      id={@identity.base_id}
      data-shadcn-ui
      data-shadcn-ui-supplemental="tooltip"
      data-placement={@placement_value}
    >
      <.native_trigger trigger={@native} id={@identity.invoker_id} describedby={@description_ids} />
      <span
        {@safe_surface_rest}
        id={@identity.description_id}
        role="tooltip"
        class={@classes}
        data-shadcn-ui
        data-shadcn-ui-supplemental-surface
      >{@content}</span>
    </span>
    """
  end
end
