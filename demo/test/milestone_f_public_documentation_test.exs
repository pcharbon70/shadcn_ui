defmodule ShadcnUIDemo.MilestoneFPublicDocumentationTest do
  use ExUnit.Case, async: true

  alias ShadcnUIDemo.DocumentationCatalogue

  @required_sections ~w(what when responsibilities accessibility fallback source native_baseline package_enhancement demo_behavior unsupported)a

  # covers: shadcn_ui.public_documentation.component_page_sections
  # covers: shadcn_ui.public_documentation.api_contract
  # covers: shadcn_ui.public_documentation.exdoc_inventory

  test "every public component has complete compiled API and plain-language page guidance" do
    for entry <- DocumentationCatalogue.entries() do
      assert Enum.all?(@required_sections, fn key ->
               value = Map.fetch!(entry.documentation, key)
               is_binary(value) and String.trim(value) != ""
             end)

      assert entry.links.gallery == entry.route
      assert entry.links.source =~ "/lib/shadcn_ui/components/"
      assert entry.links.source =~ ".ex"
      assert entry.links.api =~ "#{inspect(entry.public.module)}.html##{entry.public.function}/1"

      assert entry.api.attributes != [] or entry.api.slots != []

      for attribute <- entry.api.attributes do
        assert is_atom(attribute.name)
        assert is_atom(attribute.type)
        assert is_boolean(attribute.required)
        assert is_boolean(attribute.global)
        assert is_list(attribute.included_globals)
      end

      for slot <- entry.api.slots do
        assert is_atom(slot.name)
        assert is_boolean(slot.required)
        assert is_list(slot.attributes)
      end

      assert {:docs_v1, _, :elixir, _, module_doc, _, function_docs} =
               Code.fetch_docs(entry.public.module)

      assert is_map(module_doc)

      assert Enum.any?(function_docs, fn
               {{:function, function, 1}, _, _, %{"en" => doc}, _} ->
                 function == entry.public.function and String.trim(doc) != ""

               _ ->
                 false
             end)
    end
  end

  test "internal helpers stay out of the public documentation inventory" do
    internal_modules = [
      ShadcnUI.Components.Forms.FormContract,
      ShadcnUI.Components.Forms.Select,
      ShadcnUI.Components.Forms.SelectOptions,
      ShadcnUI.Components.Media.MediaContract,
      ShadcnUI.Components.Motion.MotionContract,
      ShadcnUI.Components.Overlays.OverlayContract,
      ShadcnUI.Components.Overlays.SupplementalContract
    ]

    documented_modules = MapSet.new(DocumentationCatalogue.entries(), & &1.public.module)

    refute Enum.any?(internal_modules, &MapSet.member?(documented_modules, &1))
  end
end
