# Execute de inst/app. Critério 5 do relatório satisfatório (plano Trilha +
# ClaRa, Fase 2): para cada análise com rota ClaRa no registro do molde, o
# projeto exportado roda do zero numa sessão limpa do R (Rscript --vanilla:
# sem .Rprofile, sem nada carregado) e o relatorio.qmd vira Word pelo Quarto,
# que também abre um R novo. Só os pacotes declarados: o do CRAN e a clara.
#
# Uma rota ClaRa nova no registro (entrada com clara = TRUE) pede casos
# aqui; sem eles, o teste para e diz qual falta.
grDevices::pdf(NULL)
for (arquivo in c("registro_tratamentos.R", "registro_bases.R", "registro_execucoes.R",
                  "registro_comunicacao.R", "exportacao_comunicacao.R")) {
  source(file.path("modules", arquivo), encoding = "UTF-8")
}
# As telas da ANOVA (anova_clara_rodar) e do teste t (teste_t_clara_rodar),
# para conferir que elas rodam a chamada que o projeto escreve.
suppressPackageStartupMessages({
  source(file.path("modules", "mod_anova.R"), encoding = "UTF-8")
  source(file.path("modules", "mod_parametric.R"), encoding = "UTF-8")
})

# O Quarto é a peça que gera o Word. Sem ele, a verificação não acontece, e
# isso é dito em voz alta, como manda a regra da suíte.
quarto_bin <- Sys.getenv("QUARTO_PATH", unname(Sys.which("quarto")))
if (!nzchar(quarto_bin) || !file.exists(quarto_bin)) {
  stop(paste0(
    "Quarto não encontrado: o Render do projeto da rota ClaRa NÃO foi verificado.\n",
    "  Solução: instale o Quarto (https://quarto.org/docs/get-started/) ou defina QUARTO_PATH."
  ), call. = FALSE)
}

bagres <- as.data.frame(EAPADados::isoproteica_bagre)
# Duas rações dos bagres, para o teste t.
dois <- bagres[is.element(as.character(bagres$racao), c("A", "B")), ]
dois$racao <- factor(as.character(dois$racao))

item_anova <- function(metodo, metodo_usado = NULL, dados = bagres) {
  list(id = "execucao_0001", tipo = "anova_um_fator", titulo = "Peso final de bagres por ração",
    incluir_word = TRUE, estado_dependencia = "Atualizada", base_tipo = "compartilhada",
    base_id = "dados_analise", base_objeto = "dados_analise",
    parametros = list(resposta = "peso_g", fator = "racao", nivel_confianca = .95,
      metodo = metodo, metodo_usado = metodo_usado,
      rotulo_x = "Ração", rotulo_y = "Peso final (g)"),
    resultado_resumo = list(grupos = length(unique(as.character(dados$racao)))))
}
item_t <- function(variancias_iguais, alternativa) {
  list(id = "execucao_0001", tipo = "teste_t_two_ind", titulo = "Peso final de bagres por ração",
    incluir_word = TRUE, estado_dependencia = "Atualizada", base_tipo = "compartilhada",
    base_id = "dados_analise", base_objeto = "dados_analise",
    parametros = list(tipo_teste = "two_ind", resposta = "peso_g", grupo = "racao",
      nivel_confianca = .95, variancias_iguais = variancias_iguais, alternativa = alternativa))
}
f_anova <- function() summary(aov(peso_g ~ racao, data = bagres))[[1]]$`F value`[1]
t_dois <- function(variancias_iguais, alternativa) {
  unname(t.test(peso_g ~ racao, data = dois, var.equal = variancias_iguais,
                alternative = alternativa)$statistic)
}

# O que muda entre as rotas: a função que escreve a chamada, a estatística
# do resultado e o que a tabela do teste traz no Word.
rotas_info <- list(
  anova_clara = list(chamada = exportacao_anova_clara_chamada,
    estatistica = "resultado$anova$f[1]", tabela = "Resíduo"),
  teste_t_clara = list(chamada = exportacao_teste_t_clara_chamada,
    estatistica = "resultado$teste$t[1]", tabela = "Diferença")
)

# Os casos de cada rota: os dados, as escolhas da tela, a tela que roda e o
# esperado, calculado direto com o R, sem a ClaRa.
casos <- list(
  anova_clara = list(
    classica = list(dados = bagres, item = item_anova("classica"), tela = anova_clara_rodar,
      esperado = f_anova),
    welch = list(dados = bagres, item = item_anova("welch"), tela = anova_clara_rodar,
      esperado = function() unname(oneway.test(peso_g ~ racao, data = bagres)$statistic)),
    automatico = list(dados = bagres, item = item_anova("auto", "classica"), tela = anova_clara_rodar,
      esperado = f_anova)
  ),
  teste_t_clara = list(
    welch_bilateral = list(dados = dois, item = item_t(FALSE, "two.sided"),
      tela = teste_t_clara_rodar, esperado = function() t_dois(FALSE, "two.sided")),
    student_maior = list(dados = dois, item = item_t(TRUE, "greater"),
      tela = teste_t_clara_rodar, esperado = function() t_dois(TRUE, "greater")),
    # A ANOVA com dois grupos sai pela rota do teste t.
    anova_dois_grupos = list(dados = dois, item = item_anova("classica", dados = dois),
      tela = anova_clara_rodar, esperado = function() t_dois(TRUE, "two.sided"))
  )
)

rotas <- Filter(function(entrada) isTRUE(entrada$clara), molde_projeto_registro)
stopifnot(length(rotas) >= 2L)
sem_caso <- setdiff(vapply(rotas, `[[`, character(1), "pasta"), intersect(names(casos), names(rotas_info)))
if (length(sem_caso)) {
  stop("Rota ClaRa sem caso neste teste: ", paste(sem_caso, collapse = ", "), call. = FALSE)
}

rscript <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
destino <- tempfile("clara_render_")
dir.create(destino)
literal <- function(x) encodeString(normalizePath(x, winslash = "/", mustWork = FALSE), quote = '"')
expressao <- function(linhas) parse(text = linhas, encoding = "UTF-8", keep.source = FALSE)[[1]]
contem <- function(texto, bloco) {
  inicio <- which(texto == bloco[1])
  any(vapply(inicio, function(i) identical(texto[i:(i + length(bloco) - 1L)], bloco), logical(1)))
}
verificados <- character()

for (entrada in rotas) for (nome_caso in names(casos[[entrada$pasta]])) {
  caso <- casos[[entrada$pasta]][[nome_caso]]
  info <- rotas_info[[entrada$pasta]]
  rotulo <- paste(entrada$pasta, nome_caso)
  manifesto <- list(execucoes = list(execucao_0001 = caso$item), secoes_globais = list(),
                    codigo_clara = TRUE)
  stopifnot(identical(exportacao_molde_projeto_entrada(manifesto)$pasta, entrada$pasta))
  projeto <- exportacao_criar_projeto(destino = destino,
    nome_projeto = paste0(entrada$pasta, "_", nome_caso),
    dados_brutos = caso$dados, base_resolvida = caso$dados, dados_analise = caso$dados,
    pipeline = list(), base_externa = NULL, registro_bases = list(), cache_bases = list(),
    registro_execucoes = manifesto$execucoes, manifesto = manifesto, revisao_origem = 1L,
    import_info = list(source = "package", package_dataset = "isoproteica_bagre"),
    templates_dir = "templates")

  # 0. A chamada que a tela roda é a que o projeto escreve: as três formas
  #    (tela, script e relatório) dão a mesma expressão, e o script e o
  #    relatório trazem o bloco gerado, linha a linha.
  chamada_tela <- info$chamada(caso$item, "tela")
  script <- readLines(file.path(projeto, "R", "analise.R"), encoding = "UTF-8")
  relatorio <- readLines(file.path(projeto, "relatorios", "relatorio.qmd"), encoding = "UTF-8")
  stopifnot(identical(expressao(info$chamada(caso$item, "script")), expressao(chamada_tela)),
    identical(expressao(info$chamada(caso$item, "relatorio")), expressao(chamada_tela)),
    contem(script, info$chamada(caso$item, "script")),
    contem(relatorio, info$chamada(caso$item, "relatorio")),
    !file.exists(file.path(projeto, "R", "funcoes.R")))
  # E a tela, com essa chamada, chega à estatística esperada.
  tela <- caso$tela(caso$dados, caso$item$parametros)
  ambiente <- new.env()
  ambiente$resultado <- tela$resultado
  stopifnot(identical(tela$chamada, chamada_tela),
            isTRUE(all.equal(unname(eval(parse(text = info$estatistica), envir = ambiente)),
                             caso$esperado())))

  # 1. O roteiro, do começo ao fim, numa sessão limpa, de dentro do projeto,
  #    como o aluno faria. A estatística volta num .rds para conferência.
  saida_rds <- file.path(destino, paste0(nome_caso, ".rds"))
  roteiro <- file.path(destino, paste0("rodar_", nome_caso, ".R"))
  writeLines(c(
    "grDevices::pdf(NULL)",
    "source('R/analise.R', encoding = 'UTF-8')",
    "stopifnot(isTRUE(\"package:clara\" %in% search()))",
    sprintf("saveRDS(unname(%s), %s)", info$estatistica, literal(saida_rds))
  ), roteiro, useBytes = TRUE)
  log <- file.path(destino, paste0("rodar_", nome_caso, ".log"))
  antigo <- setwd(projeto)
  status <- system2(rscript, c("--vanilla", shQuote(roteiro)), stdout = log, stderr = log)
  setwd(antigo)
  if (status != 0L) {
    stop(rotulo, ": o analise.R falhou na sessão limpa.\n",
         paste(readLines(log, warn = FALSE), collapse = "\n"), call. = FALSE)
  }
  stopifnot(isTRUE(all.equal(readRDS(saida_rds), caso$esperado())))

  # 2. O Render, como o botão do RStudio: quarto render na raiz do projeto.
  #    O Quarto abre o seu próprio R; o relatório não lê nada do roteiro.
  unlink(file.path(projeto, "saida", "relatorios"), recursive = TRUE)
  log_render <- file.path(destino, paste0("render_", nome_caso, ".log"))
  antigo <- setwd(projeto)
  status <- system2(quarto_bin, "render", stdout = log_render, stderr = log_render)
  setwd(antigo)
  if (status != 0L) {
    stop(rotulo, ": o Render do relatorio.qmd falhou.\n",
         paste(readLines(log_render, warn = FALSE), collapse = "\n"), call. = FALSE)
  }
  docx <- file.path(projeto, "saida", "relatorios", "relatorio.docx")
  stopifnot(file.exists(docx))

  # 3. O Word traz as duas tabelas da ClaRa (exibir_teste e exibir_resumo),
  #    com a estatística do teste escrita com vírgula, e nenhum erro de chunk.
  pasta_docx <- file.path(destino, paste0("docx_", nome_caso))
  utils::unzip(docx, files = "word/document.xml", exdir = pasta_docx)
  xml <- paste(readLines(file.path(pasta_docx, "word", "document.xml"),
                         encoding = "UTF-8", warn = FALSE), collapse = "")
  valor_texto <- formatC(caso$esperado(), format = "f", digits = 2, decimal.mark = ",")
  stopifnot(grepl(info$tabela, xml, fixed = TRUE),
    grepl("Média ± DP", xml, fixed = TRUE),
    grepl(valor_texto, xml, fixed = TRUE),
    !grepl("Error in|Erro em", xml))
  # No unilateral, o Word diz que o intervalo é aberto.
  if (identical(caso$item$parametros$alternativa, "greater")) {
    stopifnot(grepl("unilateral", xml, fixed = TRUE), grepl("+∞", xml, fixed = TRUE))
  }
  verificados <- c(verificados, rotulo)
  cat(sprintf("[ok] %s: analise.R em sessão limpa e Word renderizado (estatística = %s).\n",
              rotulo, valor_texto))
}

cat("OK: projeto da rota ClaRa gerado, rodado em sessão limpa e renderizado em Word:",
    paste(verificados, collapse = "; "), "\n")
