defmodule ShadcnUI.MilestoneGAcceptanceTest do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)

  # covers: shadcn_ui.gallery_presentation.semantic_exceptions
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution
  # covers: shadcn_ui.gallery_presentation.complete_migration

  test "accepted semantic exceptions stay explicit authored identities" do
    source =
      File.read!(Path.join(@root, "demo/lib/shadcn_ui_demo/presentation_catalogue.ex"))

    assert source =~
             "@semantic_exceptions ~w(content.radio_panels overlays.dropdown-actions media.carousel media.cover-flow)"

    for identity <-
          ~w(content.radio_panels overlays.dropdown-actions media.carousel media.cover-flow) do
      assert source =~ identity
    end

    refute source =~ ~r/(String\.to_atom|Module\.concat|Code\.eval|Phoenix\.LiveView|GenServer)/
  end

  test "catalogue evidence and reports cannot enter package release contents" do
    package_files = Mix.Project.config()[:package][:files]
    mixfile = File.read!(Path.join(@root, "mix.exs"))

    for excluded <- ["demo", ".spec", "test", "playwright", "completeness"] do
      refute Enum.any?(package_files, &String.starts_with?(&1, excluded))
    end

    refute mixfile =~ "presentation_catalogue.ex"
    refute mixfile =~ "milestone_g_catalogue_test.exs"
  end

  test "Phase 6 prepares every route while preserving Phase 7 migration truth" do
    source =
      File.read!(Path.join(@root, "demo/lib/shadcn_ui_demo/presentation_catalogue.ex"))

    catalogue = File.read!(Path.join(@root, "demo/lib/shadcn_ui_demo/catalogue.ex"))

    phase =
      File.read!(
        Path.join(
          @root,
          ".spec/planning/milestone-g-unscripted-style-gallery-presentation-parity/phase-06-closed-catalogue-presentation-metadata.md"
        )
      )

    assert source =~ "authored_ready: true"
    assert source =~ ~s(@accordion_route "/components/disclosure/accordion")
    assert source =~ "migrated: false"
    assert source =~ "visually_reviewed: false"
    assert source =~ "accepted: false"
    assert catalogue =~ "gallery ++ composition_routes()"
    assert phase =~ "Distinguish authored-ready, migrated, visually reviewed and accepted"
  end
end
