defmodule ShadcnUIDemo.OverlayCapabilities do
  @moduledoc "Authored policy and observed evidence, never browser-name-dependent markup."
  @manifest_path Application.app_dir(:shadcn_ui, "priv/compatibility/native_overlays.json")
  @evidence_path Path.expand("../../priv/compatibility/native_overlay_evidence.json", __DIR__)
  @external_resource @manifest_path
  @external_resource @evidence_path
  @manifest Jason.decode!(File.read!(@manifest_path))
  @evidence Jason.decode!(File.read!(@evidence_path))
  @order ~w(dialog dialogInvokerCommands dialogClosedBy popover popoverTarget anchorPositioning positionFallbacks discreteTransitions interestInvokers)
  @labels %{
    "dialog" => "Native dialog",
    "dialogInvokerCommands" => "commandfor / command",
    "dialogClosedBy" => "closedby",
    "popover" => "Popover",
    "popoverTarget" => "popovertarget",
    "anchorPositioning" => "CSS anchors",
    "positionFallbacks" => "Position tries",
    "discreteTransitions" => "Discrete transitions",
    "interestInvokers" => "Interest invokers"
  }
  @fallbacks %{
    "required" => "Use the complete ordinary destination when unavailable.",
    "enhancement" =>
      "Retain bounded placement or snap presentation; supplemental RTL retains normal flow.",
    "excluded" =>
      "Not emitted, even where detected. Supplemental CSS and ordinary links are the fallback."
  }

  def evidence, do: @evidence
  def manifest, do: @manifest
  def engines, do: Enum.map(~w(chromium firefox webkit), &{&1, @evidence["engines"][&1]})

  def rows do
    Enum.map(@order, fn key ->
      policy = @manifest["capabilities"][key]

      %{
        key: key,
        label: @labels[key],
        status: status(policy["status"]),
        source: policy["source"],
        fallback: @fallbacks[policy["status"]]
      }
    end)
  end

  defp status("required"), do: "Implemented — required native capability"
  defp status("enhancement"), do: "Capability-gated CSS enhancement"
  defp status("excluded"), do: "Deliberately excluded"
end
