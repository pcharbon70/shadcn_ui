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
  # covers: shadcn_ui.dialog.drawer shadcn_ui.dialog.drawer_scroll
  # covers: shadcn_ui.package.explicit_release_files shadcn_ui.package.public_import_surface
  # covers: shadcn_ui.popover.native_surface shadcn_ui.popover.modes
  # covers: shadcn_ui.popover.positioning shadcn_ui.popover.state_ownership
  # covers: shadcn_ui.popover.dropdown_actions shadcn_ui.popover.not_menu
  # covers: shadcn_ui.popover.protected_semantics shadcn_ui.popover.shared_contract

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

  test "Phase 3 exposes Drawer and exercises actual generated HEEx across three engines" do
    assert File.read!("lib/shadcn_ui.ex") =~ "ShadcnUI.Components.Overlays.Drawer"
    assert File.read!("mix.exs") =~ "ShadcnUI.Components.Overlays.Drawer"
    config = File.read!("playwright.milestone-d-phase3.config.mjs")

    for engine <- ~w(chromium firefox webkit) do
      assert config =~ ~s(browserName: "#{engine}")
    end

    ci = File.read!(".github/workflows/gallery.yml")
    assert ci =~ "mix run scripts/render-drawer-fixture.exs --check"
    assert ci =~ "npm run browser:milestone-d-phase3"
    assert ci =~ "mix run scripts/check-release-archive.exs"
    browser = File.read!("test/browser/milestone-d-drawers.spec.mjs")

    for evidence <- [
          "javaScriptEnabled: false",
          "hasTouch: true",
          "sheet.deleteRule",
          "outerHTML = replacement",
          "forcedColors",
          "scrollTop",
          "returnValue",
          "Shift+Tab"
        ] do
      assert browser =~ evidence
    end

    refute browser =~ ~r/if\s*\(browserName/
  end

  test "Phase 3 composes prior components without changing child relationships" do
    fixture = File.read!("test/fixtures/milestone_d_drawers.html")

    for marker <-
          ~w(data-shadcn-ui-header data-shadcn-ui-section-header data-shadcn-ui-navigation-menu data-shadcn-ui-accordion data-shadcn-ui-scroll-area data-shadcn-ui-radio-panels data-shadcn-ui-input data-shadcn-ui-separator) do
      assert fixture =~ marker
    end

    assert fixture =~ ~s(aria-label="Record destinations")
    assert fixture =~ ~s(href="#fallback-content")
    assert fixture =~ ~s(form="edit-form")
    assert fixture =~ ~s(role="region")
    assert fixture =~ ~s(aria-invalid="true")
    assert fixture =~ "Caller-rendered validation message."
    assert length(Regex.scan(~r/<form\b/, fixture)) == 1
    assert length(Regex.scan(~r/<nav\b/, fixture)) == 1
    refute fixture =~ ~r/(<aside|role="(?:complementary|menu|tablist)"|<script)/
  end

  test "Phase 3 keeps native scroll, safe-area, release and provenance boundaries" do
    css = File.read!("assets/shadcn_ui.css")
    for side <- ~w(top right bottom left), do: assert(css =~ "env(safe-area-inset-#{side}, 0px)")
    assert css =~ "min(100%, 100dvb)"
    assert css =~ "[data-shadcn-ui-drawer-body]:focus"
    source = File.read!("lib/shadcn_ui/components/overlays/drawer.ex")

    refute source =~
             ~r/(<script|addEventListener|setPointerCapture|ResizeObserver|IntersectionObserver|setTimeout|handle_event|String\.to_atom|scrollTop\s*=)/

    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == "overlays.drawer"))
    assert "lib/shadcn_ui/components/overlays/drawer.ex" in adaptation["localPaths"]
    assert "src/demos/drawer/basic.html" in adaptation["upstreamPaths"]
    files = Mix.Project.config()[:package][:files]

    for path <- ["scripts", "test", "demo", "playwright.milestone-d-phase3.config.mjs"],
        do: refute(path in files)
  end

  test "Phase 4 publishes native Popover and ordinary-control Dropdown Actions" do
    popover = File.read!("lib/shadcn_ui/components/overlays/popover.ex")
    actions = File.read!("lib/shadcn_ui/components/overlays/dropdown_actions.ex")
    fixture = File.read!("test/fixtures/milestone_d_popovers.html")

    for module <- ["Popover", "DropdownActions"] do
      assert File.read!("lib/shadcn_ui.ex") =~ "ShadcnUI.Components.Overlays.#{module}"
      assert File.read!("mix.exs") =~ "ShadcnUI.Components.Overlays.#{module}"
    end

    assert popover =~ "OverlayContract.popover_mode!"
    assert popover =~ "OverlayContract.popover_action!"
    assert actions =~ ~s(mode={:auto})
    assert fixture =~ ~s(popover="manual")
    assert fixture =~ ~s(id="record-actions-action-save" type="submit")
    assert fixture =~ ~s(name="intent" value="save" form="action-form")
    assert fixture =~ ~s(aria-describedby="record-actions-group-record")
    refute fixture =~ ~r/role="(?:menu|menubar|menuitem)"/

    refute popover <> actions =~
             ~r/(addEventListener|beforetoggle=|ontoggle=|ResizeObserver|IntersectionObserver|setTimeout|\.focus\(|getBoundingClientRect|String\.to_atom|<script|hidePopover\()/
  end

  test "Phase 4 joins deterministic fixtures, optional positioning and three-engine CI" do
    config = File.read!("playwright.milestone-d-phase4.config.mjs")
    for engine <- ~w(chromium firefox webkit), do: assert(config =~ ~s(browserName: "#{engine}"))
    ci = File.read!(".github/workflows/gallery.yml")
    assert ci =~ "mix run scripts/render-popover-fixture.exs --check"
    assert ci =~ "npm run browser:milestone-d-phase4"
    browser = File.read!("test/browser/milestone-d-popovers.spec.mjs")

    for evidence <- [
          "javaScriptEnabled: false",
          "hasTouch: true",
          "sheet.deleteRule",
          "outerHTML = snapshot",
          "Shift+Tab",
          "tabsToLinks",
          "waitForURL",
          "forcedColors",
          "reducedMotion"
        ] do
      assert browser =~ evidence
    end

    refute browser =~ ~r/if\s*\(browserName/
    css = File.read!("assets/shadcn_ui.css")
    assert css =~ "(position-area: block-end) and (position-try-fallbacks: flip-block)"
    assert css =~ "flip-block, flip-inline, flip-block flip-inline"
    assert css =~ "[data-shadcn-ui-popover-surface][popover]:not(:popover-open)"
  end

  test "Phase 4 records provenance and excludes behavior or browser machinery from releases" do
    manifest = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))

    for {id, name, upstream} <- [
          {"overlays.popover", "popover", "popover"},
          {"overlays.dropdown-actions", "dropdown_actions", "dropdown-menu"}
        ] do
      entry = Enum.find(manifest["adaptations"], &(&1["id"] == id))
      assert "lib/shadcn_ui/components/overlays/#{name}.ex" in entry["localPaths"]
      assert "src/demos/#{upstream}/basic.html" in entry["upstreamPaths"]
    end

    files = Mix.Project.config()[:package][:files]

    for excluded <- ["demo", "test", "scripts", "playwright.milestone-d-phase4.config.mjs"],
        do: refute(excluded in files)

    readme = File.read!("README.md")
    assert readme =~ "not an ARIA menu"
    assert readme =~ "no roving tabindex"
    assert readme =~ "always-visible ordinary fallback"
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
