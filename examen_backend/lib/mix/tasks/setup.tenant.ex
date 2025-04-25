defmodule Mix.Tasks.Setup.Tenant do
  @moduledoc false
  use Mix.Task

  def run(args) do
    setup_tenant(args)
  end

  def setup_tenant(args) do
    Enum.each([:postgrex, :ecto], &Application.ensure_all_started/1)
    ExamenBackend.Repo.start_link()

    Enum.each(args, fn tenant_id ->
      # Creates tenant schema
      query = ~c"CREATE SCHEMA \"#{tenant_id}\""
      ExamenBackend.Repo.query(query)
    end)
  end
end
