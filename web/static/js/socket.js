
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel      = socket.channel("rooms:lobby", {})
let chatInput    = $("#chat-input")
let msgContainer = $("#messages")

chatInput.on("keypress", event => {
  if(event.keyCode === 13 && chatInput.val().length > 0){
    channel.push("new_msg", {body:`Elixir Phoenix: ${chatInput.val()}`})
    chatInput.val("")
  }
})

channel.on("new_msg", payload => {
  msgContainer.append(`<br/> ${payload.body}`)
})

channel.join()
  .receive("ok", resp => {renderMessages(msgContainer, resp.messages) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let renderMessages = (msgContainer, messages) => {
  messages.map(message => {
    msgContainer.append(`<br/> ${message.body}`)
  });
}

export default socket
