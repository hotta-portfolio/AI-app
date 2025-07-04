  document.addEventListener("turbo:load", function () {
    const templateElement = document.getElementById("instruction-template");
    if (!templateElement) return;

    const template = templateElement.innerHTML;
    const container = document.getElementById("instructions");
    let index = document.querySelectorAll("#instructions .instruction-block").length;

    container.addEventListener("click", function (e) {
      if (e.target.matches("#add-step, .add-step")) {
        const newHtml = template
          .replace(/NEW_INDEX/g, index)
          .replace(/STEP_NUMBER/g, index + 1);
        container.insertAdjacentHTML("beforeend", newHtml);
        index++;
      }
      if (e.target.classList.contains("remove-step")) {
        e.target.closest(".instruction-block")?.remove();
      }
    });
  });
