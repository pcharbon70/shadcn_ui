defmodule ShadcnUI.Components.Forms.Label do
  use ShadcnUI.Component

  @moduledoc "Native label text with a protected target and explicit requirement indicators."

  attr :id, :string, required: true
  attr :for, :string, required: true
  attr :required, :boolean, default: false
  attr :optional, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders a native label associated with one explicit control ID."
  def label(assigns) do
    if assigns.required and assigns.optional do
      raise ArgumentError, "label cannot be both required and optional"
    end

    assigns =
      assigns
      |> assign(:safe_rest, protect_globals(assigns.rest, [:id, :for, :role, :data_shadcn_ui]))
      |> assign(
        :classes,
        class_names([
          "sui:flex sui:min-w-0 sui:flex-wrap sui:items-baseline sui:gap-1",
          "sui:break-words sui:text-sm sui:font-medium sui:leading-snug sui:text-foreground",
          assigns.class
        ])
      )

    ~H"""
    <label {@safe_rest} data-shadcn-ui id={@id} for={@for} class={@classes}>
      <span class="sui:min-w-0 sui:break-words">{render_slot(@inner_block)}</span>
      <span :if={@required} aria-hidden="true" class="sui:font-semibold sui:text-destructive">*</span>
      <span :if={@optional} class="sui:text-xs sui:font-normal sui:text-muted-foreground">
        (optional)
      </span>
    </label>
    """
  end
end
