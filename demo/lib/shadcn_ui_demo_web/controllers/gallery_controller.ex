defmodule ShadcnUIDemoWeb.GalleryController do
  use ShadcnUIDemoWeb, :controller

  alias ShadcnUIDemo.{BuildIdentity, Catalogue, DocumentationCatalogue, Reference}

  def landing(conn, params) do
    {:ok, presentation} = DocumentationCatalogue.lookup_presentation_route("/")

    featured_entries =
      ["foundation", "disclosure", "media"]
      |> Enum.map(fn category ->
        component = category |> Catalogue.components() |> hd()
        {:ok, entry} = DocumentationCatalogue.lookup_route(component.path)
        entry
      end)

    render_page(conn, params, %{
      kind: :landing,
      title: "ShadcnUI Gallery",
      path: "/",
      presentation: presentation,
      featured_entries: featured_entries
    })
  end

  def category(conn, %{"category" => category} = params) do
    case Catalogue.lookup_category(category) do
      {:ok, item} ->
        {:ok, presentation} = DocumentationCatalogue.lookup_presentation_route(item.path)

        entries =
          DocumentationCatalogue.entries()
          |> Enum.filter(&(&1.category.slug == item.slug))

        render_page(
          conn,
          params,
          Map.merge(item, %{
            kind: :category,
            title: item.label,
            presentation: presentation,
            entries: entries
          })
        )

      :error ->
        not_found(conn, params)
    end
  end

  def component(conn, %{"category" => category, "component" => component} = params) do
    case Catalogue.lookup_component(category, component) do
      {:ok, item} ->
        {:ok, documentation_entry} = DocumentationCatalogue.lookup(category, component)

        render_page(
          conn,
          params,
          Map.merge(item, %{
            kind: :component,
            title: item.label,
            reference: Reference.fetch!(item.render),
            documentation_entry: documentation_entry,
            related: DocumentationCatalogue.related(documentation_entry)
          })
        )

      :error ->
        not_found(conn, params)
    end
  end

  def composition(conn, %{"example" => example} = params) do
    case Catalogue.lookup_composition(example) do
      {:ok, item} ->
        {:ok, presentation} = DocumentationCatalogue.lookup_presentation_route(item.path)

        selected =
          if params["view"] in ["profile", "security"], do: params["view"], else: "profile"

        invalid = params["state"] == "invalid"

        render_page(
          conn,
          params,
          Map.merge(item, %{
            kind: :composition,
            title: item.label,
            presentation: presentation,
            selected: selected,
            invalid: invalid
          })
        )

      :error ->
        not_found(conn, params)
    end
  end

  def not_found(conn, params) do
    conn
    |> put_status(:not_found)
    |> render_page(params, %{
      kind: :not_found,
      title: "Page not found",
      path: "/",
      canonical: false
    })
  end

  defp render_page(conn, params, page) do
    theme = ShadcnUIDemo.GalleryPreferences.theme(params)
    motion = ShadcnUIDemo.GalleryPreferences.motion(params)
    build_identity = BuildIdentity.current!()

    conn
    |> put_view(html: ShadcnUIDemoWeb.PageHTML)
    |> render(:gallery,
      page_title: page.title,
      canonical_url:
        if(Map.get(page, :canonical, true),
          do: BuildIdentity.canonical_url(build_identity, page.path),
          else: nil
        ),
      page: page,
      theme: theme,
      motion: motion,
      build_identity: build_identity,
      categories: Catalogue.categories(),
      components: Catalogue.components()
    )
  end
end
