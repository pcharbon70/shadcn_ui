defmodule ShadcnUI.MilestoneFDocumentationTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  use ShadcnUI

  # Consumer/application helpers used by otherwise exact public documentation
  # examples. They are deliberately not ShadcnUI APIs.
  defmacro sigil_p({:<<>>, _, [path]}, []) when is_binary(path), do: path

  attr :account, :map, default: %{name: "Example", email: "example@test.invalid"}
  def account_snapshot(assigns), do: ~H"<p>{@account.name}</p>"

  def check_icon(assigns), do: ~H|<span aria-hidden="true">✓</span>|

  @category_guide_paths [
    "docs/guides/foundation.md",
    "docs/guides/forms.md",
    "docs/guides/disclosure.md",
    "docs/guides/navigation.md",
    "docs/guides/content-surfaces.md",
    "docs/guides/overlays.md",
    "docs/guides/interactive-surfaces.md",
    "docs/guides/media.md",
    "docs/guides/motion.md"
  ]

  @public_root_docs ~w(
    docs/compatibility.md
    docs/components.md
    docs/image-gallery.md
    docs/installation.md
    docs/integrations.md
    docs/motion-media-guide.md
    docs/provenance.md
    docs/upgrading.md
  )

  @internal_records ~w(
    assets/engineering/motion-media-css-exceptions.md
    assets/engineering/motion-media-foundations.md
    demo/operations/gallery-publication.md
    release/records/accessibility-review.md
    release/records/clean-consumer-trial.md
    release/records/milestone-e-acceptance.md
    release/records/milestone-f-acceptance.md
    release/records/milestone-g-phase1-acceptance.md
    release/records/release-candidate.md
    release/records/reproducible-candidate.md
  )

  @category_guides %{
    "docs/guides/foundation.md" => ~w(Button Badge Alert Card Avatar Skeleton),
    "docs/guides/forms.md" => [
      "Field",
      "Label",
      "Help",
      "Field Errors",
      "Error Summary",
      "Input",
      "Textarea",
      "Checkbox",
      "Radio Group",
      "Switch",
      "Native Select",
      "Enhanced Select",
      "Slider",
      "Progress",
      "Meter"
    ],
    "docs/guides/disclosure.md" => ["Accordion"],
    "docs/guides/navigation.md" => ["Navigation Menu", "Header", "Section Header"],
    "docs/guides/content-surfaces.md" => ["Scroll Area", "Separator", "Radio Panels"],
    "docs/guides/overlays.md" => [
      "Dialog",
      "Alert Dialog",
      "Drawer",
      "Popover",
      "Dropdown Actions"
    ],
    "docs/guides/interactive-surfaces.md" => ["Tooltip", "Hover Card"],
    "docs/guides/media.md" => ["Carousel", "Cover Flow", "Image Gallery"],
    "docs/guides/motion.md" => ["Marquee", "Stagger", "Scroll Indicator"]
  }

  @docs ["README.md" | Path.wildcard("docs/**/*.md")]

  @heex_examples for path <- @docs,
                     [source] <-
                       Regex.scan(~r/```heex\r?\n(.*?)```/s, File.read!(path),
                         capture: :all_but_first
                       ),
                     do: {path, source}

  for {{path, source}, index} <- Enum.with_index(@heex_examples) do
    ast =
      Phoenix.LiveView.TagEngine.compile(source,
        caller: __ENV__,
        file: "#{path}:heex-example-#{index + 1}",
        line: 1,
        tag_handler: Phoenix.LiveView.HTMLEngine
      )

    def compile_checked_heex(unquote(index), assigns), do: unquote(ast)
  end

  # covers: shadcn_ui.public_documentation.component_page_sections
  # covers: shadcn_ui.public_documentation.api_contract
  # covers: shadcn_ui.public_documentation.installation_and_assets
  # covers: shadcn_ui.public_documentation.compatibility_and_fallback
  # covers: shadcn_ui.public_documentation.controller_example
  # covers: shadcn_ui.public_documentation.transport_guidance
  # covers: shadcn_ui.public_documentation.exdoc_inventory
  # covers: shadcn_ui.public_documentation.upgrade_and_migration
  # covers: shadcn_ui.public_documentation.provenance_and_identity

  test "every public module has component metadata, prose, source links, and one exact gallery example" do
    groups = Mix.Project.config()[:docs][:groups_for_modules]

    public_modules =
      groups
      |> Keyword.reject(fn {name, _modules} -> name == :"Package contract" end)
      |> Keyword.values()
      |> List.flatten()

    assert Enum.uniq(public_modules) == public_modules

    public_identities =
      for module <- public_modules,
          {function, metadata} <- module.__components__(),
          function_exported?(module, function, 1),
          do: {module, function, metadata}

    assert length(public_identities) == 41

    catalogue_source = File.read!("demo/lib/shadcn_ui_demo/documentation_catalogue.ex")

    reference_source =
      Path.wildcard("demo/lib/shadcn_ui_demo/*reference.ex")
      |> Enum.map_join("\n", &File.read!/1)

    for {module, function, metadata} <- public_identities do
      assert {:docs_v1, _, :elixir, _, %{"en" => module_doc}, _, docs} =
               Code.fetch_docs(module)

      assert String.trim(module_doc) != ""
      assert function_exported?(module, function, 1)
      assert metadata.attrs != [] or metadata.slots != []

      assert Enum.any?(docs, fn
               {{:function, ^function, 1}, _, _, %{"en" => text}, _} -> String.trim(text) != ""
               _ -> false
             end)

      assert catalogue_source =~ inspect(module)
      assert reference_source =~ "<.#{function}"
    end
  end

  test "every README and guide HEEX fence compiles through public imports" do
    assert length(@heex_examples) >= 30
    assert function_exported?(__MODULE__, :compile_checked_heex, 2)
  end

  test "component guides cover every gallery category and control" do
    docs = Mix.Project.config()[:docs]
    guide_paths = Map.keys(@category_guides)

    assert docs[:groups_for_extras][:"Component guides"] == @category_guide_paths
    assert Enum.sort(guide_paths) == Enum.sort(@category_guide_paths)

    for {path, controls} <- @category_guides do
      assert path in docs[:extras]
      source = File.read!(path)

      for control <- controls do
        assert source =~ "## #{control}"
      end

      assert length(Regex.scan(~r/```heex\r?\n.*?```/s, source)) >= length(controls)
    end
  end

  test "public guidance, migration, legal, and release channels remain connected" do
    extras = Mix.Project.config()[:docs][:extras]

    for path <-
          ["README.md", "CHANGELOG.md", "LICENSE", "THIRD_PARTY_NOTICES.md", "RELEASE.md"] ++
            @public_root_docs do
      assert path in extras
      assert File.regular?(path)
    end

    assert Enum.sort(Path.wildcard("docs/*.md")) == Enum.sort(@public_root_docs)

    for path <- @internal_records do
      assert File.regular?(path)
      refute path in extras
    end

    assert File.read!("CHANGELOG.md") =~ "Milestone F Phase 3"
    assert File.read!("docs/upgrading.md") =~ "## Rollback"
    assert File.read!("THIRD_PARTY_NOTICES.md") =~ "MIT License"
    assert File.read!("RELEASE.md") =~ "**blocked**, not qualified"
  end

  test "package source and dependency boundary remains transport neutral" do
    dependency_names = Mix.Project.config()[:deps] |> Enum.map(&elem(&1, 0))
    source = Path.wildcard("lib/**/*.ex") |> Enum.map_join("\n", &File.read!/1)

    refute :dstar in dependency_names
    refute :datastar in dependency_names
    refute source =~ "Electron"
    refute source =~ ~r/defmodule .*Dstar/
    refute source =~ ~r/(use|import|alias) Dstar/
    refute source =~ ~r/use .*LiveView/
    refute source =~ ~r/defmodule .*Controller/
    refute source =~ ~r/defmodule .*Endpoint/
  end

  def compile_checked_heex(_index, _assigns), do: :unknown
end
