# Foundation

Foundation controls are the small, reusable building blocks used throughout an interface. They render native, semantic HTML with a closed set of visual choices; application behavior, state, and outcomes remain the caller's responsibility.

## Button

Button renders a native `button` for actions and form submission. Choose `type` from `button`, `submit`, or `reset`; `variant` from `default`, `secondary`, `destructive`, `outline`, `ghost`, or `link`; and `size` from `small`, `default`, `large`, or `icon`. It also supports `disabled`, a presentational `loading` state, and leading or trailing content. An icon-sized button requires `accessible_label`.

```heex
<.button type="submit" variant={:default} size={:large}>Save changes</.button>
```

## Badge

Badge is a passive inline label for short status or classification text. Its `variant` is `default`, `secondary`, `destructive`, or `outline`. It deliberately does not accept interactive behavior; use a link or button when the label must be actionable.

```heex
<.badge variant={:secondary}>Pending review</.badge>
```

## Alert

Alert presents visible feedback with an optional title, description, icon, and actions. Use `variant={:default | :destructive}` for appearance and choose `announcement={:none | :polite | :assertive}` explicitly for assistive-technology announcement policy. A destructive appearance does not imply an assertive announcement.

```heex
<.alert announcement={:polite} title="Draft saved" description="Your changes are available." />
```

## Card

Card groups related content without adding workflow semantics. Compose it with optional `header`, `title`, `description`, `actions`, and `footer` slots around the required body; headings, forms, links, and actions inside remain ordinary caller-owned HTML.

```heex
<.card>
  <:title><h3>Preferences</h3></:title>
  <p>Choose how the application contacts you.</p>
  <:footer><a href="/preferences">Open preferences</a></:footer>
</.card>
```

## Avatar

Avatar displays required initials and can layer an optional image over that stable fallback. Set `size` to `small`, `default`, or `large`, and `stack_position` to `none`, `first`, `middle`, or `last` when avatars overlap. `image_src` and meaningful `image_alt` must be supplied together.

```heex
<.avatar initials="PC" image_src="/images/person.jpg" image_alt="Pascal Charbonneau" size={:large} />
```

## Skeleton

Skeleton is an always-decorative loading placeholder; place it inside a separately named, caller-owned loading region. Choose `shape` from `rectangle`, `circle`, or `text`, `size` from `small`, `default`, or `large`, and use `pulse={false}` to remove its optional motion.

```heex
<section aria-busy="true" aria-label="Loading profile">
  <.skeleton shape={:circle} size={:large} />
</section>
```
