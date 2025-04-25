defmodule ExamenBackendWeb.UserSessionController do
  use ExamenBackendWeb, :controller

  alias ExamenBackend.Users

  def create(conn, %{"user_name" => user_name, "password" => password, "tenant" => tenant}) do
    with user when not is_nil(user) <- Users.get_user_by_email(email, tenant),
         true <- Users.valid_password?(user, password) do
      token = Users.generate_user_session_token(user, tenant)
      json(conn, %{token: token})
    else
      _ -> send_resp(conn, 401, "Unauthorized")
    end
  end

  def delete(conn, %{"token" => token, "tenant" => tenant}) do
    Users.delete_user_session_token(token, tenant)
    send_resp(conn, 204, "")
  end

  defp parse_account_info(account) do
    case String.split(account, "@") do
      [user_name, tenant] -> {user_name, tenant}
      _ -> {account, nil}
    end
  end
end
