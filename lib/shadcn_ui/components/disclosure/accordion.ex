defmodule ShadcnUI.Components.Disclosure.Accordion do
  use ShadcnUI.Component

  @moduledoc """
  Native disclosure items with deterministic caller-owned identity.

  Each item renders one `details` and `summary` pair. Initial `open` values are
  server-rendered snapshots only; browsers own activation and applications own
  persistence, replacement policy, routing, loading, and analytics.
  """

  @modes %{independent: true, exclusive: true}
  @id_pattern ~r/^[A-Za-z][A-Za-z0-9_:.-]*$/u
  @key_pattern ~r/^[A-Za-z0-9][A-Za-z0-9_.-]*$/u

  attr :id, :string, required: true
  attr :mode, :atom, values: [:independent, :exclusive], default: :independent
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :key, :string, required: true
    attr :summary, :string, required: true
    attr :open, :boolean
    attr :class, :any
    attr :summary_class, :any
    attr :content_class, :any
    attr :details_rest, :map
    attr :summary_rest, :map
    attr :content_rest, :map
  end

  @doc "Renders a deterministic collection of native disclosure items."
  def accordion(assigns) do
    id = validate_id!(assigns.id)
    _ = Map.fetch!(@modes, assigns.mode)
    items = assigns.item |> normalize_items!(id) |> apply_mode(assigns.mode, id)

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:items, items)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :id,
          :data_shadcn_ui,
          :data_shadcn_ui_accordion,
          :data_mode
        ])
      )
      |> assign(
        :classes,
        class_names(["sui:grid sui:w-full sui:max-w-full sui:gap-2", assigns.class])
      )

    ~H"""
    <div
      {@safe_rest}
      id={@id}
      data-shadcn-ui
      data-shadcn-ui-accordion
      data-mode={@mode}
      class={@classes}
    >
      <details
        :for={item <- @items}
        {item.details_rest}
        id={item.details_id}
        open={item.open}
        name={item.group_name}
        data-shadcn-ui
        data-shadcn-ui-accordion-item
        data-item-key={item.key}
        class={item.classes}
      >
        <summary
          {item.summary_rest}
          id={item.summary_id}
          aria-controls={item.content_id}
          data-shadcn-ui-accordion-summary
          class={item.summary_classes}
        >
          <span>{item.summary}</span>
        </summary>
        <div
          {item.content_rest}
          id={item.content_id}
          aria-labelledby={item.summary_id}
          data-shadcn-ui-accordion-content
          class={item.content_classes}
        >
          {render_slot(item)}
        </div>
      </details>
    </div>
    """
  end

  defp normalize_items!(items, id) when is_list(items) and items != [] do
    items = Enum.map(items, &normalize_item!(&1, id))
    keys = Enum.map(items, & &1.key)

    if length(keys) != length(Enum.uniq(keys)) do
      raise ArgumentError, "Accordion item keys must be unique"
    end

    items
  end

  defp normalize_items!([], _id), do: raise(ArgumentError, "Accordion requires at least one item")

  defp normalize_items!(items, _id) do
    raise ArgumentError, "Accordion items must be a nonempty list, got: #{inspect(items)}"
  end

  defp normalize_item!(item, id) when is_map(item) do
    key = item |> Map.fetch!(:key) |> validate_key!()
    summary = item |> Map.fetch!(:summary) |> require_nonblank!(:summary)
    open = item |> Map.get(:open, false) |> validate_boolean!(:open)
    item_id = "#{id}-item-#{key}"

    %{
      inner_block: Map.fetch!(item, :inner_block),
      key: key,
      summary: summary,
      open: open,
      details_id: item_id,
      summary_id: "#{item_id}-summary",
      content_id: "#{item_id}-content",
      details_rest:
        item
        |> Map.get(:details_rest, %{})
        |> validate_globals!(:details_rest)
        |> protect_globals([
          :id,
          :open,
          :name,
          :data_shadcn_ui,
          :data_shadcn_ui_accordion_item,
          :data_item_key
        ]),
      summary_rest:
        item
        |> Map.get(:summary_rest, %{})
        |> validate_globals!(:summary_rest)
        |> protect_globals([:id, :role, :aria_controls, :data_shadcn_ui_accordion_summary]),
      content_rest:
        item
        |> Map.get(:content_rest, %{})
        |> validate_globals!(:content_rest)
        |> protect_globals([:id, :aria_labelledby, :data_shadcn_ui_accordion_content]),
      classes:
        class_names([
          "sui:group sui:w-full sui:rounded-md sui:border sui:border-border",
          "sui:bg-background sui:text-foreground",
          Map.get(item, :class)
        ]),
      summary_classes:
        class_names([
          "sui:flex sui:w-full sui:max-w-full sui:cursor-pointer sui:items-center sui:gap-2",
          "sui:rounded-md sui:px-4 sui:py-3 sui:text-left sui:text-sm sui:font-medium",
          classes_for(:focus, :default),
          Map.get(item, :summary_class)
        ]),
      content_classes:
        class_names([
          "sui:min-w-0 sui:max-w-full sui:px-4 sui:pb-4 sui:text-sm sui:text-foreground",
          Map.get(item, :content_class)
        ])
    }
  rescue
    KeyError ->
      raise ArgumentError, "each Accordion item requires :key, :summary, and panel content"
  end

  defp normalize_item!(item, _id) do
    raise ArgumentError, "Accordion items must be slot entries, got: #{inspect(item)}"
  end

  defp apply_mode(items, :independent, _id) do
    Enum.map(items, &Map.put(&1, :group_name, nil))
  end

  defp apply_mode(items, :exclusive, id) do
    {items, _open_seen?} =
      Enum.map_reduce(items, false, fn item, open_seen? ->
        open = item.open and not open_seen?

        {item |> Map.put(:open, open) |> Map.put(:group_name, "#{id}-group"), open_seen? or open}
      end)

    items
  end

  defp validate_id!(id) when is_binary(id) do
    id = String.trim(id)

    if Regex.match?(@id_pattern, id) do
      id
    else
      raise ArgumentError,
            "Accordion id must start with a letter and contain only letters, digits, _, :, ., or -"
    end
  end

  defp validate_id!(id) do
    raise ArgumentError, "Accordion id must be a nonblank string, got: #{inspect(id)}"
  end

  defp validate_key!(key) when is_binary(key) do
    key = String.trim(key)

    if Regex.match?(@key_pattern, key) do
      key
    else
      raise ArgumentError,
            "Accordion item key must be nonblank and contain only letters, digits, _, ., or -"
    end
  end

  defp validate_key!(key) do
    raise ArgumentError, "Accordion item key must be a stable string, got: #{inspect(key)}"
  end

  defp require_nonblank!(value, field) when is_binary(value) do
    if String.trim(value) == "" do
      raise ArgumentError, "Accordion item #{field} must be a nonblank string"
    end

    value
  end

  defp require_nonblank!(value, field) do
    raise ArgumentError,
          "Accordion item #{field} must be a nonblank string, got: #{inspect(value)}"
  end

  defp validate_boolean!(value, _field) when is_boolean(value), do: value

  defp validate_boolean!(value, field) do
    raise ArgumentError, "Accordion item #{field} must be a boolean, got: #{inspect(value)}"
  end

  defp validate_globals!(value, _field) when is_map(value) and not is_struct(value), do: value

  defp validate_globals!(value, field) do
    raise ArgumentError, "Accordion item #{field} must be a plain map, got: #{inspect(value)}"
  end
end
