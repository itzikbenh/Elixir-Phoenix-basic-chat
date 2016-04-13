defmodule Chat.RoomChannel do
  use Chat.Web, :channel
  alias Chat.MessageView
  alias Chat.Message

  #Specifies the topic:subtopic to be joined.
  def join("rooms:lobby", _message, socket) do
    #Fetches all messages from the DB
    messages = Repo.all(Message)
    IO.inspect messages

    #passing the messages struct to be rendered as json and to modify what will be showed to the user.
    #In this case it will only show the body.
    resp = %{messages: Phoenix.View.render_many(messages, MessageView, "message.json")}
    IO.inspect resp
    {:ok, resp, socket}
  end

  #handles incoming channel.push events from the client.
  #On successful DB insert it will broadcast the message to the client event.
  #The client will fetch the broadcast through the channel.on event.
  def handle_in("new_msg", params, socket) do
    changeset = Message.changeset(%Message{}, params)
    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast! socket, "new_msg", %{body: message.body}
    end
    #reply or non-reply must be returned
    {:noreply, socket}
  end
end
