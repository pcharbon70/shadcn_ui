defmodule ShadcnUI.Components.Foundation.BadgeTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.badge shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :variant, :atom, default: :default
    attr :content, :string, default: "Ready"
    attr :rest, :global

    def render(assigns) do
      ~H"""
      <.badge
        variant={@variant}
        class={["consumer-badge", nil, false]}
        id="release-state"
        title="Release state"
        aria-label="Current release state"
        data-state="ready"
        {@rest}
      >
        {@content}
      </.badge>
      """
    end
  end

  test "renders one passive span with escaped required content and caller globals" do
    html = render_badge(content: "Ready <unsafe>")

    assert html =~ "<span"
    assert html =~ "Ready &lt;unsafe&gt;"
    assert html =~ ~s(id="release-state")
    assert html =~ ~s(title="Release state")
    assert html =~ ~s(aria-label="Current release state")
    assert html =~ ~s(data-state="ready")
    assert html =~ "consumer-badge"
    refute html =~ "<unsafe>"
    refute html =~ ~r/<(?:a|button)\b/
    refute html =~ ~r/\srole=|\stabindex=|\sdisabled=/
  end

  test "maps four variants to deterministic semantic-token classes" do
    variants = %{
      default: ~w(sui:bg-primary sui:text-primary-foreground),
      secondary: ~w(sui:bg-secondary sui:text-secondary-foreground),
      destructive: ~w(sui:bg-destructive sui:text-destructive-foreground),
      outline: ~w(sui:border sui:border-border sui:bg-transparent sui:text-foreground)
    }

    for {variant, expected_variant_classes} <- variants do
      classes = variant |> render_badge() |> attribute("class")

      assert Enum.take(classes, 8) == ~w(
               sui:inline-flex sui:items-center sui:whitespace-nowrap sui:rounded-full
               sui:px-2.5 sui:py-0.5 sui:text-xs sui:font-medium
             )

      assert Enum.all?(expected_variant_classes, &(&1 in classes))
      assert List.last(classes) == "consumer-badge"
    end
  end

  test "preserves long text and deterministic rendering" do
    content = String.duplicate("Long translated release state ", 12)

    assert render_badge(content: content) == render_badge(content: content)
    assert render_badge(content: content) =~ String.trim(content)
  end

  test "rejects link, button, role, and event attributes" do
    for {key, value} <- [
          {:href, "/releases"},
          {:type, "button"},
          {:disabled, true},
          {:role, "button"},
          {:tabindex, "0"},
          {"phx-click", "select"},
          {"data-on:click", "$select()"},
          {:onclick, "select()"}
        ] do
      assert_raise ArgumentError, ~r/does not accept interactive attribute/, fn ->
        render_badge(rest: %{key => value})
      end
    end
  end

  test "metadata exposes only the passive public contract" do
    metadata = ShadcnUI.Components.Foundation.Badge.__components__().badge
    variant = Enum.find(metadata.attrs, &(&1.name == :variant))
    inner_block = Enum.find(metadata.slots, &(&1.name == :inner_block))

    assert variant.opts[:values] == [:default, :secondary, :destructive, :outline]
    assert inner_block.required

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:href, :navigate, :patch, :type, :disabled, :selected, :dismiss]
           end)
  end

  test "source contains no component runtime or application behavior" do
    source = File.read!("lib/shadcn_ui/components/foundation/badge.ex")

    refute source =~
             ~r/(push_event|handle_event|JS\.|System\.cmd|Task\.|GenServer|Repo\.|HTTP|fetch\()/

    refute source =~ ~r/<script|javascript:/i
  end

  defp render_badge(variant) when is_atom(variant), do: render_badge(variant: variant)

  defp render_badge(overrides) do
    %{
      variant: :default,
      content: "Ready",
      rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp attribute(html, name) do
    [value] = Regex.run(~r/#{Regex.escape(name)}="([^"]*)"/, html, capture: :all_but_first)
    String.split(value)
  end
end
