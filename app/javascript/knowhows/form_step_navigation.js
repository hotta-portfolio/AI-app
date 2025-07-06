document.addEventListener("turbo:load", () => {
  const step1 = document.getElementById("step-1");
  const step2 = document.getElementById("step-2");

  document.getElementById("go-to-step-2")?.addEventListener("click", () => {
    step1.classList.add("d-none");
    step2.classList.remove("d-none");
  });

  document.getElementById("back-to-step-1")?.addEventListener("click", () => {
    step2.classList.add("d-none");
    step1.classList.remove("d-none");
  });
});
