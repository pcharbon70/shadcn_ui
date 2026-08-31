defmodule ShadcnUIDemo.MilestoneGPhase4ArticleTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.{Catalogue, DocumentationCatalogue}
  alias ShadcnUIDemoWeb.PresentationComponents

  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.specimen_semantics
  # covers: shadcn_ui.gallery_presentation.stable_identity

  test "every component keeps the shared article order and paired catalogue specimens", %{
    conn: conn
  } do
    for entry <- DocumentationCatalogue.entries() do
      html = conn |> recycle() |> get(entry.route) |> html_response(200)

      assert length(Regex.scan(~r/<h1(?:\s[^>]*)?>/, html)) == 1
      assert length(Regex.scan(~r/data-gallery-component-article/, html)) == 1
      assert length(Regex.scan(~r/data-gallery-capability=/, html)) >= 2
      assert length(Regex.scan(~r/data-gallery-example=/, html)) == length(entry.examples)

      assert_in_order(html, [
        "data-gallery-component-article",
        "data-gallery-example=",
        "data-gallery-how-it-works",
        "data-gallery-component-support",
        "data-gallery-ownership",
        ~s(aria-label="Related documentation"),
        "data-gallery-provenance"
      ])

      for example <- entry.examples do
        assert html =~ ~s(id="#{example.fragment}")
        assert html =~ ~s(data-gallery-example="#{example.source_id}")
        assert html =~ ~s(data-gallery-example-layout="#{example.layout}")
        assert html =~ ~s(id="#{example.source_fragment}")
        assert html =~ ~s(href="##{example.fragment}")
        assert html =~ ~s(href="##{example.source_fragment}")

        highlighted =
          entry.documentation.source
          |> PresentationComponents.highlight_heex()
          |> Phoenix.HTML.safe_to_string()

        assert html =~ highlighted
      end
    end
  end

  test "optional capability, comparison, overlay, and minimal guidance stay truthful", %{
    conn: conn
  } do
    enhanced = conn |> get("/components/forms/enhanced-select") |> html_response(200)
    assert enhanced =~ "Choosing the related control."

    dialog = conn |> recycle() |> get("/components/overlays/dialog") |> html_response(200)
    assert dialog =~ ~s(data-gallery-capability="progressive-enhancement")
    assert dialog =~ ~s(id="ordinary-alternative")
    assert dialog =~ ~s(data-gallery-support-table)

    button = conn |> recycle() |> get("/components/foundation/button") |> html_response(200)
    refute button =~ ~s(data-gallery-capability="progressive-enhancement")
    refute button =~ ~s(id="ordinary-alternative")

    assert Catalogue.routes() |> Enum.all?(&is_binary/1)
  end

  defp assert_in_order(document, markers) do
    positions = Enum.map(markers, &byte_offset!(document, &1))
    assert positions == Enum.sort(positions)
  end

  defp byte_offset!(document, marker) do
    {offset, _length} = :binary.match(document, marker)
    offset
  end
end
