defmodule Chat.RoomChannel do
  use Chat.Web, :channel
  alias Chat.MessageView
  alias Chat.Message

  def join("rooms:lobby", _message, socket) do
    messages = Repo.all(Message)

    resp = %{messages: Phoenix.View.render_many(messages, MessageView, "message.json")}
    {:ok, resp, socket}
  end

  def handle_in("new_msg", params, socket) do
    changeset = Message.changeset(%Message{}, params)
    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast! socket, "new_msg", %{body: message.body}
    end

    {:noreply, socket}
  end
end
