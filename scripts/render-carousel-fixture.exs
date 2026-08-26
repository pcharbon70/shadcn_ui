defmodule CarouselBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Carousel proof
        </title>
      </head>
      <body>
        <main style="max-width: 60rem; margin: auto;">
          <h1>Native Carousel</h1>
          <a href="#after" id="before">Before examples</a>
          <div :for={snap <- [:none, :proximity, :mandatory]}>
            <.carousel
              id={"carousel-#{snap}"}
              accessible_label={"Records #{snap}"}
              snap={snap}
              description="Native scrolling; item links are destinations, not selection."
            >
              <:item :for={n <- 1..6} key={"record-#{n}"} label={"Record #{n}"}>
                <h2>Record {n}</h2><p>Complete caller content.</p>
                <a href="#after">Read record {n}</a>
                <form action="/fixture-submit">
                  <label>Note {n}<input name="note" /></label><button type="submit">Submit {n}</button>
                </form>
              </:item>
            </.carousel>
          </div>
          <div dir="rtl">
            <.carousel id="rtl" accessible_label="RTL records" alignment={:center}>
              <:item :for={n <- 1..4} key={"rtl-#{n}"} label={"RTL #{n}"}>
                <h2>פריט {n}</h2><a href="#after">Destination {n}</a>
              </:item>
            </.carousel>
          </div>
          <.scroll_area axis={:both} size={:large}>
            <.carousel id="oversized" accessible_label="Oversized records" snap={:mandatory}>
              <:item key="wide" label="Wide record" class="fixture-wide">
                <h2>Oversized content</h2><p>
                  {String.duplicate("Long content wraps and remains available. ", 12)}
                </p><div style="display:flex; width:70rem; justify-content:space-between">
                  <a href="#after">Start edge</a><button id="far-edge">Far edge</button>
                </div>
              </:item>
              <:item key="end" label="Last record">
                <p>End of collection</p><a href="#after">Exit record</a>
              </:item>
            </.carousel>
          </.scroll_area>
          <a href="#before" id="after">After examples</a>
        </main>
      </body>
    </html>
    """
  end
end

html =
  CarouselBrowserFixture.render(%{})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_e_carousel.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html, do: raise("Carousel fixture is stale")
else
  File.write!(path, html)
end
