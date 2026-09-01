defmodule ShadcnUIDemo.PresentationCatalogue do
  @moduledoc """
  Closed, demo-only presentation identities for documentation articles.

  Presentation prose remains inert data. Layout identities resolve only through
  complete static class strings owned by this module, and no request text is
  converted to atoms, modules, callbacks, templates, or asset paths.
  """

  alias ShadcnUIDemo.Catalogue

  @package_root Path.expand("../../..", __DIR__)
  @layout_classes %{
    "centered" => "gallery-specimen--centered",
    "start" => "gallery-specimen--start",
    "constrained" => "gallery-specimen--constrained",
    "tall" => "gallery-specimen--tall",
    "overflow" => "gallery-specimen--overflow",
    "composition" => "gallery-specimen--composition"
  }
  @feature_identities ~w(authored-policy native-baseline progressive-enhancement exclusive-grouping details-content interpolate-size fallback)
  @semantic_exceptions ~w(content.radio_panels overlays.dropdown-actions media.carousel media.cover-flow)
  @required_presentation_keys ~w(description how_it_works features support_rows exact_fallback counterpart status)a
  @required_feature_keys ~w(identity label description reference evidence fallback)a
  @required_support_keys ~w(identity feature evidence fallback)a
  @cosmetic_keys ~w(class classes class_name css)a
  @category_descriptions %{
    "foundation" =>
      "Foundational controls and content surfaces with native semantics and closed visual choices.",
    "forms" =>
      "Native form primitives, controls, validation relationships, and measurement surfaces.",
    "disclosure" => "Native disclosure with independent and progressively exclusive grouping.",
    "navigation" => "Destination navigation and caller-heading-preserving header compositions.",
    "content-surfaces" =>
      "Native scrolling, honest separation, and radio-based content selection.",
    "overlays" =>
      "Native modal dialogs and nonmodal popovers with explicit ordinary alternatives.",
    "interactive-surfaces" =>
      "Supplemental descriptions and link previews whose required information stays visible.",
    "media" =>
      "Native scrollable media and dialog compositions with complete static alternatives.",
    "motion" =>
      "Complete static content with optional bounded decorative previews and entrance effects."
  }
  @composition_descriptions %{
    image_gallery:
      "A complete image-gallery composition with local media, captions, destinations, and a native dialog viewer.",
    motion_preferences:
      "A gallery-only motion-preference composition with complete content in system and reduced modes.",
    media_browser:
      "A complete media-browser composition that retains native scrolling and ordinary destinations.",
    motion_media_capabilities:
      "An authored capability record for motion and media enhancement gates and exact fallbacks.",
    overlay_capabilities:
      "An authored matrix of overlay capability gates, evidence, and ordinary alternatives.",
    settings_confirmation:
      "A settings flow showing caller-owned confirmation and native dialog responsibilities.",
    responsive_drawers:
      "Responsive details and filters with a useful bounded dialog or normal-flow fallback.",
    anchored_actions:
      "Document actions whose anchors and native controls remain useful without optional placement.",
    supplemental_help:
      "Supplemental help that preserves complete visible guidance and ordinary destinations.",
    documentation:
      "The checked fixture for reusable documentation prose, badges, specimens, source, and support surfaces.",
    settings: "A complete settings composition built from public form and content components.",
    application_shell:
      "A complete application-shell composition with caller-owned navigation, headings, and actions."
  }
  @accordion_route "/components/disclosure/accordion"
  @accordion_evidence "demo/priv/reference/milestone_g/phase-05-accordion-evidence.json"
  @phase_7_1_prefixes ["/components/foundation/", "/components/forms/"]
  @phase_7_1_evidence "demo/priv/reference/milestone_g/phase-07-section-1-evidence.json"
  @phase_7_2_prefixes [
    "/components/navigation/",
    "/components/content-surfaces/",
    "/components/overlays/",
    "/components/interactive-surfaces/"
  ]
  @phase_7_2_routes ~w(
    /examples/documentation
    /examples/settings
    /examples/application-shell
    /examples/overlay-capabilities
    /examples/settings-confirmation
    /examples/responsive-drawers
    /examples/anchored-actions
    /examples/supplemental-help
  )
  @phase_7_2_evidence "demo/priv/reference/milestone_g/phase-07-section-2-evidence.json"
  @phase_7_3_prefixes ["/components/media/", "/components/motion/"]
  @phase_7_3_routes ~w(
    /examples/image-gallery
    /examples/motion-preferences
    /examples/media-browser
    /examples/motion-media-capabilities
  )
  @phase_7_3_evidence "demo/priv/reference/milestone_g/phase-07-section-3-evidence.json"
  @phase_7_4_evidence "demo/priv/reference/milestone_g/phase-07-section-4-evidence.json"
  @provenance_manifest @package_root
                       |> Path.join("priv/provenance/unscripted_ui.json")
                       |> File.read!()
                       |> Jason.decode!()
  @available_visual_evidence [
                               @accordion_evidence,
                               @phase_7_1_evidence,
                               @phase_7_2_evidence,
                               @phase_7_3_evidence,
                               @phase_7_4_evidence
                             ]
                             |> Map.new(&{&1, File.regular?(Path.join(@package_root, &1))})

  @spec layout_identities() :: [String.t()]
  def layout_identities, do: Map.keys(@layout_classes) |> Enum.sort()

  @spec feature_identities() :: [String.t()]
  def feature_identities, do: @feature_identities

  @doc "Resolves a closed layout identity to its complete static class string."
  @spec layout_class!(String.t()) :: String.t()
  def layout_class!(identity) when is_binary(identity) do
    case Map.fetch(@layout_classes, identity) do
      {:ok, class} -> class
      :error -> raise ArgumentError, "unknown presentation layout identity"
    end
  end

  def layout_class!(_identity), do: raise(ArgumentError, "unknown presentation layout identity")

  @doc "Resolves a feature only from the article's closed authored list."
  @spec feature(map(), String.t()) :: {:ok, map()} | :error
  def feature(%{features: features}, identity) when is_list(features) and is_binary(identity) do
    case Enum.find(features, &(&1.identity == identity)) do
      nil -> :error
      feature -> {:ok, feature}
    end
  end

  def feature(_presentation, _identity), do: :error

  @doc "Returns factual, non-inferred migration and acceptance states for a route."
  @spec status(String.t()) :: map()
  def status(@accordion_route) do
    %{
      authored_ready: true,
      migrated: true,
      visually_reviewed: true,
      accepted: true,
      migration_wave: "5",
      visual_evidence: [@accordion_evidence]
    }
  end

  def status(route) when is_binary(route) do
    cond do
      Enum.any?(@phase_7_1_prefixes, &String.starts_with?(route, &1)) ->
        %{
          authored_ready: true,
          migrated: true,
          visually_reviewed: true,
          accepted: false,
          migration_wave: "7.1",
          visual_evidence: [@phase_7_1_evidence]
        }

      Enum.any?(@phase_7_2_prefixes, &String.starts_with?(route, &1)) or
          route in @phase_7_2_routes ->
        %{
          authored_ready: true,
          migrated: true,
          visually_reviewed: true,
          accepted: false,
          migration_wave: "7.2",
          visual_evidence: [@phase_7_2_evidence]
        }

      Enum.any?(@phase_7_3_prefixes, &String.starts_with?(route, &1)) or
          route in @phase_7_3_routes ->
        %{
          authored_ready: true,
          migrated: true,
          visually_reviewed: true,
          accepted: false,
          migration_wave: "7.3",
          visual_evidence: [@phase_7_3_evidence]
        }

      route == "/" or Enum.any?(Catalogue.categories(), &(&1.path == route)) ->
        %{
          authored_ready: true,
          migrated: true,
          visually_reviewed: true,
          accepted: false,
          migration_wave: "7.4",
          visual_evidence: [@phase_7_4_evidence]
        }

      true ->
        %{
          authored_ready: true,
          migrated: false,
          visually_reviewed: false,
          accepted: false,
          migration_wave: nil,
          visual_evidence: []
        }
    end
  end

  def status(_route), do: status("")

  @doc "Returns pinned upstream counterpart records keyed by provenance identity."
  @spec counterparts() :: %{String.t() => map()}
  def counterparts do
    upstream = Map.fetch!(@provenance_manifest, "upstream")

    Map.new(Map.fetch!(@provenance_manifest, "adaptations"), fn adaptation ->
      identity = Map.fetch!(adaptation, "id")

      {identity,
       %{
         identity: identity,
         kind:
           if(identity in @semantic_exceptions,
             do: "semantic-exception",
             else: "upstream-counterpart"
           ),
         repository: Map.fetch!(upstream, "repository"),
         revision: Map.fetch!(upstream, "commit"),
         upstream_paths: Map.fetch!(adaptation, "upstreamPaths"),
         local_changes: Map.fetch!(adaptation, "localChanges")
       }}
    end)
  end

  @doc "Builds one literal component-article presentation record."
  @spec article(atom(), atom(), map(), map()) :: map()
  def article(:accordion, function, reference, counterpart) do
    features = [
      feature_record(
        "native-baseline",
        "Native disclosure",
        reference.native_baseline,
        "documentation.native_baseline",
        "Locked Chromium, Firefox, and WebKit exercise native details and summary operation.",
        reference.fallback
      ),
      feature_record(
        "exclusive-grouping",
        "Exclusive grouping",
        reference.capability,
        "reference.capability",
        reference.exclusive_evidence,
        reference.exclusive_fallback
      ),
      feature_record(
        "details-content",
        "Animated content",
        reference.details_content,
        "reference.details_content",
        reference.details_content_evidence,
        reference.motion_fallback
      ),
      feature_record(
        "interpolate-size",
        "Intrinsic size",
        reference.interpolate_size,
        "reference.interpolate_size",
        reference.interpolate_size_evidence,
        reference.motion_fallback
      ),
      feature_record(
        "fallback",
        "Exact fallback",
        reference.fallback,
        "documentation.fallback",
        "The same locked-engine matrix verifies useful native disclosure outcomes.",
        reference.fallback
      )
    ]

    %{
      description: reference.what,
      how_it_works: [
        %{code: "<details><summary>", description: reference.native_baseline},
        %{code: ~s(name="faq"), description: reference.capability},
        %{code: "open", description: reference.open_state},
        %{code: "id + item key", description: reference.stable_identity},
        %{code: "application boundary", description: reference.responsibilities}
      ],
      features: features,
      support_rows:
        support_rows(features, ~w(exclusive-grouping details-content interpolate-size)),
      exact_fallback: reference.fallback,
      counterpart: counterpart,
      defining_function: Atom.to_string(function)
    }
  end

  def article(_render, function, reference, counterpart) do
    features =
      [
        feature_record(
          "native-baseline",
          "Native baseline",
          reference.native_baseline,
          "documentation.native_baseline",
          "Reviewed in the locked Chromium, Firefox, and WebKit evidence matrix.",
          reference.fallback
        )
      ] ++
        progressive_feature(reference) ++
        [
          feature_record(
            "fallback",
            "Exact fallback",
            reference.fallback,
            "documentation.fallback",
            "The locked-engine matrix retains the documented native or static outcome.",
            reference.fallback
          )
        ]

    %{
      description: reference.what,
      how_it_works: [
        %{code: "<.#{function}>", description: reference.native_baseline},
        %{code: "package CSS", description: reference.package_enhancement},
        %{code: "gallery only", description: reference.demo_behavior},
        %{code: "application boundary", description: reference.unsupported}
      ],
      features: features,
      support_rows: support_rows(features, Enum.map(features, & &1.identity)),
      exact_fallback: reference.fallback,
      counterpart: counterpart,
      defining_function: Atom.to_string(function)
    }
  end

  @doc "Returns presentation readiness data for every closed gallery route."
  @spec inventory([map()]) :: [map()]
  def inventory(component_entries) when is_list(component_entries) do
    components = Map.new(component_entries, &{&1.route, component_inventory(&1)})

    Catalogue.routes()
    |> Enum.map(fn route ->
      case Map.fetch(components, route) do
        {:ok, component} -> component
        :error -> page_inventory(route)
      end
    end)
  end

  @doc "Audits complete route coverage and factual readiness-state ordering."
  @spec audit_inventory([map()]) :: :ok | {:error, [String.t()]}
  def audit_inventory(inventory) when is_list(inventory) do
    routes = Enum.map(inventory, & &1.route)
    expected = Catalogue.routes()

    errors =
      []
      |> require(
        routes == expected,
        "presentation inventory route order does not match catalogue"
      )
      |> Kernel.++(
        inventory
        |> Enum.flat_map(fn record ->
          status = record.status

          []
          |> require(nonempty?(record.description), "missing route description: #{record.route}")
          |> require(record.features != [], "missing route features: #{record.route}")
          |> require(record.support_rows != [], "missing route support: #{record.route}")
          |> require(nonempty?(record.exact_fallback), "missing route fallback: #{record.route}")
          |> require(status.authored_ready, "route is not authored-ready: #{record.route}")
          |> require(
            not status.migrated or status.authored_ready,
            "migrated route is not authored-ready: #{record.route}"
          )
          |> require(
            not status.visually_reviewed or status.migrated,
            "reviewed route is not migrated: #{record.route}"
          )
          |> require(
            not status.accepted or status.visually_reviewed,
            "accepted route is not reviewed: #{record.route}"
          )
          |> require(
            status.visual_evidence != [] or not status.visually_reviewed,
            "reviewed route lacks visual evidence: #{record.route}"
          )
          |> require(
            Enum.all?(status.visual_evidence, fn path ->
              Map.get(@available_visual_evidence, path, false)
            end),
            "route has missing visual evidence: #{record.route}"
          )
        end)
      )
      |> Enum.sort()

    if errors == [], do: :ok, else: {:error, errors}
  end

  @doc "Audits declared presentation records and their specimen relationships."
  @spec audit([map()]) :: :ok | {:error, [String.t()]}
  def audit(entries) when is_list(entries) do
    errors =
      entries
      |> Enum.flat_map(&entry_errors/1)
      |> Enum.sort()

    if errors == [], do: :ok, else: {:error, errors}
  end

  defp progressive_feature(reference) do
    if Map.has_key?(reference, :capability) do
      [
        feature_record(
          "progressive-enhancement",
          "Progressive enhancement",
          reference.package_enhancement,
          "documentation.package_enhancement",
          "The locked-engine evidence exercises the authored complete capability gate.",
          reference.fallback
        )
      ]
    else
      []
    end
  end

  defp component_inventory(entry) do
    presentation = entry.presentation

    %{
      route: entry.route,
      kind: "component",
      identity: entry.provenance_id,
      label: entry.label,
      description: presentation.description,
      specimens: entry.examples,
      features: presentation.features,
      support_rows: presentation.support_rows,
      exact_fallback: presentation.exact_fallback,
      counterpart: presentation.counterpart,
      exception:
        if(presentation.counterpart.kind == "semantic-exception",
          do: "accepted-semantic-exception",
          else: nil
        ),
      status: presentation.status
    }
  end

  defp page_inventory("/") do
    local_page(
      "/",
      "landing",
      "gallery.landing",
      "ShadcnUI gallery",
      "Transport-neutral Phoenix components with shadcn-style semantic tokens and complete ordinary routes."
    )
  end

  defp page_inventory(route) do
    case Enum.find(Catalogue.categories(), &(&1.path == route)) do
      nil ->
        composition_inventory(route)

      category ->
        local_page(
          route,
          "category",
          "gallery.category.#{category.slug}",
          category.label,
          Map.fetch!(@category_descriptions, category.slug)
        )
    end
  end

  defp composition_inventory(route) do
    composition = Enum.find(Catalogue.compositions(), &(&1.path == route))

    local_page(
      route,
      "composition",
      "gallery.composition.#{composition.slug}",
      composition.label,
      Map.fetch!(@composition_descriptions, composition.render)
    )
  end

  defp local_page(route, kind, identity, label, description) do
    fallback =
      "Without optional gallery presentation, complete content and ordinary destinations remain in document order."

    feature =
      feature_record(
        "native-baseline",
        "Semantic page baseline",
        "The route renders authored landmarks, headings, content, and ordinary destinations.",
        "gallery.route",
        "Controller and static-export tests exercise the same closed route.",
        fallback
      )

    %{
      route: route,
      kind: kind,
      identity: identity,
      label: label,
      description: description,
      specimens: [],
      features: [feature],
      support_rows: support_rows([feature], [feature.identity]),
      exact_fallback: fallback,
      counterpart: %{
        identity: identity,
        kind: "local-only",
        repository: nil,
        revision: nil,
        upstream_paths: [],
        local_changes:
          "Gallery-only authored route; no package API or upstream component counterpart."
      },
      exception: "gallery-route-without-component-specimens",
      status: status(route)
    }
  end

  defp feature_record(identity, label, description, reference, evidence, fallback) do
    %{
      identity: identity,
      label: label,
      description: description,
      reference: reference,
      evidence: evidence,
      fallback: fallback
    }
  end

  defp support_rows(features, identities) do
    Enum.map(identities, fn identity ->
      feature = Enum.find(features, &(&1.identity == identity))

      %{
        identity: identity,
        feature: feature.label,
        evidence: feature.evidence,
        fallback: feature.fallback
      }
    end)
  end

  defp entry_errors(entry) do
    presentation = Map.get(entry, :presentation)

    specimen_errors(entry) ++
      if is_nil(presentation),
        do: ["missing presentation: #{entry.route}"],
        else: presentation_errors(entry, presentation)
  end

  defp specimen_errors(entry) do
    examples = Map.get(entry, :examples, [])

    duplicate_messages(examples, :specimen_id, "duplicate specimen id", entry.route) ++
      duplicate_messages(examples, :fragment, "duplicate preview fragment", entry.route) ++
      duplicate_messages(examples, :source_fragment, "duplicate source fragment", entry.route) ++
      Enum.flat_map(examples, fn example ->
        []
        |> require(example[:specimen_id], "missing specimen id: #{entry.route}")
        |> require(
          example[:component_identity] == entry.provenance_id,
          "invalid specimen component identity: #{entry.route}"
        )
        |> require(
          example[:preview_fragment] == example[:fragment],
          "invalid specimen preview fragment: #{entry.route}"
        )
        |> require(
          example[:source_fragment] == "#{example[:fragment]}-source",
          "invalid specimen fragment pair: #{entry.route}"
        )
        |> require(
          example[:source_relationship] == example[:source_id],
          "invalid specimen source relationship: #{entry.route}"
        )
        |> require(
          example[:source_compile] == entry.verification.source_compile,
          "invalid specimen compile relationship: #{entry.route}"
        )
        |> require(
          example[:layout] in layout_identities(),
          "unknown specimen layout: #{entry.route}"
        )
        |> require(nonempty?(example[:source]), "missing specimen source: #{entry.route}")
      end)
  end

  defp presentation_errors(entry, presentation) when is_map(presentation) do
    features = Map.get(presentation, :features, [])
    support_rows = Map.get(presentation, :support_rows, [])
    counterpart = Map.get(presentation, :counterpart, %{})

    []
    |> require(
      Enum.all?(@required_presentation_keys, &Map.has_key?(presentation, &1)),
      "incomplete presentation: #{entry.route}"
    )
    |> require(
      nonempty?(presentation[:description]),
      "missing presentation description: #{entry.route}"
    )
    |> require(nonempty?(presentation[:exact_fallback]), "missing exact fallback: #{entry.route}")
    |> require(
      nonempty_list?(presentation[:how_it_works]),
      "missing how-it-works points: #{entry.route}"
    )
    |> require(nonempty_list?(features), "missing presentation features: #{entry.route}")
    |> require(nonempty_list?(support_rows), "missing support rows: #{entry.route}")
    |> require(
      counterpart[:identity] == entry.provenance_id,
      "invalid upstream mapping: #{entry.route}"
    )
    |> require(
      counterpart[:kind] in ~w(upstream-counterpart semantic-exception local-only),
      "invalid counterpart kind: #{entry.route}"
    )
    |> require(
      nonempty_string_list?(counterpart[:upstream_paths]) or counterpart[:kind] == "local-only",
      "missing upstream paths: #{entry.route}"
    )
    |> require(
      no_cosmetic_keys?(presentation),
      "cosmetic class leaked into presentation metadata: #{entry.route}"
    )
    |> Kernel.++(duplicate_messages(features, :identity, "duplicate feature", entry.route))
    |> Kernel.++(
      duplicate_messages(support_rows, :identity, "duplicate support row", entry.route)
    )
    |> Kernel.++(feature_errors(features, entry.route))
    |> Kernel.++(support_errors(support_rows, features, entry.route))
  end

  defp presentation_errors(entry, _presentation),
    do: ["invalid presentation record: #{entry.route}"]

  defp feature_errors(features, route) do
    Enum.flat_map(features, fn feature ->
      []
      |> require(
        Enum.all?(@required_feature_keys, &Map.has_key?(feature, &1)),
        "incomplete feature: #{route}"
      )
      |> require(feature[:identity] in @feature_identities, "unknown feature identity: #{route}")
      |> require(
        Enum.all?(@required_feature_keys -- [:identity], &nonempty?(feature[&1])),
        "missing feature content: #{route}"
      )
    end)
  end

  defp support_errors(rows, features, route) do
    identities = MapSet.new(features, & &1.identity)

    Enum.flat_map(rows, fn row ->
      []
      |> require(
        Enum.all?(@required_support_keys, &Map.has_key?(row, &1)),
        "incomplete support row: #{route}"
      )
      |> require(MapSet.member?(identities, row[:identity]), "unknown support feature: #{route}")
      |> require(
        Enum.all?(@required_support_keys, &nonempty?(row[&1])),
        "missing support content: #{route}"
      )
    end)
  end

  defp duplicate_messages(records, key, label, route) do
    records
    |> Enum.map(&Map.get(&1, key))
    |> Enum.reject(&is_nil/1)
    |> Enum.frequencies()
    |> Enum.filter(fn {_value, count} -> count > 1 end)
    |> Enum.map(fn {value, _count} -> "#{label}: #{route}: #{value}" end)
  end

  defp no_cosmetic_keys?(value) when is_map(value) do
    Enum.all?(value, fn {key, nested} ->
      key not in @cosmetic_keys and no_cosmetic_keys?(nested)
    end)
  end

  defp no_cosmetic_keys?(value) when is_list(value), do: Enum.all?(value, &no_cosmetic_keys?/1)
  defp no_cosmetic_keys?(_value), do: true

  defp require(errors, value, message) do
    if value, do: errors, else: [message | errors]
  end

  defp nonempty?(value), do: is_binary(value) and String.trim(value) != ""
  defp nonempty_list?(value), do: is_list(value) and value != [] and Enum.all?(value, &is_map/1)

  defp nonempty_string_list?(value),
    do: is_list(value) and value != [] and Enum.all?(value, &nonempty?/1)
end
