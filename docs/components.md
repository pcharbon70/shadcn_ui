# Component API and gallery index

ShadcnUI exposes 41 defining function components through `use ShadcnUI` and
through direct imports from the modules below. Each API page is generated from
the compiled Phoenix component metadata: its Attributes and Slots sections are
the source of truth for required values, defaults, closed values, accepted
globals, and slot attributes. Function and module prose explains native
semantics, deterministic relationships, escaped string data, trusted HEEX slot
content, caller-owned state, and deliberately unsupported behavior.

Every gallery page provides a stable primary preview, the exact compile-checked
HEEX source, application ownership, accessibility, native fallback, package CSS
enhancement, gallery-only behavior, unsupported capabilities, provenance, and
related patterns. The package source link on that page leads to the defining
module. Gallery tooling is demonstration behavior and is not part of the
component API.

## Foundation

- `ShadcnUI.Components.Foundation.Button.button/1`
- `ShadcnUI.Components.Foundation.Badge.badge/1`
- `ShadcnUI.Components.Foundation.Alert.alert/1`
- `ShadcnUI.Components.Foundation.Card.card/1`
- `ShadcnUI.Components.Foundation.Avatar.avatar/1`
- `ShadcnUI.Components.Foundation.Skeleton.skeleton/1`

## Forms

- `ShadcnUI.Components.Forms.Field.field/1`
- `ShadcnUI.Components.Forms.Label.label/1`
- `ShadcnUI.Components.Forms.Help.help/1`
- `ShadcnUI.Components.Forms.FieldErrors.field_errors/1`
- `ShadcnUI.Components.Forms.ErrorSummary.error_summary/1`
- `ShadcnUI.Components.Forms.Input.input/1`
- `ShadcnUI.Components.Forms.Textarea.textarea/1`
- `ShadcnUI.Components.Forms.Checkbox.checkbox/1`
- `ShadcnUI.Components.Forms.RadioGroup.radio_group/1`
- `ShadcnUI.Components.Forms.Switch.switch/1`
- `ShadcnUI.Components.Forms.NativeSelect.native_select/1`
- `ShadcnUI.Components.Forms.EnhancedSelect.enhanced_select/1`
- `ShadcnUI.Components.Forms.Slider.slider/1`
- `ShadcnUI.Components.Forms.Progress.progress/1`
- `ShadcnUI.Components.Forms.Meter.meter/1`

## Disclosure, navigation, and content

- `ShadcnUI.Components.Disclosure.Accordion.accordion/1`
- `ShadcnUI.Components.Navigation.NavigationMenu.navigation_menu/1`
- `ShadcnUI.Components.Navigation.Header.header/1`
- `ShadcnUI.Components.Navigation.SectionHeader.section_header/1`
- `ShadcnUI.Components.Content.ScrollArea.scroll_area/1`
- `ShadcnUI.Components.Content.Separator.separator/1`
- `ShadcnUI.Components.Content.RadioPanels.radio_panels/1`

## Overlays and interactive surfaces

- `ShadcnUI.Components.Overlays.Dialog.dialog/1`
- `ShadcnUI.Components.Overlays.AlertDialog.alert_dialog/1`
- `ShadcnUI.Components.Overlays.Drawer.drawer/1`
- `ShadcnUI.Components.Overlays.Popover.popover/1`
- `ShadcnUI.Components.Overlays.DropdownActions.dropdown_actions/1`
- `ShadcnUI.Components.Overlays.Tooltip.tooltip/1`
- `ShadcnUI.Components.Overlays.HoverCard.hover_card/1`

## Media and motion

- `ShadcnUI.Components.Media.Carousel.carousel/1`
- `ShadcnUI.Components.Media.CoverFlow.cover_flow/1`
- `ShadcnUI.Components.Media.ImageGallery.image_gallery/1`
- `ShadcnUI.Components.Motion.Marquee.marquee/1`
- `ShadcnUI.Components.Motion.Stagger.stagger/1`
- `ShadcnUI.Components.Motion.ScrollIndicator.scroll_indicator/1`

ShadcnUI does not certify a browser brand, operating system, Electron, or other
embedded renderer. Consumers evaluate their environment against the documented
HTML and CSS capability and fallback contracts.
