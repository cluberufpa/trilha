# Execute de inst/app. A tela da regressão linear simples roda a ClaRa
# quando há uma reta só: a chamada que ela avalia é a que o Projeto R
# escreve, os números batem com o lm() e as abas se montam sem erro. Com
# "uma reta por grupo", a tela segue no caminho antigo, sem a ClaRa.
source("app.R", encoding = "UTF-8")

barbos <- as.data.frame(EAPADados::morfometria_barbo)
info_rv <- reactive(list(source = "package", package_dataset = "morfometria_barbo"))
referencia <- lm(altura_maxima_corpo ~ distancia_dorsal_pelvica, data = barbos)

entradas <- function(session, grupo = "none", por_grupo = FALSE, autocorrelacao = FALSE) {
  session$setInputs(
    var_y = "altura_maxima_corpo", var_x = "distancia_dorsal_pelvica",
    model_type = "linear", var_group = grupo, grp_reg = por_grupo,
    grp_color = TRUE, grp_fill = TRUE, avaliar_autocorrelacao = autocorrelacao,
    conf_level = 95, graph_theme = "minimal", show_eq = TRUE,
    custom_title = "", custom_label_x = "Distância dorsal-pélvica (mm)",
    custom_label_y = "Altura máxima do corpo (mm)",
    resid_title = "", resid_label_x = "", resid_label_y = "",
    qq_title = "", qq_label_x = "", qq_label_y = "",
    active_tab = "Tabela de Resultados"
  )
  session$setInputs(executar_analise = 1)
}

# 1. Uma reta só, sem grupo e com a cor por população: a ClaRa.
for (grupo in c("none", "populacao")) {
  testServer(mod_regression_server, args = list(data_rv = reactive(barbos), import_info = info_rv), {
    entradas(session, grupo = grupo, autocorrelacao = identical(grupo, "populacao"))
    r <- clara_rv()
    estado <- estado_execucao()
    item <- list(tipo = "regressao_linear", parametros = estado$parametros)
    stopifnot(
      inherits(r$resultado, "clara_regressao"),
      # A chamada da tela é a que o estado registrado escreve no projeto.
      identical(r$chamada, exportacao_regressao_clara_chamada(item, "tela")),
      isTRUE(all.equal(r$resultado$coeficientes$estimativa, unname(coef(referencia)))),
      isTRUE(all.equal(r$resultado$ajuste$r2, summary(referencia)$r.squared)),
      identical(nrow(r$resultado$pressupostos), if (identical(grupo, "populacao")) 3L else 2L),
      identical(r$resultado$nomes$rotulo_resposta, "Altura máxima do corpo (mm)")
    )
    # O painel, as três figuras e o código se montam sem erro.
    stopifnot(grepl("relacionar_variaveis", as.character(output$tabela_resultados_ui$html), fixed = TRUE))
    invisible(output$fit_plot)
    invisible(output$resid_fit_plot)
    invisible(output$qq_plot)
    stopifnot(any(grepl("relacionar_variaveis(", r_code_text(), fixed = TRUE)),
              grepl("lm(altura_maxima_corpo ~ distancia_dorsal_pelvica", r_code_text(), fixed = TRUE))
  })
}

# 2. Uma reta por grupo: outro modelo, sem a ClaRa; a tela usa o caminho antigo.
testServer(mod_regression_server, args = list(data_rv = reactive(barbos), import_info = info_rv), {
  entradas(session, grupo = "populacao", por_grupo = TRUE)
  stopifnot(is.null(clara_rv()), inherits(model_fit(), "lm"))
  invisible(output$fit_plot)
  stopifnot(!grepl("relacionar_variaveis", as.character(output$tabela_resultados_ui$html), fixed = TRUE))
})

# 3. A regressão com uma reta sai pela rota ClaRa; com retas por grupo, pelo
#    molde antigo; com a ClaRa desligada (registros antigos), também.
item <- function(por_grupo) list(tipo = "regressao_linear", incluir_word = TRUE,
  parametros = list(resposta = "altura_maxima_corpo", preditor = "distancia_dorsal_pelvica",
                    grupo = "populacao", tipo_modelo = "linear", regressao_por_grupo = por_grupo,
                    nivel_confianca = .95))
manifesto <- list(secoes_globais = list(), execucoes = list(e = item(FALSE)))
stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, "regressao_clara"))
manifesto$execucoes$e <- item(TRUE)
stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, "regressao_linear"))
manifesto$execucoes$e <- item(FALSE)
manifesto$codigo_clara <- FALSE
stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, "regressao_linear"))

cat("OK: tela da regressão linear simples com a ClaRa (reta única e cor por grupo).\n")
