defmodule ShadcnUIDemoWeb.GalleryController do
  use ShadcnUIDemoWeb, :controller

  alias ShadcnUIDemo.Catalogue
  alias ShadcnUIDemo.Reference

  def landing(conn, params) do
    render_page(conn, params, %{kind: :landing, title: "ShadcnUI Gallery", path: "/"})
  end

  def category(conn, %{"category" => category} = params) do
    case Catalogue.lookup_category(category) do
      {:ok, item} ->
        render_page(conn, params, Map.merge(item, %{kind: :category, title: item.label}))

      :error ->
        not_found(conn, params)
    end
  end

  def component(conn, %{"category" => category, "component" => component} = params) do
    case Catalogue.lookup_component(category, component) do
      {:ok, item} ->
        render_page(
          conn,
          params,
          Map.merge(item, %{
            kind: :component,
            title: item.label,
            reference: Reference.fetch!(item.render)
          })
        )

      :error ->
        not_found(conn, params)
    end
  end

  def not_found(conn, params) do
    conn
    |> put_status(:not_found)
    |> render_page(params, %{kind: :not_found, title: "Page not found", path: nil})
  end

  defp render_page(conn, params, page) do
    theme = if params["theme"] in ["light", "dark"], do: params["theme"], else: "light"

    conn
    |> put_view(html: ShadcnUIDemoWeb.PageHTML)
    |> render(:gallery,
      page_title: page.title,
      page: page,
      theme: theme,
      categories: Catalogue.categories(),
      components: Catalogue.components()
    )
  end
end
