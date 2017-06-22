defmodule Leganton.Application do
  @moduledoc """
  The Leganton Application Service.

  The leganton system business domain lives in this application.

  Exposes API to clients such as the `Leganton.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Leganton.Repo, []),
    ], strategy: :one_for_one, name: Leganton.Supervisor)
  end
end
