defmodule ElixirPhoenixWeb.HotelLive.HotelFormComponent do
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
        id="hotel-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save hotel</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{hotel: hotel, tenant: tenant} = assigns, socket) do
    changeset = Hotels.change_hotel(hotel, %{}, [prefix: tenant])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"hotel" => hotel_params}, socket) do
    changeset =
      socket.assigns.hotel
      |> Hotels.change_hotel(hotel_params, [prefix: socket.assigns.tenant])
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"hotel" => hotel_params}, socket) do
    save_hotel(socket, socket.assigns.action, hotel_params)
  end

  defp save_hotel(socket, :edit, hotel_params) do
    case Hotels.update_hotel(socket.assigns.hotel, hotel_params, [prefix: socket.assigns.tenant]) do
      {:ok, hotel} ->
        notify_parent({:saved, hotel})

        {:noreply,
         socket
         |> put_flash(:info, "hotel updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_hotel(socket, :new, hotel_params) do
    case Hotels.create_hotel(hotel_params, [prefix: socket.assigns.tenant]) do
      {:ok, hotel} ->
        notify_parent({:saved, hotel})

        {:noreply,
         socket
         |> put_flash(:info, "hotel created successfully")
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
