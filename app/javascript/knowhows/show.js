document.addEventListener("DOMContentLoaded", function () {
  window.showMedia = function (index) {
    const mediaElements = document.querySelectorAll(".main-media");

    mediaElements.forEach((el, i) => {
      if (i === index) {
        el.style.display = "";
      } else {
        el.style.display = "none";
      }
    });
  };
});
