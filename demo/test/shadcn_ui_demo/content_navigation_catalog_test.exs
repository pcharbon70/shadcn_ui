defmodule ShadcnUIDemo.ContentNavigationCatalogTest do
  use ExUnit.Case, async: false

  alias ShadcnUIDemo.{Catalogue, Reference}

  # covers: shadcn_ui.content_gallery.catalog shadcn_ui.content_gallery.states
  # covers: shadcn_ui.content_gallery.semantic_guidance shadcn_ui.content_gallery.fallbacks

  test "Milestone C categories and leaves are closed, ordered, and fully referenced" do
    assert Enum.map(Catalogue.categories(), & &1.slug) ==
             ~w(foundation forms disclosure navigation content-surfaces overlays interactive-surfaces)

    expected = %{
      "disclosure" => ~w(accordion),
      "navigation" => ~w(navigation-menu header section-header),
      "content-surfaces" => ~w(scroll-area separator radio-panels)
    }

    for {category, slugs} <- expected do
      components = Catalogue.components(category)
      assert Enum.map(components, & &1.slug) == slugs

      for component <- components do
        assert {:ok, ^component} = Catalogue.lookup_component(category, component.slug)
        assert component.path in Catalogue.routes()
        reference = Reference.fetch!(component.render)
        assert reference.source =~ "<.#{String.replace(component.slug, "-", "_")}"
        assert reference.accessibility =~ "Native"
        assert reference.fallback =~ "Without package CSS"
      end
    end
  end

  test "unknown and mismatched request strings fail without atoms or reflection" do
    before_count = :erlang.system_info(:atom_count)

    for value <- ["tabs", "menu", "../../secret", String.duplicate("x", 200)] do
      assert :error = Catalogue.lookup_category(value)
      assert :error = Catalogue.lookup_component("navigation", value)
      assert :error = Catalogue.lookup_component(value, "header")
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  test "demo catalogue stays outside the package release allowlist" do
    package = File.read!("../mix.exs")
    refute package =~ ~r/"demo"\s*,/
    refute package =~ "content_navigation_catalog_test"
  end
end
