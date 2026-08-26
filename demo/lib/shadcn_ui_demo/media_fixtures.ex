defmodule ShadcnUIDemo.MediaFixtures do
  @moduledoc "Closed original demo assets; never distributed with the component package."
  @manifest_path Path.expand("../../priv/media/fixtures.json", __DIR__)
  @root Path.expand("../../priv/static/media", __DIR__)
  @external_resource @manifest_path
  @manifest Jason.decode!(File.read!(@manifest_path))
  def manifest, do: @manifest
  def root, do: @root
  def entries, do: @manifest["entries"]
  def failures, do: @manifest["failures"]
  def validate!, do: validate!(@manifest, @root)

  def validate!(manifest, root) do
    unless manifest["schemaVersion"] == 1 and
             Map.keys(manifest) |> Enum.sort() == ~w(entries failures schemaVersion),
           do: raise(ArgumentError, "invalid media manifest")

    entries = manifest["entries"]
    unless is_list(entries) and entries != [], do: raise(ArgumentError, "empty fixture inventory")
    files = Enum.map(entries, & &1["file"])
    keys = Enum.map(entries, & &1["key"])

    unless Enum.uniq(files) == files and Enum.uniq(keys) == keys,
      do: raise(ArgumentError, "duplicate fixture")

    unless File.lstat!(root).type == :directory,
      do: raise(ArgumentError, "fixture root must be a real directory")

    unless Enum.sort(File.ls!(root)) == Enum.sort(files),
      do: raise(ArgumentError, "unlisted fixture files")

    Enum.map(entries, fn entry ->
      unless Map.keys(entry) |> Enum.sort() ==
               ~w(alt bytes file height key license mime sha256 source width),
             do: raise(ArgumentError, "unknown fixture metadata")

      unless is_binary(entry["file"]) and Regex.match?(~r/^[a-z][a-z0-9-]*\.svg$/, entry["file"]),
        do: raise(ArgumentError, "unsafe fixture filename")

      for field <- ~w(key alt license source) do
        unless is_binary(entry[field]) and String.trim(entry[field]) != "",
          do: raise(ArgumentError, "missing fixture #{field}")
      end

      unless entry["mime"] == "image/svg+xml",
        do: raise(ArgumentError, "unsupported fixture MIME")

      path = Path.join(root, entry["file"])

      unless File.lstat!(path).type == :regular,
        do: raise(ArgumentError, "fixture symlinks are forbidden")

      bytes = File.read!(path)

      unless byte_size(bytes) == entry["bytes"] and sha256(bytes) == entry["sha256"],
        do: raise(ArgumentError, "fixture hash/size mismatch")

      for dimension <- ~w(width height) do
        value = entry[dimension]

        unless is_integer(value) and value > 0 and
                 String.contains?(bytes, "#{dimension}=\"#{value}\""),
               do: raise(ArgumentError, "fixture dimension mismatch")
      end

      # Closed original SVGs are shapes only; never copy active/external SVG content.
      tags =
        Regex.scan(~r/<\/?([A-Za-z][^\s\/>]*)/, bytes, capture: :all_but_first) |> List.flatten()

      attrs =
        Regex.scan(~r/\s([A-Za-z][A-Za-z0-9:-]*)\s*=/, bytes, capture: :all_but_first)
        |> List.flatten()

      unless Enum.all?(tags, &(&1 in ~w(svg rect circle path))) and
               Enum.all?(
                 attrs,
                 &(&1 in ~w(xmlns width height viewBox fill cx cy r d stroke stroke-width))
               ) and
               not String.contains?(bytes, ["<!", "<?", "&", "\\"]),
             do: raise(ArgumentError, "fixture must use the closed original shape profile")

      if Regex.match?(
           ~r/<(?:script|foreignObject|image|use|style)\b|\bon\w+\s*=|(?:href|url)\s*[=(]/i,
           bytes
         ),
         do: raise(ArgumentError, "active SVG content")

      {entry, bytes}
    end)
  end

  defp sha256(bytes), do: :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)
end
