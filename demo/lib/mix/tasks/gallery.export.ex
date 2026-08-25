defmodule Mix.Tasks.Gallery.Export do
  use Mix.Task

  @shortdoc "Exports the closed controller-rendered gallery route inventory"
  @output "export"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    File.rm_rf!(@output)
    File.mkdir_p!(@output)

    entries =
      default_entries() ++
        Enum.flat_map(["light", "dark", "invalid"], fn theme -> theme_entries(theme) end) ++
        [export_entry("/__gallery-not-found__", "404.html", 404)]

    copy_assets!()
    write_sitemap!()
    reject_unexpected_output!()

    manifest = %{
      "schemaVersion" => 1,
      "assets" => asset_hashes(),
      "routes" => entries
    }

    File.write!(Path.join(@output, "route-manifest.json"), Jason.encode_to_iodata!(manifest, pretty: true))
  end

  defp default_entries do
    gallery = Enum.map(ShadcnUIDemo.Catalogue.routes(), &export_entry(&1, route_file(&1), 200))
    forms = Enum.map(ShadcnUIDemo.Catalogue.form_routes(), &export_entry(&1 <> "?static=1", route_file(&1), 200))
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
    |> String.replace(~s(href="/), ~s(href="#{prefix}))
    |> String.replace(~s(src="/), ~s(src="#{prefix}))
  end

  defp copy_assets! do
    source = Application.app_dir(:shadcn_ui_demo, "priv/static/assets")
    target = Path.join(@output, "assets")
    File.mkdir_p!(target)

    source
    |> File.ls!()
    |> Enum.filter(&Regex.match?(~r/^(?:shadcn|gallery)-[a-f0-9]{16}\.(?:css|js)$/, &1))
    |> Enum.sort()
    |> Enum.each(&File.cp!(Path.join(source, &1), Path.join(target, &1)))
  end

  defp asset_hashes do
    @output
    |> Path.join("assets/*")
    |> Path.wildcard()
    |> Enum.sort()
    |> Map.new(fn path -> {Path.basename(path), sha256(File.read!(path))} end)
  end

  defp reject_remote_runtime!(html, route) do
    if Regex.match?(~r/(?:src|href)="https?:\/\//i, html),
      do: Mix.raise("remote runtime URL found in #{route}")
  end

  defp reject_unexpected_output! do
    allowed = ~r/(?:\.html|\.css|\.js|sitemap\.xml|route-manifest\.json)$/

    @output
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(&File.regular?/1)
    |> Enum.reject(&Regex.match?(allowed, &1))
    |> case do
      [] -> :ok
      files -> Mix.raise("unexpected export files: #{inspect(files)}")
    end
  end

  defp write_sitemap! do
    base = "https://leco-industries-inc.github.io/leco_apps/shadcn-ui"

    urls =
      (ShadcnUIDemo.Catalogue.routes() ++ ShadcnUIDemo.Catalogue.form_routes())
      |> Enum.map_join("", &"<url><loc>#{base}#{&1}</loc></url>")

    File.write!(Path.join(@output, "sitemap.xml"), "<?xml version=\"1.0\" encoding=\"UTF-8\"?><urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">#{urls}</urlset>")
  end

  defp sha256(content), do: :crypto.hash(:sha256, content) |> Base.encode16(case: :lower)
end
