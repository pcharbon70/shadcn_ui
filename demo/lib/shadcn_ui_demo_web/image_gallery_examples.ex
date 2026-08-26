defmodule ShadcnUIDemoWeb.ImageGalleryExamples do
  use Phoenix.Component
  use ShadcnUI
  alias ShadcnUIDemoWeb.MediaExamples

  def images do
    MediaExamples.cover_images()
    |> Enum.map(fn image ->
      image
      |> Map.put(
        :full,
        Map.take(image, [:src, :width, :height, :srcset])
        |> Map.put(:sizes, "(max-width: 40rem) 90vw, 36rem")
      )
      |> Map.put(:sizes, "(max-width: 640px) 100vw, 33vw")
    end)
  end

  defp failure do
    %{
      key: "missing",
      src: "/media/intentionally-missing.svg",
      alt: "Intentionally unavailable landscape",
      name: "Unavailable landscape",
      width: 640,
      height: 480,
      href: "/media/ridge.svg",
      caption:
        "This image is intentionally missing. Its name and caption remain; the ordinary destination opens an available ridge illustration."
    }
  end

  def examples(assigns) do
    assigns = assign(assigns, images: images(), failure: failure())

    ~H"""
    <div class="gallery-media-examples">
      <p><a href="/examples/image-gallery">Browse the complete image gallery</a>.
        Choose an Enlarge button for a native lightbox or an Open image link for the ordinary destination.
        There is no slideshow, image fetching service or component script.</p>
      <h3>Responsive local figures and native enlargement</h3>
      <.image_gallery
        id="gallery-reference"
        accessible_label="Original illustrations"
        images={@images}
      />
      <h3>Ordinary destinations without dialogs</h3>
      <.image_gallery
        id="gallery-plain"
        accessible_label="No-dialog illustrations"
        images={@images}
        lightbox={:none}
        fit={:contain}
        columns={:two}
      />
      <h3>Caption slots and explicit close focus</h3>
      <.image_gallery
        id="gallery-caption"
        accessible_label="Caption example"
        images={Enum.take(@images, 1)}
        initial_focus={:close}
      >
        <:caption :let={item} key="ridge">
          <strong>Original ridge</strong> — trusted presentation-only caption ({item.context}).
        </:caption>
      </.image_gallery>
      <h3>Image failure preserves meaning and an available destination</h3>
      <.image_gallery id="gallery-failure" accessible_label="Failed image" images={[@failure]} />
      <h3>Suppressed motion and right-to-left figures</h3>
      <div data-shadcn-motion="reduce" dir="rtl">
        <.image_gallery
          id="gallery-reduced"
          accessible_label="Reduced RTL gallery"
          images={@images}
          motion={:none}
          density={:compact}
        />
      </div>
      <p>
        Origin animation is deliberately deferred. Reduced motion, missing anchors or transitions do not change opening or closing.
        Without native commands, use the separate Open image links. Without CSS or JavaScript, figures and destinations remain complete.
      </p>
    </div>
    """
  end

  def composition(assigns) do
    images = images()

    collection =
      for n <- 1..6 do
        image = Enum.at(images, rem(n - 1, 3))

        image
        |> Map.put(:key, "collection-#{n}")
        |> Map.put(
          :caption,
          if(n == 6,
            do:
              String.duplicate(
                "Complete caption: the portrait grove keeps its full aspect ratio in the lightbox. ",
                35
              ),
            else: image.caption
          )
        )
      end

    assigns = assign(assigns, images: images, collection: collection, failure: failure())

    ~H"""
    <article data-gallery-composition="image-gallery" class="gallery-media-examples">
      <p>Explore six views of three original local illustrations: a ridge, harbor and portrait grove.
        Enlarge any image in its own native lightbox, then use Close image or Escape to return.
        Open image links are always available independently.</p>
      <.image_gallery
        id="image-collection"
        accessible_label="Local illustration collection"
        images={@collection}
        description="Mixed aspect ratios, complete captions and ordinary full-image destinations."
      />
      <h2>Browse without a modal</h2>
      <.image_gallery
        id="image-ordinary"
        accessible_label="Ordinary collection"
        images={@images}
        lightbox={:none}
        fit={:contain}
      />
      <h2>A deliberately unavailable image</h2>
      <.image_gallery
        id="image-failure"
        accessible_label="Unavailable illustration"
        images={[@failure]}
      />
      <h2>What this example does and does not do</h2>
      <p>
        Only manifest-listed local SVG fixtures are used. The same three images are repeated with distinct keys to demonstrate a larger collection;
        no upstream artwork or remote media service is loaded. The long grove caption remains complete inside the scrolling lightbox.
      </p>
      <p>These original fixtures retain their LicenseRef-LECO-Proprietary rights notice.
        Your application owns image rights, privacy, CSP, alt text, responsive candidates and destinations.
        Native loading/decoding are hints, not guaranteed deferred fetching. Replacing this subtree closes its dialogs;
        restoration and reinvocation belong to the application.</p>
      <p>
        There is no next/previous, swipe, zoom, pan, upload, transformation or selected-image state.
        The optional thumbnail-origin effect is deferred after three-engine testing; the browser handles modal behavior without a package runtime.
      </p>
      <p>
        Use header theme and motion links to inspect alternatives. With CSS disabled or native commands unavailable,
        use the visible ordinary destinations. No component JavaScript is required.
      </p>
      <a href="/components/media/image-gallery">Read the Image Gallery API and source</a>
      <a href="/examples/motion-media-capabilities">Inspect the recorded capability evidence</a>
    </article>
    """
  end
end
