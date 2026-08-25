defmodule ShadcnUI.Components.Disclosure.AccordionTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.disclosure.accordion_native
  # covers: shadcn_ui.disclosure.accordion_modes
  # covers: shadcn_ui.disclosure.deterministic_identity
  # covers: shadcn_ui.disclosure.open_snapshot
  # covers: shadcn_ui.disclosure.protected_semantics
  # covers: shadcn_ui.disclosure.fallback
  # covers: shadcn_ui.disclosure.ownership shadcn_ui.disclosure.shared_contract

  defmodule Fixture do
    use Phoenix.Component
    use ShadcnUI

    attr :id, :any, default: "account-help"
    attr :mode, :atom, default: :independent
    attr :first_key, :any, default: "billing"
    attr :first_summary, :any, default: "Billing <details>"
    attr :first_open, :any, default: true
    attr :second_key, :any, default: "security"
    attr :second_summary, :any, default: "Security"
    attr :second_open, :any, default: false

    def render(assigns) do
      ~H"""
      <.accordion id={@id} mode={@mode} class="consumer-accordion" data-owner="application">
        <:item
          key={@first_key}
          summary={@first_summary}
          open={@first_open}
          class="consumer-item"
          summary_class="consumer-summary"
          content_class="consumer-content"
          details_rest={%{open: false, name: "override", "data-details-owner": "application"}}
          summary_rest={%{role: "button", "aria-controls": "override", "phx-click": "track"}}
          content_rest={%{"aria-labelledby": "override", "data-panel-owner": "application"}}
        >
          <p>Trusted <strong>billing</strong> panel</p>
        </:item>
        <:item
          key={@second_key}
          summary={@second_summary}
          open={@second_open}
        >
          <a href="/security">Review security</a>
        </:item>
      </.accordion>
      """
    end
  end

  test "renders one native details and summary pair per trusted panel" do
    html = render_accordion()

    assert length(Regex.scan(~r/<details\b/, html)) == 2
    assert length(Regex.scan(~r/<summary\b/, html)) == 2
    assert html =~ "Trusted <strong>billing</strong> panel"
    assert html =~ ~s(<a href="/security">Review security</a>)
    assert html =~ "Billing &lt;details&gt;"
    refute html =~ "Billing <details>"
    refute html =~ ~r/role="(?:button|group|region)"/
  end

  test "derives stable details, summary, and content relationships from caller identity" do
    html = render_accordion()

    for {details_id, summary_id, content_id} <- [
          {"account-help-item-billing", "account-help-item-billing-summary",
           "account-help-item-billing-content"},
          {"account-help-item-security", "account-help-item-security-summary",
           "account-help-item-security-content"}
        ] do
      assert html =~ ~s(id="#{details_id}")
      assert html =~ ~s(id="#{summary_id}")
      assert html =~ ~s(aria-controls="#{content_id}")
      assert html =~ ~s(id="#{content_id}")
      assert html =~ ~s(aria-labelledby="#{summary_id}")
    end

    assert html == render_accordion()
  end

  test "treats open values as protected rendered snapshots" do
    html = render_accordion(first_open: true, second_open: false)
    closed_html = render_accordion(first_open: false, second_open: false)

    assert html =~ ~r/<details[^>]+id="account-help-item-billing"[^>]+open/u
    refute html =~ ~r/<details[^>]+id="account-help-item-security"[^>]+open/u
    refute closed_html =~ ~r/<details[^>]+\sopen(?:[=>\s])/u
    refute html =~ ~s(name="override")
  end

  test "keeps independent items unnamed and every caller open snapshot" do
    html = render_accordion(first_open: true, second_open: true, mode: :independent)

    assert length(Regex.scan(~r/<details[^>]+\sopen(?:[=>\s])/u, html)) == 2
    refute html =~ ~s(name="account-help-group")
  end

  test "gives exclusive items one stable name and deterministically keeps the first open snapshot" do
    html = render_accordion(first_open: true, second_open: true, mode: :exclusive)

    assert length(Regex.scan(~r/name="account-help-group"/, html)) == 2
    assert length(Regex.scan(~r/<details[^>]+\sopen(?:[=>\s])/u, html)) == 1
    assert html =~ ~r/<details[^>]+id="account-help-item-billing"[^>]+open/u
    refute html =~ ~r/<details[^>]+id="account-help-item-security"[^>]+open/u
    assert html == render_accordion(first_open: true, second_open: true, mode: :exclusive)
  end

  test "protects identities and native meaning while forwarding unrelated globals and classes" do
    html = render_accordion()

    assert html =~ ~s(id="account-help")
    assert html =~ ~s(data-owner="application")
    assert html =~ "consumer-accordion"
    assert html =~ "consumer-item"
    assert html =~ "consumer-summary"
    assert html =~ "consumer-content"
    assert html =~ ~s(data-details-owner="application")
    assert html =~ ~s(phx-click="track")
    assert html =~ ~s(data-panel-owner="application")
    refute html =~ ~s(aria-controls="override")
    refute html =~ ~s(aria-labelledby="override")
  end

  test "rejects blank or unsafe identities, duplicate keys, malformed summaries, and invalid snapshots" do
    for id <- [nil, "", "  ", "1-start", "has space", "unsafe/segment"] do
      assert_raise ArgumentError, fn -> render_accordion(id: id) end
    end

    for key <- [nil, "", "  ", :request_key, 42, "unsafe/key"] do
      assert_raise ArgumentError, fn -> render_accordion(first_key: key) end
    end

    assert_raise ArgumentError, fn ->
      render_accordion(first_key: "same", second_key: "same")
    end

    for summary <- [nil, "", "  ", :summary] do
      assert_raise ArgumentError, fn -> render_accordion(first_summary: summary) end
    end

    assert_raise ArgumentError, fn -> render_accordion(first_open: :yes) end
    assert_raise KeyError, fn -> render_accordion(mode: :tabs) end
  end

  test "repeated request-shaped keys do not create atoms" do
    for index <- 1..20 do
      render_accordion(first_key: "warmup-#{index}")
    end

    before_count = :erlang.system_info(:atom_count)

    for index <- 1..250 do
      render_accordion(first_key: "request-#{index}")
    end

    assert :erlang.system_info(:atom_count) == before_count
  end

  test "publishes closed mode and required item metadata" do
    metadata = ShadcnUI.Components.Disclosure.Accordion.__components__().accordion
    mode = Enum.find(metadata.attrs, &(&1.name == :mode))
    item = Enum.find(metadata.slots, &(&1.name == :item))

    assert mode.opts[:values] == [:independent, :exclusive]
    assert item.required
    assert Enum.find(item.attrs, &(&1.name == :key)).required
    assert Enum.find(item.attrs, &(&1.name == :summary)).required
    refute Enum.any?(item.attrs, &(&1.name == :disabled))
  end

  test "records theme, motion, fallback, ownership, and exact upstream provenance" do
    source = File.read!("assets/shadcn_ui.css")
    css = File.read!(ShadcnUI.stylesheet_path())
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == "disclosure.accordion"))
    readme = File.read!("README.md")

    assert source =~ "[data-shadcn-ui-accordion-summary]::marker"
    assert source =~ "@supports selector(details::details-content)"
    assert source =~ "interpolate-size: allow-keywords"
    assert source =~ "transition: none !important"
    assert source =~ "border-color: CanvasText"
    assert css =~ "data-shadcn-ui-accordion-item"

    assert adaptation["upstreamPaths"] == [
             "src/content/components/accordion.mdx",
             "src/demos/accordion/basic.html"
           ]

    assert readme =~ ~r/Browsers without exclusive\s+details grouping/
    assert readme =~ ~r/Applications own persistence across server\s+replacement/
  end

  test "source contains no disclosure emulation, persistence, application behavior, or JavaScript" do
    source = File.read!("lib/shadcn_ui/components/disclosure/accordion.ex")

    refute source =~
             ~r/(handle_event|push_event|JS\.|addEventListener|toggle|localStorage|sessionStorage|IntersectionObserver|ResizeObserver|scrollIntoView|Phoenix\.LiveView|Ecto|Ash\.|Repo\.|Dstar|Datastar|Electron|GenServer|Task\.)/

    refute source =~ ~r/(String\.to_atom|binary_to_atom|System\.unique_integer|:rand|UUID)/i
    refute source =~ ~r/(<button|role="button"|<script|javascript:|raw_html|HTML\.raw)/i
  end

  defp render_accordion(overrides \\ []) do
    %{
      id: "account-help",
      mode: :independent,
      first_key: "billing",
      first_summary: "Billing <details>",
      first_open: true,
      second_key: "security",
      second_summary: "Security",
      second_open: false,
      __changed__: nil
    }
    |> Map.merge(Map.new(overrides))
    |> Fixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
