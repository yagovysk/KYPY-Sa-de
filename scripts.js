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

  // Modal: Outra clínica (Barreiras, BA)
  const openClinicBtn = document.getElementById("open-clinic-modal");
  const clinicModal = document.getElementById("clinic-modal");
  const clinicVideo = document.getElementById("clinic-video");
  const modalCloseBtn = clinicModal?.querySelector(".modal-close");
  const modalBackdrop = clinicModal?.querySelector(".modal-backdrop");

  const openModal = (modal) => {
    if (!modal) return;
    modal.setAttribute("aria-hidden", "false");
    // focus first focusable element
    modal.querySelector(".modal-close")?.focus();
  };
  const closeModal = (modal) => {
    if (!modal) return;
    modal.setAttribute("aria-hidden", "true");
    // pause video when closing
    if (clinicVideo && !clinicVideo.paused) clinicVideo.pause();
    openClinicBtn?.focus();
  };

  openClinicBtn?.addEventListener("click", (e) => {
    e.preventDefault();
    openModal(clinicModal);
  });
  modalCloseBtn?.addEventListener("click", () => closeModal(clinicModal));
  modalBackdrop?.addEventListener("click", () => closeModal(clinicModal));
  document.addEventListener("keydown", (e) => {
    if (
      e.key === "Escape" &&
      clinicModal?.getAttribute("aria-hidden") === "false"
    ) {
      closeModal(clinicModal);
    }
  });

  // ========== Menu de Acessibilidade ==========
  const accessibilityToggle = document.getElementById("accessibility-toggle");
  const accessibilityPanel = document.getElementById("accessibility-panel");
  const accessibilityClose = document.getElementById("accessibility-close");

  let fontSizeLevel = 0; // -1, 0, 1, 2
  let spacingActive = false;
  let themeMode = "light"; // light, dark, high-contrast

  // Função para salvar preferências no localStorage
  const savePreferences = () => {
    const prefs = {
      fontSizeLevel,
      spacingActive,
      themeMode,
      readableFont: document.getElementById("readable-font")?.checked || false,
      highlightLinks:
        document.getElementById("highlight-links")?.checked || false,
      focusIndicator:
        document.getElementById("focus-indicator")?.checked || false,
    };
    localStorage.setItem("accessibility-prefs", JSON.stringify(prefs));
  };

  // Função para carregar preferências do localStorage
  const loadPreferences = () => {
    const saved = localStorage.getItem("accessibility-prefs");
    if (!saved) return;

    try {
      const prefs = JSON.parse(saved);
      fontSizeLevel = prefs.fontSizeLevel || 0;
      spacingActive = prefs.spacingActive || false;
      themeMode = prefs.themeMode || "light";

      applyFontSize();
      if (spacingActive) document.body.classList.add("line-spacing-increase");
      applyTheme();

      if (prefs.readableFont) {
        document.getElementById("readable-font").checked = true;
        document.body.classList.add("readable-font");
      }
      if (prefs.highlightLinks) {
        document.getElementById("highlight-links").checked = true;
        document.body.classList.add("highlight-links");
      }
      if (prefs.focusIndicator) {
        document.getElementById("focus-indicator").checked = true;
        document.body.classList.add("focus-indicator");
      }
    } catch (e) {
      console.warn("Erro ao carregar preferências de acessibilidade", e);
    }
  };

  const openAccessibilityPanel = () => {
    accessibilityPanel?.setAttribute("aria-hidden", "false");
    accessibilityToggle?.classList.add("active");
    accessibilityClose?.focus();
  };

  const closeAccessibilityPanel = () => {
    accessibilityPanel?.setAttribute("aria-hidden", "true");
    accessibilityToggle?.classList.remove("active");
    accessibilityToggle?.focus();
  };

  const applyFontSize = () => {
    document.body.classList.remove(
      "font-size-increase",
      "font-size-increase-2",
      "font-size-decrease"
    );
    if (fontSizeLevel === 1) document.body.classList.add("font-size-increase");
    else if (fontSizeLevel === 2)
      document.body.classList.add("font-size-increase-2");
    else if (fontSizeLevel === -1)
      document.body.classList.add("font-size-decrease");
  };

  const applyTheme = () => {
    document.body.classList.remove("theme-dark", "theme-high-contrast");
    if (themeMode === "dark") document.body.classList.add("theme-dark");
    else if (themeMode === "high-contrast")
      document.body.classList.add("theme-high-contrast");
  };

  // Abrir/fechar painel
  accessibilityToggle?.addEventListener("click", openAccessibilityPanel);
  accessibilityClose?.addEventListener("click", closeAccessibilityPanel);

  // Fechar ao clicar fora do painel
  document.addEventListener("click", (e) => {
    if (accessibilityPanel?.getAttribute("aria-hidden") === "false") {
      const isClickInside =
        accessibilityPanel.contains(e.target) ||
        accessibilityToggle.contains(e.target);
      if (!isClickInside) {
        closeAccessibilityPanel();
      }
    }
  });

  // Listener para todos os botões de ação
  accessibilityPanel?.addEventListener("click", (e) => {
    const btn = e.target.closest("[data-action]");
    if (!btn) return;

    const action = btn.dataset.action;

    switch (action) {
      case "font-increase":
        if (fontSizeLevel < 2) {
          fontSizeLevel++;
          applyFontSize();
          savePreferences();
        }
        break;
      case "font-decrease":
        if (fontSizeLevel > -1) {
          fontSizeLevel--;
          applyFontSize();
          savePreferences();
        }
        break;
      case "font-reset":
        fontSizeLevel = 0;
        applyFontSize();
        savePreferences();
        break;
      case "spacing-increase":
        spacingActive = true;
        document.body.classList.add("line-spacing-increase");
        savePreferences();
        break;
      case "spacing-reset":
        spacingActive = false;
        document.body.classList.remove("line-spacing-increase");
        savePreferences();
        break;
      case "theme-light":
        themeMode = "light";
        applyTheme();
        savePreferences();
        break;
      case "theme-dark":
        themeMode = "dark";
        applyTheme();
        savePreferences();
        break;
      case "theme-high-contrast":
        themeMode = "high-contrast";
        applyTheme();
        savePreferences();
        break;
      case "reset-all":
        fontSizeLevel = 0;
        spacingActive = false;
        themeMode = "light";
        document.body.className = "";
        document.getElementById("readable-font").checked = false;
        document.getElementById("highlight-links").checked = false;
        document.getElementById("focus-indicator").checked = false;
        localStorage.removeItem("accessibility-prefs");
        break;
    }
  });

  // Checkboxes: Fonte legível, Destacar links, Indicador de foco
  document.getElementById("readable-font")?.addEventListener("change", (e) => {
    if (e.target.checked) document.body.classList.add("readable-font");
    else document.body.classList.remove("readable-font");
    savePreferences();
  });

  document
    .getElementById("highlight-links")
    ?.addEventListener("change", (e) => {
      if (e.target.checked) document.body.classList.add("highlight-links");
      else document.body.classList.remove("highlight-links");
      savePreferences();
    });

  document
    .getElementById("focus-indicator")
    ?.addEventListener("change", (e) => {
      if (e.target.checked) document.body.classList.add("focus-indicator");
      else document.body.classList.remove("focus-indicator");
      savePreferences();
    });

  // Fechar painel com Esc
  document.addEventListener("keydown", (e) => {
    if (
      e.key === "Escape" &&
      accessibilityPanel?.getAttribute("aria-hidden") === "false"
    ) {
      closeAccessibilityPanel();
    }
  });

  // Carregar preferências ao iniciar
  loadPreferences();
});
