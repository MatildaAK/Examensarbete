defmodule ElixirPhoenixWeb.HotelRoomLive.HotelRoomFormComponent do
  use ElixirPhoenixWeb, :live_component

  alias ElixirPhoenix.Hotels

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="hotel-room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:size]} type="text" label="Size" />
        <.input field={@form[:hotel_id]} type="select" label="Hotel" options={@hotels} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Room</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{hotel_room: hotel_room, tenant: tenant} = assigns, socket) do
    changeset = Hotels.change_hotel_room(hotel_room, %{}, [prefix: tenant])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"hotel_room" => hotel_room_params}, socket) do
    changeset =
      socket.assigns.hotel_room
      |> Hotels.change_hotel_room(hotel_room_params, [prefix: socket.assigns.tenant])
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"hotel_room" => hotel_room_params}, socket) do
    save_hotel_room(socket, socket.assigns.action, hotel_room_params)
  end

  defp save_hotel_room(socket, :edit, hotel_room_params) do
    case Hotels.update_hotel_room(socket.assigns.hotel_room, hotel_room_params, [prefix: socket.assigns.tenant]) do
      {:ok, hotel_room} ->
        notify_parent({:saved, hotel_room})

        {:noreply,
         socket
         |> put_flash(:info, "hotel room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_hotel_room(socket, :new, hotel_room_params) do
    case Hotels.create_hotel_room(hotel_room_params, [prefix: socket.assigns.tenant]) do
      {:ok, hotel_room} ->
        notify_parent({:saved, hotel_room})

        {:noreply,
         socket
         |> put_flash(:info, "hotel room created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
