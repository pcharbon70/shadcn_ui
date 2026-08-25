defmodule ShadcnUIDemo.Catalogue do
  @moduledoc "Immutable gallery information architecture and closed route lookup."

  @categories [
    %{label: "Foundation", slug: "foundation", path: "/components/foundation"},
    %{label: "Forms", slug: "forms", path: "/components/forms"}
  ]

  @foundation [
    %{label: "Button", slug: "button", render: :button},
    %{label: "Badge", slug: "badge", render: :badge},
    %{label: "Alert", slug: "alert", render: :alert},
    %{label: "Card", slug: "card", render: :card},
    %{label: "Avatar", slug: "avatar", render: :avatar},
    %{label: "Skeleton", slug: "skeleton", render: :skeleton}
  ]

  @forms [
    %{label: "Field", slug: "field", render: :field},
    %{label: "Label", slug: "label", render: :label},
    %{label: "Help", slug: "help", render: :help},
    %{label: "Field Errors", slug: "field-errors", render: :field_errors},
    %{label: "Error Summary", slug: "error-summary", render: :error_summary},
    %{label: "Input", slug: "input", render: :input},
    %{label: "Textarea", slug: "textarea", render: :textarea},
    %{label: "Checkbox", slug: "checkbox", render: :checkbox},
    %{label: "Radio Group", slug: "radio-group", render: :radio_group},
    %{label: "Switch", slug: "switch", render: :switch},
    %{label: "Native Select", slug: "native-select", render: :native_select},
    %{label: "Enhanced Select", slug: "enhanced-select", render: :enhanced_select},
    %{label: "Slider", slug: "slider", render: :slider},
    %{label: "Progress", slug: "progress", render: :progress},
    %{label: "Meter", slug: "meter", render: :meter}
  ]

  @components_by_category %{
    "foundation" => Enum.map(@foundation, &Map.put(&1, :category, "foundation")),
    "forms" => Enum.map(@forms, &Map.put(&1, :category, "forms"))
  }

  @components Enum.flat_map(@categories, fn category ->
                Enum.map(Map.fetch!(@components_by_category, category.slug), fn component ->
                  Map.put(component, :path, "#{category.path}/#{component.slug}")
                end)
              end)

  def categories, do: @categories
  def category, do: hd(@categories)
  def components, do: @components
  def components(category) when is_binary(category), do: Enum.filter(@components, &(&1.category == category))

  def routes do
    ["/" | Enum.flat_map(@categories, fn category ->
      [category.path | Enum.map(components(category.slug), &"#{category.path}/#{&1.slug}")]
    end)]
  end

  def lookup_category(slug) when is_binary(slug) do
    case Enum.find(@categories, &(&1.slug == slug)) do
      nil -> :error
      category -> {:ok, category}
    end
  end

  def lookup_category(_slug), do: :error

  def lookup_component(category, slug) when is_binary(category) and is_binary(slug) do
    case Enum.find(@components, &(&1.category == category and &1.slug == slug)) do
      nil -> :error
      component -> {:ok, component}
    end
  end

  def lookup_component(_category, _slug), do: :error
end
