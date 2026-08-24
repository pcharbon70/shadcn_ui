defmodule ShadcnUIDemo.Catalogue do
  @moduledoc "Immutable gallery information architecture and closed route lookup."

  @category %{label: "Foundation", slug: "foundation", path: "/components/foundation"}
  @components [
    %{label: "Button", slug: "button", path: "/components/foundation/button", render: :button},
    %{label: "Badge", slug: "badge", path: "/components/foundation/badge", render: :badge},
    %{label: "Alert", slug: "alert", path: "/components/foundation/alert", render: :alert},
    %{label: "Card", slug: "card", path: "/components/foundation/card", render: :card},
    %{label: "Avatar", slug: "avatar", path: "/components/foundation/avatar", render: :avatar},
    %{label: "Skeleton", slug: "skeleton", path: "/components/foundation/skeleton", render: :skeleton}
  ]

  def category, do: @category
  def components, do: @components
  def routes, do: ["/", @category.path | Enum.map(@components, & &1.path)]

  def lookup_category("foundation"), do: {:ok, @category}
  def lookup_category(_slug), do: :error

  def lookup_component("foundation", slug) when is_binary(slug) do
    case Enum.find(@components, &(&1.slug == slug)) do
      nil -> :error
      component -> {:ok, component}
    end
  end

  def lookup_component(_category, _slug), do: :error
end
