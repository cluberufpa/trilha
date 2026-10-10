# Execute de inst/app. Critério 5 do relatório satisfatório (plano Trilha +
# ClaRa, Fase 2): para cada análise com rota ClaRa no registro do molde, o
# projeto exportado roda do zero numa sessão limpa do R (Rscript --vanilla:
# sem .Rprofile, sem nada carregado) e o relatorio.qmd vira Word pelo Quarto,
# que também abre um R novo. Só os pacotes declarados: o do CRAN e a clara.
#
# Uma análise nova na rota ClaRa (entrada com clara = TRUE no registro) pede
# um caso aqui; sem ele, o teste para e diz qual falta.
grDevices::pdf(NULL)
for (arquivo in c("registro_tratamentos.R", "registro_bases.R", "registro_execucoes.R",
                  "registro_comunicacao.R", "exportacao_comunicacao.R")) {
  source(file.path("modules", arquivo), encoding = "UTF-8")
}
# A tela da ANOVA (anova_clara_rodar), para conferir que ela roda a chamada
# que o projeto escreve.
suppressPackageStartupMessages(source(file.path("modules", "mod_anova.R"), encoding = "UTF-8"))

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
item_anova <- function(metodo, metodo_usado = NULL) {
  list(id = "execucao_0001", tipo = "anova_um_fator", titulo = "Peso final de bagres por ração",
    incluir_word = TRUE, estado_dependencia = "Atualizada", base_tipo = "compartilhada",
    base_id = "dados_analise", base_objeto = "dados_analise",
    parametros = list(resposta = "peso_g", fator = "racao", nivel_confianca = .95,
      metodo = metodo, metodo_usado = metodo_usado,
      rotulo_x = "Ração", rotulo_y = "Peso final (g)"))
}

# Os casos de cada análise: os dados e as escolhas da tela. O esperado é
# calculado direto com o R, sem a ClaRa.
casos <- list(
  anova_um_fator = list(
    classica = list(dados = bagres, item = item_anova("classica"),
      esperado = function() summary(aov(peso_g ~ racao, data = bagres))[[1]]$`F value`[1]),
    welch = list(dados = bagres, item = item_anova("welch"),
      esperado = function() unname(oneway.test(peso_g ~ racao, data = bagres)$statistic)),
    automatico = list(dados = bagres, item = item_anova("auto", "classica"),
      esperado = function() summary(aov(peso_g ~ racao, data = bagres))[[1]]$`F value`[1])
  )
)

rotas <- Filter(function(entrada) isTRUE(entrada$clara), molde_projeto_registro)
stopifnot(length(rotas) >= 1L)
sem_caso <- setdiff(vapply(rotas, `[[`, character(1), "tipo"), names(casos))
if (length(sem_caso)) {
  stop("Rota ClaRa sem caso neste teste: ", paste(sem_caso, collapse = ", "), call. = FALSE)
}

rscript <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
destino <- tempfile("clara_render_")
dir.create(destino)
literal <- function(x) encodeString(normalizePath(x, winslash = "/", mustWork = FALSE), quote = '"')
verificados <- character()

for (entrada in rotas) for (nome_caso in names(casos[[entrada$tipo]])) {
  caso <- casos[[entrada$tipo]][[nome_caso]]
  rotulo <- paste(entrada$tipo, nome_caso)
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
  chamada_tela <- exportacao_anova_clara_chamada(caso$item, "tela")
  expressao <- function(linhas) parse(text = linhas, encoding = "UTF-8", keep.source = FALSE)[[1]]
  script <- readLines(file.path(projeto, "R", "analise.R"), encoding = "UTF-8")
  relatorio <- readLines(file.path(projeto, "relatorios", "relatorio.qmd"), encoding = "UTF-8")
  contem <- function(texto, bloco) {
    inicio <- which(texto == bloco[1])
    any(vapply(inicio, function(i) identical(texto[i:(i + length(bloco) - 1L)], bloco), logical(1)))
  }
  stopifnot(identical(expressao(exportacao_anova_clara_chamada(caso$item, "script")), expressao(chamada_tela)),
    identical(expressao(exportacao_anova_clara_chamada(caso$item, "relatorio")), expressao(chamada_tela)),
    contem(script, exportacao_anova_clara_chamada(caso$item, "script")),
    contem(relatorio, exportacao_anova_clara_chamada(caso$item, "relatorio")))
  # E a tela, com essa chamada, chega ao F esperado.
  tela <- anova_clara_rodar(caso$dados, caso$item$parametros)
  stopifnot(identical(tela$chamada, chamada_tela),
            isTRUE(all.equal(unname(tela$resultado$anova$f[1]), caso$esperado())))

  # 1. O roteiro, do começo ao fim, numa sessão limpa, de dentro do projeto,
  #    como o aluno faria. O F calculado volta num .rds para conferência.
  saida_rds <- file.path(destino, paste0(nome_caso, ".rds"))
  roteiro <- file.path(destino, paste0("rodar_", nome_caso, ".R"))
  writeLines(c(
    "grDevices::pdf(NULL)",
    "source('R/analise.R', encoding = 'UTF-8')",
    "stopifnot(isTRUE(\"package:clara\" %in% search()))",
    sprintf("saveRDS(resultado$anova$f[1], %s)", literal(saida_rds))
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
  #    com o F do teste escrito com vírgula, e nenhum erro de chunk.
  pasta_docx <- file.path(destino, paste0("docx_", nome_caso))
  utils::unzip(docx, files = "word/document.xml", exdir = pasta_docx)
  xml <- paste(readLines(file.path(pasta_docx, "word", "document.xml"),
                         encoding = "UTF-8", warn = FALSE), collapse = "")
  f_texto <- formatC(caso$esperado(), format = "f", digits = 2, decimal.mark = ",")
  stopifnot(grepl("Resíduo", xml, fixed = TRUE),
    grepl("Média ± DP", xml, fixed = TRUE),
    grepl(f_texto, xml, fixed = TRUE),
    !grepl("Error in|Erro em", xml))
  verificados <- c(verificados, rotulo)
  cat(sprintf("[ok] %s: analise.R em sessão limpa e Word renderizado (F = %s).\n",
              rotulo, f_texto))
}

# Dois grupos: a tela faz o teste t da ClaRa, e o projeto sai pelo molde da
# ANOVA (o teste t ainda não tem rota ClaRa), com o mesmo p.
artemia <- data.frame(racao = rep(c("A", "B"), each = 6),
                      taxa = c(2.1, 2.4, 2.2, 2.6, 2.3, 2.5, 1.8, 1.9, 2.0, 1.7, 2.1, 1.9))
item_t <- list(parametros = list(resposta = "taxa", fator = "racao", nivel_confianca = .95,
  metodo = "classica", metodo_usado = "classica", titulo_grafico = "", rotulo_x = "", rotulo_y = ""))
tela_t <- anova_clara_rodar(artemia, item_t$parametros)
resumo_t <- anova_clara_resumo(tela_t)
item_t$resultado_resumo <- resumo_t
item_t$tipo <- "anova_um_fator"
item_t$incluir_word <- TRUE
stopifnot(identical(tela_t$analise, "teste_t"), resumo_t$grupos == 2L,
  isTRUE(all.equal(resumo_t$p, summary(aov(taxa ~ racao, data = artemia))[[1]]$`Pr(>F)`[1])),
  !isTRUE(exportacao_anova_clara_aceita(list(execucoes = list(e = item_t), codigo_clara = TRUE))))

cat("OK: projeto da rota ClaRa gerado, rodado em sessão limpa e renderizado em Word:",
    paste(verificados, collapse = "; "), "\n")
