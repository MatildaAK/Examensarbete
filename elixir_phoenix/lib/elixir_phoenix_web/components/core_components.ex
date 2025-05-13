defmodule ElixirPhoenixWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use Gettext, backend: ElixirPhoenixWeb.Gettext

  alias Phoenix.HTML.FormField
  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-accent/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                {render_slot(@inner_block)}
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={["fixed top-2 right-2 z-50 w-80 rounded-lg p-3 ring-1 sm:w-96", @kind == :info && "bg-emerald-50 fill-cyan-900 text-emerald-800 ring-emerald-500", @kind == :error && "bg-destructive fill-destructive-foreground text-destructive-foreground shadow-md ring-rose-500"]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        {@title}
      </p>
      <p class="mt-2 text-sm leading-5">{msg}</p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} title="Success!" flash={@flash} />
    <.flash kind={:error} title="Error!" flash={@flash} />
    <.flash
      id="disconnected"
      kind={:error}
      title="We can't find the internet"
      phx-disconnected={show("#disconnected")}
      phx-connected={hide("#disconnected")}
      hidden
    >
      Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
    </.flash>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders login form.
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def login_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      {render_slot(@inner_block, f)}
      <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
        {render_slot(action, f)}
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button type="danger">Delete</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string,
    default: "primary",
    values: ~w(primary danger)
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(%{type: "danger"} = assigns) do
    ~H"""
    <button
      type={@type}
      class={[
      base_button_classes(),
      "bg-[#B50D0D] hover:bg-red-400 border-1 border-[#E77C56]",
      @class
    ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
      base_button_classes(),
      "bg-secondary hover:bg-secondary-hover active:bg-secondary",
      @class
    ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp base_button_classes do
    "rounded-lg px-3 py-2 font-bold leading-6 text-white outline-white cursor-pointer disabled:[&not(:phx-click-loading)]:opacity-50 disabled:[&not(:phx-submit-loading)]:opacity-50 disabled:pointer-events-none phx-click-loading:animate-pulse phx-submit-loading:animate-pulse"
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local date-range email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, FormField, doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global, include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name} class="peer">
      <label class="text-foreground flex items-center gap-4 text-base leading-6">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="border-border text-primary accent-primary rounded focus:ring-0"
          {@rest}
        />
        {@label}
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}>{@label}</.label>
      <select id={@id} name={@name} class={base_input_classes(@errors)} multiple={@multiple} {@rest}>
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}>{@label}</.label>
      <textarea id={@id} name={@name} class={base_input_classes(@errors)} {@rest}><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "date-range"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}>{@label}</.label>
      <input id={"##{@id}-from-date"} name={"#{@name}-from-date"} type="hidden" />
      <input id={"##{@id}-to-date"} name={"#{@name}-to-date"} type="hidden" />
      <div class="relative">
        <input
          type="text"
          name={@name}
          id={@id}
          phx-hook="DateRange"
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[base_input_classes(@errors), "relative cursor-pointer"]}
          {@rest}
        />
        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
          <.icon name="hero-calendar" class="text-foreground h-5 w-5" />
        </div>
      </div>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}>{@label}</.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[base_input_classes(@errors)]}
        {@rest}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  defp base_input_classes(errors),
    do: [
      "text-foreground mt-2 block w-full border-b-2 border-primary outline-none",
      "phx-no-feedback:border-border phx-no-feedback:focus:border-border",
      errors == [] && "border-border focus:border-border",
      errors != [] && "border-destructive-foreground focus:border-destructive-foreground"
    ]

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="text-accent-foreground block text-base font-semibold leading-6">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="text-destructive-foreground mt-3 flex gap-3 text-sm leading-6 phx-no-feedback:hidden">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-inherit">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="text-muted-foreground mt-2 text-sm leading-6">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-accent0 text-left text-sm leading-6">
          <tr>
            <th :for={col <- @col} class="p-0 pr-6 pb-4 font-normal">{col[:label]}</th>
            <th class="relative p-0 pb-4"><span class="sr-only">{gettext("Actions")}</span></th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="divide-border border-primary text-accent-foreground relative divide-y border-t text-sm leading-6"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group border-primary hover:bg-primary/30">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-accent sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "text-foreground font-semibold"]}>
                  {render_slot(col, @row_item.(row))}
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-accent sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="text-foreground relative ml-4 font-semibold leading-6 hover:text-accent-foreground"
                >
                  {render_slot(action, @row_item.(row))}
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc ~S"""
  Renders a flexible list layout using flexbox.
  ## Examples
        <.flex_list id="areas" rows={@streams.areas}>
        <:col :let={{_id, area}} label="Name">
          <.link navigate={~p"/admin/areas/#{area}"} class="block w-full">
            <%= area.name %>
          </.link>
        </:col>
        <:action :let={{_id, area}}>
          <.link navigate={~p"/admin/areas/#{area}"}>
            <.icon name="hero-arrow-right" class="h-5 w-5" />
          </.link>
        </:action>
      </.flex_list>
"""
attr :id, :string, required: true
attr :rows, :list, required: true
attr :row_id, :any, default: nil, doc: "the function for generating the row id"
attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

attr :row_item, :any,
  default: &Function.identity/1,
  doc: "the function for mapping each row before calling the :col and :action slots"

slot :col, required: true do
  attr :label, :string
end

slot :action, doc: "the slot for showing user actions"

def flex_list(assigns) do
  assigns =
    with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
      assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
    end

  ~H"""
  <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
    <div class="w-[40rem] mt-11 sm:w-full">
      <%!-- Header row --%>
      <div class="flex items-center text-left text-sm leading-6 text-accent0 border-b border-primary pb-4">
        <div :for={col <- @col} class="flex-1 pr-6 font-normal">
          <%= col[:label] %>
        </div>
        <div class="w-32">
          <span class="sr-only"><%= gettext("Actions") %></span>
        </div>
      </div>
      <%!-- List items --%>
      <div
        id={@id}
        phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
        class="divide-y divide-border"
      >
        <div
          :for={row <- @rows}
          id={@row_id && @row_id.(row)}
          class="group hover:bg-primary/30"
        >
          <div class="flex items-center py-4 text-sm leading-6 text-accent-foreground">
            <div
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["flex-1 pr-6", @row_click && "hover:cursor-pointer"]}
            >
              <span class={["relative", i == 0 && "font-semibold text-foreground"]}>
                <%= render_slot(col, @row_item.(row)) %>
              </span>
            </div>
            <div :if={@action != []} class="w-32 flex justify-end gap-3">
              <span
                :for={action <- @action}
                class="relative font-semibold text-foreground hover:text-accent-foreground"
              >
                <%= render_slot(action, @row_item.(row)) %>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="divide-border -my-4 divide-y">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 border-primary sm:gap-8">
          <dt class="text-accent0 w-1/4 flex-none">{item.title}</dt>
          <dd class="text-accent-foreground">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-6 mb-6">
      <.link
        navigate={@navigate}
        class="text-foreground text-sm font-semibold leading-6 hover:text-accent-foreground"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid an mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `assets/vendor/heroicons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(ElixirPhoenixWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(ElixirPhoenixWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  attr :class, :any, default: nil

  slot :inner_block

  def container(assigns) do
    ~H"""
    <div class={["mx-auto w-full px-4 sm:max-w-3xl sm:px-6 lg:px-8", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: ""

  def spinner(assigns) do
    ~H"""
    <p class="ml-2 flex flex-row items-center text-sm">
      <svg
        class="mr-3 -ml-1 h-4 w-4 animate-spin"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
        </circle>
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        >
        </path>
      </svg>
      <span class="sr-only">Loading...</span>
    </p>
    """
  end

  attr(:id, :string, required: true)

  attr(:class, :string, default: "")
  attr(:dropdown_class, :string, default: "")
  attr(:placement, :string, default: "left", values: ["left", "right"])
  attr(:rest, :global)
  slot(:button)

  slot :item do
    attr(:role, :string)
  end

  def dropdown_menu(assigns) do
    ~H"""
    <div class="relative">
      {render_slot(@button, %{
        "phx-click": toggle_menu("##{@id}"),
        id: "#{@id}-button",
        "aria-expanded": "false",
        "aria-haspopup": "true"
      })}

      <div
        id={@id}
        data-button-id={@id <> "-button"}
        class={[placement_class(@placement), "bg-background text-foreground border-border absolute z-30 mt-2 hidden w-max overflow-visible rounded-lg border p-0 shadow-md focus:outline-none", @class]}
        role="menu"
        aria-orientation="vertical"
        aria-labelledby={@id <> "-button"}
        phx-click-away={toggle_menu("##{@id}")}
      >
        <.focus_wrap id={@id <> "-focus"}>
          <ul :if={not Enum.empty?(@item)} role="list" {@rest} class={@dropdown_class}>
            <li :for={item <- @item} class="flex flex-col" role={item[:role] || "listitem"}>
              {render_slot(item)}
            </li>
          </ul>
          {render_slot(@inner_block)}
          <ul :if={not Enum.empty?(@item)} role="list" {@rest} class={@dropdown_class}>
            <li :for={item <- @item} class="flex flex-col" role={item[:role] || "listitem"}>
              {render_slot(item)}
            </li>
          </ul>
        </.focus_wrap>
      </div>
    </div>
    """
  end

  defp placement_class("left"), do: "left-auto right-0 origin-top-right"
  defp placement_class("right"), do: "left-0 right-auto origin-top-left"

  defp toggle_menu(js \\ %JS{}, id) do
    js
    |> JS.toggle_class("hidden", to: "#{id}")
    |> JS.toggle_class("text-accent-foreground", to: "#{id}-button")
  end

  attr :class, :any, default: ""
  attr :rest, :global, default: %{}, include: ~w(href navigate patch)
  slot :inner_block, required: true

  def dropdown_menu_link(assigns) do
    ~H"""
    <.link
      class={["flex items-center rounded-lg bg-white px-3 py-1.5 text-sm no-underline hover:bg-accent focus:ring-0", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :orientation, :string, values: ~w(vertical horizontal), default: "horizontal"
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  def separator(assigns) do
    ~H"""
    <div
      class={["bg-border shrink-0", (@orientation == "horizontal" && "h-[1px] w-full") || "w-[1px] h-full", @class]}
      {@rest}
    >
    </div>
    """
  end

  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(patch navigate href)

  slot :inner_block

  def card_link(assigns) do
    ~H"""
    <.link class={["group text-center", @class]} {@rest}>
      <div class="bg-secondary text-secondary-foreground relative flex cursor-pointer flex-col items-center justify-center gap-y-2 rounded-lg py-6 text-center text-lg font-bold uppercase group-hover:bg-secondary-hover">
        {render_slot(@inner_block)}
      </div>
    </.link>
    """
  end
end
