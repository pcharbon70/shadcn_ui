defmodule ShadcnUI.Components.Navigation.NavigationMenuTest do
  use ExUnit.Case, async: false
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.navigation.menu shadcn_ui.navigation.link_semantics
  # covers: shadcn_ui.navigation.current_location shadcn_ui.navigation.destination_ownership
  # covers: shadcn_ui.navigation.protected_semantics shadcn_ui.navigation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI
    attr :name, :any, default: "Primary navigation"
    attr :layout, :atom, default: :horizontal
    attr :key, :any, default: "overview"
    attr :destination, :any, default: "/overview?next=<unsafe>"
    attr :label, :any, default: "Overview <unsafe>"
    attr :current, :any, default: :page
    attr :second_key, :any, default: "reports"
    attr :nav_rest, :global, default: %{}
    attr :link_rest, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.navigation_menu
        accessible_name={@name}
        layout={@layout}
        class="consumer-nav"
        id="primary-nav"
        data-owner="application"
      >
        <:item
          key={@key}
          destination={@destination}
          label={@label}
          current={@current}
          class="consumer-link"
          link_rest={%{"data-link-owner": "application", "phx-click": "track"}}
        />
        <:item key={@second_key} destination="/reports" target="_blank" rel="noopener">
          Reports <span aria-hidden="true">↗</span>
        </:item>
      </.navigation_menu>
      """
    end

    def direct(assigns) do
      ~H"""
      <ShadcnUI.Components.Navigation.NavigationMenu.navigation_menu
        accessible_name="Primary"
        {@nav_rest}
      >
        <:item key="one" destination="/one" label="One" link_rest={@link_rest} />
      </ShadcnUI.Components.Navigation.NavigationMenu.navigation_menu>
      """
    end
  end

  test "renders named nav and native list anchors with safe labels" do
    html = render_menu()
    assert length(Regex.scan(~r/<nav\b/, html)) == 1
    assert length(Regex.scan(~r/<ul\b/, html)) == 1
    assert length(Regex.scan(~r/<li\b/, html)) == 2
    assert length(Regex.scan(~r/<a\b/, html)) == 2
    assert html =~ ~s(aria-label="Primary navigation")
    assert html =~ ~s(href="/overview?next=&lt;unsafe&gt;")
    assert html =~ "Overview &lt;unsafe&gt;"
    assert html =~ "Reports <span aria-hidden=\"true\">↗</span>"
  end

  test "maps only explicit closed current values" do
    for {value, rendered} <- [
          page: "page",
          step: "step",
          location: "location",
          date: "date",
          time: "time",
          true: "true"
        ] do
      assert render_menu(current: value) =~ ~s(aria-current="#{rendered}")
    end

    refute render_menu(current: :none) =~ "aria-current="
    assert_raise KeyError, fn -> render_menu(current: :route) end
  end

  test "preserves native link options, classes, and unrelated globals" do
    html = render_menu()

    for expected <- [
          ~s(target="_blank"),
          ~s(rel="noopener"),
          "consumer-nav",
          "consumer-link",
          ~s(data-owner="application"),
          ~s(data-link-owner="application"),
          ~s(phx-click="track")
        ],
        do: assert(html =~ expected)
  end

  test "rejects malformed inputs and role overstatement" do
    for name <- [nil, "", "  ", :primary],
        do: assert_raise(ArgumentError, fn -> render_menu(name: name) end)

    for destination <- [nil, "", "  ", :overview],
        do: assert_raise(ArgumentError, fn -> render_menu(destination: destination) end)

    for key <- [nil, "", "bad/key", :overview, 1],
        do: assert_raise(ArgumentError, fn -> render_menu(key: key) end)

    assert_raise ArgumentError, fn -> render_menu(key: "same", second_key: "same") end
    assert_raise KeyError, fn -> render_menu(layout: :menu) end
    assert_raise ArgumentError, fn -> render_direct(%{role: "menubar"}) end
    assert_raise ArgumentError, fn -> render_direct(%{}, %{role: "menuitem"}) end
  end

  test "request keys remain deterministic without atoms or inferred routing" do
    for index <- 1..20, do: render_menu(key: "warmup-#{index}")

    for current <- [:none, :page, :step, :location, :date, :time, true],
        do: render_menu(current: current)

    for layout <- [:horizontal, :vertical, :wrap], do: render_menu(layout: layout)
    before_count = :erlang.system_info(:atom_count)

    for index <- 1..200,
        do: assert(render_menu(key: "request-#{index}") == render_menu(key: "request-#{index}"))

    assert :erlang.system_info(:atom_count) == before_count
    source = File.read!("lib/shadcn_ui/components/navigation/navigation_menu.ex")

    refute source =~
             ~r/(conn\.|request_path|current_path|Routes\.|menubar|menuitem|tablist|aria-haspopup|keydown|preventDefault|push_event|handle_event|JS\.|String\.to_atom|binary_to_atom)/i
  end

  test "records responsive, current, resilient, ownership, and provenance contracts" do
    source = File.read!("assets/shadcn_ui.css")
    css = File.read!(ShadcnUI.stylesheet_path())
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == "navigation.navigation_menu"))
    guide = File.read!("docs/guides/navigation.md")

    assert source =~ "[data-shadcn-ui-navigation-link][aria-current]"
    assert source =~ "text-decoration-line: underline"
    assert source =~ "outline: 2px solid LinkText"
    assert css =~ "data-shadcn-ui-navigation-link"

    assert adaptation["upstreamPaths"] == [
             "src/content/components/nav-menu.mdx",
             "src/demos/nav-menu/basic.html"
           ]

    assert guide =~ "real destination links, not an ARIA command menu"
    assert guide =~ "Callers provide real links, the current-location decision"
  end

  defp render_menu(overrides \\ []) do
    %{
      name: "Primary navigation",
      layout: :horizontal,
      key: "overview",
      destination: "/overview?next=<unsafe>",
      label: "Overview <unsafe>",
      current: :page,
      second_key: "reports",
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render_direct(nav_rest, link_rest \\ %{}) do
    %{nav_rest: nav_rest, link_rest: link_rest, __changed__: nil}
    |> Fixture.direct()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
