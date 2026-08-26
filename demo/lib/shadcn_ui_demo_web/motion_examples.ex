defmodule ShadcnUIDemoWeb.MotionExamples do
  use ShadcnUIDemoWeb, :html
  alias ShadcnUIDemo.GalleryPreferences

  defp items do
    [
      %{
        key: "ridge",
        text: "Mountain walks",
        image: %{
          src: "/media/ridge.svg",
          alt: "Angular mountain ridges beneath a warm sun",
          width: 640,
          height: 480
        }
      },
      %{key: "harbor", text: "Harbor stories"},
      %{
        key: "grove",
        text: "A longer grove journal title that wraps without losing its complete text"
      }
    ]
  end

  def marquee_examples(assigns) do
    assigns = assign(assigns, :items, items())

    ~H"""
    <div class="gallery-motion-examples">
      <h3>Complete static default</h3>
      <.marquee id="marquee-static" accessible_label="Static illustrated topics" items={@items} />
      <h3>Enable, stop, reset and replay</h3>
      <p>The short preview lasts 2.5 seconds. Uncheck at any time to stop; check again to replay.</p>
      <.marquee
        id="marquee-preview"
        accessible_label="Illustrated topics"
        items={@items}
        mode={:preview}
        duration={:brief}
      />
      <h3>Opposite logical direction and five-second budget</h3>
      <.marquee
        id="marquee-opposite"
        accessible_label="Opposite direction topics"
        items={@items}
        mode={:preview}
        direction={:inline_end}
      />
      <h3>Translated presentation in a right-to-left scope</h3>
      <div dir="rtl" lang="ar">
        <.marquee
          id="marquee-rtl"
          accessible_label="مواضيع للقراءة"
          mode={:preview}
          duration={:brief}
          items={[%{key: "one", text: "رحلات الجبال"}, %{key: "two", text: "حكايات المرفأ والحدائق"}]}
        />
      </div>
      <h3>Explicit motion suppression</h3>
      <.marquee
        id="marquee-none"
        accessible_label="Suppressed topics"
        items={@items}
        mode={:preview}
        motion={:none}
      />
      <a href="/examples/motion-preferences">Compare system and reduced motion</a>
    </div>
    """
  end

  def stagger_examples(assigns) do
    ~H"""
    <div class="gallery-motion-examples">
      <p>
        Reload this page to inspect the short render-time effects. Tab to any input to reveal it immediately. These are local editing examples, not saved data.
      </p>
      <form :for={effect <- [:none, :fade, :rise]}>
        <h3>{effect} effect</h3>
        <.stagger id={"stagger-#{effect}"} as={:ol} effect={effect}>
          <:item key="first" class="gallery-motion-item">
            <a href="/media/ridge.svg">Open the complete ridge illustration</a>
          </:item>
          <:item key="second" class="gallery-motion-item">
            <label>Local note ({effect}) <input name="note" value="A complete readable default" /></label>
          </:item>
          <:item key="third" class="gallery-motion-item">
            <button type="reset">Reset {effect} example</button>
          </:item>
        </.stagger>
      </form>
      <h3>Long collection: excess items are immediate</h3>
      <.stagger id="stagger-long" as={:ul} effect={:rise} preset={:quick}>
        <:item :for={n <- 1..20} key={"entry-#{n}"} class="gallery-motion-item">
          Reading entry {n}: complete text in document order.
        </:item>
      </.stagger>
      <h3>Suppressed nested content remains usable</h3>
      <div data-shadcn-motion="reduce">
        <div data-shadcn-motion="system">
          <.stagger id="stagger-suppressed" effect={:rise}>
            <:item key="link">
              <a href="/examples/motion-preferences">Inspect motion preferences</a>
            </:item>
          </.stagger>
        </div>
      </div>
    </div>
    """
  end

  attr :theme, :string, required: true

  def motion_preferences(assigns) do
    assigns = assign(assigns, :items, items())

    ~H"""
    <div class="gallery-motion-examples">
      <p>
        System respects your operating-system preference; it never forces animation. Reduce removes decorative motion. Both links retain the selected color theme and work without JavaScript.
      </p>
      <nav aria-label="Motion examples preference">
        <a
          :for={{value, label} <- [{"system", "Follow system motion"}, {"reduce", "Reduce motion"}]}
          href={GalleryPreferences.link("/examples/motion-preferences", @theme, value)}
          data-gallery-preference
          data-gallery-light-href={
            GalleryPreferences.link("/examples/motion-preferences", "light", value)
          }
          data-gallery-dark-href={
            GalleryPreferences.link("/examples/motion-preferences", "dark", value)
          }
        >{label}</a>
      </nav>
      <h2>Try a finite preview</h2>
      <.marquee
        id="preferences-preview"
        accessible_label="Preference topics"
        items={@items}
        mode={:preview}
        duration={:brief}
      />
      <p>
        Stop/reset persists locally while unchecked. A completed preview leaves the checkbox checked, not a false playing indicator. Reloading or replacing markup can reset it; saving preferences belongs to your application.
      </p>
      <h2>Try native content inside an entrance effect</h2>
      <form>
        <.stagger id="preferences-stagger" effect={:rise} preset={:quick}>
          <:item key="note">
            <label>Local reading note <input name="note" value="Explore at your pace" /></label>
          </:item>
          <:item key="reset"><button type="reset">Reset local note</button></:item>
        </.stagger>
      </form>
      <p>
        Content is always available; focus cancels an item effect. The entrance finishes within one second, even when it is below the viewport. There is no visibility observer or animation-once promise.
      </p>
      <a href="/components/motion/marquee">Marquee API and source</a>
      <a href="/components/motion/stagger">Stagger API and source</a>
      <a href="/examples/motion-media-capabilities">Inspect capability evidence and fallbacks</a>
    </div>
    """
  end
end
