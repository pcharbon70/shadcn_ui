defmodule SupplementalBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" /><title>Supplemental surfaces</title>
        <style>
          body { margin: 2rem; font: 16px system-ui; } main { max-width: 44rem; } .example { margin-block: 2rem; } button, a { min-height: 44px; } #destination { margin-top: 4rem; }
        </style>
      </head>
      <body>
        <main>
          <button id="before">Before</button>
          <div class="example">
            <.tooltip id="tip" text="A local copy is also retained." describedby="help help">
              <:trigger label="Read the manual" kind={:link} href="#destination" />
            </.tooltip>
            <p id="help">The manual contains all required instructions.</p>
          </div>
          <button id="after">After</button>
          <div class="example">
            <.tooltip id="disabled" text="Supplemental only.">
              <:trigger label="Unavailable" disabled />
            </.tooltip>
            <p>This action is unavailable. Use the manual instead.</p>
          </div>
          <div class="example" id="translated" dir="rtl" data-shadcn-theme="dark">
            <.tooltip
              id="long"
              text={String.duplicate("Zusätzliche Informationen — معلومات إضافية. ", 8)}
              placement={:inline_start}
            >
              <:trigger label="Documentation" type="button" />
            </.tooltip>
          </div>
          <div class="example" style="overflow: hidden; max-height: 48px;">
            <.tooltip id="clipped" text="Optional description inside a clipped container.">
              <:trigger label="Clipped example manual" kind={:link} href="#destination" />
            </.tooltip>
          </div>
          <div class="example">
            <.hover_card id="card">
              <:trigger label="Read the complete manual" href="#destination" current="page" />
              <h3>Manual preview</h3><p>
                All required task information is available at the destination.
              </p>
            </.hover_card>
            <button id="after-card">After card</button>
          </div>
          <section id="destination">
            <h1>Manual</h1><p>All required task information is available here.</p>
          </section>
        </main>
      </body>
    </html>
    """
  end
end

html =
  SupplementalBrowserFixture.render(%{})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_d_supplemental_surfaces.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html,
    do:
      raise("Supplemental fixture is stale; run mix run scripts/render-supplemental-fixture.exs")
else
  File.write!(path, html)
end
