defmodule ShadcnUI do
  @moduledoc """
  Transport-neutral Phoenix function components built from semantic HTML and
  shadcn-style CSS tokens.

  `use ShadcnUI` imports each public defining component module directly. This
  preserves the `Phoenix.Component` attribute and slot metadata at caller sites
  without selecting a controller, LiveView, Dstar, or other application model.

  Applications remain responsible for copying, bundling, or serving the
  stylesheet returned by `stylesheet_path/0`.
  """

  @component_modules [
    ShadcnUI.Components.Content.RadioPanels,
    ShadcnUI.Components.Content.ScrollArea,
    ShadcnUI.Components.Content.Separator,
    ShadcnUI.Components.Disclosure.Accordion,
    ShadcnUI.Components.Navigation.Header,
    ShadcnUI.Components.Navigation.NavigationMenu,
    ShadcnUI.Components.Navigation.SectionHeader,
    ShadcnUI.Components.Overlays.AlertDialog,
    ShadcnUI.Components.Overlays.Dialog,
    ShadcnUI.Components.Overlays.Drawer,
    ShadcnUI.Components.Overlays.Popover,
    ShadcnUI.Components.Foundation.Alert,
    ShadcnUI.Components.Foundation.Avatar,
    ShadcnUI.Components.Foundation.Badge,
    ShadcnUI.Components.Foundation.Button,
    ShadcnUI.Components.Foundation.Card,
    ShadcnUI.Components.Foundation.Skeleton,
    ShadcnUI.Components.Forms.Checkbox,
    ShadcnUI.Components.Forms.EnhancedSelect,
    ShadcnUI.Components.Forms.ErrorSummary,
    ShadcnUI.Components.Forms.Field,
    ShadcnUI.Components.Forms.FieldErrors,
    ShadcnUI.Components.Forms.Help,
    ShadcnUI.Components.Forms.Input,
    ShadcnUI.Components.Forms.Label,
    ShadcnUI.Components.Forms.Meter,
    ShadcnUI.Components.Forms.NativeSelect,
    ShadcnUI.Components.Forms.Progress,
    ShadcnUI.Components.Forms.RadioGroup,
    ShadcnUI.Components.Forms.Slider,
    ShadcnUI.Components.Forms.Switch,
    ShadcnUI.Components.Forms.Textarea
  ]

  @doc """
  Imports the public defining component modules.

  The package provides HEEx infrastructure only. It does not install routes,
  sockets, processes, hooks, navigation, or state synchronization.
  """
  defmacro __using__(_options) do
    imports = Enum.map(@component_modules, &quote(do: import(unquote(&1))))

    quote do
      (unquote_splicing(imports))
    end
  end

  @doc "Returns the absolute path to the packaged, compiled stylesheet."
  @spec stylesheet_path() :: String.t()
  def stylesheet_path do
    Application.app_dir(:shadcn_ui, "priv/static/shadcn_ui.css")
  end
end
