defmodule ExamenBackend.Users.UserToken do
  use Ecto.Schema

  import Ecto.Query

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string

    belongs_to :user, ExamenBackend.Users.User, type: :binary_id

    timestamps(updated_at: false)
  end

  @session_validity_days 60

  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(64)
    hashed_token = :crypto.hash(:sha256, token)

    %__MODULE__{
      token: hashed_token,
      context: "session",
      user_id: user.id
    }
    |> then(fn record -> {Base.url_encode64(token, padding: false), record} end)
  end

  def verify_session_token_query(token) do
    hashed_token = :crypto.hash(:sha256, Base.url_decode64!(token, padding: false))

    from t in __MODULE__,
      where: t.token == ^hashed_token and t.context == "session",
      join: u in assoc(t, :user),
      where: t.inserted_at > ago(@session_validity_days, "day"),
      select: u
  end
end
