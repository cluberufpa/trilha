# {{TITULO_COMENTARIO}}: ROTEIRO DE ANÁLISE EM ClaRa
# x========================================================================x
# Pergunta: {{PERGUNTA_COMENTARIO}}
#
# Rode as seções em ordem (Ctrl+Enter; sumário: Ctrl+Shift+O).
# Cada função da ClaRa responde a uma pergunta da pesquisa. Para entender
# uma: ajuda(comparar_medias). Para ver o R por trás dela, acrescente
# mostrar_codigo = TRUE à chamada.
# Este roteiro é o caderno de estudo: aqui se explora e se confere.
# O relatório (relatorios/relatorio.qmd) repete as chamadas principais e
# roda sozinho. Por isso, uma escolha mudada aqui (rótulo, confiança,
# figura) precisa ser mudada lá também.

# 1. Preparar o ambiente ---------------------------------------------------
library(here)
here::i_am("R/analise.R")  # here() monta os caminhos a partir da raiz do projeto
{{BIBLIOTECAS_PREPARO}}
library(clara)  # as funções da ClaRa; instalação no README

# 2. Ler a planilha --------------------------------------------------------
# A planilha que viajou no projeto entra aqui, sem nenhuma alteração.
{{TRECHO_IMPORTAR}}

# 3. Preparar a base do teste t --------------------------------------------
{{TRECHO_PREPARO}}

# A base pronta: a resposta deve ser número (dbl) e os grupos, fator (fct).
glimpse(base)

# 4. Comparar as médias ----------------------------------------------------
{{COMENTARIO_COMPARAR}}
{{CHAMADA_COMPARAR}}

resultado                     # um pequeno relatório no console

# Tamanho de efeito: d de Cohen e g de Hedges, com intervalo e a leitura de Cohen.
efeito <- resultado |>
  medir_efeito()

efeito

# 5. Tabelas ---------------------------------------------------------------
resultado$resumo              # n, média, DP, EP, IC e letras por grupo
resultado$teste               # o {{NOME_TESTE}}: diferença, IC, t, GL e p
resultado$pressupostos        # {{COMENTARIO_PRESSUPOSTOS}}

# 6. Gráficos --------------------------------------------------------------
# 6.1 Exploração: caixas com as observações por cima.
grafico_caixas <- resultado |>
  grafico_boxplot()

grafico_caixas

# 6.2 Figura principal, a que vai para o artigo: todas as escolhas
# escritas, com as opções ao lado.
grafico_barras <- resultado |>
  grafico_medias(titulo           = {{TITULO_CLARA}},
                 explicacao       = TRUE,           # FALSE tira a explicação do topo
                 haste            = "ic",           # "ic", "ep" ou "dp"
                 mostrar_barras   = TRUE,
                 largura_barras   = 0.3,            # de 0 a 1
                 mostrar_pontos   = TRUE,
                 mostrar_media_dp = TRUE,
                 casas            = 1,              # casas do rótulo: a precisão da medição
                 angulo_rotulo    = -90,            # -90: em pé, dentro da barra; 0: deitado
                 mostrar_letras   = TRUE,
                 cores            = "ocean",        # "ocean", "cinza" ou um vetor
                 tamanho_texto    = 12,
                 fonte            = "sans")         # "sans" (Arial) ou "serif" (Times)

grafico_barras

# 6.3 Resíduos contra ajustados: faixas de alturas parecidas, variâncias parecidas.
grafico_ajustados <- resultado |>
  grafico_residuos()

grafico_ajustados

# 6.4 Q-Q: pontos perto da reta, resíduos compatíveis com a normal.
grafico_normal <- resultado |>
  grafico_qq()

grafico_normal

# 6.5 A diferença entre as médias, com o intervalo: haste que cruza o zero,
# sem evidência de diferença.
grafico_diferenca <- resultado |>
  grafico_pares()

grafico_diferenca

# 7. Textos dinâmicos ------------------------------------------------------
# Frases que mudam junto com os dados. No Quarto: `r textos$teste`.
textos <- resultado |>
  escrever_resultados(casas = 1,
                      haste = "ic")  # a mesma haste da figura: "ic", "ep" ou "dp"

textos

# Cada frase também pode ser vista sozinha, pelo nome depois do $:
textos$efeito
textos$pressupostos

# 8. Salvar cópias ---------------------------------------------------------
# Cópias para compartilhar: o relatório não lê estes arquivos. O nome antes
# do = vira o nome do arquivo (teste_t = resultado$teste grava teste_t.csv).
# As tabelas saem em CSV que o Excel em português abre direto.
salvar_tabelas(base                = base,     # a base preparada pela receita
               resumo_grupos       = resultado$resumo,
               teste_t             = resultado$teste,
               testes_pressupostos = resultado$pressupostos,
               tamanho_efeito      = efeito,
               pasta               = here("saida", "tabelas"))

salvar_figuras(barras    = grafico_barras,
               boxplot   = grafico_caixas,
               diferenca = grafico_diferenca,
               residuos  = grafico_ajustados,
               qq        = grafico_normal,
               pasta     = here("saida", "figuras"),
               largura   = 18,                  # em centímetros
               altura    = 12)

# 9. Registrar o ambiente --------------------------------------------------
# As versões da ClaRa, do R e dos pacotes usadas nesta execução.
registrar_ambiente(arquivo = here("saida", "sessionInfo.txt"))
