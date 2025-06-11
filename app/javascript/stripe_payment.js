// Stripeの公式JavaScriptライブラリ@stripe/stripe-jsからloadStripe関数を読み込んでいます。
import { loadStripe } from "@stripe/stripe-js";

// 決済フォームの<form id="payment-form">を取得。
document.addEventListener("turbo:load", async () => {
  const form = document.getElementById("payment-form");
  if (!form) return;

// // <meta name="stripe-public-key" content="公開鍵">タグを取得。
  const publicKeyMeta = document.querySelector("meta[name='stripe-public-key']");
  const publicKey = publicKeyMeta?.content;

  if (!publicKey) {
    console.error("Stripe public key not found in meta tag.");
    return;
  }

// 取得した公開鍵を使ってStripeオブジェクトを初期化します。
// これによりStripeのAPIと連携
  const stripe = await loadStripe(publicKey);

//   stripe.elements() を使って、Stripe提供のUIパーツを作れるようにします
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

// トークンをRailsに送るために必要
// 見えない入力欄をJavaScriptで作って
// そこに Stripe からもらった トークン（＝使い捨てのカードID） をセットして
// それをフォームにくっつけて、Railsにフォームを送信している
      const hiddenInput = document.createElement("input");
      hiddenInput.setAttribute("type", "hidden");
      hiddenInput.setAttribute("name", "stripe_token");
      hiddenInput.setAttribute("value", token);
      form.appendChild(hiddenInput);

      form.submit();
    }
  });
});
