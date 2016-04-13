defmodule Chat.MessageView do
  use Chat.Web, :view

  def render("message.json", %{message: msg}) do
    %{
      body: msg.body
    }
  end
end
