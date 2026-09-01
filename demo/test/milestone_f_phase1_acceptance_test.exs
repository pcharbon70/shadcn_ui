defmodule ShadcnUIDemo.MilestoneFPhase1AcceptanceTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.{BuildIdentity, Catalogue, DocumentationCatalogue}

  # covers: shadcn_ui.documentation_catalogue.closed_schema
  # covers: shadcn_ui.documentation_catalogue.public_api_parity
  # covers: shadcn_ui.documentation_catalogue.stable_information_architecture
  # covers: shadcn_ui.documentation_catalogue.stable_examples
  # covers: shadcn_ui.documentation_catalogue.safe_resolution
  # covers: shadcn_ui.documentation_catalogue.completeness_report
  # covers: shadcn_ui.documentation_catalogue.package_boundary
  # covers: shadcn_ui.release_publication.version_identity

  test "actual public metadata, documentation, provenance, and stable routes agree" do
    assert :ok = DocumentationCatalogue.validate()
    entries = DocumentationCatalogue.entries()
    report = DocumentationCatalogue.completeness_report()

    assert length(entries) == 41
    assert length(report) == 63

    assert MapSet.new(entries, & &1.route) ==
             Catalogue.components() |> MapSet.new(& &1.path)

    assert Enum.all?(Enum.filter(report, &(&1.kind == "component")), fn row ->
             row.documentation and row.public_metadata and row.public_import and
               row.exdoc_group and row.provenance and row.renderer and
               row.browser_route == row.route and row.export_route == row.route
           end)
  end

  test "every canonical route footer renders only the package version", %{conn: conn} do
    identity = BuildIdentity.current!()

    for route <- Catalogue.routes() do
      html = conn |> recycle() |> get(route) |> html_response(200)

      footer =
        html
        |> LazyHTML.from_document()
        |> LazyHTML.query("[data-gallery-package-version]")
        |> LazyHTML.text()
        |> String.trim()

      assert footer == "Package #{identity.package_version}"
      refute footer =~ identity.build_revision
      refute footer =~ identity.upstream_revision
      refute footer =~ ~r/(build|catalogue|upstream)/i
    end
  end

  test "identity and completeness encodings are deterministic and non-secret" do
    identity = BuildIdentity.current!()

    release_first = identity |> BuildIdentity.release_metadata() |> Jason.encode!()
    release_second = identity |> BuildIdentity.release_metadata() |> Jason.encode!()
    catalogue_first = DocumentationCatalogue.completeness_json()
    catalogue_second = DocumentationCatalogue.completeness_json()

    assert release_first == release_second
    assert catalogue_first == catalogue_second

    refute release_first <> catalogue_first =~
             ~r/(gh[opsu]_[A-Za-z0-9]+|BEGIN [A-Z ]+PRIVATE KEY|password|secret)/i
  end

  test "request-like strings remain data and never grow the atom table" do
    hostile = ["Elixir.System", "../../mix.exs", "<script>", String.duplicate("x", 2_000)]

    Enum.each(hostile, fn value ->
      DocumentationCatalogue.lookup(value, value)
      DocumentationCatalogue.lookup_route(value)
      DocumentationCatalogue.lookup_fragment(value, value)
    end)

    before = :erlang.system_info(:atom_count)

    Enum.each(hostile, fn value ->
      assert :error = DocumentationCatalogue.lookup(value, value)
      assert :error = DocumentationCatalogue.lookup_route(value)
      assert :error = DocumentationCatalogue.lookup_fragment(value, value)
    end)

    assert :erlang.system_info(:atom_count) == before
  end
end
