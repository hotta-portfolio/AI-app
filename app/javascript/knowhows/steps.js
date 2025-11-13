document.addEventListener("turbo:load", function () {
  const templateElement = document.getElementById("instruction-template");
  if (!templateElement) return;

  const template = templateElement.innerHTML;
  const container = document.getElementById("instructions");

  // --- 再番号付け: 親の col 要素を基にする ---
  function renumberSteps() {
    const cols = container.querySelectorAll(".col-md-4");
    cols.forEach((col, i) => {
      const block = col.querySelector(".instruction-block");
      const newIndex = i;
      const newStep = i + 1;

      // stepバッジと hidden step 更新
      const badge = block?.querySelector(".step-badge");
      if (badge) badge.textContent = newStep;

      const stepInput = block?.querySelector("input[name*='[step]']");
      if (stepInput) stepInput.value = newStep;

      // 各 input/textarea の name を書き換え
      col.querySelectorAll("input, textarea").forEach((el) => {
        if (!el.name) return;
        // "knowhow[instructions_attributes][###]" の ### を置換
        el.name = el.name.replace(/\[instructions_attributes\]\[\d+\]/, `[instructions_attributes][${newIndex}]`);
      });
    });
  }

  // --- 追加処理（テンプレ挿入後に再番号付け） ---
  container.addEventListener("click", function (e) {
    if (e.target.matches("#add-step, .add-step")) {
      const cols = container.querySelectorAll(".col-md-4");
      const index = cols.length; // 現在の列数を基にする
      const newHtml = template
        .replace(/NEW_INDEX/g, index)
        .replace(/STEP_NUMBER/g, index + 1);

      container.insertAdjacentHTML("beforeend", newHtml);
      renumberSteps();
    }

    // --- 削除処理（親 col を削除） ---
    if (e.target.classList.contains("remove-step")) {
      const visibleCols = container.querySelectorAll(".col-md-4:not(.d-none)");
      if (visibleCols.length <= 1) return; // 一つのみなら削除しない

      const block = e.target.closest(".instruction-block");
      if (!block) return;
      const col = block.closest(".col-md-4") || block.parentElement;

      // Railsの既存レコード向けに _destroy がある場合は値をセット
      const destroyInput = col.querySelector("input[name*='_destroy']");
      if (destroyInput) {
        destroyInput.value = "1";
      }

      // DOMから親のcolを隠す（削除すると _destroy が渡らないため削除が機能しない）
      col.classList.add("d-none");
      renumberSteps();
    }
  });

  // 初期ロード時にもインデックスを整える（既存データがある場合）
  renumberSteps();
});
