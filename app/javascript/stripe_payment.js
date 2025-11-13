// Stripeの公式JavaScriptライブラリ@stripe/stripe-jsからloadStripe関数を読み込む
import { loadStripe } from "@stripe/stripe-js";

// ページ読み込み時に実行
document.addEventListener("turbo:load", async () => {
  const form = document.getElementById("payment-form");
  if (!form) return; // 決済フォームがなければ処理中止

  // フォームに data-knowhow-id を追加しておくことで JS 側で ID を取得
  const knowhowId = form.dataset.knowhowId;

  // <meta name="stripe-public-key" content="公開鍵"> から公開鍵を取得
  const publicKey = document.querySelector("meta[name='stripe-public-key']")?.content;
  if (!publicKey) return;

  // Stripe オブジェクトを初期化
  const stripe = await loadStripe(publicKey);

  // Stripe Elements を使ってカード入力UIを作成
  // Stripeの管理下で動く「入力部品（iframe）」を作る
  const elements = stripe.elements();
  const cardNumber = elements.create("cardNumber");
  const cardExpiry = elements.create("cardExpiry");
  const cardCvc = elements.create("cardCvc");

  //その入力欄を、あなたのHTMLの中に表示する
  cardNumber.mount("#card-number-element");
  cardExpiry.mount("#card-expiry-element");
  cardCvc.mount("#card-cvc-element");

  // フォーム送信イベントを監視
  form.addEventListener("submit", async (event) => {
    event.preventDefault(); // デフォルト送信を停止

    // ==========================
    // 「このフォームが送信されるはずのURLに対して、JSON形式でPOSTリクエストを送る。
    // Railsにちゃんと自分のサイトから送ったリクエストだと証明するためのトークンも送る。
    // 返ってきた結果を response という変数に入れる。」という意味です。
    // fetch = JSからサーバーにデータを送る魔法の矢
    // await = 結果が返ってくるまで待つ魔法の杖
    // headers = サーバーへのおまじない（JSONで送るよ、これは安全なリクエストだよ）
    // body = 送るデータの中身 
    const response = await fetch(form.action, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({})
    });
    const data = await response.json();
    const clientSecret = data.client_secret;

    // ==========================
    // 2. PaymentIntentを完了（3Dセキュア対応）
    // ==========================
    const { error, paymentIntent } = await stripe.confirmCardPayment(clientSecret, {
      payment_method: { card: cardNumber },
      setup_future_usage: "off_session"
    });

    // ==========================
    // 3. エラー処理
    // ==========================
    if (error) {
      document.getElementById("card-errors").textContent = error.message;
      return;
    }

    // ==========================
    // 4. 決済成功時、Railsに通知して購入レコード作成
    // ==========================
    if (paymentIntent.status === "succeeded") {
      const confirmResponse = await fetch(`/knowhows/${knowhowId}/purchases/confirm`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ payment_intent_id: paymentIntent.id })
      });

      const confirmData = await confirmResponse.json();
      if (confirmData.success) {
        window.location.href = confirmData.redirect_url;
      } else {
        document.getElementById("card-errors").textContent = confirmData.error;
      }
    }
  });
});
