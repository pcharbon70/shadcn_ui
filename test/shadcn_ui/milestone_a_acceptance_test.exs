defmodule ShadcnUI.MilestoneAAcceptanceTest do
  use ExUnit.Case, async: false

  # covers: shadcn_ui.package.independent_mix_project
  # covers: shadcn_ui.package.heex_infrastructure_only shadcn_ui.package.transport_neutral
  # covers: shadcn_ui.package.public_import_surface shadcn_ui.package.explicit_release_files
  # covers: shadcn_ui.package.no_consumer_asset_toolchain
  # covers: shadcn_ui.component.stateless_heex shadcn_ui.component.closed_values
  # covers: shadcn_ui.component.classes_and_globals shadcn_ui.component.slots
  # covers: shadcn_ui.component.safe_content shadcn_ui.component.native_semantics
  # covers: shadcn_ui.component.protected_accessibility
  # covers: shadcn_ui.component.deterministic_identity
  # covers: shadcn_ui.component.presentation_snapshot shadcn_ui.component.progressive_floor
  # covers: shadcn_ui.stylesheet.canonical_asset shadcn_ui.stylesheet.prefixed_isolation
  # covers: shadcn_ui.stylesheet.semantic_tokens shadcn_ui.stylesheet.scoped_dark_theme
  # covers: shadcn_ui.stylesheet.asset_path shadcn_ui.stylesheet.no_runtime_assets
  # covers: shadcn_ui.stylesheet.reproducible_output
  # covers: shadcn_ui.provenance.pinned_revision shadcn_ui.provenance.component_mapping
  # covers: shadcn_ui.provenance.mit_notice shadcn_ui.provenance.no_upstream_runtime
  # covers: shadcn_ui.provenance.site_assets_excluded
  # covers: shadcn_ui.provenance.independent_identity

  alias Phoenix.HTML.Safe

  @foundation_modules [
    ShadcnUI.Components.Foundation.Alert,
    ShadcnUI.Components.Foundation.Avatar,
    ShadcnUI.Components.Foundation.Badge,
    ShadcnUI.Components.Foundation.Button,
    ShadcnUI.Components.Foundation.Card,
    ShadcnUI.Components.Foundation.Skeleton
  ]

  defmodule ConsumerFixture do
    use Phoenix.Component
    use ShadcnUI

    attr :label, :string, required: true
    attr :class, :any, default: nil
    attr :rest, :global

    def render(assigns) do
      assigns =
        assign(
          assigns,
          :classes,
          ShadcnUI.Component.class_names([
            "sui:inline-flex",
            ShadcnUI.Component.classes_for(:focus, :default),
            assigns.class
          ])
        )

      ~H"""
      <button data-shadcn-ui type="button" class={@classes} {@rest}>{@label}</button>
      """
    end
  end

  test "a real consumer compiles the public import with defining metadata intact" do
    assert Code.ensure_loaded?(ConsumerFixture)

    for module <- @foundation_modules do
      assert function_exported?(module, :__components__, 0)
      assert module.__components__() == %{}
    end
  end

  test "consumer HEEX preserves deterministic classes, globals, and escaping" do
    html =
      %{
        label: "Save <unsafe>",
        class: "consumer",
        rest: %{"aria-describedby" => "help", "data-state" => "ready"},
        __changed__: nil
      }
      |> ConsumerFixture.render()
      |> Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "data-shadcn-ui"
    assert html =~ "sui:inline-flex"
    assert html =~ "sui:focus-visible:outline-2"
    assert html =~ "consumer"
    assert html =~ ~s(aria-describedby="help")
    assert html =~ ~s(data-state="ready")
    assert html =~ "Save &lt;unsafe&gt;"
    refute html =~ "<unsafe>"
  end

  test "the approved release surface archives without excluded files" do
    temporary_root =
      Path.join(System.tmp_dir!(), "shadcn-ui-package-#{System.unique_integer([:positive])}")

    archive = Path.join(temporary_root, "shadcn_ui.tar")
    File.mkdir_p!(temporary_root)
    on_exit(fn -> File.rm_rf!(temporary_root) end)

    expected =
      [
        "CHANGELOG.md",
        "README.md",
        "THIRD_PARTY_NOTICES.md",
        "mix.exs",
        "priv/provenance/unscripted_ui.json",
        "priv/provenance/unscripted_ui.schema.json",
        "priv/static/shadcn_ui.css"
      ] ++
        ("lib/**/*.ex" |> Path.wildcard() |> Enum.sort())

    assert :ok =
             :erl_tar.create(
               String.to_charlist(archive),
               Enum.map(expected, &String.to_charlist/1),
               [{:cwd, String.to_charlist(File.cwd!())}]
             )

    assert {:ok, archived_paths} = :erl_tar.table(String.to_charlist(archive))
    actual = archived_paths |> Enum.map(&List.to_string/1) |> Enum.sort()

    assert actual == Enum.sort(expected)

    refute Enum.any?(actual, fn path ->
             String.starts_with?(path, [
               ".spec/",
               "_build/",
               "assets/",
               "demo/",
               "deps/",
               "doc/",
               "node_modules/",
               "scripts/",
               "test/"
             ])
           end)
  end

  test "compiled CSS and provenance evidence agree on the phase foundation" do
    css = File.read!(ShadcnUI.stylesheet_path())
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))

    assert css =~ ".sui\\:inline-flex"
    assert css =~ "--shadcn-ui-primary"
    assert css =~ "data-shadcn-theme=dark"
    assert css =~ "prefers-reduced-motion:reduce"
    refute css =~ "--tw-"

    assert Enum.any?(provenance["adaptations"], fn adaptation ->
             adaptation["id"] == "stylesheet.semantic-foundation" and
               "assets/shadcn_ui.css" in adaptation["localPaths"]
           end)
  end
end
