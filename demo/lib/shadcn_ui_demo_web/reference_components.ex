defmodule ShadcnUIDemoWeb.ReferenceComponents do
  use Phoenix.Component
  use ShadcnUI

  attr :render, :atom, values: [:button, :badge, :alert, :card, :avatar, :skeleton], required: true

  def component_examples(%{render: :button} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.button :for={variant <- [:default, :secondary, :destructive, :outline, :ghost, :link]} variant={variant}>{variant} action</.button>
      <.button :for={size <- [:small, :default, :large]} size={size}>A deliberately long {size} action</.button>
      <.button size={:icon} accessible_label="Add item">+</.button>
      <.button disabled>Disabled</.button><.button loading>Loading snapshot</.button>
    </div>
    """
  end

  def component_examples(%{render: :badge} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.badge :for={variant <- [:default, :secondary, :destructive, :outline]} variant={variant}>{variant} label</.badge>
      <.badge variant={:secondary} data-release="candidate">A deliberately long release candidate status</.badge>
    </div>
    """
  end

  def component_examples(%{render: :alert} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.alert announcement={:none} title="Static guidance" description="Visible without a live-region announcement." />
      <.alert variant={:destructive} announcement={:assertive} title="Session expired" description="Sign in again; the application owns recovery."><:actions><.button variant={:outline}>Sign in</.button></:actions></.alert>
    </div>
    """
  end

  def component_examples(%{render: :card} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <.card><p>Sparse caller content.</p></.card>
      <.card><:title><h3>Preferences</h3></:title><:description>Native controls remain caller-authored.</:description><form action="/components/foundation/card" method="get"><label>Email updates <input type="checkbox" name="email" /></label></form><:footer><.button type="submit">Save snapshot</.button></:footer></.card>
    </div>
    """
  end

  def component_examples(%{render: :avatar} = assigns) do
    ~H"""
    <div class="gallery-examples">
      <div class="gallery-avatar-stack"><.avatar initials="PC" stack_position={:first} /><.avatar initials="AK" image_src="/images/missing-avatar.png" image_alt="Alex Kim" stack_position={:middle} /><.avatar initials="+3" stack_position={:last} /></div>
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
end
