import { loadStripe } from "@stripe/stripe-js";

document.addEventListener("DOMContentLoaded", async () => {
  const form = document.getElementById("payment-form");
  if (!form) return;

  const stripe = await loadStripe("pk_test_51RSJ85CiZTWiTlHHr2vJxpJZMJd2HS0s6XAdeq961c9QGKcuPAte4WhNWtnzafdg3IVDrswAAW6BsoW95Ze98oaj00KozsLBsX");

  const elements = stripe.elements();
  const cardElement = elements.create("card");
  cardElement.mount("#card-element");

  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const result = await stripe.createToken(cardElement);

    if (result.error) {
      const errorDiv = document.getElementById("card-errors");
      if (errorDiv) errorDiv.textContent = result.error.message;
    } else {
      const token = result.token.id;

      const hiddenInput = document.createElement("input");
      hiddenInput.setAttribute("type", "hidden");
      hiddenInput.setAttribute("name", "stripe_token");
      hiddenInput.setAttribute("value", token);
      form.appendChild(hiddenInput);

      form.submit();
    }
  });
});
