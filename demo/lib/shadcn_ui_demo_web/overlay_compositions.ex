defmodule ShadcnUIDemoWeb.OverlayCompositions do
  use Phoenix.Component
  use ShadcnUI
  alias ShadcnUIDemo.OverlayCapabilities
  @moduledoc "Deterministic native examples, not application workflows or compatibility shims."

  attr :render, :atom, required: true

  def overlay_composition(%{render: :overlay_capabilities} = assigns) do
    assigns =
      assign(assigns,
        rows: OverlayCapabilities.rows(),
        engines: OverlayCapabilities.engines(),
        evidence: OverlayCapabilities.evidence(),
        manifest: OverlayCapabilities.manifest()
      )

    ~H"""
    <article data-gallery-composition="overlay-capabilities">
      <p>
        Reviewed <time>{@evidence["reviewedOn"]}</time>. Support is defined by web-platform capabilities, not a consuming application or one browser brand.
      </p>
      <p>
        These are observed property/syntax checks from locked test browsers, not proof of every interaction. The same semantic fixtures test native behavior across all three engines.
      </p>
      <div
        class="gallery-table-scroll"
        tabindex="0"
        role="region"
        aria-label="Overlay capability matrix"
      >
        <table>
          <caption>Policy, exact browser evidence, and ordinary fallback</caption>
          <thead>
            <tr>
              <th scope="col">Feature and authoritative source</th><th scope="col">Package policy</th><th
                :for={{engine, record} <- @engines}
                scope="col"
              >
                {engine} {record["version"]}
              </th><th scope="col">Fallback</th>
            </tr>
          </thead>
          <tbody>
            <tr :for={row <- @rows} data-capability={row.key}>
              <th scope="row"><a href={row.source}>{row.label}</a></th><td>{row.status}</td>
              <td :for={{_engine, record} <- @engines}>
                {if record["capabilities"][row.key], do: "Detected", else: "Not detected"}
              </td><td>{row.fallback}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <h2>Choose and verify your browser support</h2>
      <ul>
        <li :for={{set, features} <- Enum.sort(@manifest["componentCapabilitySets"])}>
          <strong>{set}:</strong> {Enum.join(features, ", ")}
        </li>
      </ul>
      <p>
        Require the complete native capability set for the component you choose. Test your own browsers with keyboard, pointer and assistive technology, and always provide an ordinary destination. Do not infer behavior from a user-agent string.
      </p>
      <h2>Update evidence independently</h2>
      <p>
        Review authoritative sources when browser locks or fallback policy change. Update the authored package manifest, run the same cross-engine semantic suites, then regenerate and check the demo-only record with <code>node scripts/record-overlay-capabilities.mjs</code>. No current-visitor sniffing, component shim or event runtime is installed.
      </p>
      <p>
        Scoped RTL supplemental anchors use normal-flow fallback across engines. Native keyboard preferences may skip links, and native focus restoration can vary. These limits are tested and documented rather than repaired with scripts.
      </p>
      <nav aria-label="Try complete overlay examples">
        <a
          :for={item <- ShadcnUIDemo.Catalogue.compositions()}
          :if={
            item.render in [
              :settings_confirmation,
              :responsive_drawers,
              :anchored_actions,
              :supplemental_help
            ]
          }
          href={item.path}
        >{item.label}</a>
      </nav>
    </article>
    """
  end

  def overlay_composition(%{render: :settings_confirmation} = assigns) do
    ~H"""
    <article data-gallery-composition="settings-confirmation" class="gallery-overlay-examples">
      <p>
        Native local forms demonstrate validation and cancellation. The rejected and pending examples are authored server-style snapshots, not real requests. Nothing is saved or deleted.
      </p>
      <.dialog id="settings-edit" initial_focus={:content}>
        <:trigger>Edit local preferences</:trigger><:title>Local preferences</:title><:description>
          Enter a display name; Finish closes this native dialog only.
        </:description>
        <form method="dialog">
          <label>Display name <input id="settings-name" name="display_name" required /></label><button id="settings-finish">Finish local example</button><button type="reset">Reset</button>
        </form>
        <:close>Cancel editing</:close><:fallback>
          <a href="#settings-inline">Preferences without dialogs</a>
        </:fallback>
      </.dialog>
      <.alert_dialog id="settings-confirm">
        <:trigger>Review sample discard</:trigger><:title>Discard this sample draft?</:title><:description>
          This demonstrates a consequential choice without executing one.
        </:description>
        <:cancel>Keep sample draft</:cancel><:action>
          <form method="dialog"><button value="discard">Acknowledge sample discard</button></form>
        </:action>
        <:fallback><a href="#settings-inline">Decision without a dialog</a></:fallback>
      </.alert_dialog>
      <.alert_dialog id="settings-rejected">
        <:trigger>Inspect rejected snapshot</:trigger><:title>Sample request rejected</:title><:description>
          An application could render this error after validating a request.
        </:description>
        <p role="alert">
          Example rejection: the draft changed. Review the latest content before trying again.
        </p>
        <:cancel>Return to draft</:cancel><:action>
          <form method="dialog"><button value="review">Acknowledge rejection</button></form>
        </:action>
        <:fallback><a href="#settings-inline">Read the rejection inline</a></:fallback>
      </.alert_dialog>
      <section id="settings-inline">
        <h2>Complete inline preferences and decision</h2>
        <p>Example rejection: the draft changed. Review the latest content before trying again.</p>
        <form>
          <label>Local display name <input name="display_name" value="Sample reader" /></label><button type="reset">Reset local preferences</button>
        </form>
        <button type="button" disabled>Pending snapshot — not an active request</button>
        <p>
          A real application owns validation, authorization, persistence and results. Cancel and explicit exits remain available; do not nest these modal dialogs.
        </p>
      </section>
      <.replacement_guidance />
    </article>
    """
  end

  def overlay_composition(%{render: :responsive_drawers} = assigns) do
    ~H"""
    <article data-gallery-composition="responsive-drawers" class="gallery-overlay-examples">
      <p>
        Try all three logical edges at narrow and wide widths. These are separate caller-selected examples, not an automatic breakpoint state machine.
      </p>
      <.drawer
        :for={edge <- [:start, :end, :bottom]}
        id={"filters-#{edge}"}
        edge={edge}
        initial_focus={:content}
      >
        <:trigger>Open {edge} filters</:trigger><:title>Filters and record details</:title><:description>
          Native scrolling keeps the concise header, footer and exit accessible.
        </:description>
        <form id={"filters-form-#{edge}"}>
          <label>Local filter <input name="filter" value="All records" /></label><button type="reset">Reset filter</button>
        </form>
        <.popover id={"filter-help-#{edge}"}>
          <:trigger>Show filter options</:trigger><:title>Optional filter options</:title><label><input type="checkbox" />
          Include archived samples</label>
          <:close>Close filter options</:close><:fallback>
            <a href="#filters-inline">Options inline</a>
          </:fallback>
        </.popover>
        <p :for={n <- 1..20}>
          Record {n}: Long translated details — Zusätzliche Informationen bleiben im Dokument verfügbar.
        </p>
        <:footer>Local fixture; no query or persistence.</:footer><:close>Close filters</:close><:fallback>
          <a href="#filters-inline">Filters and details without drawers</a>
        </:fallback>
      </.drawer>
      <section id="filters-inline">
        <h2>Complete inline filters and details</h2><form>
          <label>Local filter <input name="filter" value="All records" /></label><label><input type="checkbox" />
          Include archived samples</label><button type="reset">Reset filters</button>
        </form>
        <p :for={n <- 1..20}>
          Record {n}: Long translated details — Zusätzliche Informationen bleiben im Dokument verfügbar.
        </p>
      </section>
      <.replacement_guidance />
    </article>
    """
  end

  def overlay_composition(%{render: :anchored_actions} = assigns) do
    ~H"""
    <article data-gallery-composition="anchored-actions" class="gallery-overlay-examples">
      <p>
        Scroll the local host and open edge-positioned actions. Native Popover owns the top layer; CSS may flip near viewport edges.
      </p>
      <form id="document-draft">
        <label>Local document draft <input name="draft" value="Original draft" /></label>
      </form>
      <div
        class="gallery-action-scroll"
        tabindex="0"
        role="region"
        aria-label="Scrollable action examples"
      >
        <div class="gallery-action-row">
          <.popover id="edge-popover" placement={:inline_start}>
            <:trigger>Open edge options</:trigger><:title>Display options</:title><label><input type="checkbox" />
            Compact sample rows</label>
            <:close>Close edge options</:close><:fallback>
              <a href="#actions-inline">Options inline</a>
            </:fallback>
          </.popover>
          <.dropdown_actions
            id="document-actions"
            accessible_label="Local document actions"
            placement={:inline_end}
          >
            <:trigger>Open document actions</:trigger><:action
              key="read"
              kind={:link}
              destination="#actions-inline"
              label="Read full document"
            />
            <:action key="reset" type="reset" form="document-draft" label="Reset local draft" /><:action
              key="pending"
              label="Pending snapshot"
              disabled
            />
            <:fallback><a href="#actions-inline">All actions inline</a></:fallback>
          </.dropdown_actions>
        </div>
        <p :for={n <- 1..8}>Scrollable sample row {n}.</p>
      </div>
      <.popover id="manual-actions" mode={:manual} action={:show}>
        <:trigger>Show persistent manual note</:trigger><:title>Manual mode note</:title><p>
          Outside clicks and Escape do not close this surface.
        </p>
        <:close>Hide manual note</:close><:fallback>
          <a href="#actions-inline">Read the note inline</a>
        </:fallback>
      </.popover>
      <section id="actions-inline">
        <h2>Complete document and ordinary actions</h2><p>
          This is the complete local document. Manual mode stays open until explicitly hidden. No operation is sent to a server.
        </p><label><input type="checkbox" /> Compact sample rows</label><button
          type="reset"
          form="document-draft"
        >Reset local draft inline</button>
      </section>
      <.replacement_guidance />
    </article>
    """
  end

  def overlay_composition(%{render: :supplemental_help} = assigns) do
    assigns =
      assign(assigns, :translated, String.duplicate("Zusätzlicher Kontext — معلومات إضافية. ", 5))

    ~H"""
    <article data-gallery-composition="supplemental-help" class="gallery-overlay-examples">
      <p>
        All instructions are visible below. Keyboard focus and fine-pointer hover may add context; touch follows the complete ordinary link.
      </p>
      <.tooltip id="help-tip" text="The manual is also available as plain text.">
        <:trigger kind={:link} label="Read the complete manual" href="#help-manual" />
      </.tooltip>
      <.hover_card id="help-card">
        <:trigger label="Read the complete guide" href="#help-manual" /><h3>Guide preview</h3><p>
          Practical guidance for native controls, also available below.
        </p>
      </.hover_card>
      <div dir="rtl">
        <.tooltip id="help-translated" text={@translated}>
          <:trigger kind={:link} label="Read translated guidance" href="#help-manual" />
        </.tooltip>
      </div>
      <section id="help-manual">
        <h2>Complete manual and required help</h2><p>
          Use native links to navigate and buttons to act. Save your work before leaving a real application. The manual is also available as plain text.
        </p><p>Practical guidance for native controls, also available below.</p><p dir="rtl">
          {@translated}
        </p>
      </section>
      <p>
        No private data, unique task information or required actions belong in a preview. No data is fetched on hover; the application owns content freshness and privacy. Clipping may hide an optional preview, never the complete link.
      </p>
      <.replacement_guidance />
    </article>
    """
  end

  defp replacement_guidance(assigns) do
    ~H"""
    <section>
      <h2>Fallback and replacement</h2><p>
        Native invocation works without demo scripts when its capabilities exist. Missing invokers use the visible inline alternative. No anchors retains bounded default placement; no transitions or reduced motion snaps. Narrow layouts wrap; forced colors retains borders and focus. Supplemental RTL, no-hover and coarse-pointer paths retain the ordinary link and required content.
      </p><p>
        Replacing an open subtree may close it and lose focus. Applications own patch boundaries and any reinvocation; the package has no state synchronization or restoration script. Reload this page to inspect the fresh closed snapshot.
      </p>
    </section>
    """
  end
end
