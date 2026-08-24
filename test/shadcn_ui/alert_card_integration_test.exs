defmodule ShadcnUI.AlertCardIntegrationTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.alert shadcn_ui.foundation.alert_ownership
  # covers: shadcn_ui.foundation.card shadcn_ui.foundation.shared_contract

  defmodule ConsumerFixture do
    use Phoenix.Component
    use ShadcnUI

    attr :theme, :string, required: true
    attr :variant, :atom, required: true
    attr :announcement, :atom, required: true
    attr :title, :string, required: true
    attr :description, :string, required: true
    attr :dense, :boolean, required: true

    def render(assigns) do
      ~H"""
      <section
        data-shadcn-theme={@theme}
        data-phase-three-fixture
        class="sui:w-full sui:max-w-full"
      >
        <.card aria-labelledby={@dense && "#{@theme}-heading"} data-density="stress">
          <:title :if={@dense}>
            <h2 id={"#{@theme}-heading"}>{@title}</h2>
          </:title>
          <:description :if={@dense}>
            A caller-authored description that remains readable with deliberately long English content.
          </:description>
          <:actions :if={@dense}>
            <.badge variant={:secondary}>Caller-owned state</.badge>
          </:actions>
          <.alert
            variant={@variant}
            announcement={@announcement}
            title="Visible feedback"
            description={@description}
            data-operation="caller-owned"
          >
            <:icon><span aria-hidden="true">!</span></:icon>
            <:actions>
              <.button variant={:outline}>Retry in application</.button>
              <a href="/details">Open details</a>
            </:actions>
          </.alert>
          <:footer :if={@dense}>
            <form action="/acknowledge" method="post">
              <.button type="submit">Acknowledge</.button>
            </form>
          </:footer>
        </.card>
      </section>
      """
    end
  end

  test "public HEEX composes feedback and surfaces in both supported themes" do
    html = render_matrix()

    assert count(html, ~r/data-phase-three-fixture/) == 2
    assert html =~ ~s(data-shadcn-theme="light")
    assert html =~ ~s(data-shadcn-theme="dark")
    assert html =~ ~s(role="status")
    assert html =~ ~s(aria-live="polite")
    assert html =~ ~s(role="alert")
    assert html =~ ~s(aria-live="assertive")
    assert html =~ "sui:border-destructive/30"
    assert html =~ "sui:bg-card"
    assert html =~ "sui:max-w-full"
  end

  test "preserves headings, slot order, nested controls, globals, and escaping" do
    html = render_matrix()

    assert html =~ ~s(<h2 id="light-heading">Light feedback surface</h2>)
    refute html =~ ~s(<h2 id="dark-heading">Dark feedback surface</h2>)
    assert html =~ ~s(data-operation="caller-owned")
    assert html =~ "Long &lt;unsafe&gt; feedback"
    refute html =~ "<unsafe>"

    assert count(html, ~r/<button\b/) == 3
    assert count(html, ~r/<a href="\/details"/) == 2
    assert count(html, ~r/<form action="\/acknowledge" method="post">/) == 1
    assert count(html, ~r/<span[^>]*data-shadcn-ui[^>]*>Caller-owned state<\/span>/) == 1

    assert html =~
             ~r/slot="title".*slot="description".*slot="actions".*slot="content".*slot="footer"/s

    assert html =~
             ~r/slot="icon".*slot="content".*slot="title".*slot="description".*slot="actions"/s
  end

  test "compiled stylesheet contains every rendered class and accessibility mode" do
    html = render_matrix()
    css = File.read!(ShadcnUI.stylesheet_path())

    classes =
      ~r/class="([^"]+)"/
      |> Regex.scan(html, capture: :all_but_first)
      |> List.flatten()
      |> Enum.flat_map(&String.split/1)
      |> Enum.filter(&String.starts_with?(&1, "sui" <> ":"))
      |> Enum.uniq()

    for class <- classes do
      assert css =~ css_class(class), "compiled CSS is missing #{class}"
    end

    assert css =~ "data-shadcn-theme=dark"
    assert css =~ "prefers-reduced-motion:reduce"
    assert css =~ "forced-colors:active"
    assert css =~ "outline-color:highlight"
  end

  test "component source remains a static presentation boundary" do
    source =
      [
        "lib/shadcn_ui/components/foundation/alert.ex",
        "lib/shadcn_ui/components/foundation/card.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~ ~r/(Dstar|Datastar|LiveView|push_event|handle_event|JS\.|GenServer|Repo\.)/
    refute source =~ ~r/(System\.unique_integer|:rand|UUID|random)/i
    refute source =~ ~r/(raw_html|HTML\.raw|javascript:|<script)/i
    refute source =~ ~r/"sui:#\{|String\.to_atom|binary_to_atom/
  end

  defp render_matrix do
    [
      %{
        theme: "light",
        variant: :default,
        announcement: :polite,
        title: "Light feedback surface",
        description: "Long <unsafe> feedback " <> String.duplicate("that wraps safely ", 12),
        dense: true,
        __changed__: nil
      },
      %{
        theme: "dark",
        variant: :destructive,
        announcement: :assertive,
        title: "Dark feedback surface",
        description: "Long destructive feedback " <> String.duplicate("that wraps safely ", 12),
        dense: false,
        __changed__: nil
      }
    ]
    |> Enum.map_join(fn assigns ->
      assigns |> ConsumerFixture.render() |> Safe.to_iodata() |> IO.iodata_to_binary()
    end)
  end

  defp count(content, pattern), do: pattern |> Regex.scan(content) |> length()

  defp css_class(class) do
    "." <>
      (class
       |> String.replace("\\", "\\\\")
       |> String.replace(":", "\\:")
       |> String.replace(".", "\\.")
       |> String.replace("/", "\\/")
       |> String.replace("[", "\\[")
       |> String.replace("]", "\\]"))
  end
end
