defmodule ShadcnUI.MixProject do
  use Mix.Project

  @source_url "https://github.com/Leco-Industries-Inc/shadcn_ui"
  @gallery_url "https://leco-industries-inc.github.io/shadcn_ui/"
  @version "0.1.0"

  def project do
    [
      app: :shadcn_ui,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description:
        "Transport-neutral Phoenix function components with shadcn-style HTML and CSS.",
      source_url: @source_url,
      homepage_url: @gallery_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def cli do
    [preferred_envs: [precommit: :test, "spec.check": :test]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 4.1"},
      # Phoenix.Component, ~H, attr/3, and slot/3 are distributed in this
      # package. ShadcnUI does not use LiveView routes, sockets, or processes.
      {:phoenix_live_view, "~> 1.2"},
      {:ex_doc, "~> 0.40.3", only: :dev, runtime: false},
      {:spec_led_ex,
       git: "https://github.com/specleddev/specled_ex.git",
       ref: "f0d20dba6786a8f1dff0d7365a113b23db696fc1",
       only: [:dev, :test],
       runtime: false}
    ]
  end

  defp aliases do
    [
      precommit: [
        "format --check-formatted",
        "deps.unlock --check-unused",
        "compile --warnings-as-errors",
        "test"
      ]
    ]
  end

  defp package do
    [
      licenses: ["LicenseRef-LECO-Proprietary"],
      links: %{"Gallery" => @gallery_url, "GitHub" => @source_url},
      files: [
        "lib",
        "priv/static/shadcn_ui.css",
        "priv/compatibility",
        "priv/provenance",
        "mix.exs",
        "README.md",
        "CHANGELOG.md",
        "THIRD_PARTY_NOTICES.md"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "main",
      extras: ["README.md", "CHANGELOG.md", "THIRD_PARTY_NOTICES.md", "RELEASE.md"],
      groups_for_modules: [
        "Content components": [
          ShadcnUI.Components.Content.RadioPanels,
          ShadcnUI.Components.Content.ScrollArea,
          ShadcnUI.Components.Content.Separator
        ],
        "Disclosure components": [
          ShadcnUI.Components.Disclosure.Accordion
        ],
        "Foundation components": [
          ShadcnUI.Components.Foundation.Alert,
          ShadcnUI.Components.Foundation.Avatar,
          ShadcnUI.Components.Foundation.Badge,
          ShadcnUI.Components.Foundation.Button,
          ShadcnUI.Components.Foundation.Card,
          ShadcnUI.Components.Foundation.Skeleton
        ],
        "Form components": [
          ShadcnUI.Components.Forms.Checkbox,
          ShadcnUI.Components.Forms.EnhancedSelect,
          ShadcnUI.Components.Forms.ErrorSummary,
          ShadcnUI.Components.Forms.Field,
          ShadcnUI.Components.Forms.FieldErrors,
          ShadcnUI.Components.Forms.Help,
          ShadcnUI.Components.Forms.Input,
          ShadcnUI.Components.Forms.Label,
          ShadcnUI.Components.Forms.Meter,
          ShadcnUI.Components.Forms.NativeSelect,
          ShadcnUI.Components.Forms.Progress,
          ShadcnUI.Components.Forms.RadioGroup,
          ShadcnUI.Components.Forms.Slider,
          ShadcnUI.Components.Forms.Switch,
          ShadcnUI.Components.Forms.Textarea
        ],
        "Navigation components": [
          ShadcnUI.Components.Navigation.Header,
          ShadcnUI.Components.Navigation.NavigationMenu,
          ShadcnUI.Components.Navigation.SectionHeader
        ],
        "Overlay components": [
          ShadcnUI.Components.Overlays.AlertDialog,
          ShadcnUI.Components.Overlays.Dialog,
          ShadcnUI.Components.Overlays.Drawer,
          ShadcnUI.Components.Overlays.Popover,
          ShadcnUI.Components.Overlays.DropdownActions,
          ShadcnUI.Components.Overlays.Tooltip
        ],
        "Package contract": [ShadcnUI, ShadcnUI.Component]
      ]
    ]
  end
end
