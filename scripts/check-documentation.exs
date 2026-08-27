doc_root = Path.expand("doc")

required_pages =
  ~w(readme components installation compatibility integrations upgrading provenance changelog third_party_notices release)
  |> Enum.map(&Path.join(doc_root, &1 <> ".html"))

missing = Enum.reject(required_pages, &File.regular?/1)
if missing != [], do: raise("Missing generated documentation pages: #{inspect(missing)}")

internal_modules = [
  "ShadcnUI.Components.Forms.FormContract",
  "ShadcnUI.Components.Forms.Select",
  "ShadcnUI.Components.Forms.SelectOptions",
  "ShadcnUI.Components.Media.MediaContract",
  "ShadcnUI.Components.Motion.MotionContract",
  "ShadcnUI.Components.Overlays.OverlayContract",
  "ShadcnUI.Components.Overlays.SupplementalContract"
]

generated_names =
  doc_root
  |> Path.join("*.html")
  |> Path.wildcard()
  |> Enum.map(&Path.basename(&1, ".html"))
  |> MapSet.new()

for module <- internal_modules do
  if MapSet.member?(generated_names, module),
    do: raise("Internal module leaked into ExDoc: #{module}")
end

broken =
  doc_root
  |> Path.join("*.html")
  |> Path.wildcard()
  |> Enum.flat_map(fn page ->
    source = File.read!(page)

    ~r/href="([^"]+\.html(?:#[^"]*)?)"/
    |> Regex.scan(source, capture: :all_but_first)
    |> List.flatten()
    |> Enum.reject(&String.starts_with?(&1, ["http://", "https://"]))
    |> Enum.map(&(String.split(&1, "#", parts: 2) |> hd()))
    |> Enum.reject(fn target -> File.regular?(Path.expand(target, Path.dirname(page))) end)
    |> Enum.map(&{Path.basename(page), &1})
  end)

if broken != [], do: raise("Broken generated documentation links: #{inspect(broken)}")

IO.puts("Documentation audit verified #{MapSet.size(generated_names)} generated HTML pages")
