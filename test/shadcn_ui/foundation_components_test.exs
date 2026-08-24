defmodule ShadcnUI.FoundationComponentsTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.button shadcn_ui.foundation.button_content
  # covers: shadcn_ui.foundation.badge shadcn_ui.foundation.shared_contract

  @button_variants [:default, :secondary, :destructive, :outline, :ghost, :link]
  @button_sizes [:small, :default, :large, :icon]
  @badge_variants [:default, :secondary, :destructive, :outline]

  defmodule ConsumerFixture do
    use Phoenix.Component
    use ShadcnUI

    attr :button_variants, :list, required: true
    attr :button_sizes, :list, required: true
    attr :badge_variants, :list, required: true

    def render(assigns) do
      ~H"""
      <section data-shadcn-theme="light" aria-labelledby="light-heading">
        <h2 id="light-heading">Light action and label matrix</h2>
        <.button
          :for={variant <- @button_variants}
          variant={variant}
          data-variant={variant}
        >
          {variant} action
        </.button>
        <.button
          :for={size <- @button_sizes}
          size={size}
          accessible_label={size == :icon && "Icon action"}
          data-size={size}
        >
          {if size == :icon, do: "+", else: "A deliberately long #{size} action label"}
        </.button>
        <.button disabled>Disabled action</.button>
        <.button loading>Pending action</.button>
        <.badge :for={variant <- @badge_variants} variant={variant} data-variant={variant}>
          {variant} state
        </.badge>
      </section>

      <section data-shadcn-theme="dark" aria-labelledby="dark-heading">
        <h2 id="dark-heading">Dark action and label matrix</h2>
        <.button variant={:default}>Dark action</.button>
        <.button variant={:outline}>Dark outline action</.button>
        <.badge>Dark state</.badge>
        <.badge variant={:outline}>A deliberately long translated release state label</.badge>
      </section>
      """
    end
  end

  test "public imports render the complete closed Button and Badge matrix" do
    html = render_matrix()

    assert count(html, ~r/<button\b/) ==
             length(@button_variants) + length(@button_sizes) + 4

    assert count(html, ~r/<span\b/) == length(@badge_variants) + 2

    for variant <- @button_variants do
      assert html =~ ~s(data-variant="#{variant}")
    end

    for size <- @button_sizes do
      assert html =~ ~s(data-size="#{size}")
    end

    for variant <- @badge_variants do
      assert html =~ ~s(data-variant="#{variant}")
    end

    assert html =~ ~s(type="button")
    assert html =~ " disabled"
    assert html =~ ~s(aria-label="Icon action")
    assert html =~ ~s(aria-busy="true")
    refute html =~ ~r/<a\b|\srole="(?:button|link)"/
  end

  test "rendering is deterministic, escaped, and resilient to long narrow content" do
    first = render_matrix()
    second = render_matrix()

    assert first == second
    assert first =~ "A deliberately long default action label"
    assert first =~ "A deliberately long translated release state label"
    assert first =~ "sui:max-w-full"
    assert first =~ "sui:whitespace-normal"
    refute first =~ "sui:whitespace-nowrap"
  end

  test "compiled CSS contains every component class and accessibility fallback" do
    css = File.read!(ShadcnUI.stylesheet_path())
    html = render_matrix()

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

    assert css =~ "var(--shadcn-ui-primary)"
    assert css =~ "var(--shadcn-ui-secondary)"
    assert css =~ "var(--shadcn-ui-destructive)"
    assert css =~ "forced-colors:active"
    assert css =~ "outline-color:highlight"
    assert css =~ "color:graytext"
    assert css =~ "prefers-reduced-motion:reduce"
    refute css =~ ~r/(^|})\.(?:inline-flex|bg-primary|text-xs)(?:[,{])/m
  end

  test "component sources contain no transport, event, random identity, or raw HTML behavior" do
    source =
      [
        "lib/shadcn_ui/components/foundation/button.ex",
        "lib/shadcn_ui/components/foundation/badge.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~ ~r/(Dstar|Datastar|LiveView|push_event|handle_event|JS\.|GenServer|Repo\.)/
    refute source =~ ~r/(System\.unique_integer|:rand|UUID|random)/i
    refute source =~ ~r/(raw_html|HTML\.raw|javascript:|<script)/i
    refute source =~ ~r/"sui:#\{|String\.to_atom|binary_to_atom/
  end

  defp render_matrix do
    %{
      button_variants: @button_variants,
      button_sizes: @button_sizes,
      badge_variants: @badge_variants,
      __changed__: nil
    }
    |> ConsumerFixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp count(content, pattern), do: pattern |> Regex.scan(content) |> length()

  defp css_class(class) do
    "." <>
      (class
       |> String.replace("\\", "\\\\")
       |> String.replace(":", "\\:")
       |> String.replace(".", "\\.")
       |> String.replace("/", "\\/"))
  end
end
