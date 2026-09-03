defmodule ShadcnUIDemo.MilestoneGRemediationR6Test do
  use ExUnit.Case, async: true

  @repo_root Path.expand("../..", __DIR__)
  @risk_evidence File.read!("priv/reference/milestone_g/remediation-r6-manual-risk-evidence.json")
                 |> Jason.decode!()
  @regression File.read!("priv/reference/milestone_g/remediation-r6-regression-evidence.json")
              |> Jason.decode!()
  @candidate File.read!(Path.join(@repo_root, "release/candidate-status.json")) |> Jason.decode!()

  # covers: shadcn_ui.compatibility_accessibility.manual_review
  # covers: shadcn_ui.compatibility_accessibility.evidence_separation
  # covers: shadcn_ui.compatibility_accessibility.exact_engine_evidence
  # covers: shadcn_ui.compatibility_accessibility.automated_accessibility
  # covers: shadcn_ui.release_publication.truthful_gates
  # covers: shadcn_ui.release_publication.deterministic_export
  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.clean_consumer_trial
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.public_documentation.compatibility_and_fallback
  # covers: shadcn_ui.public_documentation.upgrade_and_migration
  # covers: shadcn_ui.gallery.semantic_shell
  # covers: shadcn_ui.gallery.theme_matrix
  # covers: shadcn_ui.gallery.deterministic_assets
  # covers: shadcn_ui.gallery.static_export
  # covers: shadcn_ui.gallery_presentation.accessibility_matrix
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution
  # covers: shadcn_ui.gallery_presentation.complete_migration

  test "R6.1 records the owner-approved bypass without promoting manual evidence" do
    assert @risk_evidence["status"] == "risk-accepted-manual-review-pending"
    assert @risk_evidence["authorization"]["doesNotAuthorizeDeployment"]
    assert @risk_evidence["authorization"]["doesNotQualifyCandidate"]
    assert @risk_evidence["authorization"]["doesNotClaimConformance"]

    assert Enum.all?(@risk_evidence["scenarios"], fn scenario ->
             scenario["status"] == "PENDING" and
               scenario["disposition"] == "risk-accepted-not-run"
           end)

    assert @risk_evidence["gateEffect"] == %{
             "candidateQualification" => "blocked",
             "manualAccessibility" => "pending",
             "r6Progression" => "allowed-by-explicit-risk-acceptance",
             "unresolvedAccessibilityDefects" => "not-assessed-manually",
             "wcagCertification" => "not-claimed"
           }

    assert @candidate["qualification"]["qualified"] == false
    assert @candidate["qualification"]["status"] == "blocked"

    manual_gate =
      Enum.find(@candidate["gates"], fn gate -> gate["id"] == "manual-accessibility" end)

    assert manual_gate["mandatory"]
    assert manual_gate["status"] == "pending"
  end

  test "R6.2 records the complete local regression without promoting external gates" do
    assert @regression["status"] == "passed-local-regression-with-external-gates-pending"
    assert @regression["exactSourceRevision"] == nil

    assert @regression["unitAndDocumentation"]["packagePrecommit"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 419
           }

    assert @regression["unitAndDocumentation"]["demoPrecommit"] == %{
             "failures" => 0,
             "status" => "passed",
             "tests" => 166
           }

    assert @regression["browser"]["testInvocations"] == 552
    assert @regression["browser"]["failures"] == 0
    assert @regression["browser"]["engines"] == ~w(chromium firefox webkit)
    assert @regression["distribution"]["archive"]["entries"] == 63
    assert @regression["distribution"]["currentExport"]["runs"] == 2
    assert @regression["distribution"]["currentExport"]["routes"] == 634
    assert @regression["distribution"]["currentExport"]["assets"] == 4
    assert map_size(@regression["reviewIssues"]) == 11

    assert @regression["reviewIssues"]["VR-11"] ==
             "manual-risk-accepted-pending-and-reviewed-deployment-blocking"

    assert @regression["externalGates"]["manualAccessibility"] ==
             "pending-risk-accepted-for-r6-progression"

    assert @regression["externalGates"]["flyDeploymentAuthorization"] == "pending"
    assert @regression["externalGates"]["candidateQualification"] == "blocked"
  end
end
