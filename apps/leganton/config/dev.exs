use Mix.Config

# Configure your database
config :leganton, Leganton.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "leganton_dev",
  hostname: "localhost",
  pool_size: 10
