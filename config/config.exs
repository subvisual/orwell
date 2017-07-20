# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :orwell,
  ecto_repos: [Orwell.Repo],
  github_owner: "subvisual",
  github_repo: "blog",
  github_posts_dir: "pages/posts"

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

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user,repo"] }
  ]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Orwell",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "gl8GzW9Z7lHgWQoMEyIX2OvwPCqfKP1ldLhGrnku6M/pT9Hei2YQxCyOfy/YCcQU",
  serializer: Orwell.GuardianSerializer

config :orwell,
  github_owner: System.get_env("GITHUB_OWNER"),
  github_repo: System.get_env("GITHUB_REPO"),
  github_post_path_prefix: "pages/posts",
  post_base_url: "/posts"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
