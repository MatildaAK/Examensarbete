defmodule ElixirPhoenixWeb.HotelLive.HotelList do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Hotels
  alias ElixirPhoenix.Hotels.Hotel

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <.back navigate={~p"/"}>Back to menu</.back>
      <.header>
        Hotels
        <:actions>
          <.link patch={~p"/hotels/new"}>
            <.button>Add hotel</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="hotels"
        rows={@streams.hotels}
        row_click={fn {_id, hotel} -> JS.navigate(~p"/hotels/#{hotel}") end}
      >
        <:col :let={{_id, hotel}} label="Name">{hotel.name}</:col>
        <:action :let={{_id, hotel}}>
          <div class="sr-only">
            <.link navigate={~p"/hotels/#{hotel}"}>Show</.link>
          </div>
        </:action>
      </.table>

      <.modal :if={@live_action in [:new]} id="hotel-modal" show on_cancel={JS.patch(~p"/hotels")}>
        <.live_component
          module={ElixirPhoenixWeb.HotelLive.HotelFormComponent}
          tenant={@tenant}
          id={@hotel.id || :new}
          title={@page_title}
          action={@live_action}
          hotel={@hotel}
          patch={~p"/hotels"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:title, "Hotels")
     |> stream(:hotels, Hotels.list_hotels([prefix: socket.assigns.tenant]))}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New hotel")
    |> assign(:hotel, %Hotel{}  |> Ecto.put_meta([prefix: socket.assigns.tenant]))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing hotels")
    |> assign(:hotel, nil)
  end

  @impl true
  def handle_info({ElixirPhoenixWeb.HotelLive.HotelFormComponent, {:saved, hotel}}, socket) do
    {:noreply, stream_insert(socket, :hotels, hotel)}
  end
end
