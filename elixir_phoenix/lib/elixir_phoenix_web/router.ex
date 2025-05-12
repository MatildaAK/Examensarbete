defmodule ElixirPhoenixWeb.Router do
  use ElixirPhoenixWeb, :router

  import ElixirPhoenixWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :portal do
    plug :put_root_layout, html: {ElixirPhoenixWeb.Layouts, :portal_root}
  end

  ## Authentication routes

  scope "/", ElixirPhoenixWeb do
    pipe_through [:browser, :portal, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ElixirPhoenixWeb.UserAuth, :redirect_if_user_is_authenticated}],
      layout: {ElixirPhoenixWeb.Layouts, :portal} do
      live "/log_in", AuthenticationLive.Login, :new
      # live "/users/reset_password", UserForgotPasswordLive, :new
      # live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/log_in", UserSessionController, :create
  end

  scope "/", ElixirPhoenixWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end

  ## Standard user actions

  scope "/", ElixirPhoenixWeb do
    pipe_through [:browser, :portal, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ElixirPhoenixWeb.UserAuth, :ensure_authenticated}] do
      live "/", HomeLive
      live "/users/settings", UserSettingsLive, :edit

      live "/users", UserLive.UserList, :index
      live "/users/new", UserLive.UserList, :new
      live "/users/:id", UserLive.UserShow, :show
      live "/users/:id/edit", UserLive.UserShow, :edit

      live "/hotels", HotelLive.HotelList, :index
      live "/hotels/new", HotelLive.HotelList, :new
      live "/hotels/:id", HotelLive.HotelShow, :show
      live "/hotels/:id/edit", HotelLive.HotelShow, :edit

      live "/hotel_rooms", HotelRoomLive.HotelRoomList, :index
      live "/hotel_rooms/new", HotelRoomLive.HotelRoomList, :new
      live "/hotel_rooms/:id", HotelRoomLive.HotelRoomShow, :show
      live "/hotel_rooms/:id/edit", HotelRoomLive.HotelRoomShow, :edit
      live "/hotels/:id/hotel_rooms/new", HotelLive.HotelShow, :new_hotel_room
    end
  end

  ## Development tools

  if Application.compile_env(:elixir_phoenix, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirPhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
