defmodule ExamenBackendWeb.HotelController do
  use ExamenBackendWeb, :controller

  alias ExamenBackend.Hotels
  alias ExamenBackend.Hotels.Hotel
  alias ExamenBackendWeb.Serializers

  def index(conn, _params) do
    hotels = Hotels.list_hotels([prefix: conn.assigns.tenant])
    json(conn, %{data: Enum.map(hotels, &Serializers.serialize_hotel/1)})
  end

  def show(conn, %{"id" => id}) do
    hotel = Hotels.get_hotel!(id, [prefix: conn.assigns.tenant])

    json(conn, %{ data: Serializers.serialize_hotel_with_rooms(hotel)})
  end

  def create(conn, %{"hotel" => hotel_params}) do
    with {:ok, %Hotel{} = hotel} <- Hotels.create_hotel(hotel_params, [prefix: conn.assigns.tenant]) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/hotels/#{hotel.id}")
      |> json(%{data: Serializers.serialize_hotel(hotel)})
    end
  end

  def update(conn, %{"id" => id, "hotel" => hotel_params}) do
    hotel = Hotels.get_hotel!(id, [prefix: conn.assigns.tenant])

    with {:ok, %Hotel{} = updated_hotel} <- Hotels.update_hotel(hotel, hotel_params, [prefix: conn.assigns.tenant]) do
      json(conn, %{data: Serializers.serialize_hotel(updated_hotel)})
    end
  end

  def delete(conn, %{"id" => id}) do
    hotel = Hotels.get_hotel!(id, [prefix: conn.assigns.tenant])

    with {:ok, %Hotel{}} <- Hotels.delete_hotel(hotel) do
      send_resp(conn, :no_content, "")
    end
  end
end
