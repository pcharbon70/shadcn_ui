defmodule ShadcnUI.MotionMediaFoundationsIntegrationTest do
  use ExUnit.Case, async: true
  # covers: shadcn_ui.motion_media_contract.runtime_boundary
  # covers: shadcn_ui.motion_media_contract.distribution
  # covers: shadcn_ui.motion_media_contract.css_exceptions

  test "shared helpers and normative manifest are shipped without unfinished public APIs" do
    release = Mix.Project.config()[:package][:files]
    assert "lib" in release
    assert "priv/compatibility" in release
    refute Enum.any?(release, &String.starts_with?(&1, ["demo", "test", "scripts", "docs"]))
    imports = File.read!("lib/shadcn_ui.ex")
    refute imports =~ "MediaContract"
    refute imports =~ "MotionContract"

    for path <- ~w(lib/shadcn_ui/components/media lib/shadcn_ui/components/motion) do
      helper =
        if String.ends_with?(path, "/media"), do: "media_contract.ex", else: "motion_contract.ex"

      assert File.regular?(Path.join(path, helper))

      refute File.read!(Path.join(path, helper)) =~
               ~r/(GenServer|Process\.send|<script|addEventListener|phx-hook|String\.to_atom)/
    end
  end

  test "compiled scoped suppression has an auditable independent exception" do
    source = File.read!("assets/motion-media.css")
    ledger = File.read!("docs/motion-media-css-exceptions.md")
    artifact = File.read!(ShadcnUI.stylesheet_path())
    assert ledger =~ "E-01"
    assert source =~ "data-shadcn-ui-motion"
    assert source =~ "data-shadcn-motion"
    assert source =~ "prefers-reduced-motion"
    assert artifact =~ "data-shadcn-ui-motion-part"

    refute String.replace(source, "animation: none !important;", "") =~
             ~r/(url\(|@keyframes|animation:|addEventListener|https?:)/i

    refute artifact =~ "intentionally-missing.svg"
    refute artifact =~ "/media/ridge.svg"
  end
end
