defmodule ExamenBackend.Hotels.HotelRoom do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias ExamenBackend.Hotels.Hotel

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "hotel_rooms" do
    field :name, :string
    field :size, :string
    belongs_to :hotel, Hotel, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(hotel_room, attrs, _opts) do
    hotel_room
    |> cast(attrs, [:name, :size, :hotel_id])
    |> validate_required([:name, :size])
  end
end
