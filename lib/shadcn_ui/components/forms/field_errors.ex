defmodule ShadcnUI.Components.Forms.FieldErrors do
  use ShadcnUI.Component

  @moduledoc "Ordered visible field messages with deterministic repeated-error identity."

  attr :errors, :list, required: true
  attr :ids, :list, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders every escaped message without a default live-region role."
  def field_errors(assigns) do
    if length(assigns.errors) != length(assigns.ids) do
      raise ArgumentError, "field error messages and IDs must have equal lengths"
    end

    entries =
      Enum.zip_with(assigns.ids, assigns.errors, fn id, error ->
        unless is_binary(id) and is_binary(error) do
          raise ArgumentError, "field error IDs and messages must be strings"
        end

        %{id: id, error: error}
      end)

    assigns =
      assigns
      |> assign(:entries, entries)
      |> assign(:safe_rest, protect_globals(assigns.rest, [:role, :data_shadcn_ui]))
      |> assign(
        :classes,
        class_names([
          "sui:m-0 sui:grid sui:list-disc sui:gap-1 sui:pl-5",
          "sui:break-words sui:text-sm sui:font-medium sui:text-destructive",
          assigns.class
        ])
      )

    ~H"""
    <ul :if={@entries != []} {@safe_rest} data-shadcn-ui data-shadcn-ui-field-errors class={@classes}>
      <li :for={entry <- @entries} id={entry.id} data-shadcn-ui-field-error>
        {entry.error}
      </li>
    </ul>
    """
  end
end
