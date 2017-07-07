defmodule Orwell.Web.Router do
  use Orwell.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Orwell.Web do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index

    resources "/posts", PostController, only: [:new, :create, :index]

    delete "/auth", AuthController, :delete
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Orwell.Web do
  #   pipe_through :api
  # end
end
