defmodule ShadcnUIDemo.FormCatalogTest do
  use ExUnit.Case, async: false

  alias ShadcnUIDemo.{Catalogue, Reference}

  # covers: shadcn_ui.form_gallery.catalog
  # covers: shadcn_ui.form_gallery.states
  # covers: shadcn_ui.form_gallery.modes
  # covers: shadcn_ui.form_gallery.semantic_guidance

  @slugs ~w(field label help field-errors error-summary input textarea checkbox radio-group switch native-select enhanced-select slider progress meter)

  test "Forms is a closed ordered category with one stable leaf per component" do
    assert {:ok, %{label: "Forms", path: "/components/forms"}} =
             Catalogue.lookup_category("forms")

    assert Enum.map(Catalogue.components("forms"), & &1.slug) == @slugs

    for slug <- @slugs do
      assert {:ok, component} = Catalogue.lookup_component("forms", slug)
      assert component.path == "/components/forms/#{slug}"
      assert component.path in Catalogue.routes()
      reference = Reference.fetch!(component.render)

      assert Enum.all?(
               ~w(what when responsibilities accessibility semantics fallback source)a,
               &Map.has_key?(reference, &1)
             )
    end
  end

  test "unknown and mismatched route text fails closed without atom creation" do
    before_count = :erlang.system_info(:atom_count)

    for slug <- ["Input", "../input", "missing", String.duplicate("x", 200)] do
      assert :error = Catalogue.lookup_component("forms", slug)
    end

    assert :error = Catalogue.lookup_component("foundation", "input")
    assert :error = Catalogue.lookup_component("forms", "button")
    assert :erlang.system_info(:atom_count) == before_count
  end

  test "form reference source and examples remain authored and non-reflective" do
    renderer = File.read!("lib/shadcn_ui_demo_web/reference_components.ex")
    controller = File.read!("lib/shadcn_ui_demo_web/controllers/gallery_controller.ex")

    for component <- Catalogue.components("forms") do
      assert Reference.fetch!(component.render).source =~ "<."
      assert renderer =~ ":#{component.render}"
    end

    assert renderer =~ "Explicit identity"
    assert renderer =~ "FormField"
    assert renderer =~ "Indeterminate report"
    refute controller =~ ~r/(String\.to_atom|binary_to_atom|Code\.|apply\()/
  end
end
