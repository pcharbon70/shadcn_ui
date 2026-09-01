defmodule ShadcnUI.MilestoneFPublicationOperationsTest do
  use ExUnit.Case, async: true

  @workflow File.read!(".github/workflows/gallery.yml")
  @operations File.read!("docs/gallery-operations.md")

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
    assert @workflow =~ "https://leco-shadcn-ui-demo.fly.dev/"
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
          "smoke-verified Fly release",
          "immutable image identity",
          "revision mismatch"
        ] do
      assert @operations =~ term
    end

    assert @operations =~ "healthy Machine does not imply the canonical smoke passed"
    assert @operations =~ "Never edit"
    assert @operations =~ "deployed artifact in place"
  end
end
