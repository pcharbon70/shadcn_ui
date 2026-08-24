defmodule ShadcnUI.Forms.FormContractTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe
  alias ShadcnUI.Components.Forms.FormContract

  # covers: shadcn_ui.form.normalization shadcn_ui.form.explicit_identity
  # covers: shadcn_ui.form.error_ownership shadcn_ui.form.pending_snapshot
  # covers: shadcn_ui.form.validation_boundary

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
