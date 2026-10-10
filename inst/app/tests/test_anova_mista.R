# Executar a partir de catalyser/inst/app.
library(shiny)

source(file.path("..", "..", "R", "anova_mista.R"), encoding = "UTF-8")
source(file.path("modules", "ficha_planejamento.R"), encoding = "UTF-8")
source(file.path("modules", "registro_execucoes.R"), encoding = "UTF-8")
source(file.path("modules", "mod_execucao_explicita.R"), encoding = "UTF-8")
source(file.path("modules", "mod_anova_mista.R"), encoding = "UTF-8")

arquivo <- file.path("..", "..", "..", "EAPACadernos", "projeto_anova_mista",
                     "dados", "brutos", "arrastos.csv")
dados <- utils::read.csv(arquivo, fileEncoding = "UTF-8")
parametros <- list(
  resposta = "biomassa_g", fator = "condicao",
  unidade = "praia", subamostra = "arrasto"
)

resultado <- trilha_anova_mista(dados, parametros)
stopifnot(
  resultado$n == 27L,
  resultado$n_unidades == 9L,
  is.finite(resultado$f_misto),
  is.finite(resultado$p_misto),
  nrow(resultado$tabela) == 3L,
  grepl("modelo misto", resultado$narrativa, ignore.case = TRUE),
  grepl("random = ~1", resultado$codigo, fixed = TRUE),
  inherits(resultado$grafico, "ggplot"),
  inherits(resultado$diagnosticos, "ggplot")
)

# O caminho ingênuo precisa aparecer como aviso e ser mais confiante neste exemplo.
stopifnot(
  grepl("evitar", resultado$tabela$Abordagem[3], fixed = TRUE),
  resultado$tabela$F[3] > resultado$tabela$F[2]
)

# Uma unidade não pode atravessar níveis do fator.
dados_invalidos <- dados
dados_invalidos$praia[1] <- dados_invalidos$praia[dados_invalidos$condicao != dados_invalidos$condicao[1]][1]
erro <- tryCatch({
  trilha_anova_mista(dados_invalidos, parametros)
  NULL
}, error = conditionMessage)
stopifnot(is.character(erro), grepl("único nível", erro, fixed = TRUE))

dados_rv <- reactive(dados)
ficha_rv <- reactiveVal(ficha_mesclar(NULL, list(
  origem = "Planejamento observacional — Comparativo",
  unidade_coluna = "praia",
  hierarquia = list(subamostra_coluna = "arrasto"),
  resposta_coluna = "biomassa_g",
  analise_sugerida = "anova_mista_subamostras"
)))

testServer(
  mod_anova_mista_server,
  args = list(dados_rv = dados_rv, ficha_rv = ficha_rv),
  {
    session$setInputs(
      resposta = "biomassa_g", fator = "condicao",
      unidade = "praia", subamostra = "arrasto"
    )
    stopifnot(identical(exec_ctrl$estado(), "aguardando"))
    session$setInputs(executar_analise = 1)
    stopifnot(identical(exec_ctrl$estado(), "atualizada"))
    estado <- estado_execucao()
    stopifnot(
      identical(estado$tipo, "anova_mista_subamostras"),
      identical(estado$parametros$unidade, "praia"),
      identical(estado$parametros$subamostra, "arrasto"),
      estado$resultado_resumo$n_unidades == 9L,
      isTRUE(execucoes_validar_estado(estado))
    )
    session$setInputs(unidade = "arrasto")
    stopifnot(identical(exec_ctrl$estado(), "pendente"))
  }
)

# A ficha do planejamento não entra aqui: o planejamento acontece antes da
# coleta e não precisa estar ligado às análises (decisão do professor,
# 10/10/2026). O que a tela de variáveis de coleta põe na ficha, inclusive
# as subamostras do sorteio por conglomerados, é conferido em
# test_sortear_marco.R.

cat("OK: ANOVA mista — cálculo, pseudorreplicação e estado Shiny\n")
