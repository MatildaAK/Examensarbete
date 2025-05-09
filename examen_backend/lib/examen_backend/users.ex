defmodule ExamenBackend.Users do
  import Ecto.Query, warn: false

  alias ExamenBackend.Users.User
  alias ExamenBackend.Users.UserToken
  alias ExamenBackend.Repo

  def list_users(opts) do
    Repo.all(User, opts)
  end

  def get_user!(id, opts), do: Repo.get!(User, id, opts)

  def get_user_by_email(email, tenant) do
    Repo.get_by(User, [email: email], prefix: tenant)
  end

  def get_user_by_user_name_and_password(opts, user_name, password)
      when is_binary(opts) and is_binary(user_name) and is_binary(password) do
    user = Repo.get_by(User, [user_name: user_name], prefix: opts)

    if user && Map.has_key?(user, :id) && User.valid_password?(user, password), do: user
  end

  def create_user(attrs, opts \\ []) do
    %User{}
    |> User.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  def update_user(%User{} = user, attrs, opts \\ []) do
    user
    |> User.changeset(attrs, opts)
    |> Repo.update(opts)
  end

  def valid_password?(%User{} = user, password) do
    Bcrypt.verify_pass(password, user.hashed_password)
  end

  def generate_user_session_token(%User{} = user, tenant) do
    {token, token_struct} = UserToken.build_session_token(user)
    Repo.insert!(token_struct, prefix: tenant)
    token
  end

  def get_user_by_session_token(token, tenant) do
    UserToken.verify_session_token_query(token)
    |> Repo.one(prefix: tenant)
  end

  def delete_user(%User{} = user, opts \\ []) do
    Repo.delete(user, opts)
  end

  def delete_user_session_token(token, tenant) do
    hashed_token = :crypto.hash(:sha256, Base.url_decode64!(token, padding: false))

    Repo.delete_all(
      from(t in UserToken,
        where: t.token == ^hashed_token and t.context == "session"
      ),
      prefix: tenant
    )
  end
end
