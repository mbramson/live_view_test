defmodule LiveTestWeb.ThingLive do
  defmodule Index do
    use Phoenix.LiveView
    alias LiveTest.Validation
    alias LiveTest.Validation.Thing

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
        </tbody>
      </table>
      <button phx-click="new_thing">New Thing</button>
      """
    end

    def mount(_session, socket) do
      things = Validation.list_things()
      {:ok, assign(socket, things: things)}
    end

    def handle_event("new_thing", payload, socket) do
      existing_things = socket.assigns[:things]
      all_things = case Validation.create_thing(%{}) do
        {:ok, new_thing} ->
          existing_things ++ [new_thing]

        _ -> existing_things
      end
      {:noreply, assign(socket, things: all_things)}
    end
    
    def handle_event("delete_thing", thing_id, socket) do
      existing_things = socket.assigns[:things]
      all_things = case Validation.get_thing(thing_id) do
        %Thing{} = thing ->
          Validation.delete_thing(thing)
          Enum.reject(existing_things, &(&1.id == thing.id))
        _ -> 
          IO.inspect "thing does not exist when trying to delete"
          existing_things
      end
      {:noreply, assign(socket, things: all_things)}
    end

    def handle_event(unhandled_event, payload, socket) do
      IO.inspect unhandled_event, label: "unhandled_event"
      IO.inspect payload, label: "payload"
      {:noreply, socket}
    end
  end
end
