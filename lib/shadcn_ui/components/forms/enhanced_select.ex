defmodule ShadcnUI.Components.Forms.EnhancedSelect do
  use ShadcnUI.Component

  @moduledoc """
  Opt-in customizable presentation of one native select.

  Enhanced Select uses the exact Native Select value, option, relationship, and
  submission contract. A standards-based `selectedcontent` child and package CSS
  activate only when the browser supports the complete customizable-select
  capability. Otherwise the same visible native select remains authoritative.
  """

  alias ShadcnUI.Components.Forms.Select

  @not_provided {:shadcn_ui, :not_provided}

  attr(:field, :any, default: nil)
  attr(:id, :string, default: nil)
  attr(:name, :string, default: nil)
  attr(:value, :any, default: @not_provided)
  attr(:options, :list, required: true)
  attr(:errors, :any, default: @not_provided)
  attr(:error_mode, :atom, values: [:used_input, :always, :hidden], default: :used_input)
  attr(:used, :boolean, default: false)
  attr(:translate_error, :any, default: nil)
  attr(:pending, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:optional, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:multiple, :boolean, default: false)
  attr(:size, :atom, values: [:small, :default, :large], default: :default)
  attr(:form, :string, default: nil)
  attr(:describedby, :any, default: nil)
  attr(:class, :any, default: nil)
  attr(:field_class, :any, default: nil)
  attr(:rest, :global, include: ~w(autofocus))

  slot(:label, required: true)
  slot(:help)

  @doc "Renders one native select with a capability-gated enhanced presentation."
  def enhanced_select(assigns), do: Select.render(assigns, :enhanced)
end
