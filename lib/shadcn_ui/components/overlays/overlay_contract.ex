defmodule ShadcnUI.Components.Overlays.OverlayContract do
  @moduledoc false

  alias ShadcnUI.Component

  @id_pattern ~r/^[A-Za-z][A-Za-z0-9_:.-]*$/u
  @key_pattern ~r/^[A-Za-z0-9][A-Za-z0-9_.-]*$/u
  @dialog_commands %{show_modal: "show-modal", close: "close", request_close: "request-close"}
  @popover_actions %{toggle: "toggle", show: "show", hide: "hide"}
  @dismissal_policies %{none: "none", close_request: "closerequest", any: "any"}
  @popover_modes %{auto: "auto", manual: "manual"}
  @placements %{
    block_start: "block-start",
    block_end: "block-end",
    inline_start: "inline-start",
    inline_end: "inline-end"
  }

  defmodule Identity do
    @moduledoc false
    @enforce_keys [
      :base_id,
      :invoker_id,
      :surface_id,
      :title_id,
      :description_id,
      :close_id,
      :initial_focus_id
    ]
    defstruct @enforce_keys
  end

  @spec identity!(String.t(), String.t() | integer() | nil) :: Identity.t()
  def identity!(base_id, stable_key \\ nil) do
    base_id = validate_id!(base_id)
    base_id = if is_nil(stable_key), do: base_id, else: "#{base_id}-#{validate_key!(stable_key)}"

    %Identity{
      base_id: base_id,
      invoker_id: "#{base_id}-invoker",
      surface_id: "#{base_id}-surface",
      title_id: "#{base_id}-title",
      description_id: "#{base_id}-description",
      close_id: "#{base_id}-close",
      initial_focus_id: "#{base_id}-initial-focus"
    }
  end

  @spec dialog_command!(:show_modal | :close | :request_close) :: String.t()
  def dialog_command!(value), do: closed_value!(@dialog_commands, :dialog_command, value)

  @spec popover_action!(:toggle | :show | :hide) :: String.t()
  def popover_action!(value), do: closed_value!(@popover_actions, :popover_action, value)

  @spec dismissal_policy!(:none | :close_request | :any) :: String.t()
  def dismissal_policy!(value), do: closed_value!(@dismissal_policies, :dismissal_policy, value)

  @spec popover_mode!(:auto | :manual) :: String.t()
  def popover_mode!(value), do: closed_value!(@popover_modes, :popover_mode, value)

  @spec placement!(:block_start | :block_end | :inline_start | :inline_end) :: String.t()
  def placement!(value), do: closed_value!(@placements, :placement, value)

  @spec protect_globals!(map(), :invoker | :dialog | :popover | :close | :initial_focus) :: map()
  def protect_globals!(globals, owner) when is_map(globals) and not is_struct(globals) do
    protected =
      case owner do
        :invoker ->
          [:id, :type, :role, :command, :commandfor, :popovertarget, :popovertargetaction]

        :dialog ->
          [:id, :role, :open, :closedby, :autofocus, :aria_labelledby, :aria_describedby]

        :popover ->
          [:id, :role, :popover, :aria_labelledby, :aria_describedby]

        :close ->
          [:id, :type, :role, :command, :commandfor, :popovertarget, :popovertargetaction]

        :initial_focus ->
          [:id, :autofocus]

        other ->
          raise ArgumentError, "unknown overlay global owner: #{inspect(other)}"
      end

    Component.protect_globals(globals, protected ++ [:name, :data_shadcn_ui])
  end

  def protect_globals!(globals, _owner) do
    raise ArgumentError, "overlay globals must be a plain map, got: #{inspect(globals)}"
  end

  @spec validate_nesting!(:root | :dialog, :dialog | :popover) :: :ok
  def validate_nesting!(:root, child) when child in [:dialog, :popover], do: :ok
  def validate_nesting!(:dialog, :popover), do: :ok

  def validate_nesting!(parent, child) do
    raise ArgumentError,
          "unsupported overlay nesting #{inspect(parent)} -> #{inspect(child)}; only one Popover inside a Dialog-family surface is supported"
  end

  defp validate_id!(id) when is_binary(id) do
    id = String.trim(id)

    if Regex.match?(@id_pattern, id) do
      id
    else
      raise ArgumentError,
            "overlay base ID must start with a letter and contain only letters, digits, _, :, ., or -"
    end
  end

  defp validate_id!(id) do
    raise ArgumentError, "overlay base ID must be a nonblank string, got: #{inspect(id)}"
  end

  defp validate_key!(key) when is_integer(key), do: Integer.to_string(key)

  defp validate_key!(key) when is_binary(key) do
    key = String.trim(key)

    if Regex.match?(@key_pattern, key) do
      key
    else
      raise ArgumentError, "overlay stable key must contain only letters, digits, _, ., or -"
    end
  end

  defp validate_key!(key) do
    raise ArgumentError, "overlay stable key must be a string or integer, got: #{inspect(key)}"
  end

  defp closed_value!(values, field, value) do
    case values do
      %{^value => rendered} -> rendered
      _ -> raise ArgumentError, "unsupported #{field}: #{inspect(value)}"
    end
  end
end
