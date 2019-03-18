defmodule LiveTestWeb.ThingLive do
  defmodule Index do
    use Phoenix.LiveView

    alias LiveTest.Validation
    alias LiveTest.Validation.Thing

    import Phoenix.HTML
    import Phoenix.HTML.Form
    import Phoenix.HTML.Tag
    import LiveTestWeb.ErrorHelpers

    def render(assigns) do
      ~L"""
      <h2>Listing Things</h2>

      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Number</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
      <%= for thing <- @things do %>
          <tr>
            <td><%= thing.name %></td>
            <td><%= thing.number %></td>
            <td>
              <button phx-click="delete_thing" phx-value="<%= thing.id %>">Delete</button>
            </td>
          </tr>
      <% end %>
          <tr>
          </tr>
        </tbody>
      </table>
      <button phx-click="new_empty_thing">New Thing</button>
      <%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :save_new_thing], fn f -> %>

        <%= label f, :name %>
        <%= text_input f, :name %>
        <%= error_tag f, :name %>

        <%= label f, :number %>
        <%= text_input f, :number %>
        <%= error_tag f, :number %>

        <%= submit "Save" %>
      <% end %>
      """
    end

    def mount(_session, socket) do
      if connected?(socket) do
        Phoenix.PubSub.subscribe(LiveTest.PubSub, "topics.things")
      end

      changeset = Validation.change_thing()
      all_things = fetch_all_things()
      {:ok, assign(socket, things: all_things, changeset: changeset)}
    end

    # Events from front end

    def handle_event("new_empty_thing", _payload, socket) do
      new_thing = create_thing()
      notify_subscribers(:create)
      existing_things = socket.assigns[:things]
      all_things = existing_things ++ [new_thing]
      {:noreply, assign(socket, things: all_things)}
    end
    
    def handle_event("delete_thing", thing_id, socket) do
      delete_thing(thing_id)
      notify_subscribers(:delete)
      existing_things = socket.assigns[:things]
      all_things = Enum.reject(existing_things, &(&1.id == thing_id))
      {:noreply, assign(socket, things: all_things)}
    end

    def handle_event("save_new_thing", %{"thing" => params}, socket) do
      case Validation.create_thing(params) do
        {:ok, thing} ->
          notify_subscribers(:save)
          all_things = fetch_all_things()
          changeset = Validation.change_thing()
          {:noreply, assign(socket, things: all_things, changeset: changeset)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end

    def handle_event("validate", %{"thing" => params}, socket) do
      changeset =
        %Thing{}
        |> Thing.changeset(params)
        |> Map.put(:action, :insert)

      {:noreply, assign(socket, changeset: changeset)}
    end

    def handle_event(unhandled_event, payload, socket) do
      IO.inspect unhandled_event, label: "unhandled_event"
      IO.inspect payload, label: "payload"
      {:noreply, socket}
    end

    # PubSub Stuff for cross-user communication

    def handle_info({"topics.things", {:thing, _}}, socket) do
      all_things = fetch_all_things()
      {:noreply, assign(socket, things: all_things)}
    end

    defp notify_subscribers(event) do
      Phoenix.PubSub.broadcast(LiveTest.PubSub, "topics.things", {"topics.things", {:thing, event}})
    end

    # Private things

    defp fetch_all_things() do
      Validation.list_things()
    end

    defp create_thing() do
      {:ok, thing} = Validation.create_thing()
      thing
    end

    defp delete_thing(thing_id) do
      thing = Validation.get_thing(thing_id)
      Validation.delete_thing(thing)
    end
  end
end
