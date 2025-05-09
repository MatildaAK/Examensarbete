defmodule ElixirPhoenixWeb.HomeLive do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  # alias ElixirPhoenixWeb.Utils.Titles

  def render(assigns) do
    ~H"""
    <.container class="my-6">
      <section class="grid grid-cols-1 gap-y-6 sm:grid-cols-3 sm:gap-x-4">
        <.card_link navigate={~p"/#"}>
          <.icon name="hero-home-modern-solid" class="h-16 w-16" /> Add a booking
        </.card_link>
        <.card_link navigate={~p"/#"}>
          <.icon name="hero-presentation-chart-line-solid" class="h-16 w-16" /> Check-in
        </.card_link>
        <.card_link navigate={~p"/#"}>
          <.icon name="hero-banknotes-solid" class="h-16 w-16" /> Check-out
        </.card_link>
      </section>
    </.container>
    """
  end

  def mount(_params, _session, socket) do
    # Phoenix.PubSub.subscribe(Qh.PubSub, "time")
    # socket = assign(socket, :title, Titles.day_date_time())
    {:ok,
      socket
      |> assign(:title, "Title")}
  end

end
