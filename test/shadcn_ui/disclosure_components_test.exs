defmodule ShadcnUI.DisclosureComponentsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.disclosure.accordion_native
  # covers: shadcn_ui.disclosure.accordion_modes
  # covers: shadcn_ui.disclosure.deterministic_identity
  # covers: shadcn_ui.disclosure.open_snapshot
  # covers: shadcn_ui.disclosure.protected_semantics
  # covers: shadcn_ui.disclosure.fallback
  # covers: shadcn_ui.disclosure.ownership shadcn_ui.disclosure.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :instance, :string, required: true
    attr :theme, :string, required: true
    attr :mode, :atom, required: true

    def render(assigns) do
      ~H"""
      <section id={"composition-#{@instance}"} data-shadcn-theme={@theme} class="bulma-section">
        <h2>Account guidance {@instance}</h2>
        <.separator />
        <.accordion id={"guidance-#{@instance}"} mode={@mode}>
          <:item key="billing" summary="Billing" open>
            <p>Caller-owned billing content for {@instance}.</p>
          </:item>
          <:item key="security" summary="Security">
            <.scroll_area
              id={"activity-#{@instance}"}
              size={:small}
              focusable
              accessible_label={"Security activity #{@instance}"}
            >
              <a href={"#target-#{@instance}"}>Review the final event</a>
              <p id={"target-#{@instance}"}>Final event</p>
            </.scroll_area>
          </:item>
        </.accordion>
      </section>
      """
    end
  end

  test "repeated native compositions remain deterministic across theme scopes" do
    light = render("light", "light", :independent)
    dark = render("dark", "dark", :exclusive)

    assert light == render("light", "light", :independent)
    assert dark == render("dark", "dark", :exclusive)
    assert light =~ ~s(data-shadcn-theme="light")
    assert dark =~ ~s(data-shadcn-theme="dark")
    refute light =~ ~s(name="guidance-light-group")
    assert length(Regex.scan(~r/name="guidance-dark-group"/, dark)) == 2
  end

  test "Accordion composes Separator and Scroll Area without changing native contracts" do
    html = render("composed", "light", :independent)

    assert html =~ "bulma-section"
    assert html =~ "data-shadcn-ui-separator"
    assert html =~ "data-shadcn-ui-scroll-area"
    assert html =~ ~s(role="region")
    assert html =~ ~s(aria-label="Security activity composed")
    assert html =~ ~s(href="#target-composed")
    assert html =~ ~s(id="target-composed")
    assert length(Regex.scan(~r/<details\b/, html)) == 2
    assert length(Regex.scan(~r/<summary\b/, html)) == 2
  end

  test "multiple compositions retain unique caller-derived identities" do
    html = render("one", "light", :independent) <> render("two", "dark", :exclusive)
    ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()

    assert length(ids) == length(Enum.uniq(ids))

    assert Enum.all?(
             ~w(guidance-one-item-billing guidance-two-item-security-content),
             &(&1 in ids)
           )
  end

  test "release and runtime source contain no behavior or application boundary" do
    source =
      "lib/shadcn_ui/components/disclosure/*.ex"
      |> Path.wildcard()
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~
             ~r/(handle_event|push_event|JS\.|addEventListener|localStorage|sessionStorage|Phoenix\.LiveView|Ecto|Ash\.|Repo\.|Dstar|Datastar|Electron|GenServer|Task\.)/

    refute source =~ ~r/(<script|javascript:|role="button"|String\.to_atom|binary_to_atom)/i
    refute File.exists?("assets/accordion.js")
    refute File.exists?("priv/static/accordion.js")
  end

  defp render(instance, theme, mode) do
    %{instance: instance, theme: theme, mode: mode, __changed__: nil}
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
