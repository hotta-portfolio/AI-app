document.addEventListener("turbo:load", function () {
  const templateElement = document.getElementById("instruction-template");
  if (!templateElement) return;

  const template = templateElement.innerHTML;
  const container = document.getElementById("instructions");
  const addButton = document.getElementById("add-step");
  let index = Date.now();

  if (addButton) {
    addButton.addEventListener("click", function () {
      const newHtml = template.replace(/NEW_INDEX/g, index);
      container.insertAdjacentHTML("beforeend", newHtml);
      index++;
    });
  }

  container.addEventListener("click", function (e) {
    if (e.target.classList.contains("remove-step")) {
      e.target.closest(".instruction-block").remove();
    }
  });
});
