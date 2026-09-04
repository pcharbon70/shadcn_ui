defmodule ShadcnUI.MilestoneFReleaseTest do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @status Path.join(@root, "release/candidate-status.json")
  @inputs Path.join(@root, "release/candidate-inputs.json")

  # covers: shadcn_ui.release_publication.clean_checkout
  # covers: shadcn_ui.release_publication.clean_consumer_trial
  # covers: shadcn_ui.release_publication.deterministic_export
  # covers: shadcn_ui.release_publication.explicit_archive
  # covers: shadcn_ui.release_publication.health_manifest
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates
  # covers: shadcn_ui.release_publication.version_identity

  test "candidate version and blocking status are internally consistent" do
    status = @status |> File.read!() |> Jason.decode!()
    project_version = Mix.Project.config()[:version]
    mandatory = Enum.filter(status["gates"], & &1["mandatory"])

    assert status["candidateVersion"] == project_version

    assert status["qualification"] == %{
             "qualified" => false,
             "reason" =>
               "Mandatory 1.0.0 clean-consumer, Hex publication, and public-tag gates are not all passing.",
             "status" => "blocked"
           }

    assert Enum.any?(mandatory, &(&1["status"] in ["failed", "pending"]))
    refute Enum.all?(mandatory, &(&1["status"] == "passed"))
    review_gate = Enum.find(status["gates"], &(&1["id"] == "deployment-source-review"))
    assert review_gate["status"] == "waived"
    refute review_gate["mandatory"]

    manual_gate = Enum.find(status["gates"], &(&1["id"] == "manual-accessibility"))
    refute manual_gate["mandatory"]
    assert manual_gate["status"] == "waived"

    assert Enum.all?(
             status["gates"],
             &(&1["status"] in ["passed", "failed", "pending", "waived", "not-applicable"])
           )
  end

  test "candidate inputs hash every locked dependency source" do
    inputs = @inputs |> File.read!() |> Jason.decode!()

    for {relative, expected} <- inputs["locks"] do
      actual =
        @root
        |> Path.join(relative)
        |> File.read!()
        |> then(&:crypto.hash(:sha256, &1))
        |> Base.encode16(case: :lower)

      assert actual == expected
    end
  end

  test "candidate builder excludes development-only tooling from the gallery export" do
    builder = File.read!(Path.join(@root, "scripts/build-candidate.mjs"))

    assert builder =~ ~s|run("mix", ["gallery.export"], demo, {MIX_ENV: "test"})|
  end

  test "clean consumer recipe requires the candidate Hex repository, never a source path" do
    mixfile = File.read!(Path.join(@root, "integration/clean_consumer/mix.exs"))
    runner = File.read!(Path.join(@root, "scripts/run-clean-consumer.mjs"))

    assert mixfile =~ ~s({:shadcn_ui, "== 1.0.0", repo: "candidate"})
    refute mixfile =~ "path:"
    assert runner =~ "hex.registry"
    assert runner =~ "hex_metadata.config"
    assert runner =~ "browserPassed: true"
  end

  test "historical archive evidence is not reused for the 1.0.0 target" do
    status = @status |> File.read!() |> Jason.decode!()
    evidence = "release/consumer-trial-evidence.json" |> File.read!() |> Jason.decode!()
    gates = Map.new(status["gates"], &{&1["id"], &1["status"]})

    assert evidence["candidate"]["archive"] == "shadcn_ui-0.1.0.tar"
    assert status["candidateVersion"] == "1.0.0"

    assert status["evidence"]["currentArchiveSha256"] ==
             "547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da"

    assert status["evidence"]["currentArchiveEntries"] == 63
    assert evidence["consumer"]["outsideSourceTree"]
    assert evidence["consumer"]["compiled"]
    assert evidence["consumer"]["testsPassed"]
    assert evidence["consumer"]["browserPassed"]
    refute evidence["install"]["pathDependency"]
    assert gates["actual-archive-consumer"] == "pending"
    assert gates["clean-candidate"] == "passed"
  end

  test "public release gates remain pending without adding unrelated claims" do
    status = @status |> File.read!() |> Jason.decode!()
    gates = Map.new(status["gates"], &{&1["id"], &1})

    for id <- ["hex-publication", "public-version-tag"] do
      assert gates[id]["status"] == "pending"
      assert gates[id]["mandatory"]
    end

    for id <- [
          "marketplace-listing",
          "consumer-platform-certification",
          "official-upstream-affiliation"
        ] do
      assert gates[id]["status"] == "not-applicable"
      refute gates[id]["mandatory"]
    end
  end

  test "actual archive policy remains explicit and rejects repository tooling" do
    mixfile = File.read!(Path.join(@root, "mix.exs"))
    audit = File.read!(Path.join(@root, "scripts/check-release-archive.exs"))
    package_files = Mix.Project.config()[:package][:files]

    for required <- [
          "lib",
          "priv/static/shadcn_ui.css",
          "priv/compatibility",
          "priv/provenance",
          "README.md",
          "LICENSE",
          "CHANGELOG.md"
        ] do
      assert mixfile =~ ~s("#{required}")
    end

    assert audit =~ "Unexpected archive entries"

    for excluded <- ["demo", ".spec", "scripts", "integration", "test", "node_modules"] do
      refute Enum.any?(package_files, &String.starts_with?(&1, excluded))
    end
  end
end
