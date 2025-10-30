document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (e) {
    if (!e.target.matches('input[type="file"][onchange*="previewImage"]')) return;

    const input = e.target;
    const file = input.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (e) {
      const label = input.closest("label");
      const preview = label.querySelector(".img-preview");
      const icon = label.querySelector(".upload-icon");

      preview.src = e.target.result;
      preview.classList.remove("d-none");
      if (icon) icon.style.display = "none";
    };
    reader.readAsDataURL(file);
  });
});
