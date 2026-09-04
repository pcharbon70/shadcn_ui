defmodule ShadcnUI.MilestoneFPublicationOperationsTest do
  use ExUnit.Case, async: true

  @workflow File.read!(".github/workflows/gallery.yml")
  @operations File.read!("demo/operations/gallery-publication.md")
  @deployment File.read!("release/fly-deployment-evidence.json") |> Jason.decode!()
  @status File.read!("release/candidate-status.json") |> Jason.decode!()
  @provenance File.read!("priv/provenance/unscripted_ui.json") |> Jason.decode!()

  test "workflow pins reviewed inputs and PRs cannot publish" do
    for sha <- [
          "11d5960a326750d5838078e36cf38b85af677262",
          "54075bcc5e249e4758d363f27d099f55d843f124",
          "49933ea5288caeca8642d1e84afbd3f7d6820020"
        ] do
      assert @workflow =~ sha
    end

    assert @workflow =~ "branches: [main]"
    assert @workflow =~ "contents: read"
    assert @workflow =~ "SHADCN_UI_BUILD_REVISION: ${{ github.sha }}"
    assert @workflow =~ "https://pcharbon70-shadcn-ui-demo.fly.dev/"
    refute @workflow =~ "pages: write"
    refute @workflow =~ "id-token: write"
    refute @workflow =~ "actions/deploy-pages"
    refute @workflow =~ "FLY_API_TOKEN"
    refute @workflow =~ ~r/uses: [^\s]+@(v\d+|main|master)\s*$/m
  end

  test "operations separate states and define bounded rollback" do
    for term <- [
          "Local verification",
          "source commit",
          "image build",
          "Machine rollout",
          "service health",
          "post-deployment",
          "/healthz",
          "non-reflecting 404",
          "reviewed-and-smoke-verified",
          "immutable image identity",
          "revision mismatch"
        ] do
      assert @operations =~ term
    end

    assert @operations =~ "healthy Machine does not imply the canonical smoke passed"
    assert @operations =~ "Never edit"
    assert @operations =~ "deployed artifact in place"
    assert @operations =~ "unreviewed operational deployment"
  end

  test "deployment evidence binds Fly release, image, health, smoke, and open review gates" do
    assert @deployment["release"]["status"] == "passed"

    assert @deployment["release"]["sourceRevision"] ==
             "8654f6a4500ce210682d7cae7453553d878a714c"

    assert @deployment["release"]["flyReleaseId"] == "rel_76njzd0doog3yko3"
    assert @deployment["release"]["imageDigest"] =~ ~r/^sha256:[0-9a-f]{64}$/
    assert @deployment["health"]["status"] == "passed"
    assert @deployment["canonicalSmoke"]["status"] == "passed"

    release_revision = @deployment["release"]["sourceRevision"]
    assert @deployment["health"]["reportedSourceRevision"] == release_revision
    assert @deployment["canonicalSmoke"]["expectedRevision"] == release_revision
    assert @status["evidence"]["deployedRevision"] == release_revision
    assert @deployment["health"]["reportedPackageVersion"] == Mix.Project.config()[:version]
    assert @status["evidence"]["deployedPackageVersion"] == "1.0.0"
    assert @deployment["health"]["reportedCatalogueSchema"] == "1"

    assert @deployment["health"]["reportedUpstreamRevision"] ==
             @provenance["upstream"]["commit"]

    verifier = @deployment["canonicalSmoke"]["verifier"]
    assert verifier["sourceRevision"] == release_revision

    actual_verifier_sha =
      verifier["path"]
      |> File.read!()
      |> then(&:crypto.hash(:sha256, &1))
      |> Base.encode16(case: :lower)

    assert verifier["sha256"] == actual_verifier_sha
    assert @deployment["externalGates"]["pullRequest"] == "not-opened-current-revision"
    assert @deployment["externalGates"]["sourceReview"] == "pending-independent-approval"
    assert @deployment["externalGates"]["initialRevisionCi"] == "not-run-current-revision"
    assert @deployment["externalGates"]["finalRevisionCi"] == "pending"
    assert @deployment["externalGates"]["merge"] == "pending"
    assert @deployment["rollback"]["priorReviewedSmokeVerifiedFlyRelease"] == nil
    assert @deployment["rollback"]["status"] == "no-prior-reviewed-rollback-candidate"

    assert @deployment["staticEvidenceBoundary"]["status"] == "passed-separately"
    assert File.exists?(@deployment["staticEvidenceBoundary"]["currentEvidence"])
  end
end
