# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :shadcn_ui_demo,
  namespace: ShadcnUIDemo,
  generators: [timestamp_type: :utc_datetime],
  build_revision: System.get_env("SHADCN_UI_BUILD_REVISION", String.duplicate("0", 40)),
  canonical_url:
    System.get_env(
      "SHADCN_UI_CANONICAL_URL",
      "https://leco-industries-inc.github.io/shadcn_ui/"
    )

# Configure the endpoint
config :shadcn_ui_demo, ShadcnUIDemoWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ShadcnUIDemoWeb.ErrorHTML, json: ShadcnUIDemoWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ShadcnUIDemo.PubSub

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
