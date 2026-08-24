defmodule ShadcnUI.Components.Forms.FormContract do
  @moduledoc false

  alias Phoenix.HTML.FormField
  alias ShadcnUI.Component

  @error_modes [:used_input, :always, :hidden]
  @not_provided {:shadcn_ui, :not_provided}

  defmodule Field do
    @moduledoc false

    @enforce_keys [:id, :name, :value, :errors, :errors_visible?, :pending?]
    defstruct [:id, :name, :value, :errors, :errors_visible?, :pending?]
  end

  defmodule Relationships do
    @moduledoc false

    @enforce_keys [:label_id, :help_id, :error_ids, :describedby, :aria_invalid]
    defstruct [:label_id, :help_id, :error_ids, :describedby, :aria_invalid]
  end

  @type option ::
          {:field, FormField.t() | nil}
          | {:id, String.t() | nil}
          | {:name, String.t() | nil}
          | {:value, term()}
          | {:errors, [String.t()]}
          | {:error_mode, :used_input | :always | :hidden}
          | {:used, boolean()}
          | {:translate_error, (term() -> String.t()) | nil}
          | {:pending, boolean()}

  @spec normalize!([option()]) :: Field.t()
  def normalize!(options) when is_list(options) do
    field = Keyword.get(options, :field)
    validate_field!(field)

    id = resolve_identity!(options, :id, field)
    name = resolve_identity!(options, :name, field)
    value = resolve_value(options, field)
    errors = resolve_errors!(options, field)
    error_mode = Keyword.get(options, :error_mode, :used_input)
    pending? = Keyword.get(options, :pending, false)

    validate_error_mode!(error_mode)
    validate_boolean!(:used, Keyword.get(options, :used, false))
    validate_boolean!(:pending, pending?)

    visible? = errors != [] and errors_visible?(error_mode, field, options)

    %Field{
      id: id,
      name: name,
      value: value,
      errors: if(visible?, do: errors, else: []),
      errors_visible?: visible?,
      pending?: pending?
    }
  end

  def normalize!(other) do
    raise ArgumentError,
          "form normalization options must be a keyword list, got: #{inspect(other)}"
  end

  @spec relationships(Field.t(), keyword()) :: Relationships.t()
  def relationships(%Field{} = field, options \\ []) when is_list(options) do
    help? = Keyword.get(options, :help, false)
    validate_boolean!(:help, help?)

    help_id = if help?, do: help_id(field.id)
    error_ids = Enum.with_index(field.errors, 1) |> Enum.map(&error_id(field.id, elem(&1, 1)))

    describedby =
      options
      |> Keyword.get(:describedby)
      |> describedby_tokens()
      |> Kernel.++(List.wrap(help_id))
      |> Kernel.++(error_ids)
      |> ordered_distinct()
      |> join_tokens()

    %Relationships{
      label_id: label_id(field.id),
      help_id: help_id,
      error_ids: error_ids,
      describedby: describedby,
      aria_invalid: field.errors_visible? && "true"
    }
  end

  @spec label_id(String.t()) :: String.t()
  def label_id(base_id), do: relationship_id!(base_id, "label")

  @spec help_id(String.t()) :: String.t()
  def help_id(base_id), do: relationship_id!(base_id, "help")

  @spec error_id(String.t(), pos_integer()) :: String.t()
  def error_id(base_id, ordinal) when is_integer(ordinal) and ordinal > 0 do
    relationship_id!(base_id, "error-#{ordinal}")
  end

  def error_id(_base_id, ordinal) do
    raise ArgumentError, "error ordinal must be a positive integer, got: #{inspect(ordinal)}"
  end

  @spec summary_item_id(String.t(), pos_integer()) :: String.t()
  def summary_item_id(base_id, ordinal) when is_integer(ordinal) and ordinal > 0 do
    relationship_id!(base_id, "summary-#{ordinal}")
  end

  def summary_item_id(_base_id, ordinal) do
    raise ArgumentError, "summary ordinal must be a positive integer, got: #{inspect(ordinal)}"
  end

  @spec option_id(String.t(), String.t() | atom() | integer()) :: String.t()
  def option_id(base_id, key) when is_binary(key) or is_atom(key) or is_integer(key) do
    encoded =
      key
      |> stable_option_key()
      |> Base.url_encode64(padding: false)

    relationship_id!(base_id, "option-#{encoded}")
  end

  def option_id(_base_id, key) do
    raise ArgumentError,
          "option keys must be stable strings, atoms, or integers, got: #{inspect(key)}"
  end

  @spec protect_control_globals(map(), [atom() | String.t()]) :: map()
  def protect_control_globals(globals, additional \\ []) do
    protected = [
      :id,
      :name,
      :for,
      :type,
      :role,
      :aria_invalid,
      :aria_describedby,
      :data_shadcn_ui
    ]

    Component.protect_globals(globals, protected ++ additional)
  end

  defp validate_field!(nil), do: :ok
  defp validate_field!(%FormField{}), do: :ok

  defp validate_field!(other) do
    raise ArgumentError,
          "field must be a Phoenix.HTML.FormField or nil, got: #{inspect(other)}"
  end

  defp resolve_identity!(options, key, field) do
    explicit = Keyword.get(options, key, @not_provided)

    value =
      case explicit do
        @not_provided -> field_value(field, key)
        nil -> field_value(field, key)
        value -> value
      end

    case value do
      value when is_binary(value) ->
        case String.trim(value) do
          "" -> raise ArgumentError, "normalized #{key} must be a nonblank string"
          normalized -> normalized
        end

      _ ->
        raise ArgumentError, "normalized #{key} must be a nonblank string"
    end
  end

  defp resolve_value(options, field) do
    case Keyword.get(options, :value, @not_provided) do
      @not_provided -> field_value(field, :value)
      explicit -> explicit
    end
  end

  defp resolve_errors!(options, field) do
    case Keyword.get(options, :errors, @not_provided) do
      @not_provided -> translate_field_errors!(field_value(field, :errors) || [], options)
      explicit -> validate_explicit_errors!(explicit)
    end
  end

  defp validate_explicit_errors!(errors) when is_list(errors) do
    Enum.map(errors, fn
      error when is_binary(error) -> error
      other -> raise ArgumentError, "explicit errors must be strings, got: #{inspect(other)}"
    end)
  end

  defp validate_explicit_errors!(other) do
    raise ArgumentError, "explicit errors must be a list of strings, got: #{inspect(other)}"
  end

  defp translate_field_errors!(errors, options) when is_list(errors) do
    translator = Keyword.get(options, :translate_error)
    validate_translator!(translator)

    Enum.map(errors, fn error ->
      translated = if translator, do: translator.(error), else: interpolate_error(error)

      if is_binary(translated) do
        translated
      else
        raise ArgumentError,
              "error translator must return a string, got: #{inspect(translated)}"
      end
    end)
  end

  defp translate_field_errors!(other, _options) do
    raise ArgumentError, "FormField errors must be a list, got: #{inspect(other)}"
  end

  defp validate_translator!(nil), do: :ok
  defp validate_translator!(translator) when is_function(translator, 1), do: :ok

  defp validate_translator!(other) do
    raise ArgumentError, "translate_error must be a one-arity function, got: #{inspect(other)}"
  end

  defp interpolate_error({message, replacements})
       when is_binary(message) and is_list(replacements) do
    Enum.reduce(replacements, message, fn {key, value}, rendered ->
      String.replace(rendered, "%{#{key}}", to_string(value))
    end)
  end

  defp interpolate_error(message) when is_binary(message), do: message

  defp interpolate_error(other) do
    raise ArgumentError,
          "FormField errors must be strings or {message, replacements} tuples, got: #{inspect(other)}"
  end

  defp errors_visible?(:always, _field, _options), do: true
  defp errors_visible?(:hidden, _field, _options), do: false

  defp errors_visible?(:used_input, %FormField{} = field, _options) do
    Phoenix.Component.used_input?(field)
  end

  defp errors_visible?(:used_input, nil, options), do: Keyword.get(options, :used, false)

  defp validate_error_mode!(mode) when mode in @error_modes, do: :ok

  defp validate_error_mode!(other) do
    raise ArgumentError,
          "error_mode must be one of #{inspect(@error_modes)}, got: #{inspect(other)}"
  end

  defp validate_boolean!(_key, value) when is_boolean(value), do: :ok

  defp validate_boolean!(key, value) do
    raise ArgumentError, "#{key} must be a boolean, got: #{inspect(value)}"
  end

  defp relationship_id!(base_id, suffix) do
    case base_id do
      value when is_binary(value) ->
        case String.trim(value) do
          "" -> raise ArgumentError, "relationship base ID must be a nonblank string"
          normalized -> "#{normalized}-#{suffix}"
        end

      _ ->
        raise ArgumentError, "relationship base ID must be a nonblank string"
    end
  end

  defp stable_option_key(key) when is_binary(key), do: "string:" <> key
  defp stable_option_key(key) when is_atom(key), do: "atom:" <> Atom.to_string(key)
  defp stable_option_key(key) when is_integer(key), do: "integer:" <> Integer.to_string(key)

  defp describedby_tokens(nil), do: []

  defp describedby_tokens(value) when is_binary(value) do
    String.split(value, ~r/\s+/, trim: true)
  end

  defp describedby_tokens(values) when is_list(values) do
    Enum.flat_map(values, &describedby_tokens/1)
  end

  defp describedby_tokens(other) do
    raise ArgumentError,
          "describedby must be a string, nested list of strings, or nil, got: #{inspect(other)}"
  end

  defp ordered_distinct(tokens) do
    {tokens, _seen} =
      Enum.map_reduce(tokens, MapSet.new(), fn token, seen ->
        if MapSet.member?(seen, token) do
          {nil, seen}
        else
          {token, MapSet.put(seen, token)}
        end
      end)

    Enum.reject(tokens, &is_nil/1)
  end

  defp join_tokens([]), do: nil
  defp join_tokens(tokens), do: Enum.join(tokens, " ")

  defp field_value(nil, _key), do: nil
  defp field_value(%FormField{} = field, key), do: Map.fetch!(field, key)
end
