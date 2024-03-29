defmodule LiveTestWeb.Router do
  use LiveTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {LiveTestWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveTestWeb do
    pipe_through :browser

    live "/big_small",BigSmallLive
    live "/things", ThingLive.Index
    resources "/plain/things", ThingController
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveTestWeb do
  #   pipe_through :api
  # end
end
