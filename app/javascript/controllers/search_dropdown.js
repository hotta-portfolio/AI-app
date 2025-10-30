document.addEventListener("turbo:load", () => {
  const input = document.getElementById("search-input");
  const dropdown = document.getElementById("search-dropdown");

  const categoryBtn = document.getElementById("btn-category");
  const tagBtn = document.getElementById("btn-tag");
  const priceBtn = document.getElementById("btn-price");

  const categoryForm = document.getElementById("category-form");
  const tagForm = document.getElementById("tag-form");
  const priceForm = document.getElementById("price-form");

  function clearButtons() {
    [categoryBtn, tagBtn, priceBtn].forEach(btn => btn?.classList.remove("active"));
  }

  input?.addEventListener("focus", () => {
    dropdown?.classList.remove("d-none");
  });

  document.addEventListener("click", (e) => {
    if (!document.getElementById("search-form")?.contains(e.target)) {
      dropdown?.classList.add("d-none");
      categoryForm?.classList.add("d-none");
      tagForm?.classList.add("d-none");
      priceForm?.classList.add("d-none");
      clearButtons();
    }
  });

  categoryBtn?.addEventListener("click", () => {
    categoryForm?.classList.toggle("d-none");
    tagForm?.classList.add("d-none");
    priceForm?.classList.add("d-none");
    clearButtons();
    if (!categoryForm.classList.contains("d-none")) categoryBtn.classList.add("active");
  });

  tagBtn?.addEventListener("click", () => {
    tagForm?.classList.toggle("d-none");
    categoryForm?.classList.add("d-none");
    priceForm?.classList.add("d-none");
    clearButtons();
    if (!tagForm.classList.contains("d-none")) tagBtn.classList.add("active");
  });

  priceBtn?.addEventListener("click", () => {
    priceForm?.classList.toggle("d-none");
    categoryForm?.classList.add("d-none");
    tagForm?.classList.add("d-none");
    clearButtons();
    if (!priceForm.classList.contains("d-none")) priceBtn.classList.add("active");
  });
});
