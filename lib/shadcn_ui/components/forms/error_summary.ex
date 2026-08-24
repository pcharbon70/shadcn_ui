defmodule ShadcnUI.Components.Forms.ErrorSummary do
  use ShadcnUI.Component

  @moduledoc """
  Form-level error overview with ordinary fragment links.

  The caller owns announcement, focus, scrolling, and navigation policy. The
  component adds no alert role, focus target, autofocus, or script by default.
  """

  alias ShadcnUI.Components.Forms.FormContract

  attr :id, :string, required: true
  attr :heading, :string, required: true
  attr :errors, :list, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders ordered escaped form messages.

  A binary entry is form-level text. A `{control_id, message}` tuple or a map
  with `:control_id` and `:message` creates an ordinary fragment link.
  """
  def error_summary(assigns) do
    entries =
      assigns.errors
      |> Enum.with_index(1)
      |> Enum.map(fn {entry, ordinal} -> normalize_entry!(assigns.id, ordinal, entry) end)

    assigns =
      assigns
      |> assign(:entries, entries)
      |> assign(:heading_id, "#{normalize_id!(assigns.id)}-heading")
      |> assign(
        :safe_rest,
        protect_globals(assigns.rest, [:id, :aria_labelledby, :data_shadcn_ui])
      )
      |> assign(
        :classes,
        class_names([
          "sui:grid sui:min-w-0 sui:gap-3 sui:rounded-lg sui:border sui:border-destructive",
          "sui:bg-background sui:p-4 sui:text-foreground",
          assigns.class
        ])
      )

    ~H"""
    <section
      {@safe_rest}
      data-shadcn-ui
      data-shadcn-ui-error-summary
      id={@id}
      aria-labelledby={@heading_id}
      class={@classes}
    >
      <h2 id={@heading_id} class="sui:m-0 sui:break-words sui:text-base sui:font-semibold">
        {@heading}
      </h2>
      <ol class="sui:m-0 sui:grid sui:list-decimal sui:gap-1 sui:pl-5 sui:text-sm">
        <li :for={entry <- @entries} id={entry.id}>
          <a
            :if={entry.href}
            href={entry.href}
            class="sui:break-words sui:font-medium sui:text-destructive sui:underline sui:underline-offset-4"
          >
            {entry.message}
          </a>
          <span :if={!entry.href} class="sui:break-words">{entry.message}</span>
        </li>
      </ol>
    </section>
    """
  end

  defp normalize_entry!(base_id, ordinal, message) when is_binary(message) do
    %{id: FormContract.summary_item_id(base_id, ordinal), href: nil, message: message}
  end

  defp normalize_entry!(base_id, ordinal, {control_id, message}) do
    linked_entry!(base_id, ordinal, control_id, message)
  end

  defp normalize_entry!(base_id, ordinal, %{control_id: control_id, message: message}) do
    linked_entry!(base_id, ordinal, control_id, message)
  end

  defp normalize_entry!(_base_id, _ordinal, other) do
    raise ArgumentError,
          "summary errors must be strings, {control_id, message} tuples, or maps, got: #{inspect(other)}"
  end

  defp linked_entry!(base_id, ordinal, control_id, message)
       when is_binary(control_id) and is_binary(message) do
    %{
      id: FormContract.summary_item_id(base_id, ordinal),
      href: "##{normalize_id!(control_id)}",
      message: message
    }
  end

  defp linked_entry!(_base_id, _ordinal, control_id, message) do
    raise ArgumentError,
          "summary control IDs and messages must be strings, got: #{inspect({control_id, message})}"
  end

  defp normalize_id!(id) when is_binary(id) do
    case String.trim(id) do
      "" -> raise ArgumentError, "summary and control IDs must be nonblank strings"
      normalized -> normalized
    end
  end

  defp normalize_id!(_id), do: raise(ArgumentError, "summary and control IDs must be strings")
end
