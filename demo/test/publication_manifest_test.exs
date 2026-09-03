defmodule ShadcnUIDemo.PublicationManifestTest do
  use ExUnit.Case, async: false

  setup_all do
    Mix.Task.reenable("gallery.export")
    Mix.Task.run("gallery.export")
    :ok
  end

  test "release and health manifests expose complete immutable non-secret identity" do
    release = Jason.decode!(File.read!("export/release.json"))
    health = Jason.decode!(File.read!("export/health.json"))
    routes = Jason.decode!(File.read!("export/route-manifest.json"))

    assert release["schemaVersion"] == 1
    assert release["identity"]["packageVersion"] == "1.0.0"
    assert release["identity"]["catalogueSchema"] == "1"

    assert release["identity"]["canonicalUrl"] ==
             "https://pcharbon70-shadcn-ui-demo.fly.dev/"

    assert release["identity"]["buildRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert release["identity"]["upstreamRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert health["checks"]["routes"]["expected"] == length(routes["routes"])
    assert health["checks"]["search"]["sha256"] == routes["search"]["sha256"]
    assert health["checks"]["errorPage"] == %{"file" => "404.html", "expectedStatus" => 404}

    text = File.read!("export/release.json") <> File.read!("export/health.json")
    refute text =~ ~r/(password|credential|authorization|cookie|gho_)/i
  end

  test "route manifest pins both publication manifests" do
    routes = Jason.decode!(File.read!("export/route-manifest.json"))

    for name <- ~w(release health) do
      reference = routes["publication"][name]
      bytes = File.read!("export/#{reference["file"]}")
      actual = :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)
      assert reference["schemaVersion"] == 1
      assert reference["sha256"] == actual
    end
  end
end
