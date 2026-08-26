defmodule ShadcnUI.Components.Media.CoverFlowTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Media.{CoverFlow, MediaContract}
  # covers: shadcn_ui.media_components.cover_flow_composition
  # covers: shadcn_ui.media_components.cover_flow_enhancement
  # covers: shadcn_ui.media_components.media_failure shadcn_ui.media_components.media_ownership

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    def render(assigns) do
      ~H"""
      <.cover_flow id="public" accessible_label="Public images" images={@images} />
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
          sizes: "(max-width: 40rem) 85vw, 22rem"
        }
  end

  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "flow",
        accessible_label: "Images",
        labelledby: nil,
        description: "Native list",
        images: images(),
        presentation: :enhanced,
        snap: :proximity,
        alignment: :start,
        motion: :system,
        class: "caller",
        rest: %{}
      },
      attrs
    )
    |> CoverFlow.cover_flow()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "structured images reuse native list, naming, IDs and real index without selected state" do
    html = render()
    assert html == render()

    for value <- [
          ~s(role="region"),
          ~s(aria-label="Images"),
          ~s(<ol role="list"),
          ~s(width="640" height="480"),
          ~s(loading="lazy" decoding="async"),
          ~s(srcset="/a.png 640w"),
          "Caption &amp; a",
          "Image &lt;a&gt;",
          ~s(href="/details/a")
        ],
        do: assert(html =~ value)

    for key <- ["a", "b"] do
      identity = MediaContract.identity!("flow", key)
      assert html =~ ~s(id="#{identity.item}")
      assert html =~ ~s(href="##{identity.item}")
      assert html =~ "--shadcn-ui-cover-timeline:#{identity.timeline}"
    end

    assert length(Regex.scan(~r/<figure\b/, html)) == 2
    assert length(Regex.scan(~r/<img\b/, html)) == 2
    assert html =~ ~r/<\/div>\s*<figcaption/

    refute html =~
             ~r/(aria-selected|aria-current|aria-live|<script|<button|onload=|onerror=|role="(?:tab|menu|listbox)")/
  end

  test "direct import retains metadata and all closed native choices" do
    html =
      Fixture.render(%{__changed__: nil, images: images()})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "data-shadcn-ui-cover-flow"

    assert Enum.any?(
             CoverFlow.__components__().cover_flow.attrs,
             &(&1.name == :images and &1.required)
           )

    for presentation <- [:flat, :enhanced],
        motion <- [:system, :none],
        snap <- [:none, :proximity, :mandatory],
        alignment <- [:start, :center] do
      assert render(%{
               presentation: presentation,
               motion: motion,
               snap: snap,
               alignment: alignment,
               accessible_label: nil,
               labelledby: "heading"
             }) =~ ~s(aria-labelledby="heading")
    end

    assert render(%{images: Enum.take(images(), 1)}) =~ ~s(data-shadcn-ui-presentation="flat")
  end

  test "invalid media, values, names and IDs fail before rendering" do
    for attrs <- [
          %{images: []},
          %{images: [hd(images()), hd(images())]},
          %{images: [%{}]},
          %{images: [Map.put(hd(images()), :src, "javascript:alert(1)")]},
          %{images: [Map.put(hd(images()), :width, 0)]},
          %{images: [Map.put(hd(images()), :alt, "")]},
          %{presentation: :spin},
          %{snap: :bad},
          %{alignment: :bad},
          %{motion: :force},
          %{accessible_label: nil},
          %{labelledby: "heading"},
          %{id: "bad id"}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "unrelated globals survive but semantic and CSS identities are protected" do
    html =
      render(%{
        rest: %{
          role: "tab",
          style: "animation:spin 1s infinite",
          hidden: true,
          "aria-selected": "true",
          "data-shadcn-ui-presentation": "flat",
          "phx-mounted": "caller",
          "data-owner": "caller"
        }
      })

    for forbidden <- ["spin", "aria-selected", ~s(role="tab"), " hidden"],
        do: refute(html =~ forbidden)

    assert html =~ ~s(data-owner="caller")
    assert html =~ ~s(phx-mounted="caller")
    assert html =~ ~s(data-shadcn-ui-presentation="enhanced")
  end
end
