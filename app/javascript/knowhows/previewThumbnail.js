document.addEventListener("turbo:load", function () {
  const container = document.getElementById("media-preview-container");
  const addBtn = document.getElementById("add-media-upload");

  if (!container || !addBtn) return;

  addBtn.addEventListener("click", () => {
    const input = document.createElement("input");
    input.type = "file";
    input.name = "knowhow[media_files][]"; // nameを配列にするのが重要
    input.accept = "image/*,video/*,audio/*";
    input.classList.add("d-none"); // 表示しない
    input.multiple = false;

    // change時のプレビュー追加処理
    input.addEventListener("change", function () {
      const file = this.files[0];
      if (!file) return;

      const previewEl = createPreviewElement(file);
      if (!previewEl) return;

      previewEl.classList.add("position-relative", "rounded");
      previewEl.style.width = "180px";
      previewEl.style.height = "120px";
      previewEl.style.objectFit = "cover";
      previewEl.style.border = "1px solid #ccc";

      const wrapper = document.createElement("div");
      wrapper.classList.add("d-flex", "flex-column", "align-items-center", "gap-1");
      wrapper.appendChild(previewEl);
      wrapper.appendChild(input); // inputも一緒にフォームに残す

      container.appendChild(wrapper);
    });

    input.click(); // ファイル選択を即発火
  });

  function createPreviewElement(file) {
    const url = URL.createObjectURL(file);
    const type = file.type;

    if (type.startsWith("image/")) {
      const img = document.createElement("img");
      img.src = url;
      return img;
    }

    if (type.startsWith("video/")) {
      const video = document.createElement("video");
      video.src = url;
      video.controls = true;
      video.muted = true;
      video.playsInline = true;
      return video;
    }

    if (type.startsWith("audio/")) {
      const audio = document.createElement("audio");
      audio.src = url;
      audio.controls = true;
      audio.style.width = "100%";
      return audio;
    }

    return null;
  }
});
