defmodule ShadcnUIDemoWeb.Layouts do
  use ShadcnUIDemoWeb, :html

  embed_templates "layouts/*"

  attr :page, :map, required: true
  attr :categories, :list, required: true
  attr :components, :list, required: true
  attr :theme, :string, required: true
  attr :motion, :string, default: "system"
  slot :inner_block, required: true

  def gallery(assigns) do
    ~H"""
    <a class="gallery-skip-link" href="#main-content">Skip to main content</a>
    <header class="gallery-masthead">
      <a href="/">ShadcnUI Gallery</a> <span>Package 0.1.0 · upstream bd8f403</span>
      <div aria-label="Theme">
        <button type="button" data-gallery-theme="light" aria-pressed={@theme == "light"}>Light</button>
        <button type="button" data-gallery-theme="dark" aria-pressed={@theme == "dark"}>Dark</button>
      </div>
      <nav aria-label="Motion inspection">
        <a
          :for={{value, label} <- [{"system", "System motion"}, {"reduce", "Reduce motion"}]}
          href={ShadcnUIDemo.GalleryPreferences.link(@page.path, @theme, value)}
          data-gallery-preference
          data-gallery-light-href={ShadcnUIDemo.GalleryPreferences.link(@page.path, "light", value)}
          data-gallery-dark-href={ShadcnUIDemo.GalleryPreferences.link(@page.path, "dark", value)}
          aria-current={@motion == value && "true"}
        >{label}</a>
      </nav>
      <noscript><nav aria-label="Theme links">
        <a href={ShadcnUIDemo.GalleryPreferences.link(@page.path, "light", @motion)}>Use light theme</a>
        <a href={ShadcnUIDemo.GalleryPreferences.link(@page.path, "dark", @motion)}>Use dark theme</a>
      </nav></noscript>
    </header>

    <div class="gallery-layout">
      <nav class="gallery-navigation" aria-label="Component navigation">
        <section :for={category <- @categories}>
          <a href={category.path} aria-current={@page.path == category.path && "page"}>
            {category.label}
          </a>
          <ul>
            <li :for={component <- Enum.filter(@components, &(&1.category == category.slug))}>
              <a href={component.path} aria-current={@page.path == component.path && "page"}>
                {component.label}
              </a>
            </li>
          </ul>
        </section>
      </nav>

      <main id="main-content" tabindex="-1">
        <nav aria-label="Breadcrumb">
          <a href="/">Gallery</a>
          <span :if={@page.kind in [:category, :component]} aria-hidden="true"> / </span>
          <a :if={@page.kind in [:category, :component]} href={category_for(@categories, @page).path}>{category_for(
            @categories,
            @page
          ).label}</a>
          <span :if={@page.kind == :component} aria-hidden="true"> / </span>
          <span :if={@page.kind == :component}>{@page.label}</span>
        </nav>

        <h1>{@page.title}</h1>
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end

  defp category_for(categories, %{category: slug}), do: Enum.find(categories, &(&1.slug == slug))

  defp category_for(categories, %{slug: slug, kind: :category}),
    do: Enum.find(categories, &(&1.slug == slug))
end
