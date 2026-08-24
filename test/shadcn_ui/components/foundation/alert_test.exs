defmodule ShadcnUI.Components.Foundation.AlertTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.alert shadcn_ui.foundation.alert_ownership
  # covers: shadcn_ui.foundation.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :variant, :atom, default: :default
    attr :announcement, :atom, default: :none
    attr :title, :string, default: nil
    attr :description, :string, default: nil

    def render(assigns) do
      ~H"""
      <.alert
        variant={@variant}
        announcement={@announcement}
        title={@title}
        description={@description}
        class={["consumer-alert", nil, false]}
        aria-describedby="alert-help"
        data-state="visible"
        phx-mounted="show"
        data-on:click="$inspect()"
      >
        <:icon><span aria-hidden="true">!</span></:icon>
        <:actions><button type="button">Retry</button></:actions>
      </.alert>
      """
    end

    def conflicting(assigns) do
      ~H"""
      <.alert
        announcement={:polite}
        title="Protected"
        role="alert"
        aria-live="assertive"
        data-shadcn-ui="wrong"
      />
      """
    end
  end

  test "renders escaped visible content, trusted regions, globals, and stable order" do
    html = render_alert(title: "Heads <up>", description: "Try & continue")

    assert html =~ ~s(data-shadcn-ui-slot="icon")
    assert html =~ ~s(data-shadcn-ui-slot="content")
    assert html =~ ~s(data-shadcn-ui-slot="title")
    assert html =~ ~s(data-shadcn-ui-slot="description")
    assert html =~ ~s(data-shadcn-ui-slot="actions")

    assert html =~
             ~r/slot="icon".*slot="content".*slot="title".*slot="description".*slot="actions"/s

    assert html =~ "Heads &lt;up&gt;"
    assert html =~ "Try &amp; continue"
    assert html =~ ~s(<button type="button">Retry</button>)
    assert html =~ ~s(aria-describedby="alert-help")
    assert html =~ ~s(data-state="visible")
    assert html =~ ~s(phx-mounted="show")
    assert html =~ "data-on:click=\"$inspect()\""
    refute html =~ "<up>"
  end

  test "maps announcement policy without inferring urgency from the variant" do
    none = render_alert(announcement: :none)
    polite = render_alert(announcement: :polite)
    assertive = render_alert(announcement: :assertive)
    destructive = render_alert(variant: :destructive, announcement: :none)

    refute none =~ " role="
    refute none =~ "aria-live"
    assert polite =~ ~s(role="status")
    assert polite =~ ~s(aria-live="polite")
    assert assertive =~ ~s(role="alert")
    assert assertive =~ ~s(aria-live="assertive")
    assert destructive =~ "sui:text-destructive"
    refute destructive =~ " role="
    refute destructive =~ "aria-live"
  end

  test "protects explicit announcement semantics from caller globals" do
    html = Fixture.conflicting(%{__changed__: nil}) |> safe_to_string()

    assert html =~ ~s(role="status")
    assert html =~ ~s(aria-live="polite")
    assert html =~ "data-shadcn-ui"
    refute html =~ ~s(role="alert")
    refute html =~ ~s(aria-live="assertive")
    refute html =~ ~s(data-shadcn-ui="wrong")
  end

  test "supports every visible region combination and omits absent regions" do
    title_only = render_alert(title: "Title", description: nil, slots: false)
    description_only = render_alert(title: nil, description: "Description", slots: false)
    both = render_alert(title: "Title", description: "Description", slots: false)

    assert title_only =~ ~s(data-shadcn-ui-slot="title")
    refute title_only =~ ~s(data-shadcn-ui-slot="description")
    assert description_only =~ ~s(data-shadcn-ui-slot="description")
    refute description_only =~ ~s(data-shadcn-ui-slot="title")
    assert both =~ ~s(data-shadcn-ui-slot="title")
    assert both =~ ~s(data-shadcn-ui-slot="description")

    for html <- [title_only, description_only, both] do
      refute html =~ ~s(data-shadcn-ui-slot="icon")
      refute html =~ ~s(data-shadcn-ui-slot="actions")
      assert html =~ "sui:grid-cols-1"
    end
  end

  test "rejects absent or blank visible content" do
    for {title, description} <- [{nil, nil}, {"", nil}, {"  ", "\n"}] do
      assert_raise ArgumentError, ~r/nonblank title or description/, fn ->
        render_alert(title: title, description: description, slots: false)
      end
    end
  end

  test "maps closed variants and exposes no lifecycle API" do
    default = render_alert(variant: :default)
    destructive = render_alert(variant: :destructive)

    assert default =~ "sui:border-border"
    assert default =~ "sui:bg-background"
    assert default =~ "sui:text-foreground"
    assert destructive =~ "sui:border-destructive/30"
    assert destructive =~ "sui:bg-destructive/5"
    assert destructive =~ "sui:text-destructive"

    metadata = ShadcnUI.Components.Foundation.Alert.__components__().alert
    variant = Enum.find(metadata.attrs, &(&1.name == :variant))
    announcement = Enum.find(metadata.attrs, &(&1.name == :announcement))

    assert variant.opts[:values] == [:default, :destructive]
    assert announcement.opts[:values] == [:none, :polite, :assertive]
    assert metadata.slots |> Enum.map(& &1.name) |> Enum.sort() == [:actions, :icon]

    refute Enum.any?(metadata.attrs, fn attr ->
             attr.name in [:dismissible, :on_dismiss, :on_retry, :command, :html, :raw_html]
           end)
  end

  test "source owns no lifecycle, event handling, or raw HTML" do
    source = File.read!("lib/shadcn_ui/components/foundation/alert.ex")

    refute source =~
             ~r/(push_event|handle_event|JS\.|System\.cmd|Task\.|GenServer|Repo\.|HTTP|fetch\()/

    refute source =~ ~r/(raw_html|HTML\.raw|<script|javascript:)/i
  end

  defp render_alert(overrides) do
    slots = Keyword.get(overrides, :slots, true)
    overrides = Keyword.delete(overrides, :slots)

    assigns =
      %{
        variant: :default,
        announcement: :none,
        title: "Heads up",
        description: "Something changed",
        __changed__: nil
      }
      |> Map.merge(Map.new(overrides))

    if slots do
      assigns |> Fixture.render() |> safe_to_string()
    else
      assigns
      |> Map.put(:rest, %{})
      |> ShadcnUI.Components.Foundation.Alert.alert()
      |> safe_to_string()
    end
  end

  defp safe_to_string(rendered) do
    rendered |> Safe.to_iodata() |> IO.iodata_to_binary()
  end
end
