defmodule ElixirPhoenixWeb.HomeLive do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  # alias ElixirPhoenixWeb.Utils.Titles

  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <section class="grid grid-cols-1 gap-y-6 sm:grid-cols-3 sm:gap-x-4">
        <.card_link navigate={~p"/users"}>
          <.icon name="hero-users" class="h-16 w-16" /> Users
        </.card_link>
        <.card_link navigate={~p"/hotels"}>
          <.icon name="hero-home-modern" class="h-16 w-16" /> Hotels
        </.card_link>
        <.card_link navigate={~p"/hotel_rooms"}>
          <.icon name="hero-building-office-2" class="h-16 w-16" /> Hotel Rooms
        </.card_link>
        <%!-- <.card_link navigate={~p"/hotel_rooms_1000"}>
          <.icon name="hero-building-office-2" class="h-16 w-16" /> Hotel Rooms 1000
        </.card_link> --%>
      </section>
    </.container>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :title, "Welcome!")}
  end

end
