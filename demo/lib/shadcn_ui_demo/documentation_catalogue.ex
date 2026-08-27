defmodule ShadcnUIDemo.DocumentationCatalogue do
  @moduledoc """
  Closed, authored documentation identities layered over the stable gallery catalogue.

  This module belongs to the demo and build boundary. It describes public
  component identities but never invokes them from request, fragment, or search
  text and is not part of the ShadcnUI package API.
  """

  alias ShadcnUIDemo.{Catalogue, Reference}

  @schema_version "1"
  @documentation_keys ~w(what when responsibilities accessibility fallback source)a

  @public_identities %{
    button: {ShadcnUI.Components.Foundation.Button, :button, "foundation.button"},
    badge: {ShadcnUI.Components.Foundation.Badge, :badge, "foundation.badge"},
    alert: {ShadcnUI.Components.Foundation.Alert, :alert, "foundation.alert"},
    card: {ShadcnUI.Components.Foundation.Card, :card, "foundation.card"},
    avatar: {ShadcnUI.Components.Foundation.Avatar, :avatar, "foundation.avatar"},
    skeleton: {ShadcnUI.Components.Foundation.Skeleton, :skeleton, "foundation.skeleton"},
    field: {ShadcnUI.Components.Forms.Field, :field, "forms.field"},
    label: {ShadcnUI.Components.Forms.Label, :label, "forms.label"},
    help: {ShadcnUI.Components.Forms.Help, :help, "forms.help"},
    field_errors: {ShadcnUI.Components.Forms.FieldErrors, :field_errors, "forms.field_errors"},
    error_summary:
      {ShadcnUI.Components.Forms.ErrorSummary, :error_summary, "forms.error_summary"},
    input: {ShadcnUI.Components.Forms.Input, :input, "forms.input"},
    textarea: {ShadcnUI.Components.Forms.Textarea, :textarea, "forms.textarea"},
    checkbox: {ShadcnUI.Components.Forms.Checkbox, :checkbox, "forms.checkbox"},
    radio_group: {ShadcnUI.Components.Forms.RadioGroup, :radio_group, "forms.radio_group"},
    switch: {ShadcnUI.Components.Forms.Switch, :switch, "forms.switch"},
    native_select:
      {ShadcnUI.Components.Forms.NativeSelect, :native_select, "forms.native_select"},
    enhanced_select:
      {ShadcnUI.Components.Forms.EnhancedSelect, :enhanced_select, "forms.enhanced_select"},
    slider: {ShadcnUI.Components.Forms.Slider, :slider, "forms.slider"},
    progress: {ShadcnUI.Components.Forms.Progress, :progress, "forms.progress"},
    meter: {ShadcnUI.Components.Forms.Meter, :meter, "forms.meter"},
    accordion: {ShadcnUI.Components.Disclosure.Accordion, :accordion, "disclosure.accordion"},
    navigation_menu:
      {ShadcnUI.Components.Navigation.NavigationMenu, :navigation_menu,
       "navigation.navigation_menu"},
    header: {ShadcnUI.Components.Navigation.Header, :header, "navigation.header"},
    section_header:
      {ShadcnUI.Components.Navigation.SectionHeader, :section_header, "navigation.section_header"},
    scroll_area: {ShadcnUI.Components.Content.ScrollArea, :scroll_area, "content.scroll_area"},
    separator: {ShadcnUI.Components.Content.Separator, :separator, "content.separator"},
    radio_panels:
      {ShadcnUI.Components.Content.RadioPanels, :radio_panels, "content.radio_panels"},
    dialog: {ShadcnUI.Components.Overlays.Dialog, :dialog, "overlays.dialog"},
    alert_dialog:
      {ShadcnUI.Components.Overlays.AlertDialog, :alert_dialog, "overlays.alert-dialog"},
    drawer: {ShadcnUI.Components.Overlays.Drawer, :drawer, "overlays.drawer"},
    popover: {ShadcnUI.Components.Overlays.Popover, :popover, "overlays.popover"},
    dropdown_actions:
      {ShadcnUI.Components.Overlays.DropdownActions, :dropdown_actions,
       "overlays.dropdown-actions"},
    tooltip: {ShadcnUI.Components.Overlays.Tooltip, :tooltip, "overlays.tooltip"},
    hover_card: {ShadcnUI.Components.Overlays.HoverCard, :hover_card, "overlays.hover-card"},
    carousel: {ShadcnUI.Components.Media.Carousel, :carousel, "media.carousel"},
    cover_flow: {ShadcnUI.Components.Media.CoverFlow, :cover_flow, "media.cover-flow"},
    image_gallery:
      {ShadcnUI.Components.Media.ImageGallery, :image_gallery, "media.image-gallery"},
    marquee: {ShadcnUI.Components.Motion.Marquee, :marquee, "motion.marquee"},
    stagger: {ShadcnUI.Components.Motion.Stagger, :stagger, "motion.stagger"},
    scroll_indicator:
      {ShadcnUI.Components.Motion.ScrollIndicator, :scroll_indicator, "motion.scroll-indicator"}
  }

  @spec schema_version() :: String.t()
  def schema_version, do: @schema_version

  @spec entries() :: [map()]
  def entries do
    categories = Map.new(Catalogue.categories(), &{&1.slug, &1})

    Enum.map(Catalogue.components(), fn component ->
      category = Map.fetch!(categories, component.category)
      reference = Reference.fetch!(component.render)
      {module, function, provenance_id} = Map.fetch!(@public_identities, component.render)
      fragment = "#{component.slug}-primary"

      %{
        schema_version: @schema_version,
        category: Map.take(category, [:label, :slug, :path]),
        label: component.label,
        slug: component.slug,
        route: component.path,
        render: component.render,
        public: %{module: module, function: function, arity: 1},
        documentation: Map.take(reference, @documentation_keys),
        examples: [
          %{
            fragment: fragment,
            source_id: "reference:#{component.render}",
            preview_label: "#{component.label} primary example",
            route: "#{component.path}##{fragment}"
          }
        ],
        provenance_id: provenance_id,
        verification: %{
          source_compile: "source:#{component.render}",
          browser_route: component.path,
          export_route: component.path
        }
      }
    end)
  end

  @spec lookup(String.t(), String.t()) :: {:ok, map()} | :error
  def lookup(category, slug) when is_binary(category) and is_binary(slug) do
    case Enum.find(entries(), &(&1.category.slug == category and &1.slug == slug)) do
      nil -> :error
      entry -> {:ok, entry}
    end
  end

  def lookup(_category, _slug), do: :error

  @spec lookup_route(String.t()) :: {:ok, map()} | :error
  def lookup_route(route) when is_binary(route) do
    case Enum.find(entries(), &(&1.route == route)) do
      nil -> :error
      entry -> {:ok, entry}
    end
  end

  def lookup_route(_route), do: :error

  @spec lookup_fragment(String.t(), String.t()) :: {:ok, map()} | :error
  def lookup_fragment(route, fragment) when is_binary(route) and is_binary(fragment) do
    with {:ok, entry} <- lookup_route(route),
         example when not is_nil(example) <-
           Enum.find(entry.examples, &(&1.fragment == fragment)) do
      {:ok, example}
    else
      _ -> :error
    end
  end

  def lookup_fragment(_route, _fragment), do: :error

  @spec validate() :: :ok | {:error, [String.t()]}
  def validate do
    entries = entries()

    errors =
      []
      |> duplicate_errors(entries, :route)
      |> duplicate_errors(entries, :render)
      |> duplicate_public_errors(entries)
      |> duplicate_fragment_errors(entries)
      |> missing_identity_errors(entries)

    case Enum.sort(errors) do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  defp duplicate_errors(errors, entries, key) do
    duplicates = entries |> Enum.map(&Map.fetch!(&1, key)) |> duplicate_values()
    errors ++ Enum.map(duplicates, &"duplicate #{key}: #{inspect(&1)}")
  end

  defp duplicate_public_errors(errors, entries) do
    duplicates =
      entries
      |> Enum.map(&{&1.public.module, &1.public.function, &1.public.arity})
      |> duplicate_values()

    errors ++ Enum.map(duplicates, &"duplicate public identity: #{inspect(&1)}")
  end

  defp duplicate_fragment_errors(errors, entries) do
    duplicates =
      entries
      |> Enum.flat_map(fn entry -> Enum.map(entry.examples, &{entry.route, &1.fragment}) end)
      |> duplicate_values()

    errors ++ Enum.map(duplicates, &"duplicate example fragment: #{inspect(&1)}")
  end

  defp missing_identity_errors(errors, entries) do
    catalogue_renders = MapSet.new(Catalogue.components(), & &1.render)
    documented_renders = MapSet.new(entries, & &1.render)
    authored_renders = MapSet.new(Map.keys(@public_identities))

    errors ++
      Enum.map(MapSet.difference(catalogue_renders, authored_renders), fn render ->
        "missing public identity: #{inspect(render)}"
      end) ++
      Enum.map(MapSet.difference(authored_renders, documented_renders), fn render ->
        "stale public identity: #{inspect(render)}"
      end)
  end

  defp duplicate_values(values) do
    values
    |> Enum.frequencies()
    |> Enum.filter(fn {_value, count} -> count > 1 end)
    |> Enum.map(&elem(&1, 0))
  end
end
