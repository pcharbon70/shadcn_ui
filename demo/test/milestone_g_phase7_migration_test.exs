defmodule ShadcnUIDemo.MilestoneGPhase7MigrationTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue}

  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.catalogue_metadata
  # covers: shadcn_ui.gallery_presentation.complete_migration

  test "Phase 7.1 migrates Foundation and Forms through literal catalogue metadata", %{conn: conn} do
    entries =
      DocumentationCatalogue.entries()
      |> Enum.filter(&(&1.category.slug in ["foundation", "forms"]))

    assert length(entries) == 21

    for entry <- entries do
      assert entry.presentation.status.migrated
      assert entry.presentation.status.visually_reviewed
      refute entry.presentation.status.accepted
      assert entry.presentation.status.migration_wave == "7.1"

      assert entry.presentation.status.visual_evidence == [
               "demo/priv/reference/milestone_g/phase-07-section-1-evidence.json"
             ]

      html = conn |> recycle() |> get(entry.route) |> html_response(200)
      assert html =~ ~s(data-gallery-component-article)
      assert html =~ ~s(data-gallery-capability="native-baseline")
      assert html =~ ~s(data-gallery-capability="fallback")
      assert html =~ entry.presentation.counterpart.local_changes
    end
  end

  test "Phase 7.1 specimen layouts match dense and constrained content" do
    layouts =
      DocumentationCatalogue.entries()
      |> Map.new(fn entry -> {entry.render, hd(entry.examples).layout} end)

    for render <- [:button, :badge, :avatar, :label, :help, :field_errors],
        do: assert(layouts[render] == "start")

    for render <- [
          :alert,
          :card,
          :skeleton,
          :field,
          :error_summary,
          :input,
          :textarea,
          :checkbox,
          :radio_group,
          :switch,
          :native_select,
          :enhanced_select,
          :slider,
          :progress,
          :meter
        ],
        do: assert(layouts[render] == "constrained")
  end

  test "Phase 7.1 evidence records reviewed states without claiming final acceptance" do
    evidence =
      "priv/reference/milestone_g/phase-07-section-1-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["evidenceType"] == "local-reviewed-migration-wave"
    assert evidence["componentRoutes"] == 21
    assert length(evidence["compositionRoutes"]) == 3
    assert "native-submission" in evidence["reviewedStates"]
    assert "forced-colors-contract" in evidence["reviewedStates"]
    refute evidence["accepted"]
    assert evidence["acceptancePhase"] == "8"
  end

  test "standalone form compositions use the gallery shell and preserve submission boundaries", %{
    conn: conn
  } do
    for route <- Catalogue.form_routes() do
      html = conn |> recycle() |> get(route) |> html_response(200)
      assert html =~ ~s(data-gallery-product-header)
      assert html =~ ~s(data-gallery-documentation-grid)
      assert html =~ ~s(data-gallery-form-composition)
      assert html =~ ~s(action="/forms/submit")
      assert html =~ "Application ownership"
    end

    static = conn |> recycle() |> get("/forms/profile?static=1") |> html_response(200)
    assert static =~ "Static export: submission is intentionally disabled."
    refute static =~ ~s(action="/forms/submit")
  end
end
