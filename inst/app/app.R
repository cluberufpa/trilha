# IDE_R - Aplicativo Principal Shiny
library(shiny)
library(bslib)
library(ggplot2)
library(DT)
library(readxl)

# Aumenta limite de upload para 50 MB
options(shiny.maxRequestSize = 50 * 1024^2)

# ---- Motor compartilhado (carregar ANTES dos modulos) ----------------------
# Alguns modulos (ex.: mod_exploracao_visual.R) chamam funcoes do motor, como
# cores_ocean(), ja no momento em que sao lidos por source(). Por isso o motor
# precisa estar disponivel aqui, antes do primeiro source() de modulo; caso
# contrario o app falha com "nao foi possivel encontrar a funcao cores_ocean".
if (file.exists(file.path("..", "..", "R", "descrevendo_dados.R"))) {
  # Modo desenvolvimento: runApp("inst/app") a partir da raiz do pacote.
  source(file.path("..", "..", "R", "descrevendo_dados.R"), encoding = "UTF-8")
} else {
  # Modo pacote instalado: traz as funcoes internas direto do namespace trilha.
  funcoes_motor <- c(
    "descricao_catalogo", "descricao_tipo", "exploracao_tipo_variavel",
    "trilha_codigo_descricao", "trilha_descricao", "cores_ocean", "tema_ocean",
    "aplicar_faceta_ocean", "desenhar_distribuicao", "desenhar_barras_ocean",
    "desenhar_caixa_ocean", "desenhar_dispersao_ocean", "resumir_continuas",
    "tabela_frequencia_exploratoria", "exploracao_tipos", "exploracao_base_visual",
    "exploracao_cores", "exploracao_grupo", "exploracao_retratos", "exploracao_mapa_ausentes", "exploracao_saude", "exploracao_normalidade_grupos"
  )
  ns_catalyser <- asNamespace("trilha")
  ausentes_motor <- funcoes_motor[!vapply(
    funcoes_motor, exists, logical(1), envir = ns_catalyser, inherits = FALSE
  )]
  if (length(ausentes_motor)) {
    stop(
      "O aplicativo e o pacote trilha carregado nesta sessão estão incompatíveis. ",
      "Após atualizar o pacote, reinicie o R (no RStudio: Session > Restart R ou Ctrl+Shift+F10) ",
      "e execute trilha::run_app(launch.browser = TRUE) novamente. ",
      "Se o erro persistir numa sessão nova, reinstale o pacote. ",
      "Funções ausentes: ", paste(ausentes_motor, collapse = ", "),
      call. = FALSE
    )
  }
  for (nome in funcoes_motor) {
    assign(nome, getFromNamespace(nome, "trilha"), envir = globalenv())
  }
}

# Carrega os módulos de análise
source("modules/utils_export.R", encoding = "UTF-8")
source("modules/mod_regression.R", encoding = "UTF-8")
source("modules/mod_regressao_contagem.R", encoding = "UTF-8")
source("modules/mod_model_discovery.R", encoding = "UTF-8")
source("modules/mod_nonlinear.R", encoding = "UTF-8")
source("modules/mod_description.R", encoding = "UTF-8")
source("modules/mod_parametric.R", encoding = "UTF-8")
source("modules/ficha_planejamento.R", encoding = "UTF-8")
source("modules/mod_sampling.R", encoding = "UTF-8")
source("modules/mod_anova.R", encoding = "UTF-8")
source("modules/mod_anova_mista.R", encoding = "UTF-8")
source("modules/mod_anova_dois_fatores.R", encoding = "UTF-8")
source("modules/mod_pca.R", encoding = "UTF-8")
source("modules/mod_hca.R", encoding = "UTF-8")
source("modules/mod_experimental_design.R", encoding = "UTF-8")
source("modules/mod_planejamento_variaveis.R", encoding = "UTF-8")
# Este R local falha ao converter alguns arquivos UTF-8 quando o argumento
# encoding é forçado. A limpeza global de codificação permanece separada.
source("modules/mod_planejamento_observacional.R")
source("modules/mod_n_poder.R", encoding = "UTF-8")
source("modules/mod_monitoramento.R", encoding = "UTF-8")
source("modules/mod_conceitos_coleta.R", encoding = "UTF-8")
source("modules/mod_nonparametric.R", encoding = "UTF-8")
source("modules/mod_viz_extra.R", encoding = "UTF-8")
source("modules/mod_exploracao_visual.R", encoding = "UTF-8")
source("modules/mod_mapa.R", encoding = "UTF-8")
source("modules/mod_mapa_pontos.R", encoding = "UTF-8")
source("modules/mod_series_temporais.R", encoding = "UTF-8")
source("modules/mod_arrumar.R", encoding = "UTF-8")
source("modules/mod_organizar_variaveis.R", encoding = "UTF-8")
source("modules/mod_calcular.R", encoding = "UTF-8")
source("modules/mod_agrupar_sumarizar.R", encoding = "UTF-8")
source("modules/registro_tratamentos.R", encoding = "UTF-8")
source("modules/registro_bases.R", encoding = "UTF-8")
source("modules/mod_seletor_base_analise.R", encoding = "UTF-8")
source("modules/registro_execucoes.R", encoding = "UTF-8")
source("modules/registro_comunicacao.R", encoding = "UTF-8")
source("modules/exportacao_comunicacao.R", encoding = "UTF-8")
source("modules/mod_registrar_execucao.R", encoding = "UTF-8")
source("modules/mod_execucao_explicita.R", encoding = "UTF-8")
source("modules/mod_tratar.R", encoding = "UTF-8")
source("modules/mod_preparar_compartilhada.R", encoding = "UTF-8")
source("modules/mod_bases_derivadas.R", encoding = "UTF-8")
source("modules/mod_comunicacao.R", encoding = "UTF-8")
source("modules/mod_correlacao.R", encoding = "UTF-8")
source("modules/mod_laboratorio.R", encoding = "UTF-8")
source("modules/mod_lab_tlc.R", encoding = "UTF-8")
source("modules/mod_lab_anova.R", encoding = "UTF-8")
source("modules/mod_lab_teste_t.R", encoding = "UTF-8")
source("modules/mod_ancova.R", encoding = "UTF-8")
source("modules/mod_descrevendo_dados.R", encoding = "UTF-8")
source("modules/mod_proporcoes.R", encoding = "UTF-8")
source("modules/mod_parametricos_complementares.R", encoding = "UTF-8")
source("modules/mod_pareados_categoricos.R", encoding = "UTF-8")
# Parqueados para a v2 (fora do escopo v1 do menu Mapas — ver mapas.md / BACKLOG):
# source("modules/mod_mapa_densidade.R") # densidade/heatmap de ocorrências
# source("modules/mod_mapa_raster.R")    # raster ambiental isolado

# Funções auxiliares para tipagem de colunas
detect_col_type <- function(col) {
  if (is.factor(col)) return("factor")
  if (is.logical(col)) return("logical")
  if (inherits(col, "Date") || inherits(col, "POSIXt")) return("Date")
  if (is.integer(col)) return("integer")
  if (is.numeric(col)) return("numeric")
  return("character")
}

sanitize_id <- function(x) {
  gsub("[^a-zA-Z0-9_]", "_", x)
}

# ---- Resumo dos Dados (aba do Carregamento) ---------------------------------
# Em vez do summary() cru, a aba mostra uma linha por variável, como o glimpse()
# do R: classe, tipo estatístico, ausentes, valores distintos e os primeiros
# valores. Clicar numa linha abre a distribuição daquela variável.

# Número curto em português (vírgula decimal, ponto de milhar).
resumo_num <- function(x, digitos = 4, milhar = TRUE) {
  if (length(x) == 0 || is.na(x)) return("—")
  # Ponto de milhar só a partir de 10 mil: assim um ano (2007) não vira "2.007".
  format(signif(x, digitos), big.mark = if (milhar && abs(x) >= 1e4) "." else "", decimal.mark = ",",
         scientific = FALSE, trim = TRUE)
}

# Abreviação da classe, igual à que o glimpse() imprime.
resumo_classe <- function(x) {
  if (is.ordered(x)) return("<ord>")
  if (is.factor(x)) return("<fct>")
  if (is.logical(x)) return("<lgl>")
  if (inherits(x, "POSIXt")) return("<dttm>")
  if (inherits(x, "Date")) return("<date>")
  if (is.integer(x)) return("<int>")
  if (is.numeric(x)) return("<dbl>")
  if (is.character(x)) return("<chr>")
  paste0("<", class(x)[1], ">")
}

# Tabela "glimpse" do conjunto: uma linha por variável.
resumo_glimpse <- function(df) {
  n <- nrow(df)
  linhas <- lapply(names(df), function(nome) {
    x <- df[[nome]]
    na <- sum(is.na(x))
    validos <- x[!is.na(x)]
    tipo <- exploracao_tipo_variavel(x, nome)
    # Nas categóricas mostramos os rótulos distintos, incluindo anos quando
    # sua leitura é ordinal; nas demais, os seis primeiros valores válidos.
    categorica <- startsWith(tipo, "Categórica")
    primeiros <- if (categorica) unique(validos) else utils::head(validos, 6)
    primeiros <- if (is.numeric(primeiros)) {
      vapply(primeiros, resumo_num, character(1), milhar = FALSE)
    } else as.character(primeiros)
    # Ponto e vírgula entre valores: a vírgula já é o separador decimal.
    amostra <- paste(primeiros, collapse = "; ")
    if (nchar(amostra) > 60) amostra <- paste0(substr(amostra, 1, 57), "...")
    data.frame(
      `Variável` = nome,
      Classe = resumo_classe(x),
      `Tipo estatístico` = tipo,
      `Válidos` = n - na,
      Ausentes = if (na == 0) "0" else sprintf("%d (%s%%)", na, resumo_num(round(100 * na / n, 1))),
      Distintos = length(unique(validos)),
      `Valores iniciais` = amostra,
      check.names = FALSE, stringsAsFactors = FALSE
    )
  })
  do.call(rbind, linhas)
}

# Títulos dos conjuntos do EAPADados (para o painel da direita).
eapa_titulos <- tryCatch({
  res <- data(package = "EAPADados")$results
  stats::setNames(res[, "Title"], sub("\\s.*$", "", res[, "Item"]))
}, error = function(e) character(0))

# Lista dinâmica dos conjuntos do EAPADados: puxa TODOS os datasets do pacote
# (novos conjuntos passam a aparecer sozinhos), mantendo só os que são data.frame
# e tirando tabelas auxiliares (dicionários/referências). Se o pacote não estiver
# disponível, cai numa lista mínima de segurança.
eapa_datasets <- local({
  aux <- c("dicionario_variaveis_amostragem", "referencias_dados_amostragem")
  itens <- tryCatch(
    sub("\\s.*$", "", data(package = "EAPADados")$results[, "Item"]),
    error = function(e) character(0)
  )
  itens <- setdiff(itens, aux)
  ok <- itens[vapply(itens, function(nm) {
    obj <- tryCatch(get(nm, envir = asNamespace("EAPADados")), error = function(e) NULL)
    is.data.frame(obj)
  }, logical(1))]
  ok <- sort(ok)
  if (length(ok) == 0) {
    ok <- c("artemia", "biometria_caranguejos", "camaroes_sexo",
            "cangulo_crescimento", "captura_petrechos", "isoproteica_bagre",
            "tilapia_crescimento", "walleye_erie")
  }
  ok
})
eapa_dataset_default <- if ("artemia" %in% eapa_datasets) "artemia" else eapa_datasets[1]

# Cartão simples para itens do menu Mapear e Analisar que ainda estão em preparação.
# Ele guarda o lugar do item no menu e explica ao aluno a pergunta que o item responde.
mapas_em_preparacao <- function(titulo, pergunta, texto) {
  # Um único cartão centralizado, com largura confortável de leitura.
  div(
    style = "max-width: 760px; margin: 30px auto;",
    card(
      # Cabeçalho com o nome do item.
      card_header(titulo),
      card_body(
        # A pergunta de pesquisa que o item vai responder, em destaque.
        tags$p(tags$b("Pergunta: "), pergunta),
        # O que o item fará quando estiver pronto.
        tags$p(texto),
        # Aviso de que o item ainda não está disponível.
        div(class = "alert alert-info py-2 mb-0", icon("screwdriver-wrench"), " Em preparação.")
      )
    )
  )
}

# O mesmo cartão serve a qualquer item de menu ainda em preparação.
em_preparacao <- mapas_em_preparacao

# Interface do Usuário (UI)
ui <- page_navbar(
  id = "main_navbar",
  window_title = "CatalyseR",
  title = div(
    style = "display: flex !important; flex-direction: row !important; align-items: center !important; justify-content: center !important; gap: 7px !important; padding: 2px 6px !important; width: 100% !important; height: 100% !important;",
    tags$a(
      href = "https://www.r-project.org/",
      target = "_blank",
      style = "display: flex; align-items: center; justify-content: center; transition: all 0.2s ease;",
      tags$img(src = "r_logo.png", height = "52px", style = "opacity: 0.95;")
    ),
    tags$a(
      href = "https://shiny.posit.co/",
      target = "_blank",
      style = "display: flex; align-items: center; justify-content: center; transition: all 0.2s ease;",
      tags$img(src = "shiny_logo.png", height = "59px", style = "opacity: 0.95;")
    ),
    tags$a(
      id = "sobre-custom-btn",
      href = "#",
      title = "Sobre a CatalyseR",
      `aria-label` = "Abrir Sobre a CatalyseR",
      onclick = "var el = document.querySelector(\"a[data-value='Sobre']\"); if(el) el.click(); return false;",
      style = "display: flex; flex-direction: column; align-items: center; justify-content: center; width: 56px; min-width: 56px; height: 76px; text-decoration: none; color: #1d4ed8 !important; padding: 3px; transition: all 0.2s ease; cursor: pointer;",
      tags$i(class = "fas fa-university", style = "font-size: 1.7rem; color: #1d4ed8; margin-bottom: 3px;"),
      span("Sobre", style = "font-family: 'Outfit', sans-serif; font-weight: 700; font-size: 0.72rem; line-height: 1;")
    ),
    tags$a(
      id = "ajuda-custom-btn",
      href = "#",
      title = "Ajuda de uso",
      `aria-label` = "Abrir Ajuda de uso",
      onclick = "var el = document.querySelector(\"a[data-value='Ajuda']\"); if(el) el.click(); return false;",
      style = "display: flex; flex-direction: column; align-items: center; justify-content: center; width: 56px; min-width: 56px; height: 76px; text-decoration: none; color: #3b82f6 !important; padding: 3px; transition: all 0.2s ease; cursor: pointer;",
      tags$i(class = "fas fa-circle-question", style = "font-size: 1.7rem; color: #3b82f6; margin-bottom: 3px;"),
      span("Ajuda", style = "font-family: 'Outfit', sans-serif; font-weight: 700; font-size: 0.72rem; line-height: 1;")
    )
  ),
  theme = bs_theme(
    version = 5,
    bootswatch = "cerulean", # Tema científico limpo
    primary = "#0d6efd",
    secondary = "#6c757d"
  ),
  header = tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap"),
    tags$style(HTML("
      body {
        font-family: 'Inter', sans-serif !important;
        background-color: #f8f9fa;
      }
      .navbar {
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        padding-top: 0.2rem;
        padding-bottom: 0.2rem;
        position: sticky !important;
        top: 0;
        z-index: 1020;
        background-color: #f8f9fa;
      }
      .navbar > .container-fluid {
        display: grid !important;
        grid-template-columns: 2.5fr 7fr 2.5fr !important;
        gap: 1.5rem !important; /* Adicionado gap de 1.5rem para se alinhar perfeitamente com o corpo (layout_columns) */
        padding-left: 1.5rem !important;
        padding-right: 1.5rem !important;
        width: 100% !important;
        align-items: center !important; /* Centraliza verticalmente as colunas no container pai */
      }
      .navbar-header {
        grid-column: 3 !important; /* Posicionado na coluna da direita */
        grid-row: 1 !important; /* Força na primeira linha do grid */
        width: 100% !important; /* Estica para ocupar toda a terceira coluna do grid */
        max-width: none !important;
        margin-left: 0px !important; /* Sem margem para alinhamento horizontal perfeito */
        height: auto !important;
        display: flex !important; /* Altera para flexbox para controle de alinhamento robusto */
        align-items: center !important; /* Centraliza verticalmente a marca/logos */
        justify-content: center !important; /* Centraliza horizontalmente */
        position: relative !important;
        float: none !important;
        margin-top: 0 !important;
        margin-bottom: 0 !important;
      }
      .navbar-header::before,
      .navbar-header::after {
        display: none !important;
        content: none !important;
      }
      .navbar-brand {
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        width: 100% !important;
        max-width: none !important;
        padding: 0 !important;
        margin: 0 !important;
        height: 90px !important; /* Ajustado para 90px de altura */
        position: relative !important;
        background-color: transparent !important;
        border: none !important;
        box-shadow: none !important;
        z-index: 1 !important;
        float: none !important;
      }
      .navbar-brand::before {
        content: '' !important;
        position: absolute !important;
        top: 0 !important; /* Alinha com o limite superior do pai */
        bottom: 0 !important; /* Alinha com o limite inferior do pai */
        left: 0 !important;
        right: 0 !important;
        background-color: rgba(224, 242, 254, 0.75) !important; /* Fundo azul celeste premium */
        border: 2px solid rgba(13, 110, 253, 0.45) !important;
        border-radius: 12px !important;
        box-shadow: inset 0 1px 2px rgba(0,0,0,0.03), 0 2px 4px rgba(0,0,0,0.05) !important;
        z-index: -1 !important; /* Fica atrás do conteúdo */
      }
      .navbar-nav > li:has(.navbar-slogan-container) {
        position: absolute !important;
        top: -2px !important; /* Alinha com a borda externa superior do pai */
        bottom: -2px !important; /* Alinha com a borda externa inferior do pai (altura dinâmica!) */
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        background-color: rgba(224, 242, 254, 0.75) !important; /* Fundo azul celeste premium */
        border: 2px solid rgba(13, 110, 253, 0.45) !important;
        box-shadow: inset 0 1px 2px rgba(0,0,0,0.03), 0 2px 4px rgba(0,0,0,0.05);
        z-index: 1000 !important;
        padding: 0 !important;
        transition: all 0.2s ease;
        width: 35.71% !important; /* Corresponde a 2.5fr/7fr da largura do pai */
        left: calc(-35.71% - 1.5rem) !important; /* Posicionado à esquerda no lugar do slogan (Coluna 1) */
        right: auto !important;
        border-radius: 12px !important;
      }
      .navbar-slogan-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 3px;
        width: 100%;
        min-width: 0;
        padding: 2px 8px;
        container-type: inline-size;
      }
      /* As margens transparentes do PNG ficam fora da área visível,
         dando mais espaço à marca sem aumentar a altura do cabeçalho. */
      .navbar-logo-area {
        position: relative;
        width: 100%;
        height: 66px;
        flex-shrink: 0;
        overflow: hidden;
      }
      .navbar-logo-trilha {
        display: block;
        position: absolute;
        top: -11px;
        left: 50%;
        transform: translateX(-50%);
        width: auto;
        height: 84px;
        max-width: 100%;
        object-fit: contain;
      }
      .navbar-slogan-trilha {
        color: #0F3B5F;
        font-family: 'Inter', sans-serif;
        font-size: clamp(7px, 3.6cqw, 14px);
        font-weight: 700;
        line-height: 1.2;
        white-space: nowrap;
        text-align: center;
      }
      .navbar-collapse {
        grid-column: 2 !important;
        grid-row: 1 !important; /* Força na primeira linha do grid */
        display: flex !important;
        justify-content: center !important;
        align-items: center !important; /* MUDADO de stretch para center */
        width: 100% !important;
        position: relative !important; /* Contexto de posicionamento para o slogan */
      }
      
      /* Estilo dos Menus Empilhados (Ícone no Topo, Texto Embaixo) */
      .navbar-nav {
        display: flex !important;
        flex-direction: row !important;
        flex-wrap: nowrap !important; /* Evita quebra dos menus em múltiplas linhas */
        align-items: center !important;
        width: 100% !important;
        height: 90px !important; /* Ajustado para 90px de altura */
        justify-content: space-between !important;
        gap: 2px !important;
        border: 2px solid rgba(13, 110, 253, 0.45) !important;
        padding: 4px 8px !important; /* Ajustado padding vertical */
        border-radius: 12px !important;
        background-color: rgba(228, 244, 230, 0.75) !important;
        box-shadow: inset 0 1px 2px rgba(0,0,0,0.03);
      }
      .navbar-nav .nav-item {
        flex: 1 1 0px !important;
        text-align: center !important;
      }
      
      .navbar-nav .nav-item .nav-link, 
      .navbar-nav .nav-item .dropdown-toggle {
        display: flex !important;
        flex-direction: column !important;
        align-items: center !important;
        justify-content: center !important;
        text-align: center !important;
        font-size: 0.76rem !important; /* Aumentado para 0.76rem */
        font-family: 'Outfit', sans-serif !important;
        font-weight: 700 !important;
        padding: 2px 2px !important; /* Padding vertical mínimo */
        gap: 2px !important; /* Ajustado espaçamento entre ícone e texto */
        line-height: 1.05 !important;
        width: 100% !important;
        min-width: 0 !important;
        max-width: none !important;
        color: #495057 !important;
        border-radius: 8px;
        transition: all 0.2s ease;
      }
      .navbar-nav .nav-item .nav-link:hover,
      .navbar-nav .nav-item .dropdown-toggle:hover {
        background-color: rgba(13, 110, 253, 0.05) !important;
        color: #0d6efd !important;
      }
      .navbar-nav .nav-item.active .nav-link,
      .navbar-nav .nav-item.show .dropdown-toggle,
      .navbar-nav .nav-link.active {
        background-color: rgba(13, 110, 253, 0.08) !important;
        color: #0d6efd !important;
      }
      .navbar-nav .nav-item .nav-link i,
      .navbar-nav .nav-item .dropdown-toggle i {
        font-size: 1.45rem !important; /* Aumentado para 1.45rem */
        margin-bottom: 1px !important; /* Margem mínima */
        margin-right: 0px !important;
      }
      
      /* Cores por classe: cada menu mantém sua cor quando a ordem muda. */
      .exploracao-espaco h2, .exploracao-espaco h5 { color: #0F3B5F !important; }
      .exploracao-espaco .exploracao-confirmar { background: #0F3B5F !important; border-color: #0F3B5F !important; color: white !important; }
      .exploracao-espaco .exploracao-confirmar:hover { background: #2E7D8F !important; }
      .exploracao-espaco > p { margin-bottom: .6rem !important; }
      .exploracao-espaco .catalyser-base-selector-compact { margin: .5rem 0 .8rem !important; }
      .exploracao-espaco { --bslib-spacer: 1rem; }
      .exploracao-espaco .card-body { padding: 1.1rem; }
      .exploracao-espaco .bslib-sidebar-layout { gap: 1rem; }
      .exploracao-espaco .form-group { margin-bottom: .9rem; }
      .exploracao-espaco pre { white-space: pre-wrap; line-height: 1.5; }
      .exploracao-espaco input::placeholder { color: #7c8790; font-size: .9em; }
      .exploracao-indicador { background: #f3f8f7; border-left: 3px solid #2E7D8F; border-radius: .5rem; padding: .8rem 1rem; margin-bottom: .6rem; }
      .exploracao-indicador span { display: block; color: #61717d; font-size: .85rem; }
      .exploracao-indicador strong { display: block; color: #0F3B5F; font-size: 1.5rem; }
      .exploracao-saude { display: flex; flex-wrap: wrap; gap: .5rem; align-items: center; margin: .5rem 0 1.2rem; }
      .exploracao-saude .badge { padding: .5rem .7rem; font-weight: 500; white-space: normal; }
      .descricao-conteudo .bslib-sidebar-layout { gap: 1rem; }
      .descricao-conteudo .form-group { margin-bottom: .9rem; }
      /* Importação: o status fica abaixo da configuração; a lista de
         variáveis tem sua própria rolagem para liberar o gráfico abaixo. */
      .importacao-lateral {
        display: flex; flex-direction: column; gap: 16px; height: 100%;
        min-height: 0;
      }
      .importacao-lateral > .card { flex: 0 0 auto; }
      .importacao-status { margin-top: auto; }
      .importacao-panorama { height: 100%; }
      #resumo_variaveis_tabela .dataTables_info { padding-top: 4px; }
      #resumo_variaveis_tabela th:nth-child(3),
      #resumo_variaveis_tabela td:nth-child(3) {
        min-width: 170px; white-space: nowrap;
      }
      .cor-menu-planejar { color: #8b5cf6 !important; } /* Planejando sua Pesquisa -> violeta */
      .cor-menu-preparar { color: #0d6efd !important; } /* Preparando Dados -> azul */
      .cor-menu-explorar { color: #00b894 !important; } /* Explorar e Visualizar -> verde-água */
      .cor-menu-frequencias { color: #E89B3C !important; } /* Frequências e Proporções -> âmbar */
      .cor-menu-parametricos { color: #f97316 !important; } /* Testes Paramétricos -> laranja */
      .cor-menu-naoparametricos { color: #84cc16 !important; } /* Testes Não Paramétricos -> verde-limão */
      .cor-menu-lineares { color: #7c3aed !important; } /* Regressões Lineares e MLG -> roxo */
      .cor-menu-naolineares { color: #ec4899 !important; } /* Regressão Não Linear -> rosa/magenta */
      .cor-menu-temporais { color: #2E7D8F !important; } /* Séries Temporais -> teal */
      .cor-menu-multivariada { color: #d946ef !important; } /* Estatística Multivariada -> rosa/magenta */
      .cor-menu-mapas { color: #6366f1 !important; } /* Mapear e Analisar -> roxo-violeta */
      .cor-menu-laboratorio { color: #198754 !important; } /* Laboratório de Conceitos -> verde */
      .cor-menu-comunicacao { color: #0ea5e9 !important; } /* Comunicação de Resultados -> azul-ciano */
      
      /* Atalhos da terceira faixa, dimensionados como as logos. */
      #sobre-custom-btn,
      #ajuda-custom-btn {
        transition: all 0.2s ease;
        flex: 0 0 56px !important;
      }
      #sobre-custom-btn:hover,
      #ajuda-custom-btn:hover {
        background-color: rgba(13, 110, 253, 0.08) !important;
        border-radius: 8px;
        transform: translateY(-1px);
      }
      .navbar-nav > li:has(> a[data-value='Ajuda']),
      .navbar-nav > li:has(> a[data-value='Sobre']) {
        display: none !important; /* Ajuda e Sobre usam os atalhos à direita. */
      }
      
      /* Dropdowns da bslib mantêm o formato horizontal interno clássico */
      .dropdown-menu .dropdown-item {
        display: flex !important;
        flex-direction: row !important;
        align-items: center !important;
        text-align: left !important;
        font-size: 0.85rem !important;
        font-family: 'Inter', sans-serif !important;
        padding: 8px 16px !important;
        gap: 8px !important;
      }
      /* Recuo dos módulos para destacar os títulos de grupo em todos os menus. */
      .navbar .dropdown-menu .dropdown-item {
        padding-left: 35px !important;
      }
      .dropdown-menu .dropdown-item i {
        font-size: 1rem !important;
        color: #6c757d !important;
      }
      .dropdown-menu .dropdown-item:hover i {
        color: #0d6efd !important;
      }
      
      .card {
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        border: 1px solid rgba(0,0,0,0.05);
      }
      .card-header {
        font-family: 'Outfit', sans-serif !important;
        font-weight: 700;
        letter-spacing: -0.2px;
      }
      .btn {
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.2s ease;
      }
      .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      /* Botões utilitários/secundários no tema Ocean:
         troca o cinza de baixo contraste por um verde-água suave e legível.
         Fundo seafoam claro + texto NAVY; hover em TEAL sólido com texto branco. */
      .btn-outline-secondary {
        background-color: #E6F2F1 !important;
        color: #0F3B5F !important;
        border-color: #A9D2D4 !important;
        font-weight: 600 !important;
      }
      .btn-outline-secondary:hover,
      .btn-outline-secondary:focus,
      .btn-outline-secondary:active {
        background-color: #2E7D8F !important;
        color: #ffffff !important;
        border-color: #2E7D8F !important;
      }
      .btn-outline-secondary:hover .fa,
      .btn-outline-secondary:hover svg { color: #ffffff !important; }

      /* REFINAMENTO DE DENSIDADE E COMPACTAÇÃO VISUAL */
      /* 1. Compactação de Cards (Painel Lateral e Central) */
      .card-body {
        padding: 10px 12px !important;
      }
      .card-header {
        padding: 8px 12px !important;
      }
      /* Painéis de resultado (navset_card_tab com título): o título abre a
         primeira linha do cabeçalho e as abas ocupam a segunda linha inteiras,
         em vez de dividirem a linha com o título e se espremerem em coluna.
         row-gap de 4px = metade dos 8px de padding-top que ficavam acima
         das abas (medido no navegador antes da mudança). */
      .bslib-card .card-header.bslib-navs-card-title {
        flex-direction: column;
        align-items: stretch;
        justify-content: flex-start;
        row-gap: 4px;
      }
      /* Linha companheira da regra acima: o bslib empurra as abas para a
         direita com margin-left:auto; sem zerá-lo, a barra de abas da 2ª
         linha fica com a largura do conteúdo, em vez de inteira. */
      .bslib-card .card-header.bslib-navs-card-title > .nav {
        margin-left: 0;
      }
      
      /* 2. Compactação de Form Groups, Inputs e Controles */
      .form-group, .shiny-input-container {
        margin-bottom: 8px !important;
      }
      .control-label {
        margin-bottom: 3px !important;
        font-size: 0.83rem !important;
        font-weight: 600;
        color: #495057;
      }
      .form-check {
        margin-bottom: 4px !important;
        font-size: 0.83rem !important;
      }
      .form-control, .form-select, .selectize-input {
        padding: 4px 8px !important;
        font-size: 0.83rem !important;
        height: auto !important;
        min-height: 0 !important;
      }
      .selectize-control {
        margin-bottom: 6px !important;
      }
      /* Garante área de digitação utilizável na busca do selectize */
      .selectize-input {
        min-height: 1.7rem !important;
      }
      .selectize-input input {
        font-size: 0.83rem !important;
      }
      /* O seletor de Base utilizada precisa escapar do cartão e acomodar
         nomes amigáveis/objetos R longos sem esconder as opções. */
      .catalyser-base-selector,
      .catalyser-base-selector > .card-body,
      .catalyser-base-selector .row {
        overflow: visible !important;
      }
      .catalyser-base-selector {
        position: relative !important;
        z-index: 30 !important;
      }
      .catalyser-base-selector .selectize-control {
        position: relative !important;
        z-index: 31 !important;
      }
      .catalyser-base-selector .selectize-dropdown {
        width: max-content !important;
        min-width: 100% !important;
        max-width: min(92vw, 64rem) !important;
        z-index: 2000 !important;
      }
      .catalyser-base-selector .selectize-dropdown .option {
        white-space: normal !important;
        overflow-wrap: anywhere;
        line-height: 1.25;
        padding-top: 7px !important;
        padding-bottom: 7px !important;
      }
      .catalyser-base-selector .alert {
        margin-top: 0 !important;
      }
      /* Em Explorando os Dados, a base cabe numa faixa curta acima da pergunta. */
      .catalyser-base-selector-compact {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0 0 4px;
        padding: 0 2px;
      }
      .catalyser-base-selector-compact > label {
        flex: 0 0 auto;
        margin: 0;
        font-size: 0.78rem;
        font-weight: 600;
        color: #495057;
      }
      .catalyser-base-selector-compact-input {
        width: min(30rem, 62vw);
      }
      .catalyser-base-selector-compact-input .shiny-input-container,
      .catalyser-base-selector-compact-input .selectize-control {
        margin: 0 !important;
      }
      .catalyser-base-selector-compact-input .selectize-input {
        min-height: 1.55rem !important;
        padding: 2px 7px !important;
      }
      /* Em telas estreitas, o seletor continua legível sem criar rolagem lateral. */
      @media (max-width: 640px) {
        .catalyser-base-selector-compact {
          align-items: stretch;
          flex-direction: column;
          gap: 2px;
        }
        .catalyser-base-selector-compact-input {
          width: 100%;
        }
      }
      /* Nos testes complementares (Teste F, qui-quadrado de variância, ANOVA de
         medidas repetidas), os vãos padrão de 16px dos painéis do bslib empurram
         o resultado para fora da primeira dobra; 6px mantém as linhas juntas. */
      .catalyser-complementar .tab-pane.bslib-gap-spacing {
        gap: 6px;
      }
      /* Os gráficos exploratórios não precisam ocupar toda a largura do painel. */
      .descricao-grafico-compacto {
        width: min(52%, 780px);
        min-width: 34rem;
        margin: 6px auto 12px;
      }
      /* Em telas menores, a largura total preserva rótulos e escalas legíveis. */
      @media (max-width: 900px) {
        .descricao-grafico-compacto {
          width: 100%;
          min-width: 0;
        }
      }

      /* 3. Compactação das Abas Superiores do Painel Central */
      .nav-tabs .nav-link {
        padding: 6px 12px !important;
        font-size: 0.85rem !important;
      }
      
      /* 4. Compactação do Espaço Vertical antes dos Gráficos e Tabelas */
      .card-body > .shiny-plot-output, 
      .card-body > .plotly, 
      .card-body > .shiny-html-output {
        margin-top: 2px !important;
        margin-bottom: 2px !important;
      }
      .card-body hr {
        margin: 8px 0 !important;
      }
      
      /* 5. Padronização e Ajuste Fino de Tabelas de Dados (DT) */
      .dataTables_wrapper .dataTables_filter, 
      .dataTables_wrapper .dataTables_length {
        margin-bottom: 6px !important;
        font-size: 0.83rem !important;
      }
      .dataTables_wrapper .dataTables_info, 
      .dataTables_wrapper .dataTables_paginate {
        margin-top: 6px !important;
        font-size: 0.8rem !important;
      }
      table.dataTable thead th, table.dataTable thead td {
        padding: 6px 8px !important;
        font-size: 0.83rem !important;
        font-family: 'Outfit', sans-serif !important;
        font-weight: 700;
      }
      table.dataTable tbody th, table.dataTable tbody td {
        padding: 5px 8px !important;
        font-size: 0.83rem !important;
      }
    "))
  ),
  
  # 1. Planejando sua Pesquisa
  nav_menu(
    title = HTML("Planejando<br>sua Pesquisa"),
    icon = icon("compass-drafting", class = "cor-menu-planejar"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Antes de contar")),
    nav_panel(
      title = "Conceitos antes da coleta",
      icon = icon("book-open"),
      mod_conceitos_coleta_ui("conceitos_coleta")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Delineamentos observacionais")),
    planejamento_observacional_painel("transversal_comparativo"),
    planejamento_observacional_painel("longitudinal"),
    planejamento_observacional_painel("gradiente"),
    planejamento_observacional_painel("impacto"),
    nav_panel(
      title = "Monitoramento (Séries Temporais)", icon = icon("chart-line"),
      mod_monitoramento_ui("monitoramento")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Delineamentos experimentais")),
    nav_panel(
      title = "DIC (Inteiramente Casualizado)",
      icon = icon("flask"),
      tagList(
        planejamento_contexto_ui("Como distribuir tratamentos?", "Organize as unidades e os tratamentos no croqui. Depois, abra a aba Variáveis do experimento para preparar a coleta. A análise precisa respeitar o delineamento escolhido."),
        mod_experimental_design_ui(
          "experimental_dic",
          variaveis_ui = mod_planejamento_variaveis_ui("variables_exp_dic", experimental = TRUE),
          tipo_fixo = "DIC"
        )
      )
    ),
    nav_panel(
      title = "DBC (Blocos Casualizados)", icon = icon("flask"),
      mod_experimental_design_ui("experimental_dbc", mod_planejamento_variaveis_ui("variables_exp_dbc", experimental = TRUE), tipo_fixo = "DBC")
    ),
    nav_panel(
      title = "DQL (Quadrado Latino)", icon = icon("flask"),
      mod_experimental_design_ui("experimental_dql", mod_planejamento_variaveis_ui("variables_exp_dql", experimental = TRUE), tipo_fixo = "DQL")
    ),
    nav_panel(
      title = "Fatorial (em DIC)", icon = icon("flask"),
      mod_experimental_design_ui("experimental_fatorial", mod_planejamento_variaveis_ui("variables_exp_fatorial", experimental = TRUE), tipo_fixo = "fatorial")
    ),
    nav_panel(
      title = "Parcelas Subdivididas (Split-Plot)", icon = icon("flask"),
      mod_experimental_design_ui("experimental_split_plot", mod_planejamento_variaveis_ui("variables_exp_split_plot", experimental = TRUE), tipo_fixo = "split_plot")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Montagem da amostra")),
    nav_panel(
      title = "Quanto amostrar",
      icon = icon("calculator"),
      mod_quantos_coletar_ui("quantos_coletar")
    ),
    nav_panel(
      title = "Como amostrar",
      icon = icon("shuffle"),
      mod_sortear_amostra_ui("sortear_amostra")
    ),
    # Onde amostrar: localização das unidades no território (antigo "Pontos / Estações"
    # do menu de mapas). Por ora abre o mapa de estações; as abas "Sortear locais" e
    # "Conferir a distribuição" virão depois (ver Especificacao_CatalyseR_Mapas.md).
    nav_panel(
      title = "Onde amostrar",
      icon = icon("location-crosshairs"),
      mod_mapa_pontos_ui("mapa_pontos", "pontos")
    )
  ),

  # 2. Preparando Dados
  nav_menu(
    title = HTML("Preparar<br>Dados"),
    icon = icon("database", class = "cor-menu-preparar"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Importação de dados")),
    nav_panel(
      title = "Importar Dados",
      # PENDENCIA-V2: atalho opcional "Carregar Pacote de Dados" que abre este item com a origem Pacote marcada.
      icon = icon("file-import"),
      layout_columns(
        col_widths = c(1, 1, 1),
        style = "grid-template-columns: 2.5fr 7fr 2.5fr !important;",
        
        # COLUNA 1: CARREGAMENTO DE DADOS (CONFIGURAÇÃO)
        div(class = "importacao-lateral",
          card(
            card_header("Carregamento de Dados"),
            card_body(
              style = "padding: 12px 15px;",
              radioButtons("data_source", "Origem dos Dados:",
                           choices = c("Arquivo Local (CSV/Excel)" = "local",
                                       "Pacote EAPADados" = "package")),
              conditionalPanel(
                condition = "input.data_source == 'local'",
                fileInput("file_upload", "Escolha o arquivo (.csv, .xlsx, .xls):",
                          accept = c(".csv", ".xlsx", ".xls")),
                conditionalPanel(
                  condition = "output.arquivo_csv == 'sim'",
                  checkboxInput("csv_header", "Cabeçalho na primeira linha", TRUE),
                  radioButtons("csv_sep", "Separador de Coluna:",
                               choices = c("Vírgula (,)" = ",",
                                           "Ponto e Vírgula (;)" = ";",
                                           "Tabulação (Tab)" = "\t"),
                               selected = ","),
                  radioButtons("csv_dec", "Separador de Decimal:",
                               choices = c("Ponto (.)" = ".",
                                           "Vírgula (,)" = ","),
                               selected = "."),
                  helpText("Confira a prévia: se tudo ficar em uma coluna, troque o separador de coluna. Para valores como 12,5, escolha decimal Vírgula.")
                ),
                uiOutput("excel_sheet_selector")
              ),
              conditionalPanel(
                condition = "input.data_source == 'package'",
                selectizeInput("package_dataset", "Selecione o Dataset do EAPADados:",
                  choices = eapa_datasets,
                  selected = eapa_dataset_default,
                  options = list(
                    placeholder = "Digite ou escolha um conjunto de dados...",
                    openOnFocus = TRUE,
                    dropdownParent = "body",
                    onDropdownOpen = I("function($dropdown) { $dropdown.addClass('origem-lista-ampla'); }"),
                    maxOptions = 100
                  ))
              ),
              div(
                class = "alert alert-light border mt-2 mb-0",
                style = "font-size:0.8rem; padding:8px 10px;",
                icon("arrow-right"),
                " Depois de carregar, use ",
                strong("Preparar Base Compartilhada"),
                " para selecionar, renomear, tipar ou recodificar."
              )
            )
          ),
          card(class = "importacao-status",
            card_header("Status do Dataset"),
            card_body(fill = FALSE, fillable = FALSE,
              style = "padding: 12px 15px;",
              uiOutput("dataset_status_indicator")))
        ),
        
        # COLUNA 2: ABAS DE EXIBIÇÃO (PRINCIPAL)
        navset_card_tab(
          nav_panel(
            title = "Visualização dos Dados",
            icon = icon("table"),
            card_body(
              style = "padding: 10px 15px;",
              DTOutput("data_preview_table")
            )
          ),
          nav_panel(
            title = "Resumo dos Dados",
            icon = icon("chart-bar"),
            # fill = FALSE: a tabela e o detalhe empilham sem se sobrepor.
            card_body(fill = FALSE, fillable = FALSE,
              style = "padding: 10px 15px;",
              p(class = "small text-muted mb-2",
                "Uma linha por variável, como o ", code("glimpse()"), " do R. ",
                "Confira se cada coluna chegou com o tipo certo e clique numa linha para ver a distribuição dela."),
              DTOutput("resumo_variaveis_tabela"),
              hr(style = "margin: 14px 0 10px;"),
              uiOutput("resumo_variavel_detalhe")
            )
          ),
          nav_panel(
            title = "Código R",
            icon = icon("code"),
            card_body(fill = FALSE, fillable = FALSE,
              p(class = "small text-muted", "Esta leitura acompanha o arquivo, a aba e os separadores escolhidos. Guarde o arquivo original junto ao script ou ajuste o caminho. Os tratamentos posteriores aparecem no código da base preparada."),
              verbatimTextOutput("codigo_importacao"),
              div(downloadButton("baixar_codigo_importacao", "Baixar importação (.R)", class = "btn-outline-primary"))
            )
          )
        ),
        
        # COLUNA 3: CONFERÊNCIA DA ENTRADA
        div(
          card(class = "importacao-panorama",
            card_body(
              style = "padding: 12px 15px;",
              uiOutput("dataset_panorama"),
              hr(style = "margin: 10px 0;"),
              h6("Formatos Suportados", style = "color: #0d6efd; font-weight: 700; margin-bottom: 8px;"),
              tags$ul(style = "padding-left: 15px; margin-bottom: 0; font-size: 0.85rem; line-height: 1.4;",
                tags$li("CSV (.csv)"),
                tags$li("Excel (.xlsx, .xls)"),
                tags$li("Pacote R 'EAPADados'")
              )
            )
          )
        )
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Reestruturação de planilhas")),
    nav_panel(
      title = "Empilhar colunas",
      icon = icon("layer-group"),
      div(class = "mb-0",
        h4("Empilhar colunas", class = "mb-1"),
        p(class = "small text-muted mb-2", "Empilhe várias colunas em duas: uma com o nome da coluna e outra com o valor. Confira a prévia antes de adicionar a mudança à Base Compartilhada.")),
      mod_arrumar_ui("arrumar_emp", modo_fixo = "empilhar")
    ),
    nav_panel(
      title = "Alargar planilha",
      icon = icon("table-columns"),
      div(class = "mb-0",
        h4("Alargar planilha", class = "mb-1"),
        p(class = "small text-muted mb-2", "Espalhe os valores de uma coluna em várias colunas novas. Confira a prévia antes de adicionar a mudança à Base Compartilhada.")),
      mod_arrumar_ui("arrumar_wider", modo_fixo = "alargar")
    ),
    nav_panel(
      title = "Separar colunas",
      icon = icon("scissors"),
      div(class = "mb-0",
        h4("Separar colunas", class = "mb-1"),
        p(class = "small text-muted mb-2", "Separe o conteúdo de uma coluna em duas ou mais. Confira a prévia antes de adicionar a mudança à Base Compartilhada.")),
      mod_arrumar_ui("arrumar_sep", modo_fixo = "separar")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Preparação de bases de dados")),
    nav_panel(
      title = "Preparar Base Compartilhada",
      icon = icon("list-check"),
      mod_preparar_compartilhada_ui("preparar_compartilhada")
    ),
    nav_panel(
      title = "Preparar Bases Derivadas",
      icon = icon("diagram-project"),
      mod_bases_derivadas_ui("bases_derivadas")
    )
  ),

  # Explorar e Visualizar Dados: um só menu, com dois grupos.
  # O primeiro convida o aluno a investigar os dados antes de escolher um teste;
  # o segundo é o ateliê de gráficos, onde ele escolhe variáveis e estética.
  # Rosca e Duplo eixo Y saíram do menu; os módulos seguem no código (PENDENCIA-V2: limpar).
  nav_menu(
    title = HTML("Explorar e<br>Visualizar"),
    icon = icon("chart-bar", class = "cor-menu-explorar"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Explorando os dados")),
    nav_panel(
      title = "Explorar Dataset",
      icon = icon("table-list"),
      mod_descrevendo_dados_ui("descricao_explorar", "explorar")
    ),
    nav_panel(
      title = "Conhecer as Variáveis",
      icon = icon("layer-group"),
      mod_descrevendo_dados_ui("descricao_descrever", "descrever")
    ),
    nav_panel(
      title = "Encontrar Relações",
      icon = icon("chart-simple"),
      mod_descrevendo_dados_ui("descricao_relacoes", "relacoes")
    ),
    nav_panel(
      title = "Avaliar Pressupostos",
      icon = icon("square-poll-vertical"),
      mod_descrevendo_dados_ui("descricao_pressupostos", "pressupostos")
    ),
    nav_panel(
      title = "Transformar Variáveis",
      icon = icon("arrows-rotate"),
      mod_descrevendo_dados_ui("descricao_transformar", "transformar")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Visualizando os dados")),
    nav_panel(title = "Histograma e densidade", icon = icon("chart-area"), mod_exploracao_visual_ui("visual_histograma", "histograma")),
    nav_panel(title = "Barras", icon = icon("chart-bar"), mod_exploracao_visual_ui("visual_barras", "barras")),
    nav_panel(title = "Comparar grupos", icon = icon("chart-column"), mod_exploracao_visual_ui("visual_caixa", "caixa_violino")),
    nav_panel(title = "Dispersão e tendência", icon = icon("chart-line"), mod_exploracao_visual_ui("visual_dispersao", "dispersao")),
    nav_panel(
      title = "Linhas para eixo ordenado", icon = icon("timeline"),
      mod_analise_registravel_ui(
        "fluxo_lines", tagList(mod_seletor_base_analise_ui("base_lines"), mod_lines_ui("lines")), mod_registrar_execucao_ui("registrar_lines")
      )
    ),
    nav_panel(title = "Matriz de dispersão", icon = icon("table-cells"), mod_exploracao_visual_ui("visual_matriz", "matriz")),
    nav_panel(title = "Mapa de calor de correlação", icon = icon("table-cells-large"), mod_exploracao_visual_ui("visual_calor", "calor"))
  ),

  # 4. Frequências e Proporções — respostas categóricas de unidades independentes.
  nav_menu(
    title = HTML("Frequências<br>e Proporções"),
    icon = icon("chart-pie", class = "cor-menu-frequencias"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Proporções")),
    nav_panel(
      title = "Uma proporção",
      icon = icon("percent"),
      mod_proporcoes_ui("proporcao_uma", "uma")
    ),
    nav_panel(
      title = "Duas proporções",
      icon = icon("scale-balanced"),
      mod_proporcoes_ui("proporcao_duas", "duas")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Tabelas de frequência")),
    nav_panel(
      title = "Qui-quadrado (aderência)",
      icon = icon("bullseye"),
      mod_proporcoes_ui("qui_aderencia", "aderencia")
    ),
    nav_panel(
      title = "Qui-quadrado de independência",
      icon = icon("table-cells"),
      mod_analise_registravel_ui(
        "fluxo_np_qui",
        tagList(
          mod_seletor_base_analise_ui("base_np_qui"),
          div(
            class = "alert alert-light border py-2 small",
            "A base escolhida vale para Duas variáveis e para Base tidy de contingência. ",
            "Bases tidy usam a coluna n como frequência. Se a base derivada não aparecer ",
            "em Base utilizada, volte a Preparar Bases Derivadas, clique em Recalcular esta base ",
            "e depois em Finalizar preparo."
          ),
          mod_nonparametric_ui("np_qui", "quiquadrado")
        ),
        mod_registrar_execucao_ui("registrar_np_qui")
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Dados pareados")),
    nav_panel(
      title = "McNemar (pares binários)",
      icon = icon("right-left"),
      mod_pareados_categoricos_ui("mcnemar", "mcnemar")
    )
  ),

  # 5. Testes Paramétricos
  nav_menu(
    title = HTML("Testes<br>Paramétricos"),
    icon = icon("calculator", class = "cor-menu-parametricos"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Comparação de médias")),
    nav_panel(
      title = "Teste t de Student",
      icon = icon("arrows-left-right"),
      mod_analise_registravel_ui(
        "fluxo_parametric",
        tagList(
          mod_seletor_base_analise_ui("base_parametric"),
          mod_parametric_ui("parametric")
        ),
        mod_registrar_execucao_ui("registrar_parametric")
      )
    ),
    nav_panel(
      title = "ANOVA de um fator",
      icon = icon("sliders"),
      mod_analise_registravel_ui(
        "fluxo_anova",
        tagList(
          mod_seletor_base_analise_ui("base_anova"),
          mod_anova_ui("anova")
        ),
        mod_registrar_execucao_ui("registrar_anova")
      )
    ),
    nav_panel(
      title = "ANOVA com subamostras",
      icon = icon("layer-group"),
      mod_analise_registravel_ui(
        "fluxo_anova_mista",
        tagList(
          mod_seletor_base_analise_ui("base_anova_mista"),
          mod_anova_mista_ui("anova_mista")
        ),
        mod_registrar_execucao_ui("registrar_anova_mista")
      )
    ),
    nav_panel(
      title = "ANOVA de medidas repetidas",
      icon = icon("arrows-rotate"),
      mod_parametrico_complementar_ui("anova_repetidas", "anova_medidas_repetidas")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Modelos com mais de um fator")),
    nav_panel(
      title = "ANOVA a dois fatores",
      icon = icon("table-cells-large"),
      mod_analise_registravel_ui(
        "fluxo_anova2",
        tagList(
          mod_seletor_base_analise_ui("base_anova2"),
          mod_anova_dois_fatores_ui("anova2")
        ),
        mod_registrar_execucao_ui("registrar_anova2")
      )
    ),
    nav_panel(
      title = "ANCOVA (Análise de Covariância)",
      icon = icon("chart-line"),
      mod_ancova_ui("ancova")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Comparação de variâncias")),
    nav_panel(
      title = "Qui-quadrado para variância",
      icon = icon("square-root-variable"),
      mod_parametrico_complementar_ui("qui_variancia", "qui_quadrado_variancia")
    ),
    nav_panel(
      title = "Teste F para duas variâncias",
      icon = icon("scale-balanced"),
      mod_parametrico_complementar_ui("teste_f_variancias", "teste_f_variancias")
    )
  ),

  # 6. Testes Não Paramétricos
  nav_menu(
    title = HTML("Testes Não<br>Paramétricos"),
    icon = icon("percent", class = "cor-menu-naoparametricos"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Duas amostras")),
    nav_panel(
      title = "Mann-Whitney (2 grupos)",
      icon = icon("arrows-left-right"),
      mod_nonparametric_ui("np_mw", "mannwhitney")
    ),
    nav_panel(
      title = "Wilcoxon (pareado)",
      icon = icon("shuffle"),
      mod_nonparametric_ui("np_wil", "wilcoxon")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Três ou mais amostras")),
    nav_panel(
      title = "Kruskal-Wallis (k grupos)",
      icon = icon("arrows-up-down"),
      mod_nonparametric_ui("np_kw", "kruskal")
    ),
    nav_panel(
      title = "Friedman (k grupos pareados)",
      icon = icon("arrows-rotate"),
      mod_pareados_categoricos_ui("friedman", "friedman")
    )
  ),

  # 7. Modelos de Regressão
  nav_menu(
    title = HTML("Regressões<br>Lineares e MLG"),
    icon = icon("chart-line", class = "cor-menu-lineares"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Associação")),
    nav_panel(
      title = "Correlação",
      icon = icon("braille"),
      # PENDENCIA-V2: ligar Inserir análise (registro de execução) e seletor de base ao módulo Correlação.
      mod_correlacao_ui("correlacao")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Resposta numérica")),
    nav_panel(
      title = "Linear Simples",
      icon = icon("chart-line"),
      mod_analise_registravel_ui(
        "fluxo_regression",
        tagList(
          mod_seletor_base_analise_ui("base_regression"),
          mod_regression_ui("regression")
        ),
        mod_registrar_execucao_ui("registrar_regression")
      )
    ),
    nav_panel(
      title = "Linear Múltipla",
      # PENDENCIA-V2: implementar a Regressão Linear Múltipla (hoje é só tela provisória).
      icon = icon("table-cells"),
      card(
        card_header("Regressão Linear Múltipla"),
        card_body(
          h5("Módulo em Desenvolvimento", class = "text-primary"),
          p("Esta análise estará disponível em breve no CatalyseR!"),
          helpText(
            "Permitirá ajustar modelos com múltiplas variáveis preditoras. Exemplos de aplicação:",
            tags$ul(
              tags$li("Modelagem de crescimento em cultivos fechados (fases lag, log, desaceleração e estacionária)."),
              tags$li("Curvas de seletividade de petrechos de pesca (redes de emalhe ou arrasto), estimando a probabilidade de retenção em função do comprimento do peixe.")
            )
          )
        )
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Resposta binária")),
    nav_panel(
      title = "Logística Binária",
      icon = icon("chart-line"),
      mod_analise_registravel_ui(
        "fluxo_logistic_regression",
        mod_regression_ui("logistic_regression", is_logistic = TRUE),
        mod_registrar_execucao_ui("registrar_logistic")
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Resposta de contagem")),
    nav_panel(
      title = "Poisson",
      icon = icon("hashtag"),
      mod_regressao_contagem_ui("regressao_poisson", "poisson")
    ),
    nav_panel(
      title = "Binomial Negativa",
      icon = icon("chart-column"),
      mod_regressao_contagem_ui("regressao_binomial_negativa", "binomial_negativa")
    )
  ),

  # 7.1. Regressão Não Linear
  nav_menu(
    title = HTML("Regressão<br>Não Linear"),
    icon = icon("bezier-curve", class = "cor-menu-naolineares"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Escolher a curva")),
    nav_panel(
      title = "Descobrindo o Modelo",
      icon = icon("magnifying-glass-chart"),
      mod_model_discovery_ui("discovery")
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Ajustar a curva")),
    nav_panel(
      title = "Curva Exponencial",
      icon = icon("arrow-trend-up"),
      mod_nonlinear_ui("exponencial", "exponencial")
    ),
    nav_panel(
      title = "Curva de Modelo de Potência",
      icon = icon("circle-nodes"),
      mod_nonlinear_ui("potencia", "potencia")
    ),
    nav_panel(
      title = "Curva de Crescimento de Peixes",
      icon = icon("fish"),
      mod_nonlinear_ui("von_bertalanffy", "von_bertalanffy")
    ),
    nav_panel(
      title = "Curva Polinomial",
      icon = icon("chart-area"),
      mod_nonlinear_ui("polinomial", "polinomial")
    ),
    nav_panel(
      title = "Curva Logarítmica",
      icon = icon("chart-simple"),
      mod_nonlinear_ui("logaritmica", "logaritmica")
    ),
    nav_panel(
      title = "Curva Logística",
      icon = icon("chart-line"),
      mod_nonlinear_ui("logistico", "logistico")
    )
  ),

  # 8. Séries Temporais: uma família própria, marcada pela ordem das observações.
  nav_menu(
    title = HTML("Séries<br>Temporais"),
    icon = icon("clock", class = "cor-menu-temporais"),
    nav_panel(
      title = "Visualizar e suavizar",
      icon = icon("chart-line"),
      mod_series_temporais_ui("series_visualizar", "visualizar")
    ),
    nav_panel(
      title = "Decomposição",
      icon = icon("layer-group"),
      mod_series_temporais_ui("series_decompor", "decompor")
    ),
    nav_panel(
      title = "Autocorrelação",
      icon = icon("wave-square"),
      mod_series_temporais_ui("series_autocorrelacao", "autocorrelacao")
    ),
    nav_panel(
      title = "Previsão (introdução)",
      icon = icon("forward"),
      # PENDENCIA-V2: implementar Previsão (treino e teste, modelos, exatidão) e o cabeçalho de dados comum.
      em_preparacao(
        "Previsão (introdução)",
        "O que esperar da série nos próximos períodos, e isso supera um modelo ingênuo?",
        "Separa treino e teste, compara média, sazonal ingênuo e ETS com intervalos, e mostra RMSE e MAE. Fica desmarcada por padrão e sempre exibe o modelo ingênuo ao lado."
      )
    )
  ),

  # 9. Estatística Multivariada
  nav_menu(
    title = HTML("Estatística<br>Multivariada"),
    icon = icon("diagram-project", class = "cor-menu-multivariada"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Reduzir dimensão")),
    nav_panel(
      title = "PCA (Componentes Principais)",
      icon = icon("diagram-project"),
      mod_analise_registravel_ui(
        "fluxo_pca",
        tagList(
          mod_seletor_base_analise_ui("base_pca"),
          mod_pca_ui("pca")
        ),
        mod_registrar_execucao_ui("registrar_pca")
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Agrupar")),
    nav_panel(
      title = "Análise de Agrupamentos (Clustering)",
      icon = icon("bezier-curve"),
      mod_analise_registravel_ui(
        "fluxo_hca",
        tagList(
          mod_seletor_base_analise_ui("base_hca"),
          mod_hca_ui("hca")
        ),
        mod_registrar_execucao_ui("registrar_hca")
      )
    ),
    # Reserve k-means como percurso próprio, sem apresentar cálculo antes da implementação.
    # PENDENCIA-V2: implementar k-means (hoje é só tela provisória).
    nav_panel(
      title = "Agrupamentos por k-means",
      icon = icon("bullseye"),
      tagList(
        tags$h2("Agrupamentos por k-means", class = "h4 mb-2"),
        div(
          class = "alert alert-light border",
          icon("compass"), " Esta opção está reservada para uma próxima etapa. Ela permitirá propor um número de grupos e examinar a separação entre observações numéricas, com padronização quando as unidades forem diferentes."
        )
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Comparar grupos")),
    nav_panel(
      title = "PERMANOVA",
      icon = icon("diagram-project"),
      # PENDENCIA-V2: implementar PERMANOVA (abas: Distância e ordenação, Dispersões, Teste global, Comparações par a par, Espécies que explicam).
      em_preparacao(
        "PERMANOVA",
        "As comunidades ou os perfis diferem entre os grupos?",
        "Compara grupos usando uma matriz de distâncias (Bray-Curtis, por exemplo), com teste por permutação. Verifica antes se os grupos têm dispersões parecidas e aceita mais de um fator. Exige dados em matriz de espécies por amostra."
      )
    )
  ),

  # 11. Mapear e Analisar (antigo "Mapas"): mesma posição na barra, dois grupos.
  # O mapa de estações foi para Planejando a Pesquisa > Onde amostrar.
  # Itens marcados "em preparação" guardam o lugar dos módulos que ainda virão.
  nav_menu(
    title = HTML("Mapear e<br>Analisar"),
    icon = icon("map", class = "cor-menu-mapas"),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Mapeando valores")),
    nav_panel(
      title = "Coroplético (Brasil por Estado)",
      icon = icon("map-location-dot"),
      mod_mapa_ui("mapa")
    ),
    nav_panel(
      title = "Bolhas proporcionais",
      icon = icon("circle-dot"),
      mod_mapa_pontos_ui("mapa_bolhas", "bolhas")
    ),
    nav_panel(
      title = "Densidade de ocorrências",
      icon = icon("fire"),
      mapas_em_preparacao(
        "Densidade de ocorrências",
        "Onde se concentram os registros de ocorrência ou de captura?",
        "Mostra as áreas com mais registros quando há muitos pontos. A concentração também reflete onde houve mais esforço de coleta, então a leitura deve considerar o esforço. O módulo já existe (mod_mapa_densidade.R) e será ligado aqui."
      )
    ),
    nav_item(div(class = "dropdown-header fw-bold text-uppercase small", "Analisando o espaço")),
    nav_panel(
      title = "Dependência espacial",
      icon = icon("circle-nodes"),
      mapas_em_preparacao(
        "Dependência espacial",
        "Pontos vizinhos se parecem? Posso tratar as observações como independentes?",
        "Calcula o índice de Moran, com teste por permutação, e mostra o variograma empírico. Se os vizinhos se parecem, tratar os pontos como independentes subestima a variação, o que é uma forma de pseudorreplicação."
      )
    ),
    nav_panel(
      title = "Ambiente nos pontos",
      icon = icon("temperature-half"),
      mapas_em_preparacao(
        "Ambiente nos pontos",
        "O ambiente (temperatura, clorofila, profundidade) ajuda a explicar a variação?",
        "Coloca a camada ambiental como contexto dos pontos de coleta e extrai o valor em cada estação, criando uma coluna nova para uma análise seguinte (regressão ou ANOVA). Aproveitará o módulo mod_mapa_raster.R."
      )
    )
  ),

  # O Laboratório transversal aparece antes da etapa final de Comunicação.
  # Os itens ficam em grupos por pergunta; alguns reúnem variações em abas (segunda faixa).
  do.call(nav_menu, c(
    list(title = HTML("Laboratório<br>de Conceitos"), icon = icon("flask", class = "cor-menu-laboratorio")),
    laboratorio_paineis()
  )),

  # Comunicação encerra o percurso; Ajuda e Sobre ficam nos ícones à direita.
  nav_menu(
    title = HTML("Comunicação<br>de Resultados"),
    icon = icon("file-export", class = "cor-menu-comunicacao"),
    nav_panel(
      title = "Projeto de Comunicação",
      icon = icon("file-export"),
      mod_comunicacao_ui("comunicacao")
    )
  ),

  # Spacer to push Ajuda and Sobre to the right
  nav_spacer(),
  
  # 13. Ajuda de Uso
  nav_panel(
    title = "Ajuda",
    icon = icon("circle-info"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Navegação da Ajuda",
        width = 320,
        textInput("help_search", label = NULL, placeholder = "🔍 Buscar na ajuda...", width = "100%"),
        uiOutput("help_topics_list_ui")
      ),
      uiOutput("help_content_display")
    )
  ),
  
  # 14. Sobre a IDE
  nav_panel(
    title = "Sobre",
    icon = icon("university"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Navegação Sobre a IDE",
        width = 320,
        textInput("about_search", label = NULL, placeholder = "🔍 Buscar no Sobre...", width = "100%"),
        uiOutput("about_topics_list_ui")
      ),
      uiOutput("about_content_display")
    )
  ),

  # Identidade CatalyseR na primeira faixa
  nav_item(
    div(
      class = "navbar-slogan-container",
      # Simulação da identidade Trilha, com fundo transparente.
      div(
        class = "navbar-logo-area",
        tags$img(
          src = "logo_trilha_transparente.png",
          class = "navbar-logo-trilha",
          alt = "Trilha — logo com R no hexágono e caminho pontilhado"
        )
      ),
      span(
        "Da pergunta ao relatório, uma só trilha em R.",
        class = "navbar-slogan-trilha"
      )
    )
  )
)
# Servidor (Server)
server <- function(input, output, session) {

  # Reinicializa o selectize do dataset ao mostrar o painel do pacote — sem isto,
  # o selectize nasce dentro de um conditionalPanel oculto e a BUSCA (digitar
  # parte do nome) não funciona. Ao reabrir visível, a busca passa a valer.
  observeEvent(input$data_source, {
    if (identical(input$data_source, "package")) {
      sel <- if (!is.null(input$package_dataset) && nzchar(input$package_dataset)) input$package_dataset else eapa_dataset_default
      updateSelectizeInput(session, "package_dataset",
        choices = eapa_datasets, selected = sel,
        options = list(placeholder = "Digite ou escolha um conjunto de dados...",
                       openOnFocus = TRUE, maxOptions = 100, dropdownParent = "body",
                       onDropdownOpen = I("function($dropdown) { $dropdown.addClass('origem-lista-ampla'); }")),
        server = FALSE)
    }
  }, ignoreInit = TRUE)


  # ==========================================
  # 1. SERVIÇOS DO MÓDULO DE AJUDA DE USO
  # ==========================================
  
  help_topics <- list(
    bases = list(
      title = "Guia — Base Compartilhada e Bases Derivadas",
      keywords = "base compartilhada dados_analise base derivada ramo receita massa pizza forno preparo agrupar sumarizar comunicação",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Da massa compartilhada à pizza servida</h4>
        <p>Pense nos dados importados como os ingredientes que chegam à cozinha. O preparo comum produz uma <b>massa-base</b> confiável: a <b>Base Compartilhada</b>, cujo nome técnico é <code>dados_analise</code>.</p>
        <p>Quando uma análise pede algo específico, separamos uma porção dessa massa e criamos uma <b>Base Derivada</b>. Adicionar à receita inclui apenas nessa porção os tratamentos necessários — como um filtro, uma dicotomização ou uma padronização. A massa compartilhada e os outros ramos não mudam.</p>
        <p><b>Recalcular</b> prepara a porção e permite conferi-la; <b>Finalizar preparo</b> declara que ela está pronta; executar a <b>análise</b> é levá-la ao forno; e a <b>Comunicação de Resultados</b> serve a pizza, acompanhada da receita e do modo de preparo para preservar a reprodutibilidade.</p>
        <div class='alert alert-info'><b>Pergunta que decide:</b> todas as análises deveriam receber esta mudança? Se sim, ela pertence à Base Compartilhada. Se servir apenas a uma finalidade, crie uma Base Derivada.</div>
        <ol>
          <li>Importe e organize os dados que serão comuns ao projeto.</li>
          <li>Use <b>Preparar Base Compartilhada</b> para registrar os tratamentos compartilhados.</li>
          <li>Abra <b>Preparar Dados → Preparar Bases Derivadas</b> para criar preparos específicos.</li>
          <li>Ordene a receita, recalcule a base e confira a prévia e o código R.</li>
          <li>Finalize o preparo e escolha a base apropriada no módulo de análise.</li>
        </ol>
        <p>Todas as porções nascem diretamente da mesma massa-base: Bases Derivadas não podem nascer de outras Bases Derivadas. Assim, a topologia permanece em estrela.</p>
      ")
    ),
    flow = list(
      title = "1. Fluxo de Trabalho",
      keywords = "ide_r trilha andaimes visuais paradigma ensino aprendizagem fluxo trabalho",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Fluxo de Trabalho Recomendado</h4>
        <p>A Trilha guia você através de uma jornada visual para a realização de análises estatísticas reprodutíveis. Para tirar o máximo proveito da IDE, siga este fluxo:</p>
        <ol>
          <li><b>Importação de Dados:</b> Carregue e prepare seus dados no menu <b>Preparando Dados</b>. Certifique-se de ajustar a tipagem das colunas se necessário.</li>
          <li><b>Análise Exploratória e Modelagem:</b> Em <i>Explorando os Dados</i>, conheça a planilha, as variáveis e as relações antes de escolher um teste. A Trilha sugere um caminho; você decide e pode guardar cada resultado em <i>Inserir análise</i>.</li>
          <li><b>Projeto R:</b> Abra o menu <i>Comunicação de Resultados</i> para reunir as análises e exportar o projeto.</li>
        </ol>
      ")
    ),
    import = list(
      title = "2. Importação e Tipagem",
      keywords = "carregar ler csv excel xlsx eapadados converter tipo coluna numeric factor character date tipagem",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Importação e Preparação de Dados</h4>
        <p>Para iniciar suas análises, o primeiro passo é carregar um conjunto de dados. A IDE suporta:</p>
        <ul>
          <li><b>Arquivos Locais:</b> Planilhas Excel (.xlsx, .xls) ou arquivos de texto delimitados (.csv). Você pode escolher a aba específica no Excel ou configurar o cabeçalho e separadores decimais no CSV.</li>
          <li><b>Pacotes de Exemplo:</b> Datasets didáticos inclusos no pacote científico R 'EAPADados'.</li>
        </ul>
        <p><b>Tipagem de Variáveis:</b> Na barra lateral esquerda (após carregar o arquivo), você verá uma tabela listando cada coluna e seu tipo de dado atual. Você pode alterar a tipagem de forma interativa (ex: converter para <i>numeric</i>, <i>factor</i>, <i>character</i> ou <i>Date</i>) para garantir a consistência das suas análises.</p>
        <p><b>Filtrar Dados (coluna <i>Filtro</i>):</b> Cada coluna ganha um botão <b>Filtrar</b> adequado ao seu tipo. Para <i>factor</i>, abre uma janela com os níveis da variável (ex.: <i>Macho</i>/<i>Fêmea</i>); ao desmarcar um nível, as linhas correspondentes são removidas. Para <i>numeric</i>/<i>integer</i>, abre um controle deslizante de faixa (mínimo–máximo); apenas os valores dentro do intervalo escolhido são mantidos. Em ambos os casos o efeito é em tempo real e vale para <b>todas</b> as análises. O botão sinaliza quando há filtro ativo (ex.: <i>1/2</i> para níveis, <i>Faixa</i> para intervalos), e todos os filtros são reiniciados ao carregar um novo conjunto de dados.</p>
      ")
    ),
    descr = list(
      title = "3. Estatística Descritiva",
      keywords = "média mediana desvio padrão variância resumo tabela descrever dados estatistica descritiva",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Estatística Descritiva</h4>
        <p>Em <b>Explorando os Dados > Conhecer as Variáveis</b>, você começa pelo retrato recomendado e abre mais medidas apenas quando precisar.</p>
        <p><b>Principais Recursos:</b></p>
        <ul>
          <li><b>Primeiro olhar:</b> Explorar Dataset mostra estrutura, tipos sugeridos e dados faltantes.</li>
          <li><b>Uma variável por vez:</b> a IDE sugere frequências e barras para categóricas; centro, dispersão e distribuição para numéricas. Para comparar grupos, use Encontrar Relações. Transformar Variáveis compara alternativas sem alterar a base.</li>
          <li><b>Resultados independentes:</b> Troque a variável e execute novamente. Na aba Inserir análise, escolha qual resultado adicionar ao Projeto R. As opções anteriores ficam disponíveis enquanto a base não mudar.</li>
        </ul>
      ")
    ),
    hist = list(
      title = "4. Histogramas",
      keywords = "histograma frequência densidade distribuição bins classes cor tema grafico",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Gráficos de Histograma</h4>
        <p>Em <b>Explorando os Dados > Conhecer as Variáveis</b>, examine a forma da distribuição de uma variável numérica no retrato recomendado.</p>
        <p><b>Customizações Disponíveis:</b></p>
        <ul>
          <li><b>Classes (Bins):</b> Ajuste o número de barras para melhorar o detalhamento do gráfico.</li>
          <li><b>Polígono:</b> A linha conecta os pontos médios das mesmas classes usadas pelas barras.</li>
          <li><b>Densidade:</b> A estimativa KDE tem sua própria sub-aba, com largura de banda informada.</li>
          <li><b>Código:</b> Consulte o R de cada análise na tela e personalize o gráfico no projeto exportado.</li>
        </ul>
      ")
    ),
    boxplot = list(
      title = "5. Boxplot (Diagrama de Caixa)",
      keywords = "boxplot caixa outliers dispersão jitter pontos agrupar cor preenchimento",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Diagrama de Caixa (Boxplot)</h4>
        <p>Em <b>Explorando os Dados > Encontrar Relações</b>, compare grupos antes do teste. Pontos sinalizados merecem investigação, não exclusão automática.</p>
        <p><b>Destaques da Trilha:</b></p>
        <ul>
          <li><b>Apresentação:</b> Escolha boxplot, violino ou ambos.</li>
          <li><b>Por grupo:</b> Use <i>Relações > Comparações por grupo</i> para separar a variável por um fator, como sexo, espécie ou local.</li>
          <li><b>Verificação:</b> Em <i>Pressupostos</i>, consulte normalidade, outliers e sugestões de transformação. Nenhuma transformação é aplicada automaticamente.</li>
        </ul>
      ")
    ),
    reg = list(
      title = "6. Regressão Linear",
      keywords = "regressão linear reta ajuste lm resíduos diagnóstico normalidade q-q modelos regressao",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Modelos de Regressão Linear Simples</h4>
        <p>Disponível no menu <b>Modelos de Regressão > Regressão Linear Simples</b>, este módulo permite ajustar um modelo para avaliar a influência de uma variável preditora (X) sobre uma variável resposta (Y).</p>
        <p><b>O que é gerado na tela e nos scripts:</b></p>
        <ul>
          <li><b>Equação do Modelo:</b> Reta calculada exibida dinamicamente no título.</li>
          <li><b>Coeficientes e Ajuste Global:</b> Tabelas interativas de coeficientes (estimativa, erro padrão, valor t, p-valor) e métricas globais (R-quadrado, erro padrão dos resíduos).</li>
          <li><b>Diagnóstico Gráfico:</b> Gráficos de Resíduos vs Ajustados e Normal Q-Q Plot integrados, fundamentais para a validação dos pressupostos do modelo estatístico.</li>
        </ul>
      ")
    ),
    export = list(
      title = "7. Exportação de Projetos",
      keywords = "exportar zip comunicacao resultados nome dataset projeto rproj quarto qmd download individual unica",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Tipos de Exportação de Projetos</h4>
        <p>Na Trilha, você encontrará dois tipos de exportadores de código, com objetivos didáticos distintos:</p>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>1. Projeto R da Comunicação de Resultados</h5>
        <p>Ideal para quando você conclui sua sessão de estudos ou para a entrega de relatórios e trabalhos práticos completos. No menu <b>Comunicação de Resultados</b>, o botão <b>Baixar Projeto R (.zip)</b> reúne as análises da sessão:</p>
        <ul>
          <li><b>Execuções registradas:</b> O Projeto R preserva todas as execuções que você registrou; o relatório segue a seleção editorial que você fez na tela.</li>
          <li><b>Dependências em dia:</b> A tela avisa quando alguma execução precisa ser atualizada antes da exportação.</li>
          <li><b>Relatório no RStudio:</b> O projeto traz o script de análise e o relatório Quarto (.qmd) na pasta <i>relatorios/</i>; o Word nasce no seu RStudio, quando você clica em Render.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>2. Exportação de Análise Única (Dentro de cada aba/análise específica)</h5>
        <p>Perfeita para quando você deseja focar exclusivamente no estudo isolado de uma única técnica estatística (ex: apenas o boxplot ou apenas a regressão linear), sem carregar códigos de outras análises:</p>
        <ul>
          <li><b>Foco Total:</b> Gera um pacote contendo apenas o script específico daquela análise (ex: <i>boxplot.R</i> ou <i>regressao.R</i>) e um relatório Quarto exclusivo daquele gráfico ou modelo.</li>
          <li><b>Facilidade de Estudo:</b> Excelente para entender a lógica e depurar os andaimes visuais de código passo a passo, sem misturar múltiplos tópicos de estudo.</li>
        </ul>
        <p>Ambos os formatos geram a pasta <i>dados/</i> com os seus dados e um arquivo <i>.Rproj</i> para abrir todo o ambiente de forma automática localmente no RStudio.</p>
      ")
    ),
    packages = list(
      title = "8. Pacotes R & Tidyverse",
      keywords = "pacotes tidyverse read_csv instalar ggplot2 readr library install.packages programacao r writexl readxl",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Pacotes R e o Ecossistema Tidyverse</h4>
        <p>A programação moderna em R baseia-se amplamente no <b>Tidyverse</b>, uma coleção de pacotes projetados para ciência de dados. Nossos scripts utilizam ferramentas desse ecossistema para facilitar e padronizar seu aprendizado.</p>
        
        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>Como Instalar os Pacotes Necessários</h5>
        <p>Para executar os scripts e compilar os relatórios localmente no RStudio, certifique-se de que os pacotes necessários estejam instalados. Execute os comandos abaixo no Console do RStudio:</p>
        <pre><code class='language-r'># Instalação do Tidyverse completo (inclui readxl, ggplot2, etc.)
install.packages(\"tidyverse\")

# Pacotes adicionais necessários para manipulação de planilhas e relatórios:
install.packages(\"readxl\")
install.packages(\"writexl\")
install.packages(\"flextable\")
install.packages(\"officer\")
install.packages(\"knitr\")</code></pre>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>Principais Pacotes Utilizados no Projeto</h5>
        <ul>
          <li><b>readxl:</b> Utilizado para carregar planilhas eletrônicas do Excel (.xlsx) para o ambiente de análise.</li>
          <li><b>writexl:</b> Utilizado para exportar planilhas Excel organizadas de forma limpa, permitindo criar metadados (como o Dicionário de Variáveis).</li>
          <li><b>ggplot2:</b> O padrão para criação de gráficos estatísticos e científicos de alta qualidade.</li>
          <li><b>knitr, flextable e officer:</b> Pacotes utilizados na formatação de tabelas e geração automatizada de relatórios em Word (.docx).</li>
        </ul>
      ")
    ),
    formats = list(
      title = "9. Formatos de Dados (CSV, XLSX, RDA)",
      keywords = "csv xlsx rda formato dados extensao diferença importar exportar dicionario",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Formatos de Dados Exportados</h4>
        <p>Para que você compreenda o fluxo de trabalho real de um pesquisador, a IDE exporta seus dados limpos e tipados em três formatos diferentes dentro da pasta <code>dados/</code>. Cada um possui vantagens e propósitos específicos:</p>
        
        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>1. Planilha Excel (.xlsx)</h5>
        <ul>
          <li><b>O que é:</b> É o formato mais popular no meio científico para visualização e edição manual de dados.</li>
          <li><b>Como é gerado:</b> A IDE cria duas abas (sheets) neste arquivo:
            <ul>
              <li><b>Dados:</b> Os dados propriamente ditos no formato <i>tidy</i> (limpos, onde cada linha é uma observação e cada coluna é uma variável).</li>
              <li><b>Dicionario_Variaveis:</b> Um dicionário de metadados listando todas as variáveis, seus tipos de dados e explicações sobre o significado ecológico ou experimental de cada coluna.</li>
            </ul>
          </li>
          <li><b>Uso no R:</b> Carregado usando a biblioteca <code>readxl</code>: <code>readxl::read_excel('dados/dados_limpos.xlsx', sheet = 'Dados')</code>.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>2. Arquivo CSV (.csv)</h5>
        <ul>
          <li><b>O que é:</b> Um formato universal, aberto e em texto simples (Comma-Separated Values). É lido por praticamente qualquer ferramenta de banco de dados ou linguagem de programação no mundo.</li>
          <li><b>Uso no R:</b> Carregado nativamente com <code>read.csv()</code> ou via Tidyverse com <code>readr::read_csv()</code>.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>3. Arquivo RData (.rda)</h5>
        <ul>
          <li><b>O que é:</b> Formato nativo e binário do R. Salva o objeto exatamente como ele estava na memória da IDE. Preserva todas as tipagens finas que outros formatos perdem, como a ordenação interna de fatores categóricos (sexo, tratamentos) e formatos de data.</li>
          <li><b>Uso no R:</b> Carregado instantaneamente com o comando <code>load('dados/dados_limpos.rda')</code>.</li>
        </ul>
      ")
    )
  )
  
  selected_help_topic <- reactiveVal("flow")
  
  filtered_help_topics <- reactive({
    query <- trimws(tolower(input$help_search))
    if (is.null(query) || !nzchar(query)) {
      return(help_topics)
    }
    
    matches <- sapply(help_topics, function(topic) {
      grepl(query, tolower(topic$title)) || grepl(query, tolower(topic$keywords))
    })
    
    help_topics[matches]
  })
  
  observe({
    topics <- filtered_help_topics()
    req(length(topics) > 0)
    current <- selected_help_topic()
    if (!(current %in% names(topics))) {
      selected_help_topic(names(topics)[1])
    }
  })
  
  observe({
    lapply(names(help_topics), function(id) {
      observeEvent(input[[paste0("help_btn_", id)]], {
        selected_help_topic(id)
      })
    })
  })
  
  output$help_topics_list_ui <- renderUI({
    topics <- filtered_help_topics()
    if (length(topics) == 0) {
      return(p("Nenhum tópico encontrado.", style = "color: #dc3545; font-style: italic; margin-top: 10px; font-size: 0.85rem;"))
    }
    
    current <- selected_help_topic()
    
    tags$div(
      class = "list-group help-list-group",
      style = "margin-top: 10px; border-radius: 8px; overflow: hidden;",
      lapply(names(topics), function(id) {
        is_active <- (id == current)
        actionButton(
          inputId = paste0("help_btn_", id),
          label = topics[[id]]$title,
          class = paste0("list-group-item list-group-item-action", if (is_active) " active" else ""),
          style = paste0(
            "text-align: left; border: 1px solid rgba(0,0,0,0.08); font-size: 0.85rem; font-weight: 500; padding: 10px 12px;",
            if (is_active) " background-color: #0d6efd; color: white;" else " background-color: white; color: #495057;"
          )
        )
      })
    )
  })
  
  output$help_content_display <- renderUI({
    topic_id <- selected_help_topic()
    req(topic_id %in% names(help_topics))
    
    topic <- help_topics[[topic_id]]
    
    card(
      card_header(
        topic$title, 
        style = "background-color: rgba(13, 110, 253, 0.05); color: #0d6efd; font-weight: 700; font-family: 'Outfit', sans-serif; font-size: 1.1rem; padding: 12px 15px;"
      ),
      card_body(
        style = "padding: 22px; min-height: 400px; line-height: 1.6;",
        topic$content
      )
    )
  })
  
  # ==========================================
  # 2. SERVIÇOS DO MÓDULO "SOBRE A IDE"
  # ==========================================
  
  about_topics <- list(
    intro = list(
      title = "1. Introdução e Filosofia",
      keywords = "ide_r trilha barreira sintaxe frustracao graducao posgraduacao ufpa estresse origem nome estudio",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>A Barreira da Sintaxe e o Estresse no Aprendizado</h4>
        <p>O ensino de Estatística Aplicada para cursos de graduação e pós-graduação que não pertencem à área da computação (como Ciências Biológicas, Agronomia, Ciências da Saúde) enfrenta um dilema clássico. O aprendizado da linguagem de programação frequentemente cria uma barreira de entrada muito alta devido a erros de digitação de sintaxe (como parênteses esquecidos, aspas erradas ou caminhos locais incorretos), fazendo com que alunos se frustrem e desistam antes mesmo de conseguirem interpretar os resultados estatísticos.</p>
        <p>A <b>Trilha</b>, desenvolvida na <b>UFPA (Universidade Federal do Pará)</b>, rompe essa barreira ao colocar o estudante no controle conceitual. Criada especificamente para abrir caminho ao aprendizado e às análises com R, ela visa reduzir drasticamente o estresse e a frustração dos estudantes ao utilizar a metodologia pedagógica de <i>Andaimes Visuais</i> e <i>Engenharia Reversa</i>.</p>
        
        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 20px;'>A Origem do Nome \"Trilha\"</h5>
        <p>O nome diz o que a ferramenta é: uma trilha de análise, da pergunta ao relatório.</p>
        <ul>
          <li><b>Um caminho ordenado:</b> O estudante planeja a coleta, prepara os dados, explora, analisa e comunica, nessa ordem. Cada passo deixa rastro em código R, e o rastro inteiro vira o Projeto R exportado.</li>
          <li><b>Jeito de estúdio:</b> A Trilha reúne pesquisa, análise e escrita num só lugar, como um estúdio, sem precisar de \"Studio\" no nome.</li>
          <li><b>O pacote:</b> No R, a Trilha é o pacote <code>trilha</code>, em minúsculas, como se digita em <code>library(trilha)</code>.</li>
        </ul>
        <p style='text-align: center; font-style: italic;'>Da pergunta ao relatório, uma só trilha de análise.</p>

        <div style='text-align: center; margin-top: 25px; border-top: 1px solid #dee2e6; padding-top: 15px;'>
          <span style='font-size: 0.9rem; color: #6c757d; font-weight: 600; margin-right: 12px; vertical-align: middle;'>Desenvolvido com:</span>
          <a href='https://shiny.posit.co/' target='_blank' style='text-decoration: none;'>
            <img src='https://shiny.posit.co/images/shiny-logo.png' height='42px' style='vertical-align: middle; opacity: 0.95;'
                 onerror='this.onerror=null; this.src=\"https://raw.githubusercontent.com/rstudio/shiny/main/man/figures/logo.png\";'>
          </a>
        </div>
      ")
    ),
    scaffolding = list(
      title = "2. Andaimes Visuais",
      keywords = "paradigma visual scaffolding passos exploracao visual engenharia reversa",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>O Paradigma dos Andaimes Visuais</h4>
        <p>O modelo pedagógico da Trilha baseia-se em 3 passos essenciais:</p>
        <ol>
          <li><b>Passo 1: Exploração Visual.</b> O estudante carrega os dados e ajusta modelos estatísticos e gráficos de forma imediata na tela, validando suas hipóteses visualmente e sem erros de código.</li>
          <li><b>Passo 2: Geração de Código Limpo.</b> A IDE gera de forma automática e transparente os scripts correspondentes a cada decisão tomada em tela.</li>
          <li><b>Passo 3: Engenharia Reversa e Consolidação.</b> O estudante baixa o Projeto R (.zip) e abre no RStudio local, executando linha a linha o código estruturado e modificando os códigos já prontos para observar os resultados correspondentes.</li>
        </ol>
      ")
    ),
    revolutionary = list(
      title = "3. Por que a Trilha?",
      keywords = "revolucionaria tradicional comparacao paradigma tabela ufpa estresse",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Por que essa abordagem é Revolucionária?</h4>
        <p>Veja como o paradigma dos Andaimes Visuais da Trilha inverte a frustração e diminui o estresse do aprendizado de R:</p>
        <table class='table table-striped table-bordered table-sm' style='margin-top: 15px; font-size: 0.9rem;'>
          <thead>
            <tr>
              <th>Aspecto</th>
              <th>Abordagem Tradicional</th>
              <th>O Paradigma da Trilha (UFPA)</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><b>Ponto de Partida</b></td>
              <td>Tela preta/prompt vazio.</td>
              <td>Exploração visual com geração de código correspondente.</td>
            </tr>
            <tr>
              <td><b>Lidando com Erros</b></td>
              <td>Foco em depurar sintaxe e erros de digitação.</td>
              <td>Código garantido livre de erros, pronto para rodar.</td>
            </tr>
            <tr>
              <td><b>Nível de Estresse</b></td>
              <td>Alto (sensação de impotência frente a erros de código).</td>
              <td>Baixo (foco na lógica científica e interpretação de dados).</td>
            </tr>
            <tr>
              <td><b>Estrutura de Trabalho</b></td>
              <td>Arquivos desorganizados e soltos.</td>
              <td>Estrutura profissional de pastas (dados/, scripts/, relatorios/).</td>
            </tr>
          </tbody>
        </table>
      ")
    ),
    structure = list(
      title = "4. Estrutura do Pacote",
      keywords = "estrutura arquivos rproj rda csv script qmd quarto rstudio",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Estrutura de Cada Componente Gerado</h4>
        <p>Os projetos baixados na Trilha possuem uma estrutura padronizada e profissional:</p>
        <ul>
          <li><b>projeto_analise.Rproj:</b> Dando duplo clique neste arquivo, o RStudio abre automaticamente configurado com a pasta de trabalho correta, dispensando comandos complicados como <i>setwd()</i>.</li>
          <li><b>dados/dados_limpos.rda e csv:</b> Arquivos de dados limpos gerados nativamente pela IDE, garantindo formatação correta de decimais e evitando problemas de importação.</li>
          <li><b>scripts/descrever.R / regressao.R:</b> Scripts R com sintaxe limpa e amplamente comentada para reproduzir localmente os resultados da tela.</li>
          <li><b>relatorios/relatorio.qmd:</b> Relatório estruturado em Quarto Markdown (.qmd) pronto para gerar apresentações em HTML, Word ou PDF com um clique.</li>
        </ul>
      ")
    ),
    deployment = list(
      title = "5. Como Rodar e Implantar",
      keywords = "rodar executar implantar rstudio pacote instalar shiny server nuvem deploy local",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>Como Rodar e Implantar a Trilha</h4>
        <p>Como uma ferramenta pedagógica, existem três formas principais de disponibilizar a Trilha para estudantes e pesquisadores, cada uma atendendo a um nível de maturidade técnica:</p>
        
        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>1. Nuvem/Servidor Web (A mais elegante e sem barreiras)</h5>
        <p>A melhor abordagem de todas é hospedar o aplicativo em um servidor web (como <b>Shiny Server</b>, <b>Shinyapps.io</b> ou <b>Posit Connect</b>).</p>
        <ul>
          <li><b>Como funciona:</b> A instituição de ensino hospeda a IDE em seu servidor. Os alunos acessam diretamente pelo navegador através de um link (ex: <i>https://trilha.suauniversidade.edu</i>).</li>
          <li><b>Vantagem pedagógica:</b> <b>Zero instalação inicial.</b> O estudante não precisa ter R ou RStudio instalado no primeiro dia de aula. Ele carrega seus dados e explora conceitos estatísticos de imediato. Após validar suas análises visualmente, baixa o arquivo ZIP e inicia o estudo local no RStudio.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>2. Empacotamento em Pacote R (A mais portátil e offline)</h5>
        <p>A Trilha já é distribuída como pacote de R, chamado <code>trilha</code>, no GitHub.</p>
        <ul>
          <li><b>Como funciona:</b> O usuário instala o pacote uma vez e, depois, abre a IDE com um comando:
            <pre style='background: #f1f3f5; padding: 8px; border-radius: 6px; font-size: 0.85rem;'>install.packages(\"pak\")
pak::pkg_install(\"cluberufpa/trilha\", upgrade = FALSE)
trilha::run_app(launch.browser = TRUE)</pre>
          </li>
          <li><b>Vantagem pedagógica:</b> Serve como um excelente passo intermediário de transição, onde o aluno executa um comando simples para abrir a interface em sua própria máquina, offline, familiarizando-se com o terminal do RStudio.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>3. Execução Direta via RStudio (A melhor para desenvolvimento)</h5>
        <p>Baixar a pasta do projeto (ou clonar via Git) e abrir diretamente no RStudio local.</p>
        <ul>
          <li><b>Como funciona:</b> O usuário abre a pasta no RStudio, abre o arquivo <code>app.R</code> e clica no botão <b>\"Run App\"</b> no canto superior direito do editor, ou executa no console:
            <pre style='background: #f1f3f5; padding: 8px; border-radius: 6px; font-size: 0.85rem;'>shiny::runApp()</pre>
          </li>
          <li><b>Vantagem pedagógica:</b> Ideal para professores ou alunos interessados em entender a arquitetura do próprio Shiny, permitindo que eles editem o código e customizem novos módulos ou estilos para a Trilha.</li>
        </ul>

        <hr>
        <p><b>Recomendação Pedagógica:</b> A abordagem híbrida é a mais elegante. Disponibilize a <b>Trilha na nuvem (Opção 1)</b> para as aulas teóricas e práticas iniciais. À medida que os alunos ganham autonomia executando localmente os códigos do ZIP exportado, incentive-os a instalar a ferramenta em suas próprias máquinas usando as <b>Opções 2 ou 3</b>.</p>
      ")
    ),
    pedagogical_cycle = list(
      title = "6. O Ciclo Científico e os Três Tripés",
      keywords = "ciclo cientifico tripe pedagogico tripes planejamento experimental amostral script comunicacao artigo relatorio quarto qmd",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>O Ciclo Científico e os Três Tripés Pedagógicos</h4>
        <p>A Trilha foi concebida não apenas como uma ferramenta para gerar códigos de forma automática, mas como um elemento de integração para um ciclo completo de aprendizado científico, estruturado sobre <b>três pilares essenciais (os três tripés)</b>:</p>
        
        <ol style='line-height: 1.6; margin-top: 15px;'>
          <li><b>Pilar 1: Obtenção Rigorosa de Dados (Planejamento)</b>
            <br>Toda pesquisa de qualidade começa antes da análise de dados propriamente dita. O estudante deve desenhar e executar um rigoroso <b>Planejamento de Coleta Amostral</b> ou um sólido <b>Planejamento Experimental</b>. Esta etapa de coleta estruturada constitui a base metodológica de seu artigo ou relatório de pesquisa.
          </li>
          <li style='margin-top: 10px;'><b>Pilar 2: Análise Estatística Rigorosa com Scripts R (Execução)</b>
            <br>Utilizando a IDE, o estudante realiza explorações visuais interativas, obtendo como resultado um projeto R completo contendo scripts R limpos e comentados. O aluno abre esse projeto localmente no RStudio e executa os scripts linha a linha, testando os pressupostos do modelo estatístico (ex: normalidade, resíduos, homocedasticidade) de forma rigorosa e reprodutível.
          </li>
          <li style='margin-top: 10px;'><b>Pilar 3: Comunicação Científica de Resultados (Divulgação)</b>
            <br>A ciência só está completa quando comunicada de forma clara. Utilizando o relatório Quarto (.qmd) que acompanha o Projeto R exportado, o estudante produz um <b>Relatório Científico Final</b> elegante no formato de um artigo, contendo a contextualização, a metodologia de amostragem/experimento, o código R com a análise de dados e a interpretação científica dos principais resultados.
          </li>
        </ol>
        
        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 20px;'>Fechando o Ciclo Pedagógico e Científico</h5>
        <p>A produção do <b>Projeto R</b> exportado integra-se de forma direta com a <b>Comunicação de Resultados</b>. Ao abrir o relatório Quarto da pasta <code>relatorios/</code> no RStudio local, o estudante é encorajado a preencher as seções de Metodologia (detalhando o Planejamento Amostral/Experimental do Pilar 1) e Introdução ao lado das saídas automáticas do Pilar 2. Isso simula com fidelidade o fluxo real de redação de um artigo científico em revistas de alto impacto, consolidando a ponte entre o planejamento rigoroso, a análise de dados e a comunicação acadêmica.</p>
      ")
    ),
    t_dist_visual = list(
      title = "7. Visualização de Regiões Críticas",
      keywords = "distribuicao t student regiao critica rejeicao t calculado critico p-valor hipóteses didatico plus curva caudas",
      content = HTML("
        <h4 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 700;'>O Plus Didático: Curva de Distribuição Teórica Interativa</h4>
        <p>No ensino clássico de bioestatística e testes de hipóteses, um dos maiores desafios pedagógicos é a abstraction da tomada de decisão. Alunos frequentemente decoram regras como <i>\"p-valor menor que alfa rejeita H0\"</i> ou <i>\"t calculado maior que t tabelado rejeita H0\"</i>, mas sem compreender o significado geométrico e probabilístico dessas relações.</p>
        <p>Para preencher essa lacuna, a Trilha introduz uma ferramenta visual avançada: a <b>Visualização Gráfica da Distribuição t de Student Teórica</b>, permitindo o confronto imediato entre a teoria probabilística e os dados observados.</p>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>1. Objetivos Pedagógicos</h5>
        <ul>
          <li><b>Geometrizar a Decisão Estatística:</b> O aluno observa fisicamente onde a estatística amostral está localizada na curva de distribuição de probabilidade sob a hipótese nula.</li>
          <li><b>Compreensão Visual de Hipóteses Unilaterais e Bilaterais:</b> A área sombreada se ajusta instantaneamente caso o teste seja bilateral (duas caudas vermelhas de tamanho &alpha;/2) ou unilateral (uma cauda vermelha à esquerda ou à direita de tamanho &alpha;).</li>
          <li><b>Entendimento Intuitivo do p-valor:</b> Se a linha vertical azul (t experimental) cair na área vermelha (região de rejeição), fica evidente que a probabilidade de obter um valor tão extremo ou mais extremo sob a hipótese nula é menor que a significância adotada (&alpha;).</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>2. Como Foi Desenvolvido (Lógica Técnica no R)</h5>
        <p>Em vez de depender de pacotes externos complexos (como o <i>vistributions</i>, que pode exigir compilação ou falhar em ambientes restritos), a visualização foi programada utilizando a biblioteca principal <code>ggplot2</code> combinada com funções internas de probabilidade do R:</p>
        <ul>
          <li><b>Cálculo da Densidade:</b> A curva de densidade t é calculada dinamicamente com base nos graus de liberdade (df) do teste através da função de densidade <code>dt(x, df)</code>.</li>
          <li><b>Determinação dos Limites Críticos:</b> Os pontos de corte exatos que definem a fronteira da região de rejeição (t<sub>crit</sub>) são encontrados de forma dinâmica por meio da função de quantil <code>qt(p, df)</code>, onde p depende do nível de significância &alpha; e do sentido da hipótese alternativa.</li>
          <li><b>Sombreamento da Região de Rejeição:</b> A área crítica sob a curva é preenchida em vermelho translúcido utilizando a função <code>geom_area()</code> aplicada a subconjuntos filtrados de dados (ex: x &le; t<sub>crit</sub> ou x &ge; t<sub>crit</sub>).</li>
          <li><b>Plote do t Experimental (Amostral):</b> Uma linha azul sólida espessa (<code>geom_vline()</code>) marca o valor exato do t calculado, identificada com uma etiqueta branca (<code>annotate(\"label\")</code>) contendo o valor exato da estatística.</li>
          <li><b>Escalonamento Automático dos Eixos:</b> Para evitar que valores extremamente elevados de t calculado fiquem de fora do gráfico, a escala do eixo X é ajustada dinamicamente com base no valor de t<sub>calc</sub>: <code>max(4.5, abs(t_calc) + 1.5)</code>.</li>
        </ul>

        <h5 class='text-primary' style='font-family: \"Outfit\", sans-serif; font-weight: 600; margin-top: 15px;'>3. Integração com a Filosofia da Trilha</h5>
        <p>Mantendo o paradigma dos <i>Andaimes Visuais</i>, toda essa lógica de plotagem não é apenas exibida na tela. O código completo do ggplot2 que desenha a curva, calcula as caudas e adiciona as marcações críticas é <b>gerado automaticamente e exportado</b> como parte do script R do teste t. Isso permite que o aluno execute o código em seu próprio RStudio local, estude como manipular funções de densidade em gráficos e personalize a curva para seus próprios relatórios.</p>
      ")
    )
  )
  
  selected_about_topic <- reactiveVal("intro")
  
  filtered_about_topics <- reactive({
    query <- trimws(tolower(input$about_search))
    if (is.null(query) || !nzchar(query)) {
      return(about_topics)
    }
    
    matches <- sapply(about_topics, function(topic) {
      grepl(query, tolower(topic$title)) || grepl(query, tolower(topic$keywords))
    })
    
    about_topics[matches]
  })
  
  observe({
    topics <- filtered_about_topics()
    req(length(topics) > 0)
    current <- selected_about_topic()
    if (!(current %in% names(topics))) {
      selected_about_topic(names(topics)[1])
    }
  })
  
  observe({
    lapply(names(about_topics), function(id) {
      observeEvent(input[[paste0("about_btn_", id)]], {
        selected_about_topic(id)
      })
    })
  })
  
  output$about_topics_list_ui <- renderUI({
    topics <- filtered_about_topics()
    if (length(topics) == 0) {
      return(p("Nenhum tópico encontrado.", style = "color: #dc3545; font-style: italic; margin-top: 10px; font-size: 0.85rem;"))
    }
    
    current <- selected_about_topic()
    
    tags$div(
      class = "list-group about-list-group",
      style = "margin-top: 10px; border-radius: 8px; overflow: hidden;",
      lapply(names(topics), function(id) {
        is_active <- (id == current)
        actionButton(
          inputId = paste0("about_btn_", id),
          label = topics[[id]]$title,
          class = paste0("list-group-item list-group-item-action", if (is_active) " active" else ""),
          style = paste0(
            "text-align: left; border: 1px solid rgba(0,0,0,0.08); font-size: 0.85rem; font-weight: 500; padding: 10px 12px;",
            if (is_active) " background-color: #0d6efd; color: white;" else " background-color: white; color: #495057;"
          )
        )
      })
    )
  })
  
  output$about_content_display <- renderUI({
    topic_id <- selected_about_topic()
    req(topic_id %in% names(about_topics))
    
    topic <- about_topics[[topic_id]]
    
    card(
      card_header(
        topic$title, 
        style = "background-color: rgba(13, 110, 253, 0.05); color: #0d6efd; font-weight: 700; font-family: 'Outfit', sans-serif; font-size: 1.1rem; padding: 12px 15px;"
      ),
      card_body(
        style = "padding: 22px; min-height: 400px; line-height: 1.6;",
        topic$content
      )
    )
  })

  # Valores Reativos para carregar e converter o dataset
  raw_data <- reactiveVal(NULL)
  col_types_rv <- reactiveVal(list())
  selected_cols_rv <- reactiveVal(character(0))
  # Filtros de niveis para variaveis fator: lista nomeada col -> niveis mantidos.
  # Ausencia de entrada (ou todos os niveis) = sem filtro.
  level_filters_rv <- reactiveVal(list())
  # Filtros de faixa para variaveis numericas/inteiras: lista nomeada col -> c(min, max).
  # Ausencia de entrada (ou faixa completa) = sem filtro.
  range_filters_rv <- reactiveVal(list())
  # Mapeamento para recodificação/agrupamento de fatores
  col_recodes_rv <- reactiveVal(list())
  # Renomeação opcional de colunas: vetor nomeado nome_antigo -> nome_novo.
  # Vazio por padrão => sem efeito (comportamento idêntico ao anterior).
  col_renames_rv <- reactiveVal(character(0))
  # Ordem das colunas exibidas no modal de renomeação (para ler os inputs).
  rn_import_cols <- reactiveVal(character(0))
  # Registro de observadores criados dinamicamente (evita duplicatas no re-render).
  lvl_obs_registry <- new.env()

  # Quando raw_data muda, inicializamos os tipos de coluna
  observeEvent(raw_data(), {
    df <- raw_data()
    # Reinicia os filtros (niveis e faixas) e agrupamentos a cada novo dataset.
    level_filters_rv(list())
    range_filters_rv(list())
    col_recodes_rv(list())
    if (!is.null(df)) {
      initial_types <- lapply(df, detect_col_type)
      col_types_rv(initial_types)
      selected_cols_rv(names(df))
    } else {
      col_types_rv(list())
      selected_cols_rv(character(0))
    }
  })
  
  # Observador para abrir o modal de seleção de variáveis
  observeEvent(input$select_vars_btn, {
    df <- raw_data()
    req(df)
    all_cols <- names(df)
    selected_cols <- selected_cols_rv()
    if (length(selected_cols) == 0) {
      selected_cols <- all_cols
    }
    
    showModal(modalDialog(
      title = "Selecionar Variáveis do Conjunto",
      tags$p(
        style = "font-size: 0.85rem; color: #6c757d;",
        "Marque as variáveis que deseja manter no conjunto de dados. As desmarcadas serão ocultadas de todas as análises e da tabela de tipagem."
      ),
      checkboxGroupInput(
        inputId = "modal_selected_cols",
        label = NULL,
        choices = all_cols,
        selected = selected_cols
      ),
      footer = tagList(
        actionButton("modal_vars_all", "Selecionar todas",
                     class = "btn btn-sm btn-outline-secondary"),
        modalButton("Cancelar"),
        actionButton("modal_vars_apply", "Aplicar",
                     class = "btn btn-sm btn-primary")
      ),
      easyClose = TRUE,
      size = "s"
    ))
  })
  
  # Observador para marcar todas as variáveis no modal
  observeEvent(input$modal_vars_all, {
    df <- raw_data()
    req(df)
    all_cols <- names(df)
    updateCheckboxGroupInput(session, "modal_selected_cols", selected = all_cols)
  })
  
  # Observador para aplicar a seleção de variáveis do modal
  observeEvent(input$modal_vars_apply, {
    req(input$modal_selected_cols)
    selected_cols_rv(input$modal_selected_cols)
    removeModal()
  })

  # --- Renomear colunas (import) : modal com "nome atual -> nome novo" ---
  observeEvent(input$rename_cols_btn, {
    df <- raw_data(); req(df)
    all_cols <- names(df)
    sel <- intersect(selected_cols_rv(), all_cols)
    cols <- if (length(sel) > 0) sel else all_cols
    rn_import_cols(cols)
    ren <- col_renames_rv()
    atual <- cols
    if (length(ren)) for (o in names(ren)) atual[cols == o] <- unname(ren[o])
    showModal(modalDialog(
      title = "Renomear Colunas", size = "l", easyClose = TRUE,
      tags$p(style = "font-size: 0.85rem; color: #6c757d;",
             "Ajuste os nomes à direita. A tipagem e os filtros continuam usando os dados originais; a renomeação vale para a prévia, as análises e as exportações."),
      div(style = "max-height: 430px; overflow-y: auto; padding-right: 6px;",
        lapply(seq_along(cols), function(i)
          div(style = "display:flex; gap:10px; align-items:center; margin-bottom:6px;",
            div(style = "flex:1; font-size:0.82rem; color:#666; word-break:break-word;", cols[i]),
            div(style = "flex:0 0 20px; text-align:center; color:#aaa;", "→"),
            div(style = "flex:1;", textInput(paste0("rename_in_", i), NULL, value = atual[i], width = "100%"))))),
      footer = tagList(
        actionButton("rename_reset", "Restaurar originais", class = "btn btn-sm btn-outline-secondary"),
        modalButton("Cancelar"),
        actionButton("rename_apply", "Aplicar", class = "btn btn-sm btn-primary"))
    ))
  })

  observeEvent(input$rename_reset, {
    cols <- rn_import_cols(); req(length(cols) > 0)
    for (i in seq_along(cols)) updateTextInput(session, paste0("rename_in_", i), value = cols[i])
  })

  observeEvent(input$rename_apply, {
    cols <- rn_import_cols(); req(length(cols) > 0)
    novos <- vapply(seq_along(cols), function(i) {
      v <- input[[paste0("rename_in_", i)]]; if (is.null(v)) cols[i] else trimws(v)
    }, character(1))
    if (any(!nzchar(novos))) { showNotification("Os nomes não podem ficar vazios.", type = "error"); return() }
    if (anyDuplicated(novos)) { showNotification("Há nomes de coluna duplicados.", type = "error"); return() }
    mudou <- novos != cols
    col_renames_rv(stats::setNames(novos[mudou], cols[mudou]))
    removeModal()
    showNotification(if (any(mudou)) sprintf("%d coluna(s) renomeada(s).", sum(mudou)) else "Nenhuma alteração de nome.",
                     type = "message", duration = 3)
  })

  # Observador para capturar mudanças nos inputs de tipagem dinâmica gerados
  observe({
    df <- raw_data()
    req(df)
    types <- col_types_rv()
    req(length(types) > 0)
    
    updated <- FALSE
    for (col_name in names(df)) {
      input_id <- paste0("col_type_", sanitize_id(col_name))
      val <- input[[input_id]]
      if (length(val) == 1L && !is.na(val) &&
          !identical(val, types[[col_name]])) {
        if (identical(val, "Date")) {
          erro <- tryCatch({ preparo_converter_data(df[[col_name]]); NULL }, error = conditionMessage)
          if (!is.null(erro)) {
            showNotification(paste(col_name, "—", erro), id = paste0("data_", sanitize_id(col_name)),
                             type = "error", duration = NULL)
            updateSelectInput(session, input_id, selected = types[[col_name]])
            next
          }
        }
        removeNotification(paste0("data_", sanitize_id(col_name)))
        types[[col_name]] <- val
        updated <- TRUE
      }
    }
    if (updated) {
      col_types_rv(types)
    }
  })
  
  # Dataset atualizado reativamente com os tipos selecionados
  current_data <- reactive({
    df <- raw_data()
    req(df)
    types <- col_types_rv()
    req(length(types) > 0)
    
    # Filtrar colunas selecionadas pelo usuário (só as que existem no dataset atual —
    # evita erro/dado velho ao trocar de aba/dataset com colunas diferentes)
    cols_to_keep <- intersect(selected_cols_rv(), names(df))
    if (length(cols_to_keep) > 0) {
      df <- df[, cols_to_keep, drop = FALSE]
    }
    
    # Recodificar colunas se houver mapeamento/agrupamento registrado
    recodes <- col_recodes_rv()
    for (col_name in names(df)) {
      if (!is.null(recodes[[col_name]])) {
        col_map <- recodes[[col_name]]
        map_vec <- unlist(col_map)
        val_vec <- as.character(df[[col_name]])
        mapped_vec <- map_vec[val_vec]
        # Onde a busca falhar (e o original não era NA), mantém o original
        fallback_mask <- is.na(mapped_vec) & !is.na(val_vec)
        mapped_vec[fallback_mask] <- val_vec[fallback_mask]
        df[[col_name]] <- unname(mapped_vec)
      }
    }
    
    for (col_name in names(df)) {
      target_type <- types[[col_name]]
      if (!is.null(target_type)) {
        df[[col_name]] <- tryCatch({
          if (target_type == "numeric") {
            cleaned <- gsub(",", ".", as.character(df[[col_name]]))
            as.numeric(cleaned)
          } else if (target_type == "character") {
            as.character(df[[col_name]])
          } else if (target_type == "factor") {
            as.factor(df[[col_name]])
          } else if (target_type == "integer") {
            cleaned <- gsub(",", ".", as.character(df[[col_name]]))
            as.integer(cleaned)
          } else if (target_type == "logical") {
            as.logical(df[[col_name]])
          } else if (target_type == "Date") {
            preparo_converter_data(df[[col_name]])
          } else {
            df[[col_name]]
          }
        }, error = function(e) {
          if (identical(target_type, "Date"))
            validate(need(FALSE, paste(col_name, "—", conditionMessage(e))))
          df[[col_name]]
        })
      }
    }

    # Aplica os filtros de niveis (fatores): mantem apenas as linhas cujos
    # valores estejam entre os niveis selecionados e remove niveis vazios.
    filtros <- level_filters_rv()
    if (length(filtros) > 0) {
      for (col_name in names(filtros)) {
        manter <- filtros[[col_name]]
        if (!is.null(manter) && length(manter) > 0 && col_name %in% names(df) &&
            identical(types[[col_name]], "factor")) {
          valores <- as.character(df[[col_name]])
          df <- df[!is.na(valores) & valores %in% manter, , drop = FALSE]
          if (is.factor(df[[col_name]])) {
            df[[col_name]] <- droplevels(df[[col_name]])
          }
        }
      }
    }

    # Aplica os filtros de faixa (numericas/inteiras): mantem apenas as linhas
    # cujos valores estejam dentro do intervalo [min, max] selecionado.
    faixas <- range_filters_rv()
    if (length(faixas) > 0) {
      for (col_name in names(faixas)) {
        faixa <- faixas[[col_name]]
        if (!is.null(faixa) && length(faixa) == 2 && col_name %in% names(df) &&
            identical(types[[col_name]], "factor") == FALSE &&
            (identical(types[[col_name]], "numeric") || identical(types[[col_name]], "integer"))) {
          valores <- suppressWarnings(as.numeric(df[[col_name]]))
          df <- df[!is.na(valores) & valores >= faixa[1] & valores <= faixa[2], , drop = FALSE]
        }
      }
    }

    # Renomeação opcional de colunas — SEMPRE por último, para não interferir na
    # seleção/tipagem/filtros (que operam sobre os nomes originais). Mapa vazio =
    # sem efeito, então o comportamento padrão fica idêntico ao anterior.
    ren <- col_renames_rv()
    if (length(ren) > 0) {
      nm <- names(df)
      for (o in names(ren)) nm[nm == o] <- unname(ren[o])
      names(df) <- nm
    }

    df
  })
  
  # Renderiza a interface de alteração de tipos
  output$variable_type_converter_ui <- renderUI({
    df <- raw_data()
    req(df)
    # Só mantém colunas que existem no dataset atual (evita "colunas indefinidas
    # selecionadas" ao trocar/abrir um conjunto com colunas diferentes das do estado
    # anterior). Espelha a proteção usada em current_data().
    cols_to_keep <- intersect(selected_cols_rv(), names(df))
    if (length(cols_to_keep) > 0) {
      df <- df[, cols_to_keep, drop = FALSE]
    }
    types <- col_types_rv()
    req(length(types) > 0)
    lvlf <- level_filters_rv()
    rngf <- range_filters_rv()

    card(
      card_header("Tipagem de Variáveis", style = "font-size: 0.95rem; font-weight: 700; color: #0d6efd;"),
      card_body(
        style = "padding: 10px 15px; max-height: 250px; overflow-y: auto;",
        tags$table(class = "table table-sm table-borderless align-middle", style = "margin-bottom: 0; font-size: 0.85rem;",
          tags$thead(
            tags$tr(
              tags$th("Coluna", style = "width: 38%; color: #495057; font-weight: 600;"),
              tags$th("Tipo de Dado", style = "width: 37%; color: #495057; font-weight: 600;"),
              tags$th("Filtro", style = "width: 25%; color: #495057; font-weight: 600;")
            )
          ),
          tags$tbody(
            lapply(names(df), function(col_name) {
              current_type <- types[[col_name]]
              if (is.null(current_type)) current_type <- "character"

              tags$tr(
                tags$td(
                  style = "padding: 4px 0; max-width: 110px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;",
                  tags$b(col_name)
                ),
                tags$td(
                  style = "padding: 4px 4px;",
                  selectInput(
                    inputId = paste0("col_type_", sanitize_id(col_name)),
                    label = NULL,
                    choices = c("character" = "character",
                                "numeric" = "numeric",
                                "factor" = "factor",
                                "integer" = "integer",
                                "logical" = "logical",
                                "Date" = "Date"),
                    selected = current_type,
                    width = "100%"
                  )
                ),
                tags$td(
                  style = "padding: 4px 0; text-align: right; white-space: nowrap;",
                  if (identical(current_type, "factor") || identical(current_type, "character")) {
                    fobj <- lvlf[[col_name]]
                    ativo <- !is.null(fobj) && length(fobj) > 0
                    n_total <- length(levels(as.factor(df[[col_name]])))
                    rotulo <- if (ativo) sprintf("%d/%d", length(fobj), n_total) else "Filtrar"
                    
                    col_recode <- col_recodes_rv()[[col_name]]
                    ativo_r <- !is.null(col_recode) && any(names(col_recode) != unlist(col_recode))
                    n_recoded <- if (!is.null(col_recode)) length(unique(unlist(col_recode))) else n_total
                    rotulo_r <- if (ativo_r) sprintf("Agrupado (%d)", n_recoded) else "Agrupar"
                    
                    tags$div(
                      style = "display: flex; gap: 4px; justify-content: flex-end;",
                      actionButton(
                        inputId = paste0("col_filter_btn_", sanitize_id(col_name)),
                        label = tagList(icon("filter"), rotulo),
                        class = if (ativo) "btn btn-sm btn-primary" else "btn btn-sm btn-outline-secondary",
                        style = "font-size: 0.72rem; padding: 2px 6px;"
                      ),
                      actionButton(
                        inputId = paste0("col_recode_btn_", sanitize_id(col_name)),
                        label = tagList(icon("object-group"), rotulo_r),
                        class = if (ativo_r) "btn btn-sm btn-primary" else "btn btn-sm btn-outline-secondary",
                        style = "font-size: 0.72rem; padding: 2px 6px;"
                      )
                    )
                  } else if (current_type %in% c("numeric", "integer")) {
                    robj <- rngf[[col_name]]
                    ativo <- !is.null(robj) && length(robj) == 2
                    rotulo <- if (ativo) "Faixa" else "Filtrar"
                    actionButton(
                      inputId = paste0("col_filter_btn_", sanitize_id(col_name)),
                      label = tagList(icon(if (ativo) "sliders" else "filter"), rotulo),
                      class = if (ativo) "btn btn-sm btn-primary" else "btn btn-sm btn-outline-secondary",
                      style = "font-size: 0.72rem; padding: 2px 6px;"
                    )
                  } else {
                    tags$span("—", style = "color: #adb5bd;")
                  }
                )
              )
            })
          )
        )
      )
    )
  })

  # ---- Filtro de niveis de fatores: modal + observadores dinamicos -----------
  abrir_modal_niveis <- function(col_name) {
    df <- raw_data()
    if (is.null(df) || !(col_name %in% names(df))) return(invisible(NULL))
    id <- sanitize_id(col_name)
    todos <- levels(as.factor(df[[col_name]]))
    atual <- level_filters_rv()[[col_name]]
    selecionados <- if (is.null(atual)) todos else atual
    showModal(modalDialog(
      title = paste0("Filtrar níveis — ", col_name),
      tags$p(
        style = "font-size: 0.85rem; color: #6c757d;",
        "Mantenha apenas os níveis desejados. As linhas dos níveis desmarcados ",
        "serão removidas de todas as análises."
      ),
      checkboxGroupInput(
        inputId = paste0("col_levels_", id),
        label = NULL,
        choices = todos,
        selected = selecionados
      ),
      footer = tagList(
        actionButton(paste0("col_levels_all_", id), "Selecionar todos",
                     class = "btn btn-sm btn-outline-secondary"),
        modalButton("Cancelar"),
        actionButton(paste0("col_levels_apply_", id), "Aplicar",
                     class = "btn btn-sm btn-primary")
      ),
      easyClose = TRUE,
      size = "s"
    ))
  }

  # ---- Agrupamento/Recodificação de categorias/fatores ------------------------
  abrir_modal_agrupar <- function(col_name) {
    df <- raw_data()
    if (is.null(df) || !(col_name %in% names(df))) return(invisible(NULL))
    id <- sanitize_id(col_name)
    niveis <- sort(unique(as.character(df[[col_name]])))
    recode_atual <- col_recodes_rv()[[col_name]]
    
    inputs_ui <- lapply(niveis, function(niv) {
      val_def <- if (!is.null(recode_atual[[niv]])) recode_atual[[niv]] else niv
      tags$tr(
        tags$td(style = "padding: 5px; font-weight: bold; width: 45%; vertical-align: middle;", niv),
        tags$td(style = "padding: 5px; width: 10%; text-align: center; vertical-align: middle;", icon("arrow-right")),
        tags$td(style = "padding: 5px; width: 45%; vertical-align: middle;",
                textInput(
                  inputId = paste0("recode_val_", id, "_", sanitize_id(niv)),
                  label = NULL,
                  value = val_def,
                  width = "100%"
                )
        )
      )
    })
    
    showModal(modalDialog(
      title = paste0("Agrupar / Recodificar categorias — ", col_name),
      tags$p(
        style = "font-size: 0.85rem; color: #6c757d; margin-bottom: 15px;",
        "Redefina os nomes das categorias para agrupar níveis. ",
        "Por exemplo, mapeie múltiplos níveis originais para '0' e '1' (para regressão logística) ou para nomes comuns de sua escolha."
      ),
      tags$div(
        style = "max-height: 250px; overflow-y: auto; padding-right: 5px;",
        tags$table(
          style = "width: 100%; border-collapse: collapse;",
          tags$tbody(inputs_ui)
        )
      ),
      footer = tagList(
        actionButton(paste0("col_recode_reset_", id), "Restaurar Padrão",
                     class = "btn btn-sm btn-outline-secondary"),
        modalButton("Cancelar"),
        actionButton(paste0("col_recode_apply_", id), "Aplicar",
                     class = "btn btn-sm btn-primary")
      ),
      easyClose = TRUE,
      size = "m"
    ))
  }

  abrir_modal_faixa <- function(col_name) {
    df <- raw_data()
    if (is.null(df) || !(col_name %in% names(df))) return(invisible(NULL))
    id <- sanitize_id(col_name)
    valores <- suppressWarnings(as.numeric(gsub(",", ".", as.character(df[[col_name]]))))
    if (all(is.na(valores))) {
      showNotification("A coluna não possui valores numéricos para filtrar.", type = "warning")
      return(invisible(NULL))
    }
    lim_min <- min(valores, na.rm = TRUE)
    lim_max <- max(valores, na.rm = TRUE)
    atual <- range_filters_rv()[[col_name]]
    valor <- if (is.null(atual)) c(lim_min, lim_max) else atual
    passo <- signif((lim_max - lim_min) / 100, 2)
    if (!is.finite(passo) || passo <= 0) passo <- NULL
    showModal(modalDialog(
      title = paste0("Filtrar faixa — ", col_name),
      tags$p(
        style = "font-size: 0.85rem; color: #6c757d;",
        "Mantenha apenas os valores dentro do intervalo. As linhas fora dele ",
        "serão removidas de todas as análises."
      ),
      sliderInput(
        inputId = paste0("col_range_", id),
        label = NULL,
        min = lim_min, max = lim_max, value = valor,
        step = passo, width = "100%"
      ),
      footer = tagList(
        actionButton(paste0("col_range_full_", id), "Faixa completa",
                     class = "btn btn-sm btn-outline-secondary"),
        modalButton("Cancelar"),
        actionButton(paste0("col_range_apply_", id), "Aplicar",
                     class = "btn btn-sm btn-primary")
      ),
      easyClose = TRUE,
      size = "s"
    ))
  }

  # Registra (uma unica vez por coluna) os observadores de filtro. O botao de
  # cada coluna decide, no clique, qual modal abrir conforme o tipo atual.
  observe({
    df <- raw_data()
    req(df)
    for (col_name in names(df)) {
      id <- sanitize_id(col_name)
      if (is.null(lvl_obs_registry[[paste0("reg_", id)]])) {
        local({
          cn <- col_name
          i <- id
          # Abrir o modal apropriado conforme o tipo atual da coluna
          lvl_obs_registry[[paste0("open_", i)]] <- observeEvent(
            input[[paste0("col_filter_btn_", i)]], {
              tp <- col_types_rv()[[cn]]
              if (identical(tp, "factor")) {
                abrir_modal_niveis(cn)
              } else if (identical(tp, "numeric") || identical(tp, "integer")) {
                abrir_modal_faixa(cn)
              }
            }, ignoreInit = TRUE)
          # --- Fator: selecionar todos / aplicar niveis ---
          lvl_obs_registry[[paste0("all_", i)]] <- observeEvent(
            input[[paste0("col_levels_all_", i)]], {
              todos <- levels(as.factor(raw_data()[[cn]]))
              updateCheckboxGroupInput(session, paste0("col_levels_", i), selected = todos)
            }, ignoreInit = TRUE)
          lvl_obs_registry[[paste0("apply_", i)]] <- observeEvent(
            input[[paste0("col_levels_apply_", i)]], {
              sel <- input[[paste0("col_levels_", i)]]
              todos <- levels(as.factor(raw_data()[[cn]]))
              f <- level_filters_rv()
              if (is.null(sel) || length(sel) == 0 || setequal(sel, todos)) {
                f[[cn]] <- NULL
              } else {
                f[[cn]] <- sel
              }
              level_filters_rv(f)
              removeModal()
            }, ignoreInit = TRUE)
          # --- Numerica: faixa completa / aplicar faixa ---
          lvl_obs_registry[[paste0("rfull_", i)]] <- observeEvent(
            input[[paste0("col_range_full_", i)]], {
              valores <- suppressWarnings(as.numeric(gsub(",", ".", as.character(raw_data()[[cn]]))))
              if (!all(is.na(valores))) {
                updateSliderInput(session, paste0("col_range_", i),
                                  value = c(min(valores, na.rm = TRUE), max(valores, na.rm = TRUE)))
              }
            }, ignoreInit = TRUE)
          lvl_obs_registry[[paste0("rapply_", i)]] <- observeEvent(
            input[[paste0("col_range_apply_", i)]], {
              sel <- input[[paste0("col_range_", i)]]
              valores <- suppressWarnings(as.numeric(gsub(",", ".", as.character(raw_data()[[cn]]))))
              rf <- range_filters_rv()
              if (is.null(sel) || length(sel) != 2 || all(is.na(valores))) {
                rf[[cn]] <- NULL
              } else {
                lim_min <- min(valores, na.rm = TRUE)
                lim_max <- max(valores, na.rm = TRUE)
                if (isTRUE(all.equal(sel[1], lim_min)) && isTRUE(all.equal(sel[2], lim_max))) {
                  rf[[cn]] <- NULL
                } else {
                  rf[[cn]] <- c(sel[1], sel[2])
                }
              }
              range_filters_rv(rf)
              removeModal()
            }, ignoreInit = TRUE)
          
          # --- Recodificação/Agrupamento de Fator ---
          lvl_obs_registry[[paste0("recode_open_", i)]] <- observeEvent(
            input[[paste0("col_recode_btn_", i)]], {
              abrir_modal_agrupar(cn)
            }, ignoreInit = TRUE)
            
          lvl_obs_registry[[paste0("recode_reset_", i)]] <- observeEvent(
            input[[paste0("col_recode_reset_", i)]], {
              niveis <- sort(unique(as.character(raw_data()[[cn]])))
              for (niv in niveis) {
                updateTextInput(session, paste0("recode_val_", i, "_", sanitize_id(niv)), value = niv)
              }
            }, ignoreInit = TRUE)
            
          lvl_obs_registry[[paste0("recode_apply_", i)]] <- observeEvent(
            input[[paste0("col_recode_apply_", i)]], {
              niveis <- sort(unique(as.character(raw_data()[[cn]])))
              mapa <- list()
              for (niv in niveis) {
                novo_val <- input[[paste0("recode_val_", i, "_", sanitize_id(niv))]]
                if (!is.null(novo_val) && nzchar(novo_val)) {
                  mapa[[niv]] <- novo_val
                } else {
                  mapa[[niv]] <- niv
                }
              }
              
              # Grava o mapeamento
              recodes <- col_recodes_rv()
              recodes[[cn]] <- mapa
              col_recodes_rv(recodes)
              
              # Reseta filtros de niveis se houver, pois os niveis mudaram
              f <- level_filters_rv()
              if (!is.null(f[[cn]])) {
                f[[cn]] <- NULL
                level_filters_rv(f)
              }
              
              removeModal()
            }, ignoreInit = TRUE)
            
          lvl_obs_registry[[paste0("reg_", i)]] <- TRUE
        })
      }
    }
  })
  
  # Indicador do status do dataset
  output$dataset_status_indicator <- renderUI({
    df <- current_data()
    if (is.null(df)) {
      div(
        class = "alert alert-warning",
        style = "padding: 10px; border-radius: 8px; font-size: 0.9rem; margin-bottom: 0;",
        icon("triangle-exclamation"), " Nenhum dataset carregado no momento."
      )
    } else {
      div(
        div(
          class = "alert alert-success",
          style = "padding: 10px; border-radius: 8px; font-size: 0.9rem; margin-bottom: 12px; font-weight: 500;",
          icon("circle-check"), " Arquivo carregado — confira a prévia."
        ),
        tags$table(class = "table table-sm table-borderless", style = "margin-bottom: 0; font-size: 0.85rem;",
          tags$tbody(
            tags$tr(
              tags$td(tags$b("Linhas:")),
              tags$td(nrow(df))
            ),
            tags$tr(
              tags$td(tags$b("Colunas:")),
              tags$td(ncol(df))
            ),
            tags$tr(
              tags$td(tags$b("Origem:")),
              tags$td(if (input$data_source == "local") {
                if (is.null(input$file_upload)) "Arquivo Padrão" else input$file_upload$name
              } else {
                paste("EAPADados:", input$package_dataset)
              })
            )
          )
        ),
        # Linha do DATASET ATIVO das análises (reage à promoção do Arrumar)
        uiOutput("dataset_ativo_linha")
      )
    }
  })

  # Mostra qual tabela as análises estão usando (importados x resultado do Arrumar)
  output$dataset_ativo_linha <- renderUI({
    da <- dataset_ativo_rv()
    if (is.null(da)) {
      div(style = "margin-top: 8px; font-size: 0.82rem; color: #2E7D8F;",
          icon("circle-info"), " Análises usando: dados importados.")
    } else {
      div(style = "margin-top: 8px;",
        div(class = "alert alert-info",
            style = "padding: 8px 10px; border-radius: 8px; font-size: 0.82rem; margin-bottom: 6px;",
            icon("wand-magic-sparkles"),
            sprintf(" Análises usando: %s (%d x %d).", da$fonte, nrow(da$df), ncol(da$df))),
        actionButton("voltar_importados", "Voltar aos dados importados",
                     icon = icon("rotate-left"),
                     class = "btn btn-sm btn-outline-secondary w-100"))
    }
  })
  
  # --- IMPORTAÇÃO DE DADOS LOCAL E DE PACOTE ---
  
  # Gera seletor dinâmico de variáveis do dataset (Botão de Abertura de Modal)
  output$dataset_vars_selector <- renderUI({
    df <- raw_data()
    req(df)
    
    all_cols <- names(df)
    selected_cols <- selected_cols_rv()
    if (length(selected_cols) == 0) {
      selected_cols <- all_cols
    }
    
    ativo <- length(selected_cols) < length(all_cols)
    rotulo <- sprintf("Selecionar Variáveis (%d/%d)", length(selected_cols), length(all_cols))

    n_ren <- length(col_renames_rv())
    rotulo_ren <- if (n_ren > 0) sprintf("Renomear Colunas (%d)", n_ren) else "Renomear Colunas"

    tagList(
      actionButton(
        "select_vars_btn",
        label = tagList(icon("list-check"), rotulo),
        class = if (ativo) "btn btn-sm btn-primary w-100" else "btn btn-sm btn-outline-secondary w-100",
        style = "font-size: 0.85rem; padding: 4px 10px; margin-top: 0px; margin-bottom: 0px;"
      ),
      actionButton(
        "rename_cols_btn",
        label = tagList(icon("i-cursor"), rotulo_ren),
        class = if (n_ren > 0) "btn btn-sm btn-primary w-100" else "btn btn-sm btn-outline-secondary w-100",
        style = "font-size: 0.85rem; padding: 4px 10px; margin-top: 6px; margin-bottom: 0px;"
      )
    )
  })
  
  # Gera seletor de sheets dinâmico se for planilha Excel
  # O upload chega ao servidor; usar sua confirmação também funciona após trocar o arquivo.
  output$arquivo_csv <- renderText({
    if (!is.null(input$file_upload) &&
        identical(tolower(tools::file_ext(input$file_upload$name)), "csv")) "sim" else "nao"
  })
  outputOptions(output, "arquivo_csv", suspendWhenHidden = FALSE)

  output$excel_sheet_selector <- renderUI({
    req(input$file_upload)
    ext <- tolower(tools::file_ext(input$file_upload$name))
    if (ext %in% c("xlsx", "xls")) {
      sheets <- excel_sheets(input$file_upload$datapath)
      # Cria opções formatadas mostrando o índice (Ex: "3 - regressao")
      sheet_choices <- setNames(sheets, paste0(1:length(sheets), " - ", sheets))
      # Um arquivo enviado começa pela primeira aba; o pesquisador pode trocá-la.
      selected_sheet <- sheets[1]
      selectizeInput("excel_sheet", "Selecione a Aba (Sheet):", choices = sheet_choices, selected = selected_sheet,
        options = list(placeholder = "Digite ou escolha a aba...", openOnFocus = TRUE,
          dropdownParent = "body",
          onDropdownOpen = I("function($dropdown) { $dropdown.addClass('origem-lista-ampla'); }")))
    } else {
      NULL
    }
  })
  
  # Observador reativo para atualizar o dataset com base nas entradas
  observe({
    if (input$data_source == "local") {
      req(input$file_upload)
      path <- input$file_upload$datapath
      ext <- tolower(tools::file_ext(input$file_upload$name))
      
      # A escolha da aba pode chegar depois do arquivo; aguarde sem emitir erro.
      if (ext %in% c("xlsx", "xls")) req(input$excel_sheet, nzchar(input$excel_sheet))
      tryCatch({
        if (ext == "csv") {
          df <- read.csv(path, 
                         header = input$csv_header, 
                         sep = input$csv_sep, 
                         dec = input$csv_dec,
                         stringsAsFactors = FALSE,
                         check.names = FALSE)
          raw_data(df)
          removeNotification("erro_leitura")
        } else if (ext %in% c("xlsx", "xls")) {
          if (!input$excel_sheet %in% excel_sheets(path)) return()
          df <- as.data.frame(read_excel(path, sheet = input$excel_sheet))
          raw_data(df)
          removeNotification("erro_leitura")
        }
      }, error = function(e) {
        showNotification(paste("Não foi possível ler este arquivo.",
          if (ext == "csv") "Confira o separador de coluna e o decimal.", e$message),
          type = "error", duration = NULL, id = "erro_leitura")
        # Não apresentar os dados do arquivo anterior como se fossem os novos.
        raw_data(NULL)
      })
      
    } else if (input$data_source == "package") {
      req(input$package_dataset, nzchar(input$package_dataset))
      req(input$package_dataset %in% eapa_datasets)   # só carrega um conjunto válido
      if (requireNamespace("EAPADados", quietly = TRUE)) {
        tryCatch({
          # Carrega o dataset de forma ultra-rápida direto do namespace
          df <- tryCatch({
            get(input$package_dataset, envir = asNamespace("EAPADados"))
          }, error = function(err) {
            # Fallback seguro usando data()
            data(list = input$package_dataset, package = "EAPADados", envir = environment())
            get(input$package_dataset)
          })
          raw_data(as.data.frame(df))
        }, error = function(e) {
          showNotification(paste("Erro ao carregar do pacote:", e$message), type = "error")
          # NÃO zera raw_data: mantém o último dataset válido
        })
      }
    }
  })
  
  # Caso o usuário tenha colocado o arquivo 'datasets-projetos.xlsx' diretamente na pasta dados
  # Vamos pré-carregar ele por padrão se nenhum arquivo for carregado
  observe({
    default_excel_path <- "dados/datasets-projetos.xlsx"
    if (is.null(raw_data()) && is.null(input$file_upload) && file.exists(default_excel_path)) {
      tryCatch({
        sheets <- excel_sheets(default_excel_path)
        # Prefere a sheet 3 como padrão
        selected_sheet <- if (length(sheets) >= 3) sheets[3] else sheets[1]
        df <- as.data.frame(read_excel(default_excel_path, sheet = selected_sheet))
        raw_data(df)
      }, error = function(e) {
        # Ignora erro silenciosamente no setup inicial
      })
    }
  })
  
  # Exibe a tabela de dados
  output$data_preview_table <- renderDT({
    df <- current_data()
    req(df)
    datatable(df, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE,
      language = preparo_idioma_tabela(ncol(df))))
  })
  
  # ---- Resumo dos Dados: tabela "glimpse" + detalhe da variável -------------
  resumo_glimpse_df <- reactive({
    df <- current_data()
    req(df, ncol(df) > 0)
    resumo_glimpse(df)
  })

  output$resumo_variaveis_tabela <- renderDT({
    tab <- resumo_glimpse_df()
    datatable(tab, rownames = FALSE, fillContainer = FALSE, class = "compact nowrap",
      selection = list(mode = "single", selected = 1, target = "row"),
      options = list(paging = FALSE, dom = "ti", scrollX = TRUE,
        scrollY = "220px", scrollCollapse = TRUE, ordering = FALSE,
        columnDefs = list(list(targets = 2, width = "170px")),
        language = preparo_idioma_tabela(ncol(tab)))) |>
      formatStyle("Classe", fontFamily = "monospace", color = "#2E7D8F", fontWeight = "bold") |>
      formatStyle("Ausentes", color = styleEqual("0", "#6C757D", default = "#E76F51"))
  })

  # Variável escolhida: a linha clicada (ou a primeira, ao abrir).
  resumo_variavel_escolhida <- reactive({
    df <- current_data(); req(df, ncol(df) > 0)
    i <- input$resumo_variaveis_tabela_rows_selected
    if (length(i) == 0 || i > ncol(df)) i <- 1
    names(df)[i]
  })

  output$resumo_variavel_detalhe <- renderUI({
    df <- current_data(); req(df)
    nome <- resumo_variavel_escolhida()
    x <- df[[nome]]
    n <- length(x); na <- sum(is.na(x)); v <- x[!is.na(x)]
    linha <- function(rotulo, valor) tags$tr(tags$td(tags$b(rotulo)), tags$td(valor))

    if (is.numeric(x)) {
      v <- v[is.finite(v)]
      q <- if (length(v)) stats::quantile(v, c(.25, .5, .75), names = FALSE) else rep(NA, 3)
      m <- if (length(v)) mean(v) else NA
      dp <- if (length(v) > 1) stats::sd(v) else NA
      assim <- if (length(v) > 2 && isTRUE(dp > 0)) mean((v - m)^3) / dp^3 else NA
      leitura_assim <- if (is.na(assim)) "" else if (abs(assim) < 0.5) " (quase simétrica)"
        else if (assim > 0) " (cauda à direita)" else " (cauda à esquerda)"
      linhas <- list(
        linha("Mínimo", resumo_num(if (length(v)) min(v) else NA)),
        linha("1º quartil", resumo_num(q[1])),
        linha("Mediana", resumo_num(q[2])),
        linha("Média", resumo_num(m)),
        linha("3º quartil", resumo_num(q[3])),
        linha("Máximo", resumo_num(if (length(v)) max(v) else NA)),
        linha("Desvio padrão", resumo_num(dp)),
        linha("CV", if (isTRUE(m != 0) && !is.na(dp)) paste0(resumo_num(100 * dp / abs(m), 3), "%") else "—"),
        linha("Assimetria", paste0(resumo_num(assim, 2), leitura_assim)),
        linha("Zeros", sum(v == 0))
      )
    } else if (inherits(x, c("Date", "POSIXt"))) {
      linhas <- list(
        linha("Primeira data", if (length(v)) format(min(v)) else "—"),
        linha("Última data", if (length(v)) format(max(v)) else "—"),
        linha("Datas distintas", length(unique(v)))
      )
    } else {
      freq <- sort(table(as.character(v)), decreasing = TRUE)
      linhas <- c(
        list(linha("Categorias", length(freq)),
             linha("Mais frequente", if (length(freq)) sprintf("%s (%d)", names(freq)[1], freq[[1]]) else "—")),
        lapply(utils::head(seq_along(freq), 8), function(k)
          linha(paste0("  ", names(freq)[k]),
                sprintf("%d (%s%%)", freq[[k]], resumo_num(100 * freq[[k]] / length(v), 3)))),
        if (length(freq) > 8) list(linha("…", sprintf("mais %d categorias", length(freq) - 8)))
      )
    }

    layout_columns(
      col_widths = c(5, 7),
      div(
        h6(style = "color:#0F3B5F; font-weight:700; margin-bottom:4px;",
           icon("magnifying-glass-chart"), " ", nome),
        p(class = "small text-muted mb-2",
          code(resumo_classe(x)), " · ", exploracao_tipo_variavel(x, nome),
          sprintf(" · %d válidos, %d ausentes", n - na, na)),
        tags$table(class = "table table-sm table-striped", style = "font-size:0.85rem;",
                   tags$tbody(linhas))
      ),
      plotOutput("resumo_variavel_grafico", height = "280px")
    )
  })

  output$resumo_variavel_grafico <- renderPlot({
    df <- current_data(); req(df)
    nome <- resumo_variavel_escolhida()
    x <- df[[nome]]
    validate(need(any(!is.na(x)), "Esta variável só tem valores ausentes."))
    oc <- cores_ocean()
    if (is.numeric(x)) {
      desenhar_distribuicao(df, nome, tipo = "densidade") +
        ggplot2::geom_rug(color = oc[["NAVY"]], alpha = .35, na.rm = TRUE) +
        ggplot2::labs(title = paste("Distribuição de", nome), subtitle = NULL)
    } else if (inherits(x, c("Date", "POSIXt"))) {
      ggplot(data.frame(x = x[!is.na(x)]), aes(x = x)) +
        geom_histogram(bins = 20, fill = oc[["SEAFOAM"]], color = "white") +
        tema_ocean() + labs(title = paste("Datas de", nome), x = nome, y = "Frequência")
    } else {
      # Categorias: as 15 mais frequentes, em barras horizontais.
      freq <- sort(table(as.character(x[!is.na(x)])), decreasing = TRUE)
      freq <- utils::head(freq, 15)
      tab <- data.frame(cat = factor(names(freq), levels = rev(names(freq))), n = as.integer(freq))
      ggplot(tab, aes(x = n, y = cat)) +
        geom_col(fill = oc[["TEAL"]]) +
        geom_text(aes(label = n), hjust = -0.2, size = 3.5, color = oc[["NAVY"]]) +
        scale_x_continuous(expand = expansion(mult = c(0, .12))) +
        tema_ocean() + labs(title = paste("Frequência de", nome), x = "Contagem", y = NULL)
    }
  })

  # ---- Panorama do conjunto (coluna da direita) ------------------------------
  output$dataset_panorama <- renderUI({
    df <- current_data(); req(df)
    n <- nrow(df); p <- ncol(df)
    tipos <- vapply(names(df), function(nm) exploracao_tipo_variavel(df[[nm]], nm), character(1))
    n_num <- sum(grepl("^Numérica", tipos)); n_cat <- sum(grepl("^Categórica", tipos))
    n_outros <- p - n_num - n_cat
    na_total <- sum(is.na(df))
    completas <- sum(stats::complete.cases(df))
    duplicadas <- sum(duplicated(df))
    na_col <- colSums(is.na(df)); na_col <- sort(na_col[na_col > 0], decreasing = TRUE)
    constantes <- names(df)[vapply(df, function(x) length(unique(x[!is.na(x)])) <= 1, logical(1))]
    pct <- function(a, b) if (b == 0) "0%" else paste0(resumo_num(100 * a / b, 3), "%")
    linha <- function(rotulo, valor) tags$tr(tags$td(tags$b(rotulo)), tags$td(valor))

    titulo <- if (identical(input$data_source, "package") &&
                  !is.null(input$package_dataset) && input$package_dataset %in% names(eapa_titulos)) {
      eapa_titulos[[input$package_dataset]]
    }

    avisos <- list(
      if (duplicadas > 0) tags$li(sprintf("%d linha(s) repetida(s): veja Remover duplicatas na Trilha de Preparo.", duplicadas)),
      if (length(na_col)) tags$li(sprintf("Ausentes em: %s.",
        paste(sprintf("%s (%d)", utils::head(names(na_col), 4), utils::head(na_col, 4)), collapse = ", "))),
      if (length(constantes)) tags$li(sprintf("Coluna(s) com um só valor: %s.", paste(constantes, collapse = ", "))),
      if (n_outros > 0) tags$li("Há colunas de data ou de tipo incomum: confira em Preparar Base Compartilhada.")
    )
    avisos <- Filter(Negate(is.null), avisos)

    tagList(
      h6("Panorama do conjunto", style = "color: #0d6efd; font-weight: 700; margin-bottom: 8px;"),
      if (!is.null(titulo)) p(style = "font-size:0.85rem; margin-bottom:6px;",
        icon("book"), " ", em(titulo), br(),
        span(class = "text-muted small", "Documentação: ", code(paste0("?EAPADados::", input$package_dataset)))),
      tags$table(class = "table table-sm table-borderless", style = "margin-bottom: 6px; font-size: 0.85rem;",
        tags$tbody(
          linha("Numéricas:", n_num),
          linha("Categóricas:", n_cat),
          if (n_outros > 0) linha("Datas/outras:", n_outros),
          linha("Células ausentes:", sprintf("%d (%s)", na_total, pct(na_total, n * p))),
          linha("Linhas completas:", sprintf("%d (%s)", completas, pct(completas, n))),
          linha("Linhas repetidas:", duplicadas),
          linha("Memória:", format(utils::object.size(df), units = "auto"))
        )),
      if (length(avisos)) div(class = "alert alert-warning",
        style = "padding: 8px 10px; font-size: 0.8rem; margin-bottom: 0;",
        icon("triangle-exclamation"), " Para conferir:",
        tags$ul(style = "padding-left: 16px; margin: 4px 0 0;", avisos))
      else div(class = "small", style = "color:#2E7D8F;",
        icon("circle-check"), " Sem ausentes, repetições ou colunas constantes.")
    )
  })
  # Informações de importação reativas para exportação de código
  import_info <- reactive({
    list(
      source = input$data_source,
      file_name = if (!is.null(input$file_upload)) input$file_upload$name else "datasets-projetos.xlsx",
      datapath = if (!is.null(input$file_upload)) input$file_upload$datapath else "dados/datasets-projetos.xlsx",
      # CSV não tem aba: não carregar o nome deixado pela planilha anterior.
      excel_sheet = if (tolower(tools::file_ext(input$file_upload$name %||% "")) %in% c("csv", "txt", "tsv")) NULL
        else if (!is.null(input$excel_sheet)) input$excel_sheet else "regressao",
      csv_sep = if (!is.null(input$csv_sep)) input$csv_sep else ",",
      csv_dec = if (!is.null(input$csv_dec)) input$csv_dec else ".",
      csv_header = if (!is.null(input$csv_header)) input$csv_header else TRUE,
      package_dataset = input$package_dataset,
      preparo_importacao = list(
        colunas = selected_cols_rv(), tipos = col_types_rv(),
        colunas_originais = names(raw_data()),
        classes_originais = lapply(raw_data(), function(x) class(x)[[1]]),
        recodificacoes = col_recodes_rv(), filtros_niveis = level_filters_rv(),
        filtros_faixas = range_filters_rv(), renomes = col_renames_rv()
      )
    )
  })

  codigo_importacao <- reactive({
    req(raw_data())
    preparo_codigo_importacao(import_info())
  })
  output$codigo_importacao <- renderText(codigo_importacao())
  output$baixar_codigo_importacao <- downloadHandler(
    filename = function() "importar_dados.R",
    content = function(file) writeLines(codigo_importacao(), file, useBytes = TRUE)
  )

  # ============================================================================
  # DATASET ATIVO PARA AS ANÁLISES  (Fase 2)
  # Preparar Base Compartilhada é a camada MAIS EXTERNA do dataset ativo. Resolução:
  #   importados (current_data)
  #     -> Pivotar/Separar/Criar e Editar promovem via dataset_ativo_rv -> base_resolvida
  #     -> replay(base_resolvida, pipeline_rv)                     -> dados_analise
  # REGRA anti-dupla-aplicação: os módulos estruturais e a Trilha leem
  # base_resolvida (pré-trilha), NUNCA dados_analise. A Trilha é a última camada.
  # ============================================================================
  dataset_ativo_rv <- reactiveVal(NULL)   # NULL = usar dados importados
  pipeline_rv      <- reactiveVal(list()) # trilha de preparo (lista de etapas)
  base_externa_rv  <- reactiveVal(NULL)   # provenance da base promovida (Arrumar): list(fonte, codigo)
  registro_bases_rv <- reactiveVal(bases_vazio()) # Fase 3A: ramos diretos de dados_analise
  cache_bases_rv <- reactiveVal(bases_cache_vazio()) # Fase 3A.1: resultados somente em memória
  revisao_dados_analise_rv <- reactiveVal(1L)
  registro_execucoes_rv <- reactiveVal(execucoes_vazio()) # Fase 3C: cliques explícitos
  contador_execucoes_rv <- reactiveVal(0L) # IDs monotônicos durante a sessão/dataset
  # Ficha de planejamento (contrato 1, modules/ficha_planejamento.R). O
  # delineamento, Quantos coletar e Como sortear preenchem suas partes; a
  # planilha de coleta, as análises e o Projeto R leem este mesmo objeto.
  ficha_delineamento_rv <- reactiveVal(NULL)

  # Base sobre a qual a trilha atua (importados ou resultado promovido).
  base_resolvida <- reactive({
    da <- dataset_ativo_rv()
    if (is.null(da)) current_data() else da$df
  })

  # Replay da trilha (uma vez só): devolve df + erros por etapa.
  replay_res <- reactive({ replay_pipeline(base_resolvida(), pipeline_rv()) })

  # Dataset que TODAS as análises leem (base_resolvida + trilha).
  dados_analise <- reactive({ replay_res()$df })

  # A revisão acompanha as FONTES de dados_analise, não sua mera leitura. Assim,
  # abrir uma prévia ou recalcular um ramo nunca o torna obsoleto imediatamente.
  # Na Fase 3C, análises registradas usarão o mesmo número para pedir atualização.
  observeEvent(list(current_data(), dataset_ativo_rv(), pipeline_rv()), {
    revisao_dados_analise_rv(revisao_dados_analise_rv() + 1L)
  }, ignoreInit = TRUE)

  # Callback usado pelos módulos estruturais ao confirmar a mudança compartilhada.
  promover_dataset <- function(df, fonte, codigo = NULL, acumular_codigo = FALSE) {
    anterior <- base_externa_rv()
    codigo_final <- codigo
    if (isTRUE(acumular_codigo) &&
        !is.null(anterior$codigo) && nzchar(anterior$codigo) &&
        !is.null(codigo) && nzchar(codigo)) {
      codigo_final <- paste(
        anterior$codigo,
        "",
        sprintf("# Etapa seguinte: %s", fonte),
        codigo,
        sep = "\n"
      )
    }
    dataset_ativo_rv(list(df = df, fonte = fonte))
    base_externa_rv(
      if (!is.null(codigo_final) && nzchar(codigo_final)) {
        list(fonte = fonte, codigo = codigo_final,
          codigo_sequencial = if (!is.null(attr(codigo, "etapas")))
            c(if (isTRUE(acumular_codigo)) anterior$codigo_sequencial, attr(codigo, "etapas")) else NULL)
      } else {
        NULL
      }
    )
    showNotification(sprintf("Base Compartilhada atualizada por: %s (%d linhas x %d colunas).",
                             fonte, nrow(df), ncol(df)), type = "message", duration = 6)
  }

  # Empilhar, alargar, separar, criar e organizar variáveis são mudanças
  # estruturais encadeáveis. Todas passam por este único ponto para preservar
  # a ordem e o código na trilha da Base Compartilhada.
  adicionar_mudanca_compartilhada <- function(df, fonte, codigo = NULL) {
    promover_dataset(
      df, fonte, codigo,
      acumular_codigo = TRUE
    )
  }

  # Voltar aos dados importados
  observeEvent(input$voltar_importados, {
    dataset_ativo_rv(NULL); base_externa_rv(NULL)
    showNotification("Análises voltaram aos dados importados.", type = "message", duration = 4)
  })

  # Trocar de arquivo/fonte descarta a promoção E a trilha (evita dado velho)
  observeEvent(raw_data(), {
    dataset_ativo_rv(NULL)
    pipeline_rv(list())
    base_externa_rv(NULL)
    registro_bases_rv(bases_vazio())
    cache_bases_rv(bases_cache_vazio())
    registro_execucoes_rv(execucoes_vazio())
    contador_execucoes_rv(0L)
    revisao_dados_analise_rv(1L)
  }, ignoreInit = TRUE)

  # --- CHAMADA DO MÓDULO DE REGRESSÃO ---
  # Fase 3B.3: um resolvedor leve por análise. Ele só oferece a base
  # compartilhada e ramos cujo preparo já foi finalizado e recalculado. Não há
  # replay aqui: o módulo recebe o data.frame pronto do cache da Fase 3A.1.
  seletor_regression <- mod_seletor_base_analise_server(
    "base_regression", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "geral",
    nome_analise = "A Regressão Linear"
  )
  seletor_parametric <- mod_seletor_base_analise_server(
    "base_parametric", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "geral",
    nome_analise = "O Teste t"
  )
  seletor_lines <- mod_seletor_base_analise_server(
    "base_lines", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "graficos",
    nome_analise = "O Gráfico de Linhas"
  )
  seletor_np_qui <- mod_seletor_base_analise_server(
    "base_np_qui", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "qui_quadrado",
    nome_analise = "O Qui-quadrado"
  )
  seletor_anova <- mod_seletor_base_analise_server(
    "base_anova", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "anova",
    nome_analise = "A ANOVA"
  )
  seletor_anova_mista <- mod_seletor_base_analise_server(
    "base_anova_mista", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "anova",
    nome_analise = "A ANOVA com subamostras"
  )
  seletor_anova2 <- mod_seletor_base_analise_server(
    "base_anova2", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "anova",
    nome_analise = "A ANOVA de dois fatores"
  )
  seletor_pca <- mod_seletor_base_analise_server(
    "base_pca", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "multivariada",
    nome_analise = "A PCA"
  )
  seletor_hca <- mod_seletor_base_analise_server(
    "base_hca", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, finalidade_preferida = "multivariada",
    nome_analise = "A Análise de Agrupamentos"
  )

  regressao_linear <- mod_regression_server(
    "regression", seletor_regression$dados, import_info,
    base_contexto_externo = seletor_regression$contexto
  )
  
  # --- CHAMADA DOS MÓDULOS DE REGRESSÃO NÃO LINEAR ---
  mod_nonlinear_server("exponencial", dados_analise, import_info, "exponencial")
  mod_nonlinear_server("potencia", dados_analise, import_info, "potencia")
  mod_nonlinear_server("von_bertalanffy", dados_analise, import_info, "von_bertalanffy")
  mod_nonlinear_server("polinomial", dados_analise, import_info, "polinomial")
  mod_nonlinear_server("logaritmica", dados_analise, import_info, "logaritmica")
  mod_nonlinear_server("logistico", dados_analise, import_info, "logistico")
  regressao_logistica <- mod_regression_server(
    "logistic_regression", dados_analise, import_info, is_logistic = TRUE,
    registro_bases_rv = registro_bases_rv,
    cache_bases_rv = cache_bases_rv,
    revisao_origem_rv = revisao_dados_analise_rv
  )
  regressao_poisson <- mod_regressao_contagem_server(
    "regressao_poisson", "poisson", dados_analise,
    registro_bases_rv, cache_bases_rv, revisao_dados_analise_rv,
    registro_execucoes_rv, contador_execucoes_rv
  )
  regressao_binomial_negativa <- mod_regressao_contagem_server(
    "regressao_binomial_negativa", "binomial_negativa", dados_analise,
    registro_bases_rv, cache_bases_rv, revisao_dados_analise_rv,
    registro_execucoes_rv, contador_execucoes_rv
  )
  mod_model_discovery_server("discovery", dados_analise, import_info)

  # --- CHAMADAS DOS MÓDULOS DE DESCRIÇÃO DE DADOS ---
  ficha_exploracao_rv <- reactiveVal(list())
  descricao_areas <- lapply(names(descricao_catalogo()), function(area) {
    mod_descrevendo_dados_server(
      paste0("descricao_", area), area, dados_analise, registro_bases_rv,
      cache_bases_rv, revisao_dados_analise_rv, registro_execucoes_rv,
      contador_execucoes_rv, ficha_rv = ficha_exploracao_rv
    )
  })
  proporcao_uma <- mod_proporcoes_server(
    "proporcao_uma", "uma", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, registro_execucoes_rv, contador_execucoes_rv
  )
  proporcao_duas <- mod_proporcoes_server(
    "proporcao_duas", "duas", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, registro_execucoes_rv, contador_execucoes_rv
  )
  qui_aderencia <- mod_proporcoes_server(
    "qui_aderencia", "aderencia", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, registro_execucoes_rv, contador_execucoes_rv
  )
  mod_pareados_categoricos_server(
    "mcnemar", "mcnemar", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, registro_execucoes_rv, contador_execucoes_rv
  )
  grafico_linhas <- mod_lines_server("lines", seletor_lines$dados, import_info)
  mod_exploracao_visual_server("visual_histograma", dados_analise, "histograma", ficha_rv = ficha_exploracao_rv)
  mod_exploracao_visual_server("visual_caixa", dados_analise, "caixa_violino", ficha_rv = ficha_exploracao_rv)
  mod_exploracao_visual_server("visual_dispersao", dados_analise, "dispersao", ficha_rv = ficha_exploracao_rv)
  mod_exploracao_visual_server("visual_barras", dados_analise, "barras", ficha_rv = ficha_exploracao_rv)
  mod_exploracao_visual_server("visual_matriz", dados_analise, "matriz", ficha_rv = ficha_exploracao_rv)
  mod_exploracao_visual_server("visual_calor", dados_analise, "calor", ficha_rv = ficha_exploracao_rv)
  mod_mapa_server("mapa", dados_analise, import_info)
  mod_mapa_pontos_server("mapa_pontos", dados_analise, import_info, "pontos")
  mod_mapa_pontos_server("mapa_bolhas", dados_analise, import_info, "bolhas")
  mod_series_temporais_server("series_visualizar", dados_analise, import_info)
  mod_series_temporais_server("series_decompor", dados_analise, import_info)
  mod_series_temporais_server("series_autocorrelacao", dados_analise, import_info)
  mod_correlacao_server("correlacao", dados_analise, import_info)
  comunicacao_resultados <- mod_comunicacao_server(
    "comunicacao", dados_analise, import_info,
    registro_execucoes_rv, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, projeto_rv = raw_data,
    dados_brutos_rv = raw_data,
    base_resolvida_rv = base_resolvida,
    pipeline_rv = pipeline_rv,
    base_externa_rv = base_externa_rv,
    ficha_rv = ficha_delineamento_rv
  )
  mod_laboratorio_server("laboratorio")
  mod_lab_tlc_server("lab_tlc")
  mod_lab_anova_server("lab_anova")
  mod_lab_teste_t_server("lab_teste_t")

  # --- CHAMADA DO MÓDULO PARAMÉTRICO ---
  teste_t <- mod_parametric_server("parametric", seletor_parametric$dados, import_info)
  mod_parametrico_complementar_server(
    "anova_repetidas", "anova_medidas_repetidas", dados_analise,
    registro_bases_rv, cache_bases_rv, revisao_dados_analise_rv,
    registro_execucoes_rv, contador_execucoes_rv
  )
  mod_parametrico_complementar_server(
    "qui_variancia", "qui_quadrado_variancia", dados_analise,
    registro_bases_rv, cache_bases_rv, revisao_dados_analise_rv,
    registro_execucoes_rv, contador_execucoes_rv
  )
  mod_parametrico_complementar_server(
    "teste_f_variancias", "teste_f_variancias", dados_analise,
    registro_bases_rv, cache_bases_rv, revisao_dados_analise_rv,
    registro_execucoes_rv, contador_execucoes_rv
  )

  # --- CHAMADAS DOS NOVOS MÓDULOS ---
  # Como sortear a amostra: sorteio sobre o marco amostral, antes da coleta.
  # O mesmo resultado alimenta a ficha de coleta dos delineamentos observacionais.
  sorteio_planejado <- mod_sortear_amostra_server("sortear_amostra", ficha_destino_rv = ficha_delineamento_rv)
  mod_quantos_coletar_server("quantos_coletar", ficha_rv = ficha_delineamento_rv)
  mod_n_poder_server("quantos_coletar-poder", ficha_destino_rv = ficha_delineamento_rv)
  # As quatro abas novas do Quanto amostrar, todas gravando na mesma ficha.
  mod_n_media_server("quantos_coletar-media", ficha_destino_rv = ficha_delineamento_rv)
  mod_n_proporcao_server("quantos_coletar-proporcao", ficha_destino_rv = ficha_delineamento_rv)
  mod_n_duas_prop_server("quantos_coletar-duas_prop", ficha_destino_rv = ficha_delineamento_rv)
  mod_n_correlacao_server("quantos_coletar-correlacao", ficha_destino_rv = ficha_delineamento_rv)
  mod_conceitos_coleta_server("conceitos_coleta")
  # A contingência agora é uma etapa reproduzível da receita de uma Base
  # Derivada; o fluxo legado de "tabela preparada" fica desativado.
  contingency_shared <- NULL
  # As três operações estruturais leem a Base Compartilhada resolvida. Assim,
  # podem ser encadeadas sem retornar silenciosamente aos dados importados.
  mod_arrumar_server(
    "arrumar_emp", base_resolvida, import_info,
    modo_fixo = "empilhar", on_usar = adicionar_mudanca_compartilhada, base_externa_rv = base_externa_rv
  )
  mod_arrumar_server(
    "arrumar_wider", base_resolvida, import_info,
    modo_fixo = "alargar", on_usar = adicionar_mudanca_compartilhada, base_externa_rv = base_externa_rv
  )
  mod_arrumar_server(
    "arrumar_sep", base_resolvida, import_info,
    modo_fixo = "separar", on_usar = adicionar_mudanca_compartilhada, base_externa_rv = base_externa_rv
  )
  # Selecionar, renomear, tipar e recodificar ficam centralizados neste módulo.
  # Ele lê o resultado do preparo para permitir renomear também variáveis calculadas.
  organizacao_compartilhada <- mod_organizar_variaveis_server(
    "organizar_variaveis", dados_analise,
    on_etapa = function(etapa) {
      if (length(replay_res()$erros)) {
        showNotification("Corrija as etapas com erro antes de adicionar ajustes.", type = "error")
        return(invisible(FALSE))
      }
      pipeline_rv(c(pipeline_rv(), list(etapa)))
      showNotification("Etapa de variáveis adicionada à Base Compartilhada.", type = "message")
    }
  )
  preparo_compartilhado <- mod_preparar_compartilhada_server(
    "preparar_compartilhada", dados_analise, replay_res, pipeline_rv,
    base_externa_rv, organizacao_compartilhada, import_info = import_info
  )
  mod_tratar_server("tratar", base_resolvida, replay_res, pipeline_rv, import_info,
                   base_externa_rv, grupo_rv = preparo_compartilhado$grupo)
  # Fases 3A/3B: cadastro, receita e replay lazy de ramos em estrela. Na 3B.3,
  # os módulos prioritários consomem os caches por meio dos seletores acima.
  bases_derivadas <- mod_bases_derivadas_server(
    "bases_derivadas", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, codigo_compartilhada_rv = preparo_compartilhado$codigo
  )
  anova_resultado <- mod_anova_server("anova", seletor_anova$dados, import_info, ficha_rv = ficha_delineamento_rv)
  anova_mista_resultado <- mod_anova_mista_server(
    "anova_mista", seletor_anova_mista$dados, ficha_delineamento_rv
  )
  anova2_resultado <- mod_anova_dois_fatores_server("anova2", seletor_anova2$dados, import_info)
  mod_ancova_server("ancova", dados_analise, import_info)

  # --- MÓDULOS DE TESTES NÃO PARAMÉTRICOS (um por item de menu; qui-quadrado usa a tabela preparada) ---
  qui_quadrado <- mod_nonparametric_server("np_qui", seletor_np_qui$dados, import_info, contingency_shared, "quiquadrado")
  mod_nonparametric_server("np_mw",  dados_analise, import_info, contingency_shared, "mannwhitney")
  mod_nonparametric_server("np_wil", dados_analise, import_info, contingency_shared, "wilcoxon")
  mod_nonparametric_server("np_kw",  dados_analise, import_info, contingency_shared, "kruskal")
  mod_pareados_categoricos_server(
    "friedman", "friedman", dados_analise, registro_bases_rv, cache_bases_rv,
    revisao_dados_analise_rv, registro_execucoes_rv, contador_execucoes_rv
  )
  pca_resultado <- mod_pca_server("pca", seletor_pca$dados, import_info)
  hca_resultado <- mod_hca_server("hca", seletor_hca$dados, import_info)

  # Fase 3C: o registro só acontece por clique. Cada módulo fornece um estado
  # leve; o registrador acrescenta o vínculo com a base e congela os parâmetros.
  registro_regression <- mod_registrar_execucao_server(
    "registrar_regression", regressao_linear$estado_execucao, seletor_regression$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "regression", "A Regressão Linear"
  )
  registro_logistic <- mod_registrar_execucao_server(
    "registrar_logistic", regressao_logistica$estado_execucao, regressao_logistica$base_contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "logistic_regression", "A Regressão Logística Binária"
  )
  registro_parametric <- mod_registrar_execucao_server(
    "registrar_parametric", teste_t$estado_execucao, seletor_parametric$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "parametric", "O Teste t"
  )
  registro_lines <- mod_registrar_execucao_server(
    "registrar_lines", grafico_linhas$estado_execucao, seletor_lines$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "lines", "O Gráfico de Linhas"
  )
  registro_np_qui <- mod_registrar_execucao_server(
    "registrar_np_qui", qui_quadrado$estado_execucao, seletor_np_qui$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "np_qui_quadrado", "O Qui-quadrado"
  )
  registro_anova <- mod_registrar_execucao_server(
    "registrar_anova", anova_resultado$estado_execucao, seletor_anova$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "anova", "A ANOVA"
  )
  registro_anova_mista <- mod_registrar_execucao_server(
    "registrar_anova_mista", anova_mista_resultado$estado_execucao,
    seletor_anova_mista$contexto, registro_execucoes_rv, contador_execucoes_rv,
    revisao_dados_analise_rv, registro_bases_rv, cache_bases_rv,
    "anova_mista", "A ANOVA com subamostras"
  )
  registro_anova2 <- mod_registrar_execucao_server(
    "registrar_anova2", anova2_resultado$estado_execucao, seletor_anova2$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "anova_dois_fatores", "A ANOVA de dois fatores"
  )
  registro_pca <- mod_registrar_execucao_server(
    "registrar_pca", pca_resultado$estado_execucao, seletor_pca$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "pca", "A PCA"
  )
  registro_hca <- mod_registrar_execucao_server(
    "registrar_hca", hca_resultado$estado_execucao, seletor_hca$contexto,
    registro_execucoes_rv, contador_execucoes_rv, revisao_dados_analise_rv,
    registro_bases_rv, cache_bases_rv, "hca", "A Análise de Agrupamentos"
  )
  delineamentos_experimentais <- list(
    dic = mod_experimental_design_server("experimental_dic"),
    dbc = mod_experimental_design_server("experimental_dbc"),
    dql = mod_experimental_design_server("experimental_dql"),
    fatorial = mod_experimental_design_server("experimental_fatorial"),
    split_plot = mod_experimental_design_server("experimental_split_plot")
  )
  for (tipo in names(catalogo_delineamentos_observacionais())) {
    mod_planejamento_observacional_server(
      paste0("obs_", tipo), tipo, ficha_destino_rv = ficha_delineamento_rv
    )
    mod_planejamento_variaveis_server(
      paste0("variables_obs_", tipo),
      estrutura_rv = sorteio_planejado,
      ficha_destino_rv = ficha_delineamento_rv
    )
  }
  mod_monitoramento_server("monitoramento")
  for (tipo in names(delineamentos_experimentais)) {
    mod_planejamento_variaveis_server(
      paste0("variables_exp_", tipo), delineamentos_experimentais[[tipo]],
      ficha_destino_rv = ficha_delineamento_rv
    )
  }
  
  # Zera as renomeações de colunas ao carregar ou trocar o conjunto de dados
  observeEvent(raw_data(), {
    col_renames_rv(character(0))
  }, ignoreInit = FALSE)

}

# Inicializa o app
shinyApp(ui, server)
