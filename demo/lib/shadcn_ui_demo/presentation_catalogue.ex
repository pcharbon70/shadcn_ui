defmodule ShadcnUIDemo.PresentationCatalogue do
  @moduledoc """
  Closed, demo-only presentation identities for documentation articles.

  Presentation prose remains inert data. Layout identities resolve only through
  complete static class strings owned by this module, and no request text is
  converted to atoms, modules, callbacks, templates, or asset paths.
  """

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
  @required_presentation_keys ~w(description how_it_works features support_rows exact_fallback counterpart)a
  @required_feature_keys ~w(identity label description reference evidence fallback)a
  @required_support_keys ~w(identity feature evidence fallback)a
  @cosmetic_keys ~w(class classes class_name css)a

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

  @doc "Returns pinned upstream counterpart records keyed by provenance identity."
  @spec counterparts() :: %{String.t() => map()}
  def counterparts do
    manifest =
      @package_root
      |> Path.join("priv/provenance/unscripted_ui.json")
      |> File.read!()
      |> Jason.decode!()

    upstream = Map.fetch!(manifest, "upstream")

    Map.new(Map.fetch!(manifest, "adaptations"), fn adaptation ->
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
      if is_nil(presentation), do: [], else: presentation_errors(entry, presentation)
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
