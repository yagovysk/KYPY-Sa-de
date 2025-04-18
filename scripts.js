document.addEventListener("DOMContentLoaded", () => {
  const menuToggle = document.querySelector(".menu-toggle");
  const menuClose = document.querySelector(".menu-close");
  const menuContainer = document.querySelector(".menu-container");
  const menuLinks = document.querySelectorAll(".menu a");

  // Verificação preventiva
  if (menuToggle && menuClose && menuContainer) {
    // Abrir o menu
    menuToggle.addEventListener("click", () => {
      menuContainer.classList.add("active");
    });

    // Fechar o menu
    menuClose.addEventListener("click", () => {
      menuContainer.classList.remove("active");
    });

    // Fechar ao clicar em um link do menu
    menuLinks.forEach((link) => {
      link.addEventListener("click", () => {
        menuContainer.classList.remove("active");
      });
    });
  }
});
