defmodule ShadcnUIDemo.Catalogue do
  @moduledoc "Immutable gallery information architecture and closed route lookup."

  @categories [
    %{label: "Foundation", slug: "foundation", path: "/components/foundation"},
    %{label: "Forms", slug: "forms", path: "/components/forms"},
    %{label: "Disclosure", slug: "disclosure", path: "/components/disclosure"},
    %{label: "Navigation", slug: "navigation", path: "/components/navigation"},
    %{
      label: "Content Surfaces",
      slug: "content-surfaces",
      path: "/components/content-surfaces"
    },
    %{label: "Overlays", slug: "overlays", path: "/components/overlays"},
    %{
      label: "Interactive Surfaces",
      slug: "interactive-surfaces",
      path: "/components/interactive-surfaces"
    }
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

  @disclosure [%{label: "Accordion", slug: "accordion", render: :accordion}]

  @navigation [
    %{label: "Navigation Menu", slug: "navigation-menu", render: :navigation_menu},
    %{label: "Header", slug: "header", render: :header},
    %{label: "Section Header", slug: "section-header", render: :section_header}
  ]

  @content_surfaces [
    %{label: "Scroll Area", slug: "scroll-area", render: :scroll_area},
    %{label: "Separator", slug: "separator", render: :separator},
    %{label: "Radio Panels", slug: "radio-panels", render: :radio_panels}
  ]

  @components_by_category %{
    "overlays" =>
      Enum.map(
        [
          %{label: "Dialog", slug: "dialog", render: :dialog},
          %{label: "Alert Dialog", slug: "alert-dialog", render: :alert_dialog},
          %{label: "Drawer", slug: "drawer", render: :drawer},
          %{label: "Popover", slug: "popover", render: :popover},
          %{label: "Dropdown Actions", slug: "dropdown-actions", render: :dropdown_actions}
        ],
        &Map.put(&1, :category, "overlays")
      ),
    "interactive-surfaces" =>
      Enum.map(
        [
          %{label: "Tooltip", slug: "tooltip", render: :tooltip},
          %{label: "Hover Card", slug: "hover-card", render: :hover_card}
        ],
        &Map.put(&1, :category, "interactive-surfaces")
      ),
    "foundation" => Enum.map(@foundation, &Map.put(&1, :category, "foundation")),
    "forms" => Enum.map(@forms, &Map.put(&1, :category, "forms")),
    "disclosure" => Enum.map(@disclosure, &Map.put(&1, :category, "disclosure")),
    "navigation" => Enum.map(@navigation, &Map.put(&1, :category, "navigation")),
    "content-surfaces" => Enum.map(@content_surfaces, &Map.put(&1, :category, "content-surfaces"))
  }

  @compositions [
    %{
      label: "Documentation composition",
      slug: "documentation",
      path: "/examples/documentation",
      render: :documentation
    },
    %{
      label: "Settings composition",
      slug: "settings",
      path: "/examples/settings",
      render: :settings
    },
    %{
      label: "Application shell composition",
      slug: "application-shell",
      path: "/examples/application-shell",
      render: :application_shell
    }
  ]

  @components Enum.flat_map(@categories, fn category ->
                Enum.map(Map.fetch!(@components_by_category, category.slug), fn component ->
                  Map.put(component, :path, "#{category.path}/#{component.slug}")
                end)
              end)

  def categories, do: @categories
  def form_routes, do: ["/forms/sign-in", "/forms/profile", "/forms/settings"]
  def composition_routes, do: Enum.map(@compositions, & &1.path)
  def compositions, do: @compositions
  def category, do: hd(@categories)
  def components, do: @components

  def components(category) when is_binary(category),
    do: Enum.filter(@components, &(&1.category == category))

  def routes do
    gallery = [
      "/"
      | Enum.flat_map(@categories, fn category ->
          [category.path | Enum.map(components(category.slug), &"#{category.path}/#{&1.slug}")]
        end)
    ]

    gallery ++ composition_routes()
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

  def lookup_composition(slug) when is_binary(slug) do
    case Enum.find(@compositions, &(&1.slug == slug)) do
      nil -> :error
      composition -> {:ok, composition}
    end
  end

  def lookup_composition(_slug), do: :error
end
