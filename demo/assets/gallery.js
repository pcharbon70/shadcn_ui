const storageKey = "shadcn-ui-gallery-theme";

const applyTheme = (theme) => {
  if (theme === "light" || theme === "dark") {
    document.documentElement.dataset.shadcnTheme = theme;
  }
};

try { applyTheme(localStorage.getItem(storageKey)); } catch (_error) {}

document.addEventListener("click", async (event) => {
  const theme = event.target.closest("[data-gallery-theme]")?.dataset.galleryTheme;
  if (theme) {
    applyTheme(theme);
    try { localStorage.setItem(storageKey, theme); } catch (_error) {}
    return;
  }

  const copy = event.target.closest("[data-gallery-copy]");
  if (!copy) return;
  const source = document.getElementById(copy.dataset.galleryCopy)?.textContent || "";
  try {
    await navigator.clipboard.writeText(source);
    copy.nextElementSibling.textContent = "Copied";
  } catch (_error) {
    copy.nextElementSibling.textContent = "Select and copy the source below";
  }
});
