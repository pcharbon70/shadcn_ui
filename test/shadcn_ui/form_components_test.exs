defmodule ShadcnUI.FormComponentsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.field_composition shadcn_ui.forms.field_fragments
  # covers: shadcn_ui.forms.error_summary shadcn_ui.forms.input
  # covers: shadcn_ui.forms.textarea shadcn_ui.forms.checkbox
  # covers: shadcn_ui.forms.radio_group shadcn_ui.forms.switch
  # covers: shadcn_ui.forms.native_select shadcn_ui.forms.enhanced_select
  # covers: shadcn_ui.forms.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr(:form, :any, required: true)

    def form_field_profile(assigns) do
      ~H"""
      <form method="post" action="/profiles" data-fixture="form-field">
        <.input
          field={@form[:email]}
          type="email"
          autocomplete="email"
          minlength={3}
          maxlength={120}
          required
          pending
        >
          <:label>Email address</:label>

          <:help>Used for account notices.</:help>
        </.input>

        <.textarea
          field={@form[:biography]}
          rows={5}
          minlength={10}
          maxlength={1_000}
          resize={:vertical}
          sizing={:content}
        >
          <:label>Biography</:label>

          <:help>A short description of your role.</:help>
        </.textarea>
        <button type="submit">Save profile</button>
      </form>
      """
    end

    def explicit_profile(assigns) do
      ~H"""
      <form method="post" action="/profiles" data-fixture="explicit">
        <.error_summary
          id="profile-errors"
          heading="Please review the profile"
          errors={[
            {"profile_email", "Email is already registered"},
            {"profile_biography", "Biography is too short"}
          ]}
        />
        <.input
          id="profile_email"
          name="profile[email]"
          value="ada@example.test"
          errors={["Email is already registered"]}
          error_mode={:always}
          type="email"
          required
          readonly
          describedby="profile-introduction"
        >
          <:label>Email address</:label>

          <:help>Used for account notices.</:help>
        </.input>

        <.textarea
          id="profile_biography"
          name="profile[biography]"
          value="First line\nSecond <line>"
          errors={["Biography is too short", "Biography is too short"]}
          error_mode={:always}
          rows={4}
          maxlength={1_000}
          resize={:fixed}
          disabled
        >
          <:label>Biography</:label>

          <:help>A short description of your role.</:help>
        </.textarea>
        <button type="submit">Save profile</button>
      </form>
      """
    end

    attr(:form, :any, required: true)

    def choice_settings(assigns) do
      assigns =
        assign(assigns, :contact_options, [
          %{key: "email", value: "email", label: "Courriel détaillé pour les communications"},
          %{key: "phone", value: "phone", label: "Telephone"},
          %{key: "postal", value: "postal", label: "Courrier postal", disabled: true}
        ])

      ~H"""
      <form method="post" action="/settings" data-fixture="native-choices">
        <.error_summary
          id="settings-errors"
          heading="Review these settings"
          errors={[
            {"settings_reports", "Choose whether reports are enabled"},
            {"settings_contact", "Choose a contact method"}
          ]}
        />

        <.input field={@form[:email]} type="email" required>
          <:label>Email address</:label>
        </.input>

        <.checkbox
          field={@form[:reports]}
          checked_value="enabled"
          unchecked_value="disabled"
          errors={["Choose whether reports are enabled"]}
          error_mode={:always}
        >
          <:label>Enable scheduled reports</:label>
          <:help>Space changes this native checkbox.</:help>
        </.checkbox>

        <.checkbox
          id="settings_feature_exports"
          name="settings[features]"
          mode={:multiple}
          value="exports"
          checked
        >
          <:label>Exports</:label>
        </.checkbox>

        <.checkbox
          id="settings_feature_audit"
          name="settings[features]"
          mode={:multiple}
          value="audit"
          checked
        >
          <:label>Audit history</:label>
        </.checkbox>

        <.checkbox
          id="settings_feature_beta"
          name="settings[features]"
          mode={:multiple}
          value="beta"
        >
          <:label>Beta access</:label>
        </.checkbox>

        <.switch field={@form[:notifications]}>
          <:label>Email notifications</:label>
          <:help>Uses the same native checkbox value contract.</:help>
        </.switch>

        <.radio_group
          field={@form[:contact]}
          options={@contact_options}
          errors={["Choose a contact method", "Choose a contact method"]}
          error_mode={:always}
          required
        >
          <:legend>Preferred contact method with a deliberately long translated label</:legend>
          <:help>Arrow keys and Space retain native radio behavior.</:help>
        </.radio_group>

        <.button type="submit">Save settings</.button>
        <.button type="reset" variant={:outline}>Reset settings</.button>
      </form>
      """
    end

    attr(:form, :any, required: true)

    def select_profile(assigns) do
      assigns =
        assign(assigns, :country_options, [
          %{key: :prompt, value: "", label: "Choose a country", disabled: true},
          %{
            key: :north_america,
            label: "North America",
            options: [
              %{key: :ca, value: "ca", label: "Canada"},
              %{key: :us, value: "us", label: "United States"}
            ]
          },
          %{
            key: :europe,
            label: "Europe",
            options: [
              %{key: :fr, value: "fr", label: "France"},
              %{key: :de, value: "de", label: "Germany"}
            ]
          }
        ])

      ~H"""
      <form method="post" action="/profiles" data-fixture="native-selects">
        <.error_summary
          id="profile-select-errors"
          heading="Review these selections"
          errors={[{"profile_country", "Choose an available country"}]}
        />

        <.native_select
          field={@form[:country]}
          options={@country_options}
          errors={["Choose an available country"]}
          error_mode={:always}
          required
        >
          <:label>Country</:label>
          <:help>The classic browser picker is the recommended default.</:help>
        </.native_select>

        <.enhanced_select field={@form[:timezone]} options={@country_options} pending>
          <:label>Timezone reference country</:label>
          <:help>The same native value may receive enhanced presentation.</:help>
        </.enhanced_select>

        <.enhanced_select
          field={@form[:regions]}
          options={@country_options}
          multiple
          disabled={false}
        >
          <:label>Operational regions</:label>
          <:help>Multiple values retain the native list presentation.</:help>
        </.enhanced_select>

        <.button type="submit">Save selections</.button>
        <.button type="reset" variant={:outline}>Reset selections</.button>
      </form>
      """
    end
  end

  test "ordinary FormField controls retain native names, values, constraints, and order" do
    form =
      Phoenix.Component.to_form(
        %{
          "email" => "ada@example.test",
          "biography" => "First line\nSecond line"
        },
        as: "profile"
      )

    html = render(&Fixture.form_field_profile/1, %{form: form})

    assert html =~ ~s(<form method="post" action="/profiles")
    assert html =~ ~s(id="profile_email")
    assert html =~ ~s(name="profile[email]")
    assert html =~ ~s(value="ada@example.test")
    assert html =~ ~s(type="email")
    assert html =~ ~s(minlength="3")
    assert html =~ ~s(maxlength="120")
    assert html =~ " required"
    refute html =~ " disabled"
    assert html =~ ~s(name="profile[biography]")
    assert html =~ ">First line\nSecond line</textarea>"
    assert html =~ ~s(rows="5")
    assert html =~ ~s(data-sizing="content")
    assert position(html, "<input") < position(html, "<textarea")
    assert position(html, "<textarea") < position(html, ~s(<button type="submit"))
    refute html =~ ~s(type="hidden")

    submitted =
      URI.decode_query(
        URI.encode_query(%{
          "profile[email]" => "ada@example.test",
          "profile[biography]" => "First line\nSecond line"
        })
      )

    assert submitted["profile[email]"] == "ada@example.test"
    assert submitted["profile[biography]"] == "First line\nSecond line"
  end

  test "explicit controls preserve deterministic labels, descriptions, errors, and states" do
    html = render(&Fixture.explicit_profile/1)

    assert html =~ ~s(for="profile_email")
    assert html =~ ~s(for="profile_biography")

    assert html =~
             ~s(aria-describedby="profile-introduction profile_email-help profile_email-error-1")

    assert html =~
             ~s(aria-describedby="profile_biography-help profile_biography-error-1 profile_biography-error-2")

    assert html =~ ~s(aria-invalid="true")
    assert html =~ " readonly"
    assert html =~ " disabled"
    assert html =~ "First line"
    assert html =~ "Second &lt;line&gt;"
    refute html =~ "Second <line>"
    assert length(Regex.scan(~r/Biography is too short/, html)) == 3
    assert html =~ ~s(href="#profile_email")
    assert html =~ ~s(href="#profile_biography")
  end

  test "rendered controls remain native and free of package-owned behavior" do
    form = Phoenix.Component.to_form(%{"email" => "", "biography" => ""}, as: "profile")
    html = render(&Fixture.form_field_profile/1, %{form: form})

    assert html =~ "<input"
    assert html =~ "<textarea"
    refute html =~ ~r/(phx-hook|data-on:|<script|javascript:|role="textbox"|contenteditable)/
    refute html =~ ~r/(counter|reveal|auto-grow|scroll-height|hidden synchronized)/i

    source =
      [
        "lib/shadcn_ui/components/forms/input.ex",
        "lib/shadcn_ui/components/forms/textarea.ex"
      ]
      |> Enum.map_join("\n", &File.read!/1)

    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|scrollHeight)/
  end

  test "focus, themes, constrained layout, and forced-colors evidence remain visible" do
    form = Phoenix.Component.to_form(%{"email" => "", "biography" => ""}, as: "profile")
    html = render(&Fixture.form_field_profile/1, %{form: form})
    source_css = File.read!("assets/shadcn_ui.css")
    compiled_css = File.read!(ShadcnUI.stylesheet_path())

    assert html =~ "sui:min-w-0"
    assert html =~ "sui:focus-visible:ring-2"
    assert html =~ "sui:focus-visible:ring-offset-background"
    assert html =~ "sui:bg-background"
    assert html =~ "sui:text-foreground"
    assert html =~ "sui:min-h-24"
    assert source_css =~ "@media (forced-colors: active)"
    assert source_css =~ ~s([data-shadcn-ui-textarea][aria-invalid="true"])
    assert compiled_css =~ "data-shadcn-ui-textarea"
  end

  test "complete native choice form preserves boolean, repeated, and scalar submission contracts" do
    form =
      Phoenix.Component.to_form(
        %{
          "email" => "ada@example.test",
          "reports" => "enabled",
          "notifications" => "false",
          "contact" => "phone"
        },
        as: "settings"
      )

    html = render(&Fixture.choice_settings/1, %{form: form})

    assert html =~ ~s(<form method="post" action="/settings")
    assert html =~ ~s(type="email")
    assert length(Regex.scan(~r/type="checkbox"/, html)) == 5
    assert length(Regex.scan(~r/type="radio"/, html)) == 3
    assert length(Regex.scan(~r/type="hidden"/, html)) == 2
    assert length(Regex.scan(~r/name="settings\[reports\]"/, html)) == 2
    assert length(Regex.scan(~r/name="settings\[notifications\]"/, html)) == 2
    assert length(Regex.scan(~r/name="settings\[features\]\[\]"/, html)) == 3
    assert length(Regex.scan(~r/name="settings\[contact\]"/, html)) == 3
    assert html =~ ~s(value="phone" checked)
    assert html =~ ~s(value="exports" checked)
    assert html =~ ~s(value="audit" checked)
    refute html =~ ~s(value="beta" checked)
    assert html =~ ~r/<button[^>]*type="submit"/
    assert html =~ ~r/<button[^>]*type="reset"/

    submitted = %{
      "settings[email]" => "ada@example.test",
      "settings[reports]" => "enabled",
      "settings[notifications]" => "false",
      "settings[features][]" => ["exports", "audit"],
      "settings[contact]" => "phone"
    }

    assert submitted["settings[reports]"] == "enabled"
    assert submitted["settings[notifications]"] == "false"
    assert submitted["settings[features][]"] == ["exports", "audit"]
    assert submitted["settings[contact]"] == "phone"
  end

  test "choice composition keeps native labels, grouping, errors, order, and no-script behavior" do
    form =
      Phoenix.Component.to_form(
        %{"email" => "", "reports" => false, "notifications" => true, "contact" => nil},
        as: "settings"
      )

    html = render(&Fixture.choice_settings/1, %{form: form})

    assert html =~ ~s(for="settings_reports")
    assert html =~ ~s(for="settings_notifications")
    assert html =~ ~s(<fieldset)
    assert html =~ ~s(<legend id="settings_contact-label")
    assert html =~ ~s(aria-labelledby="settings_contact-label")
    assert html =~ ~s(id="settings_contact-error-1")
    assert html =~ ~s(id="settings_contact-error-2")
    assert html =~ ~s(aria-invalid="true")
    assert html =~ "Courriel détaillé"

    assert position(html, ~s(name="settings[reports]" value="disabled")) <
             position(html, ~s(type="checkbox" id="settings_reports"))

    assert position(html, ~s(type="email")) < position(html, ~s(type="checkbox"))
    assert position(html, ~s(type="checkbox")) < position(html, ~s(type="radio"))
    assert position(html, ~s(type="radio")) < position(html, ~s(type="submit"))

    refute html =~ ~r/(phx-hook|data-on:|<script|javascript:|role="switch"|role="radio")/
    refute html =~ ~r/(contenteditable|hidden synchronized|mirrored checked)/i
  end

  test "complete select form preserves scalar and repeated native submission contracts" do
    form =
      Phoenix.Component.to_form(
        %{"country" => "ca", "timezone" => "fr", "regions" => ["ca", "de"]},
        as: "profile"
      )

    html = render(&Fixture.select_profile/1, %{form: form})

    assert html =~ ~s(<form method="post" action="/profiles")
    assert length(Regex.scan(~r/<select\b/, html)) == 3
    assert length(Regex.scan(~r/data-shadcn-ui-enhanced-select="true"/, html)) == 2
    assert length(Regex.scan(~r/<selectedcontent>/, html)) == 1
    assert html =~ ~s(name="profile[country]")
    assert html =~ ~s(name="profile[timezone]")
    assert html =~ ~s(name="profile[regions][]")
    assert html =~ ~s(value="ca" selected)
    assert html =~ ~s(value="fr" selected)
    assert html =~ ~s(value="de" selected)
    assert html =~ ~s(href="#profile_country")
    assert html =~ ~s(aria-describedby="profile_country-help profile_country-error-1")
    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~r/<button[^>]*type="submit"/
    assert html =~ ~r/<button[^>]*type="reset"/

    submitted = %{
      "profile[country]" => "ca",
      "profile[timezone]" => "fr",
      "profile[regions][]" => ["ca", "de"]
    }

    assert submitted["profile[country]"] == "ca"
    assert submitted["profile[timezone]"] == "fr"
    assert submitted["profile[regions][]"] == ["ca", "de"]
  end

  test "native and enhanced select composition keeps one control per value and no widget runtime" do
    form =
      Phoenix.Component.to_form(
        %{"country" => "", "timezone" => "ca", "regions" => []},
        as: "profile"
      )

    html = render(&Fixture.select_profile/1, %{form: form})

    assert position(html, ~s(name="profile[country]")) <
             position(html, ~s(name="profile[timezone]"))

    assert position(html, ~s(name="profile[timezone]")) <
             position(html, ~s(name="profile[regions][]"))

    assert length(Regex.scan(~r/name="profile\[country\]"/, html)) == 1
    assert length(Regex.scan(~r/name="profile\[timezone\]"/, html)) == 1
    assert length(Regex.scan(~r/name="profile\[regions\]\[\]"/, html)) == 1
    refute html =~ ~s(type="hidden")
    refute html =~ ~r/role="(?:combobox|listbox|option)"/
    refute html =~ ~r/(phx-hook|data-on:|<script|javascript:)/
  end

  defp render(fun, assigns \\ %{}) do
    assigns
    |> Map.put(:__changed__, nil)
    |> fun.()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp position(html, pattern) do
    {index, _length} = :binary.match(html, pattern)
    index
  end
end
