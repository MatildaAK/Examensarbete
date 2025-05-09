defmodule ElixirPhoenixWeb.Layouts do
  @moduledoc false

  use ElixirPhoenixWeb, :html

  embed_templates "layouts/*"

  attr :class, :string, default: ""

  slot :inner_block

  def nav_bar(assigns) do
    ~H"""
    <nav class="mx-auto my-4 flex items-center justify-center">
      <div class="flex gap-x-12">
        {render_slot(@inner_block)}
      </div>
    </nav>
    """
  end

  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(navigate patch href)

  slot :inner_block

  def nav_bar_link(assigns) do
    ~H"""
    <.link
      class="text-foreground text-lg font-semibold uppercase hover:text-accent-foreground"
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block

  def page_header(assigns) do
    ~H"""
    <div class="mx-6 lg:mx-8">
      <.header class="bg-primary text-primary-foreground mx-auto max-w-7xl overflow-hidden rounded-lg px-6 lg:px-8">
        {render_slot(@inner_block)}
      </.header>
    </div>
    """
  end

  attr :class, :string, default: ""

  def qsimbo_logo(assigns) do
    ~H"""
    <img class={["mx-auto block", @class]} src="/images/logo.png" alt="QSimbo logo" />
    """
  end

  attr :class, :string, default: ""
  attr :current_user, :map, default: nil

  slot :inner_block

  def footer(assigns) do
    ~H"""
    <footer class="bg-primary text-primary-foreground mt-10 w-full">
      <div class="mx-auto flex max-w-7xl justify-between px-6 py-6 md:flex-row lg:px-8">
        <.user_menu current_user={@current_user} />

        <nav class="flex flex-wrap items-center justify-center gap-x-12 gap-y-3" aria-label="Footer">
          <a href="#" class="text-primary-foreground text-xl font-semibold hover:text-muted">
            Contact Us
          </a>
        </nav>
      </div>
    </footer>
    """
  end

  attr :current_user, :map, default: nil

  def user_menu(assigns) do
    ~H"""
    <%= if @current_user do %>
      <div class="group relative">
        <button class="hover">
          <div class="flex">
            <div>
              <h4 class="text-lg font-bold">{@current_user.user_name}</h4>
              <p>{@current_user.name}</p>
            </div>
          </div>
        </button>
        <div class="ring-black/5 w-35 bg-primary absolute bottom-full left-1/2 z-10 hidden -translate-x-1/2 rounded-md shadow-lg ring-1 group-hover:block">
          <div class="py-1">
            <.link
              class="text-m text-primary-foreground mx-3 mt-1 block border-b border-transparent py-1 hover:border-b-white"
              href="#"
            >
              User Profile
            </.link>
            <.link
              class="text-m text-primary-foreground mx-3 mb-2 block border-b border-transparent py-1 hover:border-b-white"
              href={~p"/users/log_out"}
              method="delete"
            >
              Sign out
            </.link>
          </div>
        </div>
      </div>
    <% end %>
    """
  end
end
