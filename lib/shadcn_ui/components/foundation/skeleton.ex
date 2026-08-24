defmodule ShadcnUI.Components.Foundation.Skeleton do
  use ShadcnUI.Component

  @moduledoc """
  Decorative loading-shape presentation with a calm reduced-motion fallback.

  Applications own loading detection, announcements, replacement timing,
  errors, and content layout. Label a meaningful loading region outside the
  Skeleton component.
  """

  @base_classes ["sui:block", "sui:max-w-full", "sui:shrink-0", "sui:bg-muted"]

  @geometry_classes %{
    rectangle: %{
      small: ["sui:h-8", "sui:w-full", "sui:rounded-md"],
      default: ["sui:h-12", "sui:w-full", "sui:rounded-md"],
      large: ["sui:h-20", "sui:w-full", "sui:rounded-lg"]
    },
    circle: %{
      small: ["sui:size-8", "sui:rounded-full"],
      default: ["sui:size-10", "sui:rounded-full"],
      large: ["sui:size-12", "sui:rounded-full"]
    },
    text: %{
      small: ["sui:h-3", "sui:w-1/2", "sui:rounded-sm"],
      default: ["sui:h-3.5", "sui:w-2/3", "sui:rounded-md"],
      large: ["sui:h-4", "sui:w-full", "sui:rounded-md"]
    }
  }

  attr :shape, :atom, values: [:rectangle, :circle, :text], default: :rectangle
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :pulse, :boolean, default: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders one assistive-technology-hidden placeholder.

  `shape` and `size` are visual layout guidance only. The component never
  announces loading, labels a region, or controls when real content replaces
  the placeholder.
  """
  def skeleton(assigns) do
    assigns =
      assigns
      |> assign(:safe_rest, passive_globals(assigns.rest))
      |> assign(:pulse_state, assigns.pulse && "true")
      |> assign(
        :classes,
        class_names([
          @base_classes,
          @geometry_classes |> Map.fetch!(assigns.shape) |> Map.fetch!(assigns.size),
          assigns.pulse && classes_for(:motion, :pulse),
          assigns.class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-skeleton
      data-pulse={@pulse_state}
      aria-hidden="true"
      class={@classes}
    >
    </div>
    """
  end

  defp passive_globals(globals) do
    Map.reject(globals, fn {key, _value} ->
      key = key |> to_string() |> String.replace("_", "-")

      key in ~w(role tabindex href aria-hidden data-shadcn-ui data-shadcn-ui-skeleton data-pulse) or
        String.starts_with?(key, ["aria-", "phx-", "data-on:", "data-on-"])
    end)
  end
end
