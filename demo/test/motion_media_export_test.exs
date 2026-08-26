defmodule ShadcnUIDemo.MotionMediaExportTest do
  use ExUnit.Case, async: false
  alias ShadcnUIDemo.MediaFixtures
  # covers: shadcn_ui.motion_media_gallery.fixture_manifest
  # covers: shadcn_ui.motion_media_gallery.static_media

  test "actual export selects media and concrete preferences without stale files" do
    Mix.Task.rerun("gallery.export")
    File.write!("export/stale-test.svg", "not selected")
    Mix.Task.rerun("gallery.export")
    refute File.exists?("export/stale-test.svg")
    manifest = Jason.decode!(File.read!("export/route-manifest.json"))
    assert map_size(manifest["assets"]) == 3
    assert Map.keys(manifest["media"]) |> Enum.sort() == ~w(grove.svg harbor.svg ridge.svg)

    for entry <- MediaFixtures.entries() do
      bytes = File.read!("export/media/" <> entry["file"])
      assert Base.encode16(:crypto.hash(:sha256, bytes), case: :lower) == entry["sha256"]
      assert byte_size(bytes) == entry["bytes"]
    end

    for theme <- ~w(light dark), motion <- ~w(system reduce) do
      html =
        File.read!(
          "export/_preferences/#{theme}/#{motion}/examples/motion-media-capabilities/index.html"
        )

      assert html =~ ~s(data-shadcn-motion="#{motion}")
      assert html =~ ~s(data-shadcn-theme="#{theme}")
      refute html =~ ~s(src="/media/)
      refute html =~ ~s(srcset="/media/)
      refute html =~ ~r/href="[^"]*\?theme=/
      assert html =~ "_preferences/#{theme}/reduce/examples/motion-media-capabilities/index.html"
    end

    sitemap = File.read!("export/sitemap.xml")
    refute sitemap =~ "_preferences"
    refute File.read!("export/404.html") =~ "__gallery-not-found__"
  end

  test "unlisted and escaping files fail against a disposable fixture root" do
    root =
      Path.join(System.tmp_dir!(), "shadcn_ui_media_test_#{System.unique_integer([:positive])}")

    File.mkdir!(root)

    on_exit(fn ->
      unless Path.dirname(Path.expand(root)) == Path.expand(System.tmp_dir!()) and
               String.starts_with?(Path.basename(root), "shadcn_ui_media_test_"),
             do: raise("unsafe test cleanup")

      File.rm_rf!(root)
    end)

    fixture_root = Path.join(root, "media")
    File.cp_r!(MediaFixtures.root(), fixture_root)
    File.write!(Path.join(fixture_root, "unlisted.svg"), "unlisted")

    assert_raise ArgumentError, fn ->
      MediaFixtures.validate!(MediaFixtures.manifest(), fixture_root)
    end

    File.rm!(Path.join(fixture_root, "unlisted.svg"))
    [first | _] = MediaFixtures.entries()
    target = Path.join(fixture_root, first["file"])
    original = File.read!(target)
    active = String.replace(original, "<path", "<script")
    File.write!(target, active)

    changed =
      Map.merge(first, %{
        "bytes" => byte_size(active),
        "sha256" => Base.encode16(:crypto.hash(:sha256, active), case: :lower)
      })

    active_manifest =
      Map.put(MediaFixtures.manifest(), "entries", [changed | tl(MediaFixtures.entries())])

    assert_raise ArgumentError, ~r/closed original shape profile/, fn ->
      MediaFixtures.validate!(active_manifest, fixture_root)
    end

    File.write!(target, original)
    outside = Path.join(root, "outside.svg")
    File.cp!(target, outside)
    File.rm!(target)

    case File.ln_s(outside, target) do
      :ok ->
        assert_raise ArgumentError, fn ->
          MediaFixtures.validate!(MediaFixtures.manifest(), fixture_root)
        end

      {:error, reason} when reason in [:eperm, :enotsup, :eacces] ->
        # Windows requires an OS capability to create a symlink. CI exercises this
        # branch on Linux; do not silently report a local symlink assertion passed.
        if match?({:win32, _}, :os.type()),
          do: IO.puts("Symlink creation unavailable (#{reason}); Linux CI must verify rejection"),
          else: flunk("CI must exercise symlink rejection: #{reason}")
    end
  end
end
