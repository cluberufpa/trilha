# {{TITULO_COMENTARIO}}: ROTEIRO DE ANÁLISE EM ClaRa
# x========================================================================x
# Pergunta: {{PERGUNTA_COMENTARIO}}
#
# Rode as seções em ordem (Ctrl+Enter; sumário: Ctrl+Shift+O).
# Cada função da ClaRa responde a uma pergunta da pesquisa. Para entender
# uma: ajuda(comparar_medianas). Para ver o R por trás dela, acrescente
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

# 3. Preparar a base da comparação -----------------------------------------
{{TRECHO_PREPARO}}

# A base pronta: a resposta deve ser número (dbl) e os grupos, fator (fct).
glimpse(base)

# 4. Comparar as medianas --------------------------------------------------
{{COMENTARIO_COMPARAR}}
{{CHAMADA_COMPARAR}}

resultado                     # um pequeno relatório no console

# Tamanho de efeito: {{EFEITO_COMENTARIO}}, com intervalo e a leitura.
efeito <- resultado |>
  medir_efeito()

efeito

# 5. Tabelas ---------------------------------------------------------------
resultado$resumo              # n, mediana, quartis e letras por grupo
{{TABELAS_TESTE}}
resultado$pressupostos        # Fligner-Killeen: dispersão parecida nos grupos

# 6. Gráficos --------------------------------------------------------------
# 6.1 Exploração: caixas com as observações por cima. Caixas de alturas
# parecidas indicam dispersão parecida, como o Fligner-Killeen.
grafico_caixas <- resultado |>
  grafico_boxplot()

grafico_caixas

# 6.2 Figura principal, a que vai para o artigo: todas as escolhas
# escritas, com as opções ao lado.
grafico_principal <- resultado |>
{{FIGURA_MEDIANAS}}

grafico_principal

# 7. Textos dinâmicos ------------------------------------------------------
# Frases que mudam junto com os dados. No Quarto: `r textos$teste`.
textos <- resultado |>
  escrever_resultados()

textos

# Cada frase também pode ser vista sozinha, pelo nome depois do $:
textos$efeito
textos$pressupostos

# 8. Salvar cópias ---------------------------------------------------------
# Cópias para compartilhar: o relatório não lê estes arquivos. O nome antes
# do = vira o nome do arquivo (teste = resultado$teste grava teste.csv).
# As tabelas saem em CSV que o Excel em português abre direto.
salvar_tabelas(base                = base,     # a base preparada pela receita
               resumo_grupos       = resultado$resumo,
               teste               = resultado$teste,
               testes_pressupostos = resultado$pressupostos,
               tamanho_efeito      = efeito,
               pasta               = here("saida", "tabelas"))

salvar_figuras(medianas = grafico_principal,
               boxplot  = grafico_caixas,
               pasta    = here("saida", "figuras"),
               largura  = 18,                  # em centímetros
               altura   = 12)

# 9. Registrar o ambiente --------------------------------------------------
# As versões da ClaRa, do R e dos pacotes usadas nesta execução.
registrar_ambiente(arquivo = here("saida", "sessionInfo.txt"))
