defmodule BuddiesBackendWeb.Router do
  use BuddiesBackendWeb, :router

  import BuddiesBackendWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BuddiesBackendWeb do
    pipe_through :api

    scope "/auth" do
      post "/sign_in", UserSessionController, :create
      post "/sign_up", UserController, :create
    end

    pipe_through [:fetch_api_user]

    scope "/auth" do
      post "/sign_out", UserSessionController, :delete
    end

    resources "/houses", HouseController, except: [:new, :edit]

    scope "/user" do
      get "/", UserController, :show
    end

    scope "/house" do
      get "/", HouseController, :index
      post "/", HouseController, :create
      get "/:id", HouseController, :show
      put "/:id", HouseController, :update
      delete "/:id", HouseController, :delete
    end

    scope "/user_houses" do
      get "/house_residents/:house_id", UserHouseController, :show_house_residents
      get "/house_owner/:house_id", UserHouseController, :show_house_owner
      get "/user_matches/:user_id", UserHouseController, :show_user_matches
      post "/", UserHouseController, :create # Match, Bookmark
      delete "/:id", UserHouseController, :delete
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:buddies_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BuddiesBackendWeb.Telemetry
    end
  end
end
