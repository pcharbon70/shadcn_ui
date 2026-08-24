defmodule ShadcnUI.MixProject do
  use Mix.Project

  @source_url "https://github.com/Leco-Industries-Inc/leco_apps"
  @gallery_url "https://leco-industries-inc.github.io/leco_apps/shadcn-ui/"
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
        "Foundation components": [
          ShadcnUI.Components.Foundation.Alert,
          ShadcnUI.Components.Foundation.Avatar,
          ShadcnUI.Components.Foundation.Badge,
          ShadcnUI.Components.Foundation.Button,
          ShadcnUI.Components.Foundation.Card,
          ShadcnUI.Components.Foundation.Skeleton
        ],
        "Package contract": [ShadcnUI, ShadcnUI.Component]
      ]
    ]
  end
end
