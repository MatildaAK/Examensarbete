defmodule ElixirPhoenix.Repo.Migrations.CreateHotelRooms do
  use Ecto.Migration

  def change do
    create table(:hotel_rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :size, :string
      add :hotel_id, references(:hotels, type: :binary_id), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:hotel_rooms, [:hotel_id])
  end
end
