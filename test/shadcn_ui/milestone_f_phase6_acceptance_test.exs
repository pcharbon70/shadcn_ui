defmodule ShadcnUI.MilestoneFPhase6AcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.documentation_catalogue.closed_schema
  # covers: shadcn_ui.documentation_catalogue.public_api_parity
  # covers: shadcn_ui.documentation_catalogue.stable_information_architecture
  # covers: shadcn_ui.documentation_catalogue.stable_examples
  # covers: shadcn_ui.documentation_catalogue.safe_resolution
  # covers: shadcn_ui.documentation_catalogue.progressive_navigation
  # covers: shadcn_ui.documentation_catalogue.deterministic_search
  # covers: shadcn_ui.documentation_catalogue.progressive_search
  # covers: shadcn_ui.documentation_catalogue.completeness_report
  # covers: shadcn_ui.documentation_catalogue.package_boundary
  # covers: shadcn_ui.public_documentation.component_page_sections
  # covers: shadcn_ui.public_documentation.api_contract
  # covers: shadcn_ui.public_documentation.installation_and_assets
  # covers: shadcn_ui.public_documentation.compatibility_and_fallback
  # covers: shadcn_ui.public_documentation.controller_example
  # covers: shadcn_ui.public_documentation.transport_guidance
  # covers: shadcn_ui.public_documentation.exdoc_inventory
  # covers: shadcn_ui.public_documentation.upgrade_and_migration
  # covers: shadcn_ui.public_documentation.provenance_and_identity
  # covers: shadcn_ui.compatibility_accessibility.capability_policy
  # covers: shadcn_ui.compatibility_accessibility.exact_engine_evidence
  # covers: shadcn_ui.compatibility_accessibility.consumer_boundary
  # covers: shadcn_ui.compatibility_accessibility.fallback_evidence
  # covers: shadcn_ui.compatibility_accessibility.responsive_and_preferences
  # covers: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
  # covers: shadcn_ui.compatibility_accessibility.automated_accessibility
  # covers: shadcn_ui.compatibility_accessibility.manual_review
  # covers: shadcn_ui.compatibility_accessibility.evidence_separation
  # covers: shadcn_ui.release_publication.version_identity
  # covers: shadcn_ui.release_publication.deterministic_export
  # covers: shadcn_ui.release_publication.health_manifest
  # covers: shadcn_ui.release_publication.deployment_workflow
  # covers: shadcn_ui.release_publication.post_deploy_and_rollback
  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.clean_consumer_trial
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates

  @specs ~w(
    .spec/specs/documentation_catalogue.spec.md
    .spec/specs/public_documentation.spec.md
    .spec/specs/compatibility_accessibility.spec.md
    .spec/specs/release_publication.spec.md
  )

  test "one executable acceptance surface references all 38 Milestone F requirements" do
    requirements =
      @specs
      |> Enum.flat_map(fn path ->
        Regex.scan(~r/^- id: (shadcn_ui\.[a-z_]+\.[a-z_]+)$/m, File.read!(path),
          capture: :all_but_first
        )
      end)
      |> List.flatten()
      |> MapSet.new()

    covers =
      __ENV__.file
      |> File.read!()
      |> then(
        &Regex.scan(~r/^\s*# covers: (shadcn_ui\.[a-z_]+\.[a-z_]+)$/m, &1,
          capture: :all_but_first
        )
      )
      |> List.flatten()
      |> MapSet.new()

    assert MapSet.size(requirements) == 38
    assert covers == requirements
  end

  test "catalogue, documentation, compatibility, and package identities remain closed" do
    catalogue = Jason.decode!(File.read!("priv/compatibility/catalogue.json"))

    modules =
      Path.wildcard("lib/shadcn_ui/components/**/*.ex")
      |> Enum.map(&File.read!/1)
      |> Enum.flat_map(
        &Regex.scan(~r/defmodule (ShadcnUI\.Components\.[A-Za-z.]+)/, &1, capture: :all_but_first)
      )
      |> List.flatten()
      |> Enum.uniq()

    assert map_size(catalogue["components"]) == 41
    assert length(modules) == 48

    assert File.read!("release/records/milestone-f-acceptance.md") =~
             "all 41 component-page audits"

    assert Mix.Project.config()[:version] == "1.0.0"
  end

  test "truthful gates block qualification without adding a runtime or consumer target" do
    status = Jason.decode!(File.read!("release/candidate-status.json"))
    mandatory = Enum.filter(status["gates"], & &1["mandatory"])
    files = Mix.Project.config()[:package][:files]

    refute status["qualification"]["qualified"]
    assert Enum.any?(mandatory, &(&1["status"] in ["failed", "pending"]))
    refute Enum.any?(files, &String.starts_with?(&1, "demo"))
    refute Enum.any?(files, &String.starts_with?(&1, "scripts"))
    refute Enum.any?(files, &String.ends_with?(&1, ".js"))

    corpus = File.read!("AGENTS.md") <> File.read!("README.md")
    assert corpus =~ "transport-neutral"
    refute File.read!("mix.exs") =~ ~r/{:(dstar|ash|electron),/
  end

  test "publication verification records deployed evidence without pre-claiming CI or merge" do
    workflow = File.read!(".github/workflows/gallery.yml")
    status = Jason.decode!(File.read!("release/candidate-status.json"))
    deployment = Jason.decode!(File.read!("release/fly-deployment-evidence.json"))

    assert workflow =~ "push:"
    assert workflow =~ "branches: [main]"
    refute workflow =~ "actions/deploy-pages"
    assert status["evidence"]["finalPhase5Revision"] == nil
    assert status["evidence"]["deployedRevision"] == deployment["release"]["sourceRevision"]
    assert deployment["release"]["status"] == "passed"
    assert deployment["canonicalSmoke"]["status"] == "passed"

    gates = Map.new(status["gates"], &{&1["id"], &1["status"]})
    assert gates["ci-final-revision"] == "pending"
    assert gates["deployment-source-review"] == "pending"
    assert gates["merge"] == "pending"
    assert gates["gallery-deployment"] == "passed"
    assert gates["post-deploy-smoke"] == "passed"
  end
end
