defmodule ShadcnUIDemo.MotionMediaCompositionsTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.MediaFixtures
  # covers: shadcn_ui.motion_media_gallery.capability_evidence
  # covers: shadcn_ui.motion_media_gallery.fixture_manifest
  test "local figures, failure cases and separate evidence are visible", %{conn: conn} do
    html = conn |> get("/examples/motion-media-capabilities") |> html_response(200)

    for entry <- MediaFixtures.entries() do
      assert html =~ "/media/" <> entry["file"]
      assert html =~ entry["alt"]
      assert html =~ to_string(entry["bytes"])
    end

    assert html =~ "/media/intentionally-missing.svg"
    assert html =~ "deferred-phase-5"
    refute html =~ "<dialog"
    refute html =~ "images.unsplash.com"
    refute html =~ ~s(role="progressbar")
  end

  test "fixture inventory checks dimensions, sizes, hashes, rights and selected paths" do
    assert length(MediaFixtures.validate!()) == 3
    manifest = MediaFixtures.manifest()
    [first | rest] = manifest["entries"]

    for replacement <- [
          %{"sha256" => String.duplicate("0", 64)},
          %{"bytes" => 1},
          %{"width" => 2},
          %{"mime" => "text/javascript"},
          %{"license" => ""},
          %{"file" => "../escape.svg"},
          %{"unknown" => true}
        ] do
      invalid = Map.put(manifest, "entries", [Map.merge(first, replacement) | rest])
      assert_raise ArgumentError, fn -> MediaFixtures.validate!(invalid, MediaFixtures.root()) end
    end
  end
end
