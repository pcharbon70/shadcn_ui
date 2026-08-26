defmodule ShadcnUI.Components.Overlays.HoverCard do
  use ShadcnUI.Component
  alias ShadcnUI.Components.Overlays.{OverlayContract, SupplementalContract}
  import SupplementalContract, only: [native_trigger: 1]

  @moduledoc """
  A complete ordinary link with a supplemental, noninteractive HEEx preview.

  The single self-closing `trigger` slot requires a text label and href, preserving
  native target, rel, download, current-location and application attributes.
  `inner_block` accepts trusted HEEx using p, div, span, strong, em, small, b, i,
  br, ul, ol, li, h3, h4 and time, with only class, lang, dir and datetime
  attributes. This deliberately small presentation vocabulary rejects forms,
  controls, focusable content, scripts, media fetches and nested links. It is a
  composition guard for trusted HEEx, not an untrusted-HTML sanitizer.

  Callers must keep the destination complete and the preview nonessential:
  no workflow state, authorization result, private data, unique task information,
  loading state or required action belongs here. Content meaning cannot be
  inferred from markup. Applications own privacy, freshness and replacement.
  No interest events, analytics, client fetch, timer, focus movement, touch
  emulation or top-layer behavior is installed. Touch follows the ordinary link.
  """

  attr :id, :string, required: true
  attr :describedby, :string, default: nil

  attr :placement, :atom,
    values: [:block_start, :block_end, :inline_start, :inline_end],
    default: :block_end

  attr :class, :any, default: nil
  attr :rest, :global

  slot :trigger, required: true do
    attr :label, :string, required: true
    attr :href, :string, required: true
    attr :target, :string
    attr :rel, :string
    attr :download, :any
    attr :current, :string
    attr :class, :any
    attr :rest, :map
  end

  slot :inner_block, required: true

  @doc "Renders a link and bounded preview; all required information belongs at the destination."
  def hover_card(assigns) do
    identity = OverlayContract.identity!(assigns.id)

    if length(assigns.inner_block) != 1,
      do: raise(ArgumentError, "Hover Card requires one trusted preview")

    # Render this single slot snapshot once, outside the HEEx change-tracking
    # engine, so its presentation guard can inspect the actual trusted markup.
    content = hd(assigns.inner_block).inner_block
    preview = preview!(if(is_function(content, 2), do: content.(nil, nil), else: content))

    native =
      SupplementalContract.trigger!(Enum.map(assigns.trigger, &Map.put(&1, :kind, :link)), [:link])

    assigns =
      assigns
      |> assign(:identity, identity)
      |> assign(:preview, preview)
      |> assign(:native, native)
      |> assign(
        :description_ids,
        SupplementalContract.descriptions!(assigns.describedby, identity.description_id)
      )
      |> assign(:placement_value, OverlayContract.placement!(assigns.placement))
      |> assign(:safe_rest, SupplementalContract.globals!(assigns.rest))
      |> assign(:classes, class_names(["sui:text-sm", assigns.class]))

    ~H"""
    <div
      {@safe_rest}
      id={@identity.base_id}
      data-shadcn-ui
      data-shadcn-ui-supplemental="hover-card"
      data-placement={@placement_value}
    >
      <.native_trigger trigger={@native} id={@identity.invoker_id} describedby={@description_ids} />
      <div
        id={@identity.description_id}
        class={@classes}
        data-shadcn-ui
        data-shadcn-ui-supplemental-surface
      >
        {@preview}
      </div>
    </div>
    """
  end

  # Only already-trusted HEEx is serialized. No caller string becomes HTML.
  # Restrict the complete tag vocabulary rather than trying to enumerate all
  # HTML/SVG/MathML mechanisms that could introduce interaction or network work.
  defp preview!(%Phoenix.LiveView.Rendered{} = rendered) do
    html = rendered |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
    tags = Regex.scan(~r/<[^>]*>/s, html) |> List.flatten()

    allowed =
      ~r/\A(?:<\/(?:p|div|span|strong|em|small|b|i|ul|ol|li|h3|h4|time)\s*>|<(?:p|div|span|strong|em|small|b|i|br|ul|ol|li|h3|h4|time)(?:\s+(?:class|lang|dir|datetime)=(?:"[^"<>]*"|'[^'<>]*'))*\s*\/?>)\z/

    text = Regex.replace(~r/<[^>]*>/s, html, "")

    if String.trim(text) == "" or String.contains?(text, "<") or
         Enum.any?(tags, &(not Regex.match?(allowed, &1))),
       do:
         raise(ArgumentError, "Hover Card preview permits only noninteractive presentation HEEx")

    {:safe, html}
  end

  defp preview!(_),
    do: raise(ArgumentError, "Hover Card preview must be trusted HEEx, not raw HTML strings")
end
