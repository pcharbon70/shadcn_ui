defmodule ShadcnUI.Components.Media.CarouselTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Media.{Carousel, MediaContract}
  # covers: shadcn_ui.media_components.carousel_structure
  # covers: shadcn_ui.media_components.carousel_controls
  # covers: shadcn_ui.media_components.carousel_layout

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    def render(assigns) do
      ~H"""
      <.carousel id="real" accessible_label="Real caller">
        <:item key="first" label="First">
          <form action="/caller"><label>Name<input name="name" /></label><button>Save</button></form>
        </:item>
        <:item key="second" label="Second"><a href="/destination">Read more</a></:item>
      </.carousel>
      """
    end
  end

  defp render(attrs \\ %{}) do
    body = fn _, _ -> "Trusted body" end

    Map.merge(
      %{
        __changed__: nil,
        id: "demo",
        accessible_label: "Browse <images>",
        labelledby: nil,
        description: "Native & complete",
        snap: :proximity,
        alignment: :start,
        motion: :system,
        class: ["caller", nil],
        rest: %{},
        item: [
          %{key: "a", label: "First <item>", inner_block: body},
          %{key: "b", label: "Second", inner_block: body}
        ]
      },
      attrs
    )
    |> Carousel.carousel()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "one named region retains complete ordered content and real deterministic index" do
    html = render()
    assert html == render()
    assert html =~ ~s(role="region" tabindex="0" aria-label="Browse &lt;images&gt;")
    assert html =~ "Native &amp; complete"
    assert html =~ ~s(class="caller")
    assert length(Regex.scan(~r/<li\b/, html)) == 2
    assert length(Regex.scan(~r/<ol\b/, html)) == 1

    for key <- ["a", "b"] do
      id = MediaContract.identity!("demo", key).item
      assert html =~ ~s(id="#{id}")
      assert html =~ ~s(href="##{id}")
    end

    refute html =~
             ~r/(aria-selected|aria-current|aria-live|aria-roledescription|<script|<button|role="(?:tab|menu|listbox)")/
  end

  test "direct public import preserves metadata and trusted native forms and links" do
    html =
      Fixture.render(%{__changed__: nil})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ ~s(action="/caller")
    assert html =~ ~s(name="name")
    assert html =~ ~s(href="/destination")
    metadata = Carousel.__components__().carousel
    assert Enum.any?(metadata.attrs, &(&1.name == :id and &1.required))
    assert Enum.any?(metadata.slots, &(&1.name == :item and &1.required))
  end

  test "valid headings and closed presentation values have deterministic output" do
    for snap <- [:none, :proximity, :mandatory],
        alignment <- [:start, :center],
        motion <- [:system, :none] do
      html =
        render(%{
          accessible_label: nil,
          labelledby: "heading other-heading",
          snap: snap,
          alignment: alignment,
          motion: motion,
          description: nil
        })

      assert html =~ ~s(aria-labelledby="heading other-heading")
      refute html =~ "aria-describedby"
      assert html =~ ~s(data-shadcn-ui-motion="#{motion}")
    end
  end

  test "malformed identity, names, values and duplicate or incomplete items fail early" do
    for attrs <- [
          %{id: "bad id"},
          %{accessible_label: nil},
          %{accessible_label: " "},
          %{labelledby: "heading"},
          %{accessible_label: nil, labelledby: "#heading"},
          %{description: 1},
          %{snap: :bad},
          %{alignment: :bad},
          %{motion: :force},
          %{item: []},
          %{item: [%{key: "a", label: "A"}]},
          %{item: [%{key: "a", label: " ", inner_block: fn _, _ -> "A" end}]},
          %{item: for(_ <- 1..2, do: %{key: "a", label: "A", inner_block: fn _, _ -> "A" end})}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "required native relationships win over globals while caller behavior survives" do
    html =
      render(%{
        rest: %{
          role: "tab",
          "aria-roledescription": "carousel",
          "aria-live": "polite",
          hidden: true,
          "data-owner": "caller",
          "phx-mounted": "caller"
        },
        item: [
          %{
            key: "a",
            label: "A",
            class: "item-caller",
            rest: %{id: "override", role: "tabpanel", tabindex: 8, "data-extra": "yes"},
            inner_block: fn _, _ -> "A" end
          }
        ]
      })

    for forbidden <- ["override", "tabpanel", "aria-live", "aria-roledescription", " hidden"],
        do: refute(html =~ forbidden)

    for allowed <- [
          "item-caller",
          ~s(data-extra="yes"),
          ~s(data-owner="caller"),
          ~s(phx-mounted="caller")
        ],
        do: assert(html =~ allowed)
  end
end
