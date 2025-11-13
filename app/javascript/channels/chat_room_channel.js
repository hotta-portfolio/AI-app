import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const element = document.getElementById("chat-room");

  // チャットルームが存在しないページでは処理を中断
  if (!element) return;

  // data-room-id 属性から room_id を取得
  const roomId = element.dataset.roomId;
  const messagesContainer = document.getElementById("messages");

  // ✅ ページ読み込み時に一番下までスクロール
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }

  // ✅ ActionCable購読
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
        // メッセージを追加
        if (messagesContainer) {
          messagesContainer.insertAdjacentHTML("beforeend", data.message);

          // ✅ 新しいメッセージが届いたら自動で下までスクロール
          messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
      }
    }
  );

  // ✅ フォーム送信後に入力欄をクリア
  const form = document.querySelector("#message_form");
  if (form) {
    form.addEventListener("submit", () => {
      setTimeout(() => {
        const textarea = form.querySelector("textarea");
        if (textarea) textarea.value = "";
      }, 100); // ActionCable送信後に少し待ってからクリア
    });
  }
});
