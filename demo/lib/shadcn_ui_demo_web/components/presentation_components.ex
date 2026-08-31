defmodule ShadcnUIDemoWeb.PresentationComponents do
  @moduledoc "Gallery-only documentation presentation primitives."

  use Phoenix.Component

  @layouts ~w(centered start constrained tall overflow composition)
  @capability_identities ~w(authored-policy native-baseline progressive-enhancement fallback)

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :source, :string, required: true
  attr :layout, :string, default: "centered", values: @layouts
  slot :preview, required: true
  slot :actions

  def specimen(assigns) do
    assigns =
      assigns
      |> assign(:layout_class, Map.fetch!(layout_classes(), assigns.layout))
      |> assign(:highlighted_source, highlight_heex(assigns.source))

    ~H"""
    <figure
      class={["gallery-specimen", @layout_class]}
      data-gallery-specimen={@id}
      data-gallery-specimen-layout={@layout}
    >
      <figcaption class="gallery-specimen__caption">{@label}</figcaption>
      <fieldset class="gallery-specimen__views">
        <legend class="gallery-visually-hidden">Choose specimen view</legend>
        <div class="gallery-specimen__toolbar">
          <div class="gallery-specimen__view-controls">
            <input
              id={"#{@id}-view-preview"}
              type="radio"
              name={"#{@id}-view"}
              value="preview"
              checked
            />
            <label for={"#{@id}-view-preview"}>Preview</label>
            <input id={"#{@id}-view-code"} type="radio" name={"#{@id}-view"} value="code" />
            <label for={"#{@id}-view-code"}>Code</label>
          </div>
          <div :if={@actions != []} class="gallery-specimen__actions">
            {render_slot(@actions)}
          </div>
        </div>

        <section
          id={"#{@id}-preview"}
          class="gallery-specimen__panel gallery-specimen__preview"
          aria-label="Rendered preview"
          data-gallery-specimen-preview
        >
          {render_slot(@preview)}
        </section>

        <section
          id={"#{@id}-source"}
          class="gallery-specimen__panel gallery-specimen__code"
          aria-label="HEEx source"
          data-gallery-specimen-source
        >
          <h3 class="gallery-visually-hidden">HEEX source</h3>
          <div class="gallery-specimen__code-actions">
            <button
              type="button"
              data-gallery-copy={"#{@id}-code"}
              aria-describedby={"#{@id}-copy-status"}
            >Copy source</button>
            <span
              id={"#{@id}-copy-status"}
              class="gallery-copy-status"
              aria-live="polite"
            ></span>
          </div>
          <pre id={"#{@id}-code"} tabindex="0"><code>{@highlighted_source}</code></pre>
        </section>
      </fieldset>
    </figure>
    """
  end

  attr :id, :string, required: true
  attr :identity, :string, required: true, values: @capability_identities
  attr :label, :string, required: true
  attr :description, :string, required: true

  def capability_badge(assigns) do
    ~H"""
    <span
      class="gallery-capability-badge"
      data-gallery-capability={@identity}
      aria-describedby={"#{@id}-description"}
    >
      <span aria-hidden="true" class="gallery-capability-badge__mark"></span>
      {@label}
      <span id={"#{@id}-description"} class="gallery-visually-hidden">{@description}</span>
    </span>
    """
  end

  attr :label, :string, required: true
  attr :rows, :list, required: true

  def support_table(assigns) do
    ~H"""
    <div
      class="gallery-support-table"
      data-gallery-support-table
      tabindex="0"
      role="region"
      aria-label={@label}
    >
      <table>
        <caption>{@label}</caption>
        <thead>
          <tr>
            <th scope="col">Feature</th>
            <th scope="col">Locked-engine evidence</th>
            <th scope="col">When missing</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={row <- @rows}>
            <th scope="row">{Map.fetch!(row, :feature)}</th>
            <td>{Map.fetch!(row, :evidence)}</td>
            <td>{Map.fetch!(row, :fallback)}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def highlight_heex(source) when is_binary(source) do
    token = ~r/(<!--[\s\S]*?-->|<%[\s\S]*?%>|<\/?[A-Za-z][A-Za-z0-9_.:-]*|\/?\s*>)/

    token
    |> Regex.split(source, include_captures: true, trim: false)
    |> Enum.map(fn part ->
      escaped = part |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()

      cond do
        String.starts_with?(part, "<!--") ->
          ~s(<span class="gallery-code-comment">#{escaped}</span>)

        String.starts_with?(part, "<%") ->
          ~s(<span class="gallery-code-expression">#{escaped}</span>)

        Regex.match?(~r/^<\/?[A-Za-z]/, part) ->
          ~s(<span class="gallery-code-tag">#{escaped}</span>)

        Regex.match?(~r/^\/?\s*>$/, part) ->
          ~s(<span class="gallery-code-tag">#{escaped}</span>)

        true ->
          escaped
      end
    end)
    |> Phoenix.HTML.raw()
  end

  defp layout_classes do
    %{
      "centered" => "gallery-specimen--centered",
      "start" => "gallery-specimen--start",
      "constrained" => "gallery-specimen--constrained",
      "tall" => "gallery-specimen--tall",
      "overflow" => "gallery-specimen--overflow",
      "composition" => "gallery-specimen--composition"
    }
  end
end
