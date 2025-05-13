defmodule ElixirPhoenixWeb.UserLive.UserList do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  alias ElixirPhoenix.Accounts.Users
  alias ElixirPhoenix.Accounts.Users.User

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="my-6">

      <div class="mb-8">
        <.back navigate={~p"/"}>Back to menu</.back>
      </div>

      <.header>
        Listing Users
        <:actions>
          <.link patch={~p"/users/new"}>
            <.button>New user</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="users"
        rows={@streams.users}
        row_click={fn {_id, user} -> JS.navigate(~p"/users/#{user}") end}
      >
        <:col :let={{_id, user}} label="Name">{user.name}</:col>
        <:col :let={{_id, user}} label="User name">{user.user_name}</:col>
        <:col :let={{_id, user}} label="Email">{user.email}</:col>

        <:action :let={{_id, user}}>
          <div class="sr-only">
            <.link navigate={~p"/users/#{user}"}>Show</.link>
          </div>
        </:action>
      </.table>

      <.modal
        :if={@live_action in [:new]}
        id="user-modal"
        show
        on_cancel={JS.patch(~p"/users")}
      >
        <.live_component
          module={ElixirPhoenixWeb.UserLive.UserFormComponent}
          tenant={@tenant}
          id={@user.id || :new}
          title={@page_title}
          action={@live_action}
          user={@user}
          patch={~p"/users"}
        />
      </.modal>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
    |> assign(:title, "Users")
    |> stream(:users, Users.list_users([prefix: socket.assigns.tenant]))}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{} |> Ecto.put_meta([prefix: socket.assigns.tenant]))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({ElixirPhoenixWeb.UserLive.UserFormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end
end
