defmodule ShadcnUI.Components.Forms.Help do
  use ShadcnUI.Component

  @moduledoc "Escaped or trusted descriptive content for a native form control."

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders visible help content with a deterministic description ID."
  def help(assigns) do
    assigns =
      assigns
      |> assign(:safe_rest, protect_globals(assigns.rest, [:id, :role, :data_shadcn_ui]))
      |> assign(
        :classes,
        class_names([
          "sui:m-0 sui:max-w-full sui:break-words sui:text-sm sui:leading-relaxed",
          "sui:text-muted-foreground",
          assigns.class
        ])
      )

    ~H"""
    <p {@safe_rest} data-shadcn-ui data-shadcn-ui-field-help id={@id} class={@classes}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
