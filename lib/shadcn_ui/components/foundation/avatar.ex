defmodule ShadcnUI.Components.Foundation.Avatar do
  use ShadcnUI.Component

  @moduledoc """
  Initials-first identity presentation with an optional caller-owned image.

  Applications own image URLs, privacy, caching, loading, failure policy,
  uploads, and identity records. Avatar performs no lookup or image lifecycle
  handling.
  """

  @base_classes [
    "sui:relative",
    "sui:inline-flex",
    "sui:shrink-0",
    "sui:items-center",
    "sui:justify-center",
    "sui:overflow-hidden",
    "sui:rounded-full",
    "sui:bg-muted",
    "sui:font-medium",
    "sui:text-muted-foreground"
  ]

  @size_classes %{
    small: ["sui:size-8", "sui:text-xs"],
    default: ["sui:size-9", "sui:text-xs"],
    large: ["sui:size-12", "sui:text-sm"]
  }

  @stack_classes %{
    none: [],
    first: ["sui:border-2", "sui:border-background"],
    middle: ["sui:-ml-2", "sui:border-2", "sui:border-background"],
    last: ["sui:-ml-2", "sui:border-2", "sui:border-background"]
  }

  attr :initials, :string, required: true
  attr :image_src, :string, default: nil
  attr :image_alt, :string, default: nil
  attr :size, :atom, values: [:small, :default, :large], default: :default
  attr :stack_position, :atom, values: [:none, :first, :middle, :last], default: :none
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders stable initials with an optional image overlay.

  `image_src` and a nonblank `image_alt` must be provided together. When an
  image is present its alternative text supplies the accessible name and the
  visible initials are hidden from assistive technology to avoid duplication.
  """
  def avatar(assigns) do
    initials = normalize_required!(assigns.initials, "initials")
    image_src = normalize_optional(assigns.image_src)
    image_alt = normalize_optional(assigns.image_alt)
    validate_image_pair!(image_src, image_alt)

    assigns =
      assigns
      |> assign(:normalized_initials, initials)
      |> assign(:normalized_image_src, image_src)
      |> assign(:normalized_image_alt, image_alt)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:role, :aria_label, :aria_hidden, :data_shadcn_ui])
      )
      |> assign(
        :classes,
        class_names([
          @base_classes,
          Map.fetch!(@size_classes, assigns.size),
          Map.fetch!(@stack_classes, assigns.stack_position),
          assigns.class
        ])
      )

    ~H"""
    <span {@safe_rest} data-shadcn-ui class={@classes}>
      <span data-shadcn-ui-slot="initials" aria-hidden={@normalized_image_src && "true"}>
        {@normalized_initials}
      </span>
      <img
        :if={@normalized_image_src}
        data-shadcn-ui-slot="image"
        src={@normalized_image_src}
        alt={@normalized_image_alt}
        class="sui:absolute sui:inset-0 sui:size-full sui:rounded-full sui:object-cover"
      />
    </span>
    """
  end

  defp validate_image_pair!(nil, nil), do: :ok
  defp validate_image_pair!(src, alt) when is_binary(src) and is_binary(alt), do: :ok

  defp validate_image_pair!(_src, _alt) do
    raise ArgumentError, "image_src and a nonblank image_alt must be provided together"
  end

  defp normalize_required!(value, name) do
    case normalize_optional(value) do
      nil -> raise ArgumentError, "#{name} must be nonblank"
      normalized -> normalized
    end
  end

  defp normalize_optional(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      normalized -> normalized
    end
  end

  defp normalize_optional(_value), do: nil
end
