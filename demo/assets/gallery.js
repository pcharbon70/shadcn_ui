const storageKey = "shadcn-ui-gallery-theme";

const applyTheme = (theme) => {
  if (theme === "light" || theme === "dark") {
    document.documentElement.dataset.shadcnTheme = theme;
    document.querySelectorAll("[data-gallery-theme]").forEach(button => {
      button.setAttribute("aria-pressed", String(button.dataset.galleryTheme === theme));
    });
    document.querySelectorAll("[data-gallery-preference]").forEach(link => {
      link.href = theme === "dark" ? link.dataset.galleryDarkHref : link.dataset.galleryLightHref;
    });
  }
};

// An explicit server/static preference beats remembered demo-only state.
const explicitTheme = new URLSearchParams(location.search).has("theme") ||
  /\/(?:_preferences|_themes)\/(?:light|dark|invalid)\//.test(location.pathname);
try {
  applyTheme(explicitTheme ? document.documentElement.dataset.shadcnTheme : localStorage.getItem(storageKey));
} catch (_error) {}

const normalizeSearch = (value) => value
  .slice(0, 200)
  .normalize("NFD")
  .replace(/\p{Mark}/gu, "")
  .toLocaleLowerCase()
  .replace(/[^\p{Letter}\p{Number}]+/gu, " ")
  .trim();

for (const scope of document.querySelectorAll("[data-gallery-search-scope]")) {
  const searchInput = scope.querySelector("[data-gallery-search-input]");
  const searchStatus = scope.querySelector("[data-gallery-search-status]");
  const searchItems = [...scope.querySelectorAll("[data-gallery-search-item]")];

  const filterCatalogue = () => {
    const query = normalizeSearch(searchInput?.value || "");
    const visibleRoutes = new Set();
    for (const item of searchItems) {
      const visible = !query || item.dataset.gallerySearchText.includes(query);
      item.hidden = !visible;
      if (visible) visibleRoutes.add(item.dataset.gallerySearchRoute);
    }
    if (searchStatus) {
      const count = visibleRoutes.size;
      searchStatus.textContent = query
        ? `${count} ${count === 1 ? "component" : "components"} found`
        : `${count} components available`;
    }
  };

  searchInput?.addEventListener("input", filterCatalogue);
  scope.querySelector("[data-gallery-search-reset]")?.addEventListener("click", () => {
    searchInput.value = "";
    filterCatalogue();
    searchInput.focus();
  });
  filterCatalogue();
}

const mobileNavigation = document.querySelector("[data-gallery-mobile-navigation]");
const mobileNavigationPanel = document.querySelector("[data-gallery-mobile-navigation-panel]");
const productHeader = document.querySelector("[data-gallery-product-header]");

const fitMobileNavigation = () => {
  if (!mobileNavigation?.open || !mobileNavigationPanel) return;

  const authoredZoom = Number.parseFloat(getComputedStyle(document.documentElement).zoom);
  const zoom = Number.isFinite(authoredZoom) && authoredZoom > 0 ? authoredZoom : 1;
  const viewportHeight = window.visualViewport?.height || window.innerHeight;
  const panelTop = mobileNavigationPanel.getBoundingClientRect().top;
  const availableBlockSize = Math.max(0, (viewportHeight - panelTop) / zoom);

  mobileNavigationPanel.style.setProperty(
    "--gallery-mobile-navigation-available",
    `${availableBlockSize}px`
  );
};

const queueMobileNavigationFit = () => requestAnimationFrame(fitMobileNavigation);

mobileNavigation?.addEventListener("toggle", queueMobileNavigationFit);
window.addEventListener("resize", queueMobileNavigationFit);
window.visualViewport?.addEventListener("resize", queueMobileNavigationFit);
if (productHeader && "ResizeObserver" in window) {
  new ResizeObserver(queueMobileNavigationFit).observe(productHeader);
}

const specimenViews = new Map();
for (const specimen of document.querySelectorAll("[data-gallery-specimen]")) {
  const preview = specimen.querySelector("[data-gallery-specimen-preview]");
  const source = specimen.querySelector("[data-gallery-specimen-source]");
  const previewRadio = specimen.querySelector('input[type="radio"][value="preview"]');
  const codeRadio = specimen.querySelector('input[type="radio"][value="code"]');

  if (preview?.id && previewRadio) {
    specimenViews.set(preview.id, {panel: preview, radio: previewRadio, specimen});
  }
  if (source?.id && codeRadio) {
    specimenViews.set(source.id, {panel: source, radio: codeRadio, specimen});
  }
}

const fragmentIdentity = () => {
  if (!location.hash) return "";
  try {
    return decodeURIComponent(location.hash.slice(1));
  } catch (_error) {
    return "";
  }
};

const synchronizeSpecimenFragment = () => {
  const view = specimenViews.get(fragmentIdentity());
  if (view) view.radio.checked = true;
};

window.addEventListener("hashchange", synchronizeSpecimenFragment);
synchronizeSpecimenFragment();

document.addEventListener("change", (event) => {
  const radio = event.target.closest?.('[data-gallery-specimen] input[type="radio"]');
  if (!radio?.checked) return;

  const currentView = specimenViews.get(fragmentIdentity());
  if (!currentView || currentView.specimen !== radio.closest("[data-gallery-specimen]")) return;

  const selectedView = [...specimenViews.values()].find(view => view.radio === radio);
  if (!selectedView || selectedView === currentView) return;

  const url = new URL(location.href);
  url.hash = selectedView.panel.id;
  history.replaceState(history.state, "", url);
});

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
