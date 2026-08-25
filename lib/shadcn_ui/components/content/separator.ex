defmodule ShadcnUI.Components.Content.Separator do
  use ShadcnUI.Component

  @moduledoc """
  Semantic or explicitly decorative separation between caller-owned regions.

  Semantic mode renders a native `hr`. Decorative mode renders a nonsemantic
  element hidden from accessibility APIs. Orientation controls presentation;
  applications remain responsible for choosing whether a boundary carries
  document meaning.
  """

  @base_classes ["sui:shrink-0", "sui:border-0", "sui:bg-border"]

  @orientation_classes %{
    horizontal: ["sui:h-px", "sui:w-full"],
    vertical: ["sui:h-full", "sui:min-h-4", "sui:w-px"]
  }

  @modes %{semantic: true, decorative: true}

  attr :mode, :atom, values: [:semantic, :decorative], default: :semantic
  attr :orientation, :atom, values: [:horizontal, :vertical], default: :horizontal
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders one semantic or explicitly decorative separator."
  def separator(assigns) do
    _ = Map.fetch!(@modes, assigns.mode)

    assigns =
      assigns
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :role,
          :aria_hidden,
          :aria_orientation,
          :data_shadcn_ui,
          :data_shadcn_ui_separator,
          :data_orientation
        ])
      )
      |> assign(
        :classes,
        class_names([
          @base_classes,
          Map.fetch!(@orientation_classes, assigns.orientation),
          assigns.class
        ])
      )

    ~H"""
    <hr
      :if={@mode == :semantic}
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-separator
      data-orientation={@orientation}
      aria-orientation={@orientation}
      class={@classes}
    />
    <div
      :if={@mode == :decorative}
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-separator
      data-orientation={@orientation}
      aria-hidden="true"
      class={@classes}
    >
    </div>
    """
  end
end
