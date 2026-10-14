# Conjuntos de exemplo da ClaRa na tela de importação.
# Execute a partir de inst/app: Rscript tests/test_exemplos_clara.R
#
# Confere o seletor em dois passos (ClaRa / Outros pacotes), a leitura pela porta da ClaRa
# (carregar_dados), as telas que leem conjuntos fixos e o código R gerado para cada origem.
# O teste não fixa conjuntos em curadoria (como o do quadrado latino): pega do catálogo.

Sys.setlocale("LC_CTYPE", "Portuguese_Brazil.utf8")
suppressMessages(source("modules/utils_export.R", encoding = "UTF-8"))
suppressMessages(source("modules/exportacao_comunicacao.R", encoding = "UTF-8"))

# ---- 1. O catálogo da ClaRa alimenta o seletor -----------------------------------------
amb <- new.env()
suppressMessages(suppressWarnings(sys.source("app.R", envir = amb, keep.source = FALSE)))
g <- function(nome) get(nome, envir = amb)

catalogo <- g("clara_catalogo")
stopifnot(is.data.frame(catalogo), nrow(catalogo) >= 53L)

na_clara <- g("exemplos_escolhas")("clara")
em_outros <- g("exemplos_escolhas")("outros")
stopifnot(
  # "ClaRa" mostra só os conjuntos da própria ClaRa; "Outros pacotes", só os de fora.
  setequal(na_clara, catalogo$nome[catalogo$fonte_dados == "clara"]),
  setequal(em_outros, catalogo$nome[catalogo$fonte_dados != "clara"]),
  length(intersect(na_clara, em_outros)) == 0L,
  all(c("garoupa_pcr_histologia", "pinguins", "morfometria_barbo", "lago_vitoria",
        "anchova_norte_california") %in% na_clara),
  all(c("snapper_hg", "crabs_morfometria") %in% em_outros),
  # Em "Outros pacotes", cada item aparece como nome (Pacote).
  all(grepl("\\((FSAdata|MASS)\\)$", names(em_outros))),
  # O padrão de cada origem pertence à própria origem.
  g("exemplos_padrao")("clara") %in% na_clara,
  g("exemplos_padrao")("outros") %in% em_outros,
  # Só as duas origens da especificação: o EAPADados saiu do seletor.
  length(g("exemplos_escolhas")("eapadados")) == 0L,
  g("exemplos_origem_inicial") == "clara",
  all(nzchar(g("clara_titulos")[na_clara]))
)

# ---- 2. Todo conjunto oferecido carrega pela porta da ClaRa -----------------------------
for (nome in c(na_clara, em_outros)) {
  d <- tryCatch(clara::carregar_dados(nome), error = function(e) e)
  stopifnot(is.data.frame(d), nrow(d) > 0L)
}

# ---- 3. O McNemar do D12 é o que a documentação promete ---------------------------------
garoupa <- as.data.frame(clara::carregar_dados("garoupa_pcr_histologia"))
r1 <- garoupa[garoupa$replica == "1", ]
tab <- table(r1$histologia, r1$pcr)          # Tabela 32 de Bowater (2015)
stopifnot(identical(as.integer(tab), c(4L, 2L, 50L, 18L)),
          nrow(garoupa) == 123L,
          mcnemar.test(tab)$p.value < 1e-9)

# ---- 4. Código R gerado depende da origem ----------------------------------------------
info_clara <- list(source = "package", package_dataset = "pinguins", package_origem = "clara")
info_outros <- list(source = "package", package_dataset = "snapper_hg", package_origem = "outros")
info_antigo <- list(source = "package", package_dataset = "artemia", package_origem = "eapadados")
info_sem_origem <- list(source = "package", package_dataset = "artemia")   # projetos e testes antigos

stopifnot(
  identical(pacote_leitura_linhas(info_clara, "dados"),
            c("library(clara)", 'dados <- as.data.frame(carregar_dados("pinguins"))')),
  identical(pacote_leitura_linhas(info_outros, "dados_largo"),
            c("library(clara)", 'dados_largo <- as.data.frame(carregar_dados("snapper_hg"))')),
  identical(pacote_leitura_linhas(info_antigo, "dados"),
            c("library(EAPADados)", "data(artemia)", "dados <- artemia")),
  identical(pacote_leitura_linhas(info_sem_origem, "dados"), pacote_leitura_linhas(info_antigo, "dados")),
  identical(pacote_leitura_linhas(info_antigo, "dados", "lazy"),
            c("library(EAPADados)", "dados <- as.data.frame(artemia)"))
)

leitura_clara <- preparo_leitura_entrada(info_clara)
leitura_antiga <- preparo_leitura_entrada(info_antigo)
stopifnot(
  any(grepl('carregar_dados\\("pinguins"\\)', leitura_clara)),
  !any(grepl("EAPADados", leitura_clara)),
  any(grepl('package = "EAPADados"', leitura_antiga))
)

# O código gerado roda de verdade: lê o conjunto e devolve o mesmo que a tela mostra.
codigo <- pacote_leitura_linhas(info_clara, "dados")
ambiente <- new.env()
eval(parse(text = codigo), envir = ambiente)
stopifnot(identical(ambiente$dados, as.data.frame(clara::carregar_dados("pinguins"))))

# ---- 5. Telas que leem conjuntos fixos usam a ClaRa ---------------------------------------
suppressMessages(source("modules/mod_series_temporais.R", encoding = "UTF-8"))
anchova <- .carrega_anchova_norte_california()
stopifnot(is.data.frame(anchova), all(c("data", "desembarque_lb") %in% names(anchova)))

# PCA: os papéis sugeridos do Lago Vitória existem no conjunto.
vitoria <- clara::carregar_dados("lago_vitoria")
stopifnot(is.numeric(vitoria$clorofila_a), "estacao" %in% names(vitoria))

# Texto do barbo no relatório diz de que pacote veio o conjunto.
stopifnot(
  exportacao_pacote_dados(list(package_origem = "clara")) == "da ClaRa",
  exportacao_pacote_dados(list()) == "do EAPADados"
)

cat(sprintf("OK: seletor da ClaRa (%d + %d conjuntos), leitura por carregar_dados, telas fixas e código gerado validados.\n",
            length(na_clara), length(em_outros)))
