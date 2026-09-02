defmodule ShadcnUI.Components.Overlays.OverlayCapabilityManifestTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.overlay.browser_matrix
  # covers: shadcn_ui.overlay.no_package_runtime
  # covers: shadcn_ui.overlay.web_fallback
  # covers: shadcn_ui.overlay.application_boundary

  @manifest_path "priv/compatibility/native_overlays.json"
  @schema_path "priv/compatibility/native_overlays.schema.json"

  test "defines a closed capability vocabulary and capability-based target" do
    manifest = manifest()
    schema = decode!(@schema_path)

    assert manifest["schemaVersion"] == 1
    assert manifest["normativeTarget"] == "web-platform-capabilities"
    assert schema["additionalProperties"] == false

    assert Map.keys(manifest["capabilities"]) |> Enum.sort() ==
             ~w(anchorPositioning dialog dialogClosedBy dialogInvokerCommands discreteTransitions interestInvokers popover popoverTarget positionFallbacks)
             |> Enum.sort()

    assert manifest["capabilities"]["interestInvokers"]["status"] == "excluded"

    for {_name, capability} <- manifest["capabilities"] do
      assert capability["status"] in ~w(required enhancement excluded)
      assert URI.parse(capability["source"]).scheme == "https"
    end
  end

  test "separates normative component sets from exact cross-engine evidence" do
    manifest = manifest()

    assert manifest["componentCapabilitySets"] == %{
             "dialogFamily" => ~w(dialog dialogInvokerCommands dialogClosedBy),
             "popoverFamily" => ~w(popover popoverTarget),
             "anchoredPopoverPresentation" => ~w(anchorPositioning positionFallbacks),
             "overlayMotion" => ~w(discreteTransitions)
           }

    assert manifest["verificationEvidence"] == %{
             "implementation" => "playwright",
             "implementationVersion" => "1.62.1",
             "engines" => %{
               "chromium" => %{"revision" => "1234", "version" => "151.0.7922.34"},
               "firefox" => %{"revision" => "1538", "version" => "153.0"},
               "webkit" => %{"revision" => "2336", "version" => "26.5"}
             }
           }

    refute inspect(manifest["componentCapabilitySets"]) =~
             ~r/(windows|linux|macos|electron|chromium|firefox|webkit)/i
  end

  test "requires caller-owned ordinary fallback and explicit review controls" do
    manifest = manifest()

    assert manifest["fallbackContract"] == %{
             "required" => true,
             "owner" => "caller",
             "acceptedKinds" => ~w(ordinary-destination visible-content non-overlay-operation),
             "missingPresentationEnhancement" => "native-operation-in-bounded-readable-position"
           }

    assert manifest["changeControl"]["authoritativeSourcesRequired"]
    assert manifest["changeControl"]["crossEngineEvidenceRequired"]
    assert manifest["changeControl"]["adrRequiredForPackageRuntime"]
    assert "interest-invokers-become-cross-engine" in manifest["changeControl"]["reviewWhen"]
    assert Date.from_iso8601!(manifest["reviewedOn"])
  end

  test "release and tooling boundaries contain no overlay runtime" do
    release_files = Mix.Project.config()[:package][:files]
    package = File.read!("package.json")
    runtime = Path.wildcard("lib/**/*.ex") |> Enum.map_join("\n", &File.read!/1)

    assert "priv/compatibility" in release_files
    refute Enum.any?(release_files, &String.starts_with?(&1, ["demo", "test", "scripts"]))
    refute package =~ ~r/(floating-ui|focus-trap|popover-polyfill|custom-element|overlay-stack)/i
    # Documentation may explicitly say "no JavaScript"; reject runtime constructs.
    refute runtime =~
             ~r/(defmodule\s+.*(?:Hook|JavaScript)|GenServer|ipcRenderer|Electron|<script|phx-hook=|addEventListener\()/

    assert Path.wildcard("lib/**/*.{js,mjs,ts}") == []
  end

  defp manifest, do: decode!(@manifest_path)
  defp decode!(path), do: path |> File.read!() |> Jason.decode!()
end
