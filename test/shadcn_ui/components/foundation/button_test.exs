defmodule ShadcnUI.Components.Foundation.ButtonTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.button shadcn_ui.foundation.button_content
  # covers: shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :type, :string, default: "button"
    attr :variant, :atom, default: :default
    attr :size, :atom, default: :default
    attr :disabled, :boolean, default: false
    attr :loading, :boolean, default: false
    attr :accessible_label, :string, default: nil
    attr :content, :string, default: "Save & continue"

    def render(assigns) do
      ~H"""
      <.button
        type={@type}
        variant={@variant}
        size={@size}
        disabled={@disabled}
        loading={@loading}
        accessible_label={@accessible_label}
        class={["consumer-button", nil, false]}
        form="profile"
        name="intent"
        value="save"
        aria-describedby="button-help"
        data-state="ready"
        phx-click="save"
        data-on:click="$save()"
      >
        <:leading><span data-position="leading">Before</span></:leading>
        {@content}
        <:trailing><span data-position="trailing">After</span></:trailing>
      </.button>
      """
    end

    def conflicting(assigns) do
      ~H"""
      <.button
        size={:icon}
        accessible_label="Protected name"
        type="reset"
        disabled
        role="link"
        aria-label="Wrong name"
        aria-busy="false"
        data-loading="false"
        data-shadcn-ui="wrong"
      >
        <span aria-hidden="true">+</span>
      </.button>
      """
    end
  end

  test "renders native semantics, slots, caller attributes, and escaped content" do
    html = render_button(content: "Save <unsafe>")

    assert html =~ "<button"
    assert html =~ ~s(type="button")
    assert html =~ ~s(form="profile")
    assert html =~ ~s(name="intent")
    assert html =~ ~s(value="save")
    assert html =~ ~s(aria-describedby="button-help")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-click="save")
    assert html =~ "data-on:click=\"$save()\""
    assert html =~ ~s(data-shadcn-ui-slot="leading")
    assert html =~ ~s(data-shadcn-ui-slot="trailing")
    assert html =~ ~r/data-position="leading".*Save &lt;unsafe&gt;.*data-position="trailing"/s
    refute html =~ "<unsafe>"
  end

  test "maps every closed variant and size to deterministic prefixed classes" do
    variants = %{
      default: ~w(sui:bg-primary sui:text-primary-foreground sui:hover:opacity-90),
      secondary: ~w(sui:bg-secondary sui:text-secondary-foreground sui:hover:bg-accent),
      destructive: ~w(sui:bg-destructive sui:text-destructive-foreground),
      outline: ~w(sui:border sui:border-input sui:bg-background sui:text-foreground),
      ghost: ~w(sui:bg-transparent sui:text-foreground sui:hover:bg-accent),
      link: ~w(sui:bg-transparent sui:text-primary sui:hover:underline)
    }

    sizes = %{
      small: ~w(sui:min-h-8 sui:px-3 sui:py-1 sui:text-xs),
      default: ~w(sui:min-h-9 sui:px-4 sui:py-2),
      large: ~w(sui:min-h-10 sui:px-8 sui:py-2),
      icon: ~w(sui:size-9 sui:shrink-0 sui:p-0)
    }

    for {variant, variant_classes} <- variants,
        {size, size_classes} <- sizes do
      label = if size == :icon, do: "Save", else: nil
      html = render_button(variant: variant, size: size, accessible_label: label)
      classes = attribute(html, "class")

      assert Enum.take(classes, 11) == ~w(
               sui:inline-flex sui:cursor-pointer sui:items-center sui:justify-center
               sui:gap-2 sui:max-w-full sui:whitespace-normal sui:text-center
               sui:rounded-lg sui:text-sm sui:font-medium
             )

      assert Enum.all?(variant_classes ++ size_classes, &(&1 in classes))
      assert List.last(classes) == "consumer-button"
      assert Enum.all?(classes, &component_or_consumer_class?/1)
    end
  end

  test "preserves native types and separates loading from disabled" do
    for type <- ~w(button submit reset) do
      assert render_button(type: type) =~ ~s(type="#{type}")
    end

    loading = render_button(loading: true)
    assert loading =~ ~s(data-loading="true")
    assert loading =~ ~s(aria-busy="true")
    assert loading =~ "sui:cursor-wait"
    refute loading =~ " disabled"

    disabled = render_button(disabled: true)
    assert disabled =~ " disabled"
    refute disabled =~ "aria-busy"
  end

  test "requires a nonblank accessible label for icon-only presentation" do
    for label <- [nil, "", "   "] do
      assert_raise ArgumentError, ~r/nonblank accessible_label/, fn ->
        render_button(size: :icon, accessible_label: label)
      end
    end

    assert render_button(size: :icon, accessible_label: "  Save  ") =~
             ~s(aria-label="Save")
  end

  test "protects mandatory native and accessibility semantics" do
    html =
      %{:__changed__ => nil}
      |> Fixture.conflicting()
      |> safe_to_string()

    assert html =~ ~s(type="reset")
    assert html =~ " disabled"
    assert html =~ ~s(aria-label="Protected name")
    assert html =~ "data-shadcn-ui"
    refute html =~ ~s(role="link")
    refute html =~ "Wrong name"
    refute html =~ ~s(aria-busy="false")
    refute html =~ ~s(data-loading="false")
    refute html =~ ~s(data-shadcn-ui="wrong")
  end

  test "metadata exposes the complete closed API without behavior callbacks" do
    metadata = ShadcnUI.Components.Foundation.Button.__components__().button
    type = Enum.find(metadata.attrs, &(&1.name == :type))
    variant = Enum.find(metadata.attrs, &(&1.name == :variant))
    size = Enum.find(metadata.attrs, &(&1.name == :size))
    inner_block = Enum.find(metadata.slots, &(&1.name == :inner_block))

    assert type.opts[:values] == ~w(button submit reset)

    assert variant.opts[:values] ==
             [:default, :secondary, :destructive, :outline, :ghost, :link]

    assert size.opts[:values] == [:small, :default, :large, :icon]
    assert inner_block.required

    refute Enum.any?(
             metadata.attrs,
             &(&1.name in [:on_click, :command, :request, :html, :raw_html])
           )
  end

  test "source contains no component runtime or application operation" do
    source = File.read!("lib/shadcn_ui/components/foundation/button.ex")

    refute source =~
             ~r/(push_event|handle_event|JS\.|System\.cmd|Task\.|GenServer|Repo\.|HTTP|fetch\()/

    refute source =~ ~r/<script|javascript:/i
  end

  defp render_button(overrides) do
    %{
      type: "button",
      variant: :default,
      size: :default,
      disabled: false,
      loading: false,
      accessible_label: nil,
      content: "Save & continue",
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> safe_to_string()
  end

  defp safe_to_string(rendered) do
    rendered |> Safe.to_iodata() |> IO.iodata_to_binary()
  end

  defp attribute(html, name) do
    [value] = Regex.run(~r/#{Regex.escape(name)}="([^"]*)"/, html, capture: :all_but_first)
    String.split(value)
  end

  defp component_or_consumer_class?("consumer-button"), do: true
  defp component_or_consumer_class?("sui" <> ":" <> _class), do: true
  defp component_or_consumer_class?(_class), do: false
end
