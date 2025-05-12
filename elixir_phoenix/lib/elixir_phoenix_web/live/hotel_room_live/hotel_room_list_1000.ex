defmodule ElixirPhoenixWeb.HotelRoomLive.HotelRoomList1000 do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Hotels
  alias ElixirPhoenix.Hotels.HotelRoom
  alias ElixirPhoenix.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <.back navigate={~p"/"}>Back to menu</.back>
      <.header>
        Listing Hotel Rooms
        <:actions>
          <.link patch={~p"/hotel_rooms/new"}>
            <.button>Add Room</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="hotel_rooms"
        rows={@streams.hotel_rooms}
        row_click={fn {_id, hotel_room} -> JS.navigate(~p"/hotel_rooms/#{to_string(hotel_room.id)}") end}
      >
        <:col :let={{_id, hotel_room}} label="Name">{hotel_room.name}</:col>
        <:col :let={{_id, hotel_room}} label="Size">{hotel_room.size}</:col>
        <:col :let={{_id, hotel_room}} label="Hotel">{hotel_room.hotel.name}</:col>
        <:action :let={{_id, hotel_room}}>
          <div class="sr-only">
            <.link navigate={~p"/hotel_rooms/#{to_string(hotel_room.id)}"}>Show</.link>
          </div>
        </:action>
      </.table>

      <.modal
        :if={@live_action in [:new, :edit]}
        id="hotel-rooms-modal"
        show
        on_cancel={JS.patch(~p"/hotel_rooms")}
      >
        <.live_component
          module={ElixirPhoenixWeb.HotelRoomLive.HotelRoomFormComponent}
          tenant={@tenant}
          id={@hotel_room.id || :new}
          title={@page_title}
          action={@live_action}
          hotels={@hotels}
          hotel_room={@hotel_room}
          patch={~p"/hotel_rooms"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    hotel_rooms = ElixirPhoenix.MockData.large_list_with_hotels()

    {:ok,
     socket
     |> assign(:title, "Hotel Rooms")
     |> stream(:hotel_rooms, hotel_rooms)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    hotels = Hotels.list_hotels([prefix: socket.assigns.tenant]) |> Enum.map(fn hotel -> {hotel.name, hotel.id} end)

    socket
    |> assign(:page_title, "New hotel room")
    |> assign(:hotels, hotels)
    |> assign(:hotel_room, %HotelRoom{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing hotel rooms")
    |> assign(:hotel_room, nil)
  end

  @impl true
  def handle_info({ElixirPhoenixWeb.HotelRoomLive.HotelRoomFormComponent, {:saved, hotel_room}}, socket) do
    {:noreply, stream_insert(socket, :hotel_rooms, Repo.preload(hotel_room, :hotel))}
  end
end
