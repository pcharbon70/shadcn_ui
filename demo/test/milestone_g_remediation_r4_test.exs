defmodule ShadcnUIDemo.MilestoneGRemediationR4Test do
  use ExUnit.Case, async: true

  @exceptions_path "priv/reference/milestone_g/remediation-r4-exceptions.json"

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

  test "R4.3 retains only reviewed semantic, content, accessibility, API, and branding exceptions" do
    ledger = @exceptions_path |> File.read!() |> Jason.decode!()
    layout = File.read!("lib/shadcn_ui_demo_web/components/layouts.ex")
    presentation = File.read!("lib/shadcn_ui_demo_web/components/presentation_components.ex")
    reference = File.read!("lib/shadcn_ui_demo/reference.ex")
    css = File.read!("assets/gallery.css")

    assert ledger["schemaVersion"] == 1
    assert ledger["status"] == "accepted-r4-visible-exceptions"
    assert ledger["upstreamCommit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"
    assert ledger["movingPublicSiteAuthoritative"] == false

    assert MapSet.new(ledger["exceptions"], & &1["id"]) ==
             MapSet.new(
               ~w(branding source-language mobile-navigation view-selection independent-mode capability-policy)
             )

    assert Enum.all?(ledger["exceptions"], &(&1["status"] == "retained"))

    assert Enum.all?(ledger["exceptions"], fn exception ->
             exception["reason"] in ~w(branding api-language accessibility semantic-contract content-contract)
           end)

    assert layout =~ ">ShadcnUI</span>"
    assert layout =~ "<summary>Navigation</summary>"
    refute layout =~ ~r/(role="(?:dialog|menu)"|aria-modal|script bytes shipped: 0)/i

    assert presentation =~ ~s(data-gallery-source-language="heex")
    assert presentation =~ ~s(data-gallery-capability-policy="authored")
    assert presentation =~ ~s(type="radio")
    refute presentation =~ ~r/role="(?:tablist|tab|tabpanel)"/
    assert reference =~ ~s(id="faq-sections" mode={:independent})

    assert css =~
             ".gallery-specimen__code { position: relative; color: #f6f8fa; background: #24292e; }"

    assert css =~ "font-family: var(--gallery-font-mono)"
    assert css =~ ~s|[data-gallery-capability="progressive-enhancement"]|
    refute css =~ ~r/@supports[^\{]*\{\s*\.gallery-capability-badge/s
  end
end
