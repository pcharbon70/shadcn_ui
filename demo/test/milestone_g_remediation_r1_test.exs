defmodule ShadcnUIDemo.MilestoneGRemediationR1Test do
  use ExUnit.Case, async: true

  @baseline_path "priv/reference/milestone_g/remediation-r1-baseline.json"
  @reference_path "priv/reference/milestone_g/presentation-reference.json"
  @baseline @baseline_path |> File.read!() |> Jason.decode!()
  @reference @reference_path |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.semantic_exceptions
  # covers: shadcn_ui.gallery_presentation.stable_identity

  test "remediation baseline retains the exact pinned identity and comparison route" do
    assert @baseline["schemaVersion"] == 1
    assert @baseline["status"] == "accepted-remediation-baseline"
    assert @baseline["target"]["upstreamCommit"] == @reference["upstream"]["commit"]
    assert @baseline["target"]["movingPublicSiteAuthoritative"] == false

    assert @baseline["target"]["routes"] == %{
             "categoryDiagnostic" => "/components/foundation",
             "localAccordion" => "/components/disclosure/accordion",
             "publicUpstreamDiagnostic" => "https://unscripted.janci.dev/components/accordion"
           }
  end

  test "remediation matrix reuses every accepted Phase 1 state" do
    expected_states = MapSet.new(@reference["states"], & &1["id"])
    remediation_states = MapSet.new(@baseline["acceptedMatrix"]["states"])

    assert remediation_states == expected_states
    assert @baseline["acceptedMatrix"]["scale"] == 1
    assert @baseline["acceptedMatrix"]["motion"] == "reduced"
  end

  test "verified Accordion inputs match the accepted manifest identity" do
    reference_inputs = Map.new(@reference["upstream"]["inputs"], &{&1["path"], &1})

    for input <- @baseline["target"]["verifiedPinnedInputs"] do
      assert reference_inputs[input["path"]]["sha256"] == input["sha256"]
      assert reference_inputs[input["path"]]["bytes"] == input["bytes"]
      assert input["normalization"] =~ "CRLF"
    end
  end

  test "every reviewed issue has an owner and explicit remediation outcome" do
    ownership = @baseline["ownershipDecisions"]
    owned = Enum.join(ownership["package"] ++ ownership["gallery"], "\n")

    for id <- 1..10 do
      assert owned =~ "VR-#{String.pad_leading(Integer.to_string(id), 2, "0")}"
    end

    assert ownership["rowPresentation"]["decision"] == "package-default"
    assert ownership["primaryFaqCopy"]["decision"] == "align-with-pinned-source"
    assert length(ownership["intentionalExceptions"]) == 6
    assert map_size(@baseline["expectedOutcomes"]) == 5
  end
end
