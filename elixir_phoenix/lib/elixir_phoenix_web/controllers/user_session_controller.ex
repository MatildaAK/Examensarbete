defmodule ElixirPhoenixWeb.UserSessionController do
  use ElixirPhoenixWeb, :controller

  alias ElixirPhoenix.Accounts.Users
  alias ElixirPhoenixWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

 defp create(conn, %{"user" => user_params}, info) do
    %{"account" => account, "password" => password} = user_params

    {user_name, tenant} = parse_account_info(account)

    if user = Users.get_user_by_user_name_and_password(tenant, user_name, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(tenant, user, user_params)
    else
      conn
      |> put_flash(:error, "Invalid account or password")
      |> put_flash(:account, String.slice(account, 0, 160))
      |> redirect(to: ~p"/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  defp parse_account_info(account) do
    case String.split(account, "@") do
      [user_name, tenant] -> {user_name, tenant}
      _ -> {account, nil}
    end
  end
end
