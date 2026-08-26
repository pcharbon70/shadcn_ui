defmodule ShadcnUIDemo.MotionReference do
  @moduledoc "Authored finite-motion guidance and complete public HEEx examples."

  def scroll_indicator do
    %{
      what:
        "A named native scroll region with an optional decorative position track outside its viewport.",
      when:
        "Use it to hint at local scrolling through a bounded content region. Do not use it to measure reading, task completion, loading or numeric progress.",
      responsibilities:
        "You own trusted content, headings, link destinations, form actions and scroll/focus restoration after replacement. The native example input only edits a local draft; reset restores its default and nothing is saved.",
      accessibility:
        "The named region is a Tab stop. Native arrows, Page Up/Down, Home/End, wheel and touch remain available according to browser behavior. Child links and forms keep native semantics. The aria-hidden track cannot cover content or focus and has no accessibility-tree value.",
      semantics:
        "One source and one instance-local decoration. There is no progressbar, percentage, live region, reading state, synchronized value or external scroll-target selector. Caller content is neither cloned nor hidden.",
      fallback:
        "The track stays neutral for short/nonoverflowing content, missing joint scroll-timeline/range/scope support, forced colors, motion=:none, an ancestor reduce scope or OS reduced motion. Nested system cannot re-enable it. Missing CSS retains the full document. No script supplies a fallback. Stationary sources never advance decoration; there is no timer, listener, observer, polling or perpetual animation. Native scroll and focus can reset on replacement.",
      api:
        "Required unique id, exactly one accessible_label/labelledby (existing caller heading IDs), and trusted inner_block. Optional escaped description, size=:small|:default|:large (12rem/20rem/32rem max height; default 20rem), motion=:system|:none, class/rest. Unrelated globals survive; required names, role, focus, CSS identity and motion markers are protected. No numeric value, arbitrary size or CSS selector input.",
      source: ~S"""
      <.scroll_indicator id="reading-notes" accessible_label="Reading notes" size={:small}
        description="Scroll to inspect the complete notes.">
        <p :for={n <- 1..12}>Complete reading note {n}.</p>
        <a href="/media/ridge.svg">Open the ridge illustration</a>
      </.scroll_indicator>
      """
    }
  end

  def marquee do
    %{
      what:
        "A complete presentation list with an optional, deliberately finite scrolling preview. This is not an endless ticker.",
      when:
        "Use it for a short decorative brand or topic collection. Keep important notices, live data and application actions outside moving presentation.",
      responsibilities:
        "You own item text, stable keys, image sources, rights, alternative text and intrinsic dimensions. Replacement can reset the native checkbox. Persisting stop preferences and restoring patch state belong to your application, not this component.",
      accessibility:
        "The visible native checkbox is initially unchecked: Space or a click enables one traversal. Uncheck to stop/reset after focus leaves; check again to replay. Checked means enabled, not currently playing. The canonical named list appears once in the accessibility tree. One inert, aria-hidden decorative copy has no IDs, links, actions, controls or meaningful duplicate image alt.",
      semantics:
        "Structured noninteractive records only; there is no arbitrary cloned HEEx slot. Canonical text and image alternatives remain native list content. The unnamed checkbox contributes no form value. The duplicate disappears after completion or interruption; there are no live announcements, playback state or package scripts.",
      fallback:
        "Static is the default. Preview needs the joint CSS :has, :dir, transform and animation gate. Without CSS, its control and duplicate remain hidden and all canonical items are available. motion=:none, ancestor data-shadcn-motion=reduce and OS reduced motion win over checking. System is not force-animation. Finite effects can finish offscreen; there is no visibility observer or hover-only stop.",
      api:
        "Required id, accessible_label and nonempty items. Each item: unique string key, nonblank escaped text, optional image map (src, alt, positive width/height, optional srcset/sizes/loading/decoding). Empty alt marks an image decorative beside its text. No href, events, raw HTML or arbitrary image globals. mode=:static|:preview; direction=:inline_start|:inline_end follows LTR/RTL; duration=:brief (2500ms)|:default (5000ms), no delay/repeat. motion=:system|:none. Root class/rest preserve unrelated globals while required identities, names, motion markers and style are protected.",
      source: ~S"""
      <.marquee id="topics" accessible_label="Illustrated topics" mode={:preview} duration={:brief}
        items={[
          %{key: "ridge", text: "Mountain walks", image: %{src: "/media/ridge.svg", alt: "Angular mountain ridges beneath a warm sun", width: 640, height: 480}},
          %{key: "harbor", text: "Harbor stories"},
          %{key: "grove", text: "Grove journals"}
        ]} />
      """
    }
  end

  def stagger do
    %{
      what:
        "Complete keyed content with an optional short fade or rise as the rendered content appears.",
      when:
        "Use it to decorate a small list or content group. Do not use it to defer required information, observe viewport entry or announce task progress.",
      responsibilities:
        "You own item semantics, actions, form submission, ordering and patch boundaries. Native inputs in this demo edit only local values and Reset restores defaults; nothing is saved. Replacement can replay the render-time effect and reset controls. There is no animation-once guarantee or application state synchronization.",
      accessibility:
        "DOM order, links and forms stay native. Content starts visible; animated opacity never drops below 0.5. Focus reveals an item immediately and cancels its effect. Removing CSS or interrupting the animation restores full visibility. Excess items beyond the one-second budget appear immediately.",
      semantics:
        "The default div wrapper does not claim a list. Choose as=:ul or :ol to render native li items. Stable keyed trusted HEEx slots are not cloned. The effect is optional presentation, not loading, readiness or a navigation widget.",
      fallback:
        "effect=:none is default. Missing animation CSS, motion=:none, ancestor data-shadcn-motion=reduce and OS reduced motion retain all content. There is no observer, looping offscreen work or viewport-enter trigger; a finite entrance can finish before you scroll to it. Reload to inspect render-time effects; restoring styles or replacing content can replay them.",
      api:
        "Required id and keyed item slots with trusted HEEx; optional slot class/rest. as=:div|:ul|:ol, effect=:none|:fade|:rise, preset=:quick (150ms duration / 50ms interval)|:default (250ms / 75ms). Only delay+duration <=1000ms is admitted; all excess items are immediate. motion=:system|:none, root class/rest. Required wrappers, IDs, roles, motion markers and generated numeric timing style are protected. No arbitrary duration, delay, selector or animation CSS input.",
      source: ~S"""
      <.stagger id="reading-list" as={:ol} effect={:rise} preset={:quick}>
        <:item key="ridge"><a href="/media/ridge.svg">Read the ridge illustration</a></:item>
        <:item key="harbor"><a href="/media/harbor.svg">Read the harbor illustration</a></:item>
        <:item key="note">
          <label>Local note <input name="local_note" value="Ready to explore" /></label>
        </:item>
      </.stagger>
      """
    }
  end
end
