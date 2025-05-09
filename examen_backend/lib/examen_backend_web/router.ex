defmodule ExamenBackendWeb.Router do
  use ExamenBackendWeb, :router

  import ExamenBackendWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :fetch_current_user
    plug :require_authenticated_user
  end

  scope "/api", ExamenBackendWeb do
    pipe_through :api

    post "/login", UserSessionController, :create
    delete "/users/logout", UserSessionController, :delete
  end

  scope "/api", ExamenBackendWeb do
    pipe_through [:api, :api_auth]

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/hotels", HotelController, :index
    get "/hotels/:id", HotelController, :show
    post "/hotels", HotelController, :create
    put "/hotels/:id", HotelController, :update
    delete "/hotels/:id", HotelController, :delete

    get "/hotel_rooms", HotelRoomController, :index
    get "/hotel_rooms/:id", HotelRoomController, :show
    post "/hotel_rooms", HotelRoomController, :create
    put "/hotel_rooms/:id", HotelRoomController, :update
    delete "/hotel_rooms/:id", HotelRoomController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:examen_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ExamenBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
