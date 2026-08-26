defmodule ShadcnUIDemo.OverlayCompositionsTest do
  use ShadcnUIDemoWeb.ConnCase, async: false
  alias ShadcnUIDemo.{Catalogue, OverlayCapabilities}
  # covers: shadcn_ui.overlay_gallery.compositions shadcn_ui.overlay_gallery.fallbacks
  # covers: shadcn_ui.overlay_gallery.release_boundary shadcn_ui.overlay_gallery.capability_matrix
  # covers: shadcn_ui.overlay_gallery.cross_engine_behavior

  @compositions ~w(settings-confirmation responsive-drawers anchored-actions supplemental-help)
  test "all compositions are closed, exported and provide complete native alternatives", %{
    conn: conn
  } do
    for slug <- @compositions do
      path = "/examples/" <> slug
      assert path in Catalogue.routes()
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ ~s(data-gallery-composition="#{slug}")
      assert html =~ "Fallback and replacement"
      assert html =~ "without demo scripts"

      refute html =~
               ~r/(interestfor=|popover="hint"|role="(?:menu|menuitem)"|<dialog[^>]*\sopen(?:[ >]))/

      ids = Regex.scan(~r/\bid="([^"]+)"/, html, capture: :all_but_first) |> List.flatten()
      assert ids == Enum.uniq(ids)
    end

    html =
      conn
      |> recycle()
      |> get("/examples/settings-confirmation?state=invalid&view=untrusted-input")
      |> html_response(200)

    assert html =~ "Example rejection: the draft changed"
    assert html =~ ~s(method="dialog")
    assert html =~ "Pending snapshot"
    refute html =~ "untrusted-input"
    assert :error = Catalogue.lookup_composition("arbitrary-workflow")
  end

  test "capability policy and observed versions are explicit, deterministic and sourced", %{
    conn: conn
  } do
    evidence = OverlayCapabilities.evidence()
    manifest = OverlayCapabilities.manifest()
    html = conn |> get("/examples/overlay-capabilities") |> html_response(200)
    assert html =~ "2026-08-26"
    assert html =~ "Deliberately excluded"
    assert html =~ "Capability-gated CSS enhancement"
    assert html =~ "not proof of every interaction"

    for {engine, record} <- OverlayCapabilities.engines() do
      assert record["version"] == manifest["verificationEvidence"]["engines"][engine]["version"]
      assert html =~ record["version"]

      assert Enum.sort(Map.keys(record["capabilities"])) ==
               Enum.sort(Map.keys(manifest["capabilities"]))
    end

    for row <- OverlayCapabilities.rows() do
      assert html =~ ~s(data-capability="#{row.key}")
      assert html =~ row.source
    end

    assert evidence["engines"]["firefox"]["capabilities"]["interestInvokers"] == false
    assert manifest["capabilities"]["interestInvokers"]["status"] == "excluded"
  end

  test "compositions and capability reports are not package runtime code" do
    source = File.read!("lib/shadcn_ui_demo_web/overlay_compositions.ex")

    refute source =~
             ~r/(<script|addEventListener|setTimeout|showModal\(|showPopover\(|navigator\.userAgent|handle_event|push_event)/

    refute File.read!("../mix.exs") =~ ~r/"demo"\s*,/
    assert File.exists?("priv/compatibility/native_overlay_evidence.json")
    refute File.exists?("../priv/compatibility/native_overlay_evidence.json")
  end
end
