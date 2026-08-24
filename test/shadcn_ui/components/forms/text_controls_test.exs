defmodule ShadcnUI.Components.Forms.TextControlsTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.input shadcn_ui.forms.shared_contract

  @types ~w(text email password search tel url number date datetime-local month week time)

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :type, :string, default: "text"
    attr :size, :atom, default: :default
    attr :field, :any, default: nil
    attr :id, :string, default: nil
    attr :name, :string, default: nil
    attr :value, :any, default: {:shadcn_ui, :not_provided}
    attr :errors, :any, default: {:shadcn_ui, :not_provided}
    attr :error_mode, :atom, default: :used_input
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :readonly, :boolean, default: false
    attr :minlength, :integer, default: nil
    attr :maxlength, :integer, default: nil
    attr :pattern, :string, default: nil
    attr :min, :any, default: nil
    attr :max, :any, default: nil
    attr :step, :any, default: nil

    def input_fixture(assigns) do
      ~H"""
      <.input
        type={@type}
        size={@size}
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        readonly={@readonly}
        autocomplete="email"
        inputmode="email"
        placeholder="name@example.test"
        minlength={@minlength}
        maxlength={@maxlength}
        pattern={@pattern}
        min={@min}
        max={@max}
        step={@step}
        form="profile"
        describedby="caller-help"
        class="consumer-input"
        field_class="consumer-field"
        autocapitalize="none"
        spellcheck="false"
        aria-label="Wrong label"
        aria-invalid="false"
        data-state="ready"
        phx-change="validate"
        data-on:change="$validate()"
      >
        <:label>Email address</:label>
        <:leading><span aria-hidden="true">@</span></:leading>
        <:trailing><span aria-hidden="true">✓</span></:trailing>
        <:help>Use a private address.</:help>
      </.input>
      """
    end
  end

  test "renders every supported native input type and rejects excluded types" do
    for type <- @types do
      html = render_input(type: type, id: "value_#{type}", name: "value[#{type}]")
      assert html =~ ~s(type="#{type}")
      assert html =~ "<input"
      refute html =~ "<textarea"
    end

    for type <- ~w(checkbox radio range file color hidden button arbitrary) do
      assert_raise ArgumentError, ~r/input type must be one of/, fn ->
        render_input(type: type, id: "rejected", name: "rejected")
      end
    end
  end

  test "normalizes explicit identity, native constraints, globals, and protected semantics" do
    html =
      render_input(
        type: "email",
        id: "profile_email",
        name: "profile[email]",
        value: "ada@example.test",
        errors: ["is unavailable"],
        error_mode: :always,
        required: true,
        readonly: true,
        pending: true,
        minlength: 3,
        maxlength: 120,
        pattern: ".+@.+"
      )

    assert html =~ ~s(id="profile_email")
    assert html =~ ~s(name="profile[email]")
    assert html =~ ~s(type="email")
    assert html =~ ~s(value="ada@example.test")
    assert html =~ " required"
    assert html =~ " readonly"
    refute html =~ " disabled"
    assert html =~ ~s(autocomplete="email")
    assert html =~ ~s(inputmode="email")
    assert html =~ ~s(placeholder="name@example.test")
    assert html =~ ~s(minlength="3")
    assert html =~ ~s(maxlength="120")
    assert html =~ ~s(pattern=".+@.+")
    assert html =~ ~s(form="profile")
    assert html =~ ~s(autocapitalize="none")
    assert html =~ ~s(spellcheck="false")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-change="validate")
    assert html =~ "data-on:change=\"$validate()\""
    assert html =~ ~s(aria-invalid="true")
    refute html =~ "Wrong label"
    refute html =~ ~s(aria-invalid="false")
  end

  test "passes range constraints only to compatible native types" do
    html =
      render_input(
        type: "number",
        id: "quantity",
        name: "quantity",
        min: "1",
        max: "200",
        step: "1"
      )

    assert html =~ ~s(min="1")
    assert html =~ ~s(max="200")
    assert html =~ ~s(step="1")

    assert_raise ArgumentError, ~r/range constraints/, fn ->
      render_input(type: "email", id: "email", name: "email", min: "1")
    end

    assert_raise ArgumentError, ~r/text constraints/, fn ->
      render_input(type: "number", id: "quantity", name: "quantity", minlength: 1)
    end
  end

  test "uses FormField defaults with explicit-over-derived precedence" do
    field = form_field()
    derived = render_input(field: field, error_mode: :always)

    assert derived =~ ~s(id="account_email")
    assert derived =~ ~s(name="account[email]")
    assert derived =~ ~s(value="field@example.test")
    assert derived =~ "must be valid"

    explicit =
      render_input(
        field: field,
        id: "invite_email",
        name: "invite[email]",
        value: "invite@example.test",
        errors: ["already invited"],
        error_mode: :always
      )

    assert explicit =~ ~s(id="invite_email")
    assert explicit =~ ~s(name="invite[email]")
    assert explicit =~ ~s(value="invite@example.test")
    assert explicit =~ "already invited"
    refute explicit =~ "must be valid"
  end

  test "renders deterministic relationships and leading or trailing presentation" do
    html =
      render_input(
        id: "email",
        name: "email",
        errors: ["Repeated", "Repeated"],
        error_mode: :always
      )

    assert html =~ ~s(for="email")
    assert html =~ ~s(id="email-help")
    assert html =~ ~s(id="email-error-1")
    assert html =~ ~s(id="email-error-2")

    assert html =~
             ~s(aria-describedby="caller-help email-help email-error-1 email-error-2")

    assert html =~ "data-shadcn-ui-input-leading"
    assert html =~ "data-shadcn-ui-input-trailing"
    assert html =~ "sui:pl-9"
    assert html =~ "sui:pr-9"
  end

  test "maps closed sizes and keeps pending independent from disabled" do
    expected = %{
      small: ~w(sui:min-h-8 sui:px-2 sui:text-xs),
      default: ~w(sui:min-h-9 sui:px-3 sui:text-sm),
      large: ~w(sui:min-h-10 sui:px-3 sui:text-base)
    }

    for {size, classes} <- expected do
      html = render_input(id: "sized", name: "sized", size: size)
      assert Enum.all?(classes, &String.contains?(html, &1))
    end

    pending = render_input(id: "pending", name: "pending", pending: true)
    assert pending =~ ~s(data-pending="true")
    assert pending =~ "sui:cursor-progress"
    refute pending =~ " disabled"

    disabled = render_input(id: "disabled", name: "disabled", disabled: true)
    assert disabled =~ " disabled"
    refute disabled =~ ~s(data-pending="true")
  end

  test "escapes native values and exposes no structural or behavior API" do
    html = render_input(id: "unsafe", name: "unsafe", value: ~s(<value data-x="1">))
    assert html =~ "&lt;value data-x=&quot;1&quot;&gt;"
    refute html =~ "<value"

    metadata = ShadcnUI.Components.Forms.Input.__components__().input
    type = Enum.find(metadata.attrs, &(&1.name == :type))
    size = Enum.find(metadata.attrs, &(&1.name == :size))

    assert type.opts[:values] == @types
    assert size.opts[:values] == [:small, :default, :large]

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:as, :html, :raw_html, :on_change, :parse, :submit, :reveal]
           end)

    source = File.read!("lib/shadcn_ui/components/forms/input.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|type_atom)/
  end

  test "unknown request types do not create atoms" do
    render_input(id: "warmup", name: "warmup")
    before_count = :erlang.system_info(:atom_count)

    for index <- 1..500 do
      assert_raise ArgumentError, fn ->
        render_input(type: "request-type-#{index}", id: "value", name: "value")
      end
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  defp render_input(overrides) do
    %{
      type: "text",
      size: :default,
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      readonly: false,
      minlength: nil,
      maxlength: nil,
      pattern: nil,
      min: nil,
      max: nil,
      step: nil,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.input_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp form_field do
    form = Phoenix.Component.to_form(%{"email" => "field@example.test"}, as: "account")
    %FormField{} = field = form[:email]
    %FormField{field | errors: [{"must be valid", []}]}
  end
end
