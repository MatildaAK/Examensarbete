defmodule ExamenBackend.Hotels do
   @moduledoc false
   import Ecto.Query, warn: false


   alias ExamenBackend.Hotels.Hotel
   alias ExamenBackend.Hotels.HotelRoom
   alias ExamenBackend.Repo

   def list_hotels(opts) do
    Hotel
    |> order_by([a], a.name)
    |> Repo.all(opts)
  end

  @doc """
  Gets a single hotel.

  Raises `Ecto.NoResultsError` if the hotel does not exist.
  """
  def get_hotel!(id, opts) do
    Hotel
    |> Repo.get!(id, opts)
    |> Repo.preload(:hotel_rooms)
  end

  @doc """
  Creates a hotel.
  """
  def create_hotel(attrs, opts \\ []) do
    %Hotel{}
    |> Hotel.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a hotel.
  """
  def update_hotel(%Hotel{} = hotel, attrs, opts) do
    hotel
    |> Hotel.changeset(attrs, opts)
    |> Repo.update(opts)
  end

   @doc """
  Returns an `%Ecto.Changeset{}` for tracking hotel changes.
  """
  def change_hotel(%Hotel{} = hotel, attrs, opts \\ []) do
   Hotel.changeset(hotel, attrs, opts)
 end

  @doc """
  Deletes a hotel.
  """
  def delete_hotel(%Hotel{} = hotel, opts \\ []) do
    Repo.delete(hotel, opts)
  end

  def list_hotel_rooms(opts) do
   HotelRoom
   |> order_by([a], a.name)
   |> Repo.all(opts)
   |> Repo.preload(:hotel)
  end

  def get_hotel_room!(id, opts), do: HotelRoom |> Repo.get!(id, opts) |> Repo.preload(:hotel)

  def create_hotel_room(attrs, opts \\ []) do
    %HotelRoom{}
    |> HotelRoom.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  def update_hotel_room(%HotelRoom{} = hotel_room, attrs, opts \\ []) do
    hotel_room
    |> HotelRoom.changeset(attrs, opts)
    |> Repo.update(opts)
  end

  def delete_hotel_room(%HotelRoom{} = hotel_room, opts \\ []) do
    Repo.delete(hotel_room, opts)
  end
end
