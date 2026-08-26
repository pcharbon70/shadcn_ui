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
