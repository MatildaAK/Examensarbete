defmodule ExamenBackendWeb.UserSessionController do
  use ExamenBackendWeb, :controller

  alias ExamenBackend.Users

  def create(conn, %{"user" => user_params}) do
    %{"account" => account, "password" => password} = user_params

    {user_name, tenant} = parse_account_info(account)

    with user when not is_nil(user) <- Users.get_user_by_user_name_and_password(tenant, user_name, password),
         true <- Users.valid_password?(user, password) do
          IO.inspect(user, label: "User object")

      token = Users.generate_user_session_token(user, tenant)
      json(conn, %{token: token, user_name: user.user_name, id: user.id})
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
