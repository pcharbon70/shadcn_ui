defmodule ShadcnUIDemo.MilestoneGPhase8FunctionalTest do
  use ShadcnUIDemoWeb.ConnCase, async: true

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue, PresentationCatalogue}

  # covers: shadcn_ui.gallery_presentation.accessibility_matrix
  # covers: shadcn_ui.gallery_presentation.complete_migration
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  test "every public identity remains migrated, reviewed, source-backed, and routable", %{
    conn: conn
  } do
    inventory = DocumentationCatalogue.presentation_inventory()

    assert :ok = PresentationCatalogue.audit_inventory(inventory)
    assert Enum.map(inventory, & &1.route) == Catalogue.routes()
    assert length(inventory) == 63
    assert Enum.all?(inventory, &(&1.status.migrated and &1.status.visually_reviewed))

    for component <- Catalogue.components() do
      html = conn |> recycle() |> get(component.path) |> html_response(200)
      assert html =~ ~s(data-gallery-component-article)
      assert html =~ ~s(data-gallery-specimen-source)
      assert html =~ ~s(data-gallery-provenance)
      assert html =~ ~s(rel="canonical")
    end
  end

  test "functional evidence records the exact engines, preference states, and package boundary" do
    evidence =
      "priv/reference/milestone_g/phase-08-section-2-functional-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["status"] == "passed"
    assert evidence["inventory"]["canonicalRoutes"] == 63
    assert evidence["inventory"]["reviewedRoutes"] == 63

    assert Enum.map(evidence["browserMatrix"]["engines"], & &1["name"]) ==
             ~w(chromium firefox webkit)

    assert evidence["browserMatrix"]["phase8Tests"] == 9
    assert "javascript-disabled" in evidence["browserMatrix"]["states"]
    assert "forced-colors" in evidence["browserMatrix"]["states"]
    assert "presentation-assets-missing" in evidence["browserMatrix"]["states"]
    assert evidence["packageAudit"]["changedRuntimeFiles"] == []
    assert evidence["packageAudit"]["archiveEntries"] == 62
  end

  test "all checked Milestone G evidence remains local and present" do
    for file <- ~w(
      phase-03-presentation-evidence.json
      phase-05-accordion-evidence.json
      phase-06-catalogue-evidence.json
      phase-07-section-1-evidence.json
      phase-07-section-2-evidence.json
      phase-07-section-3-evidence.json
      phase-07-section-4-evidence.json
      phase-07-section-5-evidence.json
      phase-08-section-1-visual-evidence.json
      phase-08-section-2-functional-evidence.json
    ) do
      evidence = Jason.decode!(File.read!(Path.join("priv/reference/milestone_g", file)))
      assert evidence["schemaVersion"] == 1
    end
  end
end
