defmodule ShadcnUIDemoWeb.ContentNavigationCompositions do
  use Phoenix.Component
  use ShadcnUI

  @moduledoc "Deterministic caller-owned Milestone C page compositions."

  attr :render, :atom, required: true
  attr :selected, :string, required: true
  attr :invalid, :boolean, required: true

  def content_navigation_composition(%{render: :documentation} = assigns) do
    ~H"""
    <article data-gallery-composition="documentation">
      <.header presentation={:sticky}>
        <:brand><a href="#documentation-main">Documentation</a></:brand>
        <:primary_navigation>
          <.navigation_menu accessible_name="Documentation sections" layout={:wrap}>
            <:item key="overview" destination="#docs-overview" label="Overview" current={:location} />
            <:item key="details" destination="#docs-details" label="Detailed guidance" />
          </.navigation_menu>
        </:primary_navigation>
      </.header>
      <div id="documentation-main">
        <.section_header id="docs-overview" presentation={:sticky} anchor_effect={:accent}>
          <:heading>
            <h2>Overview</h2>
          </:heading>
          <:description>Caller-authored fragment destinations and heading levels.</:description>
        </.section_header>
        <.separator />
        <.scroll_area focusable accessible_label="Documentation body" edge_affordance={:both}>
          <p>
            Long translated guidance: Esta documentación permanece disponible en el orden del documento.
          </p>
          <.accordion id="documentation-faq" mode={:exclusive}>
            <:item key="native" summary="Native behavior" open>
              Details and summary remain browser-owned.
            </:item>
            <:item key="fallback" summary="Fallback behavior">
              Unsupported grouping remains independently operable.
            </:item>
          </.accordion>
          <section id="docs-details">
            <h3>Detailed guidance</h3><p>Nested content and links remain ordinary HTML.</p>
          </section>
        </.scroll_area>
      </div>
    </article>
    """
  end

  def content_navigation_composition(%{render: :settings} = assigns) do
    assigns =
      assign(
        assigns,
        :errors,
        if(assigns.invalid, do: [{"settings-email", "Enter a valid email"}], else: [])
      )

    ~H"""
    <article data-gallery-composition="settings">
      <.header>
        <:brand><a href="#settings-main">Settings</a></:brand><:actions>
          <.badge variant={:secondary}>Caller snapshot</.badge>
        </:actions>
      </.header>
      <div id="settings-main">
        <.alert
          :if={@invalid}
          variant={:destructive}
          title="Review the settings"
          description="The caller selected this server-rendered validation snapshot."
        />
        <.error_summary
          :if={@errors != []}
          id="settings-errors"
          heading="Review the form"
          errors={@errors}
        />
        <.radio_panels id="settings-view" name="view" selected={@selected}>
          <:legend>Settings area</:legend>
          <:option key="profile" value="profile" label="Profile">
            <.card>
              <:title>
                <h2>Profile settings</h2>
              </:title><form data-gallery-static-form>
                <.input id="settings-email" name="email" type="email">
                  <:label>Email</:label>
                </.input><.button type="button">Save snapshot</.button>
              </form>
            </.card>
          </:option>
          <:option key="security" value="security" label="Security">
            <.card>
              <:title>
                <h2>Security settings</h2>
              </:title><.checkbox id="settings-sessions" name="sessions">
                <:label>Review sessions</:label>
              </.checkbox>
            </.card>
          </:option>
        </.radio_panels>
      </div>
    </article>
    """
  end

  def content_navigation_composition(%{render: :application_shell} = assigns) do
    ~H"""
    <article data-gallery-composition="application-shell" dir="rtl">
      <.header presentation={:sticky} wrap={:responsive}>
        <:brand><a href="#shell-main">Workspace</a></:brand>
        <:primary_navigation>
          <.navigation_menu accessible_name="Primary application navigation" layout={:wrap}>
            <:item key="dashboard" destination="#dashboard" label="Dashboard" current={:page} />
            <:item key="reports" destination="#reports">
              Reports
              <.badge>4</.badge>
            </:item>
          </.navigation_menu>
        </:primary_navigation>
        <:actions><.button type="button">Create report</.button></:actions>
      </.header>
      <div class="gallery-shell-composition">
        <nav aria-label="Secondary application navigation">
          <ul>
            <li><a href="#dashboard" aria-current="page">Recent</a></li><li>
              <a href="#reports">Shared</a>
            </li>
          </ul>
        </nav>
        <div id="shell-main">
          <.section_header id="dashboard">
            <:heading>
              <h2>Dashboard</h2>
            </:heading>
          </.section_header>
          <.scroll_area
            axis={:both}
            focusable
            accessible_label="Application content"
            edge_affordance={:both}
          >
            <div class="gallery-wide-content">
              <p>Responsive overflow remains native and caller-owned.</p><p id="reports">
                Reports destination.
              </p>
            </div>
          </.scroll_area>
        </div>
      </div>
    </article>
    """
  end
end
