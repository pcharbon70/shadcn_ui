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

    attr(:id, :string, required: true)
    attr(:value, :any, default: {:shadcn_ui, :not_provided})
    attr(:max, :any, default: 1)
    attr(:accessible_label, :string, default: nil)
    attr(:visible_label, :boolean, default: true)
    attr(:size, :atom, default: :default)
    attr(:variant, :atom, default: :default)

    def progress_fixture(assigns) do
      ~H"""
      <.progress
        id={@id}
        value={@value}
        max={@max}
        accessible_label={@accessible_label}
        size={@size}
        variant={@variant}
        role="meter"
        aria-label="Wrong label"
        data-owner="application"
      >
        <:label :if={@visible_label}>Report generation</:label>
        <:description>Caller snapshot &lt;safe&gt;</:description>
      </.progress>
      """
    end

    attr(:id, :string, required: true)
    attr(:value, :any, required: true)
    attr(:min, :any, default: 0)
    attr(:max, :any, default: 1)
    attr(:low, :any, default: nil)
    attr(:high, :any, default: nil)
    attr(:optimum, :any, default: nil)
    attr(:accessible_label, :string, default: nil)
    attr(:visible_label, :boolean, default: true)
    attr(:size, :atom, default: :default)

    def meter_fixture(assigns) do
      ~H"""
      <.meter
        id={@id}
        value={@value}
        min={@min}
        max={@max}
        low={@low}
        high={@high}
        optimum={@optimum}
        accessible_label={@accessible_label}
        size={@size}
        role="progressbar"
        aria-label="Wrong label"
        data-owner="application"
      >
        <:label :if={@visible_label}>Storage use</:label>
        <:description>Caller measurement &lt;safe&gt;</:description>
      </.meter>
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

  test "progress preserves native determinate and indeterminate task semantics" do
    determinate = render_progress(id: "report-progress", value: 3, max: 10, size: :large)

    assert determinate =~ ~s(<progress)
    assert determinate =~ ~s(id="report-progress")
    assert determinate =~ ~s(value="3")
    assert determinate =~ ~s(max="10")
    assert determinate =~ ~s(aria-labelledby="report-progress-label")
    assert determinate =~ ~s(aria-describedby="report-progress-description")
    assert determinate =~ "Caller snapshot &lt;safe&gt;"
    assert determinate =~ ~s(data-size="large")
    assert determinate =~ ~s(data-owner="application")
    refute determinate =~ ~s(role="meter")
    refute determinate =~ "Wrong label"
    refute determinate =~ "<meter"

    indeterminate =
      render_progress(
        id: "background-progress",
        visible_label: false,
        accessible_label: "Background report"
      )

    assert indeterminate =~ ~s(aria-label="Background report")
    refute indeterminate =~ ~r/<progress[^>]*\svalue=/
  end

  test "progress rejects missing names and invalid numeric bounds" do
    assert_raise ArgumentError, ~r/requires a visible label or accessible_label/, fn ->
      render_progress(id: "unnamed", visible_label: false)
    end

    assert_raise ArgumentError, ~r/either a visible label or accessible_label/, fn ->
      render_progress(id: "conflicting", accessible_label: "Duplicate")
    end

    for overrides <- [[max: 0], [value: -1], [value: 11, max: 10], [value: "3"]] do
      assert_raise ArgumentError, fn -> render_progress([id: "invalid-progress"] ++ overrides) end
    end
  end

  test "meter preserves native measurement range and threshold semantics" do
    html =
      render_meter(
        id: "storage-use",
        value: 72,
        min: 0,
        max: 100,
        low: 60,
        high: 85,
        optimum: 40,
        size: :small
      )

    assert html =~ ~s(<meter)
    assert html =~ ~s(id="storage-use")
    assert html =~ ~s(value="72")
    assert html =~ ~s(min="0")
    assert html =~ ~s(max="100")
    assert html =~ ~s(low="60")
    assert html =~ ~s(high="85")
    assert html =~ ~s(optimum="40")
    assert html =~ ~s(aria-labelledby="storage-use-label")
    assert html =~ ~s(aria-describedby="storage-use-description")
    assert html =~ ~s(data-size="small")
    assert html =~ "Caller measurement &lt;safe&gt;"
    assert html =~ ~s(data-owner="application")
    refute html =~ ~s(role="progressbar")
    refute html =~ "Wrong label"
    refute html =~ "<progress"
  end

  test "meter rejects missing names and contradictory range or threshold values" do
    assert_raise ArgumentError, ~r/requires a visible label or accessible_label/, fn ->
      render_meter(id: "unnamed-meter", value: 1, visible_label: false)
    end

    invalid = [
      [value: 5, min: 10, max: 0],
      [value: -1, min: 0, max: 10],
      [value: 11, min: 0, max: 10],
      [value: 5, min: 0, max: 10, low: 8, high: 4],
      [value: 5, min: 0, max: 10, optimum: 11],
      [value: "5"]
    ]

    for overrides <- invalid do
      assert_raise ArgumentError, fn -> render_meter([id: "invalid-meter"] ++ overrides) end
    end
  end

  test "progress and meter styles retain separate native elements and static fallbacks" do
    source_css = File.read!("assets/shadcn_ui.css")

    assert source_css =~ "[data-shadcn-ui-progress]"
    assert source_css =~ "::-webkit-progress-value"
    assert source_css =~ "[data-shadcn-ui-meter]"
    assert source_css =~ "::-webkit-meter-optimum-value"
    assert source_css =~ "::-webkit-meter-even-less-good-value"
    assert source_css =~ "forced-color-adjust: auto"
    refute source_css =~ ~r/\[data-shadcn-ui-progress[^}]*animation:/s
    refute source_css =~ ~r/\[data-shadcn-ui-meter[^}]*animation:/s

    source =
      ["progress.ex", "meter.ex"]
      |> Enum.map_join("\n", &File.read!("lib/shadcn_ui/components/forms/#{&1}"))

    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|aria-live)/
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

  defp render_progress(overrides) do
    %{
      id: nil,
      value: {:shadcn_ui, :not_provided},
      max: 1,
      accessible_label: nil,
      visible_label: true,
      size: :default,
      variant: :default,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.progress_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render_meter(overrides) do
    %{
      id: nil,
      value: nil,
      min: 0,
      max: 1,
      low: nil,
      high: nil,
      optimum: nil,
      accessible_label: nil,
      visible_label: true,
      size: :default,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.meter_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp form_field(key, value) do
    form = Phoenix.Component.to_form(%{Atom.to_string(key) => value}, as: "settings")
    %FormField{} = form[key]
  end
end
