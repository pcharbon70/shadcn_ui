defmodule ShadcnUIDemoWeb.Layouts do
  use ShadcnUIDemoWeb, :html

  embed_templates "layouts/*"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <main id="main-content">{render_slot(@inner_block)}</main>
    """
  end
end
