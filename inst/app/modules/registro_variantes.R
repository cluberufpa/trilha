# Registro de variantes de delineamento — Trilha.
# Cada módulo de planejamento guarda o que todos os seus desenhos têm em comum;
# a variante (sub-delineamento) escolhida na aba Tipo decide quais campos
# aparecem, quais análises o desenho comporta e o que vai para a ficha.
# Crescer = acrescentar uma entrada numa função variantes_*(); nada mais muda.
# Plano e decisões: docs/PLANO_VARIANTES.md.
#
# Contrato de uma variante (uma lista com estes campos):
#   rotulo    texto do dropdown
#   guia      uma linha que aparece abaixo do dropdown
#   campos    nomes dos campos opcionais do formulário que a variante mostra
#   esquema   SVG do mini-desenho (texto)
#   analises  lista de análises possíveis: id, rotulo, principal (TRUE/FALSE)

# ---- Impacto ----------------------------------------------------------------

# Mini-desenho: linhas = impacto e referência, colunas = antes e depois.
# Quadro tracejado = o desenho não coleta ali.
esquema_impacto_svg <- function(antes, referencia) {
  quadro <- function(x, y, ativo, preenchimento, borda) {
    sprintf('<rect x="%d" y="%d" width="60" height="26" rx="4" fill="%s" stroke="%s"%s/>',
      x, y, if (ativo) preenchimento else "none", if (ativo) borda else "#9fb3bf",
      if (ativo) "" else ' stroke-dasharray="3 3"')
  }
  rotulo <- function(x, y, texto, cor) {
    sprintf('<text x="%d" y="%d" font-size="11" text-anchor="middle" fill="%s">%s</text>', x, y, cor, texto)
  }
  paste0(
    '<svg viewBox="0 0 150 90" width="150" height="90" role="img" aria-label="Esquema do desenho">',
    rotulo(30, 14, "antes", "#5f6b73"), rotulo(115, 14, "depois", "#5f6b73"),
    quadro(0, 20, antes, "#FCE5DE", "#E76F51"), quadro(85, 20, TRUE, "#FCE5DE", "#E76F51"),
    quadro(0, 52, antes && referencia, "#DDEFF0", "#2E7D8F"),
    quadro(85, 52, referencia, "#DDEFF0", "#2E7D8F"),
    if (antes) rotulo(30, 37, "impacto", "#8a3a24"), rotulo(115, 37, "impacto", "#8a3a24"),
    if (antes && referencia) rotulo(30, 69, "referência", "#0F3B5F"),
    if (referencia) rotulo(115, 69, "referência", "#0F3B5F"),
    "</svg>")
}

analise_prevista <- function(id, rotulo, principal = FALSE) {
  list(id = id, rotulo = rotulo, principal = principal)
}

variantes_impacto <- function() {
  list(
    ci = list(
      rotulo = "CI · Controle–Impacto",
      guia = "Compara sítios afetados e de referência, só depois da mudança.",
      campos = c("condicao", "referencia"),
      esquema = esquema_impacto_svg(antes = FALSE, referencia = TRUE),
      analises = list(
        analise_prevista("teste_t_independente", "teste t de duas amostras (média de cada sítio)", TRUE),
        analise_prevista("mann_whitney", "Mann-Whitney"),
        analise_prevista("modelo_misto_sitio", "modelo misto, com o sítio como efeito aleatório"))
    ),
    ba = list(
      rotulo = "BA · Antes–Depois",
      guia = "Compara o mesmo sítio antes e depois da mudança.",
      campos = "antes",
      esquema = esquema_impacto_svg(antes = TRUE, referencia = FALSE),
      analises = list(
        analise_prevista("teste_t_pareado", "teste t pareado", TRUE),
        analise_prevista("wilcoxon_pareado", "Wilcoxon pareado"),
        analise_prevista("modelo_misto_sitio", "modelo misto, com o sítio como efeito aleatório"))
    ),
    baci = list(
      rotulo = "BACI · Antes–Depois com referência",
      guia = "Compara a mudança do sítio afetado com a de sítios de referência.",
      campos = c("condicao", "referencia", "antes"),
      esquema = esquema_impacto_svg(antes = TRUE, referencia = TRUE),
      analises = list(
        analise_prevista("anova_dois_fatores", "ANOVA de dois fatores com interação (período × condição)", TRUE),
        analise_prevista("t_diferenca_baci", "teste t da diferença (depois − antes) entre impacto e referência"),
        analise_prevista("modelo_misto_sitio", "modelo misto, com o sítio como efeito aleatório"))
    )
  )
}

# ---- Leitura do registro ----------------------------------------------------

# Ids das análises marcadas de saída (as principais) de uma variante.
variante_analises_principais <- function(variantes, escolhida) {
  analises <- variantes[[escolhida]]$analises
  vapply(Filter(function(a) isTRUE(a$principal), analises), function(a) a$id, character(1))
}

# Condição JavaScript para um conditionalPanel: o campo aparece quando a
# variante escolhida o declara em `campos`.
variante_condicao_js <- function(ns, id_input, variantes, campo) {
  mostram <- names(Filter(function(v) campo %in% v$campos, variantes))
  if (!length(mostram)) return("false")
  sprintf("[%s].indexOf(input['%s']) >= 0",
    paste0("'", mostram, "'", collapse = ", "), ns(id_input))
}

# ---- Componente de tela: o dropdown de destaque ------------------------------

# Cartão de seleção: "Qual é o seu desenho?", uma linha de texto, o
# esquema e as caixas das análises previstas. As saídas são montadas pelo
# servidor (variante_seletor_server), com ids fixos no namespace do módulo.
variante_seletor_ui <- function(ns, id_input, titulo_modulo, variantes, selecionada) {
  shiny::div(class = "obs-variante",
    shiny::div(class = "obs-variante-modulo", titulo_modulo),
    shiny::div(class = "obs-variante-linha",
      shiny::tags$label(class = "obs-variante-pergunta", `for` = ns(id_input), "Qual é o seu desenho?"),
      shiny::selectInput(ns(id_input), NULL,
        choices = stats::setNames(names(variantes), vapply(variantes, function(v) v$rotulo, character(1))),
        selected = selecionada, width = "100%", selectize = FALSE)),
    shiny::uiOutput(ns("variante_guia")),
    shiny::div(class = "obs-variante-detalhe",
      shiny::uiOutput(ns("variante_esquema")),
      shiny::div(
        shiny::div(class = "obs-variante-legenda", "Análises possíveis (marque as que pretende fazer)"),
        shiny::uiOutput(ns("variante_analises")))))
}

variante_css <- function() "
  .obs-variante { background: #ffffff; border: 1px solid #dbe5e8; border-radius: 12px;
    padding: 12px 16px; margin-bottom: 12px; }
  .obs-variante-modulo { font-size: 0.8rem; color: #5f6b73; margin-bottom: 4px; }
  .obs-variante-linha { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .obs-variante-pergunta { font-size: 1.05rem; font-weight: 700; color: #0F3B5F; margin: 0; }
  .obs-variante-linha .shiny-input-container { flex: 1 1 240px; min-width: 0; margin: 0; width: 100%; }
  .obs-variante-linha select { font-size: 1rem; font-weight: 600; color: #0F3B5F;
    border: 2px solid #2E7D8F; border-radius: 8px; padding: 6px 10px; }
  .obs-variante-guia { margin: 8px 0 0; color: #3d4b53; font-size: 0.92rem; }
  .obs-variante-detalhe { display: grid; grid-template-columns: 150px minmax(0, 1fr); gap: 16px;
    margin-top: 10px; padding-top: 10px; border-top: 1px solid #dbe5e8; align-items: start; }
  .obs-variante-legenda { font-size: 0.8rem; color: #5f6b73; margin-bottom: 2px; }
  .obs-variante-detalhe > * { min-width: 0; }
  /* As análises acompanham a largura da coluna e preservam o texto completo. */
  .obs-variante-analises .shiny-input-container { margin-bottom: 0; width: 100%; max-width: none; }
  .obs-variante-analises .checkbox { margin: 2px 0; }
  .obs-variante-analises label { font-size: 0.82rem; color: #3d4b53; white-space: normal; overflow-wrap: anywhere; }
  .obs-variante-principal { font-size: 0.72rem; padding: 1px 7px; border-radius: 6px;
    background: #d9efe1; color: #1d5c37; margin-left: 4px; }
  @media (max-width: 600px) {
    .obs-variante-detalhe { grid-template-columns: 1fr; }
    .obs-variante-analises label { white-space: normal; }
  }
"

# Servidor do componente. Define as saídas do cartão e devolve duas funções
# reativas: a variante escolhida e as análises previstas (marcadas).
# Ao trocar de variante, as caixas voltam às análises principais.
variante_seletor_server <- function(input, output, ns, variantes, id_input, padrao) {
  escolhida <- shiny::reactive({
    v <- input[[id_input]]
    if (is.null(v) || !length(v) || !v %in% names(variantes)) padrao else v
  })
  manual <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$analises_previstas, {
    manual(list(variante = shiny::isolate(escolhida()),
      valores = as.character(input$analises_previstas)))
  }, ignoreNULL = FALSE, ignoreInit = TRUE)
  previstas <- shiny::reactive({
    m <- manual()
    v <- escolhida()
    if (!is.null(m) && identical(m$variante, v)) m$valores else variante_analises_principais(variantes, v)
  })

  output$variante_guia <- shiny::renderUI(shiny::p(class = "obs-variante-guia", variantes[[escolhida()]]$guia))
  output$variante_esquema <- shiny::renderUI(shiny::HTML(variantes[[escolhida()]]$esquema))
  output$variante_analises <- shiny::renderUI({
    v <- variantes[[escolhida()]]
    ids <- vapply(v$analises, function(a) a$id, character(1))
    nomes <- lapply(v$analises, function(a) shiny::tagList(a$rotulo,
      if (isTRUE(a$principal)) shiny::span(class = "obs-variante-principal", "principal")))
    shiny::div(class = "obs-variante-analises",
      shiny::checkboxGroupInput(ns("analises_previstas"), NULL,
        choiceNames = nomes, choiceValues = ids,
        selected = variante_analises_principais(variantes, escolhida())))
  })
  list(escolhida = escolhida, previstas = previstas)
}
