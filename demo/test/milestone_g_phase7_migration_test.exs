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

  test "Phase 7.2 migrates navigation, content, overlay, and interactive component routes", %{
    conn: conn
  } do
    entries =
      DocumentationCatalogue.entries()
      |> Enum.filter(
        &(&1.category.slug in [
            "navigation",
            "content-surfaces",
            "overlays",
            "interactive-surfaces"
          ])
      )

    assert length(entries) == 13

    for entry <- entries do
      assert entry.presentation.status.migrated
      assert entry.presentation.status.visually_reviewed
      refute entry.presentation.status.accepted
      assert entry.presentation.status.migration_wave == "7.2"

      html = conn |> recycle() |> get(entry.route) |> html_response(200)
      assert html =~ entry.presentation.counterpart.local_changes
      assert html =~ ~s(data-gallery-component-support)

      if entry.category.slug in ["overlays", "interactive-surfaces"] do
        assert html =~ ~s(id="ordinary-alternative")
      end
    end

    exceptions =
      entries
      |> Enum.filter(&(&1.presentation.counterpart.kind == "semantic-exception"))
      |> Enum.map(& &1.provenance_id)
      |> Enum.sort()

    assert exceptions == ~w(content.radio_panels overlays.dropdown-actions)
  end

  test "Phase 7.2 related compositions use the shared introduction and fallback wrapper", %{
    conn: conn
  } do
    renders = [
      :documentation,
      :settings,
      :application_shell,
      :overlay_capabilities,
      :settings_confirmation,
      :responsive_drawers,
      :anchored_actions,
      :supplemental_help
    ]

    compositions = Enum.filter(Catalogue.compositions(), &(&1.render in renders))
    assert length(compositions) == 8

    for composition <- compositions do
      {:ok, presentation} =
        DocumentationCatalogue.lookup_presentation_route(composition.path)

      assert presentation.status.migration_wave == "7.2"
      html = conn |> recycle() |> get(composition.path) |> html_response(200)
      assert html =~ ~s(data-gallery-composition-article="#{presentation.identity}")
      assert html =~ "Support and exact fallback"
      assert html =~ presentation.description
      assert html =~ presentation.exact_fallback
    end
  end

  test "Phase 7.2 closes distinct layout and evidence identities" do
    entries = DocumentationCatalogue.entries() |> Map.new(&{&1.render, &1})

    for render <- [:navigation_menu, :scroll_area],
        do: assert(hd(entries[render].examples).layout == "overflow")

    for render <- [:dialog, :drawer], do: assert(hd(entries[render].examples).layout == "tall")

    evidence =
      "priv/reference/milestone_g/phase-07-section-2-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["componentRoutes"] == 13
    assert evidence["compositionRoutes"] == 8

    assert evidence["semanticExceptions"] ==
             ~w(content.radio_panels overlays.dropdown-actions)

    assert "ordinary-alternatives" in evidence["reviewedStates"]
    refute evidence["accepted"]
  end

  test "Phase 7.3 migrates Media and Motion components with exact fallback evidence", %{
    conn: conn
  } do
    entries =
      DocumentationCatalogue.entries()
      |> Enum.filter(&(&1.category.slug in ["media", "motion"]))

    assert length(entries) == 6

    for entry <- entries do
      assert entry.presentation.status.migrated
      assert entry.presentation.status.visually_reviewed
      refute entry.presentation.status.accepted
      assert entry.presentation.status.migration_wave == "7.3"

      html = conn |> recycle() |> get(entry.route <> "?motion=reduce") |> html_response(200)
      assert html =~ ~s(data-gallery-motion-inspection="reduce")
      assert html =~ entry.presentation.exact_fallback
      assert html =~ entry.presentation.counterpart.local_changes
    end
  end

  test "Phase 7.3 media and motion compositions retain local complete content", %{conn: conn} do
    renders = [:image_gallery, :motion_preferences, :media_browser, :motion_media_capabilities]
    compositions = Enum.filter(Catalogue.compositions(), &(&1.render in renders))
    assert length(compositions) == 4

    for composition <- compositions do
      {:ok, presentation} =
        DocumentationCatalogue.lookup_presentation_route(composition.path)

      assert presentation.status.migration_wave == "7.3"
      html = conn |> recycle() |> get(composition.path <> "?motion=reduce") |> html_response(200)
      assert html =~ ~s(data-gallery-composition-article="#{presentation.identity}")
      assert html =~ "Support and exact fallback"
      refute html =~ ~r/https?:\/\/(?:images|cdn|media)\./
    end
  end

  test "Phase 7.3 closes advanced layouts and records semantic exceptions" do
    entries = DocumentationCatalogue.entries() |> Map.new(&{&1.render, &1})

    for render <- [:carousel, :cover_flow, :marquee],
        do: assert(hd(entries[render].examples).layout == "overflow")

    for render <- [:image_gallery, :scroll_indicator],
        do: assert(hd(entries[render].examples).layout == "tall")

    assert hd(entries.stagger.examples).layout == "constrained"

    evidence =
      "priv/reference/milestone_g/phase-07-section-3-evidence.json"
      |> File.read!()
      |> Jason.decode!()

    assert evidence["componentRoutes"] == 6
    assert evidence["compositionRoutes"] == 4
    assert evidence["semanticExceptions"] == ~w(media.carousel media.cover-flow)
    assert "reduced-motion" in evidence["reviewedStates"]
    assert "rights-metadata" in evidence["reviewedStates"]
    refute evidence["accepted"]
  end
end
