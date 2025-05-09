defmodule ExamenBackendWeb.Serializers do

  alias ExamenBackend.Hotels.Hotel
  alias ExamenBackend.Hotels.HotelRoom

  def serialize_hotel(%Hotel{} = hotel) do
    %{
      id: hotel.id,
      name: hotel.name,
    }
  end

  def serialize_hotel_with_rooms(%Hotel{} = hotel) do
    %{
      id: hotel.id,
      name: hotel.name,
      hotel_rooms: Enum.map(hotel.hotel_rooms, &serialize_hotel_room(&1))
    }
  end

  def serialize_hotel_room(%HotelRoom{} = hotel_room) do
    %{
      id: hotel_room.id,
      name: hotel_room.name,
      size: hotel_room.size,
      hotel_id: hotel_room.hotel_id
    }
  end
end
