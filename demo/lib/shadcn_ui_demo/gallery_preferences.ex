defmodule ShadcnUIDemo.GalleryPreferences do
  @moduledoc "Closed GET preferences; no state or request-derived render identity."
  def theme(params),
    do: if(params["theme"] in ["light", "dark"], do: params["theme"], else: "light")

  def motion(params), do: if(params["motion"] == "reduce", do: "reduce", else: "system")

  def link(path, theme, motion) do
    path = if path in ShadcnUIDemo.Catalogue.routes(), do: path, else: "/"
    path <> "?theme=" <> theme(%{"theme" => theme}) <> "&motion=" <> motion(%{"motion" => motion})
  end
end
