defmodule ShadcnUIDemo.MilestoneECatalogueTest do
  use ShadcnUIDemoWeb.ConnCase, async: true
  alias ShadcnUIDemo.{Catalogue, Reference}

  # covers: shadcn_ui.motion_media_gallery.incremental_catalog
  # covers: shadcn_ui.motion_media_gallery.references shadcn_ui.motion_media_gallery.compositions
  # covers: shadcn_ui.motion_media_gallery.motion_inspection
  test "every A–E authored route retains its shell and canonical, and every leaf has source", %{
    conn: conn
  } do
    for path <- Catalogue.routes() do
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ "Component navigation"

      assert html =~
               ~s(rel="canonical" href="https://leco-industries-inc.github.io/shadcn_ui#{path}")

      if path != "/", do: assert(html =~ ~s(aria-current="page"))
    end

    for component <- Catalogue.components() do
      html = conn |> recycle() |> get(component.path) |> html_response(200)
      assert html =~ "HEEX source"
      assert String.trim(Reference.fetch!(component.render).source) != ""
    end
  end

  test "all six E leaves preserve closed theme/motion choices and reject mismatched paths", %{
    conn: conn
  } do
    for component <- Catalogue.components(), component.category in ["media", "motion"] do
      for theme <- ~w(light dark), motion <- ~w(system reduce) do
        html =
          conn
          |> recycle()
          |> get(component.path <> "?theme=#{theme}&motion=#{motion}")
          |> html_response(200)

        assert html =~ ~s(data-shadcn-theme="#{theme}")
        assert html =~ ~s(data-shadcn-motion="#{motion}")
        assert html =~ "motion=reduce"
        assert html =~ "motion=system"
      end

      html =
        conn
        |> recycle()
        |> get(component.path <> "?theme=unknown&motion=force")
        |> html_response(200)

      assert html =~ ~s(data-shadcn-theme="light")
      assert html =~ ~s(data-shadcn-motion="system")

      for path <- [
            "/components/forms/#{component.slug}",
            "/components/#{component.category}/untrusted-sentinel"
          ] do
        html = conn |> recycle() |> get(path) |> html_response(404)
        refute html =~ "untrusted-sentinel"
      end
    end
  end

  test "capability guidance distinguishes native semantics, fallbacks and application ownership",
       %{conn: conn} do
    html = conn |> get("/examples/motion-media-capabilities") |> html_response(200)

    for text <- [
          "not tabs",
          "depth never means selection",
          "Use Progress",
          "Meter",
          "finite preview",
          "Without scroll snap",
          "Without timelines",
          "browser hints",
          "offscreen",
          "CSP",
          "state manager"
        ] do
      assert html =~ text
    end
  end
end
