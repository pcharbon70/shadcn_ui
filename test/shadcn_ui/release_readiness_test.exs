defmodule ShadcnUI.ReleaseReadinessTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.package.public_version_target

  @gallery_url "https://pcharbon70-shadcn-ui-demo.fly.dev/"

  test "documents the first public release target and canonical gallery" do
    project = Mix.Project.config()

    assert project[:version] == "1.0.0"
    assert project[:homepage_url] == @gallery_url
    assert project[:docs][:main] == "readme"
    assert "RELEASE.md" in project[:docs][:extras]

    readme = File.read!("README.md")
    release = File.read!("RELEASE.md")

    assert readme =~ @gallery_url
    assert readme =~ "mix hex.build"
    assert release =~ "Version `1.0.0` is the first public Hex release target"
    assert release =~ "Hex publication remains pending"
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
             "priv/compatibility",
             "priv/provenance",
             "mix.exs",
             "README.md",
             "LICENSE",
             "CHANGELOG.md",
             "THIRD_PARTY_NOTICES.md"
           ]
  end

  test "consumer documentation covers every foundation module" do
    guide = File.read!("docs/guides/foundation.md")
    readme = File.read!("README.md")

    for name <- ~w(Button Badge Alert Card Avatar Skeleton) do
      assert guide =~ "## #{name}"
    end

    normalized = String.downcase(guide <> readme)

    for ownership <- ["application owns", "caller-owned", "caller"] do
      assert normalized =~ ownership
    end
  end
end
