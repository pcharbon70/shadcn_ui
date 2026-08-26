defmodule ShadcnUI.Components.Overlays.Popover do
  use ShadcnUI.Component

  @moduledoc """
  Native nonmodal Popover with optional CSS anchor placement.

  The browser owns open state, implicit invoker relationships, sequential focus,
  Escape, light dismiss and focus return. Manual mode does not light-dismiss or
  close on Escape. Applications own replacement, outcomes and fallback routes.
  No toggle listener, positioning engine or package JavaScript is installed.
  """

  alias ShadcnUI.Components.Overlays.OverlayContract

  attr :id, :string, required: true
  attr :mode, :atom, values: [:auto, :manual], default: :auto
  attr :action, :atom, values: [:toggle, :show, :hide], default: :toggle

  attr :placement, :atom,
    values: [:block_start, :block_end, :inline_start, :inline_end],
    default: :block_end

  attr :accessible_label, :string, default: nil
  attr :labelledby, :string, default: nil
  attr :class, :any, default: nil
  attr :trigger_class, :any, default: nil
  attr :close_class, :any, default: nil
  attr :rest, :global
  attr :trigger_rest, :map, default: %{}
  attr :surface_rest, :map, default: %{}
  attr :close_rest, :map, default: %{}

  slot :trigger, required: true
  slot :title
  slot :description
  slot :inner_block, required: true
  slot :close
  slot :fallback

  @doc """
  Renders an initially hidden native popover and a declarative button invoker.

  Supply exactly one naming source: `title`, `accessible_label`, or `labelledby`
  referencing existing caller headings. `close` is optional but recommended for
  manual mode. `action=:hide` only hides a surface opened by another caller
  invoker; it does not create a server-owned open snapshot. Trusted trigger and
  close slots must contain noninteractive labels, not nested controls.
  """
  def popover(assigns) do
    for name <- [:trigger, :title, :description, :close, :fallback] do
      count = length(Map.fetch!(assigns, name))

      if count > 1 or (name == :trigger and count != 1),
        do: raise(ArgumentError, "Popover #{name} must have one slot entry")
    end

    identity = OverlayContract.identity!(assigns.id)
    label = optional_name!(assigns.accessible_label)
    labelledby = optional_name!(assigns.labelledby)

    if Enum.count([assigns.title != [], not is_nil(label), not is_nil(labelledby)], & &1) != 1,
      do:
        raise(
          ArgumentError,
          "Popover requires exactly one title, accessible_label, or labelledby"
        )

    if labelledby, do: Enum.each(String.split(labelledby), &OverlayContract.identity!/1)

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(:native_mode, OverlayContract.popover_mode!(assigns.mode))
      |> assign(:native_action, OverlayContract.popover_action!(assigns.action))
      |> assign(:native_placement, OverlayContract.placement!(assigns.placement))
      |> assign(:label, label)
      |> assign(:title_id, if(assigns.title != [], do: identity.title_id, else: labelledby))
      |> assign(:description_id, assigns.description != [] && identity.description_id)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :id,
          :role,
          :popover,
          :open,
          :autofocus,
          :data_shadcn_ui,
          :data_shadcn_ui_popover
        ])
      )
      |> assign(
        :safe_trigger_rest,
        safe_globals!(assigns.trigger_rest, :invoker, [
          :popover,
          :aria_expanded,
          :aria_details,
          :tabindex
        ])
      )
      |> assign(
        :safe_surface_rest,
        safe_globals!(assigns.surface_rest, :popover, [
          :hidden,
          :inert,
          :tabindex,
          :aria_modal,
          :data_placement,
          :data_shadcn_ui_overlay_surface,
          :data_shadcn_ui_popover_surface
        ])
      )
      |> assign(
        :safe_close_rest,
        safe_globals!(assigns.close_rest, :close, [
          :popover,
          :disabled,
          :hidden,
          :inert,
          :tabindex,
          :aria_expanded,
          :aria_details,
          :aria_controls,
          :aria_haspopup
        ])
      )
      |> assign(
        :trigger_classes,
        class_names([
          "sui:inline-flex sui:min-h-11 sui:items-center sui:rounded-lg sui:bg-primary sui:px-4 sui:py-2 sui:text-primary-foreground",
          classes_for(:focus, :default),
          assigns.trigger_class
        ])
      )
      |> assign(
        :surface_classes,
        class_names(["sui:grid sui:gap-3 sui:p-4 sui:text-sm", assigns.class])
      )
      |> assign(
        :close_classes,
        class_names([
          "sui:inline-flex sui:min-h-11 sui:items-center sui:rounded-md sui:border sui:border-input sui:px-3 sui:py-2",
          classes_for(:focus, :default),
          assigns.close_class
        ])
      )

    ~H"""
    <div {@safe_rest} id={@identity.base_id} data-shadcn-ui data-shadcn-ui-popover>
      <button
        {@safe_trigger_rest}
        id={@identity.invoker_id}
        type="button"
        popovertarget={@identity.surface_id}
        popovertargetaction={@native_action}
        data-shadcn-ui
        class={@trigger_classes}
      >{render_slot(@trigger)}</button>
      <section
        {@safe_surface_rest}
        id={@identity.surface_id}
        popover={@native_mode}
        aria-label={@label}
        aria-labelledby={@title_id}
        aria-describedby={@description_id}
        data-shadcn-ui
        data-shadcn-ui-overlay-surface
        data-shadcn-ui-popover-surface
        data-placement={@native_placement}
        class={@surface_classes}
      >
        <h2 :if={@title != []} id={@identity.title_id} class="sui:m-0 sui:text-base sui:font-semibold">
          {render_slot(@title)}
        </h2>
        <p
          :if={@description != []}
          id={@identity.description_id}
          class="sui:m-0 sui:text-muted-foreground"
        >
          {render_slot(@description)}
        </p>
        {render_slot(@inner_block)}
        <button
          :if={@close != []}
          {@safe_close_rest}
          id={@identity.close_id}
          type="button"
          popovertarget={@identity.surface_id}
          popovertargetaction="hide"
          data-shadcn-ui
          class={@close_classes}
        >{render_slot(@close)}</button>
      </section>
      <div :if={@fallback != []} data-shadcn-ui-popover-fallback>{render_slot(@fallback)}</div>
    </div>
    """
  end

  defp optional_name!(nil), do: nil

  defp optional_name!(value) when is_binary(value) do
    case String.trim(value) do
      "" -> raise ArgumentError, "Popover names must be nonblank"
      name -> name
    end
  end

  defp optional_name!(_), do: raise(ArgumentError, "Popover names must be strings")

  defp safe_globals!(globals, owner, extra),
    do: globals |> OverlayContract.protect_globals!(owner) |> protect_globals(extra)
end
