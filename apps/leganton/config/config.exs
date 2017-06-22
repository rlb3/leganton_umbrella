use Mix.Config

config :leganton, ecto_repos: [Leganton.Repo]

import_config "#{Mix.env}.exs"
