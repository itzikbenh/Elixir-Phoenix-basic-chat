
import {Socket} from "phoenix"

//Ceated an instance of the sockets
let socket = new Socket("/socket")

//connects to socket
socket.connect()

//Picks the channel(topic:subtopic) to be connected to.
let channel      = socket.channel("rooms:lobby")
let chatInput    = $("#chat-input")
let msgContainer = $("#messages")

//On enter if value is not empty it will be pushed to the handle_in function in the server so it
// be stored and broadcasted
chatInput.on("keypress", event => {
  if(event.keyCode === 13 && chatInput.val().length > 0){
    channel.push("new_msg", {body:`Elixir Phoenix: ${chatInput.val()}`})
    chatInput.val("")
  }
})

//On incoming broadcast meesage will be appended to the messages container
channel.on("new_msg", payload => {
  msgContainer.append(`<br/> ${payload.body}`)
})

//Joins channel and on success receives the messages collection and invokes the renderMessages function.
channel.join()
  .receive("ok", resp => {renderMessages(msgContainer, resp.messages) })
  .receive("error", resp => { console.log("Unable to join", resp) })

//Maps over the messages and appends one by one to the messages container
let renderMessages = (msgContainer, messages) => {
  messages.map(message => {
    msgContainer.append(`<br/> ${message.body}`)
  });
}

export default socket
