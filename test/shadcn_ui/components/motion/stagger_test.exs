defmodule ShadcnUI.Components.Motion.StaggerTest do
  use ExUnit.Case, async: true
  alias ShadcnUI.Components.Motion.Stagger
  # covers: shadcn_ui.motion_components.stagger shadcn_ui.motion_components.suppression

  defp render(attrs \\ %{}) do
    Map.merge(
      %{
        __changed__: nil,
        id: "steps",
        as: :div,
        effect: :none,
        preset: :default,
        motion: :system,
        class: "caller",
        rest: %{},
        item: for(n <- 0..19, do: %{key: "item-#{n}", inner_block: fn _, _ -> "Item #{n}" end})
      },
      attrs
    )
    |> Stagger.stagger()
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  test "default preserves all ordered content without inventing list or animation semantics" do
    html = render()
    assert html == render()
    refute html =~ ~r/(<li|role=|data-shadcn-ui-animated="true"|aria-live|clone)/
    assert length(Regex.scan(~r/data-shadcn-ui-stagger-item/, html)) == 20
    assert html =~ ~r/Item 0[\s\S]*Item 19/
  end

  test "semantic list choices and closed timing cap every delay plus duration at one second" do
    for wrapper <- [:ul, :ol], preset <- [:quick, :default], effect <- [:fade, :rise] do
      html = render(%{as: wrapper, preset: preset, effect: effect})
      assert html =~ "<#{wrapper}"
      assert html =~ ~s(role="list")
      assert length(Regex.scan(~r/<li\b/, html)) == 20

      times =
        Regex.scan(
          ~r/--shadcn-ui-stagger-duration:(\d+)ms;--shadcn-ui-stagger-delay:(\d+)ms/,
          html
        )

      assert length(times) == 20

      assert Enum.all?(times, fn [_, d, delay] ->
               String.to_integer(d) + String.to_integer(delay) <= 1000
             end)

      assert List.last(times) == [
               "--shadcn-ui-stagger-duration:0ms;--shadcn-ui-stagger-delay:0ms",
               "0",
               "0"
             ]
    end
  end

  test "invalid metadata and duplicate keys fail before rendering" do
    for attrs <- [
          %{id: " "},
          %{as: :section},
          %{effect: :loop},
          %{preset: :slow},
          %{motion: :force},
          %{item: []},
          %{item: [%{key: "x"}]},
          %{item: for(_ <- 1..2, do: %{key: "x", inner_block: fn _, _ -> "body" end})}
        ] do
      assert_raise ArgumentError, fn -> render(attrs) end
    end
  end

  test "protects required attributes and preserves caller classes, globals and trusted controls" do
    html =
      render(%{
        motion: :none,
        rest: %{hidden: true, role: "listbox", "data-owner": "caller"},
        item: [
          %{
            key: "one",
            class: "item-class",
            rest: %{id: "bad", style: "opacity:0", "data-test": "yes"},
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(
                ~s(<form><label>Name<input name="name"></label><button>Save</button></form><a href="/go">Go</a>)
              )
            end
          }
        ]
      })

    refute html =~ ~r/(listbox|id="bad"|opacity:0| hidden)/
    assert html =~ ~s(data-shadcn-ui-motion="none")

    for value <- [
          "item-class",
          "data-owner",
          "data-test",
          "<form>",
          ~s(name="name"),
          ~s(href="/go")
        ],
        do: assert(html =~ value)
  end
end
