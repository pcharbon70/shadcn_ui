defmodule ShadcnUI.MilestoneDAcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.overlay.browser_matrix
  # covers: shadcn_ui.overlay.no_package_runtime
  # covers: shadcn_ui.overlay.deterministic_identity
  # covers: shadcn_ui.overlay.native_invocation
  # covers: shadcn_ui.overlay.state_ownership
  # covers: shadcn_ui.overlay.focus_ownership
  # covers: shadcn_ui.overlay.dismissal
  # covers: shadcn_ui.overlay.dom_replacement
  # covers: shadcn_ui.overlay.nesting_boundary
  # covers: shadcn_ui.overlay.web_fallback
  # covers: shadcn_ui.overlay.application_boundary
  # covers: shadcn_ui.stylesheet.reduced_motion shadcn_ui.stylesheet.no_runtime_assets
  # covers: shadcn_ui.stylesheet.overlay_fallbacks shadcn_ui.stylesheet.overlay_resilience

  test "Phase 1 joins authored capability evidence to a three-engine harness" do
    manifest = Jason.decode!(File.read!("priv/compatibility/native_overlays.json"))
    config = File.read!("playwright.milestone-d-phase1.config.mjs")
    capability_test = File.read!("test/browser/milestone-d-capabilities.spec.mjs")

    assert Map.keys(manifest["verificationEvidence"]["engines"]) |> Enum.sort() ==
             ~w(chromium firefox webkit)

    for engine <- ~w(chromium firefox webkit) do
      assert config =~ ~s(name: "#{engine}")
      assert config =~ ~s(browserName: "#{engine}")
    end

    assert capability_test =~ "dialogInvokerCommands"
    assert capability_test =~ "dialogClosedBy"
    assert capability_test =~ "positionFallbacks"
    refute capability_test =~ ~r/if\s*\(browserName/
  end

  test "shared contract, fixture, and CSS encode ownership and fallback boundaries" do
    source = File.read!("lib/shadcn_ui/components/overlays/overlay_contract.ex")
    fixture = File.read!("test/fixtures/milestone_d_overlay_contract.html")
    browser = File.read!("test/browser/milestone-d-overlay-contract.spec.mjs")
    css = File.read!("assets/shadcn_ui.css")
    readme = File.read!("README.md")

    for relationship <- ~w(invoker surface title description close initial-focus),
        do: assert(source =~ relationship)

    assert fixture =~ ~s(command="show-modal")
    assert fixture =~ ~s(popover="auto")
    assert fixture =~ ~s(href="#fallback-content")
    assert browser =~ "javaScriptEnabled: false"
    assert browser =~ "Replacement snapshot"
    assert css =~ "position-try-fallbacks"
    assert css =~ "transition-behavior: allow-discrete"
    assert css =~ "forced-colors: active"
    assert readme =~ "browser-local"
    assert readme =~ "Nested modals"
  end

  test "release keeps normative manifest but excludes runtime and verification machinery" do
    files = Mix.Project.config()[:package][:files]
    runtime = File.read!("lib/shadcn_ui/components/overlays/overlay_contract.ex")

    assert "priv/compatibility" in files

    for excluded <- [
          "demo",
          "test",
          "scripts",
          "test-results",
          "playwright.milestone-d-phase1.config.mjs"
        ] do
      refute excluded in files
    end

    refute runtime =~
             ~r/(GenServer|use\s+Phoenix\.LiveView|defmodule\s+.*(?:Dstar|Electron)|focus.?trap|positioning.?engine)/i
  end
end
