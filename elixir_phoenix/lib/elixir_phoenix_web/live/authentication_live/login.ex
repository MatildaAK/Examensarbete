defmodule ElixirPhoenixWeb.AuthenticationLive.Login do
  @moduledoc false
  use ElixirPhoenixWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto mt-32 max-w-sm">
      <.login_form
        for={@form}
        id="login_form"
        action={~p"/log_in"}
        phx-update="ignore"
        autocomplete="off"
      >
        <div class="bg-primary text-primary-foreground w-full rounded-lg px-14 py-14">
          <div class="flex items-center gap-1" phx-feedback-for="user[account]">
            <label for="user_account" class="mt-2 block text-lg font-bold leading-6 text-white">
              ACCOUNT:
            </label>
            <div class="relative w-full text-white">
              <input
                type="text"
                name="user[account]"
                id="user_account"
                class="peer ps-0 bg-primary block w-full border-0 border-b-2 border-white pb-0 text-lg outline-none"
                required
              />
              <div
                class="border-border absolute inset-x-0 bottom-0 border-t peer-focus:border-t-4 peer-focus:border-white"
                aria-hidden="true"
              >
              </div>
            </div>
          </div>

          <div class="flex items-center gap-1" phx-feedback-for="user[password]">
            <label for="user_password" class="mt-2 block text-lg font-bold leading-6 text-white">
              PASSWORD:
            </label>
            <div class="relative w-full text-white">
              <input
                type="password"
                name="user[password]"
                id="user_password"
                class="peer ps-0 bg-primary block w-full border-0 border-b-2 border-white pb-0 text-lg outline-none"
                required
              />
              <div
                class="border-border absolute inset-x-0 bottom-0 border-t peer-focus:border-t-4 peer-focus:border-white"
                aria-hidden="true"
              >
              </div>
            </div>
          </div>
        </div>
        <:actions>
          <!--<.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link> -->
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="mx-auto w-1/2">LOGIN</.button>
        </:actions>
      </.login_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    account = Phoenix.Flash.get(socket.assigns.flash, :account)
    form = to_form(%{"account" => account}, as: "user")
    title = "WELCOME!"
    {:ok, socket |> assign(form: form) |> assign(title: title), temporary_assigns: [form: form]}
  end
end
