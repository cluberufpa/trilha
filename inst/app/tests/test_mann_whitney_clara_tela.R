# Execute de inst/app. A tela do Mann-Whitney roda a ClaRa: a chamada que
# ela avalia é a que o Projeto R escreve, os números batem com o
# wilcox.test() nas três hipóteses (bilateral, maior e menor), as abas se
# montam sem erro e o Mann-Whitney sai pela rota ClaRa das medianas.
source("app.R", encoding = "UTF-8")

artemias <- as.data.frame(EAPADados::artemia)
info_rv <- reactive(list(source = "package", package_dataset = "artemia"))
alternativas_r <- c(two.sided = "bilateral", greater = "maior", less = "menor")

for (alternativa in names(alternativas_r)) {
  testServer(mod_nonparametric_server,
             args = list(data_rv = reactive(artemias), import_info = info_rv,
                         fixed_test = "mannwhitney"), {
    session$setInputs(mw_y = "taxa_crescimento_mg_dia", mw_x = "racao", mw_alt = alternativa,
                      active_tab = "Resultado do Teste")
    session$setInputs(executar_analise = 1)
    res <- test_results()
    estado <- estado_execucao()
    referencia <- wilcox.test(taxa_crescimento_mg_dia ~ racao, data = artemias, exact = FALSE,
                              conf.int = TRUE, alternative = alternativa)
    item <- list(tipo = "mann_whitney", parametros = estado$parametros)
    stopifnot(
      identical(exec_ctrl$estado(), "atualizada"),
      inherits(res$clara$resultado, "clara_medianas"),
      # A chamada da tela é a que o estado registrado escreve no projeto.
      identical(res$clara$chamada, exportacao_medianas_clara_chamada(item, "tela")),
      identical(res$clara$resultado$nomes$alternativa, alternativas_r[[alternativa]]),
      isTRUE(all.equal(res$clara$resultado$teste$p, referencia$p.value)),
      isTRUE(all.equal(estado$resultado_resumo$p_valor, referencia$p.value)),
      identical(estado$tipo, "mann_whitney"),
      identical(estado$parametros$alternativa, alternativa)
    )
    # O painel, a figura e o código se montam sem erro, e o código é R válido.
    stopifnot(grepl("comparar_medianas", as.character(output$clara_ui$html), fixed = TRUE))
    invisible(output$test_plot)
    invisible(parse(text = r_code_np()))
  })
}

# Três grupos não são um Mann-Whitney: a tela pede o Kruskal-Wallis.
tres <- rbind(artemias, data.frame(racao = "C", taxa_crescimento_mg_dia = c(3, 3.4, 3.9)))
testServer(mod_nonparametric_server,
           args = list(data_rv = reactive(tres), import_info = info_rv, fixed_test = "mannwhitney"), {
  session$setInputs(mw_y = "taxa_crescimento_mg_dia", mw_x = "racao", mw_alt = "two.sided")
  session$setInputs(executar_analise = 1)
  mensagem <- tryCatch({ test_results(); "" }, error = function(e) conditionMessage(e))
  stopifnot(grepl("Kruskal-Wallis", mensagem, fixed = TRUE))
})

# O Mann-Whitney sai pela rota ClaRa das medianas e passa na validação do
# manifesto; com a ClaRa desligada (registros antigos), não há rota para ele.
manifesto <- list(secoes_globais = list(), execucoes = list(e = list(
  tipo = "mann_whitney", incluir_word = TRUE, estado_dependencia = "Atualizada",
  saidas_word = c("narrativa", "tabela"),
  parametros = list(resposta = "taxa_crescimento_mg_dia", grupo = "racao",
                    alternativa = "less", nivel_confianca = .95))))
stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, "medianas_clara"),
          exportacao_validar_manifesto(manifesto)$ok)
manifesto$codigo_clara <- FALSE
stopifnot(is.null(exportacao_molde_projeto_entrada(manifesto)))

cat("OK: tela do Mann-Whitney com a ClaRa (bilateral, maior e menor).\n")
