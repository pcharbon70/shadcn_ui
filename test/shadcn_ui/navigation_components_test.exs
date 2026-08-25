defmodule ShadcnUI.NavigationComponentsTest do
  use ExUnit.Case, async: true
  alias Phoenix.HTML.Safe
  # covers: shadcn_ui.navigation.menu shadcn_ui.navigation.link_semantics
  # covers: shadcn_ui.navigation.current_location shadcn_ui.navigation.destination_ownership
  # covers: shadcn_ui.navigation.protected_semantics shadcn_ui.navigation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI
    attr :instance, :string, required: true
    attr :theme, :string, required: true

    def render(assigns) do
      ~H"""
      <section id={"shell-#{@instance}"} data-shadcn-theme={@theme} class="bulma-section">
        <.navigation_menu accessible_name={"Account #{@instance}"} layout={:wrap}>
          <:item key="home" destination={"#home-#{@instance}"} label="Home" current={:page} />
          <:item key="alerts" destination={"#alerts-#{@instance}"}>
            Alerts
            <.badge>3</.badge>
          </:item>
        </.navigation_menu>
        <.separator />
        <.scroll_area id={"scroll-#{@instance}"} focusable accessible_label={"Activity #{@instance}"}>
          <.button type="button">Application action</.button>
          <p id={"home-#{@instance}"}>Home target</p><p id={"alerts-#{@instance}"}>Alerts target</p>
        </.scroll_area>
      </section>
      """
    end
  end

  test "navigation composes existing controls without changing their semantics" do
    html = render("one", "light")
    assert html == render("one", "light")

    for token <- [
          "<nav",
          "<a ",
          "<button",
          "data-shadcn-ui-separator",
          "data-shadcn-ui-scroll-area",
          "bulma-section"
        ],
        do: assert(html =~ token)

    refute html =~ ~r/role="(?:menu|menubar|menuitem|tab|button)"/
  end

  test "multiple themes retain unique caller identities and explicit current state" do
    html = render("light", "light") <> render("dark", "dark")
    ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
    assert length(ids) == length(Enum.uniq(ids))
    assert length(Regex.scan(~r/aria-current="page"/, html)) == 2
  end

  defp render(instance, theme),
    do:
      %{instance: instance, theme: theme, __changed__: nil}
      |> Fixture.render()
      |> Safe.to_iodata()
      |> IO.iodata_to_binary()
end
