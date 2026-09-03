# Media

Media controls present finite caller-owned collections using native lists, figures, links, scrolling, and dialogs. Callers remain responsible for image rights, safe URLs, meaningful alternatives, intrinsic dimensions, responsive sources, destinations, and restoration after server-rendered replacement.

## Carousel

Carousel is a named horizontal scroll region containing a complete ordered list and real fragment index links. Supply a stable `id`, exactly one of `accessible_label` or `labelledby`, and keyed items with labels. `snap` is `none`, `proximity`, or `mandatory`; `alignment` is `start` or `center`; and `motion` is `system` or `none`. An optional description explains the collection; there is no active slide, autoplay, cloning, or generated previous/next state.

```heex
<.carousel id="featured" accessible_label="Featured articles" snap={:proximity}>
  <:item key="welcome" label="Welcome guide">
    <h3>Welcome guide</h3>
    <a href="/guides/welcome">Read the guide</a>
  </:item>
  <:item key="release" label="Release notes">
    <h3>Release notes</h3>
    <a href="/releases/latest">Read the notes</a>
  </:item>
</.carousel>
```

## Cover Flow

Cover Flow renders an ordered carousel of image figures with optional image-only depth presentation. It requires `id`, exactly one accessible name source, and nonempty atom-keyed image maps containing unique string `key`, `src`, explicit `alt`, positive `width`, and positive `height`; records may also contain name, caption, destination, responsive-source, loading, and decoding data. `presentation` is `flat` or `enhanced`, `snap` is `none`, `proximity`, or `mandatory`, `alignment` is `start` or `center`, and `motion` is `system` or `none`.

```heex
<.cover_flow
  id="landscapes"
  accessible_label="Landscape illustrations"
  presentation={:enhanced}
  images={[
    %{
      key: "ridge",
      src: "/media/ridge.svg",
      alt: "Mountain ridges beneath a warm sun",
      width: 640,
      height: 480,
      caption: "Ridge illustration",
      href: "/media/ridge.svg"
    }
  ]}
/>
```

## Image Gallery

Image Gallery presents responsive figures and can give each image a separate native Dialog enlargement. Images use the same required identity, source, alternative, and dimension fields as Cover Flow and may add a `full` image map. Choose `columns` from `two`, `three`, or `four`; `density` from `compact` or `comfortable`; `fit` from `cover` or `contain`; `motion` from `system` or `none`; and `lightbox` from `none` or `dialog`. Dialog mode also accepts `initial_focus`, `dismissal`, and `close_label`, while `context={:dialog}` prevents nesting another dialog. Keyed caption slots may customize trusted noninteractive captions.

```heex
<.image_gallery
  id="project-gallery"
  accessible_label="Project images"
  columns={:two}
  lightbox={:dialog}
  images={[
    %{
      key: "overview",
      src: "/images/overview.jpg",
      alt: "Project overview screen",
      width: 1200,
      height: 800,
      caption: "Overview",
      full: %{src: "/images/overview.jpg", width: 1200, height: 800}
    }
  ]}
/>
```
