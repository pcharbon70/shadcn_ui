defmodule PopoverBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Popover fixtures
        </title>
      </head>
      <body>
        <button id="outside" type="button">Outside</button>
        <div id="scroll-host" style="height: 280px; overflow: auto; margin: 80px;">
          <div style="height: 100px;"></div>
          <.popover id="basic" placement={:block_end}>
            <:trigger>Open options</:trigger><:title>Options</:title>
            <:description>Native nonmodal controls.</:description>
            <input id="first-field" aria-label="First field" /><a id="inside-link" href="#fallback">Read details</a>
            <:close>Close</:close><:fallback><a href="#fallback">Ordinary options page</a></:fallback>
          </.popover>
          <div style="height: 500px;"></div>
        </div>
        <.popover id="manual" mode={:manual} action={:show} accessible_label="Manual options">
          <:trigger>Show manual</:trigger><p>Manual surfaces require an explicit hide operation.</p>
          <:close>Hide manual</:close>
        </.popover>
        <.popover id="hide" action={:hide} accessible_label="Hide-only example">
          <:trigger>Hide only</:trigger><p>Caller invoker opens this surface.</p>
        </.popover>
        <button id="external-show" popovertarget="hide-surface" popovertargetaction="show">External show</button>
        <.popover id="long" accessible_label="Translated details">
          <:trigger>Long details</:trigger>
          <p :for={n <- 1..30}>
            {n}. Überprüfung der Datensätze — تفاصيل السجل — long caller-owned text.
          </p>
          <:close>Close long details</:close><:fallback>
            <a href="#fallback">Full details</a>
          </:fallback>
        </.popover>
        <.dialog id="host-dialog">
          <:trigger>Open host dialog</:trigger><:title>Host dialog</:title>
          <.popover id="nested" accessible_label="Nested note">
            <:trigger>Nested note</:trigger><p>A single native Popover inside a modal.</p><:close>
              Hide note
            </:close>
          </.popover>
          <:close>Close dialog</:close>
        </.dialog>
        <section id="fallback">
          <h1>Ordinary destination</h1><p>Required content is available without overlays.</p>
        </section>
      </body>
    </html>
    """
  end
end

html =
  PopoverBrowserFixture.render(%{})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_d_popovers.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html,
    do: raise("Popover fixture is stale; run mix run scripts/render-popover-fixture.exs")
else
  File.write!(path, html)
end
