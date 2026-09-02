defmodule ShadcnUIDemoWeb.ReferenceComponents do
  use Phoenix.Component
  use ShadcnUI

  attr :render, :atom, required: true
  attr :example_id, :string, default: nil

  def component_examples(%{render: :image_gallery} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.ImageGalleryExamples.examples />
    """
  end

  def component_examples(%{render: :carousel} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.MediaExamples.carousel_examples />
    """
  end

  def component_examples(%{render: :cover_flow} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.MediaExamples.cover_flow_examples />
    """
  end

  def component_examples(%{render: :scroll_indicator} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.MotionExamples.scroll_indicator_examples />
    """
  end

  def component_examples(%{render: :marquee} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.MotionExamples.marquee_examples />
    """
  end

  def component_examples(%{render: :stagger} = assigns) do
    ~H"""
    <ShadcnUIDemoWeb.MotionExamples.stagger_examples />
    """
  end

  def component_examples(%{render: render} = assigns)
      when render in [
             :dialog,
             :alert_dialog,
             :drawer,
             :popover,
             :dropdown_actions,
             :tooltip,
             :hover_card
           ] do
    ~H"""
    <ShadcnUIDemoWeb.OverlayExamples.examples render={@render} />
    """
  end

  def component_examples(%{render: :button} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.button
        :for={variant <- [:default, :secondary, :destructive, :outline, :ghost, :link]}
        variant={variant}
      >{variant} action</.button>
      <.button :for={size <- [:small, :default, :large]} size={size}>A deliberately long {size} action</.button>
      <.button size={:icon} accessible_label="Add item">+</.button>
      <.button disabled>Disabled</.button><.button loading>Loading snapshot</.button>
    </div>
    """
  end

  def component_examples(%{render: :badge} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.badge :for={variant <- [:default, :secondary, :destructive, :outline]} variant={variant}>
        {variant} label
      </.badge>

      <.badge variant={:secondary} data-release="candidate">
        A deliberately long release candidate status
      </.badge>
    </div>
    """
  end

  def component_examples(%{render: :alert} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.alert
        announcement={:none}
        title="Static guidance"
        description="Visible without a live-region announcement."
      />
      <.alert
        variant={:destructive}
        announcement={:assertive}
        title="Session expired"
        description="Sign in again; the application owns recovery."
      >
        <:actions><.button variant={:outline}>Sign in</.button></:actions>
      </.alert>
    </div>
    """
  end

  def component_examples(%{render: :card} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.card>
        <p>Sparse caller content.</p>
      </.card>

      <.card>
        <:title>
          <h3>Preferences</h3>
        </:title><:description>Native controls remain caller-authored.</:description><form
          action="/components/foundation/card"
          method="get"
        >
          <label>Email updates <input type="checkbox" name="email" /></label>
        </form><:footer><.button type="submit">Save snapshot</.button></:footer>
      </.card>
    </div>
    """
  end

  def component_examples(%{render: :avatar} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <div class="gallery-avatar-stack">
        <.avatar initials="PC" stack_position={:first} /><.avatar
          initials="AK"
          image_src="/images/missing-avatar.png"
          image_alt="Alex Kim"
          stack_position={:middle}
        /><.avatar initials="+3" stack_position={:last} />
      </div>
    </div>
    """
  end

  def component_examples(%{render: :skeleton} = assigns) do
    ~H"""
    <section class="gallery-examples" aria-busy="true" aria-label="Loading profile example">
      <.skeleton shape={:circle} size={:large} />
      <.skeleton :for={size <- [:small, :default, :large]} shape={:text} size={size} />
      <.skeleton shape={:rectangle} pulse={false} />
    </section>
    """
  end

  def component_examples(%{render: :field} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.field id="field-email" name="email" errors={["Enter an email"]} error_mode={:always} required>
        <:label>Email address</:label><:control :let={field}>
          <input
            id={field.id}
            name={field.name}
            aria-describedby={field.aria_describedby}
            aria-invalid={field.aria_invalid}
          />
        </:control><:help>Use a reachable address.</:help>
      </.field>
    </div>
    """
  end

  def component_examples(%{render: :label} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.label id="demo-label" for="demo-labelled" required>Email address</.label><input
        id="demo-labelled"
        type="email"
      />
    </div>
    """
  end

  def component_examples(%{render: :help} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <input id="demo-helped" aria-describedby="demo-help" /><.help id="demo-help">
        Localized example: Guía extensa que permanece bajo control de la aplicación.
      </.help>
    </div>
    """
  end

  def component_examples(%{render: :field_errors} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.field_errors
        errors={["Enter a supported value", "Enter a supported value"]}
        ids={["demo-error-1", "demo-error-2"]}
      />
    </div>
    """
  end

  def component_examples(%{render: :error_summary} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.error_summary
        id="demo-summary"
        heading="Review the form"
        errors={[{"summary-email", "Enter an email"}, "The server rejected this fixture"]}
      /><label for="summary-email">Email address</label><input id="summary-email" />
    </div>
    """
  end

  def component_examples(%{render: :input} = assigns) do
    assigns = assign(assigns, :form, sample_form())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.input id="explicit-email" name="email" type="email" required>
          <:label>Email address</:label><:help>Native required constraint.</:help>
        </.input>
      </section><section>
        <h3>FormField</h3><.input
          field={@form[:email]}
          type="email"
          errors={["Server rejected this address"]}
          error_mode={:always}
          pending
        >
          <:label>Account email</:label>
        </.input>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :textarea} = assigns) do
    assigns = assign(assigns, :form, sample_form())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.textarea id="explicit-notes" name="notes" readonly>
          <:label>Readonly notes</:label>
        </.textarea>
      </section><section>
        <h3>FormField</h3><.textarea field={@form[:notes]} sizing={:content}>
          <:label>Profile notes</:label>
        </.textarea>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :checkbox} = assigns) do
    assigns = assign(assigns, :form, sample_form())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.checkbox
          id="explicit-feature"
          name="features"
          mode={:multiple}
          value="exports"
          checked
        >
          <:label>Exports</:label>
        </.checkbox>
      </section><section>
        <h3>FormField</h3><.checkbox field={@form[:remember]}>
          <:label>Remember me</:label>
        </.checkbox><.checkbox id="disabled-check" name="disabled" disabled>
          <:label>Disabled choice</:label>
        </.checkbox>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :radio_group} = assigns) do
    assigns = assign(assigns, :form, sample_form()) |> assign(:options, options())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.radio_group
          id="explicit-contact"
          name="contact"
          options={@options}
        >
          <:legend>Contact method</:legend>
        </.radio_group>
      </section><section>
        <h3>FormField</h3><.radio_group
          field={@form[:contact]}
          options={@options}
          errors={["Choose a method"]}
          error_mode={:always}
        >
          <:legend>Preferred contact</:legend>
        </.radio_group>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :switch} = assigns) do
    assigns = assign(assigns, :form, sample_form())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.switch id="explicit-alerts" name="alerts">
          <:label>Email alerts</:label>
        </.switch>
      </section><section>
        <h3>FormField</h3><.switch field={@form[:alerts]} pending>
          <:label>Operational alerts</:label>
        </.switch>
      </section>
    </div>
    """
  end

  def component_examples(%{render: render} = assigns)
      when render in [:native_select, :enhanced_select] do
    assigns = assign(assigns, :form, sample_form()) |> assign(:options, select_options())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.native_select
          :if={@render == :native_select}
          id="explicit-country"
          name="country"
          options={@options}
        >
          <:label>Country</:label>
        </.native_select><.enhanced_select
          :if={@render == :enhanced_select}
          id="explicit-country"
          name="country"
          options={@options}
        >
          <:label>Country</:label>
        </.enhanced_select>
      </section><section>
        <h3>FormField</h3><.native_select
          :if={@render == :native_select}
          field={@form[:country]}
          options={@options}
        >
          <:label>Account country</:label>
        </.native_select><.enhanced_select
          :if={@render == :enhanced_select}
          field={@form[:country]}
          options={@options}
        >
          <:label>Account country</:label>
        </.enhanced_select>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :slider} = assigns) do
    assigns = assign(assigns, :form, sample_form())

    ~H"""
    <div class="gallery-form-modes">
      <section>
        <h3>Explicit identity</h3><.slider
          id="explicit-volume"
          name="volume"
          value={30}
          min={0}
          max={100}
        >
          <:label>Volume</:label>
        </.slider>
      </section><section>
        <h3>FormField</h3><.slider field={@form[:volume]} min={0} max={100} step={10} pending>
          <:label>Notification volume</:label><:value_description>
            Quiet through loud.
          </:value_description>
        </.slider>
      </section>
    </div>
    """
  end

  def component_examples(%{render: :progress} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.progress id="determinate-progress" value={4} max={10}>
        <:label>Determinate report</:label>
      </.progress><.progress
        id="indeterminate-progress"
        accessible_label="Indeterminate report"
        variant={:destructive}
      />
    </div>
    """
  end

  def component_examples(%{render: :meter} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.meter id="storage-meter" value={72} min={0} max={100} low={60} high={85} optimum={40}>
        <:label>Storage use</:label><:description>
          A scalar measurement, not task completion.
        </:description>
      </.meter>
    </div>
    """
  end

  def component_examples(
        %{render: :accordion, example_id: "reference:accordion:exclusive"} = assigns
      ) do
    ~H"""
    <div class="gallery-examples">
      <.accordion id="faq" mode={:exclusive}>
        <:item key="accessibility" summary="Is it accessible?" open>
          Yes — <code>&lt;details&gt;</code>/<code>&lt;summary&gt;</code> ship with keyboard support and
          correct semantics, and the content stays in the DOM for crawlers and find-in-page.
        </:item>
        <:item key="animation" summary="Can it animate height: auto?">
          Yes. <code>interpolate-size: allow-keywords</code> on the wrapper lets
          <code>::details-content</code> transition from <code>height: 0</code> to
          <code>height: auto</code>. No measuring, no JavaScript.
        </:item>
        <:item key="grouping" summary="Only one open at a time?">
          The <code>name</code> attribute makes the group exclusive — the browser closes the
          others for you.
        </:item>
      </.accordion>
    </div>
    """
  end

  def component_examples(
        %{render: :accordion, example_id: "reference:accordion:independent"} = assigns
      ) do
    ~H"""
    <div class="gallery-examples">
      <.accordion id="faq-sections" mode={:independent}>
        <:item key="account" summary="Account guidance" open>
          Review your profile details and keep the contact information current.
        </:item>
        <:item key="privacy" summary="Privacy guidance" open>
          Review the application's privacy notice before sharing personal information.
        </:item>
        <:item key="support" summary="Support guidance">
          Use the application's ordinary support destination when you need more help.
        </:item>
      </.accordion>
    </div>
    """
  end

  def component_examples(%{render: :navigation_menu} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.navigation_menu accessible_name="Example destinations" layout={:wrap}>
        <:item
          key="current"
          destination="#current-destination"
          label="Current destination"
          current={:location}
        />
        <:item
          key="long"
          destination="#long-destination"
          label="A deliberately long translated destination label"
        />
      </.navigation_menu>
      <p id="current-destination">Current fragment target.</p><p id="long-destination">
        Long-label target.
      </p>
    </div>
    """
  end

  def component_examples(%{render: :header} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.header presentation={:sticky} border={:all}>
        <:brand><a href="#header-target">Example brand</a></:brand>
        <:primary_navigation>
          <nav aria-label="Header example"><a href="#header-target">Destination</a></nav>
        </:primary_navigation>
        <:utilities>
          <form><label>Search <input name="q" /></label></form>
        </:utilities>
        <:actions><.button type="button">Caller action</.button></:actions>
      </.header>
      <p id="header-target">Normal-flow fallback target.</p>
    </div>
    """
  end

  def component_examples(%{render: :section_header} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.section_header id="section-static" presentation={:static}>
        <:heading>
          <h3>Static section</h3>
        </:heading><:description>Caller heading level is unchanged.</:description>
      </.section_header>
      <.section_header id="section-sticky" presentation={:sticky} anchor_effect={:accent}>
        <:heading>
          <h3>Sticky section</h3>
        </:heading><:actions><.button type="button">Edit</.button></:actions>
      </.section_header>
    </div>
    """
  end

  def component_examples(%{render: :scroll_area} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.scroll_area
        size={:small}
        edge_affordance={:both}
        focusable
        accessible_label="Long activity example"
      >
        <p :for={index <- 1..12}>
          Activity row {index}: long caller-owned content remains reachable.
        </p>
      </.scroll_area>
      <.scroll_area axis={:horizontal} size={:small}>
        <div class="gallery-wide-content">Wide native overflow destination.</div>
      </.scroll_area>
    </div>
    """
  end

  def component_examples(%{render: :separator} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <p>Semantic topic one.</p><.separator mode={:semantic} /><p>Semantic topic two.</p>
      <div class="gallery-inline-example">
        <span>Left</span><.separator orientation={:vertical} mode={:decorative} /><span>Right</span>
      </div>
    </div>
    """
  end

  def component_examples(%{render: :radio_panels} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.radio_panels id="gallery-views" name="view" selected="summary" layout={:horizontal}>
        <:legend>Account view</:legend>
        <:option key="summary" value="summary" label="Summary">
          <p>Selected summary panel.</p>
        </:option>
        <:option key="activity" value="activity" label="Activity with a long translated label">
          <p>Activity panel remains in source order.</p>
        </:option>
        <:option key="disabled" value="disabled" label="Unavailable" disabled>
          <p>Disabled choice explanation remains readable.</p>
        </:option>
      </.radio_panels>
    </div>
    """
  end

  defp sample_form do
    Phoenix.Component.to_form(
      %{
        "email" => "person@example.test",
        "notes" => "Caller-owned notes",
        "remember" => "true",
        "contact" => "email",
        "alerts" => "true",
        "country" => "ca",
        "volume" => "40"
      },
      as: "sample"
    )
  end

  defp options,
    do: [
      %{key: :email, value: "email", label: "Email"},
      %{key: :phone, value: "phone", label: "Phone", disabled: true}
    ]

  defp select_options,
    do: [
      %{key: :prompt, value: "", label: "Choose", disabled: true},
      %{key: :ca, value: "ca", label: "Canada"},
      %{key: :us, value: "us", label: "United States"}
    ]
end
