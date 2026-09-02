defmodule ShadcnUIDemoWeb.HealthControllerTest do
  use ShadcnUIDemoWeb.ConnCase, async: true

  # covers: shadcn_ui.release_publication.health_manifest
  # covers: shadcn_ui.release_publication.version_identity

  test "GET /healthz returns only non-secret immutable release identity", %{conn: conn} do
    response = conn |> get("/healthz") |> json_response(200)

    assert response["status"] == "ok"
    assert response["identity"]["packageVersion"] == "0.1.0"
    assert response["identity"]["buildRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert response["identity"]["canonicalUrl"] =~ ~r/^https:\/\//
    refute inspect(response) =~ ~r/(secret|token|credential)/i
  end
end
