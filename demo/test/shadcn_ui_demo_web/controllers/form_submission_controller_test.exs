defmodule ShadcnUIDemoWeb.FormSubmissionControllerTest do
  use ShadcnUIDemoWeb.ConnCase

  # covers: shadcn_ui.form_gallery.compositions
  # covers: shadcn_ui.form_gallery.submission_fixture

  test "sign-in, profile, and settings are deterministic caller-owned compositions", %{conn: conn} do
    expectations = %{
      "/forms/sign-in" => [~s(type="email"), ~s(type="password"), ~s(type="checkbox")],
      "/forms/profile" => ["profile-errors", "<textarea", "<select", ~s(type="radio"), ~s(type="range")],
      "/forms/settings" => ["data-shadcn-ui-switch", ~s(name="demo[features][]"), "<selectedcontent>", "<progress", "<meter", " readonly", " disabled"]
    }

    for {path, fragments} <- expectations do
      html = conn |> recycle() |> get(path) |> html_response(200)
      assert html =~ "caller-owned demonstration data"
      assert html =~ ~s(name="_csrf_token")
      assert html =~ ~s(action="/forms/submit")
      assert Enum.all?(fragments, &String.contains?(html, &1))
      refute html =~ ~r/(authentication succeeded|saved|authorized)/i
    end
  end

  test "static compositions are explicitly non-submitting", %{conn: conn} do
    html = conn |> get("/forms/profile?static=1") |> html_response(200)
    assert html =~ "submission is intentionally disabled"
    refute html =~ ~s(action="/forms/submit")
    assert html =~ ~r/<button[^>]*disabled[^>]*type="submit"|<button[^>]*type="submit"[^>]*disabled/
  end

  test "allowlisted native values are rendered escaped and in deterministic key order", %{conn: conn} do
    conn = get(conn, "/forms/profile")
    csrf = csrf_token(conn.resp_body)

    params = %{
      "_csrf_token" => csrf,
      "demo" => %{
        "volume" => "70",
        "notes" => "<script>alert(1)</script>",
        "features" => ["exports", "audit"],
        "remember" => "false",
        "contact" => "email",
        "country" => "ca",
        "email" => "demo@example.test",
        "kind" => "profile"
      }
    }

    html = conn |> recycle() |> post("/forms/submit", params) |> html_response(200)
    assert html =~ "Received demonstration values"
    assert html =~ "&lt;script&gt;alert(1)&lt;/script&gt;"
    refute html =~ "<script>alert(1)</script>"
    assert html =~ "exports"
    assert html =~ "audit"
    keys = Regex.scan(~r/<dt>([^<]+)<\/dt>/, html, capture: :all_but_first) |> List.flatten()
    assert keys == Enum.sort(keys)
    assert html =~ "No authentication, persistence, authorization, or domain operation"
  end

  test "unexpected fields and malformed submissions fail without reflection or side effects", %{conn: conn} do
    conn = get(conn, "/forms/settings")
    csrf = csrf_token(conn.resp_body)

    unexpected = "unexpected-<script>-#{System.unique_integer([:positive])}"

    response =
      conn
      |> recycle()
      |> post("/forms/submit", %{"_csrf_token" => csrf, "demo" => %{unexpected => "payload"}})
      |> response(422)

    assert response == "Unexpected demonstration field"
    refute response =~ unexpected

    source = File.read!("lib/shadcn_ui_demo_web/controllers/form_controller.ex")
    refute source =~ ~r/(Repo\.|Ecto|Ash\.|authenticate|authorize|insert|update|delete)/i
  end

  defp csrf_token(html) do
    [token] = Regex.run(~r/name="_csrf_token"[^>]*value="([^"]+)"/, html, capture: :all_but_first)
    token
  end

end
