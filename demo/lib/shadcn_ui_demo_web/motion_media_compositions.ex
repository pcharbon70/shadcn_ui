defmodule ShadcnUIDemoWeb.MotionMediaCompositions do
  use Phoenix.Component
  alias ShadcnUIDemo.{MotionMediaCapabilities, MediaFixtures}
  @moduledoc "Real Phase 1 evidence and media inspection, not unfinished component previews."
  def motion_media_capabilities(assigns) do
    assigns =
      assign(assigns,
        manifest: MotionMediaCapabilities.manifest(),
        evidence: MotionMediaCapabilities.evidence(),
        scroll_media: MotionMediaCapabilities.scroll_media(),
        engines: MotionMediaCapabilities.engines(),
        fixtures: MediaFixtures.entries(),
        failures: MediaFixtures.failures()
      )

    ~H"""
    <article data-gallery-composition="motion-media-capabilities">
      <p>
        The shared foundations, <a href="/components/media/carousel">Carousel</a>,
        <a href="/components/motion/marquee">Marquee</a>
        and <a href="/components/motion/stagger">Stagger</a>
        are implemented. Try the <a href="/examples/media-browser">media browser</a>
        and <a href="/examples/motion-preferences">motion preferences</a>.
        <a href="/components/motion/scroll-indicator">Scroll Indicator</a>
        and <a href="/components/media/cover-flow">Cover Flow</a>
        are also implemented.
        Image Gallery arrives in Phase 5. Recorded capability probes remain separate from the real component interaction tests.
      </p>
      <p>
        Reviewed <time>{@evidence["reviewedOn"]}</time>. These are locked browser probes, not detection of your browser or proof that a complete component is implemented.
      </p>
      <h2>Capability policy and declaration support</h2>
      <div
        class="gallery-table-scroll"
        tabindex="0"
        role="region"
        aria-label="Motion and media capability matrix"
      >
        <table>
          <caption>Native capabilities, optional presentation and deferred controls</caption>
          <thead>
            <tr>
              <th scope="col">Feature and source</th><th scope="col">Policy</th>
              <th :for={{engine, record} <- @engines} scope="col">{engine} {record["version"]}</th>
              <th scope="col">Fallback</th>
            </tr>
          </thead>
          <tbody>
            <tr :for={{key, policy} <- Enum.sort(@manifest["capabilities"])} data-capability={key}>
              <th scope="row"><a href={policy["source"]}>{key}</a></th><td>{policy["status"]}</td>
              <td :for={{_, record} <- @engines}>
                {if record["declarations"][key], do: "Detected", else: "Not detected"}
              </td>
              <td>{policy["fallback"]}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <h2>Observed behavior — separate from parsing</h2>
      <section :for={{engine, record} <- @engines}>
        <h3>{engine} {record["version"]}</h3>
        <ul>
          <li :for={{probe, result} <- Enum.sort(record["behavior"])}>
            {probe}: {to_string(result)}
          </li>
        </ul>
      </section>
      <p>
        Generated scroll controls remain deferred. Origin-aware transitions need Phase 5 geometry and accessibility evidence. Unsupported timelines retain static native content; no script supplies a substitute.
      </p>
      <h2>Phase 4 actual component behavior</h2>
      <p>{@scroll_media["scope"]} Reviewed {@scroll_media["reviewedOn"]}.</p>
      <ul>
        <li :for={{engine, record} <- Enum.sort(@scroll_media["engines"])}>
          {engine} {record["version"]}: Scroll Indicator {record["scrollIndicator"]}; Cover Flow {record[
            "coverFlow"
          ]}.
        </li>
      </ul>
      <p>
        Run <code>{@scroll_media["command"]}</code>
        to verify native keys, isolated idle timelines, suppression and flat fallbacks. Narrow containers stay flat; no effect reports reading completion or a selected image.
      </p>
      <h2>Local media fixtures</h2>
      <p>
        Original geometric illustrations test aspect ratios, intrinsic sizing, captions and local publication. They are demo assets, not package dependencies.
      </p>
      <div class="gallery-media-fixtures">
        <figure :for={entry <- @fixtures}>
          <a href={"/media/" <> entry["file"]}>
            <img
              src={"/media/" <> entry["file"]}
              srcset={"/media/" <> entry["file"] <> " " <> to_string(entry["width"]) <> "w"}
              sizes="(max-width: 640px) 100vw, 320px"
              alt={entry["alt"]}
              width={entry["width"]}
              height={entry["height"]}
              loading="lazy"
              decoding="async"
            />
          </a>
          <figcaption>
            {entry["alt"]} — {entry["width"]} × {entry["height"]}. {entry["bytes"]} bytes. {entry[
              "license"
            ]}.
          </figcaption>
        </figure>
      </div>
      <details>
        <summary>Inspect intentional image failure</summary>
        <figure :for={entry <- @failures}>
          <img
            src={entry["src"]}
            alt={entry["alt"]}
            width={entry["width"]}
            height={entry["height"]}
            loading="lazy"
          />
          <figcaption>
            This image is intentionally missing. Its caption and alternative text remain; <a href="/media/ridge.svg">open an available landscape</a>.
          </figcaption>
        </figure>
      </details>
      <h2>Motion and replacement</h2>
      <p>
        Use System motion or Reduce motion in the header. System always respects your device setting. No force-animation choice exists. This evidence page itself starts no animation.
      </p>
      <p>
        Native checkbox, scroll and dialog state can reset when the application replaces markup. Applications own patch boundaries and restoration; ShadcnUI adds no state manager.
      </p>
      <h2>Reproduce this evidence</h2>
      <pre tabindex="0"><code>npm run capabilities:motion-media:check
    npm run browser:milestone-e-phase1</code></pre>
      <p>
        Run exact locked browsers and inspect fallbacks before claiming support. Source review and automatic checks do not replace keyboard and assistive-technology review.
      </p>
    </article>
    """
  end
end
