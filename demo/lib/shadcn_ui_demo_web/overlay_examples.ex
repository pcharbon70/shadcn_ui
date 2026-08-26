defmodule ShadcnUIDemoWeb.OverlayExamples do
  use Phoenix.Component
  use ShadcnUI
  @moduledoc "Real package components with native, local-only example operations."

  attr :render, :atom, required: true

  def examples(%{render: :dialog} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <p>Each example starts closed. Open it to try native focus, Escape and the explicit exit.</p>
      <section :for={
        {policy, label} <- [
          close_request: "Escape or Close",
          any: "Outside click, Escape or Close",
          none: "Explicit Close only"
        ]
      }>
        <h3>{label}</h3>
        <.dialog id={"dialog-#{policy}"} dismissal={policy} initial_focus={:close}>
          <:trigger>Open {label}</:trigger><:title>Local preferences</:title>
          <:description>Try the dismissal policy. No settings are persisted.</:description>
          <form method="dialog">
            <label>Display name <input name="display_name" value="Sample reader" /></label><button>Finish local example</button>
          </form>
          <:close>Close preferences</:close><:fallback>
            <a href="#ordinary-alternative">Preferences without a dialog</a>
          </:fallback>
        </.dialog>
      </section>
    </div>
    """
  end

  def examples(%{render: :alert_dialog} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <.alert_dialog id="alert-example">
        <:trigger>Review sample consequence</:trigger><:title>Discard this sample draft?</:title>
        <:description>
          This demonstration closes a local dialog. It never deletes a record.
        </:description>
        <p>The cancel button receives focus first. Backdrop clicks do not discard anything.</p>
        <:cancel>Keep draft</:cancel>
        <:action>
          <form method="dialog"><button value="acknowledged">Acknowledge example</button></form>
        </:action>
        <:fallback><a href="#ordinary-alternative">Review the consequence inline</a></:fallback>
      </.alert_dialog>
    </div>
    """
  end

  def examples(%{render: :drawer} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <section :for={edge <- [:start, :end, :bottom]}>
        <h3>Logical {edge} edge</h3>
        <.drawer id={"drawer-#{edge}"} edge={edge} initial_focus={:content}>
          <:trigger>Open {edge} drawer</:trigger><:title>Details and filters</:title>
          <:description>Scroll this bounded body; the explicit exit remains available.</:description>
          <p :for={n <- 1..14}>
            Detail {n}: this long sample text demonstrates native scrolling without a scroll runtime.
          </p>
          <:footer>Local fixture only. Nothing is saved.</:footer>
          <:close>Close details</:close><:fallback>
            <a href="#ordinary-alternative">Details without a drawer</a>
          </:fallback>
        </.drawer>
      </section>
    </div>
    """
  end

  def examples(%{render: :popover} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <section :for={placement <- [:block_start, :block_end, :inline_start, :inline_end]}>
        <h3>Auto / {placement}</h3>
        <.popover id={"popover-#{placement}"} placement={placement}>
          <:trigger>Show {placement} options</:trigger><:title>Display options</:title>
          <label><input type="checkbox" /> Compact rows (local only)</label>
          <:close>Close options</:close><:fallback>
            <a href="#ordinary-alternative">Options without a popover</a>
          </:fallback>
        </.popover>
      </section>
      <.popover id="popover-manual" mode={:manual} action={:show}>
        <:trigger>Show manual popover</:trigger><:title>Manual close</:title>
        <p>Outside clicks and Escape do not close manual mode. Use this explicit button.</p>
        <:close>Hide manual popover</:close><:fallback>
          <a href="#ordinary-alternative">Manual alternative</a>
        </:fallback>
      </.popover>
    </div>
    """
  end

  def examples(%{render: :dropdown_actions} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <form id="action-sample">
        <label>Local draft <input name="draft" value="Original" /></label>
      </form>
      <.dropdown_actions id="actions-example" accessible_label="Document actions">
        <:trigger>Document actions</:trigger>
        <:group_label key="document" label="This document" />
        <:action
          key="read"
          kind={:link}
          destination="#ordinary-alternative"
          label="Read complete document"
          group="document"
        />
        <:action
          key="reset"
          type="reset"
          form="action-sample"
          label="Reset local draft"
          group="document"
        />
        <:separator after_key="reset" />
        <:action key="pending" label="Unavailable snapshot" disabled />
        <:fallback><a href="#ordinary-alternative">All document actions inline</a></:fallback>
      </.dropdown_actions>
      <p>
        Reset changes only the native form above. It does not save, navigate or automatically close the popover.
      </p>
    </div>
    """
  end

  def examples(%{render: :tooltip} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <p>Read the complete manual using the link. The tooltip is optional, not an instruction.</p>
      <.tooltip
        id="tooltip-example"
        text="Also available as plain text."
        describedby="tooltip-visible-help"
      >
        <:trigger label="Read the complete manual" kind={:link} href="#ordinary-alternative" />
      </.tooltip>
      <p id="tooltip-visible-help">All required instructions are visible at the destination.</p>
      <div dir="rtl" lang="ar">
        <.tooltip
          id="tooltip-rtl"
          text="معلومات إضافية متاحة أيضًا في الدليل الكامل."
        >
          <:trigger label="Read the translated manual" kind={:link} href="#ordinary-alternative" />
        </.tooltip>
      </div>
    </div>
    """
  end

  def examples(%{render: :hover_card} = assigns) do
    ~H"""
    <div class="gallery-overlay-examples">
      <p>Follow this ordinary link on touch, or focus/hover it to see optional context.</p>
      <.hover_card id="hover-example">
        <:trigger label="Read the complete manual" href="#ordinary-alternative" />
        <h3>Manual preview</h3><p>Practical guidance, also available in the complete manual.</p>
      </.hover_card>
      <p>
        No hover loading, private information, required controls or analytics belong in this preview.
      </p>
    </div>
    """
  end
end
