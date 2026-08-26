defmodule ShadcnUIDemo.ReferenceCompletenessTest do
  use ExUnit.Case, async: true

  alias ShadcnUIDemo.{Catalogue, Reference}

  test "every catalogue leaf has authored guidance, source, renderer, route, and provenance" do
    renderer = File.read!("lib/shadcn_ui_demo_web/reference_components.ex")
    provenance = Jason.decode!(File.read!("../priv/provenance/unscripted_ui.json"))
    provenance_ids = Enum.map(provenance["adaptations"], & &1["id"])

    assert Enum.sort(Reference.keys()) == Enum.sort(Enum.map(Catalogue.components(), & &1.render))

    for component <- Catalogue.components() do
      reference = Reference.fetch!(component.render)

      assert Enum.all?(
               ~w(what when responsibilities accessibility fallback source)a,
               &Map.has_key?(reference, &1)
             )

      assert reference.source =~ "<.#{String.replace(component.slug, "-", "_")}"
      assert renderer =~ ":#{component.render}"

      provenance_prefix =
        case component.category do
          "foundation" -> "foundation"
          "forms" -> "forms"
          "disclosure" -> "disclosure"
          "navigation" -> "navigation"
          "content-surfaces" -> "content"
          "overlays" -> "overlays"
          "interactive-surfaces" -> "overlays"
        end

      assert Enum.any?(
               provenance_ids,
               &String.starts_with?(
                 String.replace(&1, "-", "_"),
                 "#{provenance_prefix}.#{String.replace(component.slug, "-", "_")}"
               )
             )

      assert component.path in Catalogue.routes()
    end
  end

  test "source is displayed as escaped inert text and never request-evaluated" do
    template = File.read!("lib/shadcn_ui_demo_web/controllers/page_html/gallery.html.heex")
    controller = File.read!("lib/shadcn_ui_demo_web/controllers/gallery_controller.ex")

    assert template =~ "@page.reference.source"
    assert template =~ "data-gallery-copy"
    refute controller =~ ~r/(Code\.|Module\.|String\.to_atom|binary_to_atom|apply\()/
  end
end
