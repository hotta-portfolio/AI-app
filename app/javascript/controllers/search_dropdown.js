document.addEventListener("DOMContentLoaded", () => {
  // 要素の取得
  const input = document.getElementById("search-input");
  const dropdown = document.getElementById("search-dropdown");

  const categoryBtn = document.getElementById("btn-category");
  const tagBtn = document.getElementById("btn-tag");
  const priceBtn = document.getElementById("btn-price");

  const categoryForm = document.getElementById("category-form");
  const tagForm = document.getElementById("tag-form");
  const priceForm = document.getElementById("price-form");

  // 🔍 検索欄にフォーカス → ドロップダウン表示
  input?.addEventListener("focus", () => {
    dropdown?.classList.remove("d-none");
  });

  // ❌ フォーム外をクリック → 閉じる
  document.addEventListener("click", (e) => {
    if (!document.getElementById("search-form")?.contains(e.target)) {
      dropdown?.classList.add("d-none");
      categoryForm?.classList.add("d-none");
      tagForm?.classList.add("d-none");
      priceForm?.classList.add("d-none");
    }
  });

  // 🟦 カテゴリボタンクリック → 切り替え表示
  categoryBtn?.addEventListener("click", () => {
    categoryForm?.classList.toggle("d-none");
    tagForm?.classList.add("d-none");
    priceForm?.classList.add("d-none");
  });

  // 🏷 タグボタンクリック → 切り替え表示
  tagBtn?.addEventListener("click", () => {
    tagForm?.classList.toggle("d-none");
    categoryForm?.classList.add("d-none");
    priceForm?.classList.add("d-none");
  });

  // 💰 価格帯ボタンクリック → 切り替え表示
  priceBtn?.addEventListener("click", () => {
    priceForm?.classList.toggle("d-none");
    categoryForm?.classList.add("d-none");
    tagForm?.classList.add("d-none");
  });
});
