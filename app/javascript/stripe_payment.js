// Stripeの公式JavaScriptライブラリ@stripe/stripe-jsからloadStripe関数を読み込んでいます。
import { loadStripe } from "@stripe/stripe-js";

// 決済フォームの<form id="payment-form">を取得。
// フォームが存在しなければ何もしません（他ページでは処理しないための安全策）。
document.addEventListener("DOMContentLoaded", async () => {
  const form = document.getElementById("payment-form");
  if (!form) return;

// Railsのビューで埋め込んだ<meta name="stripe-public-key" content="公開鍵">タグを取得。
  const publicKeyMeta = document.querySelector("meta[name='stripe-public-key']");
  const publicKey = publicKeyMeta?.content;

  if (!publicKey) {
    console.error("Stripe public key not found in meta tag.");
    return;
  }

// 取得した公開鍵を使ってStripeオブジェクトを初期化します。
// これによりStripeのAPIと通信できる状態になります。
  const stripe = await loadStripe(publicKey);

//   StripeのUIコンポーネント群（Elements）を作成。
// 「カード情報入力フォーム（card）」を作成し、HTML内の<div id="card-element">に差し込みます。
// このカード入力UIはStripeが管理するので、カード情報は安全に取り扱われます。
  const elements = stripe.elements();
  const cardElement = elements.create("card");
  cardElement.mount("#card-element");

// フォームの送信イベントを監視。
// 送信時にトークンからrailsに送信したいため通常の送信を止めてJavaScriptで制御します。
  form.addEventListener("submit", async (event) => {
    event.preventDefault();

// Stripeにカード情報を送って「トークン」を作成します。
    const result = await stripe.createToken(cardElement);

// トークン作成に失敗した場合、エラーメッセージを画面に表示。
// 成功したらトークンIDを取得。
    if (result.error) {
      const errorDiv = document.getElementById("card-errors");
      if (errorDiv) errorDiv.textContent = result.error.message;
    } else {
      const token = result.token.id;

// フォームに非表示の<input>を動的に追加し、トークンIDをセットします。
      const hiddenInput = document.createElement("input");
      hiddenInput.setAttribute("type", "hidden");
      hiddenInput.setAttribute("name", "stripe_token");
      hiddenInput.setAttribute("value", token);
      form.appendChild(hiddenInput);

      form.submit();
    }
  });
});
