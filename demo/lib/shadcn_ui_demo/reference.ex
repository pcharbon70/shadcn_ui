defmodule ShadcnUIDemo.Reference do
  @moduledoc "Authored English guidance and inert HEEX source for the closed catalogue."

  @references %{
    button: %{
      what: "A native button with closed visual variants, sizes, and rendered state snapshots.",
      when: "Use it for caller-owned actions and native form submission.",
      responsibilities:
        "The application owns activation, authorization, requests, duplicate prevention, and outcomes.",
      accessibility:
        "Icon presentation needs an explicit accessible label; disabled remains native.",
      fallback: "The native button and label remain available without CSS or JavaScript.",
      source: ~S(<.button type="submit" variant={:default}>Save changes</.button>)
    },
    badge: %{
      what: "A passive inline label with four closed visual variants.",
      when: "Use it to display concise caller-owned status text.",
      responsibilities:
        "The application owns status meaning and changes; Badge never navigates or dismisses.",
      accessibility: "Meaning is present in text and never relies on color alone.",
      fallback: "The span text remains readable without package styles.",
      source: ~S(<.badge variant={:secondary}>Pending review</.badge>)
    },
    alert: %{
      what: "Visible feedback with explicit none, polite, or assertive announcement policy.",
      when: "Use it for authored feedback whose announcement urgency is selected deliberately.",
      responsibilities:
        "The application owns insertion, dismissal, retry, lifecycle, and action outcomes.",
      accessibility:
        "Destructive color does not infer urgency; announcement policy determines role and live state.",
      fallback: "Title, description, and native actions remain available without JavaScript.",
      source:
        ~S(<.alert announcement={:polite} title="Draft saved" description="Your changes are available." />)
    },
    card: %{
      what: "A neutral bordered surface with composable authored regions.",
      when: "Use it to group related content without inventing workflow semantics.",
      responsibilities:
        "The application owns data, destinations, selection, submission, loading, and commands.",
      accessibility: "Caller headings, links, forms, and controls retain their native semantics.",
      fallback: "Content order and native elements remain intact without styles.",
      source: ~S(<.card><:title><h3>Preferences</h3></:title><form>...</form></.card>)
    },
    avatar: %{
      what: "Initials-first identity presentation with optional caller-owned imagery.",
      when: "Use it where an identity needs a stable textual fallback.",
      responsibilities:
        "The application owns image URLs, privacy, caching, uploads, loading, and failure policy.",
      accessibility:
        "A meaningful image alt replaces the initials as the accessible name without duplication.",
      fallback: "Initials stay in the DOM beneath unavailable imagery.",
      source:
        ~S(<.avatar initials="PC" image_src="/images/person.jpg" image_alt="Pascal Charbonneau" />)
    },
    skeleton: %{
      what: "A decorative placeholder with closed shape and size guidance.",
      when: "Use it inside a separately labelled caller-owned loading region.",
      responsibilities:
        "The application owns loading detection, announcements, errors, replacement, and layout.",
      accessibility: "Skeleton is always aria-hidden; label the meaningful region outside it.",
      fallback: "Reduced motion removes pulse while preserving geometry.",
      source:
        ~S(<section aria-busy="true" aria-label="Loading profile"><.skeleton shape={:circle} /></section>)
    }
  }

  @form_references %{
    field:
      {"A relationship-aware layout for one native control.",
       ~S(<.field id="email" name="email"><:label>Email</:label><:control :let={field}><input id={field.id} name={field.name} /></:control></.field>)},
    label:
      {"A native label with protected control association.",
       ~S(<.label for="email">Email</.label>)},
    help:
      {"Descriptive text linked to a control by the shared field contract.",
       ~S(<.help id="email-help">Use your work address.</.help>)},
    field_errors:
      {"Visible escaped validation messages with deterministic IDs.",
       ~S(<.field_errors errors={["Enter an email"]} ids={["email-error-1"]} />)},
    error_summary:
      {"A caller-placed list of form and linked field errors.",
       ~S(<.error_summary id="errors" heading="Review the form" errors={[{"email", "Enter an email"}]} />)},
    input:
      {"A native text-like input with shared field relationships.",
       ~S(<.input field={@form[:email]} type="email"><:label>Email</:label></.input>)},
    textarea:
      {"A native multiline text control with a stable sizing fallback.",
       ~S(<.textarea field={@form[:notes]}><:label>Notes</:label></.textarea>)},
    checkbox:
      {"A native checkbox for boolean or repeated submitted values.",
       ~S(<.checkbox field={@form[:remember]}><:label>Remember me</:label></.checkbox>)},
    radio_group:
      {"A native fieldset of radio inputs for one scalar choice.",
       ~S(<.radio_group field={@form[:contact]} options={@options}><:legend>Contact method</:legend></.radio_group>)},
    switch:
      {"A track-and-thumb presentation of the native boolean Checkbox contract.",
       ~S(<.switch field={@form[:alerts]}><:label>Email alerts</:label></.switch>)},
    native_select:
      {"A classic native select and the recommended picker floor.",
       ~S(<.native_select field={@form[:country]} options={@options}><:label>Country</:label></.native_select>)},
    enhanced_select:
      {"A capability-gated presentation over the same native select value.",
       ~S(<.enhanced_select field={@form[:country]} options={@options}><:label>Country</:label></.enhanced_select>)},
    slider:
      {"A native range input with browser-owned keyboard, reset, and submission.",
       ~S(<.slider field={@form[:volume]} min={0} max={100}><:label>Volume</:label></.slider>)},
    progress:
      {"A native snapshot of task completion, determinate or indeterminate.",
       ~S(<.progress id="report-progress" value={4} max={10}><:label>Report generation</:label></.progress>)},
    meter:
      {"A native scalar measurement within a known range, never task progress.",
       ~S(<.meter id="storage" value={72} min={0} max={100}><:label>Storage use</:label></.meter>)}
  }

  @content_references %{
    accordion:
      {"Native details and summary disclosure in independent or progressively exclusive groups.",
       ~S(<.accordion id="faq"><:item key="billing" summary="Billing">Billing details.</:item></.accordion>),
       "Native summary activation, focus, and find-in-page remain browser-owned; unsupported exclusive grouping remains independently operable."},
    navigation_menu:
      {"Named destination navigation built from a native nav, list, and real anchors.",
       ~S(<.navigation_menu accessible_name="Primary"><:item key="home" destination="/" label="Home" current={:page} /></.navigation_menu>),
       "Applications own destinations and current-route choice. This is link navigation, not a menu, command bar, Radio Panels group, or tab widget."},
    header:
      {"A native header composition for caller-owned brand, navigation, utilities, and actions.",
       ~S(<.header><:brand><a href="/">Brand</a></:brand><:actions><.button>Save</.button></:actions></.header>),
       "The caller owns headings, landmark names, commands, forms, and navigation; sticky presentation falls back to normal flow."},
    section_header:
      {"A section-heading composition that preserves the caller-authored heading level.",
       ~S(<.section_header><:heading><h2>Billing</h2></:heading><:actions><.button>Edit</.button></:actions></.section_header>),
       "The caller owns heading hierarchy and actions. Sticky and target decoration are optional presentation with normal-flow fallback."},
    scroll_area:
      {"One native overflow container with explicit axis, size, focus, and decorative edge choices.",
       ~S(<.scroll_area focusable accessible_label="Activity">Long caller content.</.scroll_area>),
       "Native scrolling is authoritative. The application owns dimensions, restoration, loading, and virtualization; edge cues disappear safely."},
    separator:
      {"A native hr for semantic separation or an aria-hidden decorative boundary.",
       ~S(<.separator orientation={:horizontal} mode={:semantic} />),
       "The caller decides whether a boundary is meaningful. Content order remains intact without CSS."},
    radio_panels:
      {"A native radio group paired with deterministically related caller-owned panel content.",
       ~S(<.radio_panels id="view" name="view" selected="summary"><:legend>View</:legend><:option key="summary" value="summary" label="Summary">Summary content.</:option></.radio_panels>),
       "Native radio keys and submission remain authoritative. This is not a Tab Group; without enhancement CSS every panel remains visible."}
  }

  def fetch!(render) when render in [:button, :badge, :alert, :card, :avatar, :skeleton] do
    @references
    |> Map.fetch!(render)
    |> Map.put(
      :semantics,
      "The caller's native elements, names, and document relationships remain authoritative."
    )
  end

  def fetch!(render) when is_map_key(@form_references, render) do
    {what, source} = Map.fetch!(@form_references, render)

    %{
      what: what,
      when: "Use it when its native HTML meaning matches the caller-owned form requirement.",
      responsibilities:
        "The application owns changesets, translation, validation timing, submission, persistence, authorization, pending transitions, focus, and outcomes.",
      accessibility:
        "Visible labels and deterministic help and error relationships preserve the native accessible name and description contract.",
      semantics:
        "Explicit identity takes precedence over FormField values. Protected identity and ARIA relationships cannot be contradicted through global attributes.",
      comparison: comparison(render),
      fallback: fallback(render),
      source: source
    }
  end

  def fetch!(render) when is_map_key(@content_references, render) do
    {what, source, semantics} = Map.fetch!(@content_references, render)

    %{
      what: what,
      when:
        "Use it when its native document or form semantics match the caller-owned requirement.",
      responsibilities: semantics,
      accessibility:
        "Native elements, names, relationships, focus, and keyboard behavior remain authoritative.",
      semantics: semantics,
      comparison: comparison(render),
      fallback:
        "No script is required. Without package CSS or an optional feature, content and native controls remain available in source order.",
      source: source
    }
  end

  def fetch!(render)
      when render in [
             :dialog,
             :alert_dialog,
             :drawer,
             :popover,
             :dropdown_actions,
             :tooltip,
             :hover_card
           ],
      do: ShadcnUIDemo.OverlayReference.fetch!(render)

  def fetch!(:carousel), do: ShadcnUIDemo.MediaReference.carousel()
  def fetch!(:cover_flow), do: ShadcnUIDemo.MediaReference.cover_flow()
  def fetch!(:scroll_indicator), do: ShadcnUIDemo.MotionReference.scroll_indicator()
  def fetch!(:marquee), do: ShadcnUIDemo.MotionReference.marquee()
  def fetch!(:stagger), do: ShadcnUIDemo.MotionReference.stagger()

  def keys,
    do:
      Map.keys(@references) ++
        Map.keys(@form_references) ++
        Map.keys(@content_references) ++
        ShadcnUIDemo.OverlayReference.keys() ++
        [:carousel, :marquee, :stagger, :cover_flow, :scroll_indicator]

  defp fallback(:textarea),
    do: "Unsupported browsers keep the fixed native textarea instead of CSS content sizing."

  defp fallback(:enhanced_select),
    do:
      "Unsupported or CSS-disabled browsers keep the exact visible classic native select and value."

  defp fallback(_render),
    do:
      "The native element, text, values, and document order remain usable without package CSS or JavaScript."

  defp comparison(render) when render in [:checkbox, :switch],
    do:
      "Use Checkbox for an ordinary form choice such as accepting terms. Use Switch for a boolean setting such as enabling notifications; both submit the same native checkbox contract."

  defp comparison(render) when render in [:native_select, :enhanced_select],
    do:
      "Use Native Select for the dependable platform picker. Choose Enhanced Select only when its optional presentation is useful; country values, reset, and submission stay identical."

  defp comparison(render) when render in [:progress, :meter],
    do:
      "Use Progress for completion of a task such as generating a report. Use Meter for a scalar measurement such as storage use; Meter never means task completion."

  defp comparison(:navigation_menu),
    do:
      "Use Navigation Menu links to change destination. Use Button for commands and Radio Panels to submit one native choice."

  defp comparison(:radio_panels),
    do:
      "Radio Panels uses native form radios. True tabs require tab roles, focus management, and a separately approved keyboard runtime."

  defp comparison(_render), do: nil
end
