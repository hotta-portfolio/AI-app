// app/javascript/channels/chat_room_channel.js
import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const chatRoomElement = document.getElementById("chat-room")
  if (!chatRoomElement) return

  const roomId = chatRoomElement.dataset.roomId
  const messagesContainer = document.getElementById("messages")
  const form = document.querySelector("#message_form")

  // 初期表示で一番下までスクロール
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  // スクロール関数
  const scrollToBottom = () => {
    if (!messagesContainer) return
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  // ActionCable 購読
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
        if (!messagesContainer) return

        // メッセージを追加
        messagesContainer.insertAdjacentHTML("beforeend", data.message)

        // 最新メッセージまでスクロール
        scrollToBottom()
      }
    }
  )

  // フォーム送信
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault()
      const textarea = form.querySelector("textarea")
      if (!textarea || textarea.value.trim() === "") return

      // fetchで非同期送信
      fetch(form.action, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
          "Accept": "application/json"
        },
        body: new FormData(form)
      })
      .then(() => {
        textarea.value = "" // 送信後クリア
        // DOM 挿入は ActionCable に任せる
      })
      .catch(err => console.error("Message send error:", err))
    })
  }
})
