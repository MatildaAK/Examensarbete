# defmodule ExamenBackendWeb.UserController do
#   use ExamenBackendWeb, :controller

#   alias ExamenBackend.Users

#   # def index(conn, _params) do
#   #   users = Users.list_users()
#   #   render(conn, "index.json", users: users)
#   # end

#   # def show(conn, %{"id" => id}) do
#   #   user = Users.get_user!(id)
#   #   render(conn, "show.json", user: user)
#   # end

#   def index(conn, _params) do
#     users = Users.list_users()
#     json(conn, %{data: Enum.map(users, &serialize_user/1)})
#   end

#   defp serialize_user(user), do: %{
#     id: user.id,
#     name: user.name,
#     email: user.email
#   }

#   def create(conn, %{"user" => user_params}) do
#     with {:ok, %User{} = user} <- Users.create_user(user_params) do
#       conn
#       |> put_status(:created)
#       |> put_rest_header("location", Routes.user_path(conn, :show, user))
#       |> render("show.json", user: user)
#     end
#   end
# end

defmodule ExamenBackendWeb.UserController do
  use ExamenBackendWeb, :controller

  alias ExamenBackend.Users
  alias ExamenBackend.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    json(conn, %{data: Enum.map(users, &serialize_user/1)})
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    json(conn, %{data: serialize_user(user)})
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> json(%{data: serialize_user(user)})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
      json(conn, %{data: serialize_user(updated_user)})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp serialize_user(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
