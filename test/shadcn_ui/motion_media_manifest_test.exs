defmodule ShadcnUI.MotionMediaManifestTest do
  use ExUnit.Case, async: true

  # covers: shadcn_ui.motion_media_contract.capability_manifest
  test "authored manifest satisfies every keyword of its closed schema" do
    manifest = decode("priv/compatibility/motion_media.json")
    schema = decode("priv/compatibility/motion_media.schema.json")
    validate(manifest, schema)

    for bad <- [
          Map.put(manifest, "surprise", true),
          Map.delete(manifest, "bundles"),
          put_in(manifest, ["capabilities", "has", "status"], "automatic")
        ] do
      assert_raise ExUnit.AssertionError, fn -> validate(bad, schema) end
    end
  end

  test "bundles are consumer-neutral and deferred controls never enter them" do
    manifest = decode("priv/compatibility/motion_media.json")
    assert manifest["normativeTarget"] == "web-platform-capabilities"
    assert manifest["capabilities"]["generatedControls"]["status"] == "deferred"

    for {_name, bundle} <- manifest["bundles"] do
      refute "generatedControls" in (bundle["requires"] ++ bundle["enhancements"])
      refute inspect(bundle) =~ ~r/(Electron|Windows|Chromium|Firefox|WebKit)/
    end

    evidence = decode("demo/priv/compatibility/motion_media_evidence.json")

    for engine <- ~w(chromium firefox webkit) do
      expected = manifest["verificationEvidence"]["engines"][engine]
      assert evidence["engines"][engine]["version"] == expected["version"]
      assert evidence["engines"][engine]["revision"] == expected["revision"]
      assert evidence["engines"][engine]["behavior"]["nativeScroll"]
    end

    assert Date.from_iso8601!(manifest["reviewedOn"])
  end

  # Small test-only evaluator for exactly the keywords authored in this schema.
  # Fail on unknown keywords so adding a schema rule cannot silently skip validation.
  defp validate(value, schema) do
    assert Map.keys(schema) --
             ~w($schema type const enum pattern minLength minItems uniqueItems required properties additionalProperties items) ==
             []

    if Map.has_key?(schema, "const"), do: assert(value == schema["const"])
    if schema["enum"], do: assert(value in schema["enum"])

    case schema["type"] do
      "object" ->
        assert is_map(value)
        assert schema["additionalProperties"] == false
        assert Map.keys(value) -- Map.keys(schema["properties"]) == []
        assert schema["required"] -- Map.keys(value) == []

        for {key, child} <- schema["properties"],
            Map.has_key?(value, key),
            do: validate(value[key], child)

      "array" ->
        assert is_list(value)
        assert length(value) >= Map.get(schema, "minItems", 0)
        if schema["uniqueItems"], do: assert(Enum.uniq(value) == value)
        Enum.each(value, &validate(&1, schema["items"]))

      "string" ->
        assert is_binary(value)
        assert String.length(value) >= Map.get(schema, "minLength", 0)
        if schema["pattern"], do: assert(Regex.match?(Regex.compile!(schema["pattern"]), value))

      nil ->
        :ok
    end
  end

  defp decode(path), do: path |> File.read!() |> Jason.decode!()
end
