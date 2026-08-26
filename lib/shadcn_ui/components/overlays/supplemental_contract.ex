defmodule ShadcnUI.Components.Overlays.SupplementalContract do
  @moduledoc false
  use ShadcnUI.Component
  alias ShadcnUI.Components.Overlays.OverlayContract

  @protected ~w(id class role tabindex autofocus hidden inert contenteditable aria-hidden aria-label aria-labelledby aria-describedby aria-expanded aria-haspopup aria-controls aria-details aria-disabled href target rel download aria-current type disabled name value form popover interestfor command commandfor popovertarget popovertargetaction data-shadcn-ui data-shadcn-ui-supplemental-trigger)

  def text!(value) when is_binary(value) do
    if String.trim(value) == "", do: raise(ArgumentError, "supplemental text must be nonblank")
    value
  end

  def text!(_),
    do: raise(ArgumentError, "supplemental text must be an escaped string, not markup")

  def trigger!([entry], allowed) do
    if entry[:inner_block],
      do: raise(ArgumentError, "trigger accepts label text, not nested content")

    kind = Map.get(entry, :kind, :button)
    unless kind in allowed, do: raise(ArgumentError, "unsupported native trigger kind")
    type = Map.get(entry, :type, "button")
    unless type in ["button", "submit", "reset"], do: raise(ArgumentError, "invalid button type")
    disabled = Map.get(entry, :disabled, false)
    unless is_boolean(disabled), do: raise(ArgumentError, "disabled must be boolean")

    fields =
      if kind == :link,
        do: [:type, :disabled, :name, :value, :form],
        else: [:href, :target, :rel, :download, :current]

    if Enum.any?(fields, &Map.has_key?(entry, &1)),
      do: raise(ArgumentError, "mixed link and button attributes")

    current = Map.get(entry, :current)

    unless current in [nil, "page", "step", "location", "date", "time", "true", "false"],
      do: raise(ArgumentError, "invalid aria-current")

    %{
      kind: kind,
      label: text!(entry[:label]),
      type: type,
      disabled: disabled,
      href: if(kind == :link, do: destination!(entry[:href])),
      target: entry[:target],
      rel: entry[:rel],
      download: entry[:download],
      current: current,
      name: entry[:name],
      value: entry[:value],
      form: entry[:form],
      class: class_names([classes_for(:focus, :default), entry[:class]]),
      rest: globals!(Map.get(entry, :rest, %{}), @protected)
    }
  end

  def trigger!(_, _), do: raise(ArgumentError, "exactly one native trigger is required")

  def destination!(value) do
    value = text!(value)
    uri = URI.parse(value)

    if value =~ ~r/[\s\\\x00-\x1F\x7F]/ or String.starts_with?(value, "//") or
         not (is_nil(uri.scheme) or
                String.downcase(uri.scheme) in ["http", "https", "mailto", "tel"]),
       do: raise(ArgumentError, "invalid ordinary link destination")

    if uri.scheme in ["http", "https"] and uri.host in [nil, ""],
      do: raise(ArgumentError, "HTTP destination requires a host")

    value
  end

  def descriptions!(nil, id), do: id

  def descriptions!(value, id) when is_binary(value) do
    ids = String.split(value)
    Enum.each(ids, &OverlayContract.identity!/1)
    Enum.join(Enum.uniq(ids ++ [id]), " ")
  end

  def descriptions!(_, _), do: raise(ArgumentError, "describedby must be ID references")

  def globals!(globals, extra \\ [])

  def globals!(globals, extra) when is_map(globals) do
    protected =
      @protected ++
        ~w(data-placement data-shadcn-ui-supplemental data-shadcn-ui-supplemental-surface) ++
        extra

    protect_globals(globals, Enum.flat_map(protected, &[&1, String.replace(&1, "-", "_")]))
  end

  def globals!(_, _), do: raise(ArgumentError, "globals must be a map")

  attr :trigger, :map, required: true
  attr :id, :string, required: true
  attr :describedby, :string, default: nil

  def native_trigger(assigns) do
    ~H"""
    <button
      :if={@trigger.kind == :button}
      {@trigger.rest}
      id={@id}
      type={@trigger.type}
      disabled={@trigger.disabled}
      name={@trigger.name}
      value={@trigger.value}
      form={@trigger.form}
      aria-describedby={@describedby}
      class={@trigger.class}
      data-shadcn-ui
      data-shadcn-ui-supplemental-trigger
    >{@trigger.label}</button>
    <a
      :if={@trigger.kind == :link}
      {@trigger.rest}
      id={@id}
      href={@trigger.href}
      target={@trigger.target}
      rel={@trigger.rel}
      download={@trigger.download}
      aria-current={@trigger.current}
      aria-describedby={@describedby}
      class={@trigger.class}
      data-shadcn-ui
      data-shadcn-ui-supplemental-trigger
    >{@trigger.label}</a>
    """
  end
end
