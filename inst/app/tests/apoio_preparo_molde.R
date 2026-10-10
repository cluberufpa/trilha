# Apoio dos testes de preparo. Executa o roteiro exportado (rota ClaRa) até a
# base da análise, antes da análise estatística, que tem testes próprios. A
# receita vai da planilha até `base` num só encadeamento; o relatório repete a
# mesma receita, com a mesma trava do número de linhas.
executar_preparo_molde <- function(projeto) {
  script <- file.path(projeto, "R", "analise.R")
  expressoes <- parse(script, encoding = "UTF-8")
  inicio_analise <- which(vapply(expressoes, function(x) {
    is.call(x) && identical(x[[1]], as.name("<-")) &&
      identical(x[[2]], as.name("resultado"))
  }, logical(1)))
  stopifnot(length(inicio_analise) == 1L, inicio_analise > 1L)
  # O relatório roda sozinho, com a mesma trava do número de linhas.
  linhas <- readLines(script, encoding = "UTF-8")
  qmd <- readLines(file.path(projeto, "relatorios", "relatorio.qmd"), encoding = "UTF-8")
  trava <- grep("^stopifnot\\(nrow\\(base\\) == [0-9]+L\\)$", linhas, value = TRUE)
  stopifnot(length(trava) == 1L, is.element(trava, qmd))
  anterior <- getwd()
  on.exit(setwd(anterior), add = TRUE)
  setwd(projeto)
  ambiente <- new.env(parent = globalenv())
  utils::capture.output(eval(expressoes[seq_len(inicio_analise - 1L)], envir = ambiente))
  ambiente
}
