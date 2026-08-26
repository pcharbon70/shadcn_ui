defmodule ShadcnUIDemo.MediaReference do
  @moduledoc "Closed native media guidance; future controls are not advertised."
  def image_gallery do
    %{
      what:
        "Responsive image figures with captions, ordinary destinations and separate native Dialog enlargement.",
      when:
        "Use it for a finite image collection. Choose lightbox=:none for ordinary browsing or when embedding inside another modal.",
      responsibilities:
        "You own image rights/privacy, CSP/origin policy, safe authorized URLs, meaningful alt/names, intrinsic dimensions, responsive candidates and destinations. Loading/decoding are browser hints, not guaranteed deferred fetching. Replacement resets native state; restoration is yours.",
      accessibility:
        "Keyboard Enter opens a named native Dialog with an explicit close control. The browser owns focus, inertness, Tab and Escape. Keyboard-invoked close returns to the previously focused thumbnail; pointer focus follows platform conventions. No focus trap is added. Full images always contain, and long captions scroll with the existing sticky close footer.",
      semantics:
        "A named section with a list of figures, not a slideshow. Stable instance/item keys derive Dialog and caption identities. Each thumbnail button has a visible Enlarge name and a separate Open image link, never nested controls. No next/previous, selected image, swipe, zoom, pan, uploads, transformation, fetching service or listeners.",
      fallback:
        "Ordinary links remain visible without native commands, JavaScript or CSS. Destination priority is href, then full.src, then src. Failed images retain alt/name/caption/destination. The optional origin animation is deferred: Chromium reproduced it, Firefox/WebKit did not. All use existing native snap; missing anchors, transitions or reduced motion never prevent access.",
      api:
        "Required id, exactly one accessible_label/labelledby, nonempty atom-keyed images (unique key, src, alt, positive width/height). Optional name, caption, href, width-candidate srcset with sizes, loading=:lazy|:eager, decoding=:async|:sync|:auto, and full map with its own src/dimensions/srcset/sizes. Decorative:true requires empty alt and independent name. columns=:two|:three|:four (three), density=:compact|:comfortable (comfortable), fit=:cover|:contain (cover), lightbox=:dialog|:none (dialog), motion=:system|:none. initial_focus=:auto|:content|:close, dismissal=:close_request|:none|:any, close_label defaults Close image. context=:dialog rejects dialog mode. Optional escaped description, class/rest. Repeated trusted noninteractive caption slots require key and receive %{key: key, context: :thumbnail|:full}; scope IDs and never embed controls or dialogs.",
      source: ~S"""
      <.image_gallery id="landscapes" accessible_label="Local illustrations" images={[
        %{key: "ridge", src: "/media/ridge.svg", alt: "Angular mountain ridges beneath a warm sun",
          width: 640, height: 480, caption: "Original ridge illustration", href: "/media/ridge.svg",
          srcset: [%{src: "/media/ridge.svg", width: 640}], sizes: "(max-width: 40rem) 100vw, 33vw",
          full: %{src: "/media/ridge.svg", width: 640, height: 480}}
      ]} />
      """
    }
  end

  def cover_flow do
    %{
      what:
        "A complete native Carousel list of image figures with optional image-only depth as you scroll.",
      when:
        "Use it for a finite visual collection whose captions and ordinary destinations must remain readable. Choose flat when depth adds no value.",
      responsibilities:
        "You own image rights/privacy, URLs, alternative text, dimensions, responsive candidates, captions, destinations and restoration after replacement. The package does not fetch, resize, persist or select images.",
      accessibility:
        "Tab reaches the named native scroll region, destination links and real fragment index. Native arrows, wheel and touch scroll; index links focus their list item. Every item stays in document order. Images cannot capture another link's hit target; captions and links never transform.",
      semantics:
        "An ordered list of figures, not a slideshow, tab widget or selected-image model. Stable keys derive instance-local item/caption IDs and CSS timeline names. There are no clones, autoplay, fake controls, live announcements or generated scroll markers.",
      fallback:
        "Flat by default when a container is below 40rem, has one image, lacks joint view-timeline/range/scope/3D support, uses forced colors or suppresses motion. Enhanced is permission, not a promise. No document-clock substitute runs. Stationary sources do not advance depth. CSS-disabled and no-script output retain all figures, alt, captions and destinations; broken images retain meaning. Replacement may reset native scrolling and focus.",
      api:
        "Required id, exactly one accessible_label/labelledby (caller heading IDs), and nonempty images. Each atom-keyed record requires unique string key, src, explicit alt, positive width/height; optional name, escaped caption, href, width-candidate srcset plus sizes, loading=:lazy|:eager, decoding=:async|:sync|:auto. Decorative images need decorative:true, empty alt and independent name. presentation=:enhanced|:flat (enhanced default); snap=:none|:proximity|:mandatory, alignment=:start|:center, motion=:system|:none. Optional escaped description, class/rest; required semantics and generated style are protected. No slots or arbitrary transform/timeline input.",
      source: ~S"""
      <.cover_flow id="landscape-depth" accessible_label="Landscape illustrations" presentation={:enhanced}
        images={[
          %{key: "ridge", src: "/media/ridge.svg", alt: "Angular mountain ridges beneath a warm sun", width: 640, height: 480, caption: "An original ridge illustration", href: "/media/ridge.svg"},
          %{key: "harbor", src: "/media/harbor.svg", alt: "Harbor illustration", width: 640, height: 480, caption: "An original harbor illustration", href: "/media/harbor.svg"}
        ]} />
      """
    }
  end

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
