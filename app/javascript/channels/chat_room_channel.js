// app/javascript/channels/chat_room_channel.js
import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const element = document.getElementById("chat-room")
  if (!element) return

  const roomId = element.dataset.roomId
  const messagesContainer = document.getElementById("messages")

  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  consumer.subscriptions.create(
    { channel: "ChatRoomChannel", room_id: roomId },
    {
      connected() {
        console.log(`Connected to ChatRoomChannel (room_id: ${roomId})`)
      },
      disconnected() {
        console.log("Disconnected from ChatRoomChannel")
      },
      received(data) {
        if (messagesContainer) {
          messagesContainer.insertAdjacentHTML("beforeend", data.message)
          messagesContainer.scrollTop = messagesContainer.scrollHeight
        }
      }
    }
  )

  // フォーム送信後に入力欄をクリア
  const form = document.querySelector("#message_form")
  if (form) {
    form.addEventListener("submit", () => {
      setTimeout(() => {
        const textarea = form.querySelector("textarea")
        if (textarea) textarea.value = ""
      }, 100)
    })
  }
})
