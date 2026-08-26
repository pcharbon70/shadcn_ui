defmodule ShadcnUI.MotionMediaContractTest do
  use ExUnit.Case, async: true
  import Phoenix.Component
  alias ShadcnUI.Components.Media.MediaContract, as: Media
  alias ShadcnUI.Components.Motion.MotionContract, as: Motion
  # covers: shadcn_ui.motion_media_contract.identity
  # covers: shadcn_ui.motion_media_contract.media_values
  # covers: shadcn_ui.motion_media_contract.safe_sources
  # covers: shadcn_ui.motion_media_contract.protected_globals
  # covers: shadcn_ui.motion_media_contract.motion_preference
  # covers: shadcn_ui.motion_media_contract.replacement

  defp image,
    do: %{key: "ridge", src: "/media/ridge.svg", alt: "Ridge at sunrise", width: 640, height: 480}

  test "stable identities do not collide on punctuation, Unicode or part boundaries" do
    ids =
      for {base, key} <- [
            {"one", "a-b"},
            {"one-a", "b"},
            {"one", "a.b"},
            {"one", "é"},
            {"two", "é"}
          ],
          do: Media.identity!(base, key)

    assert Enum.uniq(ids) == ids
    assert Media.entries!([image()], "gallery") == Media.entries!([image()], "gallery")
    assert_raise ArgumentError, fn -> Media.entries!([image(), image()], "gallery") end

    for bad <- ["", " ", 1, nil],
        do: assert_raise(ArgumentError, fn -> Media.identity!("gallery", bad) end)

    for bad <- ["", "1bad", "bad id", nil],
        do: assert_raise(ArgumentError, fn -> Media.identity!(bad, "key") end)
  end

  test "normalizes caller-owned responsive images and complete full-size metadata" do
    input =
      Map.merge(image(), %{
        srcset: [
          %{src: "/media/small.svg", width: 320},
          %{src: "https://example.test/large.svg", width: 640}
        ],
        sizes: "(max-width: 600px) 100vw, 640px",
        loading: :eager,
        decoding: :sync,
        href: "/details/ridge",
        caption: "An authored landscape",
        full: %{src: "/media/full.svg", width: 1280, height: 960}
      })

    normalized = Media.image!(input)
    assert normalized.srcset == "/media/small.svg 320w, https://example.test/large.svg 640w"
    assert normalized.full.width == 1280
    assert normalized.loading == "eager"
    assert normalized.decoding == "sync"
    assert normalized.name == input.alt
    assert Media.image!(image()).loading == "lazy"

    assert Media.image!(Map.merge(image(), %{alt: "", decorative: true, name: "View landscape"})).alt ==
             ""
  end

  test "rejects malformed fields, unsafe sources and conflicting metadata" do
    for fields <- [
          %{alt: nil},
          %{alt: " "},
          %{width: 0},
          %{height: -1},
          %{width: 1.5},
          %{decorative: true},
          %{decorative: "true"},
          %{loading: "lazy"},
          %{decoding: :bad},
          %{caption: 42},
          %{name: ""},
          %{srcset: ""},
          %{srcset: []},
          %{srcset: [%{src: "/a", width: 1}]},
          %{srcset: [%{src: "/a", width: 1}, %{src: "/b", width: 1}], sizes: "100vw"},
          %{srcset: [%{src: "/a,b", width: 1}], sizes: "100vw"},
          %{full: %{src: "/a"}},
          %{full: "bad"},
          %{onclick: "bad"},
          %{"src" => "/a"}
        ] do
      assert_raise ArgumentError, fn -> Media.image!(Map.merge(image(), fields)) end
    end

    for source <- [
          "",
          "javascript:alert(1)",
          "data:image/svg+xml,test",
          "//evil.test/a",
          "/\\evil.test/a",
          " https://example.test/a",
          "https://",
          "file:///a",
          "https://user:pass@example.test/a",
          "/a\nb",
          "/a" <> <<0>> <> "b",
          "/a" <> <<31>> <> "b",
          "/a" <> <<127>> <> "b",
          nil
        ] do
      assert_raise ArgumentError, fn -> Media.source!(source) end
    end

    for source <- ["/a", "https://example.test/a?x=1&y=2", "http://localhost:4000/a"],
        do: assert(Media.source!(source) == source)
  end

  test "protected globals cannot replace identities, media or suppression" do
    globals = %{
      "ID" => "bad",
      :aria_label => "bad",
      "aria-hidden" => false,
      "data-shadcn-motion" => "system",
      :src => "/bad",
      :class => "caller",
      "phx-click" => "caller"
    }

    assert Media.globals!(globals) == %{"phx-click" => "caller", class: "caller"}
    assert_raise ArgumentError, fn -> Media.globals!([]) end
  end

  test "text and URL attribute values are escaped at the HEEx boundary" do
    assigns = %{
      image:
        Media.image!(
          Map.merge(image(), %{
            alt: "<script>bad</script>",
            caption: "<b>text</b>",
            src: "/a?x=1&y=2"
          })
        )
    }

    html =
      ~H"""
      <figure>
        <img src={@image.src} alt={@image.alt} width={@image.width} height={@image.height} /><figcaption>
          {@image.caption}
        </figcaption>
      </figure>
      """
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "&lt;script&gt;"
    assert html =~ "&lt;b&gt;"
    assert html =~ "&amp;y=2"
    refute html =~ "<script>"
  end

  test "closed motion presets bound the whole sequence without persistent state" do
    assert Motion.preference!(:system) == "system"
    assert Motion.preference!(:none) == "none"

    for bad <- ["none", :force, nil],
        do: assert_raise(ArgumentError, fn -> Motion.preference!(bad) end)

    for preset <- [:brief, :default], do: assert(Motion.marquee_duration!(preset) <= 5000)
    assert_raise ArgumentError, fn -> Motion.marquee_duration!(6000) end

    for preset <- [:quick, :default], index <- 0..100 do
      item = Motion.stagger_item!(index, preset)
      assert item.duration_ms + item.delay_ms <= 1000
      if index > 20, do: refute(item.animated)
    end

    assert Motion.stagger_item!(0) == Motion.stagger_item!(0)
    assert_raise ArgumentError, fn -> Motion.stagger_item!(-1) end
    assert_raise ArgumentError, fn -> Motion.stagger_item!(1, :bad) end
  end
end
