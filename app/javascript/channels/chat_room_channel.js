import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const element = document.getElementById("chat-room");

  // チャットルームが存在しないページでは処理を中断
  if (!element) return;

  // data-room-id 属性から room_id を取得
  const roomId = element.dataset.roomId;

  consumer.subscriptions.create(
    { channel: "ChatRoomChannel", room_id: roomId },
    {
      connected() {
        console.log(`Connected to ChatRoomChannel (room_id: ${roomId})`);
      },

      disconnected() {
        console.log("Disconnected from ChatRoomChannel");
      },

      received(data) {
        // メッセージを表示する
        const messagesContainer = document.getElementById("messages");
        if (messagesContainer) {
          messagesContainer.insertAdjacentHTML("beforeend", data.message);
        }
      }
    }
  );
});
