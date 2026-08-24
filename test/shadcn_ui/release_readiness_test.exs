defmodule ShadcnUI.ReleaseReadinessTest do
  use ExUnit.Case, async: true

  @gallery_url "https://leco-industries-inc.github.io/leco_apps/shadcn-ui/"

  test "documents the internal candidate and canonical gallery" do
    project = Mix.Project.config()

    assert project[:version] == "0.1.0"
    assert project[:homepage_url] == @gallery_url
    assert project[:docs][:main] == "readme"
    assert "RELEASE.md" in project[:docs][:extras]

    readme = File.read!("README.md")
    release = File.read!("RELEASE.md")

    assert readme =~ @gallery_url
    assert readme =~ "mix hex.build"
    assert release =~ "internal `0.1.0` candidate"
    assert release =~ "does not authorize or\nperform publication to Hex"
  end

  test "release allowlist excludes repository and gallery tooling" do
    files = Mix.Project.config()[:package][:files]

    for excluded <- [
          ".github",
          ".spec",
          "RELEASE.md",
          "assets",
          "demo",
          "deps",
          "doc",
          "node_modules",
          "scripts",
          "test"
        ] do
      refute excluded in files
    end

    assert files == [
             "lib",
             "priv/static/shadcn_ui.css",
             "priv/provenance",
             "mix.exs",
             "README.md",
             "CHANGELOG.md",
             "THIRD_PARTY_NOTICES.md"
           ]
  end

  test "consumer documentation covers every foundation module" do
    readme = File.read!("README.md")

    for name <- ~w(Button Badge Alert Card Avatar Skeleton) do
      assert readme =~ "### #{name}"
    end

    normalized = String.downcase(readme)

    for ownership <- ["application owns", "applications own", "caller labels"] do
      assert normalized =~ ownership
    end
  end
end
