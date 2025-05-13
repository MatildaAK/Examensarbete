defmodule ElixirPhoenixWeb.UserAuth do
  use ElixirPhoenixWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias ElixirPhoenix.Accounts.Users

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  # @max_age 60 * 60 * 24 * 60
  # @remember_me_cookie "_elixir_phoenix_web_user_remember_me"
  # @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, tenant, user, _params \\ %{}) do
    token = Users.generate_user_session_token(tenant, user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_tenant_in_session(tenant)
    |> put_token_in_session(token)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  # defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
  #   put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  # end

  # defp maybe_write_remember_me_cookie(conn, _token, _params) do
  #   conn
  # end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    tenant = get_session(conn, :tenant)
    tenant && user_token && Users.delete_user_session_token(tenant, user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      ElixirPhoenixWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: ~p"/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    user_token = get_session(conn, :user_token)
    tenant = get_session(conn, :tenant)

    user = user_token && tenant && Users.get_user_by_session_token(tenant, user_token)
    assign(conn, :tenant, tenant)
    assign(conn, :current_user, user)
  end

  # defp ensure_user_token(conn) do
  #   if token = get_session(conn, :user_token) do
  #     {token, conn}
  #   else
  #     conn = fetch_cookies(conn, signed: [@remember_me_cookie])

  #     if token = conn.cookies[@remember_me_cookie] do
  #       {token, put_token_in_session(conn, token)}
  #     else
  #       {nil, conn}
  #     end
  #   end
  # end

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_user` - Assigns current_user
      to socket assigns based on user_token, or nil if
      there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session,
      and assigns the current_user to socket assigns based
      on user_token.
      Redirects to login page if there's no logged user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the session.
      Redirects to signed_in_path if there's a logged user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule ElixirPhoenixWeb.PageLive do
        use ElixirPhoenixWeb, :live_view

        on_mount {ElixirPhoenixWeb.UserAuth, :mount_current_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{ElixirPhoenixWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user_and_tenant(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user_and_tenant(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/log_in")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user_and_tenant(socket, session)

    if socket.assigns.current_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_current_user_and_tenant(socket, session) do
    user_token = session["user_token"]
    tenant = session["tenant"]

    user = user_token && tenant && Users.get_user_by_session_token(tenant, user_token)

    socket
    |> Phoenix.Component.assign_new(:current_user, fn -> user end)
    |> Phoenix.Component.assign_new(:tenant, fn -> tenant end)
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      # |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/log_in")
      |> halt()
    end
  end

  defp put_tenant_in_session(conn, tenant) do
    put_session(conn, :tenant, tenant)
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
