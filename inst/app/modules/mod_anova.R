# Módulo de ANOVA de um fator, com a ClaRa
# -----------------------------------------------------------------------------
# A tela mostra o resultado da mesma chamada da ClaRa que o Projeto R escreve:
#
#   escolhas da tela -> exportacao_anova_clara_chamada() -> texto da chamada
#     -> a tela avalia o texto com o pacote clara e mostra o resultado;
#     -> o exportador escreve o mesmo texto em R/analise.R e no relatório.
#
# A ClaRa nunca escolhe o teste sozinha: no método automático, quem escolhe é
# a tela, pelo Levene, e a escolha entra na chamada em variancias_iguais. Com
# dois grupos, comparar_medias() faz o teste t (decisão do professor, 10/10/2026).
# Fluxo do resto não muda: Base Compartilhada ou Derivada -> Executar análise
# -> Adicionar aos resultados -> Comunicação -> Projeto R.

library(shiny)
library(bslib)
library(ggplot2)
library(DT)

# anova_validar_entrada() e as funções do molde antigo da ANOVA, que o
# exportador ainda usa quando a opção da ClaRa fica desmarcada.
if (file.exists("templates/funcoes_anova.R")) {
  source("templates/funcoes_anova.R")
}

anova_titulo_secao <- function(texto) {
  h6(texto, style = "font-family: 'Outfit'; font-weight: 700; color: #0F3B5F; margin-top: 6px;")
}

# ---- A análise pela ClaRa -----------------------------------------------------

# O método que a chamada escreve. Na escolha automática, o Levene (centro na
# mediana, como na ClaRa) decide no alfa da confiança escolhida: com
# evidência de variâncias diferentes, Welch; sem ela, a clássica. Se o Levene
# não der resultado, Welch, que é a escolha conservadora.
anova_clara_metodo_usado <- function(df, resposta, fator, metodo, nivel_confianca) {
  if (!identical(metodo, "auto")) return(metodo)
  d <- df[stats::complete.cases(df[c(resposta, fator)]), c(resposta, fator), drop = FALSE]
  names(d) <- c("resposta", "fator")
  d$fator <- droplevels(factor(d$fator))
  levene_p <- tryCatch(
    suppressWarnings(car::leveneTest(resposta ~ fator, data = d, center = stats::median)[["Pr(>F)"]][1]),
    error = function(e) NA_real_)
  if (is.na(levene_p) || levene_p < 1 - nivel_confianca) "welch" else "classica"
}

# Roda a análise como o projeto vai rodar: monta o texto da chamada com a
# mesma função do exportador e o avalia num ambiente em que `base` é a base
# escolhida na tela. Devolve a chamada, o resultado, o efeito e as frases.
anova_clara_rodar <- function(df, parametros) {
  item <- list(tipo = "anova_um_fator", parametros = parametros)
  # Com dois grupos, a chamada é a do teste t (com a hipótese bilateral
  # escrita), a mesma que o projeto do teste t em ClaRa escreve.
  completos <- stats::complete.cases(df[c(parametros$resposta, parametros$fator)])
  grupos <- length(unique(as.character(df[[parametros$fator]][completos])))
  chamada <- if (grupos == 2L) exportacao_teste_t_clara_chamada(item, "tela") else
    exportacao_anova_clara_chamada(item, "tela")
  ambiente <- new.env(parent = asNamespace("clara"))
  ambiente$base <- df
  eval(parse(text = chamada, encoding = "UTF-8")[[1]], envir = ambiente)
  resultado <- ambiente$resultado
  list(
    parametros = parametros,
    chamada = chamada,
    resultado = resultado,
    efeito = clara::medir_efeito(resultado),
    textos = clara::escrever_resultados(resultado, casas = 2),
    analise = resultado$nomes$analise,
    metodo_usado = parametros$metodo_usado,
    versao_clara = as.character(utils::packageVersion("clara"))
  )
}

# O R comum por trás da chamada: a mesma chamada, com mostrar_codigo = TRUE.
anova_clara_codigo <- function(r, df) {
  chamada <- r$chamada
  chamada[length(chamada)] <- sub("[)]$", ",", chamada[length(chamada)])
  recuo <- strrep(" ", nchar("  comparar_medias("))
  chamada <- c(chamada, paste0(recuo, "mostrar_codigo    = TRUE)"))
  ambiente <- new.env(parent = asNamespace("clara"))
  ambiente$base <- df
  utils::capture.output(invisible(eval(parse(text = chamada, encoding = "UTF-8")[[1]], envir = ambiente)))
}

# Uma tabela qualquer no tema cinza da ClaRa, pronta para a tela.
anova_clara_tabela <- function(tabela) {
  flextable::htmltools_value(clara::exibir_tabela(tabela, tema = "cinza"))
}

# O resumo que fica registrado com a execução. Na ANOVA, F e GL da tabela;
# no teste t (dois grupos), F = t² com 1 e GL do t, a mesma prova.
anova_clara_resumo <- function(r) {
  res <- r$resultado
  efeito <- r$efeito
  valor_efeito <- function(padrao) {
    i <- grep(padrao, efeito$medida)
    if (length(i)) unname(efeito$valor[i[1]]) else NA_real_
  }
  if (identical(r$analise, "teste_t")) {
    f <- unname(res$teste$t[1])^2
    gl <- c(1, unname(res$teste$gl[1]))
    p <- unname(res$teste$p[1])
  } else {
    f <- unname(res$anova$f[1])
    gl <- unname(res$anova$gl[1:2])
    p <- unname(res$anova$p[1])
  }
  list(
    n = as.integer(res$amostra$usadas),
    excluidos = as.integer(res$amostra$excluidas),
    grupos = nrow(res$resumo),
    analise = r$analise,
    f = f, gl_1 = gl[1], gl_2 = gl[2], p = p,
    eta2 = if (identical(r$analise, "anova")) valor_efeito("^η²") else NA_real_,
    omega2 = valor_efeito("^ω²")
  )
}

mod_anova_ui <- function(id) {
  ns <- NS(id)
  tagList(
    layout_columns(
      col_widths = c(1, 1, 1),
      style = "grid-template-columns: 2.5fr 7fr 2.5fr !important;",

      # COLUNA 1: CONFIGURAÇÃO DO MODELO
      div(
        card(
          card_header("Configuração da ANOVA"),
          card_body(
            style = "padding: 12px 15px;",
            uiOutput(ns("aviso_ficha")),
            selectInput(ns("var_y"), "Variável resposta (Y — numérica):", choices = NULL),
            selectInput(ns("var_x"), "Fator / grupo (X — categórico):", choices = NULL),
            selectInput(ns("metodo"), "Método da ANOVA:",
              choices = c("Automático, conforme Levene" = "auto",
                "Clássica com Tukey" = "classica", "Welch com Games-Howell" = "welch"),
              selected = "auto"),
            sliderInput(ns("conf_level"), "Nível de confiança (%):",
                        min = 80, max = 99, value = 95, step = 1),
            helpText(
              "Com dois grupos, a comparação das médias é o teste t (Student ou Welch,",
              "conforme o método).",
              style = "font-size: 0.78rem;"
            ),
            execucao_explicita_controles_ui(ns)
          )
        ),
        card(
          card_header("Relatório e Projeto R"),
          card_body(
            style = "padding: 12px 15px;",
            div(
              class = "alert alert-light border small mb-0",
              icon("file-export"), " ",
              "Baixe o Projeto R em ",
              strong("Comunicação de Resultados"), ". Execute a análise, clique em ",
              strong("Adicionar ao Projeto R"), " e escolha lá os componentes do relatório. ",
              "No RStudio, abra o projeto e use Render para gerar o Word."
            )
          )
        )
      ),

      # COLUNA 2: RESULTADOS (divulgação progressiva)
      execucao_explicita_resultados_ui(ns, navset_card_tab(
        id = ns("active_tab"),
        title = "Painel de Resultados da ANOVA:",
        nav_panel(
          title = "Resultado principal",
          icon = icon("square-poll-vertical"),
          card_body(uiOutput(ns("principal_ui")))
        ),
        nav_panel(
          title = "Comparações",
          icon = icon("arrow-right-arrow-left"),
          card_body(uiOutput(ns("tukey_ui")))
        ),
        nav_panel(
          title = "Pressupostos e diagnósticos",
          icon = icon("circle-check"),
          card_body(uiOutput(ns("pressupostos_ui")))
        ),
        nav_panel(
          title = "Código e console",
          icon = icon("terminal"),
          card_body(uiOutput(ns("codigo_ui")))
        )
      )),

      # COLUNA 3: CONFIGURAÇÕES DE EXIBIÇÃO
      card(
        card_header("Configurações de exibição"),
        card_body(
          style = "padding: 10px 12px;",
          textInput(ns("custom_title"), "Título do gráfico:", value = ""),
          textInput(ns("custom_label_x"), "Nome dos grupos (eixo X):", value = ""),
          textInput(ns("custom_label_y"), "Nome da resposta (eixo Y):", value = ""),
          helpText(
            "Os nomes entram nas figuras, nas tabelas e nas frases, e vão escritos",
            "na chamada da ClaRa do Projeto R. Mudar um campo deixa a execução",
            "pendente: o relatório precisa refletir exatamente o que você viu.",
            style = "font-size: 0.78rem;"
          )
        )
      )
    )
  )
}

# ficha_rv (opcional): ficha de planejamento; quando sugere esta ANOVA, suas
# colunas de resposta e de grupo são pré-selecionadas.
mod_anova_server <- function(id, data_rv, import_info, ficha_rv = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    revisao_execucao <- execucao_revisao_dados(data_rv)
    gatilho_execucao <- reactiveVal(0L)

    # Atualiza seletores preservando a escolha do usuário quando ela continua válida.
    observe({
      df <- data_rv()
      req(df)
      cols <- names(df)
      num_cols <- cols[vapply(df, is.numeric, logical(1))]
      cat_cols <- cols[
        !vapply(df, is.numeric, logical(1)) |
          vapply(df, function(x) length(unique(x[!is.na(x)])) < 15L, logical(1))
      ]
      if (!length(num_cols)) num_cols <- cols
      if (!length(cat_cols)) cat_cols <- cols

      y_atual <- isolate(input$var_y)
      x_atual <- isolate(input$var_x)
      if (is.null(y_atual) || !y_atual %in% num_cols) y_atual <- num_cols[1]
      if (is.null(x_atual) || !x_atual %in% cat_cols) {
        alternativas <- setdiff(cat_cols, y_atual)
        x_atual <- if (length(alternativas)) alternativas[1] else cat_cols[1]
      }
      # Quando a ficha de planejamento sugere esta ANOVA, suas colunas têm prioridade.
      ficha <- if (is.function(ficha_rv)) ficha_rv() else NULL
      if (identical(ficha$analise_sugerida, "anova_um_fator")) {
        if (isTRUE(ficha$resposta_coluna %in% num_cols)) y_atual <- ficha$resposta_coluna
        if (ficha_fator_coluna(ficha) %in% cat_cols) x_atual <- ficha_fator_coluna(ficha)
      }
      updateSelectInput(session, "var_y", choices = num_cols, selected = y_atual)
      updateSelectInput(session, "var_x", choices = cat_cols, selected = x_atual)
    })

    # A sugestão de teste chega do planejamento, sem ser reescolhida do zero.
    output$aviso_ficha <- renderUI({
      if (!is.function(ficha_rv)) return(NULL)
      ficha_aviso_analise_ui(ficha_rv(), "anova_um_fator")
    })
    nivel_confianca <- reactive({
      valor <- suppressWarnings(as.numeric(input$conf_level))
      if (!length(valor) || is.na(valor)) valor <- 95
      valor / 100
    })

    assinatura_execucao <- reactive({
      req(input$var_y, input$var_x)
      execucao_assinatura(
        input,
        c("var_y", "var_x", "conf_level", "metodo",
          "custom_title", "custom_label_x", "custom_label_y"),
        revisao_execucao()
      )
    })

    # A validação acontece antes da análise e devolve mensagem com ação
    # corretiva; as recusas da própria ClaRa (nome de coluna com espaço,
    # grupo com menos de três observações) chegam com a mensagem dela.
    result_rv <- eventReactive(gatilho_execucao(), {
      df <- data_rv()
      req(df, input$var_y, input$var_x)
      mensagem <- anova_validar_entrada(df, input$var_y, input$var_x)
      if (!is.null(mensagem)) stop(mensagem, call. = FALSE)
      metodo <- input$metodo %||% "auto"
      parametros <- list(
        resposta = input$var_y,
        fator = input$var_x,
        nivel_confianca = nivel_confianca(),
        metodo = metodo,
        metodo_usado = anova_clara_metodo_usado(df, input$var_y, input$var_x,
                                                metodo, nivel_confianca()),
        titulo_grafico = input$custom_title %||% "",
        rotulo_x = input$custom_label_x %||% "",
        rotulo_y = input$custom_label_y %||% ""
      )
      anova_clara_rodar(df, parametros)
    }, ignoreInit = FALSE)

    exec_ctrl <- execucao_explicita_server(
      input, output, session, assinatura_execucao, result_rv,
      nome_analise = "A ANOVA",
      gatilho_rv = gatilho_execucao
    )

    # ---- 1. Resultado principal ----------------------------------------------
    output$principal_ui <- renderUI({
      r <- result_rv()
      req(r)
      res <- r$resultado
      textos <- unclass(r$textos)
      frases <- unlist(textos[c("amostra", "teste", "efeito", "comparacoes", "destaque")],
                       use.names = FALSE)
      avisos <- unlist(textos[c("alerta", "poder")], use.names = FALSE)
      avisos <- avisos[nzchar(avisos)]
      pequenos <- as.character(res$resumo[[res$nomes$grupos]][res$resumo$n < 5L])
      metodo_texto <- switch(r$analise,
        anova = "ANOVA clássica, com Tukey",
        anova_welch = "ANOVA de Welch, com Games-Howell",
        teste_t = if (isTRUE(res$nomes$variancias_iguais)) "teste t de Student (dois grupos)" else
          "teste t de Welch (dois grupos)")
      tagList(
        div(class = "small text-muted mb-2",
            sprintf("Análise feita: %s%s. ClaRa %s.", metodo_texto,
                    if (identical(r$parametros$metodo, "auto")) ", escolhida pelo Levene" else "",
                    r$versao_clara)),
        anova_titulo_secao("Narrativa automática"),
        div(class = "alert alert-secondary", style = "font-size: 0.9rem; line-height: 1.45;",
            paste(frases[nzchar(frases)], collapse = " ")),
        if (res$amostra$excluidas > 0) div(
          class = "alert alert-warning py-2 small",
          icon("filter"), sprintf(
            " %d linha(s) foram excluídas por dados faltantes em '%s' ou '%s'. Restaram %d observações.",
            res$amostra$excluidas, res$nomes$resposta, res$nomes$grupos, res$amostra$usadas
          )
        ),
        if (length(pequenos)) div(
          class = "alert alert-warning py-2 small",
          icon("triangle-exclamation"),
          sprintf(" Grupos com menos de cinco observações: %s.", paste(pequenos, collapse = ", "))
        ),
        lapply(avisos, function(a) div(class = "alert alert-light border py-2 small", a)),
        hr(),
        anova_titulo_secao("Resumo por grupo"),
        flextable::htmltools_value(clara::exibir_resumo(res, casas = 2, tema = "cinza")),
        if (!identical(r$analise, "teste_t")) helpText(
          "As letras sobrescritas resumem as comparações: grupos que compartilham",
          "ao menos uma letra não apresentaram evidência de diferença entre si.",
          "A letra 'a' fica com o grupo de maior média.",
          style = "font-size: 0.82rem;"
        ),
        hr(),
        anova_titulo_secao(if (identical(r$analise, "teste_t")) "Teste t" else "Tabela da ANOVA"),
        flextable::htmltools_value(clara::exibir_teste(res, tema = "cinza")),
        anova_titulo_secao("Tamanho de efeito"),
        anova_clara_tabela(data.frame(
          Medida = r$efeito$medida,
          Valor = clara::formatar_numero(r$efeito$valor, 3),
          `IC inferior` = clara::formatar_numero(r$efeito$ic_inf, 3),
          `IC superior` = clara::formatar_numero(r$efeito$ic_sup, 3),
          Leitura = r$efeito$leitura,
          check.names = FALSE)),
        helpText(
          "A coluna Leitura usa as convenções de Cohen. É referência estatística, não",
          "interpretação biológica: um efeito pequeno pode importar no manejo, e um",
          "grande pode ser irrelevante na prática.",
          style = "font-size: 0.82rem;"
        ),
        hr(),
        anova_titulo_secao("Gráfico principal"),
        plotOutput(ns("fit_plot"), height = "440px"),
        anova_titulo_secao("Boxplot exploratório"),
        plotOutput(ns("box_plot"), height = "380px")
      )
    })

    # A figura principal com as mesmas escolhas da seção 6.2 do roteiro.
    grafico_principal <- reactive({
      r <- result_rv(); req(r)
      titulo <- trimws(r$parametros$titulo_grafico %||% "")
      clara::grafico_medias(r$resultado,
                            titulo           = if (nzchar(titulo)) titulo else NULL,
                            explicacao       = TRUE,
                            haste            = "ic",
                            mostrar_barras   = TRUE,
                            largura_barras   = 0.3,
                            mostrar_pontos   = TRUE,
                            mostrar_media_dp = TRUE,
                            casas            = 1,
                            angulo_rotulo    = -90,
                            mostrar_letras   = TRUE,
                            cores            = "ocean",
                            tamanho_texto    = 12,
                            fonte            = "sans")
    })

    output$fit_plot <- renderPlot({ grafico_principal() })

    output$box_plot <- renderPlot({
      r <- result_rv(); req(r)
      clara::grafico_boxplot(r$resultado)
    })

    # ---- 2. Comparações -------------------------------------------------------
    output$tukey_ui <- renderUI({
      r <- result_rv()
      req(r)
      if (identical(r$analise, "teste_t")) {
        return(tagList(
          helpText("Com dois grupos há uma comparação só: o próprio teste t, na aba",
                   "Resultado principal."),
          plotOutput(ns("tukey_pares_plot"), height = "300px")
        ))
      }
      res <- r$resultado
      pos_teste <- if (identical(r$analise, "anova_welch")) "Games-Howell" else "Tukey"
      tagList(
        anova_titulo_secao(sprintf("Comparações múltiplas de %s (IC %s%%)", pos_teste,
                                   clara::formatar_numero(100 * res$nomes$confianca, 0))),
        plotOutput(ns("tukey_pares_plot"), height = "380px"),
        anova_clara_tabela(data.frame(
          Comparação = res$pares[[1]],
          Diferença = clara::formatar_numero(res$pares[[2]]),
          `IC inferior` = clara::formatar_numero(res$pares[[3]]),
          `IC superior` = clara::formatar_numero(res$pares[[4]]),
          `p ajustado` = clara::formatar_p(res$pares[[5]]),
          check.names = FALSE)),
        helpText(
          "As comparações são sempre calculadas para manter a reprodutibilidade.",
          "A interpretação principal, porém, decorre da ANOVA global e do plano",
          "analítico definido antes da coleta, não de uma varredura de pares.",
          style = "font-size: 0.85rem;"
        )
      )
    })

    output$tukey_pares_plot <- renderPlot({
      r <- result_rv(); req(r)
      clara::grafico_pares(r$resultado)
    })

    # ---- 3. Pressupostos e diagnósticos --------------------------------------
    output$pressupostos_ui <- renderUI({
      r <- result_rv()
      req(r)
      res <- r$resultado
      tagList(
        anova_titulo_secao("Testes de pressupostos"),
        anova_clara_tabela(data.frame(
          Pressuposto = res$pressupostos$pressuposto,
          Teste = res$pressupostos$teste,
          Estatística = clara::formatar_numero(res$pressupostos$estatistica, 3),
          p = clara::formatar_p(res$pressupostos$p),
          Leitura = res$pressupostos$leitura)),
        div(class = "alert alert-light border py-2 small", unclass(r$textos)$pressupostos),
        helpText(
          "Um p-valor alto não comprova o pressuposto: apenas indica que estes dados",
          "não revelaram afastamento detectável. Olhe também os gráficos abaixo.",
          if (!identical(r$analise, "anova"))
            "Sem a suposição de variâncias iguais, a normalidade é conferida em cada grupo.",
          style = "font-size: 0.85rem;"
        ),
        hr(),
        anova_titulo_secao("Inspeção gráfica dos resíduos"),
        layout_columns(
          plotOutput(ns("resid_fit_plot"), height = "380px"),
          plotOutput(ns("qq_plot"), height = "380px")
        )
      )
    })

    output$resid_fit_plot <- renderPlot({
      r <- result_rv(); req(r)
      clara::grafico_residuos(r$resultado)
    })

    output$qq_plot <- renderPlot({
      r <- result_rv(); req(r)
      clara::grafico_qq(r$resultado)
    })

    # ---- 4. Código e console --------------------------------------------------
    # A chamada é a que vai escrita no Projeto R; abaixo dela, o que a ClaRa
    # imprime no console e o R comum que rodou por baixo.
    output$codigo_ui <- renderUI({
      r <- result_rv(); req(r)
      tagList(
        anova_titulo_secao("A chamada da ClaRa"),
        helpText(
          "Este é o código que rodou e que vai escrito em R/analise.R e no relatório",
          "do Projeto R. A base preparada se chama base.",
          style = "font-size: 0.85rem;"
        ),
        tags$pre(paste(r$chamada, collapse = "\n")),
        anova_titulo_secao("O que a ClaRa mostra no console"),
        tags$pre(paste(utils::capture.output(print(r$resultado)), collapse = "\n")),
        anova_titulo_secao("O R comum por trás da chamada"),
        helpText(
          "Com mostrar_codigo = TRUE, a ClaRa imprime o código R que rodou. Ele roda",
          "sozinho, sem a ClaRa: vale conhecê-lo para não se perder fora do ecossistema.",
          style = "font-size: 0.85rem;"
        ),
        tags$pre(paste(anova_clara_codigo(r, data_rv()), collapse = "\n"))
      )
    })

    # ---- Estado canônico registrado ------------------------------------------
    estado_execucao <- reactive({
      req(exec_ctrl$atualizada())
      r <- result_rv()
      req(r)
      p <- r$parametros
      titulo <- if (nzchar(p$titulo_grafico)) {
        p$titulo_grafico
      } else {
        sprintf("%s entre grupos de %s", p$resposta, p$fator)
      }
      list(
        analise_id = "anova",
        tipo = "anova_um_fator",
        titulo = titulo,
        parametros = list(
          resposta = p$resposta,
          fator = p$fator,
          nivel_confianca = p$nivel_confianca,
          metodo = p$metodo,
          metodo_usado = p$metodo_usado,
          ajuste_comparacoes = if (identical(p$metodo_usado, "welch")) "games_howell" else "tukey",
          # A figura é a da ClaRa; o tema fica registrado para o molde antigo.
          tema = "minimal",
          titulo_grafico = p$titulo_grafico,
          rotulo_x = p$rotulo_x,
          rotulo_y = p$rotulo_y
        ),
        # O console fica fora do relatório: a aba existe na interface para
        # estudo, mas a saída bruta não vai para o Word.
        saidas_disponiveis = c(
          "narrativa", "descritivos", "tabela", "comparacoes",
          "grafico", "pressupostos", "diagnosticos"
        ),
        resultado_resumo = anova_clara_resumo(r)
      )
    })

    invisible(list(
      resultado = result_rv,
      grafico = grafico_principal,
      estado_execucao = estado_execucao,
      estado_execucao_ui = exec_ctrl$estado,
      execucao_atualizada = exec_ctrl$atualizada
    ))
  })
}
