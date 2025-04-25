defmodule ExamenBackendWeb.UserAuth do
  @moduledoc false
  use ExamenBackendWeb, :verified_routes

  import Plug.Conn

  alias ExamenBackend.Users

  def fetch_current_user(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         [tenant] <- get_req_header(conn, "x-tenant"),
         %{} = user <- Users.get_user_by_session_token(token, tenant) do
      conn
      |> assign(:tenant, tenant)
      |> assign(:current_user, user)
    else
      _ ->
        conn
        |> assign(:tenant, nil)
        |> assign(:current_user, nil)
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt()
    end
  end
end
