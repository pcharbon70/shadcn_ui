defmodule ShadcnUI.Components.Foundation.Badge do
  use ShadcnUI.Component

  @moduledoc """
  Compact passive labels with closed shadcn-style variants.

  Badge renders one noninteractive `span`. Its text may communicate status, but
  selection, links, dismissal, lifecycle, and other behavior belong to the
  surrounding application markup.
  """

  @base_classes [
    "sui:inline-flex",
    "sui:items-center",
    "sui:max-w-full",
    "sui:whitespace-normal",
    "sui:break-words",
    "sui:text-center",
    "sui:rounded-full",
    "sui:px-2.5",
    "sui:py-0.5",
    "sui:text-xs",
    "sui:font-medium"
  ]

  @variant_classes %{
    default: ["sui:bg-primary", "sui:text-primary-foreground"],
    secondary: ["sui:bg-secondary", "sui:text-secondary-foreground"],
    destructive: ["sui:bg-destructive", "sui:text-destructive-foreground"],
    outline: ["sui:border", "sui:border-border", "sui:bg-transparent", "sui:text-foreground"]
  }

  @interactive_keys MapSet.new(~w(
    href navigate patch method target download rel
    type disabled form formaction formenctype formmethod formnovalidate formtarget name value
    role tabindex onclick onkeydown onkeyup onpointerdown onpointerup
    phx-click phx-keydown phx-keyup phx-submit
    data-on:click data-on:keydown data-on:keyup data-on:pointerdown data-on:pointerup
  ))

  attr :variant, :atom,
    values: [:default, :secondary, :destructive, :outline],
    default: :default

  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc """
  Renders a passive inline badge.

  Use an application-owned link or button when the content must navigate,
  activate, select, or dismiss. Badge deliberately rejects interactive globals
  instead of making a `span` imitate a control.
  """
  def badge(assigns) do
    ensure_passive_globals!(assigns.rest)

    assigns =
      assign(
        assigns,
        :classes,
        class_names([
          @base_classes,
          Map.fetch!(@variant_classes, assigns.variant),
          assigns.class
        ])
      )

    ~H"""
    <span {@rest} data-shadcn-ui class={@classes}>{render_slot(@inner_block)}</span>
    """
  end

  defp ensure_passive_globals!(globals) do
    case Enum.find(Map.keys(globals), fn key ->
           normalized = key |> to_string() |> String.downcase()

           MapSet.member?(@interactive_keys, normalized) or
             String.starts_with?(normalized, ["on", "phx-click", "phx-key", "data-on:"])
         end) do
      nil -> :ok
      key -> raise ArgumentError, "Badge does not accept interactive attribute #{inspect(key)}"
    end
  end
end
