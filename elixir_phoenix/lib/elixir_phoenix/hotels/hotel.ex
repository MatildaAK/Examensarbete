defmodule ElixirPhoenix.Hotels.Hotel do
    @moduledoc false
    use Ecto.Schema

    import Ecto.Changeset

    alias ElixirPhoenix.Hotels.HotelRoom

    schema "hotels" do
      field :name, :string
      has_many :hotel_rooms, HotelRoom, on_delete: :delete_all

      timestamps()
    end

    @doc false
    def changeset(hotel, attrs, _opts \\ []) do
      hotel
      |> cast(attrs, [:name])
      |> validate_required([:name])
    end

end
