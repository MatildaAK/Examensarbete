defmodule ElixirPhoenixWeb.HotelLive.HotelShow do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Hotels
  alias ElixirPhoenix.Hotels.HotelRoom

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <.back navigate={~p"/hotels"}>Back to hotels</.back>
      <.header>
        {@hotel.name}
        <:actions>
          <.link patch={~p"/hotels/#{@hotel}/hotel_rooms/new"} phx-click={JS.push_focus()}>
            <.button>Add Room</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="hotel_rooms"
        rows={@streams.hotel_rooms}
        row_click={fn {_id, hotel_room} -> JS.navigate(~p"/hotel_rooms/#{hotel_room}") end}
      >
        <:col :let={{_id, hotel_room}} label="Name">{hotel_room.name}</:col>
        <:col :let={{_id, hotel_room}} label="Size">{hotel_room.size}</:col>
        <:action :let={{_id, hotel_room}}>
          <div class="sr-only">
            <.link navigate={~p"/hotel_rooms/#{hotel_room}"}>Show</.link>
          </div>
        </:action>
      </.table>

        <div class="flex justify-end space-x-6 mt-4">
        <.link
          phx-click={JS.push("delete", value: %{id: @hotel.id})}
          data-confirm="Are you sure you want to delete this hotel and all hotel_rooms releted to it?"
        >
          <.button type="danger">Delete</.button>
        </.link>
        <.link patch={~p"/hotels/#{@hotel}/edit"} phx-click={JS.push_focus()}>
          <.button>Edit hotel</.button>
        </.link>
      </div>

      <.modal
        :if={@live_action == :edit}
        id="hotel-modal"
        show
        on_cancel={JS.patch(~p"/hotels/#{@hotel}")}
      >
        <.live_component
          module={ElixirPhoenixWeb.HotelLive.HotelFormComponent}
          id={@hotel.id}
          title={@page_title}
          action={@live_action}
          hotel={@hotel}
          tenant={@tenant}
          patch={~p"/hotels/#{@hotel}"}
        />
      </.modal>

      <.modal
        :if={@live_action == :new_hotel_room}
        id="hotel-room-modal"
        show
        on_cancel={JS.patch(~p"/hotels/#{@hotel}")}
      >
        <.live_component
          module={ElixirPhoenixWeb.HotelRoomLive.HotelRoomFormComponent}
          id={:new}
          title={@page_title}
          action={:new}
          hotel_room={%HotelRoom{hotel_id: @hotel.id}}
          hotels={[{@hotel.name, @hotel.id}]}
          tenant={@tenant}
          patch={~p"/hotels/#{@hotel}"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :title, "Hotel")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    hotel = Hotels.get_hotel!(id, [prefix: socket.assigns.tenant])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:hotel, hotel)
     |> stream(:hotel_rooms, hotel.hotel_rooms)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    hotel = Hotels.get_hotel!(id, [prefix: socket.assigns.tenant])

    {:ok, _} = Hotels.delete_hotel(hotel, [prefix: socket.assigns.tenant])

    {:noreply, push_navigate(socket, to: ~p"/hotels")}
  end

  defp page_title(:show), do: "Show hotel"
  defp page_title(:edit), do: "Edit hotel"
  defp page_title(:new_hotel_room), do: "New Hotel Room"
end
