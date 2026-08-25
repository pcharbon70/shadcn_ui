defmodule ShadcnUIDemo.StaticExportTest do
  use ExUnit.Case, async: true

  test "export is closed, deterministic, local, ignored, and package-excluded" do
    task = File.read!("lib/mix/tasks/gallery.export.ex")
    workflow = File.read!("../../../.github/workflows/shadcn-ui-gallery.yml")
    deployment = File.read!("DEPLOYMENT.md")
    ignore = File.read!(".gitignore")
    package = File.read!("../mix.exs")

    assert task =~ "ShadcnUIDemo.Catalogue.routes()"
    assert task =~ "route-manifest.json"
    assert task =~ "sitemap.xml"
    assert task =~ ":crypto.hash(:sha256"
    assert task =~ "reject_remote_runtime!"
    refute task =~ ~r/(DateTime|NaiveDateTime|System\.system_time)/
    assert workflow =~ "actions/upload-pages-artifact@v3"
    assert workflow =~ "pages: write"
    assert workflow =~ "id-token: write"
    assert workflow =~ "cancel-in-progress: false"
    assert deployment =~ "Rollback"
    assert ignore =~ "/export/"
    refute package =~ ~r/"demo"\s*,/
  end
end
