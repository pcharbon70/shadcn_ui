defmodule ShadcnUI.PackageTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.package.independent_mix_project
  # covers: shadcn_ui.package.heex_infrastructure_only
  # covers: shadcn_ui.package.transport_neutral
  # covers: shadcn_ui.package.public_import_surface
  # covers: shadcn_ui.package.explicit_release_files
  # covers: shadcn_ui.package.no_consumer_asset_toolchain

  defmodule ConsumerFixture do
    use ShadcnUI
  end

  @foundation_modules [
    ShadcnUI.Components.Foundation.Alert,
    ShadcnUI.Components.Foundation.Avatar,
    ShadcnUI.Components.Foundation.Badge,
    ShadcnUI.Components.Foundation.Button,
    ShadcnUI.Components.Foundation.Card,
    ShadcnUI.Components.Foundation.Skeleton
  ]

  test "defines the package entry point and foundation component namespaces" do
    assert Code.ensure_loaded?(ShadcnUI)
    assert Enum.all?(@foundation_modules, &Code.ensure_loaded?/1)
  end

  test "use ShadcnUI compiles in a transport-neutral consumer fixture" do
    assert Code.ensure_loaded?(ConsumerFixture)
    assert ConsumerFixture.__info__(:functions) == []
  end

  test "resolves the packaged stylesheet without copying or serving it" do
    assert ShadcnUI.stylesheet_path() ==
             Application.app_dir(:shadcn_ui, "priv/static/shadcn_ui.css")
  end

  test "keeps the direct dependency boundary limited to HEEx infrastructure" do
    dependencies =
      Mix.Project.config()
      |> Keyword.fetch!(:deps)
      |> Enum.map(&elem(&1, 0))

    assert dependencies == [:phoenix_html, :phoenix_live_view, :spec_led_ex]

    specled_options =
      Mix.Project.config()
      |> Keyword.fetch!(:deps)
      |> Enum.find_value(fn
        {:spec_led_ex, options} -> options
        {:spec_led_ex, _requirement, options} -> options
        _dependency -> nil
      end)

    assert specled_options[:runtime] == false
    assert specled_options[:only] == [:dev, :test]
  end

  test "uses an explicit package release allowlist" do
    package = Mix.Project.config()[:package]

    assert package[:licenses] == ["LicenseRef-LECO-Proprietary"]
    assert package[:links] == %{"GitHub" => "https://github.com/Leco-Industries-Inc/leco_apps"}

    assert package[:files] == [
             "lib",
             "priv/static/shadcn_ui.css",
             "priv/provenance",
             "mix.exs",
             "README.md",
             "CHANGELOG.md",
             "THIRD_PARTY_NOTICES.md"
           ]
  end

  test "runtime sources contain no application framework boundary" do
    source =
      "lib/**/*.ex"
      |> Path.wildcard()
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~
             ~r/defmodule\s+(?:Dstar|Datastar|Ash|Electron|Phoenix\.(?:Controller|Endpoint|LiveView))\b/
  end
end
