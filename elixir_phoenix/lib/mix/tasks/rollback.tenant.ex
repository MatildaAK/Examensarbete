defmodule Mix.Tasks.Rollback.Tenant do
  @moduledoc false

  use Mix.Task

  def run(args) do
    run_tenant_rollback(args)
  end

  defp run_tenant_rollback(args) do
    Enum.each(args, fn tenant_id ->
      options = [
        prefix: "#{tenant_id}",
        step: 1
      ]

      {:ok, _, _} = Ecto.Migrator.with_repo(ElixirPhoenix.Repo, &Ecto.Migrator.run(&1, :down, options))
    end)
  end
end
