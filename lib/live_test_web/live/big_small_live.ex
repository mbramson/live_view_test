defmodule LiveTestWeb.BigSmallLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h2>Bigger or Smaller?</h2>
      <p>
        Current Size: <%= @font_size %> px
      </p>
      <button phx-click="bigger">Bigger</button>
      <button phx-click="smaller">Smaller</button>
      <p style="font-size:<%= @font_size %>px;">WORD</p>
    </div>
    """
  end

  def mount(_session, socket) do
    IO.inspect "mounted!"
    {:ok, assign(socket, font_size: 100)}
  end

  def handle_event("bigger", _payload, socket) do
    assigns = socket.assigns
    IO.inspect "bigger!"
    old_font_size = assigns[:font_size]
    new_font_size = old_font_size * 1.1 |> round
    IO.inspect "Font Size #{old_font_size} -> #{new_font_size}"
    {:noreply, assign(socket, font_size: new_font_size)}
  end
  def handle_event("smaller", _payload, socket) do
    assigns = socket.assigns
    IO.inspect "smaller!"
    old_font_size = assigns[:font_size]
    new_font_size = old_font_size * 0.9 |> round
    IO.inspect "Font Size #{old_font_size} -> #{new_font_size}"
    {:noreply, assign(socket, font_size: new_font_size)}
  end
  def handle_event(other_event, payload, socket) do
    IO.inspect other_event, label: "unhandled_event"
    IO.inspect payload, label: "payload"
    {:noreply, socket}
  end
end
