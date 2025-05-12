defmodule ElixirPhoenixWeb.UserLive.UserShow do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Accounts.Users

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">

      <div class="mb-8">
        <.back navigate={~p"/users"}>Back to users</.back>
      </div>

      <.header>
        User: <%= @user.name %>
      </.header>

      <.list>
        <:item title="Name"> <%= @user.name %></:item>
        <:item title="User name"> <%= @user.user_name %></:item>
        <:item title="Email"> <%= @user.email %></:item>
      </.list>

      <div class="flex justify-end">
        <div class="w-1/4">
          <div class="flex justify-between">
            <div>
              <button class="bg-[#B50D0D] py-2 px-3 rounded-lg text-white border-2 border-solid border-[#E77C56] hover:bg-[#E44646]"
                phx-click={JS.push("delete", value: %{id: @user.id}) |> hide("##{@user.id}")}
                data-confirm="Are you sure?"
              >
                Delete
              </button>
            </div>
            <div>
              <.link patch={~p"/users/#{@user}/edit"} phx-click={JS.push_focus()}>
                <.button>Edit</.button>
              </.link>
            </div>
          </div>
        </div>
      </div>

      <.modal
      :if={@live_action == :edit}
        id="user-modal"
        show
        on_cancel={JS.patch(~p"/users/#{@user}")}
      >
        <.live_component
          module={ElixirPhoenixWeb.UserLive.UserSettings}
          tenant={@tenant}
          id={@user.id}
          title={@page_title}
          action={@live_action}
          user={@user}
          patch={~p"/users/#{@user}"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :title, "User")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Users.get_user!(id, [prefix: socket.assigns.tenant]))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Users.get_user!(id, [prefix: socket.assigns.tenant])
    {:ok, _} = Users.delete_user(user, [prefix: socket.assigns.tenant])

    {:noreply,
    socket
    |> assign(:users, user)
    |> put_flash(:info, "User #{user.name} deleted successfully.")
    |> push_navigate(to: ~p"/users")}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
