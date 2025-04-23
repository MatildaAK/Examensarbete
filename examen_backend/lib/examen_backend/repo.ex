defmodule ExamenBackend.Repo do
  use Ecto.Repo,
    otp_app: :examen_backend,
    adapter: Ecto.Adapters.Postgres
end
