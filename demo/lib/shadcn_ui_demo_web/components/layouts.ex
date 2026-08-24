defmodule ShadcnUIDemoWeb.Layouts do
  use ShadcnUIDemoWeb, :html

  embed_templates "layouts/*"

  attr :page, :map, required: true
  attr :category, :map, required: true
  attr :components, :list, required: true
  attr :theme, :string, required: true
  slot :inner_block, required: true

  def gallery(assigns) do
    ~H"""
    <a class="gallery-skip-link" href="#main-content">Skip to main content</a>
    <header class="gallery-masthead">
      <a href="/">ShadcnUI Gallery</a>
      <span>Package 0.1.0 · upstream bd8f403</span>
      <div aria-label="Theme">
        <button type="button" data-gallery-theme="light" aria-pressed={@theme == "light"}>Light</button>
        <button type="button" data-gallery-theme="dark" aria-pressed={@theme == "dark"}>Dark</button>
      </div>
    </header>
    <div class="gallery-layout">
      <nav class="gallery-navigation" aria-label="Component navigation">
        <a href={@category.path} aria-current={@page.path == @category.path && "page"}>
          {@category.label}
        </a>
        <ul>
          <li :for={component <- @components}>
            <a href={component.path} aria-current={@page.path == component.path && "page"}>
              {component.label}
            </a>
          </li>
        </ul>
      </nav>
      <main id="main-content" tabindex="-1">
        <nav aria-label="Breadcrumb">
          <a href="/">Gallery</a>
          <span :if={@page.kind in [:category, :component]} aria-hidden="true"> / </span>
          <a :if={@page.kind in [:category, :component]} href={@category.path}>{@category.label}</a>
          <span :if={@page.kind == :component} aria-hidden="true"> / </span>
          <span :if={@page.kind == :component}>{@page.label}</span>
        </nav>
        <h1>{@page.title}</h1>
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end
end
