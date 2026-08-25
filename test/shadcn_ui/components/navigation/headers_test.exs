defmodule ShadcnUI.Components.Navigation.HeadersTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.navigation.header shadcn_ui.navigation.section_header
  # covers: shadcn_ui.navigation.sticky_fallback shadcn_ui.navigation.protected_semantics
  # covers: shadcn_ui.navigation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :width, :atom, default: :contained
    attr :density, :atom, default: :default
    attr :wrap, :atom, default: :responsive
    attr :border, :atom, default: :bottom
    attr :presentation, :atom, default: :static
    attr :header_rest, :global, default: %{}

    def page_header(assigns) do
      ~H"""
      <.header
        width={@width}
        density={@density}
        wrap={@wrap}
        border={@border}
        presentation={@presentation}
        class="consumer-header"
        data-owner="application"
        {@header_rest}
      >
        <:brand class="consumer-brand" rest={%{"data-region-owner": "brand"}}>
          <a href="/">Northwind</a>
        </:brand>
        <:primary_navigation>
          <nav aria-label="Primary"><a href="/reports">Reports</a></nav>
        </:primary_navigation>
        <:utilities>
          <form action="/search"><input name="q" /></form>
        </:utilities>
        <:actions><button type="button">New report</button></:actions>
      </.header>
      """
    end

    attr :presentation, :atom, default: :static
    attr :density, :atom, default: :default
    attr :anchor_effect, :atom, default: :offset
    attr :border, :boolean, default: false
    attr :section_rest, :global, default: %{}

    def render_section(assigns) do
      ~H"""
      <.section_header
        presentation={@presentation}
        density={@density}
        anchor_effect={@anchor_effect}
        border={@border}
        class="consumer-section-header"
        id="billing-heading"
        {@section_rest}
      >
        <:heading>
          <h3>Billing &amp; invoices</h3>
        </:heading>
        <:description>
          <p>Manage payment details.</p>
        </:description>
        <:actions><a href="/invoices">View invoices</a><button type="button">Edit</button></:actions>
      </.section_header>
      """
    end
  end

  test "Header preserves every caller semantic region in document order" do
    html = render_page_header()

    assert html =~ "<header"
    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(data-region-owner="brand")
    assert order(html, "Northwind") < order(html, "Primary")
    assert order(html, "Primary") < order(html, "<form")
    assert order(html, "<form") < order(html, "New report")
    assert html =~ ~s(<nav aria-label="Primary">)
    assert html =~ ~s(<a href="/reports">Reports</a>)
    assert html =~ ~s(<button type="button">New report</button>)
    refute html =~ ~r/<h[1-6]\b/
    refute html =~ ~r/role="(?:navigation|button|menubar)"/
  end

  test "Header maps every closed layout snapshot to static classes" do
    snapshots = [
      {:full, :compact, :wrap, :none, :static, ["sui:w-full", "sui:px-3", "sui:flex-wrap"]},
      {:contained, :default, :responsive, :bottom, :sticky,
       ["sui:max-w-7xl", "sui:px-4", "sui:md:flex-nowrap", "sui:sticky"]},
      {:narrow, :comfortable, :nowrap, :all, :static,
       ["sui:max-w-5xl", "sui:px-6", "sui:flex-nowrap", "sui:rounded-lg"]}
    ]

    for {width, density, wrap, border, presentation, expected} <- snapshots do
      overrides =
        [width: width, density: density, wrap: wrap, border: border, presentation: presentation]

      html = render_page_header(overrides)
      assert html =~ ~s(data-width="#{width}")
      assert html =~ ~s(data-density="#{density}")
      assert html =~ ~s(data-wrap="#{wrap}")
      assert Enum.all?(expected, &(&1 in all_classes(html)))
      assert html == render_page_header(overrides)
    end
  end

  test "Section Header preserves the caller heading level and content order" do
    html = render_section_header(presentation: :sticky, anchor_effect: :accent, border: true)

    assert html =~ ~s(<h3>Billing &amp; invoices</h3>)
    refute html =~ ~r/<h[12456]\b/
    assert order(html, "<h3") < order(html, "Manage payment details")
    assert order(html, "Manage payment details") < order(html, "View invoices")
    assert html =~ ~s(data-presentation="sticky")
    assert html =~ ~s(data-anchor-effect="accent")
    assert "sui:scroll-mt-20" in all_classes(html)
    assert "shadcn-ui-section-header-accent" in all_classes(html)
  end

  test "structural globals are protected while unrelated globals pass through" do
    page =
      render_page_header(
        header_rest: %{
          role: "button",
          "data-width": "override",
          "aria-label": "Application masthead",
          title: "Page tools"
        }
      )

    section =
      render_section_header(
        section_rest: %{role: "heading", "data-presentation": "override", "aria-live": "polite"}
      )

    refute page =~ ~s(role="button")
    assert page =~ ~s(data-width="contained")
    assert page =~ ~s(aria-label="Application masthead")
    assert page =~ ~s(title="Page tools")
    refute section =~ ~s(role="heading")
    assert section =~ ~s(data-presentation="static")
    assert section =~ ~s(aria-live="polite")
  end

  test "invalid closed values fail and metadata exposes the documented API" do
    for overrides <- [
          [width: :fluid],
          [density: :dense],
          [wrap: :auto],
          [border: :left],
          [presentation: :fixed]
        ],
        do: assert_raise(KeyError, fn -> render_page_header(overrides) end)

    for overrides <- [
          [presentation: :fixed],
          [density: :dense],
          [anchor_effect: :animated]
        ],
        do: assert_raise(KeyError, fn -> render_section_header(overrides) end)

    header = ShadcnUI.Components.Navigation.Header.__components__().header
    section = ShadcnUI.Components.Navigation.SectionHeader.__components__().section_header

    assert attr_values(header, :width) == [:full, :contained, :narrow]
    assert attr_values(header, :presentation) == [:static, :sticky]
    assert Enum.find(section.slots, &(&1.name == :heading)).required
    assert attr_values(section, :anchor_effect) == [:none, :offset, :accent]
  end

  test "documentation, fallback CSS, and provenance describe ownership honestly" do
    source = File.read!("assets/shadcn_ui.css")
    readme = File.read!("README.md")
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))

    assert source =~ "[data-shadcn-ui-section-header][data-presentation=\"sticky\"]"
    assert source =~ "[data-shadcn-ui-section-header][data-anchor-effect=\"accent\"]:target"
    assert readme =~ "Header does not create a page heading"
    assert readme =~ "normal document flow"

    assert Enum.any?(provenance["adaptations"], &(&1["id"] == "navigation.header"))
    assert Enum.any?(provenance["adaptations"], &(&1["id"] == "navigation.section_header"))
  end

  test "sources contain no heading inference, commands, routing, observation, or JavaScript" do
    source =
      [
        "lib/shadcn_ui/components/navigation/header.ex",
        "lib/shadcn_ui/components/navigation/section_header.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~
             ~r/(request_path|Routes\.|current_path|handle_event|push_event|JS\.|IntersectionObserver|ResizeObserver|addEventListener|onscroll|String\.to_atom|binary_to_atom|<script|javascript:)/i
  end

  defp render_page_header(overrides \\ []) do
    %{
      width: :contained,
      density: :default,
      wrap: :responsive,
      border: :bottom,
      presentation: :static,
      header_rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.page_header()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render_section_header(overrides) do
    %{
      presentation: :static,
      density: :default,
      anchor_effect: :offset,
      border: false,
      section_rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render_section()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp attr_values(metadata, name),
    do: Enum.find(metadata.attrs, &(&1.name == name)).opts[:values]

  defp all_classes(html),
    do:
      ~r/class="([^"]*)"/
      |> Regex.scan(html, capture: :all_but_first)
      |> List.flatten()
      |> Enum.flat_map(&String.split/1)

  defp order(html, needle), do: :binary.match(html, needle) |> elem(0)
end
