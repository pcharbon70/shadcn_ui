defmodule ShadcnUI.Components.Foundation.Alert do
  use ShadcnUI.Component

  @moduledoc """
  Visible feedback with explicit, caller-selected announcement semantics.

  Alert renders only the current presentation. The caller owns insertion
  timing, lifecycle, dismissal, retry behavior, action handling, and command
  outcomes. A destructive visual variant never implies urgency.
  """

  @base_classes [
    "sui:grid",
    "sui:w-full",
    "sui:max-w-full",
    "sui:gap-x-3",
    "sui:rounded-lg",
    "sui:border",
    "sui:px-4",
    "sui:py-3",
    "sui:text-sm"
  ]

  @variant_classes %{
    default: ["sui:border-border", "sui:bg-background", "sui:text-foreground"],
    destructive: [
      "sui:border-destructive/30",
      "sui:bg-destructive/5",
      "sui:text-destructive"
    ]
  }

  @announcement_attributes %{
    none: {nil, nil},
    polite: {"status", "polite"},
    assertive: {"alert", "assertive"}
  }

  attr :variant, :atom, values: [:default, :destructive], default: :default
  attr :announcement, :atom, values: [:none, :polite, :assertive], default: :none
  attr :title, :string, default: nil
  attr :description, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :icon
  slot :actions

  @doc """
  Renders visible feedback without owning its lifecycle or actions.

  At least one nonblank `title` or `description` is required. Icon and actions
  slots are trusted HEEX; callers retain the native meaning and behavior of any
  nested controls.
  """
  def alert(assigns) do
    title = normalize_text(assigns.title)
    description = normalize_text(assigns.description)
    validate_visible_content!(title, description)
    {role, aria_live} = Map.fetch!(@announcement_attributes, assigns.announcement)

    assigns =
      assigns
      |> assign(:normalized_title, title)
      |> assign(:normalized_description, description)
      |> assign(:role, role)
      |> assign(:aria_live, aria_live)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:role, :aria_live, :data_shadcn_ui])
      )
      |> assign(
        :classes,
        class_names([
          @base_classes,
          if(assigns.icon == [], do: "sui:grid-cols-1", else: "sui:grid-cols-[auto_1fr]"),
          Map.fetch!(@variant_classes, assigns.variant),
          assigns.class
        ])
      )

    ~H"""
    <div
      {@safe_rest}
      data-shadcn-ui
      role={@role}
      aria-live={@aria_live}
      class={@classes}
    >
      <span
        :if={@icon != []}
        data-shadcn-ui-slot="icon"
        class="sui:mt-0.5 sui:size-4 sui:shrink-0"
      >
        {render_slot(@icon)}
      </span>
      <div data-shadcn-ui-slot="content" class="sui:min-w-0">
        <p :if={@normalized_title} data-shadcn-ui-slot="title" class="sui:font-medium">
          {@normalized_title}
        </p>
        <p
          :if={@normalized_description}
          data-shadcn-ui-slot="description"
          class={[
            "sui:break-words",
            @normalized_title && "sui:mt-0.5",
            @variant == :default && "sui:text-muted-foreground",
            @variant == :destructive && "sui:opacity-80"
          ]}
        >
          {@normalized_description}
        </p>
        <div
          :if={@actions != []}
          data-shadcn-ui-slot="actions"
          class="sui:mt-3 sui:flex sui:flex-wrap sui:items-center sui:gap-2"
        >
          {render_slot(@actions)}
        </div>
      </div>
    </div>
    """
  end

  defp validate_visible_content!(nil, nil) do
    raise ArgumentError, "alerts require a nonblank title or description"
  end

  defp validate_visible_content!(_title, _description), do: :ok

  defp normalize_text(text) when is_binary(text) do
    case String.trim(text) do
      "" -> nil
      normalized -> normalized
    end
  end

  defp normalize_text(_text), do: nil
end
