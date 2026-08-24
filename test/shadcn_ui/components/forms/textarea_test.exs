defmodule ShadcnUI.Components.Forms.TextareaTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.textarea shadcn_ui.forms.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

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
    attr :resize, :atom, default: :vertical
    attr :sizing, :atom, default: :fixed

    def textarea_fixture(assigns) do
      ~H"""
      <.textarea
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
        resize={@resize}
        sizing={@sizing}
        rows={5}
        cols={40}
        minlength={10}
        maxlength={1_000}
        placeholder="Tell us about your work"
        autocomplete="off"
        form="profile"
        describedby="caller-help"
        class="consumer-textarea"
        field_class="consumer-field"
        autocapitalize="sentences"
        spellcheck="true"
        wrap="soft"
        aria-label="Wrong label"
        aria-invalid="false"
        data-sizing="wrong"
        data-state="ready"
        phx-change="validate"
      >
        <:label>Biography</:label>
        <:help>Briefly describe your role.</:help>
      </.textarea>
      """
    end
  end

  test "renders explicit identity, escaped element content, native attributes, and globals" do
    html =
      render_textarea(
        id: "profile_bio",
        name: "profile[bio]",
        value: "First <line>\nSecond & line",
        errors: ["is too short"],
        error_mode: :always,
        pending: true,
        required: true,
        readonly: true,
        sizing: :content
      )

    assert html =~ ~s(id="profile_bio")
    assert html =~ ~s(name="profile[bio]")
    assert html =~ ~s(>First &lt;line&gt;\nSecond &amp; line</textarea>)
    refute html =~ ~r/<textarea[^>]*\svalue=/
    assert html =~ " required"
    assert html =~ " readonly"
    refute html =~ " disabled"
    assert html =~ ~s(rows="5")
    assert html =~ ~s(cols="40")
    assert html =~ ~s(minlength="10")
    assert html =~ ~s(maxlength="1000")
    assert html =~ ~s(placeholder="Tell us about your work")
    assert html =~ ~s(autocomplete="off")
    assert html =~ ~s(form="profile")
    assert html =~ ~s(autocapitalize="sentences")
    assert html =~ ~s(spellcheck="true")
    assert html =~ ~s(wrap="soft")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-change="validate")
    assert html =~ ~s(data-sizing="content")
    assert html =~ ~s(data-pending="true")
    assert html =~ ~s(aria-invalid="true")
    refute html =~ "Wrong label"
    refute html =~ ~s(data-sizing="wrong")
    refute html =~ ~s(aria-invalid="false")
  end

  test "uses FormField defaults with explicit-over-derived precedence" do
    field = form_field()
    derived = render_textarea(field: field, error_mode: :always)

    assert derived =~ ~s(id="profile_biography")
    assert derived =~ ~s(name="profile[biography]")
    assert derived =~ ">Field biography</textarea>"
    assert derived =~ "must be longer"

    explicit =
      render_textarea(
        field: field,
        id: "editor_note",
        name: "editor[note]",
        value: "Explicit note",
        errors: ["cannot be blank"],
        error_mode: :always
      )

    assert explicit =~ ~s(id="editor_note")
    assert explicit =~ ~s(name="editor[note]")
    assert explicit =~ ">Explicit note</textarea>"
    assert explicit =~ "cannot be blank"
    refute explicit =~ "Field biography"
  end

  test "maps every resize policy and keeps sizing enhancement explicit" do
    expected = %{
      vertical: "sui:resize-y",
      horizontal: "sui:resize-x",
      both: "sui:resize",
      fixed: "sui:resize-none"
    }

    for {resize, class} <- expected do
      html = render_textarea(id: "bio", name: "bio", resize: resize)
      assert html =~ class
      assert html =~ ~s(data-sizing="fixed")
    end

    metadata = ShadcnUI.Components.Forms.Textarea.__components__().textarea
    resize = Enum.find(metadata.attrs, &(&1.name == :resize))
    sizing = Enum.find(metadata.attrs, &(&1.name == :sizing))
    assert resize.opts[:values] == [:vertical, :horizontal, :both, :fixed]
    assert sizing.opts[:values] == [:fixed, :content]
  end

  test "keeps a stable minimum-height fallback outside the capability query" do
    source = File.read!("assets/shadcn_ui.css")
    [fallback, enhancement] = String.split(source, "@supports (field-sizing: content)", parts: 2)

    assert fallback =~ "[data-shadcn-ui-textarea]"
    assert fallback =~ "min-height: 6rem"
    refute fallback =~ "field-sizing: content"
    assert enhancement =~ ~s([data-shadcn-ui-textarea][data-sizing="content"])
    assert enhancement =~ "field-sizing: content"
  end

  test "does not collapse empty, long, multiline, translated, or constrained values" do
    for value <- ["", String.duplicate("long content ", 80), "first\nsecond\nthird", "Équipe 日本語"] do
      html = render_textarea(id: "content", name: "content", value: value)
      assert html =~ "sui:min-h-24"
      assert html =~ "sui:focus-visible:ring-2"
      assert html =~ ~s(minlength="10")
      assert html =~ ~s(maxlength="1000")
      assert html =~ "</textarea>"
    end
  end

  test "keeps pending independent from disabled and exposes no behavior API" do
    pending = render_textarea(id: "pending", name: "pending", pending: true)
    assert pending =~ ~s(data-pending="true")
    assert pending =~ "sui:cursor-progress"
    refute pending =~ " disabled"

    disabled = render_textarea(id: "disabled", name: "disabled", disabled: true)
    assert disabled =~ " disabled"
    refute disabled =~ ~s(data-pending="true")

    metadata = ShadcnUI.Components.Forms.Textarea.__components__().textarea

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:as, :html, :raw_html, :on_change, :auto_grow, :measure, :submit]
           end)

    source = File.read!("lib/shadcn_ui/components/forms/textarea.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|scroll_height)/
  end

  defp render_textarea(overrides) do
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
      readonly: false,
      resize: :vertical,
      sizing: :fixed,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.textarea_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp form_field do
    form = Phoenix.Component.to_form(%{"biography" => "Field biography"}, as: "profile")
    %FormField{} = field = form[:biography]
    %FormField{field | errors: [{"must be longer", []}]}
  end
end
