defmodule ShadcnUIDemo.MilestoneAAcceptanceTest do
  use ShadcnUIDemoWeb.ConnCase, async: false

  alias ShadcnUIDemo.{Catalogue, Reference}

  @components %{
    alert: ShadcnUI.Components.Foundation.Alert,
    avatar: ShadcnUI.Components.Foundation.Avatar,
    badge: ShadcnUI.Components.Foundation.Badge,
    button: ShadcnUI.Components.Foundation.Button,
    card: ShadcnUI.Components.Foundation.Card,
    skeleton: ShadcnUI.Components.Foundation.Skeleton
  }

  test "the complete public surface has exactly one closed gallery reference" do
    leaves = Catalogue.components("foundation")
    provenance = Jason.decode!(File.read!("../priv/provenance/unscripted_ui.json"))
    provenance_ids = MapSet.new(provenance["adaptations"], & &1["id"])

    assert MapSet.new(leaves, & &1.render) == MapSet.new(Map.keys(@components))
    assert MapSet.subset?(MapSet.new(Map.keys(@components)), MapSet.new(Reference.keys()))

    for leaf <- leaves do
      module = Map.fetch!(@components, leaf.render)
      assert Map.has_key?(module.__components__(), leaf.render)
      assert Reference.fetch!(leaf.render).source =~ "<.#{leaf.slug}"
      assert MapSet.member?(provenance_ids, "foundation.#{leaf.slug}")
      assert File.exists?("../test/shadcn_ui/components/foundation/#{leaf.slug}_test.exs")
      assert Enum.count(leaves, &(&1.render == leaf.render)) == 1
      assert Enum.count(Catalogue.routes(), &(&1 == leaf.path)) == 1
    end
  end

  test "every route has deterministic default, light, dark, and invalid-theme responses", %{
    conn: conn
  } do
    for route <- Catalogue.routes(),
        {input, expected} <- [
          {nil, "light"},
          {"light", "light"},
          {"dark", "dark"},
          {"minty", "light"}
        ] do
      query = if input, do: "?theme=#{input}", else: ""
      html = conn |> recycle() |> get(route <> query) |> html_response(200)
      assert html =~ ~s(data-shadcn-theme="#{expected}")
      assert length(Regex.scan(~r/<h1\b/, html)) == 1
      assert html =~ "Component navigation"
    end

    first =
      conn |> recycle() |> get("/components/foundation/not-a-component") |> html_response(404)

    second =
      conn |> recycle() |> get("/components/foundation/not-a-component") |> html_response(404)

    strip_csrf =
      &Regex.replace(
        ~r/name="csrf-token" content="[^"]+"/,
        &1,
        ~s(name="csrf-token" content="token")
      )

    assert strip_csrf.(first) == strip_csrf.(second)
    refute first =~ "not-a-component"
  end

  test "acceptance inputs remain local and outside the package boundary" do
    package_sources = "../lib/**/*.ex" |> Path.wildcard() |> Enum.map_join("\n", &File.read!/1)

    demo_sources =
      "{lib,assets,scripts}/**/*.{ex,exs,heex,css,js,mjs}"
      |> Path.wildcard()
      |> Enum.map_join("\n", &File.read!/1)

    package_mix = File.read!("../mix.exs")

    refute package_sources =~ ~r/(Phoenix\.Controller|ShadcnUIDemo|Playwright|gallery\.export)/
    refute demo_sources =~ ~r/(https?:\/\/[^\s\"']+\.(?:js|css|woff2?)|Dstar|Datastar|Electron)/i

    refute package_mix =~ ~r/files:\s*\[[^\]]*"(?:demo|test|scripts|\.github)"/s
  end
end
