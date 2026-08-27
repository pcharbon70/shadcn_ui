defmodule ShadcnUIDemo.DocumentationCatalogueTest do
  use ExUnit.Case, async: false

  # covers: shadcn_ui.documentation_catalogue.closed_schema
  # covers: shadcn_ui.documentation_catalogue.public_api_parity
  # covers: shadcn_ui.documentation_catalogue.stable_information_architecture
  # covers: shadcn_ui.documentation_catalogue.stable_examples
  # covers: shadcn_ui.documentation_catalogue.safe_resolution
  # covers: shadcn_ui.documentation_catalogue.completeness_report
  # covers: shadcn_ui.documentation_catalogue.deterministic_search

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

  test "compiled imports, ExDoc groups, provenance, routes, and references have exact parity" do
    entries = DocumentationCatalogue.entries()
    report = DocumentationCatalogue.completeness_report()

    assert length(entries) == 41
    assert length(DocumentationCatalogue.public_inventory()) == 41
    assert length(report) == 41
    assert Enum.map(report, & &1.route) == Enum.sort(Enum.map(entries, & &1.route))

    for row <- report do
      assert row.documentation
      assert row.public_metadata
      assert row.public_import
      assert row.exdoc_group
      assert row.provenance
      assert row.renderer
      assert row.browser_route == row.route
      assert row.export_route == row.route
      assert String.starts_with?(row.source_compile, "source:")
    end
  end

  test "completeness output is deterministic and contains no host paths or clocks" do
    first = DocumentationCatalogue.completeness_json()
    second = DocumentationCatalogue.completeness_json()

    assert first == second
    assert Jason.decode!(first) |> length() == 41
    refute first =~ Path.expand("..")
    refute first =~ ~r/(20\d\d-\d\d-\d\d|system_time|DateTime)/
  end

  test "search document is minimal, deterministic, safe, and repository-subpath aware" do
    assert :ok = DocumentationCatalogue.validate_search()
    records = DocumentationCatalogue.search_records()

    assert length(records) == 41
    assert Enum.map(records, & &1["route"]) == Enum.map(Catalogue.components(), & &1.path)
    assert Enum.uniq_by(records, & &1["url"]) == records

    for record <- records do
      assert Map.keys(record) == ~w(category keywords name route summary url)
      assert record["url"] == "/shadcn_ui" <> record["route"]
      assert is_list(record["keywords"])
      refute inspect(record) =~ ~r/(HEEx|Elixir\.|<%|<script|javascript:)/i
    end

    first = DocumentationCatalogue.search_json()
    assert first == DocumentationCatalogue.search_json()
    assert %{"schemaVersion" => "1", "records" => ^records} = Jason.decode!(first)
    refute first =~ Path.expand("..")
  end

  test "search normalization bounds Unicode and leaves hostile-looking text inert" do
    assert DocumentationCatalogue.normalize_search(" Éléments <SCRIPT>alert(1)</SCRIPT> ") ==
             "elements script alert 1 script"

    assert String.length(DocumentationCatalogue.normalize_search(String.duplicate("x", 500))) ==
             200

    assert DocumentationCatalogue.search_text!("foundation", "button") =~ "button"

    assert_raise ArgumentError, fn ->
      DocumentationCatalogue.search_text!("<script>", "../../secret")
    end
  end

  test "audit reports missing, duplicate, and stale identities deterministically" do
    [first | rest] = DocumentationCatalogue.entries()

    assert {:error, missing_errors} = DocumentationCatalogue.audit(rest)
    assert Enum.any?(missing_errors, &String.starts_with?(&1, "missing documentation identity:"))

    assert {:error, duplicate_errors} = DocumentationCatalogue.audit([first, first | rest])
    assert "duplicate route: #{inspect(first.route)}" in duplicate_errors

    stale = put_in(first.public.module, ShadcnUI.Component)
    assert {:error, stale_errors} = DocumentationCatalogue.audit([stale | rest])
    assert Enum.any?(stale_errors, &String.starts_with?(&1, "stale documentation identity:"))

    assert missing_errors == Enum.sort(missing_errors)
    assert duplicate_errors == Enum.sort(duplicate_errors)
    assert stale_errors == Enum.sort(stale_errors)
  end
end
