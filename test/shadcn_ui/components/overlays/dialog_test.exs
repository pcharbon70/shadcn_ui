defmodule ShadcnUI.Components.Overlays.DialogTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.dialog.native_modal
  # covers: shadcn_ui.dialog.dismissal_policy
  # covers: shadcn_ui.dialog.initial_focus
  # covers: shadcn_ui.dialog.protected_semantics
  # covers: shadcn_ui.dialog.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :id, :any, default: "account-settings"
    attr :title?, :boolean, default: true
    attr :title, :any, default: "Account <settings>"
    attr :description?, :boolean, default: true
    attr :accessible_label, :any, default: nil
    attr :dismissal, :atom, default: :close_request
    attr :initial_focus, :atom, default: :content
    attr :size, :atom, default: :large
    attr :alignment, :atom, default: :start
    attr :density, :atom, default: :comfortable
    attr :trigger_rest, :map, default: %{}
    attr :dialog_rest, :map, default: %{}
    attr :content_rest, :map, default: %{}
    attr :close_rest, :map, default: %{}

    def render(assigns) do
      ~H"""
      <.dialog
        id={@id}
        accessible_label={@accessible_label}
        dismissal={@dismissal}
        initial_focus={@initial_focus}
        size={@size}
        alignment={@alignment}
        density={@density}
        class="consumer-surface"
        trigger_class="consumer-trigger"
        content_class="consumer-content"
        close_class="consumer-close"
        trigger_rest={@trigger_rest}
        dialog_rest={@dialog_rest}
        content_rest={@content_rest}
        close_rest={@close_rest}
        data-owner="application"
      >
        <:trigger>Open settings</:trigger>
        <:title :if={@title?}>{@title}</:title>
        <:description :if={@description?}>Update translated account preferences.</:description>

        <form method="dialog" action="/account/preferences" phx-submit="save">
          <label for="display-name">Display name</label>
          <input id="display-name" name="account[display_name]" value="Ada" />
          <button value="preview">Preview</button>
        </form>

        <:close>Done</:close>
        <:fallback><a href="/account/preferences">Open the settings page</a></:fallback>
      </.dialog>
      """
    end
  end

  test "renders one initially closed native modal relationship and explicit exit" do
    html = render_dialog()

    assert length(Regex.scan(~r/<dialog\b/, html)) == 1
    assert length(Regex.scan(~r/command="show-modal"/, html)) == 1
    assert length(Regex.scan(~r/command="close"/, html)) == 1
    refute html =~ ~r/<dialog[^>]+\sopen(?:[=>\s])/
    refute html =~ ~r/role="dialog"/

    assert html =~ ~s(id="account-settings-invoker")
    assert html =~ ~s(commandfor="account-settings-surface")
    assert html =~ ~s(id="account-settings-surface")
    assert html =~ ~s(closedby="closerequest")
    assert html =~ ~s(id="account-settings-close")
  end

  test "derives title and description relationships and preserves trusted body markup" do
    html = render_dialog()

    assert html =~ ~s(aria-labelledby="account-settings-title")
    assert html =~ ~s(id="account-settings-title")
    assert html =~ "Account &lt;settings&gt;"
    refute html =~ "Account <settings>"
    assert html =~ ~s(aria-describedby="account-settings-description")
    assert html =~ ~s(id="account-settings-description")
    assert html =~ ~s(<form method="dialog" action="/account/preferences" phx-submit="save">)
    assert html =~ ~s(name="account[display_name]")
    assert html =~ ~s(href="/account/preferences")
  end

  test "accepts an explicit accessible label only when title is absent" do
    html = render_dialog(title?: false, accessible_label: "Translated preferences")

    assert html =~ ~s(aria-label="Translated preferences")
    refute html =~ "aria-labelledby="
    refute html =~ ~s(id="account-settings-title")

    assert_raise ArgumentError, ~r/requires one title/, fn ->
      render_dialog(title?: false, accessible_label: "  ")
    end

    assert_raise ArgumentError, ~r/not both/, fn ->
      render_dialog(title?: true, accessible_label: "Duplicate name")
    end
  end

  test "maps every closed size, alignment, density, and dismissal value" do
    for {dismissal, native} <- [none: "none", close_request: "closerequest", any: "any"] do
      html = render_dialog(dismissal: dismissal)
      assert html =~ ~s(closedby="#{native}")
      assert html =~ ~s(data-dismissal="#{native}")
    end

    for {size, class} <- [
          small: "sui:max-w-sm",
          default: "sui:max-w-lg",
          large: "sui:max-w-2xl",
          full: "sui:max-w-none"
        ] do
      assert render_dialog(size: size) =~ class
    end

    assert render_dialog(alignment: :center) =~ "sui:text-center"
    assert render_dialog(alignment: :start) =~ "sui:text-start"
    assert render_dialog(density: :compact) =~ "sui:p-4"
    assert render_dialog(density: :comfortable) =~ "sui:p-6"
  end

  test "places protected native autofocus only on the selected stable target" do
    content = render_dialog(initial_focus: :content)
    close = render_dialog(initial_focus: :close)
    automatic = render_dialog(initial_focus: :auto)

    assert content =~ ~r/id="account-settings-initial-focus"[^>]+tabindex="-1"[^>]+autofocus/
    assert content =~ ~s(data-initial-focus-target="account-settings-initial-focus")
    assert close =~ ~r/id="account-settings-close"[^>]+autofocus/
    assert close =~ ~s(data-initial-focus-target="account-settings-close")
    refute automatic =~ "autofocus"
    refute automatic =~ "data-initial-focus-target="
    refute content =~ ~r/<dialog[^>]+tabindex=/
  end

  test "protects modal semantics while forwarding application globals and classes" do
    conflicts = %{
      "id" => "wrong",
      "type" => "submit",
      "role" => "menu",
      "command" => "wrong",
      "commandfor" => "wrong",
      "open" => true,
      "closedby" => "any",
      "autofocus" => true,
      "aria-label" => "Wrong",
      "aria-labelledby" => "wrong",
      "aria-describedby" => "wrong",
      "data-owner" => "application",
      "phx-click" => "track"
    }

    html =
      render_dialog(
        trigger_rest: conflicts,
        dialog_rest: conflicts,
        content_rest: conflicts,
        close_rest: conflicts
      )

    assert html =~ ~s(data-owner="application")
    assert html =~ ~s(phx-click="track")
    assert html =~ "consumer-surface"
    assert html =~ "consumer-trigger"
    assert html =~ "consumer-content"
    assert html =~ "consumer-close"
    refute html =~ "wrong"
    refute html =~ ~r/<dialog[^>]+\sopen(?:[=>\s])/
  end

  test "publishes closed metadata and rejects invalid identity or values" do
    metadata = ShadcnUI.Components.Overlays.Dialog.__components__().dialog

    assert Enum.find(metadata.attrs, &(&1.name == :dismissal)).opts[:values] ==
             [:none, :close_request, :any]

    assert Enum.find(metadata.attrs, &(&1.name == :initial_focus)).opts[:values] ==
             [:auto, :content, :close]

    assert Enum.find(metadata.slots, &(&1.name == :trigger)).required
    assert Enum.find(metadata.slots, &(&1.name == :inner_block)).required
    assert Enum.find(metadata.slots, &(&1.name == :close)).required

    for id <- [nil, "", "  ", "1-dialog", "has space", "unsafe/path"] do
      assert_raise ArgumentError, fn -> render_dialog(id: id) end
    end

    assert_raise ArgumentError, fn -> render_dialog(dismissal: :escape) end
    assert_raise KeyError, fn -> render_dialog(initial_focus: :request) end

    for {field, value} <- [size: :huge, alignment: :right, density: :dense] do
      assert_raise KeyError, fn -> render_dialog([{field, value}]) end
    end
  end

  test "source contains no modal runtime, application operation, or dynamic identity" do
    source = File.read!("lib/shadcn_ui/components/overlays/dialog.ex")

    refute source =~
             ~r/(addEventListener|showModal\(|\.close\(|focus\(|setTimeout|handle_event|push_event|JS\.|Phoenix\.LiveView|Dstar|Electron|Ecto|Ash\.|Repo\.|GenServer|Task\.)/

    refute source =~
             ~r/(String\.to_atom|binary_to_atom|System\.unique_integer|:rand|UUID|confirm\()/i
  end

  defp render_dialog(overrides \\ []) do
    %{
      id: "account-settings",
      title?: true,
      title: "Account <settings>",
      description?: true,
      accessible_label: nil,
      dismissal: :close_request,
      initial_focus: :content,
      size: :large,
      alignment: :start,
      density: :comfortable,
      trigger_rest: %{},
      dialog_rest: %{},
      content_rest: %{},
      close_rest: %{},
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
