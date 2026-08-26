defmodule ShadcnUI.Components.Overlays.DropdownActions do
  use ShadcnUI.Component
  import ShadcnUI.Components.Overlays.Popover, only: [popover: 1]

  @moduledoc """
  Ordinary links and buttons inside one auto Popover, deliberately not a menu.

  Use native Tab/Shift+Tab, link activation, button Enter/Space, Escape and light
  dismiss. No roving focus, arrow keys, typeahead, submenus or automatic outcome
  dismissal are installed. Applications own methods, CSRF, authorization,
  command results, destinations, pending snapshots and replacement.
  """

  alias ShadcnUI.Components.Overlays.OverlayContract

  @current %{
    none: nil,
    page: "page",
    step: "step",
    location: "location",
    date: "date",
    time: "time",
    true: "true"
  }
  @protected ~w(id role tabindex autofocus href target rel download aria-current aria-label aria-labelledby aria-describedby type disabled aria-disabled name value form popover popovertarget popovertargetaction command commandfor aria-haspopup aria-expanded aria-details data-shadcn-ui data-shadcn-ui-dropdown-action data-destructive)

  attr :id, :string, required: true
  attr :accessible_label, :string, required: true

  attr :placement, :atom,
    values: [:block_start, :block_end, :inline_start, :inline_end],
    default: :block_end

  attr :class, :any, default: nil
  attr :trigger_class, :any, default: nil
  attr :rest, :global
  attr :trigger_rest, :map, default: %{}
  attr :surface_rest, :map, default: %{}

  slot :trigger, required: true
  slot :fallback

  slot :action, required: true do
    attr :key, :string, required: true
    attr :label, :string, required: true
    attr :kind, :atom, values: [:link, :button]
    attr :destination, :string
    attr :target, :string
    attr :rel, :string
    attr :download, :any
    attr :current, :atom
    attr :type, :string
    attr :disabled, :boolean
    attr :name, :string
    attr :value, :string
    attr :form, :string
    attr :group, :string
    attr :destructive, :boolean
    attr :class, :any
    attr :rest, :map
  end

  slot :group_label do
    attr :key, :string, required: true
    attr :label, :string, required: true
  end

  slot :separator do
    attr :after_key, :string, required: true
    attr :decorative, :boolean
  end

  @doc """
  Renders keyed, text-labelled native actions in caller action-slot order.

  Actions default to `kind=:button`, `type="button"`. Links require
  `kind=:link` and `destination`; supported destinations are relative paths,
  fragments and explicit http/https/mailto/tel URLs. Labels are text, not nested
  HEEx. A `group_label` key is referenced by contiguous actions' `group` values.
  A `separator` names the action it follows; `decorative=true` removes its
  thematic-break semantics. Conflicting action globals are rejected rather than
  silently changing a caller control. Provide a normal fallback destination.
  """
  def dropdown_actions(assigns) do
    if length(assigns.trigger) != 1 or length(assigns.fallback) > 1,
      do: raise(ArgumentError, "Dropdown Actions requires one trigger and at most one fallback")

    identity = OverlayContract.identity!(assigns.id)
    label = text!(assigns.accessible_label, :accessible_label)
    if assigns.action == [], do: raise(ArgumentError, "Dropdown Actions requires actions")

    groups =
      Map.new(assigns.group_label, fn group ->
        reject_content!(group)
        {key!(group.key), text!(group.label, :group_label)}
      end)

    if map_size(groups) != length(assigns.group_label),
      do: raise(ArgumentError, "duplicate group keys")

    actions = Enum.map(assigns.action, &normalize_action!(&1, identity.base_id))
    keys = Enum.map(actions, & &1.key)
    if Enum.uniq(keys) != keys, do: raise(ArgumentError, "duplicate action keys")

    separators =
      Map.new(assigns.separator, fn separator ->
        reject_content!(separator)
        after_key = key!(separator.after_key)

        unless after_key in keys,
          do: raise(ArgumentError, "separator must follow an existing action")

        {after_key, boolean!(Map.get(separator, :decorative, false), :decorative)}
      end)

    if map_size(separators) != length(assigns.separator),
      do: raise(ArgumentError, "duplicate separators")

    {actions, seen_groups} =
      Enum.map_reduce(actions, MapSet.new(), fn action, seen ->
        group = action.group

        if group && not Map.has_key?(groups, group),
          do: raise(ArgumentError, "unknown action group")

        show_label = group && not MapSet.member?(seen, group)

        {%{
           action
           | group_id: group && "#{identity.base_id}-group-#{group}",
             group_label: show_label && groups[group],
             separator: Map.fetch(separators, action.key)
         }, if(group, do: MapSet.put(seen, group), else: seen)}
      end)

    unless MapSet.equal?(seen_groups, MapSet.new(Map.keys(groups))),
      do: raise(ArgumentError, "group labels must name at least one action")

    runs =
      actions
      |> Enum.map(& &1.group)
      |> Enum.chunk_by(& &1)
      |> Enum.map(&hd/1)
      |> Enum.reject(&is_nil/1)

    unless runs == Enum.uniq(runs),
      do: raise(ArgumentError, "actions in a group must be contiguous")

    assigns =
      assigns
      |> assign(:actions, actions)
      |> assign(:label, label)
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:id, :role, :data_shadcn_ui_dropdown_actions])
      )

    ~H"""
    <.popover
      {@safe_rest}
      id={@id}
      accessible_label={@label}
      mode={:auto}
      action={:toggle}
      placement={@placement}
      class={@class}
      trigger_class={@trigger_class}
      trigger_rest={@trigger_rest}
      surface_rest={@surface_rest}
      data-shadcn-ui-dropdown-actions
    >
      <:trigger>{render_slot(@trigger)}</:trigger>
      <div data-shadcn-ui-dropdown-list>
        <div :for={action <- @actions} data-action-key={action.key}>
          <p :if={action.group_label} id={action.group_id} data-shadcn-ui-dropdown-group>
            {action.group_label}
          </p>
          <a
            :if={action.kind == :link}
            {action.rest}
            id={action.id}
            href={action.destination}
            target={action.target}
            rel={action.rel}
            download={action.download}
            aria-current={action.current}
            aria-describedby={action.group_id}
            data-shadcn-ui
            data-shadcn-ui-dropdown-action
            data-destructive={to_string(action.destructive)}
            class={action.classes}
          >{action.label}</a>
          <button
            :if={action.kind == :button}
            {action.rest}
            id={action.id}
            type={action.type}
            disabled={action.disabled}
            name={action.name}
            value={action.value}
            form={action.form}
            aria-describedby={action.group_id}
            data-shadcn-ui
            data-shadcn-ui-dropdown-action
            data-destructive={to_string(action.destructive)}
            class={action.classes}
          >{action.label}</button>
          <hr :if={action.separator == {:ok, false}} data-shadcn-ui-dropdown-separator />
          <div
            :if={action.separator == {:ok, true}}
            aria-hidden="true"
            data-shadcn-ui-dropdown-separator
          >
          </div>
        </div>
      </div>
      <:fallback :if={@fallback != []}>{render_slot(@fallback)}</:fallback>
    </.popover>
    """
  end

  defp normalize_action!(action, base) do
    reject_content!(action)
    key = key!(action.key)
    kind = Map.get(action, :kind, :button)
    unless kind in [:link, :button], do: raise(ArgumentError, "invalid action kind")
    rest = Map.get(action, :rest, %{})

    unless is_map(rest) and not is_struct(rest),
      do: raise(ArgumentError, "action rest must be a plain map")

    for key <- Map.keys(rest) do
      normalized = key |> to_string() |> String.replace("_", "-") |> String.downcase()

      if normalized in @protected,
        do: raise(ArgumentError, "action globals cannot override #{normalized}")
    end

    disabled = boolean!(Map.get(action, :disabled, false), :disabled)
    destructive = boolean!(Map.get(action, :destructive, false), :destructive)
    type = Map.get(action, :type, "button")

    unless type in ["button", "submit", "reset"],
      do: raise(ArgumentError, "invalid native button type")

    if kind == :link and
         (disabled or Enum.any?([:type, :name, :value, :form], &Map.has_key?(action, &1))),
       do: raise(ArgumentError, "link actions cannot have button attributes")

    if kind == :button and
         Enum.any?([:destination, :target, :rel, :download, :current], &Map.has_key?(action, &1)),
       do: raise(ArgumentError, "button actions cannot have link attributes")

    download = Map.get(action, :download)

    unless is_nil(download) or is_binary(download) or is_boolean(download),
      do: raise(ArgumentError, "invalid download value")

    %{
      key: key,
      id: "#{base}-action-#{key}",
      label: text!(action.label, :label),
      kind: kind,
      destination: if(kind == :link, do: destination!(Map.get(action, :destination))),
      target: optional!(Map.get(action, :target)),
      rel: optional!(Map.get(action, :rel)),
      download: download,
      current: Map.fetch!(@current, Map.get(action, :current, :none)),
      type: type,
      disabled: disabled,
      name: optional!(Map.get(action, :name)),
      value: optional!(Map.get(action, :value)),
      form: optional!(Map.get(action, :form)),
      group: if(Map.get(action, :group), do: key!(action.group)),
      group_id: nil,
      group_label: nil,
      separator: :error,
      destructive: destructive,
      rest: rest,
      classes:
        class_names([
          "sui:flex sui:w-full sui:min-h-11 sui:items-center sui:rounded-md sui:px-3 sui:py-2 sui:text-start sui:text-sm",
          classes_for(:focus, :default),
          Map.get(action, :class)
        ])
    }
  end

  defp reject_content!(slot) do
    if Map.get(slot, :inner_block),
      do:
        raise(
          ArgumentError,
          "use text labels; nested interactive labels/content are not accepted"
        )
  end

  defp key!(value) when is_binary(value) do
    value = String.trim(value)

    unless Regex.match?(~r/^[A-Za-z0-9][A-Za-z0-9_.-]*$/, value),
      do: raise(ArgumentError, "invalid stable key")

    value
  end

  defp key!(_), do: raise(ArgumentError, "keys must be stable strings")

  defp text!(value, field) when is_binary(value) do
    value = String.trim(value)
    if value == "", do: raise(ArgumentError, "#{field} must be nonblank")
    value
  end

  defp text!(_, field), do: raise(ArgumentError, "#{field} must be text")
  defp optional!(value) when is_nil(value) or is_binary(value), do: value
  defp optional!(_), do: raise(ArgumentError, "native attribute must be text or nil")
  defp boolean!(value, _) when is_boolean(value), do: value
  defp boolean!(_, field), do: raise(ArgumentError, "#{field} must be boolean")

  defp destination!(value) do
    value = text!(value, :destination)
    uri = URI.parse(value)

    if Regex.match?(~r/[\s\\\x00-\x1F\x7F]/u, value) or String.starts_with?(value, "//"),
      do: raise(ArgumentError, "invalid destination")

    case uri.scheme && String.downcase(uri.scheme) do
      nil ->
        if Regex.match?(~r/^[^\/?#]*:/, value), do: raise(ArgumentError, "invalid destination")

      scheme when scheme in ["http", "https"] ->
        if is_nil(uri.host) or uri.host == "", do: raise(ArgumentError, "URL requires host")

      scheme when scheme in ["mailto", "tel"] ->
        if is_nil(uri.path) or uri.path == "",
          do: raise(ArgumentError, "URL requires destination")

      _ ->
        raise ArgumentError, "unsupported destination scheme"
    end

    value
  end
end
