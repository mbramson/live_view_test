# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_test,
  ecto_repos: [LiveTest.Repo]

# Configures the endpoint
config :live_test, LiveTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TUXXTvRYfXSvoNjIdl8tKsLN7aFUCZeE7BkwaL09MH2vCoE2va9MBxKF5si7eNV7",
  render_errors: [view: LiveTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveTest.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use the LiveView leex templates
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
