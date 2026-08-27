defmodule ShadcnUI.Components.Overlays.AlertDialog do
  use ShadcnUI.Component

  @moduledoc """
  A consequential native Alert Dialog with least-destructive initial focus.

  The component renders warning and cancellation structure only. The caller's
  action slot retains native button or form semantics and owns authorization,
  validation, CSRF, submission, pending state, retry, persistence, outcomes,
  and result announcements.
  """

  alias ShadcnUI.Components.Overlays.OverlayContract

  @size_classes %{
    small: ["sui:w-full", "sui:max-w-sm"],
    default: ["sui:w-full", "sui:max-w-lg"],
    large: ["sui:w-full", "sui:max-w-2xl"]
  }

  attr :id, :string, required: true
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :class, :any, default: nil
  attr :trigger_class, :any, default: nil
  attr :content_class, :any, default: nil
  attr :cancel_class, :any, default: nil
  attr :rest, :global
  attr :trigger_rest, :map, default: %{}
  attr :dialog_rest, :map, default: %{}
  attr :content_rest, :map, default: %{}
  attr :cancel_rest, :map, default: %{}
  attr :action_rest, :map, default: %{}

  slot :trigger, required: true
  slot :title, required: true
  slot :description, required: true
  slot :inner_block
  slot :cancel, required: true
  slot :action, required: true
  slot :fallback

  @doc """
  Renders an initially closed native `dialog` with `role="alertdialog"`.

  Cancellation always uses `closedby="closerequest"` and native `autofocus`.
  The action slot is trusted caller HEEx; ShadcnUI does not wrap, activate,
  submit, disable, authorize, or report it.
  """
  def alert_dialog(assigns) do
    validate_slots!(assigns)
    _ = Map.fetch!(@size_classes, assigns.size)
    identity = OverlayContract.identity!(assigns.id)

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :id,
          :role,
          :data_shadcn_ui,
          :data_shadcn_ui_alert_dialog
        ])
      )
      |> assign(
        :safe_trigger_rest,
        OverlayContract.protect_globals!(assigns.trigger_rest, :invoker)
      )
      |> assign(:safe_dialog_rest, protect_dialog_globals!(assigns.dialog_rest))
      |> assign(:safe_content_rest, protect_content_globals!(assigns.content_rest))
      |> assign(:safe_cancel_rest, protect_cancel_globals!(assigns.cancel_rest))
      |> assign(:safe_action_rest, protect_action_globals!(assigns.action_rest))
      |> assign(:surface_classes, class_names([@size_classes[assigns.size], assigns.class]))
      |> assign(
        :content_classes,
        class_names([
          "sui:grid sui:min-w-0 sui:max-w-full sui:items-start sui:gap-5 sui:p-6 sui:text-start",
          assigns.content_class
        ])
      )
      |> assign(
        :trigger_classes,
        class_names([
          "sui:inline-flex sui:min-h-9 sui:items-center sui:justify-center sui:rounded-lg",
          "sui:bg-destructive sui:px-4 sui:py-2 sui:text-sm sui:font-medium sui:text-destructive-foreground",
          classes_for(:focus, :default),
          assigns.trigger_class
        ])
      )
      |> assign(
        :cancel_classes,
        class_names([
          "sui:inline-flex sui:min-h-9 sui:items-center sui:justify-center sui:rounded-lg",
          "sui:border sui:border-input sui:bg-background sui:px-4 sui:py-2 sui:text-sm sui:font-medium sui:text-foreground",
          classes_for(:focus, :default),
          assigns.cancel_class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      id={@identity.base_id}
      data-shadcn-ui
      data-shadcn-ui-alert-dialog
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
        data-shadcn-ui-alert-dialog-invoker
        class={@trigger_classes}
      >
        {render_slot(@trigger)}
      </button>

      <dialog
        {@safe_dialog_rest}
        id={@identity.surface_id}
        role="alertdialog"
        closedby="closerequest"
        aria-labelledby={@identity.title_id}
        aria-describedby={@identity.description_id}
        data-shadcn-ui
        data-shadcn-ui-overlay-surface
        data-shadcn-ui-dialog-surface
        data-shadcn-ui-alert-dialog-surface
        data-size={@size}
        data-initial-focus-target={@identity.close_id}
        class={@surface_classes}
      >
        <div
          {@safe_content_rest}
          id={"#{@identity.base_id}-content"}
          data-shadcn-ui-dialog-content
          data-shadcn-ui-alert-dialog-content
          class={@content_classes}
        >
          <header class="sui:grid sui:gap-2">
            <h2 id={@identity.title_id} class="sui:text-lg sui:font-semibold">
              {render_slot(@title)}
            </h2>
            <div id={@identity.description_id} class="sui:text-sm sui:text-muted-foreground">
              {render_slot(@description)}
            </div>
          </header>

          <div
            :if={@inner_block != []}
            data-shadcn-ui-alert-dialog-body
            class="sui:min-w-0 sui:max-w-full"
          >
            {render_slot(@inner_block)}
          </div>

          <footer class="sui:flex sui:flex-wrap sui:justify-end sui:gap-2">
            <button
              {@safe_cancel_rest}
              id={@identity.close_id}
              type="button"
              command={OverlayContract.dialog_command!(:close)}
              commandfor={@identity.surface_id}
              autofocus
              data-shadcn-ui
              data-shadcn-ui-dialog-close
              data-shadcn-ui-alert-dialog-cancel
              class={@cancel_classes}
            >
              {render_slot(@cancel)}
            </button>
            <div
              {@safe_action_rest}
              id={"#{@identity.base_id}-action"}
              data-shadcn-ui-alert-dialog-action
            >
              {render_slot(@action)}
            </div>
          </footer>
        </div>
      </dialog>

      <div :if={@fallback != []} data-shadcn-ui-alert-dialog-fallback>
        {render_slot(@fallback)}
      </div>
    </div>
    """
  end

  defp validate_slots!(assigns) do
    for {name, slots, required?} <- [
          {:trigger, assigns.trigger, true},
          {:title, assigns.title, true},
          {:description, assigns.description, true},
          {:inner_block, assigns.inner_block, false},
          {:cancel, assigns.cancel, true},
          {:action, assigns.action, true},
          {:fallback, assigns.fallback, false}
        ] do
      count = length(slots)

      if count > 1 or (required? and count != 1) do
        raise ArgumentError, "Alert Dialog #{name} must contain exactly one slot entry"
      end
    end
  end

  defp protect_dialog_globals!(globals) do
    globals
    |> OverlayContract.protect_globals!(:dialog)
    |> protect_globals([:data_shadcn_ui_alert_dialog_surface])
  end

  defp protect_content_globals!(globals) when is_map(globals) and not is_struct(globals) do
    globals
    |> OverlayContract.protect_globals!(:initial_focus)
    |> protect_globals([:data_shadcn_ui_dialog_content, :data_shadcn_ui_alert_dialog_content])
  end

  defp protect_content_globals!(globals) do
    raise ArgumentError, "Alert Dialog content_rest must be a plain map, got: #{inspect(globals)}"
  end

  defp protect_cancel_globals!(globals) do
    globals
    |> OverlayContract.protect_globals!(:close)
    |> protect_globals([:disabled, :data_shadcn_ui_alert_dialog_cancel])
  end

  defp protect_action_globals!(globals) when is_map(globals) and not is_struct(globals) do
    protect_globals(globals, [:id, :role, :data_shadcn_ui_alert_dialog_action])
  end

  defp protect_action_globals!(globals) do
    raise ArgumentError, "Alert Dialog action_rest must be a plain map, got: #{inspect(globals)}"
  end
end
