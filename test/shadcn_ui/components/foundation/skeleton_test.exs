defmodule ShadcnUI.Components.Foundation.SkeletonTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.skeleton shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :shape, :atom, default: :rectangle
    attr :size, :atom, default: :default
    attr :pulse, :boolean, default: true

    def render(assigns) do
      ~H"""
      <.skeleton
        shape={@shape}
        size={@size}
        pulse={@pulse}
        class="consumer-skeleton"
        title="Visual placeholder"
        data-layout="profile"
        role="status"
        aria-live="polite"
        aria-label="Loading"
        aria-hidden="false"
        tabindex="0"
        phx-click="load"
        data-on:click="$load()"
      />
      """
    end
  end

  test "renders a passive decorative placeholder and protects hidden semantics" do
    html = render_skeleton()

    assert html =~ "data-shadcn-ui"
    assert html =~ "data-shadcn-ui-skeleton"
    assert html =~ ~s(aria-hidden="true")
    assert html =~ ~s(title="Visual placeholder")
    assert html =~ ~s(data-layout="profile")
    refute html =~ ~s(role="status")
    refute html =~ "aria-live"
    refute html =~ "aria-label"
    refute html =~ "tabindex"
    refute html =~ "phx-click"
    refute html =~ "data-on:click"
  end

  test "maps every closed shape and size deterministically" do
    expected = %{
      rectangle: %{
        small: ~w(sui:h-8 sui:w-full sui:rounded-md),
        default: ~w(sui:h-12 sui:w-full sui:rounded-md),
        large: ~w(sui:h-20 sui:w-full sui:rounded-lg)
      },
      circle: %{
        small: ~w(sui:size-8 sui:rounded-full),
        default: ~w(sui:size-10 sui:rounded-full),
        large: ~w(sui:size-12 sui:rounded-full)
      },
      text: %{
        small: ~w(sui:h-3 sui:w-1/2 sui:rounded-sm),
        default: ~w(sui:h-3.5 sui:w-2/3 sui:rounded-md),
        large: ~w(sui:h-4 sui:w-full sui:rounded-md)
      }
    }

    for {shape, sizes} <- expected, {size, classes} <- sizes do
      html = render_skeleton(shape: shape, size: size)
      assert Enum.all?(classes, &String.contains?(html, &1))
      assert html == render_skeleton(shape: shape, size: size)
    end
  end

  test "pulse is presentation only and can render as a static snapshot" do
    pulse = render_skeleton(pulse: true)
    static = render_skeleton(pulse: false)

    assert pulse =~ ~s(data-pulse="true")
    assert pulse =~ "sui:animate-pulse"
    refute static =~ "data-pulse"
    refute static =~ "sui:animate-pulse"
    assert static =~ "sui:h-12"
  end

  test "stylesheet removes pulse under reduced motion without hiding geometry" do
    source = File.read!("assets/shadcn_ui.css")

    assert source =~ "@media (prefers-reduced-motion: reduce)"
    assert source =~ ~s([data-shadcn-ui-skeleton])
    assert source =~ "animation: none !important"

    refute source =~
             ~r/\[data-shadcn-ui-skeleton\][^{]*\{[^}]*(display:\s*none|visibility:\s*hidden)/s
  end

  test "metadata and source expose no loading lifecycle behavior" do
    metadata = ShadcnUI.Components.Foundation.Skeleton.__components__().skeleton
    shape = Enum.find(metadata.attrs, &(&1.name == :shape))
    size = Enum.find(metadata.attrs, &(&1.name == :size))

    assert shape.opts[:values] == [:rectangle, :circle, :text]
    assert size.opts[:values] == [:small, :default, :large]

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:loading, :on_complete, :replace, :error, :label, :raw_html]
           end)

    source = File.read!("lib/shadcn_ui/components/foundation/skeleton.ex")
    refute source =~ ~r/(push_event|handle_event|JS\.|Task\.|GenServer|Repo\.|fetch\()/
    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
  end

  defp render_skeleton(overrides \\ []) do
    %{
      shape: :rectangle,
      size: :default,
      pulse: true,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
