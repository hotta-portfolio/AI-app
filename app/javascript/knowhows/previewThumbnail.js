document.addEventListener("turbo:load", () => {
  // 左サムネイル
  const thumbnails = document.querySelectorAll(".thumbnail-input");

  thumbnails.forEach((input) => {
    input.addEventListener("change", () => {
      const label = input.closest("label");
      if (!label) return;

      // input以外の要素を削除する（input自体は削除しない）
      [...label.children].forEach(child => {
        if (child !== input) child.remove();
      });

      previewInElement(input.files[0], label);
    });
  });

  // メインアップロード
  const mainInput = document.getElementById("main-upload-input");
  const mainLabel = document.getElementById("main-upload-label");
  const mainPlaceholder = document.getElementById("main-upload-placeholder");
  const mainPreviewContent = document.getElementById("main-preview-content");

  if (mainInput && mainLabel && mainPreviewContent) {
    mainInput.addEventListener("change", () => {
      const file = mainInput.files[0];
      if (!file) return;

      // メインラベルの中をクリア（inputは除外）
      [...mainLabel.children].forEach(child => {
        if (child !== mainInput) child.remove();
      });

      previewInElement(file, mainLabel);
      mainPreviewContent.innerHTML = "";
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
