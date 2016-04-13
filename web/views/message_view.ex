defmodule Chat.MessageView do
  use Chat.Web, :view

  #Renders the collection and returns a struct with just the body
  def render("message.json", %{message: msg}) do
    %{
      body: msg.body
    }
  end
end
