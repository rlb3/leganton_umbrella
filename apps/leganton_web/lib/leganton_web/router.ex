defmodule Leganton.Web.Router do
  use Leganton.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Leganton.Web do
    pipe_through :api
  end
end
