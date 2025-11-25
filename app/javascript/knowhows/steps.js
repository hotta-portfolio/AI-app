document.addEventListener("turbo:load", function () {
  const templateElement = document.getElementById("instruction-template");
  if (!templateElement) return;

  const template = templateElement.innerHTML;
  const container = document.getElementById("instructions");

  // === STEP番号を「表示中のSTEPだけ」で再計算 ===
  function renumberSteps() {
    const cols = container.querySelectorAll(".col-md-4:not(.d-none)");

    cols.forEach((col, i) => {
      const block = col.querySelector(".instruction-block");
      const newIndex = i;
      const newStep = i + 1;

      // STEPバッジ
      const badge = block.querySelector(".step-badge");
      if (badge) badge.textContent = newStep;

      // hidden step
      const stepInput = block.querySelector("input[name*='[step]']");
      if (stepInput) stepInput.value = newStep;

      // 各 input/textarea の name を書き換え
      col.querySelectorAll("input, textarea").forEach((el) => {
        if (!el.name) return;
        el.name = el.name.replace(
          /\[instructions_attributes\]\[\d+\]/,
          `[instructions_attributes][${newIndex}]`
        );
      });
    });
  }

  // === 追加処理 ===
  container.addEventListener("click", function (e) {
    if (e.target.matches("#add-step, .add-step")) {
      const visibleCols = container.querySelectorAll(".col-md-4:not(.d-none)");
      const index = visibleCols.length;
      const newHtml = template
        .replace(/NEW_INDEX/g, index)
        .replace(/STEP_NUMBER/g, index + 1);

      container.insertAdjacentHTML("beforeend", newHtml);
      renumberSteps();
    }

    // === 削除処理 ===
    if (e.target.classList.contains("remove-step")) {
      const visibleCols = container.querySelectorAll(".col-md-4:not(.d-none)");
      if (visibleCols.length <= 1) return;

      const block = e.target.closest(".instruction-block");
      if (!block) return;

      const col = block.closest(".col-md-4");

      const destroyInput = col.querySelector("input[name*='_destroy']");
      if (destroyInput) destroyInput.value = "1";

      col.classList.add("d-none");
      renumberSteps();
    }
  });

  // === 初期ロード時 ===
  renumberSteps();
});
