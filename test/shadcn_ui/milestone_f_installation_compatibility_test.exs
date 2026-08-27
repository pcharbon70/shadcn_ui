defmodule ShadcnUI.MilestoneFInstallationCompatibilityTest do
  use ExUnit.Case, async: true

  @installation File.read!("docs/installation.md")
  @compatibility File.read!("docs/compatibility.md")
  @readme File.read!("README.md")

  # covers: shadcn_ui.public_documentation.installation_and_assets
  # covers: shadcn_ui.public_documentation.compatibility_and_fallback

  test "installation guidance covers imports, packaged CSS, isolation, CSP, and runtime absence" do
    for text <- [
          "use ShadcnUI",
          "import ShadcnUI.Components.Foundation.Button",
          "ShadcnUI.stylesheet_path/0",
          "Plug.Static",
          "--shadcn-ui-*",
          "data-shadcn-theme",
          "prefers-reduced-motion",
          "Bulma",
          "Content Security Policy",
          "no Node",
          "Tailwind",
          "JavaScript"
        ] do
      assert @installation =~ text
    end

    assert @readme =~ "docs/installation.md"
    assert File.exists?(ShadcnUI.stylesheet_path())
  end

  test "compatibility policy records every public family, exact evidence, consumer review, and change control" do
    for text <- [
          "Button, Badge, Alert, Card, Avatar, Skeleton",
          "Enhanced Select",
          "Dialog, Alert Dialog, Drawer",
          "Carousel",
          "Image Gallery",
          "Chromium 151.0.7922.34 revision 1234",
          "Firefox 153.0 revision 1538",
          "WebKit 26.5 revision 2336",
          "not normative targets",
          "does not certify Electron",
          "user-agent sniffing",
          "accepted ADR",
          "migration"
        ] do
      assert @compatibility =~ text
    end

    assert @readme =~ "docs/compatibility.md"
  end

  test "package stylesheet contains no remote runtime assets" do
    css = File.read!(ShadcnUI.stylesheet_path())
    runtime_css = Regex.replace(~r{/\*.*?\*/}s, css, "")

    refute runtime_css =~ "http://"
    refute runtime_css =~ "https://"
    refute runtime_css =~ "@import"
    refute runtime_css =~ "javascript:"
  end
end
