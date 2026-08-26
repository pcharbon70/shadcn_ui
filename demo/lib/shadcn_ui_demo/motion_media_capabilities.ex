defmodule ShadcnUIDemo.MotionMediaCapabilities do
  @moduledoc "Reviewed platform policy and observations, not visitor detection."
  @manifest_path Application.app_dir(:shadcn_ui, "priv/compatibility/motion_media.json")
  @evidence_path Path.expand("../../priv/compatibility/motion_media_evidence.json", __DIR__)
  @scroll_media_path Path.expand("../../priv/compatibility/scroll_media_evidence.json", __DIR__)
  @external_resource @scroll_media_path
  @scroll_media Jason.decode!(File.read!(@scroll_media_path))
  @external_resource @manifest_path
  @external_resource @evidence_path
  @manifest Jason.decode!(File.read!(@manifest_path))
  @evidence Jason.decode!(File.read!(@evidence_path))
  def manifest, do: @manifest
  def evidence, do: @evidence
  def scroll_media, do: @scroll_media
  def engines, do: Enum.map(~w(chromium firefox webkit), &{&1, @evidence["engines"][&1]})
end
