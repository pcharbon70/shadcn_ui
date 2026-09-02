defmodule ShadcnUIDemoWeb.Layouts do
  use ShadcnUIDemoWeb, :html

  embed_templates "layouts/*"

  attr :page, :map, required: true
  attr :categories, :list, required: true
  attr :components, :list, required: true
  attr :theme, :string, required: true
  attr :motion, :string, default: "system"
  attr :build_identity, :map, required: true
  slot :inner_block, required: true

  def gallery(assigns) do
    assigns = assign(assigns, :search_texts, ShadcnUIDemo.DocumentationCatalogue.search_texts())

    ~H"""
    <a class="gallery-skip-link" href="#main-content">Skip to main content</a>
    <header class="gallery-product-header" data-gallery-product-header>
      <div class="gallery-product-header__inner">
        <a class="gallery-wordmark" href="/" aria-label="ShadcnUI home">
          <span>ShadcnUI</span><span aria-hidden="true">/gallery</span>
        </a>
        <nav class="gallery-primary-navigation" aria-label="Primary navigation">
          <a href="/examples/documentation">Docs</a>
          <a href="/components/foundation">Components</a>
          <a
            href="https://github.com/pcharbon70/shadcn_ui"
            aria-label="ShadcnUI repository"
          >Repository</a>
        </nav>
        <details class="gallery-mobile-navigation" data-gallery-mobile-navigation>
          <summary>Navigation</summary>
          <div class="gallery-mobile-navigation__panel" data-gallery-mobile-navigation-panel>
            <nav class="gallery-mobile-primary-navigation" aria-label="Mobile primary navigation">
              <a href="/examples/documentation">Docs</a>
              <a href="/components/foundation">Components</a>
              <a
                href="https://github.com/pcharbon70/shadcn_ui"
                aria-label="ShadcnUI repository"
              >Repository</a>
            </nav>
            <nav aria-label="Mobile component navigation">
              <.navigation_sections
                page={@page}
                categories={@categories}
                components={@components}
                search_texts={@search_texts}
              />
            </nav>
          </div>
        </details>
        <div class="gallery-theme-control" role="group" aria-label="Theme">
          <button type="button" data-gallery-theme="light" aria-pressed={@theme == "light"}>
            Light
          </button>
          <button type="button" data-gallery-theme="dark" aria-pressed={@theme == "dark"}>
            Dark
          </button>
        </div>
      </div>
    </header>

    <div class="gallery-layout" data-gallery-documentation-grid>
      <div class="gallery-catalogue" data-gallery-catalogue>
        <search class="gallery-search" data-gallery-search>
          <label for="gallery-component-search">Search components</label>
          <div>
            <input
              id="gallery-component-search"
              type="search"
              maxlength="200"
              autocomplete="off"
              aria-describedby="gallery-search-status"
              data-gallery-search-input
            />
            <button type="button" data-gallery-search-reset>Clear</button>
          </div>
          <p id="gallery-search-status" aria-live="polite" data-gallery-search-status>
            {length(@components)} components available
          </p>
        </search>
        <nav
          class="gallery-navigation"
          aria-label="Component navigation"
          data-gallery-desktop-catalogue
        >
          <.navigation_sections
            page={@page}
            categories={@categories}
            components={@components}
            search_texts={@search_texts}
          />
        </nav>
      </div>

      <main id="main-content" class="gallery-article" tabindex="-1" data-gallery-main>
        <nav class="gallery-breadcrumb" aria-label="Breadcrumb" data-gallery-breadcrumb>
          <a href="/" aria-current={@page.kind == :landing && "page"}>Gallery</a>
          <span :if={@page.kind in [:category, :component]} aria-hidden="true"> / </span>
          <a
            :if={@page.kind in [:category, :component]}
            href={category_for(@categories, @page).path}
            aria-current={@page.kind == :category && "page"}
          >{category_for(@categories, @page).label}</a>
          <span :if={@page.kind == :component} aria-hidden="true"> / </span>
          <span :if={@page.kind == :component} aria-current="page">{@page.label}</span>
          <span :if={@page.kind == :composition} aria-hidden="true"> / </span>
          <span :if={@page.kind == :composition} aria-current="page">{@page.title}</span>
        </nav>

        <h1>{@page.title}</h1>
        {render_slot(@inner_block)}
      </main>
    </div>

    <footer class="gallery-metadata" data-gallery-metadata>
      <div class="gallery-metadata__inner">
        <p data-gallery-package-version>Package {@build_identity.package_version}</p>
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
      </div>
    </footer>
    """
  end

  attr :page, :map, required: true
  attr :categories, :list, required: true
  attr :components, :list, required: true
  attr :search_texts, :map, required: true

  defp navigation_sections(assigns) do
    ~H"""
    <section :for={category <- @categories}>
      <h2>
        <a href={category.path} aria-current={@page.path == category.path && "page"}>
          {category.label}
        </a>
      </h2>
      <ul>
        <li
          :for={component <- Enum.filter(@components, &(&1.category == category.slug))}
          data-gallery-search-item
          data-gallery-search-route={component.path}
          data-gallery-search-text={Map.fetch!(@search_texts, component.path)}
        >
          <a href={component.path} aria-current={@page.path == component.path && "page"}>
            {component.label}
          </a>
        </li>
      </ul>
    </section>
    <section class="gallery-navigation__showcases">
      <h2>Complete page examples</h2>
      <ul>
        <li :for={composition <- ShadcnUIDemo.Catalogue.compositions()}>
          <a
            href={composition.path}
            aria-current={@page.path == composition.path && "page"}
            data-gallery-showcase
          >
            <span>{composition.label}</span>
            <span class="gallery-navigation__marker" aria-hidden="true">Example</span>
          </a>
        </li>
      </ul>
    </section>
    """
  end

  defp category_for(categories, %{category: slug}), do: Enum.find(categories, &(&1.slug == slug))

  defp category_for(categories, %{slug: slug, kind: :category}),
    do: Enum.find(categories, &(&1.slug == slug))
end
