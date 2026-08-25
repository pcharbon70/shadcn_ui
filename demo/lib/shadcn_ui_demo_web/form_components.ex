defmodule ShadcnUIDemoWeb.FormComponents do
  use Phoenix.Component
  use ShadcnUI

  attr :kind, :atom, values: [:sign_in, :profile, :settings], required: true
  attr :form, :any, required: true
  attr :submittable, :boolean, default: true

  def composition(%{kind: :sign_in} = assigns) do
    ~H"""
    <.card>
      <:title>Sign-in form composition</:title><:description>
        Fixture data only; no authentication occurs.
      </:description>
      <.form
        for={@form}
        action={@submittable && "/forms/submit"}
        method={if(@submittable, do: "post", else: "get")}
        data-demo-form="sign-in"
      >
        <input type="hidden" name="demo[kind]" value="sign-in" />
        <.input
          field={@form[:email]}
          type="email"
          autocomplete="email"
          errors={["Use the demonstration account"]}
          error_mode={:always}
          required
        >
          <:label>Email address</:label>
        </.input>
        <.input
          field={@form[:password]}
          type="password"
          autocomplete="current-password"
          required
          pending
        >
          <:label>Password</:label><:help>Pending is a presentation snapshot only.</:help>
        </.input>
        <.checkbox field={@form[:remember]}>
          <:label>Remember this demonstration choice</:label>
        </.checkbox>
        <.button type="submit" disabled={!@submittable}>Inspect submitted values</.button>
      </.form>
    </.card>
    """
  end

  def composition(%{kind: :profile} = assigns) do
    assigns = assign(assigns, :countries, countries()) |> assign(:contacts, contacts())

    ~H"""
    <.card>
      <:title>Profile form composition</:title><:description>
        Repeated server errors and caller-owned FormFields.
      </:description>
      <.form
        for={@form}
        action={@submittable && "/forms/submit"}
        method={if(@submittable, do: "post", else: "get")}
        data-demo-form="profile"
      >
        <input type="hidden" name="demo[kind]" value="profile" />
        <.error_summary
          id="profile-errors"
          heading="Review the profile fixture"
          errors={[
            {"demo_name", "Enter a display name"},
            {"demo_notes", "Notes need more detail"},
            {"demo_notes", "Notes need more detail"}
          ]}
        />
        <.input field={@form[:name]} errors={["Enter a display name"]} error_mode={:always} required>
          <:label>A deliberately long display name label for narrow and translated layouts</:label>
        </.input>
        <.textarea
          field={@form[:notes]}
          errors={["Notes need more detail", "Notes need more detail"]}
          error_mode={:always}
          sizing={:content}
        >
          <:label>Profile notes</:label>
        </.textarea>
        <.native_select field={@form[:country]} options={@countries}>
          <:label>Country</:label>
        </.native_select>
        <.radio_group field={@form[:contact]} options={@contacts}>
          <:legend>Preferred contact method</:legend>
        </.radio_group>
        <.slider field={@form[:volume]} min={0} max={100} step={10}>
          <:label>Notification volume</:label>
        </.slider>
        <.button type="submit" disabled={!@submittable}>Inspect submitted values</.button><.button
          type="reset"
          variant={:outline}
        >Reset</.button>
      </.form>
    </.card>
    """
  end

  def composition(%{kind: :settings} = assigns) do
    assigns = assign(assigns, :countries, countries())

    ~H"""
    <.card>
      <:title>Settings form composition</:title><:description>
        Native settings values plus caller-owned task and measurement snapshots.
      </:description>
      <.form
        for={@form}
        action={@submittable && "/forms/submit"}
        method={if(@submittable, do: "post", else: "get")}
        data-demo-form="settings"
      >
        <input type="hidden" name="demo[kind]" value="settings" />
        <.switch field={@form[:alerts]}>
          <:label>Operational alerts</:label>
        </.switch>
        <.checkbox
          id="demo_feature_exports"
          name="demo[features]"
          mode={:multiple}
          value="exports"
          checked
        >
          <:label>Exports</:label>
        </.checkbox>
        <.checkbox
          id="demo_feature_audit"
          name="demo[features]"
          mode={:multiple}
          value="audit"
          checked
        >
          <:label>Audit history</:label>
        </.checkbox>
        <.checkbox id="demo_feature_beta" name="demo[features]" mode={:multiple} value="beta" disabled>
          <:label>Unavailable beta access</:label>
        </.checkbox>
        <.enhanced_select field={@form[:country]} options={@countries}>
          <:label>Account country</:label>
        </.enhanced_select>
        <.input field={@form[:account]} readonly>
          <:label>Readonly account identifier</:label>
        </.input>
        <.progress id="settings-progress" value={4} max={10}>
          <:label>Settings review task</:label>
        </.progress>
        <.meter id="settings-meter" value={72} min={0} max={100} low={60} high={85} optimum={40}>
          <:label>Storage use measurement</:label>
        </.meter>
        <.button type="submit" disabled={!@submittable}>Inspect submitted values</.button>
      </.form>
    </.card>
    """
  end

  defp countries,
    do: [
      %{key: :prompt, value: "", label: "Choose", disabled: true},
      %{key: :ca, value: "ca", label: "Canada"},
      %{key: :us, value: "us", label: "United States"}
    ]

  defp contacts,
    do: [
      %{key: :email, value: "email", label: "Email"},
      %{key: :phone, value: "phone", label: "Phone"}
    ]
end
