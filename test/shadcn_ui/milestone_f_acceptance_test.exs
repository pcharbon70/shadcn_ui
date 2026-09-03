defmodule ShadcnUI.MilestoneFAcceptanceTest do
  use ExUnit.Case, async: true

  @manifest File.read!("priv/compatibility/catalogue.json") |> Jason.decode!()
  @evidence File.read!("demo/priv/compatibility/milestone_f_engine_evidence.json")
            |> Jason.decode!()

  # covers: shadcn_ui.compatibility_accessibility.capability_policy
  # covers: shadcn_ui.compatibility_accessibility.consumer_boundary
  test "normative support is capability-based and consumer-neutral" do
    assert @manifest["normativeTarget"] == "web-platform-capabilities"

    assert @manifest["policy"] == %{
             "applicationTargetBranches" => false,
             "consumerOwnsEnvironmentValidation" => true,
             "fallbackRequired" => true,
             "supportSelector" => "declared-native-and-css-capabilities",
             "userAgentBranches" => false
           }

    assert map_size(@manifest["components"]) == 41

    assert Enum.sort(Map.values(@manifest["components"]) |> Enum.uniq()) ==
             Enum.sort(Map.keys(@manifest["bundles"]))

    policy = File.read!("docs/compatibility.md")
    assert policy =~ "supports declared HTML and CSS capability bundles"
    assert policy =~ "does not certify Electron or another embedded consumer"
    assert policy =~ "application owns validation of its renderer"
    refute policy =~ ~r/ShadcnUI supports (?:Chrome|Chromium|Firefox|Safari|WebKit) \d/
  end

  # covers: shadcn_ui.compatibility_accessibility.evidence_separation
  test "normative manifests and observed engine evidence stay separate" do
    assert @evidence["evidenceType"] == "observed-not-normative"
    assert Map.keys(@evidence["engines"]) == ~w(chromium firefox webkit)

    assert @evidence["capabilityObservations"]["status"] ==
             "measured-separately-from-outcomes"

    refute Map.has_key?(@manifest, "engines")
    refute Map.has_key?(@manifest, "platform")
    assert File.regular?("priv/compatibility/catalogue.json")
    refute File.exists?("priv/compatibility/milestone_f_engine_evidence.json")
    assert File.regular?("demo/priv/compatibility/milestone_f_engine_evidence.json")

    files = Mix.Project.config()[:package][:files]
    assert "priv/compatibility" in files
    refute "demo" in files
  end

  # covers: shadcn_ui.compatibility_accessibility.manual_review
  test "manual ledger is structured, pending, and cannot imply certification" do
    ledger = File.read!("release/records/accessibility-review.md")

    for id <- 1..6 do
      assert ledger =~ "### MAN-0#{id}"
    end

    for field <- [
          "Reviewer:",
          "Date:",
          "Hardware:",
          "Browser:",
          "Assistive technology or device:",
          "Steps:",
          "Observations:",
          "Defects:",
          "Retest result:",
          "Status:"
        ] do
      assert length(Regex.scan(~r/^\- #{Regex.escape(field)}/m, ledger)) == 6
    end

    assert length(Regex.scan(~r/^\- Status: PENDING$/m, ledger)) == 6

    assert ledger =~
             ~r/must not state\s+that manual accessibility acceptance or WCAG certification is complete/

    assert ledger =~ "Automated evidence"
    assert ledger =~ "axe-core 4.13.0"
  end

  test "the release-facing docs and executable acceptance surfaces are wired" do
    mix = File.read!("mix.exs")
    browser = File.read!("test/browser/milestone-f-compatibility.spec.mjs")

    assert mix =~ ~s("docs/compatibility.md")
    refute mix =~ ~s("release/records/accessibility-review.md")
    assert browser =~ ~s|expect(result.version).toBe("4.13.0")|
    assert browser =~ "javaScriptEnabled: false"
    assert browser =~ "forcedColors: \"active\""
    assert browser =~ "serveMotionMediaExport(routes)"
  end
end
