defmodule ShadcnUI.Components.Media.MediaContract do
  @moduledoc false
  alias ShadcnUI.Component

  @fields ~w(key src alt decorative name width height srcset sizes caption href loading decoding full)a
  @protected ~w(id type role name tabindex aria_label aria_labelledby aria_describedby aria_hidden inert hidden src srcset sizes alt width height loading decoding href command commandfor open data_shadcn_motion data_shadcn_ui_motion data_shadcn_ui_motion_part)a

  def entries!(entries, id) when is_list(entries) do
    validate_id!(id)

    normalized =
      Enum.map(entries, fn entry ->
        image = image!(entry)
        Map.put(image, :identity, identity!(id, Map.fetch!(image, :key)))
      end)

    keys = Enum.map(normalized, & &1.key)
    if Enum.uniq(keys) != keys, do: invalid!(:key, "duplicate")
    normalized
  end

  def entries!(_, _), do: invalid!(:entries, "expected a list")

  def identity!(id, key) do
    validate_id!(id)
    text!(key, :key)
    # Encoding each part avoids punctuation/Unicode and delimiter collisions.
    stem =
      "shadcn-ui-media-#{Base.encode16(id, case: :lower)}-#{Base.encode16(key, case: :lower)}"

    %{
      item: stem <> "-item",
      invoker: stem <> "-invoker",
      dialog: stem <> "-dialog",
      caption: stem <> "-caption",
      timeline: "--" <> stem
    }
  end

  def image!(entry) when is_map(entry) and not is_struct(entry) do
    if Map.keys(entry) -- @fields != [], do: invalid!(:image, "unknown fields")
    key = text!(Map.get(entry, :key), :key)
    decorative = Map.get(entry, :decorative, false)
    unless is_boolean(decorative), do: invalid!(:decorative, "expected a boolean")
    alt = Map.get(entry, :alt)
    unless is_binary(alt), do: invalid!(:alt, "explicit text required")
    name = optional_text!(Map.get(entry, :name), :name)

    if decorative do
      unless alt == "" and is_binary(name),
        do: invalid!(:alt, "decorative images need empty alt and an independent name")
    else
      text!(alt, :alt)
    end

    srcset = srcset!(Map.get(entry, :srcset))
    sizes = optional_text!(Map.get(entry, :sizes), :sizes)
    if srcset && is_nil(sizes), do: invalid!(:sizes, "required with width candidates")

    %{
      key: key,
      src: source!(Map.get(entry, :src)),
      alt: alt,
      decorative: decorative,
      name: name || alt,
      width: dimension!(Map.get(entry, :width)),
      height: dimension!(Map.get(entry, :height)),
      srcset: srcset,
      sizes: sizes,
      caption: optional_text!(Map.get(entry, :caption), :caption),
      href: optional_source!(Map.get(entry, :href)),
      loading: closed!(Map.get(entry, :loading, :lazy), [:lazy, :eager], :loading),
      decoding: closed!(Map.get(entry, :decoding, :async), [:auto, :sync, :async], :decoding),
      full: full!(Map.get(entry, :full))
    }
  end

  def image!(_), do: invalid!(:image, "expected an atom-keyed map")

  def source!(source) when is_binary(source) do
    if source == "" or Regex.match?(~r/[\s\\\\<>"]|%0[ad]/i, source),
      do: invalid!(:source, "blank or unsafe URL characters")

    uri = URI.parse(source)

    root_relative =
      String.starts_with?(source, "/") and not String.starts_with?(source, "//") and
        is_nil(uri.host)

    absolute =
      uri.scheme in ["http", "https"] and is_binary(uri.host) and uri.host != "" and
        is_nil(uri.userinfo)

    unless root_relative or absolute, do: invalid!(:source, "use a root-relative or HTTP(S) URL")
    source
  end

  def source!(_), do: invalid!(:source, "expected a URL string")

  def globals!(globals) when is_map(globals) and not is_struct(globals) do
    unless Enum.all?(Map.keys(globals), &(is_atom(&1) or is_binary(&1))),
      do: invalid!(:globals, "expected attribute names")

    Component.protect_globals(globals, @protected)
  end

  def globals!(_), do: invalid!(:globals, "expected a map")

  defp full!(nil), do: nil

  defp full!(full) when is_map(full) and not is_struct(full) do
    if Map.keys(full) -- ~w(src width height srcset sizes)a != [],
      do: invalid!(:full, "unknown fields")

    srcset = srcset!(Map.get(full, :srcset))
    sizes = optional_text!(Map.get(full, :sizes), :sizes)
    if srcset && is_nil(sizes), do: invalid!(:sizes, "required with width candidates")

    %{
      src: source!(Map.get(full, :src)),
      width: dimension!(Map.get(full, :width)),
      height: dimension!(Map.get(full, :height)),
      srcset: srcset,
      sizes: sizes
    }
  end

  defp full!(_), do: invalid!(:full, "expected full-size image metadata")

  defp srcset!(nil), do: nil

  defp srcset!(entries) when is_list(entries) and entries != [] do
    candidates =
      Enum.map(entries, fn
        %{src: src, width: width} = candidate when map_size(candidate) == 2 ->
          {source!(src), dimension!(width)}

        _ ->
          invalid!(:srcset, "expected src/width candidate maps")
      end)

    widths = Enum.map(candidates, &elem(&1, 1))
    if Enum.uniq(widths) != widths, do: invalid!(:srcset, "duplicate widths")

    Enum.map_join(candidates, ", ", fn {source, width} ->
      if String.contains?(source, ","), do: invalid!(:srcset, "encode commas in candidate URLs")
      "#{source} #{width}w"
    end)
  end

  defp srcset!(_), do: invalid!(:srcset, "expected a nonempty candidate list")

  defp validate_id!(id) do
    unless is_binary(id) and Regex.match?(~r/^[A-Za-z][A-Za-z0-9_.:-]*$/, id),
      do: invalid!(:id, "expected a stable HTML identifier")

    id
  end

  defp dimension!(value) when is_integer(value) and value > 0, do: value
  defp dimension!(_), do: invalid!(:dimensions, "expected positive integers")
  defp optional_source!(nil), do: nil
  defp optional_source!(value), do: source!(value)
  defp optional_text!(nil, _), do: nil
  defp optional_text!(value, field), do: text!(value, field)

  defp text!(value, field) do
    unless is_binary(value) and String.valid?(value) and String.trim(value) != "",
      do: invalid!(field, "expected nonblank text")

    value
  end

  defp closed!(value, choices, field) do
    unless value in choices, do: invalid!(field, "unsupported value")
    Atom.to_string(value)
  end

  defp invalid!(field, reason), do: raise(ArgumentError, "media #{field}: #{reason}")
end
