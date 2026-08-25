defmodule ShadcnUI.Phase4ComponentsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.navigation.header shadcn_ui.navigation.section_header
  # covers: shadcn_ui.navigation.sticky_fallback shadcn_ui.navigation.protected_semantics
  # covers: shadcn_ui.navigation.shared_contract
  # covers: shadcn_ui.content.radio_panels shadcn_ui.content.radio_not_tabs
  # covers: shadcn_ui.content.radio_fallback shadcn_ui.content.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :instance, :string, required: true
    attr :theme, :string, required: true
    attr :selected, :string, default: "summary"

    def render(assigns) do
      ~H"""
      <article id={"page-#{@instance}"} data-shadcn-theme={@theme} class="bulma-consumer-page">
        <.header presentation={:sticky} wrap={:responsive}>
          <:brand><a href={"#main-#{@instance}"}>Northwind</a></:brand>
          <:primary_navigation>
            <.navigation_menu accessible_name={"Primary #{@instance}"} layout={:wrap}>
              <:item
                key="summary"
                destination={"#summary-#{@instance}"}
                label="Summary"
                current={:page}
              />
              <:item key="details" destination={"#details-#{@instance}"}>
                Details
                <.badge>2</.badge>
              </:item>
            </.navigation_menu>
          </:primary_navigation>
          <:utilities>
            <form action="/search">
              <.input id={"query-#{@instance}"} name="query">
                <:label>Search</:label>
              </.input>
            </form>
          </:utilities>
          <:actions><.button type="button">Create</.button></:actions>
        </.header>

        <main id={"main-#{@instance}"}>
          <.section_header id={"summary-#{@instance}"} presentation={:sticky} anchor_effect={:accent}>
            <:heading>
              <h2>Account summary {@instance}</h2>
            </:heading>
            <:description>Choose a caller-owned view.</:description>
            <:actions><.button type="button" variant={:outline}>Export</.button></:actions>
          </.section_header>
          <.separator />
          <.scroll_area focusable accessible_label={"Views #{@instance}"}>
            <.radio_panels
              id={"views-#{@instance}"}
              name="view"
              selected={@selected}
              layout={:horizontal}
            >
              <:legend>Visible account view</:legend>
              <:option key="summary" value="summary" label="Summary">
                <section id={"details-#{@instance}"}>
                  <h3>Summary panel</h3><p>Current totals.</p>
                </section>
              </:option>
              <:option key="activity" value="activity" label="Activity">
                <section>
                  <h3>Activity panel</h3><form action="/filter">
                    <label>Filter <input name="filter" /></label>
                  </form>
                </section>
              </:option>
            </.radio_panels>
          </.scroll_area>
        </main>
      </article>
      """
    end
  end

  test "composes Phase 4 with existing components without changing child semantics" do
    html = render("light", "light")

    for token <- [
          "<header",
          "<nav",
          "<a ",
          "<form",
          "<input",
          "<button",
          "<h2",
          "<h3",
          "<fieldset",
          "<legend",
          "data-shadcn-ui-separator",
          "data-shadcn-ui-scroll-area",
          "data-shadcn-ui-radio-panels",
          "bulma-consumer-page"
        ],
        do: assert(html =~ token)

    refute html =~ ~r/role="(?:menu|menubar|menuitem|tablist|tab|tabpanel)"/
    assert order(html, "Account summary") < order(html, "Choose a caller-owned view")
    assert order(html, "Choose a caller-owned view") < order(html, "Export")
  end

  test "repeated light and dark compositions are deterministic with unique identities" do
    light = render("light", "light")
    dark = render("dark", "dark", "activity")
    html = light <> dark
    ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()

    assert light == render("light", "light")
    assert dark == render("dark", "dark", "activity")
    assert length(ids) == length(Enum.uniq(ids))
    assert html =~ ~s(data-shadcn-theme="light")
    assert html =~ ~s(data-shadcn-theme="dark")
    assert length(Regex.scan(~r/data-selected="true"/, html)) == 2
  end

  test "compiled package exposes Phase 4 modules and no application runtime" do
    docs = Mix.Project.config()[:docs]
    navigation = Keyword.fetch!(docs[:groups_for_modules], :"Navigation components")
    content = Keyword.fetch!(docs[:groups_for_modules], :"Content components")
    css = File.read!(ShadcnUI.stylesheet_path())

    assert ShadcnUI.Components.Navigation.Header in navigation
    assert ShadcnUI.Components.Navigation.SectionHeader in navigation
    assert ShadcnUI.Components.Content.RadioPanels in content
    assert css =~ "data-shadcn-ui-section-header"
    assert css =~ "data-shadcn-ui-radio-panel-option"

    refute File.dir?("lib/shadcn_ui_web")
    refute File.exists?("assets/radio_panels.js")
    refute File.exists?("assets/header.js")
  end

  defp render(instance, theme, selected \\ "summary") do
    %{instance: instance, theme: theme, selected: selected, __changed__: nil}
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp order(html, needle), do: :binary.match(html, needle) |> elem(0)
end
