defmodule ShadcnUI.Components.Media.ImageGalleryTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Media.{ImageGallery, MediaContract}
  # covers: shadcn_ui.media_components.gallery_figures
  # covers: shadcn_ui.media_components.media_failure shadcn_ui.media_components.media_ownership

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    def render(assigns) do
      ~H"""
      <.image_gallery id="public" accessible_label="Public images" images={@images}>
        <:caption :let={item} key="a"><strong>{item.key} trusted caption</strong></:caption>
      </.image_gallery>
      """
    end
  end

  defp images do
    for key <- ["a", "b"],
        do: %{
          key: key,
          src: "/#{key}.png",
          alt: "Image <#{key}>",
          width: 640,
          height: 480,
          caption: "Caption & #{key}",
          href: "/details/#{key}",
          srcset: [%{src: "/#{key}.png", width: 640}],
          sizes: "(max-width: 40rem) 100vw, 33vw",
          full: %{src: "/full/#{key}.png", width: 1280, height: 960}
        }
  end

  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "gallery",
        accessible_label: "Images",
        labelledby: nil,
        description: "Native figures",
        images: images(),
        columns: :three,
        density: :comfortable,
        fit: :cover,
        motion: :system,
        lightbox: :dialog,
        context: :root,
        initial_focus: :auto,
        dismissal: :close_request,
        close_label: "Close image",
        class: "caller",
        rest: %{},
        caption: []
      },
      attrs
    )
    |> ImageGallery.image_gallery()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "structured figures preserve escaped metadata, intrinsic dimensions and separate real destinations" do
    html = render()
    assert html == render()

    for value <- [
          ~s(aria-label="Images"),
          ~s(<ul role="list"),
          ~s(width="640" height="480"),
          ~s(loading="lazy" decoding="async"),
          ~s(srcset="/a.png 640w"),
          "Caption &amp; a",
          "Image &lt;a&gt;",
          ~s(href="/details/a")
        ],
        do: assert(html =~ value)

    for key <- ["a", "b"],
        do: assert(html =~ ~s(id="#{MediaContract.identity!("gallery", key).item}"))

    assert length(Regex.scan(~r/<figure\b/, html)) == 4

    refute html =~
             ~r/(aria-selected|aria-current|aria-live|<script|onload=|onerror=|role="(?:tab|menu|listbox)")/
  end

  test "direct import, keyed trusted caption and closed layout choices" do
    html =
      Fixture.render(%{__changed__: nil, images: images()})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "<strong>a trusted caption</strong>"
    refute html =~ "Caption &amp; a"

    assert Enum.any?(
             ImageGallery.__components__().image_gallery.attrs,
             &(&1.name == :images and &1.required)
           )

    for columns <- [:two, :three, :four],
        density <- [:compact, :comfortable],
        fit <- [:cover, :contain],
        motion <- [:system, :none] do
      assert render(%{
               columns: columns,
               density: density,
               fit: fit,
               motion: motion,
               accessible_label: nil,
               labelledby: "heading"
             }) =~ ~s(aria-labelledby="heading")
    end
  end

  test "full source then supplied thumbnail are documented destination fallbacks, not inferred fetches" do
    record = hd(images()) |> Map.delete(:href)
    assert render(%{images: [record]}) =~ ~s(href="/full/a.png")
    assert render(%{images: [Map.delete(record, :full)]}) =~ ~s(href="/a.png")

    decorative =
      record
      |> Map.put(:alt, "")
      |> Map.put(:decorative, true)
      |> Map.put(:name, "Decorative landscape")

    assert render(%{images: [decorative]}) =~ "Open image: Decorative landscape"
    assert render(%{images: [Map.put(record, :src, "/missing.png")]}) =~ "Caption &amp; a"
  end

  test "invalid fields, URLs, dimensions, identities, captions, naming and choices fail before rendering" do
    for attrs <- [
          %{images: []},
          %{images: [hd(images()), hd(images())]},
          %{images: [%{}]},
          %{images: [Map.put(hd(images()), :src, "javascript:alert(1)")]},
          %{images: [Map.put(hd(images()), :width, 0)]},
          %{images: [Map.put(hd(images()), :alt, "")]},
          %{images: [Map.put(hd(images()), :loader, :custom)]},
          %{columns: :five},
          %{density: :wide},
          %{fit: :fill},
          %{motion: :force},
          %{accessible_label: nil},
          %{labelledby: "heading"},
          %{id: "bad id"},
          %{caption: [%{key: "absent", inner_block: fn _, _ -> "caption" end}]}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "required semantics are protected while unrelated globals survive" do
    html =
      render(%{
        rest: %{
          role: "tab",
          style: "animation:spin 1s infinite",
          hidden: true,
          "aria-selected": "true",
          "aria-roledescription": "slideshow",
          "data-owner": "caller",
          "phx-mounted": "caller"
        }
      })

    for value <- ["spin", "aria-selected", "aria-roledescription", ~s(role="tab"), " hidden"],
        do: refute(html =~ value)

    assert html =~ ~s(data-owner="caller")
    assert html =~ ~s(phx-mounted="caller")
  end

  # covers: shadcn_ui.media_components.gallery_dialog shadcn_ui.media_components.gallery_origin
  test "existing Dialog owns native naming, commands, dismissal and focus; no nested controls or runtime" do
    html = render(%{initial_focus: :close})

    for key <- ["a", "b"] do
      base = MediaContract.identity!("gallery", key).dialog
      assert html =~ ~s(commandfor="#{base}-surface")
      assert html =~ ~s(aria-labelledby="#{base}-title")
      assert html =~ ~s(aria-describedby="#{base}-description")
      assert html =~ ~s(id="#{base}-close")
    end

    for value <- [
          ~s(command="show-modal"),
          ~s(command="close"),
          ~s(closedby="closerequest"),
          ~s(src="/full/a.png"),
          ~s(width="1280" height="960"),
          "sui:object-contain",
          "sui:max-h-[60dvb]",
          "Close image"
        ],
        do: assert(html =~ value)

    refute html =~ ~r/<dialog[^>]*\sopen(?:\s|>)/
    refute html =~ ~r/<button[^>]*>(?:(?!<\/button>).)*<(?:a|button|dialog)\b/s
    refute html =~ ~r/(anchor-name|position-anchor|viewTransition|<script|onerror|onclick)/
    ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
    assert ids == Enum.uniq(ids)

    for focus <- [:auto, :content, :close],
        dismissal <- [:none, :close_request, :any],
        do:
          assert(
            render(%{initial_focus: focus, dismissal: dismissal}) =~
              "data-shadcn-ui-gallery-lightbox"
          )

    plain = render(%{lightbox: :none, context: :dialog})
    refute plain =~ ~r/<(?:button|dialog)\b/
    assert length(Regex.scan(~r/<figure\b/, plain)) == 2
    assert plain =~ "Open image:"

    for attrs <- [
          %{context: :dialog},
          %{lightbox: :zoom},
          %{context: :popover},
          %{initial_focus: :first},
          %{dismissal: :escape},
          %{close_label: ""},
          %{close_label: nil}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end
end
