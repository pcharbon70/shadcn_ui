defmodule ShadcnUI.ComponentContractTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe
  alias ShadcnUI.Component

  defmodule ContractFixture do
    use ShadcnUI.Component

    attr :label, :string, required: true
    attr :variant, :atom, values: [:default, :secondary], default: :default
    attr :type, :string, values: ["button", "submit", "reset"], default: "button"
    attr :disabled, :boolean, default: false
    attr :class, :any, default: nil
    attr :rest, :global, include: ~w(form name value)

    slot :leading
    slot :inner_block, required: true

    def probe(assigns) do
      assigns =
        assigns
        |> assign(
          :safe_globals,
          protect_globals(assigns.rest, [:type, :disabled, :role, :aria_label])
        )
        |> assign(
          :classes,
          class_names([
            "sui:inline-flex",
            classes_for(:variant, assigns.variant),
            classes_for(:focus, :default),
            assigns.class
          ])
        )

      ~H"""
      <button
        {@safe_globals}
        type={@type}
        disabled={@disabled}
        class={@classes}
        aria-label={@label}
      >
        <span :if={@leading != []} aria-hidden="true">{render_slot(@leading)}</span>
        {render_slot(@inner_block)}
      </button>
      """
    end

    attr :label, :string, required: true

    def consumer(assigns) do
      ~H"""
      <.probe
        label="Protected label"
        class={["consumer", nil, false]}
        aria-describedby="help"
        data-state="idle"
        phx-click="save"
        data-on:click="$save()"
        type="submit"
      >
        <:leading>+</:leading>
        {@label}
      </.probe>
      """
    end
  end

  test "fixed mappings return complete prefixed classes or nil" do
    assert Component.classes_for(:variant, :default) == [
             "sui:bg-primary",
             "sui:text-primary-foreground"
           ]

    assert Component.classes_for(:size, :icon) == ["sui:size-9", "sui:p-0"]
    assert Component.classes_for(:radius, :full) == ["sui:rounded-full"]
    assert Component.classes_for(:focus, :default)
    assert Component.classes_for(:disabled, :default)
    assert Component.classes_for(:motion, :pulse) == ["sui:animate-pulse"]
    assert Component.classes_for(:variant, :unknown) == nil
    assert Component.classes_for(:variant, "default") == nil
  end

  test "unknown request strings do not grow the atom table" do
    before_count = :erlang.system_info(:atom_count)

    for index <- 1..1_000 do
      assert Component.classes_for(:variant, "request-value-#{index}") == nil
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  test "class composition is deterministic and validates caller values" do
    assert Component.class_names(["sui:block", [nil, " consumer "], false]) == [
             "sui:block",
             "consumer"
           ]

    assert_raise ArgumentError, ~r/classes must be strings/, fn ->
      Component.class_names(["sui:block", :arbitrary_modifier])
    end
  end

  test "protected globals cannot contradict required semantics" do
    assert Component.protect_globals(
             %{
               "type" => "reset",
               :disabled => false,
               :role => "link",
               "aria-label" => "Wrong",
               "data-state" => "idle"
             },
             [:type, :disabled, :role, :aria_label]
           ) == %{"data-state" => "idle"}
  end

  test "real HEEX preserves globals, slots, escaping, and class order" do
    html =
      %{label: "Save <unsafe>", __changed__: nil}
      |> ContractFixture.consumer()
      |> Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ ~s(type="submit")
    assert html =~ ~s(aria-label="Protected label")
    assert html =~ ~s(aria-describedby="help")
    assert html =~ ~s(data-state="idle")
    assert html =~ ~s(phx-click="save")
    assert html =~ "data-on:click=\"$save()\""
    assert html =~ "class=\"sui:inline-flex sui:bg-primary sui:text-primary-foreground"
    assert html =~ "consumer"
    assert html =~ "Save &lt;unsafe&gt;"
    assert html =~ ">+</span>"
    refute html =~ "<unsafe>"
    refute html =~ ~s(role="link")
  end

  test "fixture metadata exposes closed values and semantic slots" do
    metadata = ContractFixture.__components__().probe
    variant = Enum.find(metadata.attrs, &(&1.name == :variant))
    type = Enum.find(metadata.attrs, &(&1.name == :type))
    inner_block = Enum.find(metadata.slots, &(&1.name == :inner_block))
    leading = Enum.find(metadata.slots, &(&1.name == :leading))

    assert variant.opts[:values] == [:default, :secondary]
    assert type.opts[:values] == ["button", "submit", "reset"]
    assert inner_block.required
    refute leading.required
    refute Enum.any?(metadata.attrs, &(&1.name in [:html, :raw_html]))
  end
end
