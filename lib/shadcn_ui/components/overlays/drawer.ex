defmodule ShadcnUI.Components.Overlays.Drawer do
  use ShadcnUI.Component

  @moduledoc """
  A native modal dialog presented at a logical edge, without drag gestures.

  `edge` selects rendered presentation, not responsive application state.
  Native commands, focus containment, dismissal, and restoration belong to the
  browser. Applications own form results, authorization, replacement, and any
  reinvocation. Supply an ordinary `fallback` destination for unsupported invokers.
  """

  alias ShadcnUI.Components.Overlays.OverlayContract

  @edges %{start: "start", end: "end", bottom: "bottom"}
  @sizes %{small: "small", default: "default", large: "large"}
  @focus %{auto: true, content: true, close: true}

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :edge, :atom, values: [:start, :end, :bottom], default: :end
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :dismissal, :atom, values: [:none, :close_request, :any], default: :close_request
  attr :initial_focus, :atom, values: [:auto, :content, :close], default: :auto
  attr :class, :any, default: nil
  attr :trigger_class, :any, default: nil
  attr :content_class, :any, default: nil
  attr :close_class, :any, default: nil
  attr :rest, :global
  attr :trigger_rest, :map, default: %{}
  attr :dialog_rest, :map, default: %{}
  attr :content_rest, :map, default: %{}
  attr :close_rest, :map, default: %{}

  slot :trigger, required: true
  slot :title
  slot :description
  slot :header
  slot :inner_block, required: true
  slot :footer
  slot :close, required: true
  slot :fallback

  @doc """
  Renders a closed native modal Drawer with a required title or accessible label.

  Keep header and footer concise; put long content in the body. `initial_focus`
  may target the body (`content`), close button, or native automatic selection.
  Body globals are forwarded to the named keyboard-focusable content region;
  unrelated native and transport attributes pass through the other `*_rest` maps.
  Caller slots must not introduce nested modals, duplicate autofocus, or disable
  the explicit exit. No form, navigation landmark, or result is invented.
  """
  def drawer(assigns) do
    for name <- [:trigger, :title, :description, :header, :footer, :close, :fallback] do
      count = length(Map.fetch!(assigns, name))

      if count > 1 or (name in [:trigger, :close] and count != 1) do
        raise ArgumentError, "Drawer #{name} must contain exactly one slot entry"
      end
    end

    label = if is_binary(assigns.accessible_label), do: String.trim(assigns.accessible_label)
    label = if label in [nil, ""], do: nil, else: label

    if (assigns.title == [] and is_nil(label)) or (assigns.title != [] and not is_nil(label)) do
      raise ArgumentError, "Drawer requires one title or nonblank accessible_label, not both"
    end

    identity = OverlayContract.identity!(assigns.id)
    _ = Map.fetch!(@focus, assigns.initial_focus)

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(:label, label)
      |> assign(:edge_value, Map.fetch!(@edges, assigns.edge))
      |> assign(:size_value, Map.fetch!(@sizes, assigns.size))
      |> assign(:closedby, OverlayContract.dismissal_policy!(assigns.dismissal))
      |> assign(:title_id, assigns.title != [] && identity.title_id)
      |> assign(:description_id, assigns.description != [] && identity.description_id)
      |> assign(
        :body_id,
        if(assigns.initial_focus == :content,
          do: identity.initial_focus_id,
          else: "#{identity.base_id}-content"
        )
      )
      |> assign(
        :focus_target,
        case assigns.initial_focus do
          :auto -> nil
          :content -> identity.initial_focus_id
          :close -> identity.close_id
        end
      )
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:id, :role, :data_shadcn_ui, :data_shadcn_ui_drawer])
      )
      |> assign(
        :safe_trigger_rest,
        OverlayContract.protect_globals!(assigns.trigger_rest, :invoker)
      )
      |> assign(
        :safe_dialog_rest,
        safe_globals!(assigns.dialog_rest, :dialog, [
          :tabindex,
          :aria_modal,
          :popover,
          :hidden,
          :inert,
          :data_edge,
          :data_shadcn_ui_drawer_surface
        ])
      )
      |> assign(
        :safe_content_rest,
        safe_globals!(assigns.content_rest, :initial_focus, [
          :hidden,
          :inert,
          :data_shadcn_ui_drawer_body
        ])
      )
      |> assign(
        :safe_close_rest,
        safe_globals!(assigns.close_rest, :close, [:disabled, :hidden, :inert, :aria_disabled])
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
        :close_classes,
        class_names([
          "sui:inline-flex sui:min-h-11 sui:items-center sui:rounded-lg sui:border sui:border-input sui:bg-background sui:px-4 sui:py-2 sui:text-foreground",
          classes_for(:focus, :default),
          assigns.close_class
        ])
      )
      |> assign(
        :body_classes,
        class_names([
          "sui:min-w-0 sui:max-w-full",
          classes_for(:focus, :default),
          assigns.content_class
        ])
      )

    ~H"""
    <div {@safe_rest} id={@identity.base_id} data-shadcn-ui data-shadcn-ui-drawer>
      <button
        {@safe_trigger_rest}
        id={@identity.invoker_id}
        type="button"
        command={OverlayContract.dialog_command!(:show_modal)}
        commandfor={@identity.surface_id}
        aria-haspopup="dialog"
        aria-controls={@identity.surface_id}
        data-shadcn-ui
        class={@trigger_classes}
      >
        {render_slot(@trigger)}
      </button>
      <dialog
        {@safe_dialog_rest}
        id={@identity.surface_id}
        closedby={@closedby}
        aria-labelledby={@title_id}
        aria-label={@label}
        aria-describedby={@description_id}
        data-shadcn-ui
        data-shadcn-ui-overlay-surface
        data-shadcn-ui-drawer-surface
        data-edge={@edge_value}
        data-size={@size_value}
        data-initial-focus-target={@focus_target}
        class={class_names(@class)}
      >
        <header data-shadcn-ui-drawer-header>
          <div class="sui:min-w-0">
            <h2 :if={@title != []} id={@identity.title_id} class="sui:text-lg sui:font-semibold">
              {render_slot(@title)}
            </h2>
            <div
              :if={@description != []}
              id={@identity.description_id}
              class="sui:text-sm sui:text-muted-foreground"
            >
              {render_slot(@description)}
            </div>
            {render_slot(@header)}
          </div>
          <button
            {@safe_close_rest}
            id={@identity.close_id}
            type="button"
            command={OverlayContract.dialog_command!(:close)}
            commandfor={@identity.surface_id}
            autofocus={@initial_focus == :close}
            data-shadcn-ui
            class={@close_classes}
          >
            {render_slot(@close)}
          </button>
        </header>
        <div
          {@safe_content_rest}
          id={@body_id}
          role="region"
          aria-labelledby={@title_id}
          aria-label={@label}
          tabindex="0"
          autofocus={@initial_focus == :content}
          data-shadcn-ui
          data-shadcn-ui-drawer-body
          class={@body_classes}
        >
          {render_slot(@inner_block)}
        </div>
        <footer :if={@footer != []} data-shadcn-ui-drawer-footer>
          {render_slot(@footer)}
        </footer>
      </dialog>
      <div :if={@fallback != []} data-shadcn-ui-drawer-fallback>{render_slot(@fallback)}</div>
    </div>
    """
  end

  defp safe_globals!(globals, owner, extra) do
    globals |> OverlayContract.protect_globals!(owner) |> protect_globals(extra)
  end
end
