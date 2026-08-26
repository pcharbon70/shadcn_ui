defmodule ShadcnUIDemo.ContentNavigationCompositionsTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.Catalogue

  # covers: shadcn_ui.content_gallery.compositions shadcn_ui.content_gallery.content_stress
  # covers: shadcn_ui.content_gallery.release_boundary

  test "closed composition routes render deterministic cross-milestone pages", %{conn: conn} do
    expectations = %{
      "/examples/documentation" => ["Documentation sections", "documentation-faq", "docs-details"],
      "/examples/settings" => ["settings-view", "Profile settings", "Save snapshot"],
      "/examples/application-shell" => [
        "Primary application navigation",
        "Secondary application navigation",
        "Application content"
      ]
    }

    assert Enum.filter(Catalogue.composition_routes(), &Map.has_key?(expectations, &1)) ==
             ["/examples/documentation", "/examples/settings", "/examples/application-shell"]

    for {path, fragments} <- expectations do
      html = conn |> recycle() |> get(path) |> html_response(200)
      repeated = conn |> recycle() |> get(path) |> html_response(200)
      assert stable_html(html) == stable_html(repeated)
      assert Enum.all?(fragments, &String.contains?(html, &1))
      assert length(Regex.scan(~r/<main\b/, html)) == 1

      refute html =~
               ~r/(LiveView|data-phx-session|websocket|data-on-keydown|role="(?:tab|tabpanel|menu)")/
    end
  end

  test "settings snapshots are caller-selected through closed query values", %{conn: conn} do
    security = conn |> get("/examples/settings?view=security&state=invalid") |> html_response(200)
    invalid = security

    fallback =
      conn
      |> recycle()
      |> get("/examples/settings?view=unknown&state=unknown")
      |> html_response(200)

    assert security =~ ~r/value="security"[^>]*checked/
    assert invalid =~ "Enter a valid email"
    assert fallback =~ ~r/value="profile"[^>]*checked/
    refute fallback =~ "Enter a valid email"
    assert security =~ "data-gallery-static-form"
    assert security =~ ~s(type="button")
  end

  test "content stress and fallbacks are authored without browser sniffing or client state" do
    source = File.read!("lib/shadcn_ui_demo_web/content_navigation_compositions.ex")
    task = File.read!("lib/mix/tasks/gallery.export.ex")

    for evidence <- [
          "Esta documentación",
          "dir=\"rtl\"",
          "axis={:both}",
          "edge_affordance={:both}",
          "id=\"docs-details\""
        ] do
      assert source =~ evidence
    end

    assert task =~ "Catalogue.routes()"

    refute source =~
             ~r/(userAgent|matchMedia|innerWidth|localStorage|sessionStorage|handle_event|push_event|JS\.|<script)/
  end

  defp stable_html(html),
    do: Regex.replace(~r/(<meta name="csrf-token" content=")[^"]+/, html, "\\1token")
end
