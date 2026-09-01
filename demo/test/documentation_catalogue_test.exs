defmodule ShadcnUIDemo.DocumentationCatalogueTest do
  use ExUnit.Case, async: false

  # covers: shadcn_ui.documentation_catalogue.closed_schema
  # covers: shadcn_ui.documentation_catalogue.public_api_parity
  # covers: shadcn_ui.documentation_catalogue.stable_information_architecture
  # covers: shadcn_ui.documentation_catalogue.stable_examples
  # covers: shadcn_ui.documentation_catalogue.safe_resolution
  # covers: shadcn_ui.documentation_catalogue.completeness_report
  # covers: shadcn_ui.documentation_catalogue.deterministic_search

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue, PresentationCatalogue}

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
      assert is_map(entry.presentation)
      assert entry.presentation.description == entry.documentation.what
      assert entry.presentation.exact_fallback == entry.documentation.fallback
      assert entry.presentation.counterpart.identity == entry.provenance_id

      assert Enum.all?(
               ~w(what when responsibilities accessibility fallback source native_baseline package_enhancement demo_behavior unsupported)a,
               &is_binary(Map.fetch!(entry.documentation, &1))
             )

      assert entry.links.gallery == entry.route
      assert entry.links.source =~ "/lib/shadcn_ui/components/"
      assert entry.links.api =~ ".html##{entry.public.function}/1"
      assert is_list(entry.api.attributes)
      assert is_list(entry.api.slots)

      for example <- entry.examples do
        assert example.source_fragment == "#{example.fragment}-source"
        assert example.route == "#{entry.route}##{example.fragment}"
        assert example.source =~ "<.#{entry.public.function}"
        assert example.layout in PresentationCatalogue.layout_identities()
      end

      if entry.render != :accordion do
        assert [example] = entry.examples
        assert example.fragment == "#{entry.slug}-primary"
        assert example.source_id == "reference:#{entry.render}"
      end
    end
  end

  test "presentation inventory covers every component and gallery-only route in catalogue order" do
    inventory = DocumentationCatalogue.presentation_inventory()

    assert :ok = PresentationCatalogue.audit_inventory(inventory)
    assert length(inventory) == 63
    assert Enum.map(inventory, & &1.route) == Catalogue.routes()

    assert Enum.frequencies_by(inventory, & &1.kind) == %{
             "landing" => 1,
             "category" => 9,
             "component" => 41,
             "composition" => 12
           }

    for record <- inventory do
      assert record.status.authored_ready
      assert is_binary(record.description) and record.description != ""
      assert record.features != []
      assert record.support_rows != []
      assert is_binary(record.exact_fallback) and record.exact_fallback != ""
    end

    pilot = Enum.find(inventory, &(&1.route == "/components/disclosure/accordion"))
    assert pilot.status.migrated
    assert pilot.status.visually_reviewed
    assert pilot.status.accepted

    assert pilot.status.visual_evidence == [
             "demo/priv/reference/milestone_g/phase-05-accordion-evidence.json"
           ]

    assert Enum.count(inventory, & &1.status.migrated) == 22
    assert Enum.count(inventory, & &1.status.visually_reviewed) == 22
    assert Enum.count(inventory, & &1.status.accepted) == 1
  end

  test "semantic exceptions and gallery-only routes are explicit" do
    entries = DocumentationCatalogue.entries()

    assert entries
           |> Enum.filter(&(&1.presentation.counterpart.kind == "semantic-exception"))
           |> Enum.map(& &1.provenance_id)
           |> Enum.sort() ==
             ~w(content.radio_panels media.carousel media.cover-flow overlays.dropdown-actions)

    local =
      DocumentationCatalogue.presentation_inventory()
      |> Enum.reject(&(&1.kind == "component"))

    assert length(local) == 22

    for record <- local do
      assert record.counterpart.kind == "local-only"
      assert record.counterpart.upstream_paths == []
      assert record.exception == "gallery-route-without-component-specimens"
      assert record.specimens == []
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
               is_binary(label) and label != ""
           end)
  end

  test "presentation metadata resolves literal content through closed identities" do
    assert {:ok, accordion} =
             DocumentationCatalogue.lookup("disclosure", "accordion")

    presentation = accordion.presentation

    assert presentation.description == accordion.documentation.what
    assert presentation.exact_fallback == accordion.documentation.fallback
    assert presentation.defining_function == "accordion"
    assert presentation.counterpart.identity == accordion.provenance_id
    assert presentation.counterpart.kind == "upstream-counterpart"
    assert presentation.counterpart.revision =~ ~r/^[a-f0-9]{40}$/
    assert presentation.counterpart.upstream_paths != []

    assert Enum.all?(presentation.how_it_works, fn point ->
             is_binary(point.code) and is_binary(point.description)
           end)

    assert Enum.map(presentation.features, & &1.identity) ==
             ~w(native-baseline exclusive-grouping details-content interpolate-size fallback)

    for feature <- presentation.features do
      assert Map.keys(feature) |> Enum.sort() ==
               ~w(description evidence fallback identity label reference)a |> Enum.sort()

      assert {:ok, ^feature} = PresentationCatalogue.feature(presentation, feature.identity)
      assert Enum.all?(Map.values(feature), &(is_binary(&1) and &1 != ""))
    end

    assert :error = PresentationCatalogue.feature(presentation, "unknown")

    for example <- accordion.examples do
      assert example.specimen_id == "#{example.fragment}-specimen"
      assert example.preview_fragment == example.fragment
      assert example.source_fragment == "#{example.fragment}-source"
      assert example.source_relationship == example.source_id
      assert example.source_compile == accordion.verification.source_compile
      assert example.component_identity == accordion.provenance_id
    end
  end

  test "layout resolution is closed and cosmetic classes stay outside catalogue metadata" do
    assert PresentationCatalogue.layout_identities() ==
             ~w(centered composition constrained overflow start tall)

    for identity <- PresentationCatalogue.layout_identities() do
      assert PresentationCatalogue.layout_class!(identity) ==
               "gallery-specimen--#{identity}"
    end

    hostile = ["unknown", "gallery-specimen--centered", "<script>", "Elixir.System", "../asset"]

    for value <- hostile do
      assert_raise ArgumentError, fn -> PresentationCatalogue.layout_class!(value) end
    end

    before = :erlang.system_info(:atom_count)

    for value <- hostile do
      assert_raise ArgumentError, fn -> PresentationCatalogue.layout_class!(value) end
    end

    assert :erlang.system_info(:atom_count) == before

    metadata = DocumentationCatalogue.entries() |> Enum.map(& &1.presentation) |> inspect()
    refute metadata =~ ~r/(gallery-specimen--|class_name|"class")/
  end

  test "presentation audit rejects missing, duplicate, unknown, and cosmetic declarations" do
    entries = DocumentationCatalogue.entries()
    index = Enum.find_index(entries, &(&1.render == :accordion))
    accordion = Enum.at(entries, index)

    missing = put_in(accordion.presentation.description, "")

    assert {:error, errors} =
             PresentationCatalogue.audit(List.replace_at(entries, index, missing))

    assert "missing presentation description: #{accordion.route}" in errors

    duplicate =
      update_in(accordion.presentation.features, fn [first | rest] -> [first, first | rest] end)

    assert {:error, errors} =
             PresentationCatalogue.audit(List.replace_at(entries, index, duplicate))

    assert Enum.any?(errors, &String.starts_with?(&1, "duplicate feature:"))

    unknown =
      update_in(accordion.examples, fn [first | rest] ->
        [Map.put(first, :layout, "<script>") | rest]
      end)

    assert {:error, errors} =
             PresentationCatalogue.audit(List.replace_at(entries, index, unknown))

    assert "unknown specimen layout: #{accordion.route}" in errors

    cosmetic = update_in(accordion.presentation, &Map.put(&1, :class, "arbitrary visitor class"))

    assert {:error, errors} =
             PresentationCatalogue.audit(List.replace_at(entries, index, cosmetic))

    assert "cosmetic class leaked into presentation metadata: #{accordion.route}" in errors
  end

  test "related documentation stays within authored ordinary routes" do
    for entry <- DocumentationCatalogue.entries() do
      related = DocumentationCatalogue.related(entry)
      destinations = Enum.map(related.components ++ related.compositions, & &1.path)

      assert destinations != []
      assert Enum.uniq(destinations) == destinations
      assert Enum.all?(destinations, &(&1 in Catalogue.routes()))
      refute entry.route in destinations
    end
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
    assert length(report) == 63
    assert Enum.map(report, & &1.route) == Enum.sort(Catalogue.routes())

    component_report = Enum.filter(report, &(&1.kind == "component"))
    assert Enum.map(component_report, & &1.route) == Enum.sort(Enum.map(entries, & &1.route))

    for row <- component_report do
      assert row.documentation
      assert row.public_metadata
      assert row.public_import
      assert row.exdoc_group
      assert row.provenance
      assert row.renderer
      assert row.browser_route == row.route
      assert row.export_route == row.route
      assert String.starts_with?(row.source_compile, "source:")
      assert row.description
      assert row.specimens > 0
      assert row.source
      assert row.features != []
      assert row.support != []
      assert row.fallback
      assert row.mapping in ~w(upstream-counterpart semantic-exception)
      assert row.authored_ready
    end

    assert Enum.count(report, & &1.migrated) == 22
    assert Enum.count(report, & &1.visually_reviewed) == 22
    assert Enum.count(report, & &1.accepted) == 1
  end

  test "completeness output is deterministic and contains no host paths or clocks" do
    first = DocumentationCatalogue.completeness_json()
    second = DocumentationCatalogue.completeness_json()

    assert first == second
    assert Jason.decode!(first) |> length() == 63
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
