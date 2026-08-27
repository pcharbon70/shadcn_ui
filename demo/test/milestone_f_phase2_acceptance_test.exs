defmodule ShadcnUIDemo.MilestoneFPhase2AcceptanceTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue}

  # covers: shadcn_ui.documentation_catalogue.stable_information_architecture
  # covers: shadcn_ui.documentation_catalogue.stable_examples
  # covers: shadcn_ui.documentation_catalogue.progressive_navigation
  # covers: shadcn_ui.documentation_catalogue.deterministic_search
  # covers: shadcn_ui.documentation_catalogue.progressive_search
  # covers: shadcn_ui.documentation_catalogue.package_boundary

  test "all 41 component pages connect navigation, metadata, preview, source, and canonical identity",
       %{conn: conn} do
    assert :ok = DocumentationCatalogue.validate()

    for entry <- DocumentationCatalogue.entries() do
      html = conn |> recycle() |> get(entry.route) |> html_response(200)
      example = hd(entry.examples)

      assert html =~ ~s(id="#{example.fragment}")
      assert html =~ ~s(id="#{example.fragment}-source")
      assert html =~ ~s(data-gallery-example="#{example.source_id}")

      assert html =~
               ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{entry.route}")

      assert html =~
               entry.documentation.source
               |> Phoenix.HTML.html_escape()
               |> Phoenix.HTML.safe_to_string()
    end
  end

  test "progressive search metadata appears twice while every ordinary route remains reachable",
       %{conn: conn} do
    html = conn |> get("/") |> html_response(200)

    assert length(Regex.scan(~r/data-gallery-search-item/, html)) == 82
    assert length(Regex.scan(~r/data-gallery-search-route=/, html)) == 82
    assert html =~ ~s(type="search")
    assert html =~ "41 components available"

    for component <- Catalogue.components() do
      assert length(Regex.scan(~r/href="#{Regex.escape(component.path)}"/, html)) == 2
    end
  end
end
