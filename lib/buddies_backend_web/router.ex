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

    scope "/user" do
      get "/", UserController, :show
      get "/:id/matches", UserHouseController, :show_user_matches
      post "/update_preferences", UserController, :update_preferences
    end

    scope "/houses" do
      get "/", HouseController, :index
      post "/", HouseController, :create
      get "/:id", HouseController, :show
      put "/:id", HouseController, :update
      delete "/:id", HouseController, :delete
      get "/:id/residents", UserHouseController, :show_house_residents
      get "/:id/owner", UserHouseController, :show_house_owner
      get "/:id/matches", UserHouseController, :show_house_matches
      get "/:id/score", HouseController, :get_house_match_score
      get "/:id/favorites", UserHouseController, :show_house_favorites
      post "/:house_id/favorite", UserHouseController, :favorite_house
      delete "/:house_id/favorite", UserHouseController, :remove_favorite_house
      get "/:user_id/favorite_houses", UserHouseController, :get_user_favorite_houses
      get "/:house_id/join_request", UserHouseController, :get_join_request
      post "/:house_id/join", UserHouseController, :join_house
      delete "/:house_id/join", UserHouseController, :remove_join_house
      get "/:house_id/:user_id/is_member", UserHouseController, :is_member
      get "/living/:user_id", UserHouseController, :get_user_houses
      get "/:house_id/activities", ActivityController, :index
      post "/:house_id/activities", ActivityController, :create


      scope "/:house_id/tasks" do
        get "/", TaskController, :index
        post "/", TaskController, :create
        get "/:id", TaskController, :show
        put "/:id", TaskController, :update
        delete "/:id", TaskController, :delete
      end

      scope "/:house_id/bills" do
        get "/", BillController, :index
        post "/", BillController, :create
        get "/:id", BillController, :show
        put "/:id", BillController, :update
        delete "/:id", BillController, :delete
      end

      scope "/:house_id/products" do
        get "/", ProductController, :index
        post "/", ProductController, :create
        get "/:id", ProductController, :show
        put "/:id", ProductController, :update
        delete "/:id", ProductController, :delete
      end
    end

    scope "/user_houses" do
      # Match, Bookmark
      post "/", UserHouseController, :create
      delete "/:id", UserHouseController, :delete
    end

    scope "/tasks" do
      put "/:id", TaskController, :update
    end

    get "/plan/:name", PlanController, :show

    scope "/subscriptions" do
      post "/", SubscriptionController, :create
      delete "/:house_id", SubscriptionController, :delete
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
