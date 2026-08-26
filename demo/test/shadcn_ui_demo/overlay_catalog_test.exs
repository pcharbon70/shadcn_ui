defmodule ShadcnUIDemo.OverlayCatalogTest do
  use ShadcnUIDemoWeb.ConnCase, async: false
  alias ShadcnUIDemo.{Catalogue, Reference}
  # covers: shadcn_ui.overlay_gallery.catalog shadcn_ui.overlay_gallery.states
  # covers: shadcn_ui.overlay_gallery.semantic_guidance shadcn_ui.gallery.safe_resolution
  # covers: shadcn_ui.gallery.stable_routes shadcn_ui.gallery.theme_matrix

  @categories %{
    "overlays" => ~w(dialog alert-dialog drawer popover dropdown-actions),
    "interactive-surfaces" => ~w(tooltip hover-card)
  }

  test "closed catalogue and all seven references render native states in both themes", %{
    conn: conn
  } do
    for {category, slugs} <- @categories do
      assert Enum.map(Catalogue.components(category), & &1.slug) == slugs

      for slug <- slugs do
        assert {:ok, entry} = Catalogue.lookup_component(category, slug)
        assert entry.path in Catalogue.routes()
        reference = Reference.fetch!(entry.render)

        for key <-
              ~w(what when accessibility semantics capability responsibilities comparison fallback source)a,
            do: assert(String.trim(Map.fetch!(reference, key)) != "")

        for theme <- ~w(light dark) do
          html = conn |> recycle() |> get(entry.path <> "?theme=" <> theme) |> html_response(200)
          assert html =~ ~s(data-shadcn-theme="#{theme}")
          assert html =~ ~s(href="#{entry.path}" aria-current="page")

          assert html =~
                   ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{entry.path}")

          assert html =~ ~s(id="ordinary-alternative")
          assert html =~ "HEEX source"
          assert html =~ "Browser capabilities"
          assert html =~ "Choosing the related control"
          assert html =~ "bd8f403"
          ids = Regex.scan(~r/\bid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
          assert ids == Enum.uniq(ids)
          refute html =~ ~r/(role="(?:menu|menubar|menuitem)"|interestfor=|popover="hint")/
        end
      end
    end
  end

  test "unknown and mismatched overlay routes fail closed and do not reflect input", %{conn: conn} do
    for path <- [
          "/components/overlays/tooltip",
          "/components/interactive-surfaces/dialog",
          "/components/overlays/not-a-control",
          "/components/unknown/dialog"
        ] do
      html = conn |> recycle() |> get(path) |> html_response(404)
      refute html =~ path
      refute html =~ ~s(rel="canonical")
    end
  end

  test "examples expose dismissal, native modes, edges and real ordinary alternatives", %{
    conn: conn
  } do
    dialog = conn |> recycle() |> get("/components/overlays/dialog") |> html_response(200)
    for policy <- ~w(none closerequest any), do: assert(dialog =~ ~s(closedby="#{policy}"))
    popover = conn |> recycle() |> get("/components/overlays/popover") |> html_response(200)
    assert popover =~ ~s(popover="manual")
    assert popover =~ ~s(popover="auto")
    drawer = conn |> recycle() |> get("/components/overlays/drawer") |> html_response(200)
    for edge <- ~w(start end bottom), do: assert(drawer =~ ~s(data-edge="#{edge}"))

    tooltip =
      conn |> recycle() |> get("/components/interactive-surfaces/tooltip") |> html_response(200)

    assert tooltip =~ ~s(role="tooltip")
    assert tooltip =~ "tooltip-visible-help tooltip-example-description"
  end
end
