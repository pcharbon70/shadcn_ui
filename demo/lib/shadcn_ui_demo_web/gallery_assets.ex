defmodule ShadcnUIDemoWeb.GalleryAssets do
  @moduledoc "Resolves only the closed fingerprinted gallery asset manifest."

  @manifest_path Application.app_dir(:shadcn_ui_demo, "priv/static/assets/manifest.json")
  @external_resource @manifest_path
  @manifest if File.exists?(@manifest_path),
              do: Jason.decode!(File.read!(@manifest_path)),
              else: %{}

  @spec path(String.t()) :: String.t()
  def path(name) when name in ["shadcn.css", "gallery.css", "gallery.js"] do
    Map.fetch!(@manifest, name)
  end
end
