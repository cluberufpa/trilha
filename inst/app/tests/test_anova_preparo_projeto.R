# Percurso da ANOVA na rota ClaRa: preparo confirmado -> ZIP -> código que
# viaja -> números do modelo. Roteiro e relatório rodam em sessões
# independentes, dentro do projeto descompactado (here::i_am, sem stub de here).
invisible(Sys.setlocale("LC_ALL", "English_United States.utf8"))
source("app.R", encoding = "UTF-8")

brutos <- data.frame(
  tanque = seq_len(19),
  tratamento = c(rep(c("baixa", "media", "alta"), each = 6), "alta"),
  peso_g = c(100, 112, 108, 98, 115, 104, 120, 132, 118, 140, 125, 129,
             153, 148, 161, 155, 142, 165, NA_real_)
)
externa <- list(codigo = "dados <- dplyr::rename(dados, densidade = tratamento)",
                codigo_sequencial = "dados <- dplyr::rename(dados, densidade = tratamento)")
resolvida <- dplyr::rename(brutos, densidade = tratamento)
trilha <- list(list(tipo = "reescalar", ativa = TRUE,
                   params = list(coluna = "peso_g", simbolo = "k", nome = "peso_kg")))
compartilhada <- replay_pipeline(resolvida, trilha)$df
bases <- bases_adicionar(bases_vazio(),
  bases_novo_registro("base_0001", "Tanques selecionados", "base_tanques", finalidade = "anova"))
bases <- bases_adicionar_etapa(bases, "base_0001", "filtrar",
  list(coluna = "tanque", origem = "numerica", operador = ">", valor = 1), compartilhada)
cache <- list(base_0001 = bases_recalcular_cache(compartilhada, bases[[1]], 1L))
bases <- bases_finalizar(bases, "base_0001", cache, 1L)
e <- list(id = "execucao_0001", analise_id = "anova", tipo = "anova_um_fator",
  titulo = "Peso de tilápias por densidade",
  parametros = list(resposta = "peso_kg", fator = "densidade", nivel_confianca = .99),
  saidas_disponiveis = c("narrativa", "descritivos", "tabela", "comparacoes",
                         "grafico", "pressupostos", "diagnosticos"),
  base_id = "base_0001", base_objeto = "base_tanques", base_tipo = "derivada")
manifesto <- comunicacao_manifesto(comunicacao_estado_vazio(), list(execucao_0001 = e),
                                   list(execucao_0001 = "Atualizada"))
raiz <- Sys.getenv("CATALYSER_TESTE_ANOVA_DESTINO", unset = tempfile("anova_preparo_"))
dir.create(raiz, recursive = TRUE, showWarnings = FALSE)
zip_saida <- file.path(raiz, "anova_preparo.zip")
exportacao_empacotar_projeto(zip_saida, nome_projeto = "anova_preparo",
  dados_brutos = brutos, base_resolvida = resolvida, dados_analise = compartilhada,
  pipeline = trilha, base_externa = externa, registro_bases = bases, cache_bases = cache,
  registro_execucoes = list(execucao_0001 = e), manifesto = manifesto, revisao_origem = 1L,
  import_info = list(source = "package", package_dataset = "tilapias_teste"),
  templates_dir = "templates")
utils::unzip(zip_saida, exdir = raiz)
projeto <- file.path(raiz, "anova_preparo")
stopifnot(!file.exists(file.path(projeto, "dados/processados/base_resolvida.rds")))

# Cada entrada roda num processo R novo, com a pasta do projeto como local de
# trabalho, como no RStudio. O roteiro e o relatório (rota ClaRa) devem
# entregar a mesma base, as mesmas exclusões e os mesmos F, p e Tukey a 99%.
esperado <- calcular_anova(cache$base_0001$df, "peso_kg", "densidade", .99)
iguais <- function(x, y) isTRUE(all.equal(x, y, check.attributes = FALSE, tolerance = 1e-10))
stopifnot(identical(list.files(file.path(projeto, "relatorios"), pattern = "[.]qmd$"), "relatorio.qmd"),
          !file.exists(file.path(projeto, "R", "funcoes.R")))
extraido <- file.path(raiz, "relatorio.qmd.R")
knitr::purl(file.path(projeto, "relatorios", "relatorio.qmd"), output = extraido, quiet = TRUE)
entradas <- c(file.path(projeto, "R", "analise.R"), extraido)
resultados <- list()
literal <- function(x) encodeString(normalizePath(x, winslash = "/", mustWork = FALSE), quote = '"')
for (i in seq_along(entradas)) {
  verificador <- file.path(raiz, paste0("validar_", i, ".R"))
  saida <- file.path(raiz, paste0("resultado_", i, ".rds"))
  log <- file.path(raiz, paste0("execucao_", i, ".log"))
  writeLines(c(
    sprintf("setwd(%s)", literal(projeto)),
    "grDevices::pdf(NULL)",
    sprintf("source(%s, encoding = 'UTF-8')", literal(entradas[i])),
    sprintf(paste(
      "saveRDS(list(base = as.data.frame(base), amostra = resultado$amostra,",
      "f = resultado$anova$f[1], p = resultado$anova$p[1], pares = resultado$pares,",
      "resumo = as.data.frame(resultado$resumo), efeito = textos$efeito), %s)"), literal(saida))
  ), verificador, useBytes = TRUE)
  status <- system2(file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript"),
    shQuote(verificador), stdout = log, stderr = log)
  if (status != 0L) stop(paste(readLines(log, warn = FALSE), collapse = "\n"))
  resultados[[i]] <- readRDS(saida)
}
tukey <- stats::TukeyHSD(esperado$fit, conf.level = .99)[[1]]
esperada <- as.data.frame(cache$base_0001$df)
for (env in resultados) {
  base <- env$base
  base$densidade <- as.character(base$densidade)
  stopifnot(iguais(base, esperada),
    env$amostra$total == 18L, env$amostra$usadas == 17L, env$amostra$excluidas == 1L,
    env$amostra$usadas == esperado$n,
    iguais(env$f, esperado$f_anova),
    iguais(env$p, esperado$p_anova),
    iguais(env$pares$diferenca, unname(tukey[, "diff"])),
    iguais(env$pares$ic_inf, unname(tukey[, "lwr"])))
}
stopifnot(iguais(resultados[[1]]$resumo, resultados[[2]]$resumo),
          identical(resultados[[1]]$efeito, resultados[[2]]$efeito))
cat("OK: ZIP ANOVA em ClaRa, receita com estrutura, trilha e ramo, exclusões, F, p, Tukey 99% e roteiro e relatório equivalentes.\n")
cat("Projeto para Render:", normalizePath(projeto, winslash = "/"), "\n")
