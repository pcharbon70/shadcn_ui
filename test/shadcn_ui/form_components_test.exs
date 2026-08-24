defmodule ShadcnUI.FormComponentsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.field_composition shadcn_ui.forms.field_fragments
  # covers: shadcn_ui.forms.error_summary shadcn_ui.forms.input
  # covers: shadcn_ui.forms.textarea shadcn_ui.forms.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :form, :any, required: true

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
