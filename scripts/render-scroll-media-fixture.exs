defmodule ScrollMediaBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <!DOCTYPE html><html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Scroll media proof
        </title>
      </head>
      <body>
        <main style="max-width:60rem;margin:auto">
          <h1>Native scroll decoration</h1>
          <.scroll_indicator
            :for={id <- ["first", "second"]}
            id={id}
            accessible_label={"Notes #{id}"}
            size={:small}
          >
            <div :for={n <- 1..12}>
              <h2>Note {n}</h2><p>Complete content with native scrolling.</p>
              <a href="#after">Read note {n}</a><label>Note {n}<input name={"#{id}-#{n}"} /></label>
            </div>
          </.scroll_indicator>
          <.scroll_indicator id="short" accessible_label="Short content" size={:large}>
            <p>All visible.</p>
          </.scroll_indicator>
          <div data-shadcn-motion="reduce">
            <div data-shadcn-motion="system">
              <.scroll_indicator id="nested" accessible_label="Nested suppression" size={:small}>
                <p :for={n <- 1..20}>Suppressed content {n}</p>
              </.scroll_indicator>
            </div>
          </div>
          <.scroll_indicator
            id="none"
            accessible_label="Explicit suppression"
            motion={:none}
            size={:small}
          >
            <p :for={n <- 1..20}>No motion {n}</p>
          </.scroll_indicator>
          <button id="after">After examples</button>
        </main>
      </body>
    </html>
    """
  end
end

html =
  ScrollMediaBrowserFixture.render(%{__changed__: nil})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_e_scroll_media.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html, do: raise("Scroll media fixture is stale")
else
  File.write!(path, html)
end
