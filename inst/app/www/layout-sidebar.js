/* O flyout apresenta atalhos para os links originais do bslib. Os painéis,
   bindings Shiny e servidores dos módulos permanecem montados no lugar. */
function trilhaFlyoutBounds(railRight, anchorTop, viewportWidth, viewportHeight, panelHeight, preferredWidth = 348) {
  const left = Math.max(0, Math.ceil(railRight)) + 8;
  const width = Math.max(0, Math.min(preferredWidth, viewportWidth - left - 8));
  const maxHeight = Math.max(0, viewportHeight - 16);
  const top = Math.max(8, Math.min(anchorTop, viewportHeight - Math.min(panelHeight, maxHeight) - 8));
  return { left, top, width, maxHeight };
}
if (typeof module !== "undefined" && module.exports) module.exports = { trilhaFlyoutBounds };

if (typeof document !== "undefined") document.addEventListener("DOMContentLoaded", function () {
  const nav = document.getElementById("main_navbar");
  if (!nav) return;
  const rail = nav.closest(".navbar");
  const toggle = document.getElementById("trilha-toggle-sidebar");
  const path = document.getElementById("trilha-caminho");
  rail.classList.add("trilha-sidebar");
  rail.setAttribute("aria-label", "Navegação principal");
  const menus = Array.from(nav.querySelectorAll(":scope > li.dropdown"));
  const label = el => el.textContent.replace(/\s+/g, " ").trim();
  const normalize = text => text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLocaleLowerCase("pt-BR");
  let opened = null;
  let preferredPanelWidth = 260;

  // Fora da navbar: position:fixed não fica preso ao overflow da barra.
  const panel = document.createElement("section");
  panel.id = "trilha-flyout";
  panel.className = "trilha-flyout";
  panel.hidden = true;
  panel.setAttribute("role", "dialog");
  panel.setAttribute("aria-modal", "false");
  panel.setAttribute("aria-labelledby", "trilha-flyout-title");
  const header = document.createElement("div");
  header.className = "trilha-flyout-header";
  const title = document.createElement("h2");
  title.id = "trilha-flyout-title";
  const close = document.createElement("button");
  close.type = "button";
  close.className = "trilha-flyout-close";
  close.setAttribute("aria-label", "Fechar submenu");
  close.textContent = "×";
  const search = document.createElement("input");
  search.type = "search";
  search.className = "trilha-flyout-search";
  search.placeholder = "Buscar módulo…";
  search.setAttribute("aria-label", "Buscar módulo neste menu");
  // Sem id ou classe de binding: a busca é local, sem input reativo Shiny.
  const list = document.createElement("ul");
  list.className = "trilha-flyout-list";
  const empty = document.createElement("p");
  empty.className = "trilha-flyout-empty";
  empty.setAttribute("role", "status");
  empty.textContent = "Nenhum módulo encontrado.";
  empty.hidden = true;
  const footer = document.createElement("div");
  footer.className = "trilha-flyout-footer";
  footer.textContent = "Esc para fechar";
  header.append(title, close, search);
  panel.append(header, list, empty, footer);
  document.body.appendChild(panel);

  // Mede os nomes com as fontes efetivamente carregadas, sem abreviação.
  function textWidth(text, element, weight) {
    const style = getComputedStyle(element);
    const probe = document.createElement("span");
    probe.setAttribute("aria-hidden", "true");
    probe.style.cssText = "position:fixed;visibility:hidden;white-space:nowrap;width:max-content;pointer-events:none";
    probe.style.fontFamily = style.fontFamily;
    probe.style.fontSize = style.fontSize;
    probe.style.fontWeight = weight || style.fontWeight;
    probe.style.letterSpacing = style.letterSpacing;
    probe.textContent = text;
    document.body.appendChild(probe);
    const width = probe.getBoundingClientRect().width;
    probe.remove();
    return width;
  }
  function sizeSidebar() {
    const labels = Array.from(nav.querySelectorAll(".trilha-menu-label"));
    if (!labels.length) return;
    const longest = Math.max(...labels.map(el => textWidth(label(el), el, "600")));
    const required = Math.max(300, Math.ceil(longest + 76));
    document.body.style.setProperty("--trilha-rail-content-width", required + "px");
    const available = window.innerWidth <= 600 ? Math.min(required, Math.floor(window.innerWidth * .4)) : required;
    document.body.style.setProperty("--trilha-rail-width", available + "px");
  }
  function sizePanel() {
    const buttons = Array.from(list.querySelectorAll(".trilha-flyout-item"));
    const longest = Math.max(0, ...buttons.map(el => textWidth(label(el), el, "600")));
    const groups = Array.from(list.querySelectorAll(".trilha-flyout-group"));
    const groupWidth = Math.max(0, ...groups.map(el => textWidth(label(el).toLocaleUpperCase("pt-BR"), el)));
    preferredPanelWidth = Math.ceil(Math.max(260, longest + 70, groupWidth + 42, textWidth(title.textContent, title) + 64));
  }
  function positionPanel() {
    if (!opened) return;
    const heading = opened.querySelector(":scope > .dropdown-toggle");
    const rect = heading.getBoundingClientRect();
    const bounds = trilhaFlyoutBounds(rail.getBoundingClientRect().right, rect.top,
      window.innerWidth, window.innerHeight, panel.getBoundingClientRect().height, preferredPanelWidth);
    panel.style.left = bounds.left + "px";
    panel.style.width = bounds.width + "px";
    panel.style.maxHeight = bounds.maxHeight + "px";
    // A nova largura pode mudar a altura das linhas.
    const height = panel.getBoundingClientRect().height;
    panel.style.top = trilhaFlyoutBounds(bounds.left - 8, rect.top,
      window.innerWidth, window.innerHeight, height, preferredPanelWidth).top + "px";
  }

  function closePanel(restoreFocus = false) {
    if (!opened) return;
    const heading = opened.querySelector(":scope > .dropdown-toggle");
    opened.classList.remove("trilha-open");
    heading.setAttribute("aria-expanded", "false");
    opened = null;
    panel.hidden = true;
    if (restoreFocus) heading.focus();
  }

  function identifyActive(link) {
    nav.querySelectorAll("[aria-current]").forEach(el => el.removeAttribute("aria-current"));
    nav.querySelectorAll(".trilha-active-note").forEach(el => el.remove());
    menus.forEach(menu => menu.classList.remove("trilha-active-menu"));
    link.setAttribute("aria-current", "page");
    const menu = link.closest("li.dropdown");
    const parts = ["Trilha"];
    if (menu) {
      menu.classList.add("trilha-active-menu");
      const heading = menu.querySelector(":scope > .dropdown-toggle");
      parts.push(heading.dataset.trilhaLabel);
      const note = document.createElement("span");
      note.className = "trilha-active-note";
      note.textContent = "Em uso: " + label(link);
      heading.appendChild(note);
    }
    parts.push(label(link));
    path.replaceChildren();
    parts.forEach(function (part, index) {
      const span = document.createElement("span");
      span.textContent = part;
      if (index === parts.length - 1) span.setAttribute("aria-current", "page");
      path.appendChild(span);
    });
  }

  function visibleButtons() {
    return Array.from(list.querySelectorAll(".trilha-flyout-item")).filter(button => !button.parentElement.hidden);
  }

  function openPanel(menu) {
    if (opened === menu) { closePanel(true); return; }
    closePanel();
    opened = menu;
    menu.classList.add("trilha-open");
    const heading = menu.querySelector(":scope > .dropdown-toggle");
    heading.setAttribute("aria-expanded", "true");
    title.textContent = heading.dataset.trilhaLabel;
    search.value = "";
    search.hidden = menu.querySelectorAll(".dropdown-menu a[data-bs-toggle='tab']").length < 8;
    empty.hidden = true;
    list.replaceChildren();
    Array.from(menu.querySelector(":scope > .dropdown-menu").children).forEach(function (item) {
      const link = item.querySelector("a[data-bs-toggle='tab']");
      const group = item.querySelector(".dropdown-header");
      const row = document.createElement("li");
      if (group) {
        row.className = "trilha-flyout-group";
        row.textContent = label(group);
      } else if (link) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "trilha-flyout-item";
        button.dataset.search = normalize(label(link));
        if (link.classList.contains("active")) {
          button.classList.add("active");
          button.setAttribute("aria-current", "page");
        }
        const icon = link.querySelector("i");
        if (icon) {
          const copy = icon.cloneNode(true);
          copy.setAttribute("aria-hidden", "true");
          copy.removeAttribute("aria-label");
          button.appendChild(copy);
        }
        const text = document.createElement("span");
        text.textContent = label(link);
        button.appendChild(text);
        button.addEventListener("click", function () {
          // O clique original mantém a seleção e os bindings nativos do Shiny.
          link.click();
          closePanel(true); // inclui seleção repetida da aba já ativa
          heading.focus({ preventScroll: true });
        });
        row.appendChild(button);
      } else return;
      list.appendChild(row);
    });
    sizePanel();
    panel.hidden = false;
    list.scrollTop = 0;
    positionPanel();
    const focus = search.hidden ? (list.querySelector(".active") || visibleButtons()[0] || close) : search;
    focus.focus({ preventScroll: true });
  }

  search.addEventListener("input", function () {
    const query = normalize(search.value.trim());
    let currentGroup = null;
    let matches = 0;
    Array.from(list.children).forEach(function (row) {
      if (row.classList.contains("trilha-flyout-group")) {
        currentGroup = row;
        row.hidden = true;
      } else {
        const found = row.firstElementChild.dataset.search.includes(query);
        row.hidden = !found;
        if (found) { matches++; if (currentGroup) currentGroup.hidden = false; }
      }
    });
    empty.hidden = matches > 0;
    list.scrollTop = 0;
    positionPanel();
  });
  close.addEventListener("click", () => closePanel(true));

  menus.forEach(function (menu) {
    const heading = menu.querySelector(":scope > .dropdown-toggle");
    heading.querySelectorAll("br").forEach(br => br.replaceWith(" "));
    heading.dataset.trilhaLabel = label(heading);
    heading.setAttribute("aria-label", heading.dataset.trilhaLabel);
    heading.setAttribute("title", heading.dataset.trilhaLabel);
    const menuLabel = document.createElement("span");
    menuLabel.className = "trilha-menu-label";
    menuLabel.textContent = heading.dataset.trilhaLabel;
    Array.from(heading.childNodes).filter(node => node.nodeType === 3).forEach(node => node.remove());
    heading.appendChild(menuLabel);
    heading.setAttribute("role", "button");
    heading.setAttribute("tabindex", "0");
    heading.setAttribute("aria-expanded", "false");
    heading.setAttribute("aria-controls", panel.id);
    heading.setAttribute("aria-haspopup", "dialog");
    heading.removeAttribute("data-bs-toggle");
    heading.removeAttribute("data-toggle");
    heading.addEventListener("click", function (event) {
      event.preventDefault();
      openPanel(menu);
    });
    heading.addEventListener("keydown", function (event) {
      if ([" ", "Enter", "ArrowRight", "ArrowDown"].includes(event.key)) {
        event.preventDefault();
        if (opened !== menu || [" ", "Enter"].includes(event.key)) openPanel(menu);
        else (search.hidden ? visibleButtons()[0] || close : search).focus();
      }
    });
  });

  panel.addEventListener("keydown", function (event) {
    const buttons = visibleButtons();
    const current = buttons.indexOf(document.activeElement);
    if (["ArrowDown", "ArrowUp"].includes(event.key) && (current >= 0 || event.target === search)) {
      event.preventDefault();
      const next = current < 0 ? (event.key === "ArrowDown" ? 0 : buttons.length - 1)
        : (current + (event.key === "ArrowDown" ? 1 : -1) + buttons.length) % buttons.length;
      buttons[next]?.focus();
    } else if (current >= 0 && ["Home", "End"].includes(event.key)) {
      event.preventDefault();
      (event.key === "Home" ? buttons[0] : buttons[buttons.length - 1])?.focus();
    }
  });
  document.addEventListener("keydown", function (event) {
    if (opened && event.key === "Escape") {
      event.preventDefault();
      closePanel(true);
    }
  });
  document.addEventListener("pointerdown", function (event) {
    if (opened && !panel.contains(event.target) && !opened.querySelector(":scope > .dropdown-toggle").contains(event.target)) closePanel();
  });
  document.addEventListener("focusin", function (event) {
    if (opened && !panel.contains(event.target) && !rail.contains(event.target)) closePanel();
  });
  // Continua ouvindo a troca real de aba nos links originais, ainda na navbar.
  $(nav).on("shown.bs.tab", "a[data-bs-toggle='tab']", function () {
    identifyActive(this);
    closePanel(true);
  });
  nav.addEventListener("click", function (event) {
    if (event.target.closest("a[data-bs-toggle='tab']")) closePanel();
  });
  toggle.addEventListener("click", function () {
    closePanel();
    const collapsed = document.body.classList.toggle("trilha-sidebar-collapsed");
    toggle.setAttribute("aria-expanded", String(!collapsed));
    toggle.setAttribute("aria-label", collapsed ? "Mostrar barra lateral" : "Recolher barra lateral");
    window.dispatchEvent(new Event("resize"));
  });
  function fitNavigation() { sizeSidebar(); if (opened) { sizePanel(); positionPanel(); } }
  window.addEventListener("resize", fitNavigation);
  document.fonts.ready.then(fitNavigation);
  document.fonts.addEventListener("loadingdone", fitNavigation);
  fitNavigation();
  rail.querySelector(".navbar-collapse").addEventListener("scroll", positionPanel, { passive: true });
  const initial = nav.querySelector("a[data-bs-toggle='tab'].active");
  if (initial) identifyActive(initial);
});