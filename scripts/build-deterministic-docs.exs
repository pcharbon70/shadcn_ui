# ExDoc delegates Makeup highlighting to processes with independently seeded
# RNGs. Normalize those presentation-only delimiter prefixes after generation.
# EPUB UUIDs are also random, so the reproducible candidate publishes the HTML
# and Markdown documentation formats and does not claim deterministic EPUB.
File.rm_rf!("doc")

Mix.Task.run("docs", [
  "--warnings-as-errors",
  "--formatter",
  "html",
  "--formatter",
  "markdown"
])

pattern = ~r/data-group-id="([0-9]{10})-([0-9]+)"/

for path <- Path.wildcard("doc/**/*.html") do
  html = File.read!(path)

  prefixes =
    pattern
    |> Regex.scan(html, capture: :all_but_first)
    |> Enum.map(&hd/1)
    |> Enum.uniq()
    |> Enum.with_index(1)
    |> Map.new(fn {prefix, index} -> {prefix, "release-#{index}"} end)

  normalized =
    Regex.replace(pattern, html, fn _match, prefix, suffix ->
      ~s(data-group-id="#{Map.fetch!(prefixes, prefix)}-#{suffix}")
    end)

  File.write!(path, normalized)
end
