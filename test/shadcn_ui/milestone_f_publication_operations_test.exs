defmodule ShadcnUI.MilestoneFPublicationOperationsTest do
  use ExUnit.Case, async: true

  @workflow File.read!(".github/workflows/gallery.yml")
  @operations File.read!("docs/gallery-operations.md")

  test "workflow pins reviewed inputs and PRs cannot publish" do
    for sha <- [
          "11d5960a326750d5838078e36cf38b85af677262",
          "54075bcc5e249e4758d363f27d099f55d843f124",
          "49933ea5288caeca8642d1e84afbd3f7d6820020",
          "56afc609e74202658d3ffba0e8f6dda462b719fa",
          "d6db90164ac5ed86f2b6aed7e0febac5b3c0c03e"
        ] do
      assert @workflow =~ sha
    end

    assert @workflow =~ "if: github.event_name == 'push' && github.ref == 'refs/heads/main'"
    assert @workflow =~ "contents: read"
    assert @workflow =~ "pages: write"
    assert @workflow =~ "id-token: write"
    assert @workflow =~ "retention-days: 30"
    assert @workflow =~ "SHADCN_UI_EXPECTED_REVISION: ${{ github.sha }}"
    refute @workflow =~ ~r/uses: [^\s]+@(v\d+|main|master)\s*$/m
  end

  test "operations separate states and define bounded rollback" do
    for term <- [
          "Local verification",
          "pull-request CI",
          "merge",
          "deployment",
          "post-deployment",
          "release.json",
          "health.json",
          "non-reflecting 404",
          "previously verified",
          "reviewed revert",
          "cache",
          "30 days"
        ] do
      assert @operations =~ term
    end

    assert @operations =~ "merge does not imply deployment occurred"
    assert @operations =~ "Never edit the"
    assert @operations =~ "deployed artifact in place"
  end
end
