defmodule MotionBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    assigns =
      assign(assigns, :items, [
        %{key: "a", text: "Alpha"},
        %{key: "b", text: "Beta"},
        %{key: "c", text: "Gamma"}
      ])

    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Motion proof
        </title>
      </head>
      <body>
        <main style="max-width:50rem;margin:auto">
          <h1>Bounded motion</h1>
          <.marquee id="static" accessible_label="Static brands" items={@items} />
          <.marquee
            id="preview"
            accessible_label="Preview brands"
            items={@items}
            mode={:preview}
            duration={:brief}
          />
          <.marquee id="five" accessible_label="Five second brands" items={@items} mode={:preview} />
          <div dir="rtl">
            <.marquee
              id="rtl"
              accessible_label="RTL brands"
              items={@items}
              mode={:preview}
              duration={:brief}
            />
          </div>
          <div data-shadcn-motion="reduce">
            <div data-shadcn-motion="system">
              <.marquee
                id="nested"
                accessible_label="Suppressed brands"
                items={@items}
                mode={:preview}
              />
            </div>
          </div>
          <.marquee
            id="none"
            accessible_label="No motion"
            items={@items}
            mode={:preview}
            motion={:none}
          />
          <button id="after">After motion</button>
        </main>
      </body>
    </html>
    """
  end
end

html =
  MotionBrowserFixture.render(%{__changed__: nil})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_e_motion.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html, do: raise("Motion fixture is stale")
else
  File.write!(path, html)
end
