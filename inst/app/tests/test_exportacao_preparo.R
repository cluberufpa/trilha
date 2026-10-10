invisible(Sys.setlocale("LC_ALL", "English_United States.utf8"))
source("tests/test_refinamentos_preparo.R", encoding="UTF-8")
library(dplyr)
source("tests/apoio_preparo_molde.R", encoding="UTF-8")
app_dir <- normalizePath(".", winslash="/")
saida <- tempfile("conferencia_preparo_");dir.create(saida)
ps <- isolate(pipeline()); preparada <- isolate(final())
# Cada derivada recebe a compartilhada inteira, e mantém somente seu recorte.
bs <- bases_adicionar(bases_vazio(), bases_novo_registro("base_0001", "Peso acima de 100 g", "base_peso_alto", finalidade="anova"))
bs <- bases_adicionar_etapa(bs, "base_0001", "filtrar", list(coluna="peso_g", origem="numerica", operador=">", valor=100), preparada)
caches <- list(base_0001=bases_recalcular_cache(preparada, bases_obter(bs,"base_0001"), 1L))
bs <- bases_finalizar(bs, "base_0001", caches, 1L)
stopifnot(all(caches$base_0001$df$peso_g>100),nrow(caches$base_0001$df)<nrow(preparada))
info <- list(source="local",file_name="Treino-Transformacoes.xlsx",datapath=file.path(app_dir,"dados/Treino-Transformacoes.xlsx"),excel_sheet="biometria")
e <- list(id="execucao_0001",analise_id="anova_um_fator",tipo="anova_um_fator",titulo="Massa por espécie",
 parametros=list(resposta="massa_kg",fator="especie",nivel_confianca=.95,rotulo_x="Espécie",rotulo_y="Massa (kg)"),
 saidas_disponiveis=c("narrativa","tabela","grafico","pressupostos","diagnosticos"),
 base_id="dados_analise",base_objeto="dados_analise",base_tipo="compartilhada",codigo_r=NULL)
for (derivada in c(FALSE,TRUE)) {
 nome <- if(derivada) "biometria_filtrada" else "biometria_treino"
 if(derivada) {e$base_id <- "base_0001";e$base_objeto <- "base_peso_alto";e$base_tipo <- "derivada"}
 execucoes <- list(execucao_0001=e)
 manifesto <- comunicacao_manifesto(comunicacao_estado_vazio(),execucoes,list(execucao_0001="Atualizada"))
 destino <- tempfile("exportado_",tmpdir=saida);dir.create(destino)
 projeto <- exportacao_criar_projeto(destino,nome,df,df,preparada,ps,NULL,bs,caches,execucoes,manifesto,1L,info,file.path(app_dir,"templates"))
 # Rota ClaRa: a planilha fica direto em dados/, sem subpastas.
 planilha <- file.path(projeto, "dados", exportacao_nome_planilha(info))
 stopifnot(file.exists(file.path(projeto,paste0(nome,".Rproj"))),
           identical(readxl::excel_sheets(planilha), "biometria"),
           isTRUE(all.equal(
             as.data.frame(readxl::read_excel(planilha)),
             as.data.frame(readxl::read_excel(info$datapath, sheet="biometria")))) )
 esperada <- if(derivada)caches$base_0001$df else preparada
 esperada$especie <- factor(esperada$especie)
 esperada <- droplevels(tidyr::drop_na(esperada,massa_kg,especie))
 # A receita do roteiro vai da planilha até a base desta análise (a
 # compartilhada ou o ramo), num só encadeamento.
 env <- executar_preparo_molde(projeto)
 obtida <- as.data.frame(env$base)
 obtida$especie <- factor(as.character(obtida$especie))
 obtida <- droplevels(tidyr::drop_na(obtida, massa_kg, especie))
 # O Excel recria row.names; comparamos todas as colunas, incluindo seus tipos.
 stopifnot(isTRUE(all.equal(as.list(obtida), as.list(esperada))))
 modelo <- stats::aov(massa_kg ~ especie, data=obtida)
 referencia <- stats::aov(massa_kg ~ especie, data=esperada)
 stopifnot(isTRUE(all.equal(stats::coef(modelo), stats::coef(referencia))))

 cat("PASSOU: projeto",nome,"reproduz",nrow(esperada),"linhas na receita do roteiro em ClaRa; o relatório tem a mesma trava; aba utilizada e nome Rproj conferidos.\n")
}
