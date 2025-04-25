defmodule Mix.Tasks.Migrate.Tenant do
  @moduledoc false
  use Mix.Task

  def run(args) do
    run_tenant_migrations(args)
  end

  defp run_tenant_migrations(args) do
    Enum.each(args, fn tenant_id ->
      options = [
        prefix: "#{tenant_id}",
        all: true
      ]

      {:ok, _, _} = Ecto.Migrator.with_repo(ExamenBackend.Repo, &Ecto.Migrator.run(&1, :up, options))
    end)
  end
end
