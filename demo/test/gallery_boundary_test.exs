defmodule ShadcnUIDemo.GalleryBoundaryTest do
  use ExUnit.Case, async: true

  test "demo is a controller-only path consumer outside package release files" do
    mix = File.read!("mix.exs")
    router = File.read!("lib/shadcn_ui_demo_web/router.ex")
    endpoint = File.read!("lib/shadcn_ui_demo_web/endpoint.ex")
    package_mix = File.read!("../mix.exs")

    assert mix =~ ~s({:shadcn_ui, path: ".."})
    refute mix =~ ~r/{:(?:ecto|phoenix_live_view|dstar|ash|electron)/
    refute router =~ ~r/(live_session|live\s+|socket|Dstar|Datastar)/
    refute endpoint =~ ~r/Phoenix\.LiveView\.Socket/
    refute package_mix =~ ~r/"demo"\s*,/
  end

  test "demo runtime assets are local, bounded, and fingerprinted" do
    source = File.read!("assets/gallery.css") <> File.read!("assets/gallery.js")
    build = File.read!("scripts/build-assets.mjs")
    ignore = File.read!(".gitignore")

    refute source =~ ~r/(https?:|@import|analytics|fonts\.google)/i
    assert source =~ ~s|url("./bricolage-grotesque-wght-a97804dc9fbe5fc9.woff2")|
    assert source =~ "system-ui"
    assert build =~ ~s|createHash("sha256")|
    assert build =~ "shadcn_ui.css"
    assert ignore =~ "/export/"
    assert ignore =~ "/node_modules/"
  end

  test "the single demo script owns only theme persistence and source copying" do
    scripts = Path.wildcard("assets/**/*.js")
    source = Enum.map_join(scripts, &File.read!/1)

    assert scripts == ["assets/gallery.js"]
    assert source =~ "shadcn-ui-gallery-theme"
    assert source =~ "navigator.clipboard.writeText"
    refute source =~ ~r/(fetch\(|XMLHttpRequest|WebSocket|EventSource|data-on:|phx-)/
  end
end
