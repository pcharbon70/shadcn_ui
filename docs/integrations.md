# Phoenix controller, Dstar, and LiveView integration

ShadcnUI renders explicit stateless HEEX snapshots. A controller request, Dstar
patch, or LiveView event may choose new assigns and render the same function;
the package does not own routes, state, event names, signals, sockets, patch
boundaries, authorization, or persistence.

## Shared component snapshot

Define an application component with explicit assigns and public imports:

```elixir
defmodule MyAppWeb.AccountComponents do
  use Phoenix.Component
  use ShadcnUI

  attr :account, :map, required: true

  def account_snapshot(assigns) do
    ~H"""
    <.card>
      <:title><h1>{@account.name}</h1></:title>
      <p>{@account.email}</p>
      <a href="/accounts">Back to accounts</a>
    </.card>
    """
  end
end
```

Strings such as `name` and `email` are escaped by HEEX. The application must
load and authorize `account`; the ordinary anchor remains a complete navigation
path. Serve the local packaged stylesheet as described in the
[installation guide](installation.md).

## Ordinary controller rendering

The runnable gallery itself is controller-rendered. A consumer follows the same
Phoenix pattern:

```elixir
defmodule MyAppWeb.AccountController do
  use MyAppWeb, :controller

  def show(conn, %{"id" => id}) do
    account = Accounts.get_authorized!(conn.assigns.current_user, id)
    render(conn, :show, account: account)
  end
end

defmodule MyAppWeb.AccountHTML do
  use MyAppWeb, :html
  import MyAppWeb.AccountComponents

  embed_templates "account_html/*"
end
```

```heex
<.account_snapshot account={@account} />
```

The router, controller, data access, status codes, redirects, CSRF, stylesheet
endpoint, and authentication remain application code. The package archive does
not contain this example application.

## Dstar patches

Dstar applications should validate untrusted signals and authorize the server
operation before choosing assigns. Render the same snapshot on the server, then
pass its HTML through the response or patch API of the application's pinned
Dstar version:

```elixir
def account_patch(assigns) do
  assigns = Map.put_new(assigns, :__changed__, nil)

  assigns
  |> MyAppWeb.AccountComponents.account_snapshot()
  |> Phoenix.HTML.Safe.to_iodata()
end
```

The application owns the Dstar route/action, CSRF integration, signal schema,
authentication, authorization, response event, target, merge mode, error
handling, reconnection, and replacement boundary. Do not place secrets or
authoritative permissions in client signals. Replacing a subtree may reset
browser-local focus, native overlay state, form values, or scroll position; the
application chooses whether and how to preserve them. ShadcnUI does not depend
on Dstar and exposes no actions or signals.

## LiveView rendering

A LiveView also passes explicit assigns to the same component:

```elixir
defmodule MyAppWeb.AccountLive do
  use MyAppWeb, :live_view
  import MyAppWeb.AccountComponents

  def render(assigns) do
    ~H"""
    <.account_snapshot account={@account} />
    """
  end

  def handle_event("rename", %{"name" => name}, socket) do
    account = Accounts.rename_authorized!(socket.assigns.current_user, name)
    {:noreply, assign(socket, :account, account)}
  end
end
```

The LiveView owns the event, parameter validation, authorization, state,
temporary assigns, streams, navigation, and recovery. `@account` is a rendered
snapshot, not a ShadcnUI state contract. ShadcnUI uses `phoenix_live_view` only
for `Phoenix.Component`, HEEX, attrs, and slots; it installs no LiveView route,
socket, hook, process, event, or client navigation.
