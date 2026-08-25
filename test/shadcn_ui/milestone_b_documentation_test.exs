defmodule ShadcnUI.MilestoneBDocumentationTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.form_gallery.semantic_guidance
  # covers: shadcn_ui.form_gallery.select_fallback
  # covers: shadcn_ui.provenance.component_mapping
  # covers: shadcn_ui.package.explicit_release_files

  test "public guidance documents shared ownership, fallback, and server trust boundaries" do
    readme = File.read!("README.md") |> String.replace(~r/\s+/, " ")

    for phrase <- [
          "Explicit `id`, `name`, `value`, and `errors` take precedence",
          "Error visibility is selected",
          "`pending` is presentation only",
          "Ordinary browser form submission",
          "fixed native minimum height",
          "same visible, focusable classic select",
          "Every server operation must parse, validate",
          "authorize",
          "--shadcn-ui-*"
        ] do
      assert readme =~ phrase
    end

    for component <-
          ~w(Field Label Help Error Summary Input Textarea Checkbox Radio Group Switch Native Select Enhanced Select Slider Progress Meter) do
      assert readme =~ component
    end
  end

  test "every Milestone B adaptation is pinned and mapped to local source" do
    provenance = Jason.decode!(File.read!("priv/provenance/unscripted_ui.json"))
    notices = File.read!("THIRD_PARTY_NOTICES.md")

    assert provenance["upstream"]["commit"] == "bd8f403030c8d1f46804da6eda733fde7e908e63"
    assert notices =~ "MIT License"
    assert notices =~ "independent Phoenix adaptation"

    ids = MapSet.new(provenance["adaptations"], & &1["id"])

    for id <-
          ~w(forms.field forms.label forms.help forms.field_errors forms.error_summary forms.input forms.textarea forms.checkbox forms.radio_group forms.switch forms.native_select forms.enhanced_select forms.slider forms.progress forms.meter) do
      assert MapSet.member?(ids, id)
      adaptation = Enum.find(provenance["adaptations"], &(&1["id"] == id))
      assert adaptation["localPaths"] != []
      assert adaptation["upstreamPaths"] != []
      assert adaptation["localChanges"] != ""
    end
  end

  test "release and gallery documentation preserve independent rollback boundaries" do
    release = File.read!("RELEASE.md")
    deployment = File.read!("demo/DEPLOYMENT.md")
    package = Mix.Project.config()[:package]

    assert release =~ "Milestones A and B"
    assert release =~ "Never edit an archive"
    assert deployment =~ "non-submitting compositions"
    assert deployment =~ "Rollback"
    refute Enum.any?(package[:files], &(&1 in ["demo", "test", ".spec", "scripts", ".github"]))
  end
end
