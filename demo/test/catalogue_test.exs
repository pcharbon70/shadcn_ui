defmodule ShadcnUIDemo.CatalogueTest do
  use ExUnit.Case, async: true

  alias ShadcnUIDemo.Catalogue

  test "catalogue is ordered, unique, complete, and deterministic" do
    components = Catalogue.components()

    assert Enum.map(components, & &1.slug) == ~w(button badge alert card avatar skeleton)
    assert Enum.uniq_by(components, & &1.slug) == components
    assert Enum.uniq_by(components, & &1.path) == components
    assert Enum.uniq_by(components, & &1.render) == components
    assert Catalogue.routes() == ["/", "/components/foundation" | Enum.map(components, & &1.path)]
  end

  test "closed lookups do not grow atoms or reflect unknown request text" do
    before = :erlang.system_info(:atom_count)

    for value <- ["unknown", "Button", "../../secret", String.duplicate("x", 100)] do
      assert :error = Catalogue.lookup_component("foundation", value)
      assert :error = Catalogue.lookup_category(value)
    end

    assert :erlang.system_info(:atom_count) == before
  end

  test "mismatched category and component pairs fail closed" do
    assert {:ok, %{render: :button}} = Catalogue.lookup_component("foundation", "button")
    assert :error = Catalogue.lookup_component("other", "button")
    assert :error = Catalogue.lookup_component("foundation", "missing")
  end
end
