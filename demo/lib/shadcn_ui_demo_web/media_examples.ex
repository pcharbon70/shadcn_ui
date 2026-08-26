defmodule ShadcnUIDemoWeb.MediaExamples do
  use Phoenix.Component
  use ShadcnUI
  alias ShadcnUIDemo.MediaFixtures

  def cover_images do
    Enum.map(MediaFixtures.entries(), fn entry ->
      %{
        key: entry["key"],
        src: "/media/" <> entry["file"],
        alt: entry["alt"],
        width: entry["width"],
        height: entry["height"],
        href: "/media/" <> entry["file"],
        caption: entry["alt"] <> ". Original local illustration; open the complete image.",
        srcset: [%{src: "/media/" <> entry["file"], width: entry["width"]}],
        sizes: "(max-width: 640px) 80vw, 320px"
      }
    end)
  end

  def cover_flow_examples(assigns) do
    images = cover_images()

    failure = %{
      key: "missing",
      src: "/media/intentionally-missing.svg",
      alt: "Intentionally unavailable landscape",
      width: 640,
      height: 480,
      caption:
        "The image is intentionally missing. This caption and available destination remain.",
      href: "/media/ridge.svg"
    }

    long =
      for n <- 1..9 do
        images
        |> Enum.at(rem(n - 1, 3))
        |> Map.put(:key, "long-#{n}")
        |> Map.put(
          :caption,
          String.duplicate("Long captions wrap independently of image depth. ", 5)
        )
      end

    assigns = assign(assigns, images: images, failure: failure, long: long)

    ~H"""
    <div class="gallery-media-examples">
      <p>
        Scroll with native arrows, wheel or touch, or follow an item link.
        <a href="/examples/media-browser">Open the complete media browser</a>
        or <a href="/examples/motion-media-capabilities">inspect capability evidence</a>.
      </p>
      <h3>Optional depth with complete destinations</h3>
      <.cover_flow id="cover-reference" accessible_label="Landscape depth" images={@images} />
      <h3>Independent flat presentation</h3>
      <.cover_flow
        id="cover-flat"
        accessible_label="Flat landscapes"
        images={@images}
        presentation={:flat}
      />
      <h3>One image: no depth or overflow needed</h3>
      <.cover_flow id="cover-single" accessible_label="One landscape" images={Enum.take(@images, 1)} />
      <h3>Long collection and captions</h3>
      <.cover_flow
        id="cover-long"
        accessible_label="Long landscape collection"
        images={@long}
        snap={:none}
      />
      <section dir="rtl">
        <h3>Right-to-left native collection</h3>
        <.cover_flow id="cover-rtl" accessible_label="RTL landscapes" images={@images} />
      </section>
      <h3>Broken image, preserved meaning</h3>
      <.cover_flow
        id="cover-failure"
        accessible_label="Image failure example"
        images={[@failure | @images]}
      />
    </div>
    """
  end

  def carousel_examples(assigns) do
    assigns = assign(assigns, :fixtures, MediaFixtures.entries())

    ~H"""
    <div class="gallery-media-examples">
      <p>
        Use native scrolling or the labelled item links.
        <a href="/examples/media-browser">Open the complete media browser</a>
        or <a href="/examples/motion-media-capabilities">inspect capability evidence</a>.
      </p>
      <section>
        <h3>Original local images</h3>
        <.carousel
          id="reference-images"
          accessible_label="Original landscapes"
          description="Each destination opens the complete original image."
        >
          <:item :for={entry <- @fixtures} key={entry["key"]} label={entry["alt"]}>
            <.image entry={entry} />
          </:item>
        </.carousel>
      </section>
      <section :for={snap <- [:none, :proximity, :mandatory]}>
        <h3>Snap: {snap}</h3>
        <.carousel
          id={"reference-#{snap}"}
          accessible_label={"Snap #{snap}"}
          snap={snap}
          alignment={:center}
        >
          <:item :for={n <- 1..4} key={"item-#{n}"} label={"Item #{n}"}>
            <h4>Reading card {n}</h4><p>
              All content is present. Snap only changes where native scrolling settles.
            </p>
            <a href="/examples/media-browser">Browse the complete collection</a>
          </:item>
        </.carousel>
      </section>
      <section>
        <h3>One item and real local controls</h3>
        <.carousel id="reference-controls" accessible_label="Local draft">
          <:item key="draft" label="Draft preferences">
            <form>
              <label>Local caption <input name="caption" value="A landscape" /></label>
              <label><input type="checkbox" name="favorite" /> Mark as favorite locally</label>
              <button type="reset">Reset local preferences</button>
            </form><p>No submission or persistence. The reset button restores native defaults.</p>
          </:item>
        </.carousel>
      </section>
      <section>
        <h3>Oversized content and long collections</h3>
        <.carousel id="reference-long" accessible_label="Long reading collection" snap={:mandatory}>
          <:item key="wide" label="Oversized card" class="gallery-media-wide">
            <h4>A deliberately wide card</h4><p>
              {String.duplicate("Native scrolling keeps this whole card reachable. ", 8)}
            </p>
            <div class="gallery-media-wide-row">
              <a href="/media/ridge.svg">Open ridge</a><a href="/media/harbor.svg">Open harbor at the far edge</a>
            </div>
          </:item>
          <:item :for={n <- 1..12} key={"chapter-#{n}"} label={"Chapter #{n}"}>
            <h4>Chapter {n}</h4><p>Document order and keyboard access stay intact.</p><a href="/examples/media-browser">Open media browser</a>
          </:item>
        </.carousel>
      </section>
      <section dir="rtl">
        <h3>Right-to-left layout</h3>
        <.carousel id="reference-rtl" accessible_label="RTL landscapes" alignment={:center}>
          <:item :for={entry <- @fixtures} key={entry["key"]} label={entry["alt"]}>
            <.image entry={entry} />
          </:item>
        </.carousel>
      </section>
    </div>
    """
  end

  def media_browser(assigns) do
    assigns = assign(assigns, fixtures: MediaFixtures.entries(), images: cover_images())

    ~H"""
    <article data-gallery-composition="media-browser" class="gallery-media-examples">
      <p>
        Three original illustrations, complete image destinations and native item navigation. Carousel, Cover Flow and Image Gallery are implemented.
      </p>
      <p>
        Use the header theme and motion links to compare presentation. No media is fetched from an external service.
      </p>
      <.carousel
        id="media-browser"
        accessible_label="Illustration collection"
        description="Scroll, follow an item link, or open any complete image."
      >
        <:item :for={entry <- @fixtures} key={entry["key"]} label={entry["alt"]}>
          <.image entry={entry} />
        </:item>
      </.carousel>
      <h2>Optional image depth</h2>
      <p>
        <a href="/examples/image-gallery">Browse responsive figures with native image lightboxes</a>.
      </p>
      <.cover_flow id="media-browser-depth" accessible_label="Illustration depth" images={@images} />
      <h2>Native notes with decorative position</h2>
      <.scroll_indicator id="media-browser-notes" accessible_label="Illustration notes" size={:small}>
        <p :for={n <- 1..12}>
          Note {n}: original local illustrations remain available with or without motion.
        </p>
      </.scroll_indicator>
      <h2>Complete collection</h2>
      <ul>
        <li :for={entry <- @fixtures}>
          <a href={"/media/" <> entry["file"]}>{entry["alt"]}</a>
          — {entry["width"]} × {entry["height"]}, {entry["bytes"]} bytes. {entry["license"]}.
        </li>
      </ul>
      <h2>What this example owns</h2>
      <p>
        The gallery owns these original fixtures, captions, layout and destinations. A consuming application owns media rights, privacy, input validation and navigation. Replacing this markup may reset scrolling; the package does not restore it.
      </p>
      <a href="/components/media/carousel">Read the Carousel API and examples</a>
      <a href="/components/media/cover-flow">Read the Cover Flow API and examples</a>
    </article>
    """
  end

  attr :entry, :map, required: true

  defp image(assigns) do
    ~H"""
    <figure>
      <img
        src={"/media/" <> @entry["file"]}
        srcset={"/media/" <> @entry["file"] <> " " <> to_string(@entry["width"]) <> "w"}
        sizes="(max-width: 640px) 80vw, 320px"
        alt={@entry["alt"]}
        width={@entry["width"]}
        height={@entry["height"]}
        loading="lazy"
        decoding="async"
      />
      <figcaption>{@entry["alt"]}</figcaption>
    </figure>
    <a href={"/media/" <> @entry["file"]}>Open complete image</a>
    """
  end
end
