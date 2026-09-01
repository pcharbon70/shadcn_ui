defmodule ShadcnUI.Forms.FormContractTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe
  alias ShadcnUI.Components.Forms.FormContract

  # covers: shadcn_ui.form.normalization shadcn_ui.form.explicit_identity
  # covers: shadcn_ui.form.error_ownership shadcn_ui.form.pending_snapshot
  # covers: shadcn_ui.form.validation_boundary shadcn_ui.form.deterministic_relationships
  # covers: shadcn_ui.form.invalid_state shadcn_ui.form.protected_globals
  # covers: shadcn_ui.form.native_states shadcn_ui.form.native_submission

  defmodule EscapeFixture do
    use Phoenix.Component

    attr :id, :string, required: true
    attr :name, :string, required: true
    attr :value, :any, required: true
    attr :errors, :list, required: true

    def render(assigns) do
      ~H"""
      <input id={@id} name={@name} value={@value} />
      <p :for={error <- @errors}>{error}</p>
      """
    end
  end

  test "normalizes FormField defaults and explicit values with stable precedence" do
    field = form_field(params: %{"email" => "field@example.test"})

    derived = FormContract.normalize!(field: field, error_mode: :always)

    assert derived.id == "account_email"
    assert derived.name == "account[email]"
    assert derived.value == "field@example.test"
    assert derived.errors == ["must be at least 8 characters"]

    explicit =
      FormContract.normalize!(
        field: field,
        id: "invite_email",
        name: "invite[email]",
        value: "explicit@example.test",
        errors: ["Already invited"],
        error_mode: :always
      )

    assert explicit.id == "invite_email"
    assert explicit.name == "invite[email]"
    assert explicit.value == "explicit@example.test"
    assert explicit.errors == ["Already invited"]
  end

  test "requires nonblank explicit or derived submitted identity" do
    for options <- [[], [id: "", name: "profile[name]"], [id: "profile_name", name: "  "]] do
      assert_raise ArgumentError, ~r/normalized (id|name) must be a nonblank string/, fn ->
        FormContract.normalize!(options)
      end
    end
  end

  test "uses closed caller-owned error visibility without inferring submission" do
    pristine = form_field(params: %{})
    used = form_field(params: %{"email" => "taken@example.test"})

    refute FormContract.normalize!(field: pristine).errors_visible?
    assert FormContract.normalize!(field: used).errors_visible?
    assert FormContract.normalize!(field: pristine, error_mode: :always).errors_visible?
    refute FormContract.normalize!(field: used, error_mode: :hidden).errors_visible?

    refute FormContract.normalize!(
             id: "explicit",
             name: "explicit",
             errors: ["Invalid"],
             error_mode: :used_input
           ).errors_visible?

    assert FormContract.normalize!(
             id: "explicit",
             name: "explicit",
             errors: ["Invalid"],
             error_mode: :used_input,
             used: true
           ).errors_visible?

    assert_raise ArgumentError, ~r/error_mode must be one of/, fn ->
      FormContract.normalize!(field: used, error_mode: :submitted)
    end
  end

  test "translates raw field tuples or interpolates them deterministically" do
    field = form_field(errors: [{"must be at least %{count} characters", count: 8}])

    assert FormContract.normalize!(field: field, error_mode: :always).errors ==
             ["must be at least 8 characters"]

    translated =
      FormContract.normalize!(
        field: field,
        error_mode: :always,
        translate_error: fn {message, options} ->
          "translated: #{String.replace(message, "%{count}", to_string(options[:count]))}"
        end
      )

    assert translated.errors == ["translated: must be at least 8 characters"]

    assert_raise ArgumentError, ~r/explicit errors must be strings/, fn ->
      FormContract.normalize!(
        id: "email",
        name: "email",
        errors: [{"raw", []}],
        error_mode: :always
      )
    end
  end

  test "preserves caller values and escapes them only when HEEx renders markup" do
    normalized =
      FormContract.normalize!(
        id: "profile_email",
        name: "profile[email]",
        value: ~s(<unsafe value="yes">),
        errors: ["Use <another> address"],
        error_mode: :always
      )

    assert normalized.value == ~s(<unsafe value="yes">)
    assert normalized.errors == ["Use <another> address"]

    html =
      normalized
      |> Map.from_struct()
      |> Map.put(:__changed__, nil)
      |> EscapeFixture.render()
      |> Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "&lt;unsafe value=&quot;yes&quot;&gt;"
    assert html =~ "Use &lt;another&gt; address"
    refute html =~ "<unsafe"
    refute html =~ "<another>"
  end

  test "pending is presentation data and normalization is deterministic without atom growth" do
    options = [
      id: "profile_name",
      name: "profile[name]",
      value: "Ada",
      errors: ["Review required"],
      error_mode: :always,
      pending: true
    ]

    assert FormContract.normalize!(options) == FormContract.normalize!(options)
    assert FormContract.normalize!(options).pending?

    FormContract.normalize!(options)
    before_count = :erlang.system_info(:atom_count)

    for index <- 1..500 do
      FormContract.normalize!(
        id: "field-#{index}",
        name: "form[field-#{index}]",
        value: "value-#{index}"
      )
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  test "normalization has no validation, persistence, event, or request side effect" do
    source = File.read!("lib/shadcn_ui/components/forms/form_contract.ex")

    refute source =~
             ~r/(Ecto\.Changeset|Repo\.|Ash\.|HTTP|Req\.|Finch|push_event|handle_event|send\(|GenServer|Task\.)/

    normalized =
      FormContract.normalize!(
        id: "operation",
        name: "operation",
        errors: ["Server rejected this value"],
        error_mode: :always,
        pending: true
      )

    assert normalized.errors_visible?
    assert normalized.pending?
  end

  test "derives stable label, help, repeated-error, summary, and option IDs" do
    normalized =
      FormContract.normalize!(
        id: "profile_language",
        name: "profile[language]",
        errors: ["is unavailable", "is unavailable"],
        error_mode: :always
      )

    first = FormContract.relationships(normalized, help: true)
    second = FormContract.relationships(normalized, help: true)

    assert first == second
    assert first.label_id == "profile_language-label"
    assert first.help_id == "profile_language-help"

    assert first.error_ids == [
             "profile_language-error-1",
             "profile_language-error-2"
           ]

    assert FormContract.summary_item_id("profile_language", 2) ==
             "profile_language-summary-2"

    string_id = FormContract.option_id("profile_language", "north america/fr")
    atom_id = FormContract.option_id("profile_language", :north_america_fr)
    integer_id = FormContract.option_id("profile_language", 42)

    assert string_id =~ ~r/^profile_language-option-[A-Za-z0-9_-]+$/
    assert Enum.uniq([string_id, atom_id, integer_id]) |> length() == 3
    refute string_id =~ "north america"
  end

  test "assembles ordered distinct descriptions and visible invalid relationships" do
    visible =
      FormContract.normalize!(
        id: "email",
        name: "email",
        errors: ["Invalid", "Invalid"],
        error_mode: :always
      )

    relationships =
      FormContract.relationships(visible,
        help: true,
        describedby: ["caller-one caller-two", "caller-one", nil]
      )

    assert relationships.describedby ==
             "caller-one caller-two email-help email-error-1 email-error-2"

    assert relationships.aria_invalid == "true"

    hidden =
      visible
      |> Map.put(:errors, [])
      |> Map.put(:errors_visible?, false)
      |> FormContract.relationships(describedby: "caller-only")

    assert hidden.describedby == "caller-only"
    assert hidden.aria_invalid == false
    assert hidden.error_ids == []
  end

  test "protects relationship semantics while retaining unrelated caller globals" do
    globals = %{
      "id" => "wrong-id",
      "name" => "wrong-name",
      "for" => "wrong-target",
      "type" => "button",
      "role" => "combobox",
      "aria-invalid" => "false",
      "aria-describedby" => "wrong-description",
      "disabled" => true,
      "class" => "consumer-class",
      "autocomplete" => "email",
      "aria-label" => "Email",
      "data-state" => "ready",
      "phx-change" => "validate",
      "data-on:change" => "$validate()"
    }

    safe = FormContract.protect_control_globals(globals, [:disabled])

    assert safe == %{
             "class" => "consumer-class",
             "autocomplete" => "email",
             "aria-label" => "Email",
             "data-state" => "ready",
             "phx-change" => "validate",
             "data-on:change" => "$validate()"
           }
  end

  test "rejects unstable relationship inputs without creating atoms" do
    assert_raise ArgumentError, ~r/positive integer/, fn ->
      FormContract.error_id("email", 0)
    end

    assert_raise ArgumentError, ~r/stable strings, atoms, or integers/, fn ->
      FormContract.option_id("email", %{request: "derived"})
    end

    before_count = :erlang.system_info(:atom_count)

    for index <- 1..500 do
      FormContract.option_id("choice", "request-key-#{index}")
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  defp form_field(options) do
    params = Keyword.get(options, :params, %{})
    value = Map.get(params, "email", "field@example.test")

    form = Phoenix.Component.to_form(params, as: "account")
    %FormField{} = email_field = form[:email]

    %FormField{
      email_field
      | id: "account_email",
        name: "account[email]",
        value: value,
        errors:
          Keyword.get(options, :errors, [{"must be at least %{count} characters", count: 8}])
    }
  end
end
