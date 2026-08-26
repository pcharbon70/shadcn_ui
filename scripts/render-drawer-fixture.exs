defmodule DrawerBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Drawer browser fixture
        </title>
      </head>
      <body>
        <a id="outside" href="#fallback-content">Outside focus target</a>
        <div :for={edge <- [:start, :end, :bottom]}>
          <.drawer id={"drawer-#{edge}"} edge={edge} initial_focus={:content}>
            <:trigger>Open {edge}</:trigger>
            <:title>Drawer {edge}</:title>
            <:description>Native edge presentation.</:description>
            <p>Details in document order.</p>
            <input aria-label="Example value" />
            <:close>Close</:close>
            <:fallback><a href="#fallback-content">Open full details</a></:fallback>
          </.drawer>
        </div>
        <div :for={policy <- [:none, :any]}>
          <.drawer
            id={"policy-#{policy}"}
            edge={:bottom}
            size={:small}
            dismissal={policy}
            initial_focus={:close}
          >
            <:trigger>Open {policy}</:trigger>
            <:title>Dismissal {policy}</:title>
            <p>Always has an explicit exit.</p>
            <:close>Close</:close>
          </.drawer>
        </div>
        <.drawer id="edit-details" edge={:end} size={:large} initial_focus={:content}>
          <:trigger>Edit details</:trigger>
          <:title>Record details</:title>
          <:description>Caller-owned draft.</:description>
          <:header><span>Record 42</span></:header>
          <.header density={:compact}>
            <:brand><span>Record tools</span></:brand>
            <:primary_navigation>
              <.navigation_menu accessible_name="Record destinations">
                <:item key="full" destination="#fallback-content" label="Full record" />
              </.navigation_menu>
            </:primary_navigation>
          </.header>
          <.section_header>
            <:heading>
              <h3>Draft fields</h3>
            </:heading>
          </.section_header>
          <.alert
            variant={:destructive}
            title="Review required"
            description="The server reported a missing reference."
          />
          <form id="edit-form" method="dialog">
            <.input id="record-reference" name="reference" value="" required>
              <:label>Reference</:label>
            </.input>
            <.radio_panels id="record-mode" name="mode" selected="summary">
              <:legend>Detail level</:legend>
              <:option key="summary" value="summary" label="Summary">
                <p>Summary draft</p>
              </:option>
              <:option key="complete" value="complete" label="Complete">
                <p>Complete draft</p>
              </:option>
            </.radio_panels>
            <.separator />
            <.accordion id="record-help">
              <:item key="help" summary="Reference guidance">
                Use the caller's reference number.
              </:item>
            </.accordion>
            <button type="button" popovertarget="record-note">Show note</button>
            <div id="record-note" popover>
              <p>One native nested Popover.</p><button
                type="button"
                popovertarget="record-note"
                popovertargetaction="hide"
              >Hide note</button>
            </div>
            <.card>
              <:title>
                <h3>Translated details</h3>
              </:title>
              <p :for={number <- 1..35} dir="auto">
                {number}. Long translated copy: Überprüfung der Datensätze — تفاصيل السجل — caller-owned content.
              </p>
            </.card>
            <.scroll_area axis={:horizontal} accessible_label="Short supplementary content">
              <span>Short content fits without creating another vertical scroll region.</span>
            </.scroll_area>
            <.input
              id="validation-target"
              name="notes"
              value="Review this field"
              errors={["Caller-rendered validation message."]}
              used={true}
            >
              <:label>Server validation target</:label>
            </.input>
          </form>
          <:footer>
            <.button type="submit" form="edit-form" value="saved" id="save-record">Save draft</.button>
          </:footer>
          <:close>Close</:close>
          <:fallback><a href="#fallback-content">Edit on the full page</a></:fallback>
        </.drawer>
        <section id="fallback-content">
          <h1>Full details fallback</h1><p>Required details remain available.</p>
        </section>
      </body>
    </html>
    """
  end
end

html =
  DrawerBrowserFixture.render(%{})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_d_drawers.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html,
    do: raise("Drawer browser fixture is stale; run mix run scripts/render-drawer-fixture.exs")
else
  File.write!(path, html)
end
