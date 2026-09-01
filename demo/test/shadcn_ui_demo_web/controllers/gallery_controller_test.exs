defmodule ShadcnUIDemoWeb.GalleryControllerTest do
  use ShadcnUIDemoWeb.ConnCase

  # covers: shadcn_ui.gallery.component_guidance shadcn_ui.gallery.safe_resolution
  # covers: shadcn_ui.gallery.semantic_shell shadcn_ui.gallery.stable_routes
  # covers: shadcn_ui.gallery.theme_matrix

  alias ShadcnUIDemo.Catalogue

  test "every canonical route renders the expected shell and authored-composition current markers",
       %{conn: conn} do
    for path <- Catalogue.routes() do
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ "<main"
      assert html =~ "Component navigation"

      expected =
        case path do
          "/" -> 1
          # Two authored markers plus desktop/mobile links and the breadcrumb.
          "/examples/application-shell" -> 5
          "/examples/" <> _ -> 3
          # Desktop/mobile links plus the breadcrumb current location.
          _ -> 3
        end

      assert length(Regex.scan(~r/aria-current="page"/, html)) == expected
    end
  end

  test "theme input is closed and content remains available without script", %{conn: conn} do
    for {theme, expected} <- [
          {nil, "light"},
          {"light", "light"},
          {"dark", "dark"},
          {"minty", "light"}
        ] do
      query = if theme, do: "?theme=#{theme}", else: ""

      html =
        conn |> recycle() |> get("/components/foundation/button#{query}") |> html_response(200)

      assert html =~ ~s(data-shadcn-theme="#{expected}")
      assert html =~ "HEEX source"
      assert html =~ ~s(href="/components/foundation/card")
    end
  end

  test "responsive shell renders one search identity, native navigation, and footer metadata", %{
    conn: conn
  } do
    html = conn |> get("/components/foundation/button") |> html_response(200)

    assert html =~ ~s(<summary>Navigation</summary>)
    assert html =~ ~s(aria-label="Mobile primary navigation")
    assert html =~ ~s(aria-label="Mobile component navigation")
    assert html =~ ~s(data-gallery-metadata)
    assert html =~ ~s(data-gallery-build-identity)
    assert length(Regex.scan(~r/id="gallery-component-search"/, html)) == 1
    assert length(Regex.scan(~r/id="gallery-search-status"/, html)) == 1
    refute html =~ ~r/(aria-modal="true"|role="menu"|role="dialog")/
  end

  test "every component has catalogue-driven guidance, a stable preview, source, and related links",
       %{conn: conn} do
    for component <- Catalogue.components() do
      html = conn |> recycle() |> get(component.path) |> html_response(200)
      fragment = "#{component.slug}-primary"

      assert html =~ ~s(id="#{fragment}")
      assert html =~ ~s(href="##{fragment}")
      assert html =~ ~s(data-gallery-theme-scope="light")
      assert html =~ ~s(data-gallery-motion-inspection="system")
      assert html =~ ~s(id="#{fragment}-source")
      assert html =~ ~s(data-gallery-component-article)
      assert html =~ "How it works"
      assert html =~ "Accessibility and browser support"
      assert html =~ "Application ownership and API"
      assert html =~ "Related documentation"
      assert html =~ "Catalogue identity"
    end
  end

  test "unknown and mismatched paths return deterministic non-reflecting 404", %{conn: conn} do
    for path <- ["/missing", "/components/other/button", "/components/foundation/missing"] do
      html = conn |> recycle() |> get(path) |> html_response(404)
      assert html =~ "Page not found"
      refute html =~ path
    end
  end
end
