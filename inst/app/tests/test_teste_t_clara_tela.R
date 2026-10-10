# Execute de inst/app. A tela do teste t de duas amostras roda a ClaRa: a
# chamada que ela avalia é a que o Projeto R escreve, os números batem com
# o t.test() nas três hipóteses (bilateral, maior e menor) e as abas se
# montam sem erro.
source("app.R", encoding = "UTF-8")

dados <- data.frame(
  peso_g = c(86, 83, 91, 84, 87, 88, 87, 94, 86, 89),
  racao = factor(rep(c("A", "B"), each = 5))
)
info_rv <- reactive(list(source = "package", package_dataset = "bagres_teste"))

for (alternativa in c("two.sided", "greater", "less")) {
  testServer(mod_parametric_server, args = list(data_rv = reactive(dados), import_info = info_rv), {
    session$setInputs(
      test_type = "two_ind", two_var_y = "peso_g", two_var_x = "racao",
      two_var_equal = TRUE, alternative = alternativa, conf_level = 95,
      graph_theme = "minimal", custom_title = "", custom_label_x = "", custom_label_y = "",
      active_tab = "Tabela de Resultados"
    )
    session$setInputs(executar_analise = 1)
    res <- test_results()
    estado <- estado_execucao()
    referencia <- t.test(peso_g ~ racao, data = dados, var.equal = TRUE, alternative = alternativa)
    item <- list(tipo = "teste_t_two_ind", parametros = estado$parametros)
    stopifnot(
      inherits(res$clara$resultado, "clara_medias"),
      # A chamada da tela é a que o estado registrado escreve no projeto.
      identical(res$clara$chamada, exportacao_teste_t_clara_chamada(item, "tela")),
      isTRUE(all.equal(res$t_out$p.value, referencia$p.value)),
      isTRUE(all.equal(unname(res$t_out$conf.int), unname(referencia$conf.int[1:2]))),
      isTRUE(all.equal(estado$resultado_resumo$p_valor, referencia$p.value)),
      identical(estado$parametros$alternativa, alternativa)
    )
    # As saídas da tela se montam sem erro.
    stopifnot(nzchar(as.character(output$results_summary$html)))
    invisible(output$hypothesis_text)
    invisible(output$normality_test_out)
  })
}

# O teste t sai pela rota ClaRa, a padrão; só o exportador a desliga, nos
# registros antigos com fotografia da base, e aí sai pelo exportador geral.
manifesto <- list(secoes_globais = list(), execucoes = list(e = list(
  tipo = "teste_t_two_ind", incluir_word = TRUE,
  parametros = list(resposta = "peso_g", grupo = "racao", variancias_iguais = TRUE,
                    alternativa = "greater", nivel_confianca = .95))))
stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, "teste_t_clara"))
manifesto$codigo_clara <- FALSE
stopifnot(is.null(exportacao_molde_projeto_entrada(manifesto)))

cat("OK: tela do teste t de duas amostras com a ClaRa (bilateral, maior e menor).\n")
