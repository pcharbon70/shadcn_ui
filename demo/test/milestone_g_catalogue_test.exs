defmodule ShadcnUIDemo.MilestoneGCatalogueTest do
  use ExUnit.Case, async: false

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue, PresentationCatalogue}

  @repo_root Path.expand("../..", __DIR__)

  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.catalogue_metadata
  # covers: shadcn_ui.gallery_presentation.stable_identity
  # covers: shadcn_ui.gallery_presentation.complete_migration

  test "defining components and authored presentation metadata agree one-to-one" do
    entries = DocumentationCatalogue.entries()
    inventory = DocumentationCatalogue.presentation_inventory()
    component_inventory = Enum.filter(inventory, &(&1.kind == "component"))

    assert :ok = DocumentationCatalogue.validate()
    assert length(entries) == 41
    assert length(component_inventory) == 41
    assert Enum.map(entries, & &1.route) == Enum.map(component_inventory, & &1.route)

    for {entry, presentation} <- Enum.zip(entries, component_inventory) do
      assert entry.route == presentation.route
      assert entry.provenance_id == presentation.identity
      assert Atom.to_string(entry.public.function) == entry.presentation.defining_function
      assert entry.examples == presentation.specimens
      assert Enum.all?(entry.examples, &(&1.source_compile == entry.verification.source_compile))
      assert entry.presentation.description == entry.documentation.what
      assert entry.presentation.exact_fallback == entry.documentation.fallback
      assert entry.presentation.features == presentation.features
      assert entry.presentation.support_rows == presentation.support_rows
    end
  end

  test "migration waves remain distinct from final acceptance" do
    inventory = DocumentationCatalogue.presentation_inventory()

    assert Enum.map(inventory, & &1.route) == Catalogue.routes()
    assert Enum.all?(inventory, & &1.status.authored_ready)
    assert Enum.count(inventory, & &1.status.migrated) == 53
    assert Enum.count(inventory, & &1.status.visually_reviewed) == 53
    assert Enum.count(inventory, & &1.status.accepted) == 1

    assert %{route: "/components/disclosure/accordion", status: %{accepted: true}} =
             Enum.find(inventory, & &1.status.accepted)
  end

  test "route, search, fragment, feature, and layout strings remain inert" do
    {:ok, accordion} = DocumentationCatalogue.lookup("disclosure", "accordion")
    hostile = ["Elixir.System", "../../asset", "<script>", "reference:callback", "unknown"]

    for value <- hostile do
      DocumentationCatalogue.lookup(value, value)
      DocumentationCatalogue.lookup_route(value)
      DocumentationCatalogue.lookup_fragment(value, value)
      PresentationCatalogue.feature(accordion.presentation, value)

      assert_raise ArgumentError, fn -> PresentationCatalogue.layout_class!(value) end
    end

    before = :erlang.system_info(:atom_count)

    for value <- hostile do
      assert :error = DocumentationCatalogue.lookup(value, value)
      assert :error = DocumentationCatalogue.lookup_route(value)
      assert :error = DocumentationCatalogue.lookup_fragment(value, value)
      assert :error = PresentationCatalogue.feature(accordion.presentation, value)
      assert_raise ArgumentError, fn -> PresentationCatalogue.layout_class!(value) end
    end

    assert :erlang.system_info(:atom_count) == before
  end

  test "search, sitemap, and completeness outputs are byte-identical and demo-only" do
    outputs = fn ->
      %{
        search: DocumentationCatalogue.search_json(),
        sitemap: DocumentationCatalogue.sitemap_xml(),
        completeness: DocumentationCatalogue.completeness_json()
      }
    end

    assert outputs.() == outputs.()

    first = outputs.()
    assert length(Jason.decode!(first.completeness)) == 63
    assert length(Regex.scan(~r/<url><loc>/, first.sitemap)) == 66
    refute inspect(first) =~ Path.expand(@repo_root)

    package_files = Mix.Project.deps_paths() |> Map.fetch!(:shadcn_ui) |> Path.join("mix.exs")
    release_source = File.read!(package_files)
    refute release_source =~ "presentation_catalogue.ex"
    refute release_source =~ "completeness"
  end

  test "checked Phase 6 evidence byte-matches every deterministic output" do
    evidence =
      "priv/reference/milestone_g/phase-06-catalogue-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    outputs = %{
      "search" => DocumentationCatalogue.search_json(),
      "sitemap" => DocumentationCatalogue.sitemap_xml()
    }

    assert evidence["evidenceType"] == "local-automated-catalogue-evidence"
    assert evidence["inventory"]["galleryRoutes"] == 63
    assert evidence["inventory"]["authoredReady"] == 63
    assert evidence["inventory"]["accepted"] == 1
    assert evidence["outputs"]["completeness"]["bytes"] == 54_171
    assert evidence["outputs"]["completeness"]["sha256"] =~ ~r/^[a-f0-9]{64}$/

    for {identity, bytes} <- outputs do
      expected = evidence["outputs"][identity]
      assert expected["bytes"] == byte_size(bytes)

      assert expected["sha256"] ==
               :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)
    end
  end
end
