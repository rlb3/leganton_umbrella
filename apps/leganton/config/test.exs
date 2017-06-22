use Mix.Config

# Configure your database
config :leganton, Leganton.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "leganton_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
