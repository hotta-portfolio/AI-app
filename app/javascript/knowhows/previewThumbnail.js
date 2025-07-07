document.addEventListener("turbo:load", () => {
  // 左サムネイル
  const thumbnails = document.querySelectorAll(".thumbnail-input");

  thumbnails.forEach((input) => {
    input.addEventListener("change", () => {
      const label = input.closest("label");
      label.innerHTML = ""; // 中身クリア
      previewInElement(input.files[0], label);
    });
  });

  // 右：メイン
  const mainInput = document.getElementById("main-upload-input");
  const mainLabel = document.getElementById("main-upload-label");
  const mainPlaceholder = document.getElementById("main-upload-placeholder");
  const mainPreviewContent = document.getElementById("main-preview-content");

  if (mainInput && mainLabel && mainPreviewContent) {
    mainInput.addEventListener("change", () => {
      const file = mainInput.files[0];
      if (!file) return;

      mainLabel.innerHTML = ""; // ラベル内クリア
      previewInElement(file, mainLabel);

      mainPreviewContent.innerHTML = ""; // 既存があれば削除
    });
  }

  function previewInElement(file, container) {
    const url = URL.createObjectURL(file);
    const type = file.type;

    let el;
    if (type.startsWith("image/")) {
      el = document.createElement("img");
      el.src = url;
      el.style.objectFit = "cover";
      el.style.width = "100%";
      el.style.height = "100%";
      el.className = "rounded";
    } else if (type.startsWith("video/")) {
      el = document.createElement("video");
      el.src = url;
      el.controls = true;
      el.style.width = "100%";
      el.style.height = "100%";
      el.className = "rounded";
    } else if (type.startsWith("audio/")) {
      el = document.createElement("audio");
      el.src = url;
      el.controls = true;
      el.className = "w-100";
    }

    if (el) {
      container.appendChild(el);
    } else {
      container.innerHTML = "<div class='text-muted'>Unsupported format</div>";
    }
  }
});
