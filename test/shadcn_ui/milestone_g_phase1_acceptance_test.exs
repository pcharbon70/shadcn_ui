defmodule ShadcnUI.MilestoneGPhase1AcceptanceTest do
  use ExUnit.Case, async: true

  @presentation_spec File.read!(".spec/specs/gallery_presentation.spec.md")
  @decision File.read!(".spec/decisions/pinned-gallery-presentation-parity.md")
  @coverage File.read!(
              ".spec/planning/milestone-g-unscripted-style-gallery-presentation-parity/coverage-map.md"
            )
  @verification @presentation_spec
                |> String.split("```spec-verification", parts: 2)
                |> List.last()
  @manifest File.read!("demo/priv/reference/milestone_g/presentation-reference.json")
            |> Jason.decode!()
  @provenance File.read!("priv/provenance/unscripted_ui.json") |> Jason.decode!()

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.local_assets
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  test "decision, specification, package provenance, and reference use one pin" do
    commit = @manifest["upstream"]["commit"]

    assert commit == @provenance["upstream"]["commit"]
    assert @decision =~ "id: shadcn_ui.pinned_gallery_presentation_parity"
    assert @decision =~ commit
    assert @presentation_spec =~ "shadcn_ui.pinned_gallery_presentation_parity"
    assert @presentation_spec =~ "shadcn_ui.gallery_presentation.pinned_reference"
  end

  test "every additive requirement has a phase owner and verification target" do
    requirement_ids =
      Regex.scan(~r/^- id: shadcn_ui\.gallery_presentation\.([a-z_]+)$/m, @presentation_spec,
        capture: :all_but_first
      )
      |> List.flatten()

    assert length(requirement_ids) == 14
    assert length(Enum.uniq(requirement_ids)) == 14

    Enum.each(requirement_ids, fn id ->
      assert @coverage =~ "`gallery_presentation.#{id}`"

      assert @verification =~ "- shadcn_ui.gallery_presentation.#{id}"
    end)
  end

  test "reference and font evidence are deterministic demo-only files" do
    encoded_once = Jason.encode!(@manifest)
    encoded_twice = @manifest |> Jason.encode!() |> Jason.decode!() |> Jason.encode!()

    assert encoded_once == encoded_twice
    assert @manifest["capturePolicy"]["networkRequiredForVerification"] == false
    assert @manifest["fontReview"]["binaryCopied"] == true

    assert @manifest["fontReview"]["localBinarySha256"] ==
             @manifest["fontReview"]["upstreamBinarySha256"]

    package_files = Mix.Project.config()[:package][:files]
    refute "demo" in package_files
    refute ".spec" in package_files
    refute "docs" in package_files

    archive_audit = File.read!("scripts/check-release-archive.exs")
    assert archive_audit =~ ~s("demo/")
    assert archive_audit =~ ~s(".spec/")
  end

  test "retained notices and semantic exceptions remain explicit" do
    mit = File.read!("THIRD_PARTY_NOTICES.md")

    ofl =
      File.read!("demo/priv/reference/milestone_g/licenses/bricolage-grotesque-OFL.txt")

    assert mit =~ "MIT License"
    assert mit =~ @manifest["upstream"]["commit"]
    assert ofl =~ "Copyright 2022 The Bricolage Grotesque Project Authors"
    assert ofl =~ "SIL OPEN FONT LICENSE Version 1.1"

    for phrase <- [
          "must not copy unscripted/ui",
          "Radio Panels",
          "rather than an ARIA menu",
          "no tablist, tab or tabpanel roles"
        ] do
      assert @decision =~ phrase
    end
  end
end
