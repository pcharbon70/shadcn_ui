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
  # covers: shadcn_ui.dialog.native_modal shadcn_ui.dialog.dismissal_policy
  # covers: shadcn_ui.dialog.initial_focus shadcn_ui.dialog.alert_dialog
  # covers: shadcn_ui.dialog.alert_ownership shadcn_ui.dialog.protected_semantics
  # covers: shadcn_ui.dialog.shared_contract

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

  test "Phase 2 publishes Dialog and Alert Dialog through one closed native modal contract" do
    entry = File.read!("lib/shadcn_ui.ex")
    dialog = File.read!("lib/shadcn_ui/components/overlays/dialog.ex")
    alert = File.read!("lib/shadcn_ui/components/overlays/alert_dialog.ex")
    fixture = File.read!("test/fixtures/milestone_d_dialogs.html")

    assert entry =~ "ShadcnUI.Components.Overlays.Dialog"
    assert entry =~ "ShadcnUI.Components.Overlays.AlertDialog"
    assert dialog =~ "command={OverlayContract.dialog_command!(:show_modal)}"
    assert dialog =~ ~s(closedby={@closedby})
    assert alert =~ ~s(role="alertdialog")
    assert alert =~ ~s(closedby="closerequest")
    assert alert =~ "autofocus"
    assert fixture =~ ~s(method="dialog")
    assert fixture =~ ~s(popover="auto")
    assert fixture =~ "Server rejection snapshot"
    assert fixture =~ ~s(data-pending="true")
  end

  test "Phase 2 locks three-engine behavior and application ownership evidence" do
    config = File.read!("playwright.milestone-d-phase2.config.mjs")
    browser = File.read!("test/browser/milestone-d-dialogs.spec.mjs")
    readme = File.read!("README.md")

    for engine <- ~w(chromium firefox webkit) do
      assert config =~ ~s(name: "#{engine}")
      assert config =~ ~s(browserName: "#{engine}")
    end

    for evidence <- [
          "Shift+Tab",
          "javaScriptEnabled: false",
          "clickBackdrop",
          "returnValue",
          "Replacement snapshot",
          "Server rejection snapshot",
          "toBeDisabled",
          "forcedColors",
          "reducedMotion"
        ],
        do: assert(browser =~ evidence)

    assert readme =~ "The browser owns Tab containment"
    assert readme =~ "The component never"
    assert readme =~ ~r/Browser\s+`confirm\(\)`/
  end

  test "Phase 2 provenance and source audit exclude modal and consequence runtimes" do
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptations = provenance["adaptations"]

    for {id, source} <- [
          {"overlays.dialog", "lib/shadcn_ui/components/overlays/dialog.ex"},
          {"overlays.alert-dialog", "lib/shadcn_ui/components/overlays/alert_dialog.ex"}
        ] do
      adaptation = Enum.find(adaptations, &(&1["id"] == id))
      assert source in adaptation["localPaths"]
      assert Enum.all?(adaptation["upstreamPaths"], &String.starts_with?(&1, "src/"))
    end

    runtime =
      [
        "lib/shadcn_ui/components/overlays/dialog.ex",
        "lib/shadcn_ui/components/overlays/alert_dialog.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute runtime =~
             ~r/(addEventListener|showModal\(|focus\(|setTimeout|confirm\(|requestSubmit|handle_event|push_event|GenServer|String\.to_atom|System\.unique_integer)/
  end
end
