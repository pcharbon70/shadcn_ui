defmodule ShadcnUIDemo.MilestoneGRemediationR4Test do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.gallery_presentation.pinned_reference
  # covers: shadcn_ui.gallery_presentation.shell
  # covers: shadcn_ui.gallery_presentation.progressive_navigation
  # covers: shadcn_ui.gallery_presentation.presentation_system
  # covers: shadcn_ui.gallery_presentation.article_hierarchy
  # covers: shadcn_ui.gallery_presentation.catalogue_metadata
  # covers: shadcn_ui.gallery_presentation.visual_evidence
  # covers: shadcn_ui.gallery_presentation.semantic_exceptions
  # covers: shadcn_ui.gallery_presentation.accessibility_matrix
  # covers: shadcn_ui.gallery_presentation.deterministic_distribution

  @exceptions_path "priv/reference/milestone_g/remediation-r4-exceptions.json"
  @integration_path "priv/reference/milestone_g/remediation-r4-integration-evidence.json"
  @repo_root Path.expand("../..", __DIR__)

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
    assert css =~ "font-size: 1.375rem; font-weight: 600; letter-spacing: -.02em"

    assert css =~
             ":is(p, ul, ol, blockquote):where(:not(.gallery-specimen *)) { font-size: .875rem; line-height: 1.5; }"

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

  test "R4.4 records stable reviewed goldens and closes every integration gate" do
    evidence = @integration_path |> File.read!() |> Jason.decode!()

    accordion_visual =
      File.read!(Path.join(@repo_root, "test/browser/milestone-g-accordion-visual.spec.mjs"))

    migration =
      File.read!(Path.join(@repo_root, "test/browser/milestone-g-phase7-migration.spec.mjs"))

    assert evidence["schemaVersion"] == 1
    assert evidence["status"] == "passed-remediation-r4-complete"
    assert evidence["upstreamCommit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"
    assert evidence["reviewedGoldenChanges"] == 38
    assert evidence["expectedFailuresRemaining"] == 0

    for group <- evidence["goldenGroups"] do
      files =
        @repo_root
        |> Path.join(group["glob"])
        |> Path.wildcard()
        |> Enum.sort()

      manifest =
        Enum.map_join(files, fn file ->
          digest =
            file
            |> File.read!()
            |> then(&:crypto.hash(:sha256, &1))
            |> Base.encode16(case: :lower)

          relative = Path.relative_to(file, @repo_root)
          "#{digest}  #{relative}\n"
        end)

      actual = manifest |> then(&:crypto.hash(:sha256, &1)) |> Base.encode16(case: :lower)
      assert length(files) == group["files"]
      assert actual == group["sha256sumLinesDigest"], "golden group drift for #{group["id"]}"
    end

    assert evidence["verification"]["packageTests"] == %{
             "tests" => 419,
             "failures" => 0,
             "status" => "passed"
           }

    assert evidence["verification"]["demoTests"]["status"] == "passed"

    assert evidence["verification"]["crossEngineFunctional"]["engines"] ==
             ~w(chromium firefox webkit)

    assert evidence["verification"]["deterministicExport"] == "passed"
    refute accordion_visual =~ ~s(test.fail(true, "R4)
    refute migration =~ ~s(test.fail(true, "R4)
  end
end
