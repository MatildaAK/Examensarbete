defmodule ElixirPhoenixWeb.HotelRoomLive.HotelRoomShow do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Hotels

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <.back navigate={~p"/hotel_rooms"}>Back to hotel rooms</.back>
      <.header>
        {@hotel_room.name} ({@hotel_room.hotel.name})
      </.header>

      <.list>
        <:item title="Name">{@hotel_room.name}</:item>
        <:item title="Size">{@hotel_room.size}</:item>
        <:item title="Hotel">{@hotel_room.hotel.name}</:item>
      </.list>

        <div class="flex justify-end space-x-6 mt-4">
        <.link
          phx-click={JS.push("delete", value: %{id: @hotel_room.id})}
          data-confirm="Are you sure you want to delete this hotel room?"
        >
          <.button type="danger">Delete</.button>
        </.link>
        <.link patch={~p"/hotel_rooms/#{@hotel_room}/edit"} phx-click={JS.push_focus()}>
          <.button>Edit hotel room</.button>
        </.link>
      </div>

      <.modal
        :if={@live_action == :edit}
        id="hotel-room-modal"
        show
        on_cancel={JS.patch(~p"/hotel_rooms/#{@hotel_room}")}
      >
        <.live_component
          module={ElixirPhoenixWeb.HotelRoomLive.HotelRoomFormComponent}
          id={@hotel_room.id}
          title={@page_title}
          action={@live_action}
          hotels={@hotels}
          hotel_room={@hotel_room}
          tenant={@tenant}
          patch={~p"/hotel_rooms/#{@hotel_room}"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    hotels = Enum.map(Hotels.list_hotels([prefix: socket.assigns.tenant]), fn x -> {x.name, x.id} end)

    {:ok,
      socket
      |> assign(:hotels, hotels)
      |> assign(:title, "Hotel room")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:hotel_room, Hotels.get_hotel_room!(id, [prefix: socket.assigns.tenant]))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    hotel_room = Hotels.get_hotel_room!(id, [prefix: socket.assigns.tenant])

    {:ok, _} = Hotels.delete_hotel_room(hotel_room, [prefix: socket.assigns.tenant])

    {:noreply, push_navigate(socket, to: ~p"/hotels")}
  end

  defp page_title(:show), do: "Show hotel"
  defp page_title(:edit), do: "Edit hotel"
end
