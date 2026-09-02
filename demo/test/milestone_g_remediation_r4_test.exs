defmodule ShadcnUIDemo.MilestoneGRemediationR4Test do
  use ExUnit.Case, async: true

  test "R4.1 primary Accordion uses the pinned FAQ while the independent example stays local" do
    reference = File.read!("lib/shadcn_ui_demo/reference.ex")
    rendered = File.read!("lib/shadcn_ui_demo_web/reference_components.ex")
    css = File.read!("assets/gallery.css")

    for question <- [
          "Is it accessible?",
          "Can it animate height: auto?",
          "Only one open at a time?"
        ] do
      assert reference =~ question
      assert rendered =~ question
    end

    assert reference =~ "interpolate-size: allow-keywords"
    assert reference =~ "::details-content"
    assert rendered =~ "the content stays in the DOM for crawlers and find-in-page"
    assert rendered =~ "the browser closes the"
    assert rendered =~ "others for you"

    refute reference =~ "Can I change my billing plan?"
    refute rendered =~ "How do I secure my account?"
    refute rendered =~ "Where can I get help?"

    assert reference =~ ~s(id="faq-sections" mode={:independent})
    assert reference =~ ~s(summary="Account guidance" open)
    assert reference =~ ~s(summary="Privacy guidance" open)
    assert rendered =~ ~s(id="faq-sections" mode={:independent})

    assert css =~ ~s([data-gallery-specimen="accordion-primary"])
    assert css =~ "grid-template-columns: auto minmax(0, 1fr)"
    assert css =~ "font-family: var(--gallery-font-mono)"
    assert css =~ "inline-size: min(100%, 28rem)"
    assert css =~ "background: #24292e"
    refute css =~ ~s([data-gallery-specimen="accordion-independent"])
  end

  test "R4.2 pins article metrics and moves narrow search into the native disclosure" do
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    css = File.read!("assets/gallery.css")
    javascript = File.read!("assets/gallery.js")

    assert layout =~ ~s(data-gallery-search-scope="mobile")
    assert layout =~ ~s(data-gallery-search-scope="desktop")
    assert layout =~ ~s(id="gallery-mobile-component-search")
    assert layout =~ ~s(id="gallery-component-search")
    assert layout =~ ~s(aria-label="Mobile component navigation")
    assert layout =~ ~s(aria-current={@page.path == component.path && "page"})

    assert css =~ "--gallery-text-2xl: 1.875rem"
    assert css =~ "--gallery-text-xl: 1.375rem"
    assert css =~ "--gallery-leading-copy: 1.5"
    assert css =~ "max-inline-size: 60ch !important"
    assert css =~ ".gallery-catalogue { display: none; }"
    assert css =~ ".gallery-layout main { padding-block: 1rem 3rem; }"

    assert javascript =~ ~s|document.querySelectorAll("[data-gallery-search-scope]")|
    assert javascript =~ ~s|scope.querySelector("[data-gallery-search-input]")|
    assert javascript =~ ~s|scope.querySelectorAll("[data-gallery-search-item]")|
    refute javascript =~ ~r/(fetch\(|XMLHttpRequest|pushState)/
  end
end
