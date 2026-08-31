defmodule ShadcnUIDemo.StaticExportTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.documentation_catalogue.package_boundary
  # covers: shadcn_ui.documentation_catalogue.deterministic_search

  test "export is closed, deterministic, local, ignored, and package-excluded" do
    task = File.read!("lib/mix/tasks/gallery.export.ex")
    workflow = File.read!("../.github/workflows/gallery.yml")
    deployment = File.read!("DEPLOYMENT.md")
    ignore = File.read!(".gitignore")
    package = File.read!("../mix.exs")

    assert task =~ "ShadcnUIDemo.Catalogue.routes()"
    assert task =~ "route-manifest.json"
    assert task =~ "release.json"
    assert task =~ "health.json"
    assert task =~ "BuildIdentity.release_metadata(identity)"
    assert task =~ "BuildIdentity.health_metadata(identity)"
    assert task =~ "sitemap.xml"
    assert task =~ "DocumentationCatalogue.search_json()"
    assert task =~ "search-index-"
    assert task =~ ~s("search" => search)
    assert task =~ ":crypto.hash(:sha256"
    assert task =~ "reject_remote_runtime!"
    assert task =~ "canonical_url"
    assert task =~ "~w(shadcn.css gallery.css gallery.js bricolage-grotesque-wght.woff2)"
    assert task =~ "ShadcnUIDemoWeb.GalleryAssets.path/1"
    assert File.read!("scripts/check-export-determinism.mjs") =~ ~s(MIX_ENV: "test")
    refute task =~ "File.ls!()"
    refute task =~ ~r/(DateTime|NaiveDateTime|System\.system_time)/

    assert workflow =~
             "actions/upload-pages-artifact@56afc609e74202658d3ffba0e8f6dda462b719fa # v3"

    assert workflow =~ "pages: write"
    assert workflow =~ "id-token: write"
    assert workflow =~ "cancel-in-progress: false"
    assert workflow =~ ~s(SHADCN_UI_BUILD_REVISION: ${{ github.sha }})
    assert deployment =~ "Rollback"
    assert ignore =~ "/export/"
    refute package =~ ~r/"demo"\s*,/
  end
end
