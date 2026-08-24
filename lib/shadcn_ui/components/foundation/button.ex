defmodule ShadcnUI.Components.Foundation.Button do
  use ShadcnUI.Component

  @moduledoc """
  Native button actions with closed shadcn-style variants and sizes.

  Button renders one native `button`. The caller owns activation, submission,
  duplicate prevention, authorization, request lifecycle, and command outcomes.
  `loading` changes only the rendered busy presentation and never disables the
  button automatically.
  """

  @base_classes [
    "sui:inline-flex",
    "sui:cursor-pointer",
    "sui:items-center",
    "sui:justify-center",
    "sui:gap-2",
    "sui:whitespace-nowrap",
    "sui:rounded-lg",
    "sui:text-sm",
    "sui:font-medium"
  ]

  @variant_classes %{
    default: [
      "sui:bg-primary",
      "sui:text-primary-foreground",
      "sui:transition-opacity",
      "sui:hover:opacity-90"
    ],
    secondary: [
      "sui:bg-secondary",
      "sui:text-secondary-foreground",
      "sui:transition-colors",
      "sui:hover:bg-accent",
      "sui:hover:text-accent-foreground"
    ],
    destructive: [
      "sui:bg-destructive",
      "sui:text-destructive-foreground",
      "sui:transition-opacity",
      "sui:hover:opacity-90"
    ],
    outline: [
      "sui:border",
      "sui:border-input",
      "sui:bg-background",
      "sui:text-foreground",
      "sui:transition-colors",
      "sui:hover:bg-accent",
      "sui:hover:text-accent-foreground"
    ],
    ghost: [
      "sui:bg-transparent",
      "sui:text-foreground",
      "sui:transition-colors",
      "sui:hover:bg-accent",
      "sui:hover:text-accent-foreground"
    ],
    link: [
      "sui:bg-transparent",
      "sui:text-primary",
      "sui:underline-offset-4",
      "sui:transition-colors",
      "sui:hover:underline"
    ]
  }

  @loading_classes ["sui:cursor-wait", "sui:opacity-70"]

  attr :type, :string, values: ~w(button submit reset), default: "button"

  attr :variant, :atom,
    values: [:default, :secondary, :destructive, :outline, :ghost, :link],
    default: :default

  attr :size, :atom, values: [:small, :default, :large, :icon], default: :default
  attr :disabled, :boolean, default: false
  attr :loading, :boolean, default: false

  attr :accessible_label, :string,
    default: nil,
    doc: "Accessible name override; required and nonblank for icon-only buttons."

  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(autofocus form name value)

  slot :leading
  slot :inner_block, required: true
  slot :trailing

  @doc """
  Renders a native button.

  Leading and trailing slots are trusted HEEX regions. Callers should mark a
  purely decorative icon `aria-hidden="true"`. Icon-sized buttons require an
  explicit nonblank `accessible_label`.
  """
  def button(assigns) do
    validate_accessible_name!(assigns)

    assigns =
      assigns
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :type,
          :disabled,
          :role,
          :aria_label,
          :aria_busy,
          :data_loading,
          :data_shadcn_ui
        ])
      )
      |> assign(
        :classes,
        class_names([
          @base_classes,
          Map.fetch!(@variant_classes, assigns.variant),
          classes_for(:size, assigns.size),
          classes_for(:focus, :default),
          classes_for(:disabled, :default),
          assigns.loading && @loading_classes,
          assigns.class
        ])
      )
      |> assign(:normalized_accessible_label, normalize_label(assigns.accessible_label))
      |> assign(:loading_state, assigns.loading && "true")

    ~H"""
    <button
      {@safe_rest}
      data-shadcn-ui
      data-loading={@loading_state}
      type={@type}
      disabled={@disabled}
      aria-label={@normalized_accessible_label}
      aria-busy={@loading_state}
      class={@classes}
    >
      <span :if={@leading != []} data-shadcn-ui-slot="leading">{render_slot(@leading)}</span>
      {render_slot(@inner_block)}
      <span :if={@trailing != []} data-shadcn-ui-slot="trailing">{render_slot(@trailing)}</span>
    </button>
    """
  end

  defp validate_accessible_name!(%{size: :icon, accessible_label: label}) do
    if is_nil(normalize_label(label)) do
      raise ArgumentError, "icon-only buttons require a nonblank accessible_label"
    end
  end

  defp validate_accessible_name!(_assigns), do: :ok

  defp normalize_label(label) when is_binary(label) do
    case String.trim(label) do
      "" -> nil
      normalized -> normalized
    end
  end

  defp normalize_label(_label), do: nil
end
