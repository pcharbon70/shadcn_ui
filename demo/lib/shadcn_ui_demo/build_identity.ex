defmodule ShadcnUIDemo.BuildIdentity do
  @moduledoc """
  Validated immutable identity for one gallery build.

  The revision is injected through demo configuration. This module never shells
  out to Git, performs a network request, or adds state to the ShadcnUI package.
  """

  alias ShadcnUIDemo.DocumentationCatalogue

  @development_revision String.duplicate("0", 40)
  @revision_pattern ~r/^[0-9a-f]{40}$/
  @version_pattern ~r/^(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?$/
  @schema_pattern ~r/^[1-9]\d*$/

  @type t :: %{
          package_version: String.t(),
          build_revision: String.t(),
          catalogue_schema: String.t(),
          upstream_revision: String.t(),
          development: boolean()
        }

  @spec development_revision() :: String.t()
  def development_revision, do: @development_revision

  @spec current() :: {:ok, t()} | {:error, [String.t()]}
  def current do
    new(%{
      package_version: Application.spec(:shadcn_ui, :vsn) |> to_string(),
      build_revision:
        Application.get_env(:shadcn_ui_demo, :build_revision, @development_revision),
      catalogue_schema: DocumentationCatalogue.schema_version(),
      upstream_revision: upstream_revision()
    })
  end

  @spec current!() :: t()
  def current! do
    case current() do
      {:ok, identity} -> identity
      {:error, errors} -> raise ArgumentError, Enum.join(errors, "; ")
    end
  end

  @spec new(map()) :: {:ok, t()} | {:error, [String.t()]}
  def new(values) when is_map(values) do
    identity = %{
      package_version: Map.get(values, :package_version),
      build_revision: Map.get(values, :build_revision),
      catalogue_schema: Map.get(values, :catalogue_schema),
      upstream_revision: Map.get(values, :upstream_revision)
    }

    errors =
      []
      |> validate_field(:package_version, identity.package_version, @version_pattern)
      |> validate_field(:build_revision, identity.build_revision, @revision_pattern)
      |> validate_field(:catalogue_schema, identity.catalogue_schema, @schema_pattern)
      |> validate_field(:upstream_revision, identity.upstream_revision, @revision_pattern)
      |> Enum.sort()

    case errors do
      [] ->
        {:ok, Map.put(identity, :development, identity.build_revision == @development_revision)}

      errors ->
        {:error, errors}
    end
  end

  def new(_values), do: {:error, ["identity input must be a map"]}

  @spec release_metadata(t()) :: map()
  def release_metadata(identity) do
    %{
      "packageVersion" => identity.package_version,
      "buildRevision" => identity.build_revision,
      "catalogueSchema" => identity.catalogue_schema,
      "upstreamRevision" => identity.upstream_revision,
      "development" => identity.development
    }
  end

  @spec health_metadata(t()) :: map()
  def health_metadata(identity) do
    %{
      "identity" => release_metadata(identity),
      "expectedChecks" => ["catalogue", "routes", "assets"],
      "runtime" => "static"
    }
  end

  defp validate_field(errors, field, value, pattern) when is_binary(value) do
    if Regex.match?(pattern, value), do: errors, else: ["invalid #{field}" | errors]
  end

  defp validate_field(errors, field, _value, _pattern), do: ["invalid #{field}" | errors]

  defp upstream_revision do
    :shadcn_ui
    |> Application.app_dir("priv/provenance/unscripted_ui.json")
    |> File.read!()
    |> Jason.decode!()
    |> get_in(["upstream", "commit"])
  end
end
