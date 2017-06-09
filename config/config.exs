# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :orwell,
  ecto_repos: [Orwell.Repo]

# Configures the endpoint
config :orwell, Orwell.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Eh/1xPz3VWR7QKIc0GTTqcyV4Gs6xmuim8eLioUcOIy4CERj66Bcw20OGzJz1dRB",
  render_errors: [view: Orwell.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Orwell.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
