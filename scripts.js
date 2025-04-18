const menuToggle = document.querySelector(".menu-toggle");
const menuContainer = document.querySelector(".menu-container");

menuToggle.addEventListener("click", () => {
  menuContainer.classList.toggle("active"); // Expande ou recolhe o menu
  menuToggle.classList.toggle("active"); // Alterna o estado do ícone
});
