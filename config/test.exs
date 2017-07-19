use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :orwell, Orwell.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :orwell, Orwell.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "postgres",
  database: "orwell_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :exvcr, [
  vcr_cassette_library_dir: "test/fixtures/vcr_cassettes",
  custom_cassette_library_dir: "test/fixtures/custom_cassettes",
  filter_request_headers: ["Authorization"]
]

config :orwell,
  github_owner: "subvisual",
  github_repo: "blog-test",
  github_post_path_prefix: "pages/posts",
  post_base_url: "/posts"

import_config "test.secret.exs"
