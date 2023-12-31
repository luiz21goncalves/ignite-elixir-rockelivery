defmodule RockeliveryWeb.Router do
  use RockeliveryWeb, :router

  alias RockeliveryWeb.Auth.Pipeline
  alias RockeliveryWeb.Plugs.UUIDChecker

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug Pipeline
  end

  scope "/api", RockeliveryWeb do
    pipe_through :api

    scope "/v1" do
      post "/users", UsersController, :create
      post "/users/authenticate", UsersController, :sign_in
    end
  end

  scope "/api", RockeliveryWeb do
    pipe_through [:api, :auth]

    scope "/v1" do
      resources "/users", UsersController, except: [:new, :edit, :create]

      post "/items", ItemsController, :create

      post "/orders", OrdersController, :create
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rockelivery, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RockeliveryWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
