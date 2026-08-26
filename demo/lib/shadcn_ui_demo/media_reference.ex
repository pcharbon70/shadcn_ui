defmodule ShadcnUIDemo.MediaReference do
  @moduledoc "Closed Carousel guidance; future media controls are not advertised."
  def carousel do
    %{
      what:
        "A complete ordered list in a named native horizontal scroll region, with real item links.",
      when:
        "Use it to browse a finite collection while keeping every card and its ordinary destinations available.",
      responsibilities:
        "You own content, image rights/privacy, alternative text, intrinsic sizes, destinations, form actions and scroll restoration after replacement. This demo only edits local form controls; reset really restores their defaults.",
      accessibility:
        "Tab reaches the named region and native child controls according to browser keyboard preferences (some skip links). Arrow keys, touch, wheel and item links use native scrolling. Index links focus their item; no roving focus or live announcements are supplied. Focus outlines and logical padding remain visible in RTL, narrow and zoomed layouts.",
      semantics:
        "One named region contains an ordered list. Stable item keys generate unique fragment targets. An item link is not remote pagination, an active slide or synchronized selection. There are no tab/menu/listbox roles, fake previous/next buttons, clones, autoplay or generated scroll controls.",
      fallback:
        "Without snap, ordinary scrolling remains. Without CSS, every item and real index link forms a complete ordered document. Without JavaScript, all component operations still work. Reduce motion, motion=:none or your system preference removes smooth scrolling, not navigation.",
      api:
        "Required: unique id and exactly one of accessible_label / labelledby (existing heading IDs). Optional escaped description. Repeated item slots require nonblank key, label and trusted HEEx body, and accept class/rest. snap=:none|:proximity|:mandatory (proximity default), alignment=:start|:center (start default), motion=:system|:none (system default). Root class/rest preserve unrelated caller styling and framework globals; required native identities, roles, focus and names are protected. No raw HTML or active-slide attribute exists.",
      source: ~S"""
      <.carousel id="landscapes" accessible_label="Landscape collection"
        description="Scroll or follow an item link." snap={:proximity} alignment={:start}>
        <:item key="ridge" label="Mountain ridge">
          <h3>Mountain ridge</h3>
          <img src="/media/ridge.svg" width="640" height="480" alt="Angular mountain ridges beneath a warm sun" />
          <a href="/media/ridge.svg">Open complete ridge image</a>
        </:item>
        <:item key="harbor" label="Harbor">
          <h3>Harbor</h3>
          <a href="/media/harbor.svg">Open complete harbor image</a>
        </:item>
      </.carousel>
      """
    }
  end
end
