# Navigation

Navigation controls organize destinations, page identity, headings, and nearby actions without taking ownership of routes or commands. Callers provide real links, the current-location decision, and the document's heading hierarchy.

## Navigation Menu

Navigation Menu renders a named `nav` containing real destination links, not an ARIA command menu. Supply `accessible_name`, choose `layout` from `horizontal`, `vertical`, or `wrap`, and add keyed items with a destination and either a text `label` or slot content. An item can declare `current` as `none`, `page`, `step`, `location`, `date`, `time`, or `true`, and accepts ordinary link options such as `target`, `rel`, and `download`.

```heex
<.navigation_menu accessible_name="Primary" layout={:horizontal}>
  <:item key="home" destination="/" label="Home" current={:page} />
  <:item key="docs" destination="/docs" label="Documentation" />
</.navigation_menu>
```

## Header

Header composes optional brand, primary-navigation, utilities, and actions regions in a native page header. Set `width` to `full`, `contained`, or `narrow`; `density` to `compact`, `default`, or `comfortable`; `wrap` to `wrap`, `nowrap`, or `responsive`; `border` to `none`, `bottom`, or `all`; and `presentation` to `static` or `sticky`.

```heex
<.header width={:contained} presentation={:sticky}>
  <:brand><a href="/">Acme</a></:brand>
  <:primary_navigation><a href="/projects">Projects</a></:primary_navigation>
  <:actions><.button>New project</.button></:actions>
</.header>
```

## Section Header

Section Header groups a required caller-authored heading with optional description and actions. It never chooses the heading level. `presentation` is `static` or `sticky`, `density` is `compact`, `default`, or `comfortable`, `anchor_effect` is `none`, `offset`, or `accent`, and `border` adds an optional bottom boundary.

```heex
<.section_header anchor_effect={:accent} border>
  <:heading><h2>Billing</h2></:heading>
  <:description>Manage invoices and payment methods.</:description>
  <:actions><.button variant={:outline}>Edit</.button></:actions>
</.section_header>
```
