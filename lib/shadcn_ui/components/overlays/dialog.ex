defmodule ShadcnUI.Components.Overlays.Dialog do
  use ShadcnUI.Component

  @moduledoc """
  A native modal Dialog with declarative invocation and explicit exit.

  The browser owns modality, focus containment, Escape, light dismiss, and
  restoration. `initial_focus` only places native `autofocus` in the rendered
  snapshot. Applications own state, replacement, forms, commands, outcomes,
  and any reinvocation after a server-rendered subtree is replaced.
  """

  alias ShadcnUI.Components.Overlays.OverlayContract

  @size_classes %{
    small: ["sui:w-full", "sui:max-w-sm"],
    default: ["sui:w-full", "sui:max-w-lg"],
    large: ["sui:w-full", "sui:max-w-2xl"],
    full: ["sui:w-[calc(100vi-2rem)]", "sui:max-w-none"]
  }
  @alignment_classes %{
    start: ["sui:items-start", "sui:text-start"],
    center: ["sui:items-center", "sui:text-center"]
  }
  @density_classes %{
    compact: ["sui:gap-3", "sui:p-4"],
    comfortable: ["sui:gap-5", "sui:p-6"]
  }

  attr :id, :string, required: true
  attr :accessible_label, :string, default: nil
  attr :dismissal, :atom, values: [:none, :close_request, :any], default: :close_request
  attr :initial_focus, :atom, values: [:auto, :content, :close], default: :auto
  attr :size, :atom, values: [:small, :default, :large, :full], default: :default
  attr :alignment, :atom, values: [:start, :center], default: :start
  attr :density, :atom, values: [:compact, :comfortable], default: :comfortable
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
  slot :inner_block, required: true
  slot :close, required: true
  slot :fallback

  @doc """
  Renders an initially closed native `dialog` and its `show-modal` invoker.

  Supply either one `title` slot or a nonblank `accessible_label`, never both.
  `content` and `close` are the explicit autofocus choices; `auto` leaves
  initial focus selection entirely to the browser. A caller supporting browsers
  below the declarative invoker capability floor should provide `fallback`.
  """
  def dialog(assigns) do
    validate_slots!(assigns)
    validate_closed_values!(assigns)
    label = normalize_label(assigns.accessible_label)
    validate_accessible_name!(assigns.title, label)
    identity = OverlayContract.identity!(assigns.id)

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(:label, label)
      |> assign(:closedby, OverlayContract.dismissal_policy!(assigns.dismissal))
      |> assign(:title_id, assigns.title != [] && identity.title_id)
      |> assign(:description_id, assigns.description != [] && identity.description_id)
      |> assign(:content_id, "#{identity.base_id}-content")
      |> assign(:content_focus?, assigns.initial_focus == :content)
      |> assign(:close_focus?, assigns.initial_focus == :close)
      |> assign(:initial_focus_target, initial_focus_target(assigns.initial_focus, identity))
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:id, :role, :data_shadcn_ui, :data_shadcn_ui_dialog])
      )
      |> assign(
        :safe_trigger_rest,
        OverlayContract.protect_globals!(assigns.trigger_rest, :invoker)
      )
      |> assign(:safe_dialog_rest, OverlayContract.protect_globals!(assigns.dialog_rest, :dialog))
      |> assign(:safe_content_rest, protect_content_globals!(assigns.content_rest))
      |> assign(:safe_close_rest, OverlayContract.protect_globals!(assigns.close_rest, :close))
      |> assign(:surface_classes, class_names([@size_classes[assigns.size], assigns.class]))
      |> assign(
        :content_classes,
        class_names([
          "sui:grid sui:min-w-0 sui:max-w-full",
          @alignment_classes[assigns.alignment],
          @density_classes[assigns.density],
          assigns.content_class
        ])
      )
      |> assign(
        :trigger_classes,
        class_names([
          "sui:inline-flex sui:min-h-9 sui:items-center sui:justify-center sui:rounded-lg",
          "sui:bg-primary sui:px-4 sui:py-2 sui:text-sm sui:font-medium sui:text-primary-foreground",
          classes_for(:focus, :default),
          assigns.trigger_class
        ])
      )
      |> assign(
        :close_classes,
        class_names([
          "sui:inline-flex sui:min-h-9 sui:items-center sui:justify-center sui:rounded-lg",
          "sui:border sui:border-input sui:bg-background sui:px-4 sui:py-2 sui:text-sm sui:font-medium sui:text-foreground",
          classes_for(:focus, :default),
          assigns.close_class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      id={@identity.base_id}
      data-shadcn-ui
      data-shadcn-ui-dialog
      data-dismissal={@closedby}
      data-initial-focus={@initial_focus}
    >
      <button
        {@safe_trigger_rest}
        id={@identity.invoker_id}
        type="button"
        command={OverlayContract.dialog_command!(:show_modal)}
        commandfor={@identity.surface_id}
        aria-haspopup="dialog"
        aria-controls={@identity.surface_id}
        data-shadcn-ui
        data-shadcn-ui-dialog-invoker
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
        data-shadcn-ui-dialog-surface
        data-size={@size}
        data-initial-focus-target={@initial_focus_target}
        class={@surface_classes}
      >
        <div
          {@safe_content_rest}
          id={if(@content_focus?, do: @identity.initial_focus_id, else: @content_id)}
          tabindex={@content_focus? && "-1"}
          autofocus={@content_focus?}
          data-shadcn-ui-dialog-content
          class={@content_classes}
        >
          <header :if={@title != [] or @description != []} class="sui:grid sui:gap-2">
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
          </header>

          <div data-shadcn-ui-dialog-body class="sui:min-w-0 sui:max-w-full">
            {render_slot(@inner_block)}
          </div>

          <footer class="sui:flex sui:flex-wrap sui:justify-end sui:gap-2">
            <button
              {@safe_close_rest}
              id={@identity.close_id}
              type="button"
              command={OverlayContract.dialog_command!(:close)}
              commandfor={@identity.surface_id}
              autofocus={@close_focus?}
              data-shadcn-ui
              data-shadcn-ui-dialog-close
              class={@close_classes}
            >
              {render_slot(@close)}
            </button>
          </footer>
        </div>
      </dialog>

      <div :if={@fallback != []} data-shadcn-ui-dialog-fallback>
        {render_slot(@fallback)}
      </div>
    </div>
    """
  end

  defp validate_slots!(assigns) do
    for {name, slots, required?} <- [
          {:trigger, assigns.trigger, true},
          {:title, assigns.title, false},
          {:description, assigns.description, false},
          {:close, assigns.close, true},
          {:fallback, assigns.fallback, false}
        ] do
      count = length(slots)

      if count > 1 or (required? and count != 1) do
        raise ArgumentError, "Dialog #{name} must contain exactly one slot entry"
      end
    end
  end

  defp validate_closed_values!(assigns) do
    _ = Map.fetch!(@size_classes, assigns.size)
    _ = Map.fetch!(@alignment_classes, assigns.alignment)
    _ = Map.fetch!(@density_classes, assigns.density)
    _ = Map.fetch!(%{auto: true, content: true, close: true}, assigns.initial_focus)
    :ok
  end

  defp validate_accessible_name!([], nil) do
    raise ArgumentError, "Dialog requires one title or a nonblank accessible_label"
  end

  defp validate_accessible_name!(title, label) when title != [] and not is_nil(label) do
    raise ArgumentError, "Dialog accepts a title or accessible_label, not both"
  end

  defp validate_accessible_name!(_title, _label), do: :ok

  defp normalize_label(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      label -> label
    end
  end

  defp normalize_label(_value), do: nil

  defp initial_focus_target(:auto, _identity), do: nil
  defp initial_focus_target(:content, identity), do: identity.initial_focus_id
  defp initial_focus_target(:close, identity), do: identity.close_id

  defp protect_content_globals!(globals) when is_map(globals) and not is_struct(globals) do
    globals
    |> OverlayContract.protect_globals!(:initial_focus)
    |> protect_globals([:data_shadcn_ui_dialog_content])
  end

  defp protect_content_globals!(globals) do
    raise ArgumentError, "Dialog content_rest must be a plain map, got: #{inspect(globals)}"
  end
end
