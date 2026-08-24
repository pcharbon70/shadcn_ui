defmodule ShadcnUI.Components.Foundation.AvatarTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.avatar shadcn_ui.foundation.avatar_stack
  # covers: shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :initials, :string, default: "PC"
    attr :image_src, :string, default: nil
    attr :image_alt, :string, default: nil
    attr :size, :atom, default: :default
    attr :stack_position, :atom, default: :none

    def render(assigns) do
      ~H"""
      <.avatar
        initials={@initials}
        image_src={@image_src}
        image_alt={@image_alt}
        size={@size}
        stack_position={@stack_position}
        class="consumer-avatar"
        data-person-id="42"
        phx-mounted="observe"
      />
      """
    end
  end

  test "renders escaped initials as the stable accessible baseline" do
    html = render_avatar(initials: "P<")

    assert html =~ ~s(data-shadcn-ui-slot="initials")
    assert html =~ "P&lt;"
    assert html =~ ~s(data-person-id="42")
    assert html =~ ~s(phx-mounted="observe")
    refute html =~ "<img"
    refute html =~ "aria-hidden"
  end

  test "layers a meaningful caller image without duplicating its accessible name" do
    html = render_avatar(image_src: "/people/pascal.jpg", image_alt: "Pascal Charbonneau")

    assert html =~ ~s(src="/people/pascal.jpg")
    assert html =~ ~s(alt="Pascal Charbonneau")
    assert html =~ ~s(data-shadcn-ui-slot="image")
    assert html =~ ~s(data-shadcn-ui-slot="initials" aria-hidden="true")
    assert html =~ ~r/>\s*PC\s*</
    refute html =~ "onerror"
  end

  test "requires nonblank initials and paired image source and alt" do
    for initials <- [nil, "", "  "] do
      assert_raise ArgumentError, ~r/initials must be nonblank/, fn ->
        render_avatar(initials: initials)
      end
    end

    for pair <- [
          [image_src: "/person.jpg", image_alt: nil],
          [image_src: nil, image_alt: "Person"],
          [image_src: " ", image_alt: "Person"],
          [image_src: "/person.jpg", image_alt: " "]
        ] do
      assert_raise ArgumentError, ~r/must be provided together/, fn -> render_avatar(pair) end
    end
  end

  test "maps every closed size and bounded stack position" do
    sizes = %{
      small: ~w(sui:size-8 sui:text-xs),
      default: ~w(sui:size-9 sui:text-xs),
      large: ~w(sui:size-12 sui:text-sm)
    }

    stacks = %{
      none: [],
      first: ~w(sui:border-2 sui:border-background),
      middle: ~w(sui:-ml-2 sui:border-2 sui:border-background),
      last: ~w(sui:-ml-2 sui:border-2 sui:border-background)
    }

    for {size, size_classes} <- sizes, {position, stack_classes} <- stacks do
      html = render_avatar(size: size, stack_position: position)
      assert Enum.all?(size_classes ++ stack_classes, &String.contains?(html, &1))
    end
  end

  test "metadata and source expose no image lifecycle or provider behavior" do
    metadata = ShadcnUI.Components.Foundation.Avatar.__components__().avatar
    size = Enum.find(metadata.attrs, &(&1.name == :size))
    stack = Enum.find(metadata.attrs, &(&1.name == :stack_position))

    assert size.opts[:values] == [:small, :default, :large]
    assert stack.opts[:values] == [:none, :first, :middle, :last]

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:on_error, :provider, :upload, :record, :random_color, :raw_html]
           end)

    source = File.read!("lib/shadcn_ui/components/foundation/avatar.ex")

    refute source =~
             ~r/(push_event|handle_event|fetch\(|HTTPoison|Req\.|ImageProvider|Upload|:rand)/

    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
  end

  defp render_avatar(overrides) do
    %{
      initials: "PC",
      image_src: nil,
      image_alt: nil,
      size: :default,
      stack_position: :none,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
