document.addEventListener("turbo:load", function () {
  const thumbnailInput = document.querySelector(".thumbnail-input");

  if (thumbnailInput) {
    thumbnailInput.addEventListener("change", function () {
      const file = this.files[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onload = function (e) {
        const label = thumbnailInput.closest("label");
        const preview = label.querySelector(".thumbnail-preview");
        const icon = label.querySelector(".upload-icon");

        preview.src = e.target.result;
        preview.classList.remove("d-none");
        if (icon) icon.classList.add("d-none");
      };
      reader.readAsDataURL(file);
    });
  }
});
