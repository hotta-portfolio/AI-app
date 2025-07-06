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


function previewImage(input) {
  const file = input.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = function (e) {
    const preview = input.closest("label").querySelector(".img-preview");
    preview.src = e.target.result;
    preview.classList.remove("d-none");

    // アイコンを非表示に
    input.closest("label").querySelector(".upload-icon").style.display = "none";
  };
  reader.readAsDataURL(file);
}
