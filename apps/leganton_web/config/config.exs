# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :leganton_web,
  namespace: Leganton.Web,
  ecto_repos: [Leganton.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :leganton_web, Leganton.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ugm0JpgK8FVP6kuTIhBUb0BmSm2YHHVNPqaPVRCOxK9DTZTMS9iRFvd4tiC4TtsG",
  render_errors: [view: Leganton.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Leganton.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :leganton_web, :generators,
  context_app: :leganton

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
