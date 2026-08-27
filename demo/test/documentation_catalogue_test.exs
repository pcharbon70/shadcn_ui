defmodule ShadcnUIDemo.DocumentationCatalogueTest do
  use ExUnit.Case, async: false

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue}

  test "closed schema describes every stable component route" do
    assert :ok = DocumentationCatalogue.validate()
    entries = DocumentationCatalogue.entries()

    assert Enum.map(entries, & &1.route) ==
             Catalogue.components() |> Enum.map(& &1.path)

    assert Enum.map(entries, & &1.category.slug) ==
             Catalogue.components() |> Enum.map(& &1.category)

    for entry <- entries do
      assert entry.schema_version == "1"
      assert entry.category.path <> "/" <> entry.slug == entry.route
      assert entry.public.arity == 1
      assert Code.ensure_loaded?(entry.public.module)
      assert function_exported?(entry.public.module, entry.public.function, entry.public.arity)
      assert is_binary(entry.provenance_id)

      assert Enum.all?(
               ~w(what when responsibilities accessibility fallback source)a,
               &is_binary(Map.fetch!(entry.documentation, &1))
             )

      assert [%{fragment: fragment, source_id: source_id, route: route}] = entry.examples
      assert fragment == "#{entry.slug}-primary"
      assert source_id == "reference:#{entry.render}"
      assert route == "#{entry.route}##{fragment}"
    end
  end

  test "authored examples have stable unique fragments and explicit relationships" do
    relationships =
      for entry <- DocumentationCatalogue.entries(), example <- entry.examples do
        {entry.route, example.fragment, example.source_id, example.preview_label}
      end

    assert Enum.uniq(relationships) == relationships

    assert Enum.all?(relationships, fn {route, fragment, source_id, label} ->
             String.starts_with?(route, "/components/") and
               fragment =~ ~r/^[a-z0-9-]+$/ and
               String.starts_with?(source_id, "reference:") and
               String.ends_with?(label, " primary example")
           end)
  end

  test "closed lookups never derive executable identities from request text" do
    assert {:ok, %{public: %{module: ShadcnUI.Components.Foundation.Button}}} =
             DocumentationCatalogue.lookup("foundation", "button")

    assert {:ok, %{fragment: "button-primary"}} =
             DocumentationCatalogue.lookup_fragment(
               "/components/foundation/button",
               "button-primary"
             )

    unknown = [
      "unknown",
      "Button",
      "Elixir.System",
      "../../secret",
      "<script>",
      String.duplicate("x", 1_000)
    ]

    Enum.each(unknown, fn value ->
      DocumentationCatalogue.lookup(value, value)
      DocumentationCatalogue.lookup_route(value)
      DocumentationCatalogue.lookup_fragment(value, value)
    end)

    before = :erlang.system_info(:atom_count)

    for value <- unknown do
      assert :error = DocumentationCatalogue.lookup(value, value)
      assert :error = DocumentationCatalogue.lookup_route(value)
      assert :error = DocumentationCatalogue.lookup_fragment(value, value)
    end

    assert :erlang.system_info(:atom_count) == before
  end

  test "documentation inventory remains in the demo boundary" do
    package_source = File.read!("../lib/shadcn_ui.ex")
    release_source = File.read!("../mix.exs")

    refute package_source =~ "DocumentationCatalogue"
    refute release_source =~ "demo/lib/shadcn_ui_demo/documentation_catalogue.ex"
  end
end
