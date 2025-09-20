document.addEventListener("DOMContentLoaded", () => {
  const menuToggle = document.querySelector(".menu-toggle");
  const menuClose = document.querySelector(".menu-close");
  const menuContainer = document.getElementById("menu-container");
  const menuLinks = document.querySelectorAll(".menu a");

  const openMenu = () => {
    menuContainer.classList.add("active");
  };

  const closeMenu = () => {
    menuContainer.classList.remove("active");
  };

  // Abertura do menu pelo botão ☰
  menuToggle?.addEventListener("click", openMenu);

  // Fechamento do menu pelo botão ✕
  menuClose?.addEventListener("click", closeMenu);

  // Fechar ao clicar em qualquer item do menu
  menuLinks.forEach((link) => {
    link.addEventListener("click", closeMenu);
  });

  // 👇 Scroll reveal animation (vai e volta)
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("show");
        } else {
          entry.target.classList.remove("show");
        }
      });
    },
    {
      threshold: 0.1,
    }
  );

  document.querySelectorAll(".scroll-reveal").forEach((el) => {
    observer.observe(el);
  });

  // Scroll to top button
  const scrollUpBtn = document.getElementById("scroll-up");
  const toggleScrollUp = () => {
    if (!scrollUpBtn) return;
    const y = window.scrollY || document.documentElement.scrollTop;
    if (y > 300) {
      scrollUpBtn.classList.add("show");
    } else {
      scrollUpBtn.classList.remove("show");
    }
  };

  window.addEventListener("scroll", toggleScrollUp, { passive: true });
  toggleScrollUp();

  scrollUpBtn?.addEventListener("click", (e) => {
    e.preventDefault();
    window.scrollTo({ top: 0, behavior: "smooth" });
  });

  // Sound toggle for hero video
  const heroVideo = document.querySelector(".video-background");
  const soundToggle = document.getElementById("sound-toggle");
  soundToggle?.addEventListener("click", async () => {
    if (!heroVideo) return;
    try {
      if (heroVideo.muted) {
        heroVideo.muted = false;
        // Some browsers require a play() call after unmuting
        await heroVideo.play();
        soundToggle.textContent = "🔊";
        soundToggle.setAttribute("aria-label", "Desativar áudio do vídeo");
      } else {
        heroVideo.muted = true;
        soundToggle.textContent = "🔇";
        soundToggle.setAttribute("aria-label", "Ativar áudio do vídeo");
      }
    } catch (e) {
      // Fallback: if play() fails, keep muted and inform via icon
      heroVideo.muted = true;
      soundToggle.textContent = "🔇";
    }
  });
});
