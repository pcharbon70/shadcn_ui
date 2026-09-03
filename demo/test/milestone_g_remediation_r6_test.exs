defmodule ShadcnUIDemo.MilestoneGRemediationR6Test do
  use ExUnit.Case, async: true

  @repo_root Path.expand("../..", __DIR__)
  @risk_evidence File.read!("priv/reference/milestone_g/remediation-r6-manual-risk-evidence.json")
                 |> Jason.decode!()
  @candidate File.read!(Path.join(@repo_root, "release/candidate-status.json")) |> Jason.decode!()

  # covers: shadcn_ui.compatibility_accessibility.manual_review
  # covers: shadcn_ui.compatibility_accessibility.evidence_separation
  # covers: shadcn_ui.release_publication.truthful_gates
  # covers: shadcn_ui.public_documentation.compatibility_and_fallback

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
end
