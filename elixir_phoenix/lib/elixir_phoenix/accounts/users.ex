defmodule ElixirPhoenix.Accounts.Users do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ElixirPhoenix.Repo

  alias ElixirPhoenix.Accounts.Users.{User, UserToken, UserNotifier}

  ## Database getters

  @doc """
  Returns the list of users.

    iex> list_users(100006)
    [%Users{}, ...]

  """
  def list_users(opts) do
    Repo.all(User, opts)
  end

  @doc """
  Gets a user by id.

    iex> get_user!("100001", "1")
    %User{}

  """
  def get_user!(id, opts), do: Repo.get!(User, id, opts)

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email, prefix: "100001")
  end

  @doc """
  Gets a user for a tenant by name and password.
  """
  def get_user_by_user_name_and_password(tenant, user_name, password)
      when is_binary(tenant) and is_binary(user_name) and is_binary(password) do
    user = Repo.get_by(User, [user_name: user_name], prefix: tenant)
    if User.valid_password?(user, password), do: user
  end

  ## User registration

  @doc """
  Adds a user to the given tenant.
  """
  def add_user(attrs, opts \\ []) do
    %User{}
    |> User.registration_changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  @doc """
  Update a user to the given tenant
  """
  def update_user(%User{} = user, attrs, opts \\ []) do
    user
    |> User.update_changeset(attrs, opts)
    |> Repo.update(opts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs, opts \\ []) do
    User.registration_changeset(user, attrs, opts)
  end

  def change_user(%User{} = user, attrs, opts \\ []) do
    User.update_changeset(user, attrs, opts)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  def delete_user(%User{} = user, opts \\ []) do
    Repo.delete(user, opts)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs, opts \\ []) do
    changeset =
      user
      |> User.password_changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all, opts))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(tenant, user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token, prefix: tenant)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(tenant, token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query, prefix: tenant)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(tenant, token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"), prefix: tenant)
    :ok
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &url(~p"/users/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs, opts \\ []) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all, opts))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
