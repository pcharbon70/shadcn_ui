defmodule ShadcnUIDemo.MilestoneGPhase5AccordionTest do
  use ShadcnUIDemoWeb.ConnCase

  alias ShadcnUIDemo.DocumentationCatalogue

  @repo_root Path.expand("../..", __DIR__)
  @evidence_path Path.join(
                   @repo_root,
                   "demo/priv/reference/milestone_g/phase-05-accordion-evidence.json"
                 )

  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.catalogue_metadata
  # covers: shadcn_ui.gallery_presentation.stable_identity
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.semantic_exceptions
  # covers: shadcn_ui.disclosure.accordion_modes

  test "Accordion pilot metadata closes both specimens and capability evidence" do
    assert {:ok, entry} = DocumentationCatalogue.lookup("disclosure", "accordion")

    assert Enum.map(entry.examples, & &1.source_id) == [
             "reference:accordion:exclusive",
             "reference:accordion:independent"
           ]

    assert Enum.map(entry.examples, & &1.fragment) == [
             "accordion-primary",
             "accordion-independent"
           ]

    assert Enum.all?(entry.examples, &(&1.layout == "constrained"))
    assert Enum.at(entry.examples, 0).source =~ ~s(mode={:exclusive})
    assert Enum.at(entry.examples, 1).source =~ ~s(mode={:independent})

    assert Enum.map(entry.presentation.features, & &1.identity) ==
             ~w(native-baseline exclusive-grouping details-content interpolate-size fallback)

    assert length(entry.presentation.support_rows) == 3
    assert entry.presentation.counterpart.identity == "disclosure.accordion"
    assert entry.presentation.counterpart.local_changes =~ "deterministic native details"
  end

  test "Accordion article renders exact fragments, modes, guidance, ownership, and provenance", %{
    conn: conn
  } do
    html = conn |> get("/components/disclosure/accordion") |> html_response(200)

    for marker <- [
          ~s(data-gallery-example="reference:accordion:exclusive"),
          ~s(data-gallery-example="reference:accordion:independent"),
          ~s(id="accordion-primary-source"),
          ~s(id="accordion-independent-source"),
          ~s(data-gallery-capability="exclusive-grouping"),
          ~s(data-gallery-capability="details-content"),
          ~s(data-gallery-capability="interpolate-size"),
          "Application ownership and API",
          "Related documentation",
          "disclosure.accordion"
        ],
        do: assert(html =~ marker)

    assert length(Regex.scan(~r/<details[^>]+name="faq-group"/, html)) == 3
    assert length(Regex.scan(~r/<details[^>]+id="faq-sections-item-/, html)) == 3
    refute html =~ ~s(id="ordinary-alternative")
  end

  test "pilot visual evidence is complete and byte-matches every checked golden" do
    evidence = @evidence_path |> File.read!() |> Jason.decode!()

    assert evidence["reference"] ==
             "demo/priv/reference/milestone_g/presentation-reference.json"

    assert evidence["approvedTemplate"]["status"] ==
             "accepted-for-phase-06-metadata-and-phase-07-migration"

    assert length(evidence["goldens"]) == 12
    assert length(evidence["approvedDifferences"]) == 4

    for golden <- evidence["goldens"] do
      actual =
        @repo_root
        |> Path.join(golden["file"])
        |> File.read!()
        |> then(&:crypto.hash(:sha256, &1))
        |> Base.encode16(case: :lower)

      assert actual == golden["sha256"], "golden drift for #{golden["id"]}"
    end
  end
end
