defmodule ShadcnUI.Component do
  @moduledoc """
  Shared authoring conventions for ShadcnUI defining component modules.

  Public values select complete, statically discoverable class lists. Unknown
  values return `nil`; they are never converted into atoms or interpolated into
  utility names. Component modules use Phoenix attribute `values` metadata when
  an unsupported literal should produce a compile-time diagnostic.
  """

  @classes %{
    variant: %{
      default: ["sui:bg-primary", "sui:text-primary-foreground"],
      secondary: ["sui:bg-secondary", "sui:text-secondary-foreground"],
      destructive: ["sui:bg-destructive", "sui:text-destructive-foreground"],
      outline: ["sui:border", "sui:border-input", "sui:bg-background"],
      ghost: ["sui:bg-transparent", "sui:hover:bg-accent"],
      link: ["sui:bg-transparent", "sui:text-primary", "sui:underline-offset-4"]
    },
    size: %{
      small: ["sui:h-8", "sui:px-3", "sui:text-xs"],
      default: ["sui:h-9", "sui:px-4", "sui:py-2"],
      large: ["sui:h-10", "sui:px-8"],
      icon: ["sui:size-9", "sui:p-0"]
    },
    radius: %{
      small: ["sui:rounded-sm"],
      default: ["sui:rounded-md"],
      large: ["sui:rounded-lg"],
      full: ["sui:rounded-full"]
    },
    focus: %{
      default: [
        "sui:focus-visible:outline-2",
        "sui:focus-visible:outline-offset-2",
        "sui:focus-visible:outline-ring",
        "sui:focus-visible:ring-2",
        "sui:focus-visible:ring-ring",
        "sui:focus-visible:ring-offset-2",
        "sui:focus-visible:ring-offset-background"
      ]
    },
    disabled: %{
      default: ["sui:disabled:pointer-events-none", "sui:disabled:opacity-50"]
    },
    motion: %{
      colors: ["sui:transition-colors"],
      pulse: ["sui:animate-pulse"],
      spin: ["sui:animate-spin"]
    }
  }

  defmacro __using__(_options) do
    quote do
      use Phoenix.Component

      import ShadcnUI.Component,
        only: [class_names: 1, classes_for: 2, protect_globals: 2]
    end
  end

  @doc "Returns the fixed classes for a shared group and value, or `nil`."
  @spec classes_for(atom(), atom()) :: [String.t()] | nil
  def classes_for(group, value) when is_atom(group) and is_atom(value) do
    @classes
    |> Map.get(group, %{})
    |> Map.get(value)
  end

  def classes_for(_group, _value), do: nil

  @doc "Flattens package and caller classes into deterministic render order."
  @spec class_names(term()) :: [String.t()]
  def class_names(classes) do
    classes
    |> List.wrap()
    |> List.flatten()
    |> Enum.flat_map(&normalize_class/1)
  end

  @doc "Removes protected native or accessibility keys from caller globals."
  @spec protect_globals(map(), [atom() | String.t()]) :: map()
  def protect_globals(globals, protected) when is_map(globals) and is_list(protected) do
    protected_keys =
      protected
      |> Enum.flat_map(fn key ->
        string_key = to_string(key)
        [string_key, String.replace(string_key, "_", "-")]
      end)
      |> MapSet.new()

    Map.reject(globals, fn {key, _value} ->
      MapSet.member?(protected_keys, to_string(key))
    end)
  end

  defp normalize_class(nil), do: []
  defp normalize_class(false), do: []

  defp normalize_class(class) when is_binary(class) do
    case String.trim(class) do
      "" -> []
      normalized -> [normalized]
    end
  end

  defp normalize_class(other) do
    raise ArgumentError,
          "classes must be strings, nested lists, nil, or false; got: #{inspect(other)}"
  end
end
