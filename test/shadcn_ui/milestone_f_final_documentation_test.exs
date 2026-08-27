defmodule ShadcnUI.MilestoneFFinalDocumentationTest do
  use ExUnit.Case, async: true

  @specs ~w(
    .spec/specs/documentation_catalogue.spec.md
    .spec/specs/public_documentation.spec.md
    .spec/specs/compatibility_accessibility.spec.md
    .spec/specs/release_publication.spec.md
  )
  @ledger File.read!("docs/milestone-f-acceptance.md")

  test "acceptance ledger names every one of the 38 Milestone F requirements once" do
    ids =
      @specs
      |> Enum.flat_map(fn path ->
        Regex.scan(~r/^- id: (shadcn_ui\.[a-z_]+\.[a-z_]+)$/m, File.read!(path),
          capture: :all_but_first
        )
      end)
      |> List.flatten()

    assert length(ids) == 38
    assert length(Enum.uniq(ids)) == 38
    assert Enum.all?(ids, &(length(Regex.scan(~r/`#{Regex.escape(&1)}`/, @ledger)) == 1))
  end

  test "candidate status blocks qualification and agrees with the ledger" do
    status = Jason.decode!(File.read!("release/candidate-status.json"))
    gates = Map.new(status["gates"], &{&1["id"], &1["status"]})

    assert status["evidence"]["milestoneFRequirements"] == 38
    assert status["evidence"]["milestoneFRequirementsImplemented"] == 38
    assert status["evidence"]["milestoneFManualRequirementsPending"] == 1
    refute status["qualification"]["qualified"]
    assert gates["phase-6-integration"] == "pending"
    assert gates["manual-accessibility"] == "pending"
    assert gates["ci-final-revision"] == "pending"
    assert gates["gallery-deployment"] == "pending"
    assert gates["post-deploy-smoke"] == "pending"
  end

  test "release-facing documents agree on boundaries and deferred work" do
    corpus =
      ~w(README.md RELEASE.md CHANGELOG.md docs/installation.md docs/integrations.md
         docs/compatibility.md docs/upgrading.md docs/gallery-operations.md)
      |> Enum.map_join("\n", &File.read!/1)

    for term <- ["Dstar", "LiveView", "controller", "0.1.0", "Hex", "rollback"] do
      assert corpus =~ term
    end

    for deferred <- ["marketplace", "CLI", "theme", "component families", "Electron"] do
      assert @ledger =~ deferred
    end

    assert @ledger =~ "The internal candidate remains blocked"
    refute @ledger =~ ~r/internal candidate (?:is|has been) qualified/i
  end
end
