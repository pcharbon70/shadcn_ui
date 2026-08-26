defmodule ShadcnUIDemoWeb.GalleryControllerTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.Catalogue

  test "every canonical route renders directly with exactly one current marker", %{conn: conn} do
    for path <- Catalogue.routes() do
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ "<main"
      assert html =~ "Component navigation"

      expected =
        case path do
          "/" -> 0
          "/examples/documentation" -> 0
          "/examples/settings" -> 0
          "/examples/application-shell" -> 2
          "/examples/" <> _ -> 0
          _ -> 1
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

  test "unknown and mismatched paths return deterministic non-reflecting 404", %{conn: conn} do
    for path <- ["/missing", "/components/other/button", "/components/foundation/missing"] do
      html = conn |> recycle() |> get(path) |> html_response(404)
      assert html =~ "Page not found"
      refute html =~ path
    end
  end
end
