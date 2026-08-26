defmodule ShadcnUIDemo.OverlayReference do
  @moduledoc "Closed, authored Milestone D guidance; source examples are inert text."

  @references %{
    dialog: %{
      what:
        "A focused task in a native modal dialog. The rest of the page is inert while it is open.",
      when:
        "Use for a short task that needs focused attention; use an ordinary page for a long workflow.",
      accessibility:
        "A title names the dialog and an optional description explains it. Native Tab stays inside, Escape follows closedby, and the explicit Close button always provides an exit. Initial focus may be auto, content or close; native restoration can vary with browser keyboard preferences.",
      semantics:
        "A button with command=show-modal and commandfor opens a real dialog. Stable IDs connect the title, description and invoker. closedby defaults to closerequest; none requires explicit close and any also allows light dismiss.",
      capability:
        "Requires native dialog, declarative commandfor/command invocation and closedby. CSS backdrops, bounded layout and discrete transitions are presentation only.",
      source:
        ~S(<.dialog id="preferences" initial_focus={:close}><:trigger>Open preferences</:trigger><:title>Preferences</:title><:description>Review this local example.</:description><p>No settings are saved.</p><:close>Close preferences</:close><:fallback><a href="#ordinary-alternative">Read preferences inline</a></:fallback></.dialog>)
    },
    alert_dialog: %{
      what:
        "A consequential confirmation with a native modal boundary and an explicit safe cancellation path.",
      when:
        "Use only when interruption is justified by a consequence; use Dialog for routine tasks and visible Alert for feedback.",
      accessibility:
        "The native dialog carries role=alertdialog, a required title and description. Cancel receives autofocus, Escape cancels, and backdrop clicks do not dismiss it. The action remains an ordinary caller-owned control.",
      semantics:
        "commandfor opens a real dialog with fixed closedby=closerequest. Cancel is the least-destructive initial focus target. The component never executes or authorizes the action.",
      capability:
        "Requires the Dialog capability set. A destructive visual style is not authorization, a successful result or a package confirmation handler.",
      source:
        ~S(<.alert_dialog id="confirm"><:trigger>Review confirmation</:trigger><:title>Discard this sample draft?</:title><:description>This is a local demonstration, not a delete operation.</:description><:cancel>Keep draft</:cancel><:action><form method="dialog"><button value="discard">Acknowledge example</button></form></:action><:fallback><a href="#ordinary-alternative">Read the decision inline</a></:fallback></.alert_dialog>)
    },
    drawer: %{
      what: "A native modal dialog presented at the logical start, end or bottom edge.",
      when:
        "Use for a bounded details or filters task. It is not a draggable panel or a replacement for ordinary navigation.",
      accessibility:
        "The title, description, focus entry, native containment, Escape and explicit Close follow Dialog. The named body supports keyboard scrolling; keep header and footer short.",
      semantics:
        "edge selects start, end or bottom, not application state. Logical sides follow writing direction. Content scrolls within a bounded viewport; no gestures or focus manager are installed.",
      capability:
        "Requires the Dialog capability set. Logical edge layout and safe-area spacing are CSS presentation; unsupported presentation retains a bounded native dialog.",
      source:
        ~S(<.drawer id="filters" edge={:end} initial_focus={:content}><:trigger>Open filters</:trigger><:title>Filters</:title><p>Caller-owned controls go here.</p><:close>Close filters</:close><:fallback><a href="#ordinary-alternative">Read filters inline</a></:fallback></.drawer>)
    },
    popover: %{
      what:
        "A native nonmodal surface beside an ordinary trigger, with a bounded centered placement fallback.",
      when:
        "Use for a small group of optional controls without making the rest of the page inert. Use Dialog when modality is needed.",
      accessibility:
        "Native Tab follows document order. Auto mode supports Escape and light dismiss; manual mode requires an explicit hide control. A title, accessible_label or external labelledby names the surface; no dialog or menu role is invented.",
      semantics:
        "popover=auto or manual pairs with popovertarget and toggle/show/hide actions. Optional logical anchor placement and ordered flips use native CSS, not a positioning engine.",
      capability:
        "Requires Popover and popovertarget. Missing anchors retain a viewport-bounded centered surface. Manual does not close on Escape or outside click.",
      source:
        ~S(<.popover id="options" placement={:block_end}><:trigger>Open options</:trigger><:title>Display options</:title><label><input type="checkbox" /> Compact rows</label><:close>Close options</:close><:fallback><a href="#ordinary-alternative">Read options inline</a></:fallback></.popover>)
    },
    dropdown_actions: %{
      what: "Ordinary links and buttons grouped in an auto Popover. This is not an ARIA menu.",
      when:
        "Use for a compact list of optional actions. Choose a separately specified menu if arrow keys, roving focus or submenus are required.",
      accessibility:
        "Native Tab, Shift+Tab, Enter, Space, disabled buttons and link context menus remain authoritative. No menu/menuitem roles, arrow-key navigation, typeahead or automatic action-result dismissal are added.",
      semantics:
        "Stable action keys derive IDs. Each self-closing action has escaped label text and native link or button attributes. Groups and separators organize the list without changing its ordinary control semantics.",
      capability:
        "Requires Popover and popovertarget; optional anchors have the same centered fallback as Popover. Destinations, native form submission and action outcomes belong to the caller.",
      source:
        ~S(<.dropdown_actions id="actions" accessible_label="Document actions"><:trigger>Document actions</:trigger><:action key="read" kind={:link} destination="#ordinary-alternative" label="Read document" /><:action key="reset" type="reset" form="sample-form" label="Reset local form" /><:fallback><a href="#ordinary-alternative">All actions inline</a></:fallback></.dropdown_actions>)
    },
    tooltip: %{
      what:
        "A short optional text description attached to an already complete native button or link.",
      when:
        "Use for nonessential context. Required labels, instructions, errors, status and task information belong in visible Help, Alert or page content.",
      accessibility:
        "One escaped role=tooltip bubble is nonfocusable. aria-describedby merges existing IDs without duplicates. Keyboard focus and fine-pointer hover reveal it; disabled controls remain disabled.",
      semantics:
        "A single structured text-labelled trigger preserves native button type or link destination. This is CSS presentation, not an interest invoker, top layer or Escape-dismissable overlay.",
      capability:
        "Native trigger and description semantics are the floor. Hover/focus CSS is optional. Narrow, coarse-pointer, RTL and unsupported-anchor layouts retain flow presentation; touch activates the ordinary control.",
      source:
        ~S(<.tooltip id="manual-tip" text="Also available as plain text."><:trigger kind={:link} label="Read the complete manual" href="#ordinary-alternative" /></.tooltip>)
    },
    hover_card: %{
      what: "A noninteractive preview that enriches a complete ordinary link.",
      when:
        "Use for optional destination context that is also available at that destination. Never hide unique task information or required actions in a preview.",
      accessibility:
        "The link keeps its accessible name, href, target, rel, download, current location and native keyboard/context-menu behavior. The preview never takes focus; hover/focus-within can reveal it.",
      semantics:
        "A single text-labelled link owns a trusted presentation-only HEEx preview. Forms, focusable controls, scripts, fetching media and nested links are rejected. Content meaning and privacy remain caller obligations, not markup validation.",
      capability:
        "No interestfor or popover=hint is used. Coarse-pointer users follow the link. Missing hover/focus loses only the preview; RTL and missing anchors retain normal flow. No loading, timers, analytics or long-press emulation are installed.",
      source:
        ~S(<.hover_card id="manual-card"><:trigger label="Read the complete manual" href="#ordinary-alternative" /><h3>Manual preview</h3><p>Optional context also available in the manual.</p></.hover_card>)
    }
  }

  def keys, do: Map.keys(@references)

  def fetch!(key) do
    @references
    |> Map.fetch!(key)
    |> Map.merge(%{
      responsibilities:
        "Applications own routes, authorization, CSRF, validation, persistence, loading, outcomes and replacement. Replacing an open subtree may close it and lose native focus; these examples do not restore it or synchronize state. No real operation is executed.",
      comparison:
        "Dialog and Drawer are modal; Alert Dialog adds consequence semantics and safe cancel focus. Popover is nonmodal; Dropdown Actions contains ordinary controls, not ARIA menus. Tooltip and Hover Card are supplemental only. Use ordinary links for destinations, buttons for actions and visible Help for required guidance. Interest invokers and interactive previews are deferred.",
      fallback:
        "Always-visible ordinary content below remains available. Without script, native controls still work when their required platform features exist. Without CSS, native dialogs/popovers still need invocation; supplemental content is visible in flow. Without invokers or Popover, use the ordinary alternative. Without anchors use bounded default placement; without transitions or with reduced motion it snaps. No hover/coarse pointer retains the complete trigger or link. Forced colors preserves borders and focus; narrow/zoomed text wraps, RTL uses logical edges or supplemental flow. Replacing the subtree does not restore its open state or focus."
    })
  end
end
