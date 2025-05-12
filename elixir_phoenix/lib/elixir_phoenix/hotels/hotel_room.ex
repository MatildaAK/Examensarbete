defmodule ElixirPhoenix.Hotels.HotelRoom do
  @moduledoc false
  use ElixirPhoenix.Schema

  import Ecto.Changeset

  alias ElixirPhoenix.Hotels.Hotel

  schema "hotel_rooms" do
    field :name, :string
    field :size, :string
    belongs_to :hotel, Hotel

    timestamps()
  end

  @doc false
  def changeset(hotel_room, attrs, _opts) do
    hotel_room
    |> cast(attrs, [:name, :size, :hotel_id])
    |> validate_required([:name, :size])
  end
end
