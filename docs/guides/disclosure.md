# Disclosure

Disclosure controls let readers reveal authored content in place while keeping operation, focus, and keyboard behavior browser-owned. They use native HTML instead of requiring package state or a script runtime.

## Accordion

Accordion renders keyed native `details` and `summary` pairs. `mode={:independent}` allows several items to remain open, while `mode={:exclusive}` gives the items a shared native name so supporting browsers keep one open at a time. Every item requires a stable `key` and `summary` and may set its initial `open` state; item, summary, and content classes or attribute maps provide scoped styling hooks.

```heex
<.accordion id="faq" mode={:exclusive}>
  <:item key="shipping" summary="When will my order ship?" open>
    Orders normally leave within two business days.
  </:item>
  <:item key="returns" summary="Can I return it?">
    Review the return policy before sending an item back.
  </:item>
</.accordion>
```
