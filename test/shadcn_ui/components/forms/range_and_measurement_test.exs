defmodule ShadcnUI.Components.Forms.RangeAndMeasurementTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.slider shadcn_ui.forms.shared_contract
  # covers: shadcn_ui.form.normalization shadcn_ui.form.deterministic_relationships
  # covers: shadcn_ui.form.native_states shadcn_ui.form.protected_globals
  # covers: shadcn_ui.form.native_submission shadcn_ui.stylesheet.form_resilience

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr(:field, :any, default: nil)
    attr(:id, :string, default: nil)
    attr(:name, :string, default: nil)
    attr(:value, :any, default: {:shadcn_ui, :not_provided})
    attr(:errors, :any, default: {:shadcn_ui, :not_provided})
    attr(:error_mode, :atom, default: :used_input)
    attr(:pending, :boolean, default: false)
    attr(:required, :boolean, default: false)
    attr(:disabled, :boolean, default: false)

    def slider_fixture(assigns) do
      ~H"""
      <.slider
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        min={0}
        max={100}
        step={5}
        form="settings"
        describedby="caller-description caller-description"
        class="consumer-slider"
        field_class="consumer-field"
        autofocus
        role="slider"
        aria-label="Wrong label"
        aria-invalid="false"
        data-owner="application"
        phx-change="caller-owned"
      >
        <:label>Volume</:label>
        <:value_description>Quiet through loud.</:value_description>
        <:help>Choose a percentage.</:help>
      </.slider>
      """
    end
  end

  test "renders one native range input with explicit values and relationships" do
    html =
      render_slider(
        id: "settings_volume",
        name: "settings[volume]",
        value: 35,
        required: true
      )

    assert length(Regex.scan(~r/<input\b/, html)) == 1
    assert html =~ ~s(type="range")
    assert html =~ ~s(id="settings_volume")
    assert html =~ ~s(name="settings[volume]")
    assert html =~ ~s(value="35")
    assert html =~ ~s(min="0")
    assert html =~ ~s(max="100")
    assert html =~ ~s(step="5")
    assert html =~ ~s(form="settings")
    assert html =~ " required"

    assert html =~
             ~s(aria-describedby="caller-description settings_volume-value-description settings_volume-help")

    assert html =~ ~s(id="settings_volume-value-description")
    assert html =~ "Quiet through loud."
    refute html =~ ~s(type="hidden")
  end

  test "derives FormField identity and value while explicit value wins" do
    field = form_field(:volume, "45")
    derived = render_slider(field: field)

    assert derived =~ ~s(id="settings_volume")
    assert derived =~ ~s(name="settings[volume]")
    assert derived =~ ~s(value="45")

    explicit = render_slider(field: field, value: 70)
    assert explicit =~ ~s(value="70")
    refute explicit =~ ~s(value="45")
  end

  test "preserves invalid disabled and pending snapshots while protecting semantics" do
    html =
      render_slider(
        id: "volume",
        name: "volume",
        errors: ["Choose a supported level"],
        error_mode: :always,
        pending: true,
        disabled: true
      )

    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~s(data-pending="true")
    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(phx-change="caller-owned")
    assert html =~ " disabled"
    refute html =~ "Wrong label"
    refute html =~ ~s(role="slider")
    refute html =~ ~s(aria-invalid="false")
  end

  test "owns no drag model, parser, synchronized output, or executable behavior" do
    metadata = ShadcnUI.Components.Forms.Slider.__components__().slider

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:dragging, :on_change, :on_drag, :formatter, :parser, :output]
           end)

    source = File.read!("lib/shadcn_ui/components/forms/slider.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|type="hidden"|<output)/
  end

  test "styles preserve native fallback, pointer target, focus, themes, and forced colors" do
    source_css = File.read!("assets/shadcn_ui.css")
    compiled_css = File.read!(ShadcnUI.stylesheet_path())

    assert source_css =~ ~s([data-shadcn-ui-slider] {)
    assert source_css =~ "appearance: auto"
    assert source_css =~ "min-block-size: 2.75rem"
    assert source_css =~ "::-webkit-slider-runnable-track"
    assert source_css =~ "::-moz-range-track"
    assert source_css =~ ":focus-visible"
    assert source_css =~ "@media (forced-colors: active)"
    assert source_css =~ "forced-color-adjust: auto"
    assert compiled_css =~ "data-shadcn-ui-slider"
    refute source_css =~ ~r/\[data-shadcn-ui-slider[^}]*transform:/s
  end

  defp render_slider(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.slider_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp form_field(key, value) do
    form = Phoenix.Component.to_form(%{Atom.to_string(key) => value}, as: "settings")
    %FormField{} = form[key]
  end
end
