defmodule ShadcnUIDemo.MilestoneGPhase7AcceptanceTest do
  use ShadcnUIDemoWeb.ConnCase, async: false

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue, PresentationCatalogue}

  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.complete_migration
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  test "all 63 authored-ready routes are migrated and reviewed without inflating acceptance" do
    inventory = DocumentationCatalogue.presentation_inventory()

    assert :ok = PresentationCatalogue.audit_inventory(inventory)
    assert Enum.map(inventory, & &1.route) == Catalogue.routes()
    assert length(inventory) == 63
    assert Enum.all?(inventory, & &1.status.authored_ready)
    assert Enum.all?(inventory, & &1.status.migrated)
    assert Enum.all?(inventory, & &1.status.visually_reviewed)
    assert Enum.count(inventory, & &1.status.accepted) == 1

    assert Enum.find(inventory, & &1.status.accepted).route ==
             "/components/disclosure/accordion"
  end

  test "every canonical route renders the shared shell and its literal article structure", %{
    conn: conn
  } do
    for presentation <- DocumentationCatalogue.presentation_inventory() do
      html = conn |> recycle() |> get(presentation.route) |> html_response(200)

      assert html =~ ~s(data-gallery-product-header)
      assert html =~ ~s(data-gallery-main)
      assert html =~ ~s(data-gallery-metadata)
      assert html =~ ~s(data-gallery-package-version>Package 0.1.0</p>)

      assert html =~
               ~s(rel="canonical" href="https://pcharbon70-shadcn-ui-demo.fly.dev#{presentation.route}")

      case presentation.kind do
        "landing" ->
          assert html =~ ~s(data-gallery-discovery="landing")
          assert html =~ ~s(data-gallery-featured-specimens)

        "category" ->
          assert html =~
                   ~s(data-gallery-discovery="#{String.trim_leading(presentation.route, "/components/")}")

          assert html =~ ~s(data-gallery-category-components)

        "component" ->
          assert html =~ ~s(data-gallery-component-article)
          assert html =~ ~s(data-gallery-example=)
          assert html =~ ~s(data-gallery-provenance)

        "composition" ->
          assert html =~ ~s(data-gallery-composition-article="#{presentation.identity}")
          assert html =~ ~s(data-gallery-composition-body)
      end
    end
  end

  test "every canonical static destination retains the same structural contract" do
    Mix.Task.reenable("gallery.export")
    Mix.Task.run("gallery.export")

    manifest = Jason.decode!(File.read!("export/route-manifest.json"))
    default_routes = Enum.filter(manifest["routes"], &(&1["request"] in Catalogue.routes()))

    assert length(default_routes) == 63
    assert Enum.map(default_routes, & &1["request"]) == Catalogue.routes()

    for entry <- default_routes do
      html = File.read!(Path.join("export", entry["file"]))
      assert entry["status"] == 200
      assert html =~ ~s(data-gallery-product-header)
      assert html =~ ~s(data-gallery-main)
      assert html =~ ~s(data-gallery-metadata)

      if String.starts_with?(entry["request"], "/components/") and
           Enum.any?(Catalogue.components(), &(&1.path == entry["request"])) do
        assert html =~ ~s(data-gallery-component-article)
        assert html =~ ~s(data-gallery-specimen-source)
      end
    end
  end

  test "Phase 7 evidence binds the full route, family, preference, and delivery matrix" do
    evidence =
      "priv/reference/milestone_g/phase-07-section-5-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["inventory"] == %{
             "acceptedRoutes" => 1,
             "categoryRoutes" => 9,
             "componentRoutes" => 41,
             "compositionRoutes" => 12,
             "landingRoutes" => 1,
             "migratedRoutes" => 63,
             "reviewedRoutes" => 63,
             "totalRoutes" => 63
           }

    assert length(evidence["browserMatrix"]["families"]) == 9
    assert evidence["browserMatrix"]["themes"] == ~w(light dark)
    assert evidence["browserMatrix"]["viewports"] == ~w(desktop mobile)

    assert evidence["browserMatrix"]["specimenLayouts"] ==
             ~w(centered composition constrained overflow start tall)

    assert evidence["packageAudit"]["changedRuntimeFiles"] == []
    refute evidence["accepted"]
    assert evidence["acceptancePhase"] == "8"
  end
end
