defmodule ShadcnUI.Components.Forms.SelectControlsTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.FormField
  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.forms.native_select shadcn_ui.forms.shared_contract
  # covers: shadcn_ui.form.normalization shadcn_ui.form.explicit_identity
  # covers: shadcn_ui.form.deterministic_relationships shadcn_ui.form.native_states
  # covers: shadcn_ui.form.protected_globals shadcn_ui.form.native_submission

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr(:field, :any, default: nil)
    attr(:id, :string, default: nil)
    attr(:name, :string, default: nil)
    attr(:value, :any, default: {:shadcn_ui, :not_provided})
    attr(:options, :list, required: true)
    attr(:errors, :any, default: {:shadcn_ui, :not_provided})
    attr(:error_mode, :atom, default: :used_input)
    attr(:pending, :boolean, default: false)
    attr(:required, :boolean, default: false)
    attr(:disabled, :boolean, default: false)
    attr(:multiple, :boolean, default: false)
    attr(:size, :atom, default: :default)

    def native_fixture(assigns) do
      ~H"""
      <.native_select
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        options={@options}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        multiple={@multiple}
        size={@size}
        form="profile"
        describedby="caller-help caller-help"
        class="consumer-select"
        field_class="consumer-field"
        autofocus
        role="combobox"
        aria-label="Wrong label"
        aria-invalid="false"
        data-state="ready"
        phx-change="caller-owned"
      >
        <:label>Country</:label>
        <:help>Choose the country used for your account.</:help>
      </.native_select>
      """
    end

    attr(:field, :any, default: nil)
    attr(:id, :string, default: nil)
    attr(:name, :string, default: nil)
    attr(:value, :any, default: {:shadcn_ui, :not_provided})
    attr(:options, :list, required: true)
    attr(:errors, :any, default: {:shadcn_ui, :not_provided})
    attr(:error_mode, :atom, default: :used_input)
    attr(:pending, :boolean, default: false)
    attr(:required, :boolean, default: false)
    attr(:disabled, :boolean, default: false)
    attr(:multiple, :boolean, default: false)
    attr(:size, :atom, default: :default)

    def enhanced_fixture(assigns) do
      ~H"""
      <.enhanced_select
        field={@field}
        id={@id}
        name={@name}
        value={@value}
        options={@options}
        errors={@errors}
        error_mode={@error_mode}
        pending={@pending}
        required={@required}
        disabled={@disabled}
        multiple={@multiple}
        size={@size}
        form="profile"
        describedby="caller-help caller-help"
        class="consumer-select"
        field_class="consumer-field"
        autofocus
        role="listbox"
        aria-label="Wrong label"
        aria-invalid="false"
        data-state="ready"
        phx-change="caller-owned"
      >
        <:label>Country</:label>
        <:help>Choose the country used for your account.</:help>
      </.enhanced_select>
      """
    end
  end

  test "renders one classic native select with scalar selection" do
    html =
      render_native(
        id: "profile_country",
        name: "profile[country]",
        value: "ca",
        options: options(),
        required: true
      )

    assert length(Regex.scan(~r/<select\b/, html)) == 1
    assert html =~ ~s(id="profile_country")
    assert html =~ ~s(name="profile[country]")
    assert html =~ ~s(value="ca" selected)
    assert html =~ ~s(value="us")
    assert html =~ ~s(value="" disabled)
    assert html =~ " required"
    refute html =~ " multiple"
    refute html =~ ~r/role="(?:combobox|listbox|option)"/
    refute html =~ ~s(type="hidden")
  end

  test "renders escaped options and one-level optgroups in caller order" do
    html = render_native(id: "country", name: "country", value: "fr", options: options())

    assert html =~ ~s(<optgroup data-shadcn-ui data-shadcn-ui-select-group id=")
    assert html =~ ~s(label="Europe &amp; neighbors")
    assert html =~ "France &lt;Hexagon&gt;"
    assert html =~ ~s(value="fr" selected)
    assert html =~ ~s(value="us" disabled)

    prompt_position = position(html, "Choose a country")
    canada_position = position(html, "Canada")
    france_position = position(html, "France &lt;Hexagon&gt;")
    assert prompt_position < canada_position
    assert canada_position < france_position
  end

  test "derives FormField values and lets an explicit value take precedence" do
    field = form_field(:country, "ca")
    derived = render_native(field: field, options: options())

    assert derived =~ ~s(id="profile_country")
    assert derived =~ ~s(name="profile[country]")
    assert derived =~ ~s(value="ca" selected)

    explicit = render_native(field: field, value: "fr", options: options())
    assert explicit =~ ~s(value="fr" selected)
    refute explicit =~ ~s(value="ca" selected)
  end

  test "normalizes native multiple names and selected list values" do
    html =
      render_native(
        id: "regions",
        name: "profile[regions]",
        value: ["ca", :fr, "ca"],
        options: options(),
        multiple: true
      )

    assert html =~ ~s(name="profile[regions][]")
    assert html =~ " multiple"
    assert length(Regex.scan(~r/ selected/, html)) == 2
    assert html =~ ~s(value="ca" selected)
    assert html =~ ~s(value="fr" selected)

    already_repeated =
      render_native(
        id: "regions",
        name: "profile[regions][]",
        value: [],
        options: options(),
        multiple: true
      )

    assert already_repeated =~ ~s(name="profile[regions][]")
    refute already_repeated =~ "[][]"
  end

  test "keeps prompts explicit and owns no placeholder policy" do
    without_prompt =
      render_native(
        id: "country",
        name: "country",
        options: [%{key: :ca, value: "ca", label: "Canada"}]
      )

    refute without_prompt =~ "Choose a country"
    refute without_prompt =~ "placeholder"

    with_prompt = render_native(id: "country", name: "country", value: "", options: options())
    assert with_prompt =~ ~s(value="" selected disabled)
  end

  test "connects errors and help while protecting native semantics" do
    html =
      render_native(
        id: "country",
        name: "country",
        options: options(),
        errors: ["Choose again", "Choose again"],
        error_mode: :always,
        pending: true,
        disabled: true
      )

    assert html =~ ~s(for="country")
    assert html =~ ~s(aria-describedby="caller-help country-help country-error-1 country-error-2")
    assert html =~ ~s(aria-invalid="true")
    assert html =~ ~s(data-pending="true")
    assert html =~ ~s(data-state="ready")
    assert html =~ ~s(phx-change="caller-owned")
    assert html =~ " disabled"
    refute html =~ "Wrong label"
    refute html =~ ~s(aria-invalid="false")
    refute html =~ ~s(role="combobox")
  end

  test "renders deterministic IDs from stable keys across reordering" do
    original = render_native(id: "country", name: "country", options: options())
    reordered = render_native(id: "country", name: "country", options: Enum.reverse(options()))

    ids = Regex.scan(~r/id="(country-option-[^"]+)"/, original, capture: :all_but_first)

    reordered_ids =
      Regex.scan(~r/id="(country-option-[^"]+)"/, reordered, capture: :all_but_first)

    assert Enum.sort(ids) == Enum.sort(reordered_ids)
    assert length(ids) == 6
  end

  test "rejects malformed, nested, duplicate, or executable option structures" do
    invalid = [
      [],
      [%{key: :ca, value: "ca"}],
      [%{key: :ca, value: %{domain: true}, label: "Canada"}],
      [%{key: :ca, value: "ca", label: ""}],
      [%{key: :ca, value: "ca", label: "Canada", render: fn -> :bad end}],
      [%{key: :group, label: "Group", options: []}],
      [%{key: :group, label: "Group", options: [%{key: :nested, label: "Nested", options: []}]}],
      [
        %{key: :duplicate, value: "ca", label: "Canada"},
        %{key: :duplicate, value: "fr", label: "France"}
      ]
    ]

    for options <- invalid do
      assert_raise ArgumentError, fn ->
        render_native(id: "country", name: "country", options: options)
      end
    end

    assert_raise ArgumentError, ~r/single select value must be scalar/, fn ->
      render_native(id: "country", name: "country", value: ["ca"], options: options())
    end

    assert_raise ArgumentError, ~r/multiple select value must be a list/, fn ->
      render_native(
        id: "country",
        name: "country",
        value: "ca",
        options: options(),
        multiple: true
      )
    end

    assert_raise ArgumentError, ~r/single select name must not use/, fn ->
      render_native(id: "country", name: "country[]", options: options())
    end
  end

  test "does not create atoms from caller option data" do
    options =
      for index <- 1..100 do
        token = "request-option-#{index}-#{System.unique_integer([:positive])}"
        %{key: token, value: token, label: token}
      end

    render_native(id: "warmup", name: "warmup", options: options)
    before_count = :erlang.system_info(:atom_count)
    html = render_native(id: "request", name: "request", options: options)
    after_count = :erlang.system_info(:atom_count)

    assert html =~ hd(options).label
    assert after_count == before_count
  end

  test "exposes no raw markup, option callback, or custom-widget behavior API" do
    metadata = ShadcnUI.Components.Forms.NativeSelect.__components__().native_select

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:html, :raw_html, :render_option, :on_select, :filter, :fetch]
           end)

    source =
      ["native_select.ex", "select.ex", "select_options.ex"]
      |> Enum.map_join("\n", &File.read!("lib/shadcn_ui/components/forms/#{&1}"))

    refute source =~ ~r/(String\.to_atom|handle_event|push_event|JS\.|<script|javascript:)/
  end

  test "enhanced select adds only standards-based optional structure to one native control" do
    html =
      render_enhanced(
        id: "profile_country",
        name: "profile[country]",
        value: "ca",
        options: options(),
        required: true
      )

    assert length(Regex.scan(~r/<select\b/, html)) == 1
    assert html =~ ~s(data-shadcn-ui-enhanced-select="true")
    assert html =~ ~s(<button data-shadcn-ui-select-button>)
    assert html =~ ~s(<selectedcontent></selectedcontent>)
    assert html =~ ~s(name="profile[country]")
    assert html =~ ~s(value="ca" selected)
    assert html =~ "Canada"
    refute html =~ ~s(type="hidden")
    refute html =~ ~r/role="(?:combobox|listbox|option)"/
  end

  test "enhanced and native APIs render identical names, values, options, and relationships" do
    overrides = [
      id: "country",
      name: "profile[country]",
      value: "fr",
      options: options(),
      errors: ["Choose again"],
      error_mode: :always,
      pending: true
    ]

    native = render_native(overrides)
    enhanced = render_enhanced(overrides)

    for fragment <- [
          ~s(name="profile[country]"),
          ~s(value="fr" selected),
          ~s(aria-describedby="caller-help country-help country-error-1"),
          ~s(aria-invalid="true"),
          ~s(data-pending="true"),
          "Choose a country",
          "Europe &amp; neighbors",
          "France &lt;Hexagon&gt;"
        ] do
      assert native =~ fragment
      assert enhanced =~ fragment
    end

    assert Regex.scan(~r/<option\b[^>]*>/, native) == Regex.scan(~r/<option\b[^>]*>/, enhanced)

    assert Regex.scan(~r/<optgroup\b[^>]*>/, native) ==
             Regex.scan(~r/<optgroup\b[^>]*>/, enhanced)
  end

  test "enhanced multiple mode preserves the classic native list without selectedcontent" do
    html =
      render_enhanced(
        id: "regions",
        name: "profile[regions]",
        value: ["ca", "fr"],
        options: options(),
        multiple: true
      )

    assert html =~ ~s(name="profile[regions][]")
    assert html =~ " multiple"
    assert length(Regex.scan(~r/ selected/, html)) == 2
    refute html =~ "selectedcontent"
    refute html =~ "data-shadcn-ui-select-button"
  end

  test "gates every enhanced selector and preserves classic visible CSS before the gate" do
    css = File.read!("assets/shadcn_ui.css")
    marker = "@supports (appearance: base-select) and selector(::picker(select)) {"
    [fallback, enhanced] = String.split(css, marker, parts: 2)

    assert fallback =~ "[data-shadcn-ui-select]"
    assert fallback =~ "appearance: auto"
    refute fallback =~ "[data-shadcn-ui-enhanced-select"
    refute fallback =~ "::picker(select)"
    refute fallback =~ "selectedcontent"

    assert enhanced =~ ~s([data-shadcn-ui-enhanced-select="true"])
    assert enhanced =~ "appearance: base-select"
    assert enhanced =~ "::picker(select)"
    assert enhanced =~ "selectedcontent"
    assert enhanced =~ "option:checked"
    assert enhanced =~ "option:disabled"
    assert enhanced =~ "option:focus-visible"
    assert enhanced =~ "@media (forced-colors: active)"

    refute css =~ ~r/\[data-shadcn-ui-enhanced-select[^}]*display:\s*none/s
    refute css =~ ~r/\[data-shadcn-ui-select[^}]*visibility:\s*hidden/s
  end

  test "enhanced API exposes no custom popup, filter, focus, or value state" do
    metadata = ShadcnUI.Components.Forms.EnhancedSelect.__components__().enhanced_select

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [
               :open,
               :active_option,
               :query,
               :filter,
               :fetch,
               :on_select,
               :on_open,
               :popup_id
             ]
           end)

    source = File.read!("lib/shadcn_ui/components/forms/enhanced_select.ex")
    refute source =~ ~r/(handle_event|push_event|JS\.|<script|javascript:|role=)/
  end

  defp render_native(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      options: options(),
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      multiple: false,
      size: :default,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.native_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp render_enhanced(overrides) do
    %{
      field: nil,
      id: nil,
      name: nil,
      value: {:shadcn_ui, :not_provided},
      options: options(),
      errors: {:shadcn_ui, :not_provided},
      error_mode: :used_input,
      pending: false,
      required: false,
      disabled: false,
      multiple: false,
      size: :default,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.enhanced_fixture()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp options do
    [
      %{key: :prompt, value: "", label: "Choose a country", disabled: true},
      %{key: "ca-key", value: "ca", label: "Canada"},
      %{key: 3, value: "us", label: "United States", disabled: true},
      %{
        key: :europe,
        label: "Europe & neighbors",
        options: [
          %{key: :fr, value: "fr", label: "France <Hexagon>"},
          %{key: :de, value: "de", label: "Germany"}
        ]
      }
    ]
  end

  defp form_field(key, value) do
    form = Phoenix.Component.to_form(%{Atom.to_string(key) => value}, as: "profile")
    %FormField{} = form[key]
  end

  defp position(html, pattern) do
    {index, _length} = :binary.match(html, pattern)
    index
  end
end
