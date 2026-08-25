defmodule ShadcnUI.Components.Overlays.AlertDialogTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.dialog.alert_dialog
  # covers: shadcn_ui.dialog.alert_ownership
  # covers: shadcn_ui.dialog.protected_semantics
  # covers: shadcn_ui.dialog.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :id, :any, default: "delete-account"
    attr :size, :atom, default: :default
    attr :title, :any, default: "Delete <account>?"
    attr :description, :any, default: "This action cannot be undone."
    attr :pending, :boolean, default: false
    attr :disabled, :boolean, default: false
    attr :trigger_rest, :map, default: %{}
    attr :dialog_rest, :map, default: %{}
    attr :content_rest, :map, default: %{}
    attr :cancel_rest, :map, default: %{}
    attr :action_rest, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.alert_dialog
        id={@id}
        size={@size}
        class="consumer-alert-surface"
        trigger_class="consumer-alert-trigger"
        content_class="consumer-alert-content"
        cancel_class="consumer-alert-cancel"
        trigger_rest={@trigger_rest}
        dialog_rest={@dialog_rest}
        content_rest={@content_rest}
        cancel_rest={@cancel_rest}
        action_rest={@action_rest}
        data-owner="application"
      >
        <:trigger>Delete account</:trigger>
        <:title>{@title}</:title>
        <:description>{@description}</:description>

        <p>Export anything you need before continuing.</p>

        <:cancel>Keep account</:cancel>
        <:action>
          <form method="post" action="/account" phx-submit="delete">
            <input type="hidden" name="_csrf_token" value="caller-token" />
            <input type="hidden" name="_method" value="delete" />
            <button
              type="submit"
              name="intent"
              value="delete-account"
              disabled={@disabled}
              aria-busy={@pending && "true"}
              data-pending={@pending && "true"}
            >
              Delete permanently
            </button>
          </form>
        </:action>
        <:fallback><a href="/account/delete">Review account deletion</a></:fallback>
      </.alert_dialog>
      """
    end
  end

  test "renders consequential relationships and least-destructive native focus" do
    html = render_alert_dialog()

    assert length(Regex.scan(~r/<dialog\b/, html)) == 1
    assert html =~ ~s(id="delete-account-surface")
    assert html =~ ~s(role="alertdialog")
    assert html =~ ~s(closedby="closerequest")
    assert html =~ ~s(aria-labelledby="delete-account-title")
    assert html =~ ~s(aria-describedby="delete-account-description")
    assert html =~ ~s(id="delete-account-title")
    assert html =~ ~s(id="delete-account-description")
    assert html =~ ~r/id="delete-account-close"[^>]+autofocus/
    assert html =~ ~s(data-initial-focus-target="delete-account-close")
    refute html =~ ~s(closedby="any")
  end

  test "renders distinct trigger, cancel, action, body, and ordinary fallback regions" do
    html = render_alert_dialog()

    assert html =~ ~s(command="show-modal")
    assert html =~ ~s(commandfor="delete-account-surface")
    assert html =~ "Delete account"
    assert html =~ "Keep account"
    assert html =~ "Delete permanently"
    assert html =~ "Export anything you need"
    assert html =~ ~s(data-shadcn-ui-alert-dialog-action)
    assert html =~ ~s(href="/account/delete")
    assert html =~ "Delete &lt;account&gt;?"
    refute html =~ "Delete <account>?"
  end

  test "preserves caller-owned form, CSRF, method, action, disabled, and pending snapshots" do
    html = render_alert_dialog(pending: true, disabled: true)

    assert html =~ ~s(<form method="post" action="/account" phx-submit="delete">)
    assert html =~ ~s(name="_csrf_token" value="caller-token")
    assert html =~ ~s(name="_method" value="delete")
    assert html =~ ~s(type="submit")
    assert html =~ ~s(name="intent")
    assert html =~ ~s(value="delete-account")
    assert html =~ "disabled"
    assert html =~ ~s(aria-busy="true")
    assert html =~ ~s(data-pending="true")
    refute html =~ ~s(method="dialog")
  end

  test "protects alert, cancellation, and relationship semantics while forwarding application globals" do
    conflicts = %{
      "id" => "wrong",
      "role" => "dialog",
      "open" => true,
      "closedby" => "any",
      "autofocus" => false,
      "command" => "wrong",
      "commandfor" => "wrong",
      "aria-labelledby" => "wrong",
      "aria-describedby" => "wrong",
      "disabled" => true,
      "data-owner" => "application",
      "phx-click" => "track"
    }

    html =
      render_alert_dialog(
        trigger_rest: conflicts,
        dialog_rest: conflicts,
        content_rest: conflicts,
        cancel_rest: conflicts,
        action_rest: %{"data-owner" => "application", "phx-click" => "track"}
      )

    assert html =~ ~s(role="alertdialog")
    assert html =~ ~s(closedby="closerequest")
    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(phx-click="track")
    assert html =~ "consumer-alert-surface"
    assert html =~ "consumer-alert-trigger"
    assert html =~ "consumer-alert-content"
    assert html =~ "consumer-alert-cancel"
    refute html =~ "wrong"
    refute html =~ ~r/id="delete-account-close"[^>]+disabled/
  end

  test "publishes required consequence slots and no ambiguous focus or dismissal controls" do
    metadata = ShadcnUI.Components.Overlays.AlertDialog.__components__().alert_dialog

    for slot <- [:trigger, :title, :description, :cancel, :action] do
      assert Enum.find(metadata.slots, &(&1.name == slot)).required
    end

    refute Enum.any?(metadata.attrs, &(&1.name in [:dismissal, :initial_focus, :open, :outcome]))

    assert Enum.find(metadata.attrs, &(&1.name == :size)).opts[:values] == [
             :small,
             :default,
             :large
           ]

    for id <- [nil, "", "  ", "1-alert", "has space", "unsafe/path"] do
      assert_raise ArgumentError, fn -> render_alert_dialog(id: id) end
    end

    assert_raise KeyError, fn -> render_alert_dialog(size: :full) end
  end

  test "source performs no consequence, submission, focus, or outcome behavior" do
    source = File.read!("lib/shadcn_ui/components/overlays/alert_dialog.ex")

    refute source =~
             ~r/(submit\(|requestSubmit|confirm\(|addEventListener|showModal\(|\.close\(|focus\(|setTimeout|handle_event|push_event|JS\.|Phoenix\.LiveView|Dstar|Electron|Ecto|Ash\.|Repo\.|GenServer|Task\.)/

    refute source =~
             ~r/(authorized|persisted|success|succeeded|completed|String\.to_atom|binary_to_atom|UUID)/i
  end

  defp render_alert_dialog(overrides \\ []) do
    %{
      id: "delete-account",
      size: :default,
      title: "Delete <account>?",
      description: "This action cannot be undone.",
      pending: false,
      disabled: false,
      trigger_rest: %{},
      dialog_rest: %{},
      content_rest: %{},
      cancel_rest: %{},
      action_rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
