defmodule ShadcnUIDemo.DocumentationCatalogue do
  @moduledoc """
  Closed, authored documentation identities layered over the stable gallery catalogue.

  This module belongs to the demo and build boundary. It describes public
  component identities but never invokes them from request, fragment, or search
  text and is not part of the ShadcnUI package API.
  """

  alias ShadcnUIDemo.{Catalogue, Reference}

  @schema_version "1"
  @package_root Path.expand("../../..", __DIR__)
  @documentation_keys ~w(what when responsibilities accessibility fallback source native_baseline package_enhancement demo_behavior unsupported)a
  @search_keys ~w(category keywords name route summary url)
  @static_base "/shadcn_ui"
  @related_compositions %{
    "foundation" => [:documentation],
    "forms" => [:settings],
    "disclosure" => [:responsive_drawers],
    "navigation" => [:application_shell],
    "content-surfaces" => [:documentation],
    "overlays" => [:overlay_capabilities, :settings_confirmation],
    "interactive-surfaces" => [:supplemental_help],
    "media" => [:image_gallery, :media_browser],
    "motion" => [:motion_preferences, :motion_media_capabilities]
  }

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

      examples = examples(component, reference, fragment)

      %{
        schema_version: @schema_version,
        category: Map.take(category, [:label, :slug, :path]),
        label: component.label,
        slug: component.slug,
        route: component.path,
        render: component.render,
        public: %{module: module, function: function, arity: 1},
        documentation: Map.take(reference, @documentation_keys),
        links: %{
          gallery: component.path,
          source: source_url(module),
          api: api_url(module, function)
        },
        api: component_api(module, function),
        examples: examples,
        presentation: presentation(component.render),
        provenance_id: provenance_id,
        verification: %{
          source_compile: "source:#{component.render}",
          browser_route: component.path,
          export_route: component.path
        }
      }
    end)
  end

  defp examples(%{render: :accordion} = component, reference, fragment) do
    [
      %{
        fragment: fragment,
        source_fragment: "#{fragment}-source",
        source_id: "reference:accordion:exclusive",
        preview_label: "Exclusive FAQ",
        layout: "constrained",
        route: "#{component.path}##{fragment}",
        source: reference.source
      },
      %{
        fragment: "accordion-independent",
        source_fragment: "accordion-independent-source",
        source_id: "reference:accordion:independent",
        preview_label: "Independent sections",
        layout: "constrained",
        route: "#{component.path}#accordion-independent",
        source: reference.independent_source
      }
    ]
  end

  defp examples(component, reference, fragment) do
    [
      %{
        fragment: fragment,
        source_fragment: "#{fragment}-source",
        source_id: "reference:#{component.render}",
        preview_label: "#{component.label} primary example",
        layout: "centered",
        route: "#{component.path}##{fragment}",
        source: reference.source
      }
    ]
  end

  defp presentation(:accordion) do
    %{
      capabilities: [
        %{identity: "native-baseline", label: "Native disclosure", field: :native_baseline},
        %{identity: "exclusive-grouping", label: "Exclusive grouping", field: :capability},
        %{identity: "details-content", label: "Animated content", field: :details_content},
        %{identity: "interpolate-size", label: "Intrinsic size", field: :interpolate_size},
        %{identity: "fallback", label: "Exact fallback", field: :fallback}
      ],
      how_it_works: [
        %{code: "<details><summary>", field: :native_baseline},
        %{code: ~s(name="faq"), field: :capability},
        %{code: "open", field: :open_state},
        %{code: "id + item key", field: :stable_identity},
        %{code: "application boundary", field: :responsibilities}
      ],
      support_rows: [
        %{
          feature: "Exclusive grouping",
          evidence: :exclusive_evidence,
          fallback: :exclusive_fallback
        },
        %{
          feature: "Animated disclosure content",
          evidence: :details_content_evidence,
          fallback: :motion_fallback
        },
        %{
          feature: "Intrinsic-size interpolation",
          evidence: :interpolate_size_evidence,
          fallback: :motion_fallback
        }
      ],
      adaptation:
        "The article presentation is adapted from the pinned unscripted/ui Accordion reference. Phoenix slot syntax, deterministic IDs, and the package's native disclosure contract are deliberate local differences."
    }
  end

  defp presentation(_render), do: nil

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

  @doc "Returns closed, deterministic related component and composition destinations."
  @spec related(map()) :: %{components: [map()], compositions: [map()]}
  def related(%{category: %{slug: category}, route: route}) do
    %{
      components:
        Catalogue.components(category)
        |> Enum.reject(&(&1.path == route))
        |> Enum.take(3)
        |> Enum.map(&Map.take(&1, [:label, :path])),
      compositions:
        Catalogue.compositions()
        |> Enum.filter(&(&1.render in Map.fetch!(@related_compositions, category)))
        |> Enum.map(&Map.take(&1, [:label, :path]))
    }
  end

  @doc "Returns the minimal, deterministic search document records in catalogue order."
  @spec search_records() :: [map()]
  def search_records do
    Enum.map(entries(), &search_record/1)
  end

  @doc "Returns normalized search text keyed only by authored component routes."
  @spec search_texts() :: %{String.t() => String.t()}
  def search_texts do
    Map.new(search_records(), fn record ->
      {record["route"], normalize_record(record)}
    end)
  end

  @doc "Encodes the versioned search document without clocks, host paths, or executable data."
  @spec search_json() :: String.t()
  def search_json do
    Jason.encode!(%{"records" => search_records(), "schemaVersion" => @schema_version})
  end

  @doc "Returns normalized authored search text for one closed component identity."
  @spec search_text!(String.t(), String.t()) :: String.t()
  def search_text!(category, slug) do
    with {:ok, entry} <- lookup(category, slug) do
      entry
      |> search_record()
      |> normalize_record()
    else
      :error -> raise ArgumentError, "unknown documentation catalogue identity"
    end
  end

  @doc "Normalizes bounded search input without converting it to atoms or executable identities."
  @spec normalize_search(String.t()) :: String.t()
  def normalize_search(value) when is_binary(value) do
    value
    |> String.slice(0, 200)
    |> String.normalize(:nfd)
    |> String.replace(~r/\p{Mn}/u, "")
    |> String.downcase()
    |> String.replace(~r/[^\p{L}\p{N}]+/u, " ")
    |> String.trim()
  end

  @spec validate_search() :: :ok | {:error, [String.t()]}
  def validate_search do
    records = search_records()
    routes = MapSet.new(entries(), & &1.route)

    errors =
      records
      |> Enum.with_index()
      |> Enum.flat_map(fn {record, index} ->
        []
        |> maybe_error(
          Map.keys(record) == @search_keys,
          "search record #{index} has an open schema"
        )
        |> maybe_error(
          MapSet.member?(routes, record["route"]),
          "search record #{index} has an unknown route"
        )
        |> maybe_error(
          record["url"] == @static_base <> record["route"],
          "search record #{index} has an invalid URL"
        )
        |> maybe_error(
          Enum.all?(Map.values(record), &safe_search_value?/1),
          "search record #{index} has unsafe data"
        )
      end)
      |> Kernel.++(
        search_records()
        |> Enum.map(& &1["url"])
        |> duplicate_values()
        |> Enum.map(&"duplicate search URL: #{&1}")
      )
      |> Enum.sort()

    if errors == [], do: :ok, else: {:error, errors}
  end

  @spec validate() :: :ok | {:error, [String.t()]}
  def validate do
    with :ok <- audit(entries()), do: validate_search()
  end

  @doc "Returns the compiled component identities imported by `use ShadcnUI`."
  @spec public_inventory() :: [{module(), atom(), 1}]
  def public_inventory do
    public_import_modules()
    |> Enum.flat_map(fn module ->
      Code.ensure_loaded!(module)

      module.__components__()
      |> Map.keys()
      |> Enum.filter(&function_exported?(module, &1, 1))
      |> Enum.map(&{module, &1, 1})
    end)
    |> Enum.sort_by(fn {module, function, arity} -> {inspect(module), function, arity} end)
  end

  @doc "Returns deterministic, path-independent documentation completeness rows."
  @spec completeness_report() :: [map()]
  def completeness_report do
    provenance_ids = provenance_ids()
    exdoc_modules = MapSet.new(exdoc_modules())
    public_inventory = MapSet.new(public_inventory())

    renderer =
      File.read!(Path.join(@package_root, "demo/lib/shadcn_ui_demo_web/reference_components.ex"))

    entries()
    |> Enum.map(fn entry ->
      identity = {entry.public.module, entry.public.function, entry.public.arity}

      %{
        category: entry.category.slug,
        component: entry.slug,
        route: entry.route,
        public_module: inspect(entry.public.module),
        public_function: Atom.to_string(entry.public.function),
        fragments: Enum.map(entry.examples, & &1.fragment),
        documentation: documentation_complete?(entry.documentation),
        public_metadata: MapSet.member?(public_inventory, identity),
        public_import: entry.public.module in public_import_modules(),
        exdoc_group: MapSet.member?(exdoc_modules, entry.public.module),
        provenance_id: entry.provenance_id,
        provenance: MapSet.member?(provenance_ids, entry.provenance_id),
        source_compile: entry.verification.source_compile,
        renderer: renderer =~ ":#{entry.render}",
        browser_route: entry.verification.browser_route,
        export_route: entry.verification.export_route
      }
    end)
    |> Enum.sort_by(& &1.route)
  end

  @doc "Encodes the sorted completeness report without timestamps or host paths."
  @spec completeness_json() :: String.t()
  def completeness_json, do: Jason.encode!(completeness_report())

  @doc "Audits an authored entry list against compiled and repository evidence."
  @spec audit([map()]) :: :ok | {:error, [String.t()]}
  def audit(entries) when is_list(entries) do
    errors =
      []
      |> duplicate_errors(entries, :route)
      |> duplicate_errors(entries, :render)
      |> duplicate_public_errors(entries)
      |> duplicate_fragment_errors(entries)
      |> missing_identity_errors(entries)
      |> compiled_inventory_errors(entries)
      |> evidence_errors(entries)

    case Enum.sort(errors) do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  defp compiled_inventory_errors(errors, entries) do
    documented = MapSet.new(entries, &{&1.public.module, &1.public.function, &1.public.arity})
    compiled = MapSet.new(public_inventory())

    errors ++
      Enum.map(MapSet.difference(compiled, documented), fn identity ->
        "missing documentation identity: #{inspect(identity)}"
      end) ++
      Enum.map(MapSet.difference(documented, compiled), fn identity ->
        "stale documentation identity: #{inspect(identity)}"
      end)
  end

  defp evidence_errors(errors, entries) do
    imported = MapSet.new(public_import_modules())
    exdoc = MapSet.new(exdoc_modules())
    provenance = provenance_ids()

    errors ++
      Enum.flat_map(entries, fn entry ->
        []
        |> maybe_error(
          MapSet.member?(imported, entry.public.module),
          "public module is not imported: #{inspect(entry.public.module)}"
        )
        |> maybe_error(
          MapSet.member?(exdoc, entry.public.module),
          "public module is not in ExDoc groups: #{inspect(entry.public.module)}"
        )
        |> maybe_error(
          MapSet.member?(provenance, entry.provenance_id),
          "missing provenance: #{entry.provenance_id}"
        )
        |> maybe_error(
          documentation_complete?(entry.documentation),
          "incomplete documentation: #{entry.route}"
        )
        |> maybe_error(entry.route in Catalogue.routes(), "missing gallery route: #{entry.route}")
      end)
  end

  defp maybe_error(errors, true, _message), do: errors
  defp maybe_error(errors, false, message), do: [message | errors]

  defp documentation_complete?(documentation) do
    Enum.all?(@documentation_keys, fn key ->
      case Map.fetch(documentation, key) do
        {:ok, value} -> is_binary(value) and String.trim(value) != ""
        :error -> false
      end
    end)
  end

  defp component_api(module, function) do
    metadata = module.__components__() |> Map.fetch!(function)

    %{
      attributes:
        Enum.map(metadata.attrs, fn attribute ->
          %{
            name: attribute.name,
            type: attribute.type,
            required: attribute.required,
            default: Keyword.get(attribute.opts, :default, :none),
            values: Keyword.get(attribute.opts, :values),
            global: attribute.type == :global,
            included_globals: Keyword.get(attribute.opts, :include, [])
          }
        end),
      slots:
        Enum.map(metadata.slots, fn slot ->
          %{name: slot.name, required: slot.required, attributes: Enum.map(slot.attrs, & &1.name)}
        end)
    }
  end

  defp source_url(module) do
    path =
      module
      |> inspect()
      |> String.replace_prefix("ShadcnUI.Components.", "")
      |> Macro.underscore()

    "https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/lib/shadcn_ui/components/#{path}.ex"
  end

  defp api_url(module, function),
    do: "https://hexdocs.pm/shadcn_ui/#{inspect(module)}.html##{function}/1"

  defp search_record(entry) do
    %{
      "category" => entry.category.label,
      "keywords" => search_keywords(entry),
      "name" => entry.label,
      "route" => entry.route,
      "summary" => entry.documentation.what,
      "url" => @static_base <> entry.route
    }
  end

  defp normalize_record(record) do
    record
    |> Map.take(~w(category keywords name summary))
    |> Map.values()
    |> List.flatten()
    |> Enum.join(" ")
    |> normalize_search()
  end

  defp search_keywords(entry) do
    [entry.slug, entry.category.slug, Atom.to_string(entry.public.function)]
    |> Enum.map(&String.replace(&1, ["-", "_"], " "))
    |> Enum.uniq()
  end

  defp safe_search_value?(value) when is_binary(value) do
    String.valid?(value) and
      not String.contains?(String.downcase(value), ["<script", "<%", "javascript:"])
  end

  defp safe_search_value?(value) when is_list(value), do: Enum.all?(value, &safe_search_value?/1)
  defp safe_search_value?(_value), do: false

  defp public_import_modules do
    @package_root
    |> Path.join("lib/shadcn_ui.ex")
    |> File.read!()
    |> section_between("@component_modules [", "]")
    |> component_modules()
  end

  defp exdoc_modules do
    @package_root
    |> Path.join("mix.exs")
    |> File.read!()
    |> section_between("groups_for_modules: [", ~s("Package contract"))
    |> component_modules()
  end

  defp component_modules(source) do
    ~r/ShadcnUI\.Components(?:\.[A-Z][A-Za-z0-9_]*)+/
    |> Regex.scan(source)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn name ->
      name
      |> String.split(".")
      |> Module.concat()
    end)
  end

  defp section_between(source, opening, closing) do
    with [_before, tail] <- String.split(source, opening, parts: 2),
         [section, _after] <- String.split(tail, closing, parts: 2) do
      section
    else
      _ -> raise "documentation catalogue source marker is missing"
    end
  end

  defp provenance_ids do
    @package_root
    |> Path.join("priv/provenance/unscripted_ui.json")
    |> File.read!()
    |> Jason.decode!()
    |> Map.fetch!("adaptations")
    |> MapSet.new(&Map.fetch!(&1, "id"))
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
