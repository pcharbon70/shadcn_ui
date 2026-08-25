defmodule ShadcnUI.Components.Navigation.NavigationMenu do
  use ShadcnUI.Component

  @moduledoc """
  Named destination navigation built from a native landmark, list, and anchors.

  Current location is an explicit caller snapshot. ShadcnUI does not inspect a
  request, resolve routes, authorize entries, intercept activation, or provide
  menu, tab, command, popup, or client-router behavior.
  """

  @key_pattern ~r/^[A-Za-z0-9][A-Za-z0-9_.-]*$/u
  @current_values %{
    none: nil,
    page: "page",
    step: "step",
    location: "location",
    date: "date",
    time: "time",
    true: "true"
  }

  attr :accessible_name, :string, required: true
  attr :layout, :atom, values: [:horizontal, :vertical, :wrap], default: :horizontal
  attr :class, :any, default: nil
  attr :list_class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :key, :string, required: true
    attr :destination, :string, required: true
    attr :label, :string
    attr :current, :atom, values: [:none, :page, :step, :location, :date, :time, true]
    attr :target, :string
    attr :rel, :string
    attr :download, :any
    attr :class, :any
    attr :link_rest, :map
  end

  @doc "Renders named native destination navigation with explicit current state."
  def navigation_menu(assigns) do
    accessible_name = require_nonblank!(assigns.accessible_name, :accessible_name)
    reject_role!(assigns.rest, :navigation)
    items = normalize_items!(assigns.item)

    assigns =
      assigns
      |> assign(:accessible_name, accessible_name)
      |> assign(:items, items)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [
          :role,
          :aria_label,
          :aria_labelledby,
          :data_shadcn_ui,
          :data_shadcn_ui_navigation_menu,
          :data_layout
        ])
      )
      |> assign(:classes, class_names(["sui:w-full sui:max-w-full", assigns.class]))
      |> assign(:list_classes, class_names([layout_class!(assigns.layout), assigns.list_class]))

    ~H"""
    <nav
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-navigation-menu
      data-layout={@layout}
      aria-label={@accessible_name}
      class={@classes}
    >
      <ul data-shadcn-ui-navigation-list class={@list_classes}>
        <li :for={item <- @items} data-shadcn-ui-navigation-item data-item-key={item.key}>
          <a
            {item.link_rest}
            href={item.destination}
            aria-current={item.current}
            target={item.target}
            rel={item.rel}
            download={item.download}
            data-shadcn-ui
            data-shadcn-ui-navigation-link
            class={item.classes}
          >
            <span :if={item.label_kind == :text}>{item.label}</span>
            <span :if={item.label_kind == :slot}>{render_slot(item)}</span>
          </a>
        </li>
      </ul>
    </nav>
    """
  end

  defp normalize_items!(items) when is_list(items) and items != [] do
    items = Enum.map(items, &normalize_item!/1)
    keys = Enum.map(items, & &1.key)

    if length(keys) != length(Enum.uniq(keys)),
      do: raise(ArgumentError, "Navigation Menu item keys must be unique")

    items
  end

  defp normalize_items!([]),
    do: raise(ArgumentError, "Navigation Menu requires at least one item")

  defp normalize_items!(items),
    do:
      raise(
        ArgumentError,
        "Navigation Menu items must be a nonempty list, got: #{inspect(items)}"
      )

  defp normalize_item!(item) when is_map(item) do
    key = item |> fetch_item!(:key) |> validate_key!()
    destination = item |> fetch_item!(:destination) |> require_nonblank!(:destination)
    {label_kind, label} = normalize_label!(item)
    current = item |> Map.get(:current, :none) |> then(&Map.fetch!(@current_values, &1))
    link_rest = item |> Map.get(:link_rest, %{}) |> validate_globals!(:link_rest)
    reject_role!(link_rest, :link)

    %{
      inner_block: fetch_item!(item, :inner_block),
      key: key,
      destination: destination,
      label_kind: label_kind,
      label: label,
      current: current,
      target: optional_string!(Map.get(item, :target), :target),
      rel: optional_string!(Map.get(item, :rel), :rel),
      download: validate_download!(Map.get(item, :download)),
      link_rest:
        protect_globals(link_rest, [
          :href,
          :role,
          :tabindex,
          :aria_current,
          :target,
          :rel,
          :download,
          :data_shadcn_ui,
          :data_shadcn_ui_navigation_link
        ]),
      classes:
        class_names([
          "sui:inline-flex sui:max-w-full sui:items-center sui:rounded-md",
          "sui:px-3 sui:py-2 sui:text-sm sui:font-medium sui:break-words",
          classes_for(:focus, :default),
          Map.get(item, :class)
        ])
    }
  end

  defp normalize_item!(item),
    do: raise(ArgumentError, "Navigation Menu items must be slot entries, got: #{inspect(item)}")

  defp fetch_item!(item, field) do
    case Map.fetch(item, field) do
      {:ok, value} -> value
      :error -> raise ArgumentError, "each Navigation Menu item requires :key and :destination"
    end
  end

  defp normalize_label!(item),
    do:
      if(is_nil(Map.get(item, :label)),
        do: {:slot, nil},
        else: {:text, require_nonblank!(Map.get(item, :label), :label)}
      )

  defp validate_key!(key) when is_binary(key) do
    key = String.trim(key)

    if Regex.match?(@key_pattern, key),
      do: key,
      else:
        raise(
          ArgumentError,
          "Navigation Menu item key must be nonblank and contain only letters, digits, _, ., or -"
        )
  end

  defp validate_key!(key),
    do:
      raise(
        ArgumentError,
        "Navigation Menu item key must be a stable string, got: #{inspect(key)}"
      )

  defp require_nonblank!(value, field) when is_binary(value) do
    value = String.trim(value)
    if value == "", do: raise(ArgumentError, "#{field} must be a nonblank string"), else: value
  end

  defp require_nonblank!(value, field),
    do: raise(ArgumentError, "#{field} must be a nonblank string, got: #{inspect(value)}")

  defp optional_string!(nil, _field), do: nil
  defp optional_string!(value, field), do: require_nonblank!(value, field)

  defp validate_download!(value) when is_nil(value) or is_boolean(value) or is_binary(value),
    do: value

  defp validate_download!(value),
    do: raise(ArgumentError, "download must be a boolean, string, or nil, got: #{inspect(value)}")

  defp validate_globals!(value, _field) when is_map(value) and not is_struct(value), do: value

  defp validate_globals!(value, field),
    do: raise(ArgumentError, "#{field} must be a plain map, got: #{inspect(value)}")

  defp reject_role!(globals, owner) do
    if Map.has_key?(globals, :role) or Map.has_key?(globals, "role"),
      do: raise(ArgumentError, "Navigation Menu #{owner} does not accept a caller role")
  end

  defp layout_class!(:horizontal), do: "sui:flex sui:items-center sui:gap-1 sui:overflow-x-auto"
  defp layout_class!(:vertical), do: "sui:grid sui:gap-1"
  defp layout_class!(:wrap), do: "sui:flex sui:flex-wrap sui:items-center sui:gap-1"

  defp layout_class!(layout),
    do: raise(KeyError, key: layout, term: [:horizontal, :vertical, :wrap])
end
