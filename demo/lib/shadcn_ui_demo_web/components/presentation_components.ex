defmodule ShadcnUIDemoWeb.PresentationComponents do
  @moduledoc "Gallery-only documentation presentation primitives."

  use Phoenix.Component

  alias ShadcnUIDemo.PresentationCatalogue

  @layouts PresentationCatalogue.layout_identities()
  @capability_identities PresentationCatalogue.feature_identities()

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :source, :string, required: true
  attr :source_id, :string, required: true
  attr :theme, :string, required: true, values: ~w(light dark)
  attr :motion, :string, required: true, values: ~w(system reduce)
  attr :layout, :string, default: "centered", values: @layouts
  slot :preview, required: true
  slot :actions

  def specimen(assigns) do
    assigns =
      assigns
      |> assign(:layout_class, PresentationCatalogue.layout_class!(assigns.layout))
      |> assign(:highlighted_source, highlight_heex(assigns.source))

    ~H"""
    <figure
      class={["gallery-specimen", @layout_class]}
      data-gallery-specimen={@id}
      data-gallery-specimen-source-id={@source_id}
      data-gallery-specimen-layout={@layout}
      data-gallery-specimen-theme={@theme}
      data-gallery-specimen-motion={@motion}
    >
      <figcaption class="gallery-specimen__caption">{@label}</figcaption>
      <fieldset class="gallery-specimen__views">
        <legend class="gallery-visually-hidden">Choose specimen view</legend>
        <div class="gallery-specimen__toolbar">
          <div class="gallery-specimen__view-controls">
            <input
              id={"#{@id}-view-preview"}
              type="radio"
              name={"#{@id}-view"}
              value="preview"
              checked
            />
            <label for={"#{@id}-view-preview"}>Preview</label>
            <input id={"#{@id}-view-code"} type="radio" name={"#{@id}-view"} value="code" />
            <label for={"#{@id}-view-code"}>Code</label>
          </div>
          <div :if={@actions != []} class="gallery-specimen__actions">
            {render_slot(@actions)}
          </div>
        </div>

        <section
          id={"#{@id}-preview"}
          class="gallery-specimen__panel gallery-specimen__preview"
          aria-label={"#{@label} rendered preview"}
          tabindex="-1"
          data-gallery-specimen-preview
        >
          {render_slot(@preview)}
        </section>

        <section
          id={"#{@id}-source"}
          class="gallery-specimen__panel gallery-specimen__code"
          aria-label={"#{@label} HEEx source"}
          tabindex="-1"
          data-gallery-specimen-source
          data-gallery-source-language="heex"
        >
          <h3 class="gallery-visually-hidden">HEEX source</h3>
          <div class="gallery-specimen__code-actions">
            <button
              type="button"
              data-gallery-copy={"#{@id}-code"}
              aria-describedby={"#{@id}-copy-status"}
            >Copy source</button>
            <span
              id={"#{@id}-copy-status"}
              class="gallery-copy-status"
              aria-live="polite"
            ></span>
          </div>
          <pre id={"#{@id}-code"} tabindex="0"><code>{@highlighted_source}</code></pre>
        </section>
      </fieldset>
    </figure>
    """
  end

  attr :id, :string, required: true
  attr :identity, :string, required: true, values: @capability_identities
  attr :label, :string, required: true
  attr :description, :string, required: true

  def capability_badge(assigns) do
    ~H"""
    <span
      class="gallery-capability-badge"
      data-gallery-capability={@identity}
      data-gallery-capability-policy="authored"
      aria-describedby={"#{@id}-description"}
    >
      <span aria-hidden="true" class="gallery-capability-badge__mark"></span>
      {@label}
      <span id={"#{@id}-description"} class="gallery-visually-hidden">{@description}</span>
    </span>
    """
  end

  attr :label, :string, required: true
  attr :rows, :list, required: true

  def support_table(assigns) do
    ~H"""
    <div
      class="gallery-support-table"
      data-gallery-support-table
      tabindex="0"
      role="region"
      aria-label={@label}
    >
      <table>
        <caption>{@label}</caption>
        <thead>
          <tr>
            <th scope="col">Feature</th>
            <th scope="col">Locked-engine evidence</th>
            <th scope="col">When missing</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={row <- @rows}>
            <th scope="row">{Map.fetch!(row, :feature)}</th>
            <td>{Map.fetch!(row, :evidence)}</td>
            <td>{Map.fetch!(row, :fallback)}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def presentation_fixture(assigns) do
    assigns =
      assigns
      |> assign(:layouts, @layouts)
      |> assign(
        :fixture_source,
        ~S(<.button id="deterministic-long-identifier-for-keyboard-overflow-evidence" variant={:outline}>Save translated preferences safely</.button>)
      )
      |> assign(:support_rows, [
        %{
          feature: "Native radio selection",
          evidence: "Locked Chromium, Firefox, and WebKit exercise the ordinary radio group.",
          fallback: "Without presentation CSS, Preview and Code remain visible in source order."
        },
        %{
          feature: "Optional source copy feedback",
          evidence: "The locked demo-script check records success and failure text.",
          fallback:
            "Source remains selectable and keyboard-scrollable when copying is unavailable."
        }
      ])

    ~H"""
    <article class="gallery-presentation-fixture" data-gallery-presentation-fixture>
      <header>
        <p class="gallery-presentation-fixture__eyebrow">Presentation system fixture</p>
        <h2>Reusable documentation surfaces</h2>
        <p>
          This checked fixture keeps prose, every closed preview layout, capability identities,
          long source, empty actions, and exact fallback evidence together.
        </p>
      </header>

      <section data-gallery-prose-fixture>
        <h3>Readable prose and durable anchors</h3>
        <p>
          Unicode remains authored text: español, العربية, 日本語. Long identifiers such as
          <code>deterministic_long_identifier_for_gallery_presentation_evidence</code>
          wrap safely.
        </p>
        <ul>
          <li>Landmarks and heading order stay independent of typography.</li>
          <li><a href="#presentation-support">Ordinary fragments remain addressable.</a></li>
        </ul>
        <blockquote>
          Fallback meaning stays visible instead of becoming a color-only promise.
        </blockquote>
      </section>

      <section class="gallery-presentation-fixture__badges" aria-label="Capability identity examples">
        <.capability_badge
          :for={
            {identity, label} <- [
              {"authored-policy", "Authored policy"},
              {"native-baseline", "Native baseline"},
              {"progressive-enhancement", "Progressive enhancement"},
              {"fallback", "Exact fallback"}
            ]
          }
          id={"presentation-#{identity}"}
          identity={identity}
          label={label}
          description={"Closed #{label} identity; not a visitor-specific support claim."}
        />
      </section>

      <section class="gallery-presentation-fixture__specimens" aria-label="Closed specimen layouts">
        <.specimen
          :for={{layout, index} <- Enum.with_index(@layouts)}
          id={"presentation-fixture-#{layout}"}
          label={"#{String.capitalize(layout)} preview layout"}
          source={@fixture_source}
          source_id={"fixture:#{layout}"}
          theme="light"
          motion="reduce"
          layout={layout}
        >
          <:preview>
            <div class="gallery-presentation-fixture__sample">
              <strong>{index + 1}. {String.capitalize(layout)}</strong>
              <span>Complete rendered content remains in document order.</span>
            </div>
          </:preview>
          <:actions :if={layout == "centered"}>
            <a href="#presentation-support">Support evidence</a>
          </:actions>
        </.specimen>
      </section>

      <section id="presentation-support">
        <h3>Support evidence</h3>
        <.support_table label="Presentation system support and fallback" rows={@support_rows} />
      </section>
    </article>
    """
  end

  def highlight_heex(source) when is_binary(source) do
    token = ~r/(<!--[\s\S]*?-->|<%[\s\S]*?%>|<\/?[A-Za-z][A-Za-z0-9_.:-]*|\/?\s*>)/

    token
    |> Regex.split(source, include_captures: true, trim: false)
    |> Enum.map(fn part ->
      escaped = part |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()

      cond do
        String.starts_with?(part, "<!--") ->
          ~s(<span class="gallery-code-comment">#{escaped}</span>)

        String.starts_with?(part, "<%") ->
          ~s(<span class="gallery-code-expression">#{escaped}</span>)

        Regex.match?(~r/^<\/?[A-Za-z]/, part) ->
          ~s(<span class="gallery-code-tag">#{escaped}</span>)

        Regex.match?(~r/^\/?\s*>$/, part) ->
          ~s(<span class="gallery-code-tag">#{escaped}</span>)

        true ->
          escaped
      end
    end)
    |> Phoenix.HTML.raw()
  end
end
