defmodule CandidateConsumer.Page do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    ~H"""
    <main id="candidate-consumer">
      <section data-theme="light"><.button id="save">Save</.button></section>
      <section data-theme="dark">
        <.input id="email" name="email">
          <:label>Email</:label>
        </.input>
      </section>
      <.navigation_menu accessible_name="Primary">
        <:item key="home" destination="/" label="Home" current={:page} />
      </.navigation_menu>
      <.dialog id="preferences" initial_focus={:close}>
        <:trigger>Open preferences</:trigger>
        <:title>Preferences</:title>
        <:description>Review local preferences.</:description>
        <p id="dialog-content">Native dialog content</p>
        <:close>Close preferences</:close>
        <:fallback><a href="#dialog-content">Read inline</a></:fallback>
      </.dialog>
      <.carousel id="examples" accessible_label="Examples">
        <:item key="one" label="One">
          <p>First example</p>
        </:item>
        <:item key="two" label="Two">
          <p>Second example</p>
        </:item>
      </.carousel>
      <.marquee id="topics" accessible_label="Topics" items={[%{key: "one", text: "One"}]} />
    </main>
    """
  end
end

defmodule CandidateConsumer.DstarShapedGuidance do
  use Phoenix.Component
  use ShadcnUI

  def patch(assigns) do
    ~H"""
    <section id="dstar-patch"><.button>Server action</.button></section>
    """
  end
end

defmodule CandidateConsumer.LiveViewShapedGuidance do
  use Phoenix.LiveView
  use ShadcnUI

  @impl true
  def render(assigns) do
    ~H"""
    <section id="live-view-shape"><.button>Socket action</.button></section>
    """
  end
end
