defmodule ShadcnUIDemo.BuildIdentityTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.release_publication.version_identity

  alias ShadcnUIDemo.BuildIdentity

  @revision "0123456789abcdef0123456789abcdef01234567"
  @upstream "abcdef0123456789abcdef0123456789abcdef01"

  test "accepts explicit immutable identity and derives matching metadata" do
    assert {:ok, identity} =
             BuildIdentity.new(%{
               package_version: "0.1.0",
               build_revision: @revision,
               catalogue_schema: "1",
               upstream_revision: @upstream,
               canonical_url: "https://leco-industries-inc.github.io/shadcn_ui/"
             })

    refute identity.development

    assert BuildIdentity.release_metadata(identity) == %{
             "packageVersion" => "0.1.0",
             "buildRevision" => @revision,
             "catalogueSchema" => "1",
             "upstreamRevision" => @upstream,
             "canonicalUrl" => "https://leco-industries-inc.github.io/shadcn_ui/",
             "development" => false
           }

    assert BuildIdentity.health_metadata(identity)["identity"] ==
             BuildIdentity.release_metadata(identity)
  end

  test "uses the explicit configured revision and derives development identity" do
    assert {:ok, identity} = BuildIdentity.current()
    configured_revision = Application.fetch_env!(:shadcn_ui_demo, :build_revision)

    assert identity.package_version == "0.1.0"
    assert identity.catalogue_schema == "1"
    assert identity.build_revision == configured_revision
    assert identity.development == (configured_revision == BuildIdentity.development_revision())
    assert identity.upstream_revision =~ ~r/^[0-9a-f]{40}$/
  end

  test "accepts an explicit Fly HTTPS origin and joins canonical paths" do
    assert {:ok, identity} =
             BuildIdentity.new(%{
               package_version: "0.1.0",
               build_revision: @revision,
               catalogue_schema: "1",
               upstream_revision: @upstream,
               canonical_url: "https://leco-shadcn-ui-demo.fly.dev/"
             })

    assert BuildIdentity.canonical_url(identity, "/components/foundation/button") ==
             "https://leco-shadcn-ui-demo.fly.dev/components/foundation/button"
  end

  test "rejects partial, symbolic, secret-like, mutable, and malformed values" do
    valid = %{
      package_version: "0.1.0",
      build_revision: @revision,
      catalogue_schema: "1",
      upstream_revision: @upstream
    }

    invalid = [
      {:package_version, "latest"},
      {:package_version, "v0.1"},
      {:build_revision, "HEAD"},
      {:build_revision, "0123456"},
      {:build_revision, "gho_secret-token"},
      {:catalogue_schema, "next"},
      {:catalogue_schema, "0"},
      {:upstream_revision, "main"},
      {:upstream_revision, nil},
      {:canonical_url, "http://leco-industries-inc.github.io/shadcn_ui/"},
      {:canonical_url, "https://user@example.test/shadcn_ui/?token=secret"},
      {:canonical_url, "https://example.test/not-normalized"},
      {:canonical_url, "https://example.test/a/../b/"}
    ]

    for {field, value} <- invalid do
      assert {:error, errors} = BuildIdentity.new(Map.put(valid, field, value))
      assert "invalid #{field}" in errors
    end
  end

  test "source contains no Git shell or network discovery" do
    source = File.read!("lib/shadcn_ui_demo/build_identity.ex")

    refute source =~ ~r/(System\.cmd|git rev-parse|Req\.|HTTPoison|Finch\.|:httpc)/
  end
end
