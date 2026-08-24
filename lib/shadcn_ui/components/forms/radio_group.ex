defmodule ShadcnUI.Components.Forms.RadioGroup do
  use ShadcnUI.Component

  @moduledoc """
  Native exclusive-choice group with deterministic option identity.

  Radio Group renders one fieldset, one legend, and real radio inputs from
  validated caller data. Selection is a server-rendered snapshot derived from a
  FormField or explicit value; native keyboard, reset, and submission behavior
  remain browser-owned.
  """

  alias ShadcnUI.Components.Forms.FormContract
  import ShadcnUI.Components.Forms.FieldErrors, only: [field_errors: 1]
  import ShadcnUI.Components.Forms.Help, only: [help: 1]

  @not_provided {:shadcn_ui, :not_provided}
  @option_keys [:key, :value, :label, :disabled]
  @layout_classes %{
    vertical: "sui:grid sui:gap-2",
    inline: "sui:flex sui:flex-wrap sui:gap-x-5 sui:gap-y-2"
  }

  attr :field, :any, default: nil
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :selected, :any, default: @not_provided
  attr :options, :list, required: true
  attr :errors, :any, default: @not_provided
  attr :error_mode, :atom, values: [:used_input, :always, :hidden], default: :used_input
  attr :used, :boolean, default: false
  attr :translate_error, :any, default: nil
  attr :pending, :boolean, default: false
  attr :required, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :form, :string, default: nil
  attr :layout, :atom, values: [:vertical, :inline], default: :vertical
  attr :describedby, :any, default: nil
  attr :class, :any, default: nil
  attr :options_class, :any, default: nil
  attr :option_class, :any, default: nil
  attr :legend_class, :any, default: nil
  attr :rest, :global

  slot :legend, required: true
  slot :help

  @doc "Renders one native fieldset of deterministic radio options."
  def radio_group(assigns) do
    options = normalize_options!(assigns.options)
    layout_class = Map.fetch!(@layout_classes, assigns.layout)

    normalized =
      FormContract.normalize!(
        field: assigns.field,
        id: assigns.id,
        name: assigns.name,
        value: assigns.selected,
        errors: assigns.errors,
        error_mode: assigns.error_mode,
        used: assigns.used,
        translate_error: assigns.translate_error,
        pending: assigns.pending
      )

    selected = validate_selected!(normalized.value)

    relationships =
      FormContract.relationships(normalized,
        help: assigns.help != [],
        describedby: assigns.describedby
      )

    options =
      Enum.map(options, fn option ->
        Map.put(option, :id, FormContract.option_id(normalized.id, option.key))
      end)

    assigns =
      assigns
      |> assign(:normalized, normalized)
      |> assign(:selected, selected)
      |> assign(:relationships, relationships)
      |> assign(:options, options)
      |> assign(
        :safe_rest,
        FormContract.protect_control_globals(assigns.rest, [
          :aria_label,
          :aria_labelledby,
          :disabled,
          :form,
          :data_pending
        ])
      )
      |> assign(
        :classes,
        class_names([
          "sui:grid sui:min-w-0 sui:gap-2 sui:rounded-md sui:border-l-2",
          "sui:border-transparent sui:pl-3 sui:text-foreground",
          normalized.errors_visible? && "sui:border-destructive",
          assigns.disabled && "sui:opacity-60",
          normalized.pending? && "sui:cursor-progress",
          assigns.class
        ])
      )
      |> assign(:options_classes, class_names([layout_class, assigns.options_class]))
      |> assign(
        :control_classes,
        class_names([
          "sui:size-4 sui:shrink-0 sui:border sui:border-input sui:accent-primary",
          "sui:bg-background sui:text-primary sui:outline-none",
          "sui:focus-visible:ring-2 sui:focus-visible:ring-ring sui:focus-visible:ring-offset-2",
          "sui:focus-visible:ring-offset-background sui:disabled:cursor-not-allowed",
          "sui:disabled:opacity-50 sui:checked:border-primary",
          normalized.errors_visible? && "sui:border-destructive"
        ])
      )

    ~H"""
    <fieldset
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-radio-group
      data-invalid={@normalized.errors_visible? && "true"}
      data-pending={@normalized.pending? && "true"}
      id={@normalized.id}
      disabled={@disabled}
      form={@form}
      aria-labelledby={@relationships.label_id}
      aria-describedby={@relationships.describedby}
      aria-invalid={@relationships.aria_invalid}
      class={@classes}
    >
      <legend
        id={@relationships.label_id}
        class={
          class_names(["sui:max-w-full sui:break-words sui:text-sm sui:font-medium", @legend_class])
        }
      >
        {render_slot(@legend)}<span
          :if={@required}
          aria-hidden="true"
          class="sui:ml-1 sui:text-destructive"
        >*</span>
      </legend>
      <div data-shadcn-ui-radio-options class={@options_classes}>
        <label
          :for={option <- @options}
          for={option.id}
          class={
            class_names([
              "sui:flex sui:min-w-0 sui:items-start sui:gap-2 sui:text-sm",
              option.disabled && "sui:opacity-60",
              @option_class
            ])
          }
        >
          <input
            data-shadcn-ui
            data-shadcn-ui-radio
            type="radio"
            id={option.id}
            name={@normalized.name}
            value={option.value}
            checked={same_value?(@selected, option.value)}
            required={@required}
            disabled={option.disabled}
            form={@form}
            class={@control_classes}
          />
          <span class="sui:min-w-0 sui:break-words">{option.label}</span>
        </label>
      </div>
      <.help :if={@help != []} id={@relationships.help_id}>{render_slot(@help)}</.help>
      <.field_errors errors={@normalized.errors} ids={@relationships.error_ids} />
    </fieldset>
    """
  end

  defp normalize_options!(options) when is_list(options) and options != [] do
    options = Enum.map(options, &normalize_option!/1)
    ensure_unique!(options, :key)
    ensure_unique!(options, :value)
    options
  end

  defp normalize_options!([]), do: raise(ArgumentError, "radio options must be a nonempty list")

  defp normalize_options!(other) do
    raise ArgumentError, "radio options must be a nonempty list, got: #{inspect(other)}"
  end

  defp normalize_option!(option) when is_map(option) and not is_struct(option) do
    unexpected = Map.keys(option) -- @option_keys

    if unexpected != [] do
      raise ArgumentError,
            "radio options may contain only #{inspect(@option_keys)}, got: #{inspect(unexpected)}"
    end

    %{
      key: option |> Map.fetch!(:key) |> validate_key!(),
      value: option |> Map.fetch!(:value) |> require_nonblank!(:value),
      label: option |> Map.fetch!(:label) |> require_nonblank!(:label),
      disabled: option |> Map.get(:disabled, false) |> validate_disabled!()
    }
  rescue
    KeyError ->
      raise ArgumentError, "each radio option must include :key, :value, and :label"
  end

  defp normalize_option!(other) do
    raise ArgumentError,
          "each radio option must be a plain map with atom keys, got: #{inspect(other)}"
  end

  defp validate_key!(key) when is_binary(key) or is_atom(key) or is_integer(key), do: key

  defp validate_key!(key) do
    raise ArgumentError,
          "radio option key must be a stable string, atom, or integer, got: #{inspect(key)}"
  end

  defp require_nonblank!(value, field) when is_binary(value) do
    if String.trim(value) == "" do
      raise ArgumentError, "radio option #{field} must be a nonblank string"
    end

    value
  end

  defp require_nonblank!(value, field) do
    raise ArgumentError,
          "radio option #{field} must be a nonblank string, got: #{inspect(value)}"
  end

  defp validate_disabled!(value) when is_boolean(value), do: value

  defp validate_disabled!(value) do
    raise ArgumentError, "radio option disabled must be a boolean, got: #{inspect(value)}"
  end

  defp ensure_unique!(options, field) do
    values = Enum.map(options, &Map.fetch!(&1, field))

    if length(values) != length(Enum.uniq(values)) do
      raise ArgumentError, "radio option #{field} values must be unique"
    end
  end

  defp validate_selected!(nil), do: nil

  defp validate_selected!(value)
       when is_binary(value) or is_atom(value) or is_integer(value) or is_float(value),
       do: value

  defp validate_selected!(value) do
    raise ArgumentError, "radio selected value must be scalar or nil, got: #{inspect(value)}"
  end

  defp same_value?(left, right)
       when is_binary(left) or is_atom(left) or is_integer(left) or is_float(left),
       do: to_string(left) == right

  defp same_value?(_left, _right), do: false
end
