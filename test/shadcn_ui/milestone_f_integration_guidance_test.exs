defmodule ShadcnUI.MilestoneFIntegrationGuidanceTest do
  use ExUnit.Case, async: true

  defmodule SharedSnapshot do
    use Phoenix.Component
    use ShadcnUI

    attr :account, :map, required: true

    def account_snapshot(assigns) do
      ~H"""
      <.card>
        <:title>
          <h1>{@account.name}</h1>
        </:title>
        <p>{@account.email}</p>
        <a href="/accounts">Back to accounts</a>
      </.card>
      """
    end
  end

  defmodule DstarShapedSnapshot do
    def account_patch(assigns) do
      assigns = Map.put_new(assigns, :__changed__, nil)

      assigns
      |> SharedSnapshot.account_snapshot()
      |> Phoenix.HTML.Safe.to_iodata()
    end
  end

  defmodule LiveViewShapedSnapshot do
    use Phoenix.Component
    import SharedSnapshot, only: [account_snapshot: 1]

    attr :account, :map, required: true

    def render(assigns) do
      ~H"""
      <.account_snapshot account={@account} />
      """
    end
  end

  @integration File.read!("docs/integrations.md")
  @upgrading File.read!("docs/upgrading.md")
  @provenance File.read!("docs/provenance.md")

  # covers: shadcn_ui.public_documentation.controller_example
  # covers: shadcn_ui.public_documentation.transport_guidance
  # covers: shadcn_ui.public_documentation.upgrade_and_migration
  # covers: shadcn_ui.public_documentation.provenance_and_identity

  test "controller, Dstar-shaped, and LiveView-shaped snapshots render through public imports" do
    assigns = %{account: %{name: "<Admin>", email: "admin@example.test"}, __changed__: nil}

    controller_html = SharedSnapshot.account_snapshot(assigns) |> Phoenix.HTML.Safe.to_iodata()
    dstar_html = DstarShapedSnapshot.account_patch(assigns)
    live_view_html = LiveViewShapedSnapshot.render(assigns) |> Phoenix.HTML.Safe.to_iodata()

    for html <- [controller_html, dstar_html, live_view_html] do
      rendered = IO.iodata_to_binary(html)
      assert rendered =~ "&lt;Admin&gt;"
      assert rendered =~ ~s(href="/accounts")
      assert rendered =~ "data-shadcn-ui"
      assert rendered =~ "sui:bg-card"
    end

    assert @integration =~ "stylesheet"
    assert @integration =~ "ordinary anchor"
    assert @integration =~ "on Dstar and exposes no actions or signals"
    assert @integration =~ "installs no LiveView route"
  end

  test "upgrade guidance separates candidate, public, deployment, manual, and rollback states" do
    for text <- [
          "internal `0.1.0` candidate",
          "publicly available on Hex",
          "local tests is not proof of CI",
          "manual review",
          "Deprecation policy",
          "accepted ADR",
          "Rollback",
          "previous reviewed commit"
        ] do
      assert @upgrading =~ text
    end
  end

  test "provenance manifest covers public identities and retains the exact independent notice" do
    manifest = File.read!("priv/provenance/unscripted_ui.json") |> Jason.decode!()
    notices = File.read!("THIRD_PARTY_NOTICES.md")
    adaptations = Map.new(manifest["adaptations"], &{&1["id"], &1})

    assert manifest["upstream"]["commit"] ==
             "bd8f403030c8d1f46804da6eda733fde7e908e63"

    assert map_size(adaptations) >= 41
    assert notices =~ "ShadcnUI is an independent Phoenix adaptation"
    assert notices =~ "MIT License"
    assert notices =~ "Copyright (c) 2026 Ján Timoranský"
    assert @provenance =~ manifest["upstream"]["commit"]
    assert @provenance =~ "not an official"
  end
end
