defmodule ShadcnUI.PublicHexReleasePhase1Test do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @preflight_path Path.join(@root, "release/public-release-preflight.json")
  @preflight @preflight_path |> File.read!() |> Jason.decode!()

  # covers: shadcn_ui.release_publication.deployment_workflow
  # covers: shadcn_ui.release_publication.public_release_target
  # covers: shadcn_ui.release_publication.truthful_gates
  # covers: shadcn_ui.release_publication.version_identity

  test "section 1.1 records the exact synchronized release boundary" do
    release = @preflight["release"]
    boundary = @preflight["sourceBoundary"]
    authority = @preflight["authority"]

    assert release["package"] == "shadcn_ui"
    assert release["version"] == Mix.Project.config()[:version]
    assert release["qualificationBranch"] == "codex/public-1-0-0-release-phase-1"
    assert release["branchBaseRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert authority["releaseOwner"] == "pcharbon70"
    assert authority["intendedHexAccount"] == "pcharbon70"
    assert authority["hexOrganization"] == nil
    assert authority["reviewMethod"] == "approving GitHub review"
    assert authority["independentReviewerRequired"]

    assert boundary["deployedRevision"] =~ ~r/^[0-9a-f]{40}$/
    assert boundary["comparedThroughRevision"] == release["branchBaseRevision"]
    assert boundary["commitCount"] == 7
    assert boundary["changedFileCount"] == length(boundary["changedFiles"])
    assert boundary["changedFilesSha256"] =~ ~r/^[0-9a-f]{64}$/
  end

  test "section 1.1 inventory is reproducible and excludes material deployment changes" do
    boundary = @preflight["sourceBoundary"]
    range = "#{boundary["deployedRevision"]}..#{boundary["comparedThroughRevision"]}"

    {files, 0} = System.cmd("git", ["diff", "--name-only", range], cd: @root)
    changed_files = files |> String.split("\n", trim: true)
    digest = :crypto.hash(:sha256, files) |> Base.encode16(case: :lower)

    assert changed_files == boundary["changedFiles"]
    assert digest == boundary["changedFilesSha256"]

    material_paths = [
      "lib/",
      "priv/static/",
      "demo/lib/",
      "demo/assets/",
      "mix.exs",
      "package.json",
      "package-lock.json",
      "demo/package.json",
      "demo/package-lock.json"
    ]

    refute Enum.any?(changed_files, fn path ->
             Enum.any?(material_paths, &String.starts_with?(path, &1))
           end)

    refute boundary["materialGalleryOrPackageChange"]
    refute boundary["replacementFlyDeploymentRequired"]
  end

  test "section 1.1 retains a secret-free clean-worktree policy" do
    working_tree = @preflight["workingTree"]

    assert working_tree["cleanAtSectionStart"]
    refute working_tree["generatedArchivesTracked"]
    refute working_tree["generatedDocsTracked"]
    refute working_tree["credentialsTracked"]
    refute working_tree["evidenceSecretsTracked"]
  end
end
