defmodule ShadcnUI.MilestoneFPhase1AcceptanceTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.documentation_catalogue.package_boundary
  # covers: shadcn_ui.release_publication.version_identity
  # covers: shadcn_ui.package.transport_neutral
  # covers: shadcn_ui.package.explicit_release_files

  test "Milestone F foundations remain outside the package runtime and archive allowlist" do
    package_files = Mix.Project.config()[:package][:files]
    runtime_source = Path.wildcard("lib/**/*.ex") |> Enum.map_join("\n", &File.read!/1)

    refute runtime_source =~ "DocumentationCatalogue"
    refute runtime_source =~ "BuildIdentity"

    for excluded <- ["demo", ".spec", "docs", "test", "scripts", "assets"] do
      refute excluded in package_files
    end

    assert package_files == [
             "lib",
             "priv/static/shadcn_ui.css",
             "priv/compatibility",
             "priv/provenance",
             "mix.exs",
             "README.md",
             "LICENSE",
             "CHANGELOG.md",
             "THIRD_PARTY_NOTICES.md"
           ]
  end

  test "demo identity is injected without Git, network, or package state discovery" do
    source = File.read!("demo/lib/shadcn_ui_demo/build_identity.ex")
    config = File.read!("demo/config/config.exs")
    workflow = File.read!(".github/workflows/gallery.yml")

    assert config =~ "SHADCN_UI_BUILD_REVISION"
    assert workflow =~ ~s(SHADCN_UI_BUILD_REVISION: ${{ github.sha }})
    refute source =~ ~r/(System\.cmd|git rev-parse|Req\.|HTTPoison|Finch\.|:httpc)/
    refute File.read!("lib/shadcn_ui.ex") =~ "SHADCN_UI_BUILD_REVISION"
  end
end
