defmodule ShadcnUIDemo.FlyDeploymentTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.gallery.separate_application
  # covers: shadcn_ui.gallery.deterministic_assets
  # covers: shadcn_ui.gallery.online_publication
  # covers: shadcn_ui.gallery.excluded_from_package
  # covers: shadcn_ui.release_publication.version_identity
  # covers: shadcn_ui.release_publication.health_manifest
  # covers: shadcn_ui.release_publication.deployment_workflow
  # covers: shadcn_ui.release_publication.post_deploy_and_rollback

  test "Fly configuration deploys one bounded stateless release with an HTTP health check" do
    config = File.read!("fly.toml")

    assert config =~ ~s(app = "leco-shadcn-ui-demo")
    assert config =~ ~s(primary_region = "yyz")
    assert config =~ ~s(dockerfile = "Dockerfile")
    assert config =~ ~s(PHX_HOST = "leco-shadcn-ui-demo.fly.dev")
    assert config =~ ~s(path = "/healthz")
    assert config =~ ~s(auto_stop_machines = "stop")
    assert config =~ ~s(min_machines_running = 0)
    assert config =~ ~s(memory = "256mb")
    refute config =~ ~r/(SECRET_KEY_BASE\s*=|access_token|credential)/i
  end

  test "Docker release builds the real path dependency and excludes source from runtime" do
    dockerfile = File.read!("Dockerfile")
    ignore = File.read!("../.dockerignore")
    package_mix = File.read!("../mix.exs")

    assert dockerfile =~ "COPY mix.exs mix.lock ./"
    assert dockerfile =~ "COPY demo/mix.exs demo/mix.lock demo/"
    assert dockerfile =~ "COPY demo/priv demo/priv"
    assert dockerfile =~ "RUN node demo/scripts/build-assets.mjs"
    assert dockerfile =~ "RUN mix release"
    assert dockerfile =~ ~s(CMD ["/app/bin/server"])
    assert ignore =~ "demo/test"
    refute dockerfile =~ "COPY --from=builder /app/lib"
    refute dockerfile =~ "COPY --from=builder /app/demo/lib"

    refute package_mix =~ ~r/"demo"\s*,/
    refute package_mix =~ ~r/"\.dockerignore"\s*,/
    refute package_mix =~ ~r/"fly\.toml"\s*,/
    refute package_mix =~ ~r/"Dockerfile"\s*,/
  end

  test "operations keep verification, deployment, smoke, secrets, and rollback separate" do
    operations = File.read!("../docs/gallery-operations.md")
    smoke = File.read!("scripts/smoke-fly-gallery.mjs")

    assert operations =~ "Fly.io"
    assert operations =~ "SECRET_KEY_BASE"
    assert operations =~ "healthz"
    assert operations =~ "rollback"
    assert operations =~ "separate states"
    assert smoke =~ "assets.size !== 4"
  end
end
