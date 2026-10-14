/* A navegação continua sendo a do bslib/Shiny. Só a abertura dos menus é
   local: não envia inputs, troca abas, remonta módulos ou altera cálculos. */
document.addEventListener("DOMContentLoaded", function () {
  const nav = document.getElementById("main_navbar");
  if (!nav) return;
  const rail = nav.closest(".navbar");
  const toggle = document.getElementById("trilha-toggle-sidebar");
  const path = document.getElementById("trilha-caminho");
  rail.classList.add("trilha-sidebar");
  rail.setAttribute("aria-label", "Navegação principal");
  const menus = Array.from(nav.querySelectorAll(":scope > li.dropdown"));
  const label = (el) => el.textContent.replace(/\s+/g, " ").trim();

  function closeMenus() {
    menus.forEach(function (menu) {
      menu.classList.remove("trilha-open");
      menu.querySelector(":scope > .dropdown-toggle").setAttribute("aria-expanded", "false");
    });
  }

  // Os links originais mantêm data-value, data-bs-target e o input main_navbar.
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

  menus.forEach(function (menu, index) {
    const heading = menu.querySelector(":scope > .dropdown-toggle");
    const submenu = menu.querySelector(":scope > .dropdown-menu");
    heading.querySelectorAll("br").forEach(br => br.replaceWith(" "));
    heading.dataset.trilhaLabel = label(heading);
    heading.setAttribute("role", "button");
    heading.setAttribute("tabindex", "0");
    heading.setAttribute("aria-expanded", "false");
    heading.removeAttribute("data-bs-toggle");
    heading.removeAttribute("data-toggle");
    submenu.id = "trilha-submenu-" + index;
    heading.setAttribute("aria-controls", submenu.id);
    heading.addEventListener("click", function (event) {
      event.preventDefault();
      const open = menu.classList.contains("trilha-open");
      closeMenus();
      if (!open) {
        menu.classList.add("trilha-open");
        heading.setAttribute("aria-expanded", "true");
      }
    });
    heading.addEventListener("keydown", function (event) {
      if (event.key === " ") { event.preventDefault(); heading.click(); }
    });
  });

  // Usa o evento de troca real de aba, inclusive quando Shiny a seleciona.
  $(nav).on("shown.bs.tab", "a[data-bs-toggle='tab']", function () {
    identifyActive(this);
    closeMenus();
    this.closest("li.dropdown")?.querySelector(":scope > .dropdown-toggle").focus();
  });
  nav.addEventListener("click", function (event) {
    const link = event.target.closest("a[data-bs-toggle='tab']");
    if (link) closeMenus(); // também recolhe ao selecionar de novo a aba atual
  });
  rail.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      const heading = rail.querySelector(".trilha-open > .dropdown-toggle");
      closeMenus();
      heading?.focus();
    }
  });
  toggle.addEventListener("click", function () {
    const collapsed = document.body.classList.toggle("trilha-sidebar-collapsed");
    toggle.setAttribute("aria-expanded", String(!collapsed));
    toggle.setAttribute("aria-label", collapsed ? "Mostrar barra lateral" : "Recolher barra lateral");
    // Recalcula o espaço de gráficos e tabelas após a mudança de largura.
    window.dispatchEvent(new Event("resize"));
  });
  const initial = nav.querySelector("a[data-bs-toggle='tab'].active");
  if (initial) identifyActive(initial);
});
