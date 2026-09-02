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
end
