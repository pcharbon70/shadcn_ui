defmodule ShadcnUI.Components.Motion.MarqueeTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Motion.Marquee
  # covers: shadcn_ui.motion_components.marquee_static
  # covers: shadcn_ui.motion_components.marquee_control
  # covers: shadcn_ui.motion_components.marquee_duplicates

  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "brands",
        accessible_label: "Our <brands>",
        items: [%{key: "one", text: "One <script>"}, %{key: "two", text: "Two"}],
        mode: :static,
        direction: :inline_start,
        duration: :default,
        motion: :system,
        class: "caller",
        rest: %{}
      },
      attrs
    )
    |> Marquee.marquee()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "static default is one complete named list, with escaped text and deterministic identities" do
    html = render()
    assert html == render()
    assert html =~ ~s(aria-label="Our &lt;brands&gt;")
    assert html =~ "One &lt;script&gt;"
    assert length(Regex.scan(~r/<li\b/, html)) == 2
    refute html =~ ~r/(<input|clone|aria-live|<script)/
    assert html =~ ~s(class="caller")
    assert Marquee.__components__().marquee.slots == []
  end

  test "preview has an unchecked unnamed native control and one safe duplicate" do
    html =
      render(%{
        mode: :preview,
        items: [
          %{
            key: "a",
            text: "A",
            image: %{
              src: "/a.svg",
              alt: "Artwork",
              width: 30,
              height: 20,
              srcset: [%{src: "/a.svg", width: 30}],
              sizes: "30px"
            }
          }
        ]
      })

    [_, input] = Regex.run(~r/(<input[^>]+>)/, html)
    refute input =~ ~r/(\bname=|checked|disabled)/
    assert input =~ "aria-describedby"
    assert html =~ "uncheck to stop and reset"
    [_, clone] = Regex.run(~r/data-shadcn-ui-motion-part="clone"[^>]*>(.*?)<\/div>/s, html)
    assert html =~ ~r/hidden inert aria-hidden="true"/
    assert clone =~ ~s(alt="")
    refute clone =~ ~r/(\bid=|\bname=|tabindex|href=|<input|<button|<a\b|on\w+=|phx-|role=)/
    assert length(Regex.scan(~r/<ul\b/, html)) == 1
    assert length(Regex.scan(~r/data-shadcn-ui-motion-part="clone"/, html)) == 1
  end

  test "closed values, metadata, images, keys and noninteractive records are validated" do
    for attrs <- [
          %{id: "bad id"},
          %{accessible_label: " "},
          %{items: []},
          %{mode: :loop},
          %{direction: :left},
          %{duration: 20},
          %{motion: :force},
          %{items: [%{key: "a", text: {:safe, "html"}}]},
          %{items: [%{key: "a", text: "A", href: "/go"}]},
          %{
            items: [
              %{
                key: "a",
                text: "A",
                image: %{src: "javascript:alert(1)", alt: "A", width: 1, height: 1}
              }
            ]
          },
          %{items: [%{key: "a", text: "A", image: %{src: "/a", alt: "A", width: 0, height: 1}}]},
          %{
            items: [
              %{
                key: "a",
                text: "A",
                image: %{src: "/a", alt: "A", width: 1, height: 1, href: "/go"}
              }
            ]
          },
          %{items: [%{key: "a", text: "A"}, %{key: "a", text: "B"}]}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end

    for duration <- [:brief, :default], direction <- [:inline_start, :inline_end] do
      assert render(%{duration: duration, direction: direction}) =~
               ~s(data-shadcn-ui-duration="#{duration}")
    end
  end

  test "mandatory globals win while unrelated attributes survive" do
    html =
      render(%{
        rest: %{
          id: "override",
          role: "alert",
          hidden: true,
          style: "display:none",
          "aria-hidden": "true",
          "data-shadcn-ui-motion": "force",
          "data-owner": "caller",
          "phx-mounted": "caller"
        }
      })

    refute html =~ ~r/(override|role="alert"|display:none|aria-hidden|force)/
    assert html =~ ~s(data-owner="caller")
    assert html =~ ~s(phx-mounted="caller")
  end
end
