defmodule ElixirPhoenixWeb.UserLive.UserSettings do
    @moduledoc false
    use ElixirPhoenixWeb, :live_component

    alias ElixirPhoenix.Accounts.Users

    @impl true
    def render(assigns) do
      ~H"""
      <div class="my-6">
        <.header>
            <%= @title %>
        </.header>

        <div class="space-y-12 divide-y">
          <div class="pb-8">
            <.simple_form
              for={@user_form}
              id="update-user-form"
              phx-target={@myself}
              phx-change="validate_user"
              phx-submit="update_user"
            >
              <.input field={@user_form[:name]} type="text" label="Name"/>
              <.input field={@user_form[:user_name]} type="text" label="User name" />
              <.input field={@user_form[:email]} type="text" label="Email" />
              <:actions>
                <.button phx-disable-with="Saving...">Change User</.button>
              </:actions>
            </.simple_form>
          </div>

          <div>
            <.simple_form
              for={@password_form}
              id="password-form"
              phx-target={@myself}
              phx-change="validate_password"
              phx-submit="update_password"
            >
              <.input
                field={@password_form[:password]}
                type="password"
                label="New password"
                placeholder="Password"
                required
              />
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label="Confirm new password"
                placeholder="Confirm Password"
              />
              <:actions>
                <.button phx-disable-with="Saving...">Change Password</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </div>
      """
    end

    @impl true
    def update(%{user: user, tenant: tenant} = assigns, socket) do
      password_changeset = Users.change_user_password(user)
      user_changeset = Users.change_user(user, %{}, [prefix: tenant])

      socket =
        socket
        |> assign(:title, "User")
        |> assign(assigns)
        |> assign(:password_form, to_form(password_changeset))
        |> assign(:user_form, to_form(user_changeset))

      {:ok, socket}
    end

    @impl true
    def handle_event("validate_user", %{"user" => user_params}, socket) do
      changeset =
        socket.assigns.user
        |> Users.change_user(user_params, [prefix: socket.assigns.tenant])
        |> Map.put(:action, :validate)

      {:noreply, assign(socket, user_form: to_form(changeset))}
    end

    @impl true
    def handle_event("validate_password", %{"user" => %{"password_confirmation" => password} = user_params}, socket) do
      changeset =
        socket.assigns.user
        |> Users.change_user_password(user_params)
        |> Map.put(:action, :validate)

      {:noreply, assign(socket, password_form: to_form(changeset), password_confirmation: password)}
    end

    def handle_event("update_password", %{"user" => %{"password_confirmation" => password} = user_params}, socket) do
      case Users.update_user_password(
        socket.assigns.user,
        password,
        user_params,
        [prefix: socket.assigns.tenant]
        ) do
        {:ok, user} ->
          notify_parent({:saved, user})

          {:noreply,
            socket
            |> put_flash(:info, "Password updated successfully")
            |> assign(:user, user)
            |> push_patch(to: socket.assigns.patch)
          }

        {:error, changeset} ->
          {:noreply, assign(socket, password_form: to_form(changeset))}
      end
    end

    def handle_event("update_user", %{"user" => user_params}, socket) do
        case Users.update_user(
          socket.assigns.user,
          user_params,
          [prefix: socket.assigns.tenant]
          ) do
        {:ok, user} ->
          notify_parent({:saved, user})

          {:noreply,
            socket
            |> put_flash(:info,  "#{user.name} updated successfully")
            |> assign(:user, user)
            |> redirect(to: socket.assigns.patch)
          }
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, user_form: to_form(changeset))}
      end
    end

    defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
