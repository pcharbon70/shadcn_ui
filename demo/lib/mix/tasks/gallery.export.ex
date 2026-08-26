defmodule Mix.Tasks.Gallery.Export do
  use Mix.Task

  @shortdoc "Exports the closed controller-rendered gallery route inventory"
  @output "export"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    expected = Path.expand("../../../export", __DIR__)
    unless Path.expand(@output) == expected, do: Mix.raise("export must run from the demo root")

    if File.exists?(@output) and File.lstat!(@output).type != :directory,
      do: Mix.raise("export target must be a real directory")

    File.rm_rf!(@output)
    File.mkdir_p!(@output)

    entries =
      default_entries() ++
        Enum.flat_map(["light", "dark", "invalid"], fn theme -> theme_entries(theme) end) ++
        preference_entries() ++
        [export_entry("/__gallery-not-found__", "404.html", 404)]

    copy_assets!()
    copy_media!()
    write_sitemap!()
    reject_unexpected_output!(entries)

    manifest = %{
      "schemaVersion" => 1,
      "assets" => asset_hashes(),
      "media" =>
        Map.new(
          ShadcnUIDemo.MediaFixtures.entries(),
          &{&1["file"], Map.take(&1, ~w(mime sha256 bytes width height))}
        ),
      "routes" => entries
    }

    File.write!(
      Path.join(@output, "route-manifest.json"),
      Jason.encode_to_iodata!(manifest, pretty: true)
    )
  end

  defp default_entries do
    gallery = Enum.map(ShadcnUIDemo.Catalogue.routes(), &export_entry(&1, route_file(&1), 200))

    forms =
      Enum.map(
        ShadcnUIDemo.Catalogue.form_routes(),
        &export_entry(&1 <> "?static=1", route_file(&1), 200)
      )

    gallery ++ forms
  end

  defp theme_entries(theme) do
    query_theme = if theme == "invalid", do: "minty", else: theme

    Enum.map(ShadcnUIDemo.Catalogue.routes(), fn route ->
      export_entry(
        route <> "?theme=#{query_theme}",
        Path.join(["_themes", theme, route_file(route)]),
        200
      )
    end)
  end

  defp preference_entries do
    for theme <- ["light", "dark"],
        motion <- ["system", "reduce", "invalid"],
        route <- ShadcnUIDemo.Catalogue.routes() do
      query_motion = if motion == "invalid", do: "unexpected", else: motion

      export_entry(
        route <> "?theme=#{theme}&motion=#{query_motion}",
        Path.join(["_preferences", theme, motion, route_file(route)]),
        200
      )
    end
  end

  defp export_entry(request_path, output_file, expected_status) do
    conn = Plug.Test.conn(:get, request_path) |> ShadcnUIDemoWeb.Endpoint.call([])

    if conn.status != expected_status do
      Mix.raise("#{request_path} returned #{conn.status}, expected #{expected_status}")
    end

    html = rewrite_links(conn.resp_body, output_file)
    reject_remote_runtime!(html, request_path)
    target = Path.join(@output, output_file)
    File.mkdir_p!(Path.dirname(target))
    File.write!(target, html)

    %{
      "request" => request_path,
      "file" => String.replace(output_file, "\\", "/"),
      "status" => expected_status,
      "sha256" => sha256(html)
    }
  end

  defp route_file("/"), do: "index.html"
  defp route_file(route), do: Path.join(String.trim_leading(route, "/"), "index.html")

  defp rewrite_links(html, output_file) do
    depth = output_file |> Path.dirname() |> Path.split() |> Enum.reject(&(&1 == ".")) |> length()
    prefix = String.duplicate("../", depth)

    html
    |> then(
      &Regex.replace(
        ~r/((?:href|data-gallery-light-href|data-gallery-dark-href)=")(\/[^"]*)\?theme=(light|dark)&amp;motion=(system|reduce)"/,
        &1,
        fn _, attribute, route, theme, motion ->
          (attribute <> prefix <> Path.join(["_preferences", theme, motion, route_file(route)]))
          |> String.replace("\\", "/")
          |> Kernel.<>("\"")
        end
      )
    )
    |> then(
      &Regex.replace(~r/srcset="([^"]+)"/, &1, fn _, candidates ->
        rewritten =
          candidates
          |> String.split(",")
          |> Enum.map_join(", ", fn candidate ->
            String.trim(candidate) |> String.replace_prefix("/", prefix)
          end)

        ~s(srcset="#{rewritten}")
      end)
    )
    |> then(
      &Regex.replace(
        ~r/(<meta name="csrf-token" content=")[^"]+("\s*\/?>)/,
        &1,
        "\\1static-export\\2"
      )
    )
    |> String.replace(~s(href="/), ~s(href="#{prefix}))
    |> String.replace(~s(src="/), ~s(src="#{prefix}))
  end

  defp copy_assets! do
    source = Application.app_dir(:shadcn_ui_demo, "priv/static/assets")
    target = Path.join(@output, "assets")
    File.mkdir_p!(target)

    # Windows Mix builds may retain older copied priv files. Export only the
    # three assets actually selected by the closed compiled manifest.
    ~w(shadcn.css gallery.css gallery.js)
    |> Enum.map(&ShadcnUIDemoWeb.GalleryAssets.path/1)
    |> Enum.map(fn path ->
      unless Regex.match?(~r"^/assets/(?:shadcn|gallery)-[a-f0-9]{16}\.(?:css|js)$", path),
        do: Mix.raise("unexpected gallery asset path: #{path}")

      Path.basename(path)
    end)
    |> Enum.sort()
    |> Enum.each(&File.cp!(Path.join(source, &1), Path.join(target, &1)))
  end

  defp copy_media! do
    target = Path.join(@output, "media")
    File.mkdir_p!(target)

    for {entry, bytes} <- ShadcnUIDemo.MediaFixtures.validate!() do
      File.write!(Path.join(target, entry["file"]), bytes)
    end
  end

  defp asset_hashes do
    @output
    |> Path.join("assets/*")
    |> Path.wildcard()
    |> Enum.sort()
    |> Map.new(fn path -> {Path.basename(path), sha256(File.read!(path))} end)
  end

  defp reject_remote_runtime!(html, route) do
    # Ordinary source links and canonical metadata do not load runtime assets.
    runtime =
      html
      |> String.replace(~r/<a\b[^>]*>/i, "")
      |> String.replace(
        ~r/<link\s+rel="canonical"\s+href="https:\/\/leco-industries-inc\.github\.io\/shadcn_ui[^\"]*"\s*\/?\s*>/i,
        ""
      )

    if Regex.match?(~r/(?:src|href|srcset)="[^"]*(?:https?:)?\/\//i, runtime),
      do: Mix.raise("remote runtime URL found in #{route}")
  end

  defp reject_unexpected_output!(entries) do
    allowed =
      Enum.map(entries, &Path.join(@output, &1["file"])) ++
        Enum.map(Map.keys(asset_hashes()), &Path.join([@output, "assets", &1])) ++
        Enum.map(ShadcnUIDemo.MediaFixtures.entries(), &Path.join([@output, "media", &1["file"]])) ++
        [Path.join(@output, "sitemap.xml")]

    allowed = MapSet.new(Enum.map(allowed, &Path.expand/1))

    @output
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(&File.regular?/1)
    |> Enum.reject(&MapSet.member?(allowed, Path.expand(&1)))
    |> case do
      [] -> :ok
      files -> Mix.raise("unexpected export files: #{inspect(files)}")
    end
  end

  defp write_sitemap! do
    base = "https://leco-industries-inc.github.io/shadcn_ui"

    urls =
      (ShadcnUIDemo.Catalogue.routes() ++ ShadcnUIDemo.Catalogue.form_routes())
      |> Enum.map_join("", &"<url><loc>#{base}#{&1}</loc></url>")

    File.write!(
      Path.join(@output, "sitemap.xml"),
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">#{urls}</urlset>"
    )
  end

  defp sha256(content), do: :crypto.hash(:sha256, content) |> Base.encode16(case: :lower)
end
