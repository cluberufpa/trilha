# =============================================================================
# funcoes_nonparametric.R
# -----------------------------------------------------------------------------
# Funções canônicas dos testes NÃO PARAMÉTRICOS da Trilha (ecossistema EAPA):
#   - Qui-quadrado de independência  (a partir de uma matriz de contagens)
#   - Teste exato de Fisher          (alternativa para tabelas esparsas)
#   - Wilcoxon dos postos sinalizados(amostras pareadas)
#   (Mann-Whitney e Kruskal-Wallis saíram daqui: as telas e os projetos usam
#   comparar_medianas(), da ClaRa)
#
# Padrão de cada análise (do mouse ao código):
#   calcular_*() -> lista com as estatísticas do teste
#   arrumar_*()  -> data.frame enxuto em português (imprime em qualquer lugar)
#   relatar_*()  -> frase-relatório em português (p-valor e interpretação)
# =============================================================================

library(flextable)

# Evita erro de 'req' fora do Shiny (ao rodar o script exportado no RStudio)
if (!exists("req", mode = "function")) {
  req <- function(...) invisible(TRUE)
}

# ---- Utilitários ------------------------------------------------------------
fmt_np <- function(x, dig = 2) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return("-")
  formatC(x, format = "f", digits = dig, decimal.mark = ",")
}

p_txt_np <- function(p) {
  if (is.null(p) || is.na(p)) return("-")
  if (p < 0.001) "p < 0,001" else paste0("p = ", fmt_np(p, 4))
}

# ---- Interpretação de tamanhos de efeito ------------------------------------
# Para r / correlação bisserial de postos / V de Cramér (escala 0–1 em módulo):
# limiares de Cohen (0,1 / 0,3 / 0,5).
interpretar_r_np <- function(r) {
  if (is.null(r) || length(r) == 0 || is.na(r)) return("indefinido")
  a <- abs(r)
  if (a < 0.10)      "desprezível"
  else if (a < 0.30) "pequeno"
  else if (a < 0.50) "moderado"
  else               "grande"
}

# Para epsilon² (Kruskal-Wallis): limiares usuais (0,01 / 0,06 / 0,14).
interpretar_epsilon2 <- function(e) {
  if (is.null(e) || length(e) == 0 || is.na(e)) return("indefinido")
  if (e < 0.01)      "desprezível"
  else if (e < 0.06) "pequeno"
  else if (e < 0.14) "moderado"
  else               "grande"
}

# =============================================================================
# 1. QUI-QUADRADO DE INDEPENDÊNCIA (recebe uma matriz/tabela de contagens)
# =============================================================================
calcular_qui_quadrado <- function(tab, correct = TRUE,
                                  var_row = "Linha", var_col = "Coluna") {
  tab <- as.matrix(tab)
  storage.mode(tab) <- "numeric"

  chi <- suppressWarnings(chisq.test(tab, correct = correct))
  min_esp <- suppressWarnings(min(chi$expected))

  # Tamanho de efeito: V de Cramér = sqrt(X² / (N * (min(linhas, colunas) - 1))).
  # Em tabela 2x2 equivale ao coeficiente Phi.
  N <- sum(tab)
  k_min <- min(nrow(tab), ncol(tab))
  cramer_v <- if (N > 0 && k_min > 1)
    sqrt(unname(chi$statistic) / (N * (k_min - 1))) else NA_real_

  list(
    tab             = tab,
    esperados       = chi$expected,
    statistic       = unname(chi$statistic),
    df              = unname(chi$parameter),
    p               = chi$p.value,
    method          = chi$method,
    N               = N,
    min_esperado    = min_esp,
    alerta_esperado = isTRUE(min_esp < 5),
    cramer_v        = cramer_v,
    efeito          = interpretar_r_np(cramer_v),
    correct         = correct,
    var_row         = var_row,
    var_col         = var_col
  )
}

#' Teste exato de Fisher (alternativa para tabelas esparsas)
calcular_fisher <- function(tab) {
  tab <- as.matrix(tab)
  storage.mode(tab) <- "numeric"
  ft <- tryCatch(fisher.test(tab), error = function(e) NULL)
  if (is.null(ft)) {
    return(list(p = NA, method = "Teste Exato de Fisher (não pôde ser calculado)"))
  }
  list(p = ft$p.value, method = ft$method)
}

arrumar_qui_quadrado <- function(r) {
  data.frame(
    Métrica = c("Qui-quadrado (X²)", "Graus de liberdade (gl)", "p-valor",
                "N (total)", "Menor freq. esperada", "V de Cramér", "Tamanho do efeito"),
    Valor = c(fmt_np(r$statistic, 4), as.character(r$df), p_txt_np(r$p),
              as.character(r$N), fmt_np(r$min_esperado, 2),
              fmt_np(r$cramer_v, 3), r$efeito),
    stringsAsFactors = FALSE, check.names = FALSE
  )
}

relatar_qui_quadrado <- function(r) {
  if (is.na(r$p)) {
    return("Não foi possível calcular o qui-quadrado com a tabela informada (verifique se há contagens suficientes).")
  }
  sig <- if (r$p < 0.05) {
    "há associação estatisticamente significativa"
  } else {
    "não há associação estatisticamente significativa (independência)"
  }
  corr_txt <- if (isTRUE(r$correct) && all(dim(r$tab) == 2)) {
    " (com correção de continuidade de Yates)"
  } else {
    ""
  }
  aviso <- if (isTRUE(r$alerta_esperado)) {
    paste0(" Atenção: a menor frequência esperada foi ", fmt_np(r$min_esperado, 2),
           " (abaixo de 5), o que fragiliza o qui-quadrado; considere o teste exato de Fisher.")
  } else {
    ""
  }
  efeito_txt <- if (!is.na(r$cramer_v))
    paste0(" A força da associação, medida pelo V de Cramér, foi de ",
           fmt_np(r$cramer_v, 3), " (efeito ", r$efeito, ").") else ""

  paste0(
    "O teste de qui-quadrado de independência de Pearson", corr_txt,
    ", aplicado à tabela de contingência entre '", r$var_row, "' e '", r$var_col,
    "' (N = ", r$N, "), indica que ", sig,
    " [X² = ", fmt_np(r$statistic, 2), "; gl = ", r$df, "; ", p_txt_np(r$p), "].",
    efeito_txt, aviso
  )
}

# =============================================================================
# 2. WILCOXON DOS POSTOS SINALIZADOS (amostras pareadas)
# =============================================================================
calcular_wilcoxon <- function(df, var1, var2, alternative = "two.sided") {
  d <- df[, c(var1, var2)]
  d <- na.omit(d)
  w <- suppressWarnings(wilcox.test(d[[var1]], d[[var2]], paired = TRUE, alternative = alternative))

  # Tamanho de efeito: correlação bisserial de postos para pares =
  # 4V/(n_r(n_r+1)) - 1, onde V é a soma dos postos positivos e n_r é o número de
  # diferenças NÃO nulas (os empates/zeros são descartados, como no wilcox.test).
  difs <- d[[var1]] - d[[var2]]
  n_r <- sum(difs != 0)
  V <- unname(w$statistic)
  r_rb <- if (n_r > 0) (4 * V) / (n_r * (n_r + 1)) - 1 else NA_real_

  list(
    statistic = V, p = w$p.value, method = w$method,
    mediana1 = median(d[[var1]]), mediana2 = median(d[[var2]]),
    mediana_dif = median(difs),
    r_rb = r_rb, efeito = interpretar_r_np(r_rb),
    alternative = alternative, var1 = var1, var2 = var2, n = nrow(d)
  )
}

arrumar_wilcoxon <- function(r) {
  data.frame(
    Métrica = c("Estatística V", "p-valor",
                paste0("Mediana (", r$var1, ")"),
                paste0("Mediana (", r$var2, ")"),
                "Mediana das diferenças", "N (pares)",
                "r (bisserial de postos)", "Tamanho do efeito"),
    Valor = c(fmt_np(r$statistic, 4), p_txt_np(r$p),
              fmt_np(r$mediana1, 3), fmt_np(r$mediana2, 3),
              fmt_np(r$mediana_dif, 3), as.character(r$n),
              fmt_np(r$r_rb, 3), r$efeito),
    stringsAsFactors = FALSE, check.names = FALSE
  )
}

relatar_wilcoxon <- function(r) {
  sig <- if (r$p < 0.05) "diferença estatisticamente significativa" else "nenhuma diferença estatisticamente significativa"
  efeito_txt <- if (!is.na(r$r_rb))
    paste0(" O tamanho do efeito (correlação bisserial de postos) foi r = ",
           fmt_np(r$r_rb, 3), ", um efeito ", r$efeito, ".") else ""
  paste0(
    "O teste de Wilcoxon dos postos sinalizados comparou as medições pareadas '", r$var1,
    "' (mediana = ", fmt_np(r$mediana1, 2), ") e '", r$var2,
    "' (mediana = ", fmt_np(r$mediana2, 2), "), com ", r$n, " pares. A mediana das diferenças foi ",
    fmt_np(r$mediana_dif, 2), ", indicando ", sig,
    " [V = ", fmt_np(r$statistic, 2), "; ", p_txt_np(r$p), "].", efeito_txt
  )
}
