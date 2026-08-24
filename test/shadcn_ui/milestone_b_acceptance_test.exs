defmodule ShadcnUI.MilestoneBAcceptanceTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.form.normalization shadcn_ui.form.explicit_identity
  # covers: shadcn_ui.form.error_ownership shadcn_ui.form.deterministic_relationships
  # covers: shadcn_ui.form.invalid_state shadcn_ui.form.native_states
  # covers: shadcn_ui.form.protected_globals shadcn_ui.form.pending_snapshot
  # covers: shadcn_ui.form.validation_boundary shadcn_ui.form.native_submission
  # covers: shadcn_ui.forms.field_composition shadcn_ui.forms.field_fragments
  # covers: shadcn_ui.forms.error_summary shadcn_ui.forms.shared_contract
  # covers: shadcn_ui.provenance.pinned_revision shadcn_ui.provenance.component_mapping

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
    attr :translate_error, :any, default: nil
    attr :pending, :boolean, default: false
    attr :required, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :label, :string, default: "Email address"
    attr :help, :string, default: "We use this only for account notices."

    def one_field(assigns) do
      ~H"""
      <.field
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        errors={@errors}
        error_mode={@error_mode}
        used={@used}
        translate_error={@translate_error}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        describedby="application-description application-description"
        data-owner="application"
      >
        <:label>{@label}</:label>
        <:control :let={control}>
          <input
            id={control.id}
            name={control.name}
            value={control.value}
            required={control.required}
            disabled={control.disabled}
            aria-describedby={control.aria_describedby}
            aria-invalid={control.aria_invalid}
            data-pending={control.pending && "true"}
            autocomplete="email"
          />
        </:control>
        <:help>{@help}</:help>
      </.field>
      """
    end

    def composition(assigns) do
      ~H"""
      <div class="sui:grid sui:max-w-full sui:gap-6" data-shadcn-theme="light">
        <.error_summary
          id="settings-errors"
          heading="Please review the highlighted settings"
          errors={[
            {"settings_email", "Email is not available"},
            {"settings_locale", "Choisissez une langue prise en charge"},
            {"settings_locale", "Choisissez une langue prise en charge"}
          ]}
        />

        <.field
          id="settings_email"
          name="settings[email]"
          value="long-address@example.test"
          errors={["Email is not available"]}
          error_mode={:always}
          required
        >
          <:label>
            A deliberately long account email label that wraps at narrow viewport widths
          </:label>
          <:control :let={control}>
            <input
              id={control.id}
              name={control.name}
              value={control.value}
              required={control.required}
              aria-describedby={control.aria_describedby}
              aria-invalid={control.aria_invalid}
            />
          </:control>
          <:help>Long translated guidance remains visible and associated with this control.</:help>
        </.field>

        <div data-shadcn-theme="dark">
          <.field
            id="settings_locale"
            name="settings[locale]"
            value="fr-CA"
            errors={[
              "Choisissez une langue prise en charge",
              "Choisissez une langue prise en charge"
            ]}
            error_mode={:always}
            pending
          >
            <:label>Langue préférée pour les communications très détaillées</:label>
            <:control :let={control}>
              <input
                id={control.id}
                name={control.name}
                value={control.value}
                aria-describedby={control.aria_describedby}
                aria-invalid={control.aria_invalid}
              />
            </:control>
            <:help>La sélection demeure sous le contrôle de l’application.</:help>
          </.field>
        </div>
      </div>
      """
    end
  end

  test "explicit and FormField inputs render the same semantic field snapshot" do
    raw_error = {"must contain at least %{count} characters", count: 8}
    field = form_field(%{"email" => "ada@example.test"}, [raw_error])

    explicit =
      render_one(
        id: "account_email",
        name: "account[email]",
        value: "ada@example.test",
        errors: ["must contain at least 8 characters"],
        error_mode: :always,
        required: true
      )

    derived = render_one(field: field, error_mode: :always, required: true)

    assert explicit == derived
    assert explicit =~ ~s(id="account_email")
    assert explicit =~ ~s(name="account[email]")
    assert explicit =~ ~s(aria-invalid="true")
    assert explicit =~ "must contain at least 8 characters"
  end

  test "used-input, always, and hidden policies preserve escaped translated errors" do
    pristine = form_field(%{}, [{"invalid %{kind}", kind: "<address>"}])
    used = form_field(%{"email" => "bad"}, [{"invalid %{kind}", kind: "<address>"}])

    refute render_one(field: pristine, error_mode: :used_input) =~ "invalid"

    used_html = render_one(field: used, error_mode: :used_input)
    assert used_html =~ "invalid &lt;address&gt;"
    refute used_html =~ "<address>"

    translated =
      render_one(
        field: pristine,
        error_mode: :always,
        translate_error: fn _error -> "Adresse <invalide>" end
      )

    assert translated =~ "Adresse &lt;invalide&gt;"
    refute translated =~ "<invalide>"

    hidden = render_one(field: used, error_mode: :hidden)
    refute hidden =~ "invalid"
    refute hidden =~ "aria-invalid"
    refute hidden =~ "account_email-error"
  end

  test "server rerenders keep relationship order and atom count stable" do
    options = [
      id: "profile_email",
      name: "profile[email]",
      value: "ada@example.test",
      errors: ["Repeated", "Repeated"],
      error_mode: :always,
      pending: true
    ]

    first = render_one(options)
    assert first == render_one(options)

    assert first =~
             ~s(aria-describedby="application-description profile_email-help profile_email-error-1 profile_email-error-2")

    for index <- 1..20 do
      render_one(id: "warmup-#{index}", name: "warmup[#{index}]", value: index)
    end

    before_count = :erlang.system_info(:atom_count)

    for index <- 1..250 do
      render_one(id: "request-#{index}", name: "request[#{index}]", value: index)
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  test "multiple fields and one summary have complete unique fragment relationships" do
    html = render(&Fixture.composition/1)

    ids = Regex.scan(~r/\sid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()

    references =
      Regex.scan(~r/(?:for|href|aria-labelledby)="\#?([^"]+)"/, html, capture: :all_but_first)
      |> List.flatten()

    describedby =
      Regex.scan(~r/aria-describedby="([^"]+)"/, html, capture: :all_but_first)
      |> List.flatten()
      |> Enum.flat_map(&String.split/1)

    assert length(ids) == length(Enum.uniq(ids))
    assert Enum.all?(references ++ describedby, &(&1 in ids))
    assert length(Regex.scan(~r/Choisissez une langue prise en charge/, html)) == 4
    assert html =~ ~s(href="#settings_email")
    assert length(Regex.scan(~r/href="#settings_locale"/, html)) == 2
  end

  test "content stress, themes, and forced-colors evidence stay semantic" do
    html = render(&Fixture.composition/1)
    source_css = File.read!("assets/shadcn_ui.css")
    compiled_css = File.read!(ShadcnUI.stylesheet_path())

    assert html =~ ~s(data-shadcn-theme="light")
    assert html =~ ~s(data-shadcn-theme="dark")
    assert html =~ "sui:break-words"
    assert html =~ "sui:max-w-full"
    assert html =~ "Langue préférée"
    assert source_css =~ "@media (forced-colors: active)"
    assert source_css =~ "[data-shadcn-ui-field-error]"
    assert compiled_css =~ "data-shadcn-ui-field-error"
  end

  test "phase components expose no application behavior or runtime dependency" do
    runtime_source =
      "lib/shadcn_ui/components/forms/*.ex"
      |> Path.wildcard()
      |> Enum.map_join("\n", &File.read!/1)

    dependencies =
      Mix.Project.config()
      |> Keyword.fetch!(:deps)
      |> Enum.map(&elem(&1, 0))

    assert dependencies == [:phoenix_html, :phoenix_live_view, :ex_doc, :spec_led_ex]

    refute runtime_source =~
             ~r/(Ecto|Gettext|Dstar|Datastar|Ash\.|Electron|Repo\.|handle_event|push_event|System\.cmd|GenServer|Task\.|<script|javascript:)/

    rendered = render(&Fixture.composition/1)
    refute rendered =~ ~r/(autofocus|scrollIntoView|window\.|document\.)/

    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))

    assert Enum.any?(provenance["adaptations"], fn adaptation ->
             adaptation["id"] == "forms.label" and
               adaptation["localPaths"] == ["lib/shadcn_ui/components/forms/label.ex"]
           end)
  end

  defp render_one(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      used: false,
      translate_error: nil,
      pending: false,
      required: false,
      disabled: false,
      label: "Email address",
      help: "We use this only for account notices.",
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.one_field()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render(fun) do
    %{__changed__: nil} |> fun.() |> Safe.to_iodata() |> IO.iodata_to_binary()
  end

  defp form_field(params, errors) do
    form = Phoenix.Component.to_form(params, as: "account")
    %FormField{} = field = form[:email]
    %FormField{field | id: "account_email", name: "account[email]", errors: errors}
  end
end
