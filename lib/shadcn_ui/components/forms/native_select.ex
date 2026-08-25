defmodule ShadcnUI.Components.Forms.NativeSelect do
  use ShadcnUI.Component

  @moduledoc """
  Classic native select with validated caller-owned options.

  Native Select preserves the browser picker, keyboard behavior, selected
  values, reset, constraint validation, and ordinary form submission. Prompts
  are explicit caller options; the package owns no placeholder or selection
  policy.
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

  @doc "Renders one classic native select with deterministic field relationships."
  def native_select(assigns), do: Select.render(assigns, :native)
end
