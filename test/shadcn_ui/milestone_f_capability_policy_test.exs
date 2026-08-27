defmodule ShadcnUI.MilestoneFCapabilityPolicyTest do
  use ExUnit.Case, async: true

  @manifest File.read!("priv/compatibility/catalogue.json") |> Jason.decode!()
  @evidence File.read!("demo/priv/compatibility/milestone_f_engine_evidence.json")
            |> Jason.decode!()

  # covers: shadcn_ui.compatibility_accessibility.capability_policy
  test "closed capability policy covers all 41 public catalogue identities" do
    assert @manifest["normativeTarget"] == "web-platform-capabilities"
    assert @manifest["policy"]["userAgentBranches"] == false
    assert @manifest["policy"]["applicationTargetBranches"] == false
    assert @manifest["policy"]["consumerOwnsEnvironmentValidation"] == true
    assert map_size(@manifest["components"]) == 41

    for {component, bundle_name} <- @manifest["components"] do
      assert is_binary(component)
      bundle = Map.fetch!(@manifest["bundles"], bundle_name)
      assert is_list(bundle["native"])
      assert is_list(bundle["enhancements"])
      assert is_binary(bundle["fallback"])
      assert Enum.all?(bundle["sources"], &Map.has_key?(@manifest["authoritativeSources"], &1))
    end
  end

  test "authoritative source review and deliberate deferrals are explicit" do
    assert map_size(@manifest["authoritativeSources"]) >= 10

    for {_id, source} <- @manifest["authoritativeSources"] do
      assert String.starts_with?(source["url"], "https://")
      assert source["reviewedOn"] == "2026-08-27"
      assert String.trim(source["caveat"]) != ""
    end

    assert "package-javascript" in @manifest["deliberateDeferrals"]
    assert "true-tabs" in @manifest["deliberateDeferrals"]
  end

  # covers: shadcn_ui.compatibility_accessibility.exact_engine_evidence
  test "exact engines and component outcomes remain observed evidence" do
    assert @evidence["evidenceType"] == "observed-not-normative"
    assert @evidence["recordedOn"] == "2026-08-27"
    assert @evidence["lock"]["playwright"] == "1.62.1"
    assert Map.keys(@evidence["engines"]) == ~w(chromium firefox webkit)

    for {_family, outcome} <- @evidence["componentOutcomes"] do
      assert outcome["status"] == "passed"
      assert outcome["checks"] != []
    end

    assert Enum.any?(@evidence["knownGaps"], &String.contains?(&1, "not proof"))
    assert Enum.any?(@evidence["knownGaps"], &String.contains?(&1, "Manual"))
  end
end
