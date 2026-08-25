defmodule ShadcnUI.Components.Forms.SelectOptions do
  @moduledoc false

  alias ShadcnUI.Components.Forms.FormContract

  @option_keys [:key, :value, :label, :disabled]
  @group_keys [:key, :label, :options, :disabled]

  def normalize!(options, base_id) when is_list(options) and options != [] do
    items = Enum.map(options, &normalize_item!(&1, base_id))
    keys = Enum.flat_map(items, &item_keys/1)

    if length(keys) != length(Enum.uniq(keys)) do
      raise ArgumentError, "select option and optgroup keys must be unique"
    end

    items
  end

  def normalize!([], _base_id) do
    raise ArgumentError, "select options must be a nonempty list"
  end

  def normalize!(other, _base_id) do
    raise ArgumentError, "select options must be a nonempty list, got: #{inspect(other)}"
  end

  def selected!(nil, false), do: nil
  def selected!(nil, true), do: []

  def selected!(value, false) do
    if is_list(value) do
      raise ArgumentError, "single select value must be scalar or nil, got: #{inspect(value)}"
    end

    scalar_string!(value, "single select value")
  end

  def selected!(values, true) when is_list(values) do
    values
    |> Enum.map(&scalar_string!(&1, "multiple select value"))
    |> Enum.uniq()
  end

  def selected!(value, true) do
    raise ArgumentError, "multiple select value must be a list or nil, got: #{inspect(value)}"
  end

  def selected?(nil, _value), do: false
  def selected?(selected, value) when is_list(selected), do: value in selected
  def selected?(selected, value), do: selected == value

  defp normalize_item!(item, base_id) when is_map(item) and not is_struct(item) do
    if Map.has_key?(item, :options) do
      normalize_group!(item, base_id)
    else
      normalize_option!(item, base_id)
    end
  end

  defp normalize_item!(other, _base_id) do
    raise ArgumentError,
          "select entries must be plain option or optgroup maps, got: #{inspect(other)}"
  end

  defp normalize_option!(option, base_id) do
    validate_keys!(option, @option_keys, "option")
    key = option |> fetch!(:key, "option") |> stable_key!("option")

    %{
      kind: :option,
      key: key,
      id: FormContract.option_id(base_id, key),
      value: option |> fetch!(:value, "option") |> scalar_string!("option value"),
      label: option |> fetch!(:label, "option") |> nonblank_string!("option label"),
      disabled: option |> Map.get(:disabled, false) |> boolean!("option disabled")
    }
  end

  defp normalize_group!(group, base_id) do
    validate_keys!(group, @group_keys, "optgroup")
    key = group |> fetch!(:key, "optgroup") |> stable_key!("optgroup")
    options = fetch!(group, :options, "optgroup")

    if not is_list(options) or options == [] do
      raise ArgumentError, "optgroup options must be a nonempty list"
    end

    %{
      kind: :group,
      key: key,
      id: FormContract.option_id(base_id, key),
      label: group |> fetch!(:label, "optgroup") |> nonblank_string!("optgroup label"),
      disabled: group |> Map.get(:disabled, false) |> boolean!("optgroup disabled"),
      options: Enum.map(options, &normalize_nested_option!(&1, base_id))
    }
  end

  defp normalize_nested_option!(option, base_id)
       when is_map(option) and not is_struct(option) and not is_map_key(option, :options) do
    normalize_option!(option, base_id)
  end

  defp normalize_nested_option!(other, _base_id) do
    raise ArgumentError,
          "optgroups may contain only plain option maps and may not be nested, got: #{inspect(other)}"
  end

  defp item_keys(%{kind: :option, key: key}), do: [key]

  defp item_keys(%{kind: :group, key: key, options: options}) do
    [key | Enum.map(options, & &1.key)]
  end

  defp validate_keys!(map, allowed, label) do
    unexpected = Map.keys(map) -- allowed

    if unexpected != [] do
      raise ArgumentError,
            "select #{label} maps may contain only #{inspect(allowed)}, got: #{inspect(unexpected)}"
    end
  end

  defp fetch!(map, key, label) do
    Map.fetch!(map, key)
  rescue
    KeyError -> raise ArgumentError, "each select #{label} must include :#{key}"
  end

  defp stable_key!(key, _label) when is_binary(key) or is_atom(key) or is_integer(key), do: key

  defp stable_key!(key, label) do
    raise ArgumentError,
          "select #{label} key must be a stable string, atom, or integer, got: #{inspect(key)}"
  end

  defp scalar_string!(value, _label)
       when is_binary(value) or is_atom(value) or is_integer(value) or is_float(value) or
              is_boolean(value),
       do: to_string(value)

  defp scalar_string!(value, label) do
    raise ArgumentError, "#{label} must be a scalar value, got: #{inspect(value)}"
  end

  defp nonblank_string!(value, label) when is_binary(value) do
    if String.trim(value) == "" do
      raise ArgumentError, "#{label} must be a nonblank string"
    end

    value
  end

  defp nonblank_string!(value, label) do
    raise ArgumentError, "#{label} must be a nonblank string, got: #{inspect(value)}"
  end

  defp boolean!(value, _label) when is_boolean(value), do: value

  defp boolean!(value, label) do
    raise ArgumentError, "#{label} must be a boolean, got: #{inspect(value)}"
  end
end
