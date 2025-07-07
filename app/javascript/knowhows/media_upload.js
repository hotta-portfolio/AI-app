document.addEventListener("turbo:load", function () {
  const container = document.getElementById("media-upload-container");
  const addButton = document.getElementById("add-media-upload");

  if (!container || !addButton) return;

  addButton.addEventListener("click", function () {
    const lastBlock = container.querySelector(".media-upload-block");
    if (!lastBlock) return;

    const newBlock = lastBlock.cloneNode(true);

    // ファイル入力リセット
    const fileInput = newBlock.querySelector("input[type='file']");
    if (fileInput) fileInput.value = "";

    // プレビュー非表示に戻す
    const preview = newBlock.querySelector(".media-preview-placeholder");
    if (preview) preview.classList.add("d-none");

    container.appendChild(newBlock);
  });
});
