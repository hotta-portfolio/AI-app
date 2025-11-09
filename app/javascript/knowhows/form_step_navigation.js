document.addEventListener("turbo:load", () => {
  const step1 = document.getElementById("step-1");
  const step2 = document.getElementById("step-2");
  const goToStep2Btn = document.getElementById("go-to-step-2");
  const backToStep1Btn = document.getElementById("back-to-step-1");
  const mainMediaError = document.getElementById("main-media-error");

  if (!step1 || !step2 || !goToStep2Btn || !backToStep1Btn) return;

  goToStep2Btn.addEventListener("click", () => {
    let valid = true;

    const titleInput = document.querySelector("#knowhow_title");
    const descriptionInput = document.querySelector("#knowhow_description");
    const categorySelect = document.querySelector("#knowhow_category_type");
    const priceInput = document.querySelector("#knowhow_price");
    const thumbnailInputs = document.querySelectorAll(".thumbnail-input");
    const mainInput = document.querySelector("#main-upload-input");

    // エラーリセット
    [titleInput, descriptionInput, categorySelect, priceInput].forEach(input => {
      if (!input) return;
      input.classList.remove("is-invalid");
      const feedback = input.parentNode.querySelector(".invalid-feedback");
      if (feedback) feedback.remove();
    });
    if (mainMediaError) mainMediaError.style.display = "none";

    function showError(input, message) {
      if (!input) return;
      input.classList.add("is-invalid");
      let feedback = input.parentNode.querySelector(".invalid-feedback");
      if (!feedback) {
        feedback = document.createElement("div");
        feedback.classList.add("invalid-feedback");
        input.parentNode.appendChild(feedback);
      }
      feedback.textContent = message;
    }

    // STEP1必須チェック
    if (!titleInput || !titleInput.value.trim()) { showError(titleInput, "タイトルを入力してください"); valid = false; }
    if (!descriptionInput || !descriptionInput.value.trim()) { showError(descriptionInput, "説明を入力してください"); valid = false; }
    if (!categorySelect || !categorySelect.value) { showError(categorySelect, "カテゴリを選択してください"); valid = false; }

    // 価格チェック
    if (priceInput) {
      const priceValue = priceInput.value.trim();
      if (!priceValue || isNaN(priceValue)) { showError(priceInput, "価格を正しく入力してください"); valid = false; }
      else if (Number(priceValue) < 100) { showError(priceInput, "価格は100円以上で入力してください"); valid = false; }
    }

    // メディアチェック
    let mediaCount = 0;

    // 既存メディア（hiddenで残っているもの）をカウント
    document.querySelectorAll("input[name='knowhow[existing_media_file_ids][]']").forEach(input => {
      if (input.value) mediaCount++;
    });

    // 新規アップロード予定メディアをカウント
    if (thumbnailInputs) {
      thumbnailInputs.forEach(input => {
        if (input.files && input.files.length > 0) mediaCount += input.files.length;
      });
    }
    if (mainInput && mainInput.files.length > 0) mediaCount += mainInput.files.length;

    if (mediaCount === 0) {
      if (mainMediaError) mainMediaError.style.display = "block";
      valid = false;
    }

    if (valid) {
      step1.classList.add("d-none");
      step2.classList.remove("d-none");
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  });

  // STEP2の投稿ボタン取得
  const submitBtn = document.querySelector("#step-2 input[type='submit'][value='投稿する']");
  if (submitBtn) {
    submitBtn.addEventListener("click", (e) => {
      let valid = true;
      // エラーリセット
      const existingErrors = document.querySelectorAll(".instruction-error");
      existingErrors.forEach(error => error.remove());

      // 画像inputのチェック
      const imageInputs = document.querySelectorAll("input[type='file'][name^='knowhow[instructions_attributes]'][name$='[image]']");
      imageInputs.forEach((input, _index) => {
        const block = input.closest(".instruction-block");
        if (block && getComputedStyle(block).display !== 'none') {
          const hasExistingImage = block && block.querySelector("img") && block.querySelector("img").src; // 既存画像があるかチェック
          if (!hasExistingImage) {
            showInstructionError(`画像を選択してください`, block);
            valid = false;
          }
        }
      });

      if (!valid) {
        e.preventDefault(); // 送信を阻止
        window.scrollTo({ top: 0, behavior: "smooth" });
      }
    });
  }

  function showInstructionError(message, targetBlock) {
    const errorDiv = document.createElement("div");
    errorDiv.classList.add("alert", "alert-danger", "mt-3", "instruction-error");
    errorDiv.textContent = message;
    targetBlock.appendChild(errorDiv);
  }

  backToStep1Btn.addEventListener("click", () => {
    step2.classList.add("d-none");
    step1.classList.remove("d-none");
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
});
