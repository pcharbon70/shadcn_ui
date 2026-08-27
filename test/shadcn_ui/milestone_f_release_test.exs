defmodule ShadcnUI.MilestoneFReleaseTest do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @status Path.join(@root, "release/candidate-status.json")
  @inputs Path.join(@root, "release/candidate-inputs.json")

  test "candidate version and blocking status are internally consistent" do
    status = @status |> File.read!() |> Jason.decode!()
    project_version = Mix.Project.config()[:version]
    mandatory = Enum.filter(status["gates"], & &1["mandatory"])

    assert status["candidateVersion"] == project_version

    assert status["qualification"] == %{
             "qualified" => false,
             "reason" =>
               "Mandatory manual accessibility, CI, and SpecLed gates are not all passing.",
             "status" => "blocked"
           }

    assert Enum.any?(mandatory, &(&1["status"] in ["failed", "pending"]))
    refute Enum.all?(mandatory, &(&1["status"] == "passed"))

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

    assert mixfile =~ ~s({:shadcn_ui, "== 0.1.0", repo: "candidate"})
    refute mixfile =~ "path:"
    assert runner =~ "hex.registry"
    assert runner =~ "hex_metadata.config"
    assert runner =~ "browserPassed: true"
  end

  test "candidate remains internal and excludes public or platform claims" do
    status = @status |> File.read!() |> Jason.decode!()
    gates = Map.new(status["gates"], &{&1["id"], &1})

    for id <- [
          "hex-publication",
          "public-version-tag",
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
