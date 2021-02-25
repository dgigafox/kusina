defmodule FiestaWeb.Router do
  use FiestaWeb, :router
  use Pow.Phoenix.Router

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: FiestaWeb.FallbackController

    plug FiestaWeb.Plugs.PutCurrentUserSession
    plug :put_layout, {FiestaWeb.LayoutView, "app.html"}
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: FiestaWeb.FallbackController
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FiestaWeb do
    pipe_through :browser

    resources "/", PageController, only: [:index]
  end

  scope "/", FiestaWeb do
    pipe_through [:browser, :not_authenticated]

    post "/signup", Users.RegistrationController, :create, as: :signup
    post "/login", Users.SessionController, :create, as: :login
  end

  scope "/", FiestaWeb do
    pipe_through [:browser, :protected]

    resources "/dashboard", DashboardController, only: [:index]
    resources "/lobby", LobbyController, only: [:index]
    delete "/logout", Users.SessionController, :delete, as: :logout

    live "/kitchen", KitchenLive.Index, layout: {FiestaWeb.LayoutView, "app.html"}
    live "/chat/:id", ChatLive, layout: {FiestaWeb.LayoutView, "app.html"}
  end

  # Other scopes may use custom stacks.
  # scope "/api", FiestaWeb do
  #   pipe_through :api
  # end
end