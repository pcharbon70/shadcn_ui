defmodule ImageGalleryBrowserFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    images =
      for {key, width, height} <- [
            {"ridge", 640, 480},
            {"harbor", 720, 480},
            {"grove", 480, 640},
            {"intentionally-missing", 640, 480}
          ] do
        %{
          key: key,
          src: "/media/#{key}.svg",
          alt: "Landscape #{key}",
          name: key,
          width: width,
          height: height,
          loading: :eager,
          href: "/media/#{key}.svg",
          caption:
            if(key == "grove",
              do: String.duplicate("Complete long caption. ", 100),
              else: "Caption for #{key}"
            ),
          full: %{
            src: "/media/#{key}.svg",
            width: width,
            height: height,
            srcset: [%{src: "/media/#{key}.svg", width: width}],
            sizes: "(max-width: 40rem) 90vw, 36rem"
          }
        }
      end

    assigns = assign(assigns, :images, images)

    ~H"""
    <!DOCTYPE html><html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Image Gallery proof
        </title>
      </head>
      <body>
        <main style="max-width:60rem;margin:auto">
          <h1>Native Image Gallery</h1><button id="before">Before gallery</button>
          <.image_gallery id="gallery" accessible_label="Gallery" images={@images} />
          <.image_gallery
            id="second"
            accessible_label="Independent gallery"
            images={Enum.take(@images, 1)}
            initial_focus={:content}
          />
          <.image_gallery
            id="close-focus"
            accessible_label="Close focus"
            images={Enum.take(@images, 1)}
            initial_focus={:close}
          />
          <.image_gallery
            id="plain"
            accessible_label="Ordinary images"
            images={@images}
            lightbox={:none}
            fit={:contain}
          />
          <div data-shadcn-motion="reduce">
            <div data-shadcn-motion="system">
              <.image_gallery
                id="reduced"
                accessible_label="Suppressed"
                images={Enum.take(@images, 1)}
                motion={:none}
              />
            </div>
          </div>
          <button id="after">After gallery</button>
        </main>
      </body>
    </html>
    """
  end
end

html =
  ImageGalleryBrowserFixture.render(%{__changed__: nil})
  |> Phoenix.HTML.Safe.to_iodata()
  |> IO.iodata_to_binary()
  |> String.replace(~r/[ \t]+$/m, "")

path = Path.expand("../test/fixtures/milestone_e_image_gallery.html", __DIR__)

if "--check" in System.argv() do
  if File.read!(path) != html, do: raise("Image Gallery fixture is stale")
else
  File.write!(path, html)
end
