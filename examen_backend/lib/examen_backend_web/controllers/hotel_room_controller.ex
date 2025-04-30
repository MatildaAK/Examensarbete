defmodule ExamenBackendWeb.HotelRoomController do
  use ExamenBackendWeb, :controller

  alias ExamenBackend.Hotels
  alias ExamenBackend.Hotels.HotelRoom
  alias ExamenBackendWeb.Serializers

  def index(conn, _params) do
    hotel_rooms = Hotels.list_hotel_rooms([prefix: conn.assigns.tenant])
    json(conn, %{data: Enum.map(hotel_rooms, &Serializers.serialize_hotel_room/1)})
  end

  def show(conn, %{"id" => id}) do
    hotel_room = Hotels.get_hotel_room!(id, [prefix: conn.assigns.tenant])
    json(conn, %{data: Serializers.serialize_hotel_room(hotel_room)})
  end

  def create(conn, %{"hotel_room" => hotel_room_params}) do
    with {:ok, %HotelRoom{} = hotel_room} <- Hotels.create_hotel_room(hotel_room_params, [prefix: conn.assigns.tenant]) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/hotel_rooms/#{hotel_room.id}")
      |> json(%{data: Serializers.serialize_hotel_room(hotel_room)})
    end
  end

  def update(conn, %{"id" => id, "hotel_room" => hotel_room_params}) do
    hotel_room = Hotels.get_hotel_room!(id, [prefix: conn.assigns.tenant])

    with {:ok, %HotelRoom{} = updated_hotel_room} <- Hotels.update_hotel_room(hotel_room, hotel_room_params) do
      json(conn, %{data: Serializers.serialize_hotel_room(updated_hotel_room)})
    end
  end

  def delete(conn, %{"id" => id}) do
    hotel_room = Hotels.get_hotel_room!(id, [prefix: conn.assigns.tenant])

    with {:ok, %HotelRoom{}} <- Hotels.delete_hotel_room(hotel_room) do
      send_resp(conn, :no_content, "")
    end
  end
end
