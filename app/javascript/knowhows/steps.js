document.addEventListener("turbo:load", function () {
  const templateElement = document.getElementById("instruction-template");
  if (!templateElement) return;

  const template = templateElement.innerHTML;
  const container = document.getElementById("instructions");

  container.addEventListener("click", function (e) {
    if (e.target.matches("#add-step, .add-step")) {
      // 毎回最新のインデックスとステップ数を取得
      const currentBlocks = container.querySelectorAll(".instruction-block");
      const index = currentBlocks.length;
      const stepNumber = index + 1;

      const newHtml = template
        .replace(/NEW_INDEX/g, index)
        .replace(/STEP_NUMBER/g, stepNumber);

      container.insertAdjacentHTML("beforeend", newHtml);
    }

    if (e.target.classList.contains("remove-step")) {
      e.target.closest(".instruction-block")?.remove();
    }
  });
});
