defmodule ShadcnUIDemo.Reference do
  @moduledoc "Authored English guidance and inert HEEX source for the closed catalogue."

  @references %{
    button: %{
      what: "A native button with closed visual variants, sizes, and rendered state snapshots.",
      when: "Use it for caller-owned actions and native form submission.",
      responsibilities: "The application owns activation, authorization, requests, duplicate prevention, and outcomes.",
      accessibility: "Icon presentation needs an explicit accessible label; disabled remains native.",
      fallback: "The native button and label remain available without CSS or JavaScript.",
      source: ~S(<.button type="submit" variant={:default}>Save changes</.button>)
    },
    badge: %{
      what: "A passive inline label with four closed visual variants.",
      when: "Use it to display concise caller-owned status text.",
      responsibilities: "The application owns status meaning and changes; Badge never navigates or dismisses.",
      accessibility: "Meaning is present in text and never relies on color alone.",
      fallback: "The span text remains readable without package styles.",
      source: ~S(<.badge variant={:secondary}>Pending review</.badge>)
    },
    alert: %{
      what: "Visible feedback with explicit none, polite, or assertive announcement policy.",
      when: "Use it for authored feedback whose announcement urgency is selected deliberately.",
      responsibilities: "The application owns insertion, dismissal, retry, lifecycle, and action outcomes.",
      accessibility: "Destructive color does not infer urgency; announcement policy determines role and live state.",
      fallback: "Title, description, and native actions remain available without JavaScript.",
      source: ~S(<.alert announcement={:polite} title="Draft saved" description="Your changes are available." />)
    },
    card: %{
      what: "A neutral bordered surface with composable authored regions.",
      when: "Use it to group related content without inventing workflow semantics.",
      responsibilities: "The application owns data, destinations, selection, submission, loading, and commands.",
      accessibility: "Caller headings, links, forms, and controls retain their native semantics.",
      fallback: "Content order and native elements remain intact without styles.",
      source: ~S(<.card><:title><h3>Preferences</h3></:title><form>...</form></.card>)
    },
    avatar: %{
      what: "Initials-first identity presentation with optional caller-owned imagery.",
      when: "Use it where an identity needs a stable textual fallback.",
      responsibilities: "The application owns image URLs, privacy, caching, uploads, loading, and failure policy.",
      accessibility: "A meaningful image alt replaces the initials as the accessible name without duplication.",
      fallback: "Initials stay in the DOM beneath unavailable imagery.",
      source: ~S(<.avatar initials="PC" image_src="/images/person.jpg" image_alt="Pascal Charbonneau" />)
    },
    skeleton: %{
      what: "A decorative placeholder with closed shape and size guidance.",
      when: "Use it inside a separately labelled caller-owned loading region.",
      responsibilities: "The application owns loading detection, announcements, errors, replacement, and layout.",
      accessibility: "Skeleton is always aria-hidden; label the meaningful region outside it.",
      fallback: "Reduced motion removes pulse while preserving geometry.",
      source: ~S(<section aria-busy="true" aria-label="Loading profile"><.skeleton shape={:circle} /></section>)
    }
  }

  def fetch!(render) when render in [:button, :badge, :alert, :card, :avatar, :skeleton],
    do: Map.fetch!(@references, render)

  def keys, do: Map.keys(@references)
end
