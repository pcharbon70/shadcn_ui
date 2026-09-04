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
               "Mandatory 1.0.0 archive, clean-consumer, exact-revision reproducibility, manual accessibility, review, CI, merge, Hex publication, and public-tag gates are not all passing.",
             "status" => "blocked"
           }

    assert Enum.any?(mandatory, &(&1["status"] in ["failed", "pending"]))
    refute Enum.all?(mandatory, &(&1["status"] == "passed"))
    assert Enum.find(mandatory, &(&1["id"] == "deployment-source-review"))["status"] == "pending"

    assert Enum.all?(
             status["gates"],
             &(&1["status"] in ["passed", "failed", "pending", "not-applicable"])
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
    assert status["evidence"]["currentArchiveSha256"] == nil
    assert status["evidence"]["currentArchiveEntries"] == nil
    assert evidence["consumer"]["outsideSourceTree"]
    assert evidence["consumer"]["compiled"]
    assert evidence["consumer"]["testsPassed"]
    assert evidence["consumer"]["browserPassed"]
    refute evidence["install"]["pathDependency"]
    assert gates["actual-archive-consumer"] == "pending"
    assert gates["clean-candidate"] == "pending"
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
