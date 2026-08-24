defmodule ShadcnUI.Components.Forms.FieldTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.field_composition shadcn_ui.forms.field_fragments
  # covers: shadcn_ui.forms.error_summary shadcn_ui.forms.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :field, :any, default: nil
    attr :id, :string, default: nil
    attr :name, :string, default: nil
    attr :value, :any, default: {:shadcn_ui, :not_provided}
    attr :errors, :any, default: {:shadcn_ui, :not_provided}
    attr :error_mode, :atom, default: :used_input
    attr :used, :boolean, default: false
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :optional, :boolean, default: false
    attr :disabled, :boolean, default: false

    def render(assigns) do
      ~H"""
      <.field
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        errors={@errors}
        error_mode={@error_mode}
        used={@used}
        pending={@pending}
        required={@required}
        optional={@optional}
        disabled={@disabled}
        describedby="caller-description shared-description"
        class="consumer-field"
        data-owner="application"
      >
        <:label>Email & account</:label>
        <:control :let={control}>
          <input
            id={control.id}
            name={control.name}
            value={control.value}
            required={control.required}
            disabled={control.disabled}
            aria-describedby={control.aria_describedby}
            aria-invalid={control.aria_invalid}
            data-pending={control.pending}
          />
        </:control>
        <:help>Use a private address.</:help>
      </.field>
      """
    end

    def summary(assigns) do
      ~H"""
      <.error_summary
        id="profile-errors"
        heading="Review <these> fields"
        errors={[
          {"profile_email", "Email <already> exists"},
          {"profile_email", "Email <already> exists"},
          "The form could not be saved"
        ]}
        role="region"
        aria-live="polite"
        class="consumer-summary"
      />
      """
    end

    def fragments(assigns) do
      ~H"""
      <.label id="name-label" for="name" required role="button">Name</.label>
      <.help id="name-help" role="alert">{"Help <text>"}</.help>
      <.field_errors
        ids={["name-error-1", "name-error-2"]}
        errors={["Repeated", "Repeated"]}
        role="alert"
      />
      """
    end
  end

  test "composes deterministic label, control, help, and repeated errors" do
    html =
      render_field(
        id: "profile_email",
        name: "profile[email]",
        value: "ada@example.test",
        errors: ["is invalid", "is invalid"],
        error_mode: :always,
        required: true,
        pending: true
      )

    assert html =~ ~s(id="profile_email-label")
    assert html =~ ~s(for="profile_email")
    assert html =~ ~s(id="profile_email" name="profile[email]")
    assert html =~ ~s(value="ada@example.test")

    assert html =~
             ~s(aria-describedby="caller-description shared-description profile_email-help profile_email-error-1 profile_email-error-2")

    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~s(id="profile_email-help")
    assert html =~ ~s(id="profile_email-error-1")
    assert html =~ ~s(id="profile_email-error-2")
    assert length(Regex.scan(~r/\bis invalid\b/, html)) == 2
    assert html =~ ~s(data-required="true")
    assert html =~ ~s(data-pending="true")
    refute html =~ " disabled"
  end

  test "renders FormField and explicit modes with equivalent semantic identity" do
    explicit =
      render_field(
        id: "account_email",
        name: "account[email]",
        value: "ada@example.test",
        errors: ["is invalid"],
        error_mode: :always
      )

    field = form_field()
    derived = render_field(field: field, error_mode: :always)

    for fragment <- [
          ~s(id="account_email"),
          ~s(name="account[email]"),
          ~s(value="ada@example.test"),
          ~s(for="account_email"),
          ~s(id="account_email-help"),
          ~s(id="account_email-error-1"),
          ~s(aria-invalid="true")
        ] do
      assert explicit =~ fragment
      assert derived =~ fragment
    end
  end

  test "hides errors without dangling invalid or error references" do
    html =
      render_field(
        id: "email",
        name: "email",
        errors: ["Hidden"],
        error_mode: :hidden
      )

    refute html =~ "Hidden"
    refute html =~ "aria-invalid"
    refute html =~ "email-error"
    assert html =~ ~s(aria-describedby="caller-description shared-description email-help")
  end

  test "renders fragments with protected relationships and no default live role" do
    html = render(&Fixture.fragments/1)

    assert html =~ ~s(id="name-label")
    assert html =~ ~s(for="name")
    refute html =~ ~s(for="wrong")
    refute html =~ ~s(role="button")
    assert html =~ "Help &lt;text&gt;"
    assert length(Regex.scan(~r/\bRepeated\b/, html)) == 2
    refute html =~ ~s(role="alert")
  end

  test "renders Error Summary with escaped repeated messages and ordinary links" do
    html = render(&Fixture.summary/1)

    assert html =~ ~s(id="profile-errors")
    assert html =~ ~s(aria-labelledby="profile-errors-heading")
    assert html =~ ~s(role="region")
    assert html =~ ~s(aria-live="polite")
    assert html =~ "Review &lt;these&gt; fields"
    assert length(Regex.scan(~r/href="#profile_email"/, html)) == 2
    assert html =~ ~s(id="profile-errors-summary-1")
    assert html =~ ~s(id="profile-errors-summary-2")
    assert html =~ ~s(id="profile-errors-summary-3")
    assert length(Regex.scan(~r/Email &lt;already&gt; exists/, html)) == 2
    refute html =~ "autofocus"
    refute html =~ "tabindex"
    refute html =~ "<script"
  end

  test "requires coherent relationship input and keeps state presentational" do
    assert_raise ArgumentError, ~r/both required and optional/, fn ->
      render_field(id: "name", name: "name", required: true, optional: true)
    end

    assert_raise ArgumentError, ~r/equal lengths/, fn ->
      assigns = %{ids: ["one"], errors: ["One", "Two"], class: nil, rest: %{}, __changed__: nil}
      assigns |> ShadcnUI.Components.Forms.FieldErrors.field_errors() |> Safe.to_iodata()
    end

    source = File.read!("lib/shadcn_ui/components/forms/field.ex")
    refute source =~ ~r/(handle_event|push_event|Repo\.|Ash\.|Changeset|<script|javascript:)/
  end

  defp render_field(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      used: false,
      pending: false,
      required: false,
      optional: false,
      disabled: false,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render(fun) do
    %{__changed__: nil} |> fun.() |> Safe.to_iodata() |> IO.iodata_to_binary()
  end

  defp form_field do
    form = Phoenix.Component.to_form(%{"email" => "ada@example.test"}, as: "account")
    %FormField{} = field = form[:email]
    %FormField{field | errors: [{"is invalid", []}]}
  end
end
