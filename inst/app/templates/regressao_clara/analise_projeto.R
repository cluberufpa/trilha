# {{TITULO_COMENTARIO}}: ROTEIRO DE ANÁLISE EM ClaRa
# x========================================================================x
# Pergunta: {{PERGUNTA_COMENTARIO}}
#
# Rode as seções em ordem (Ctrl+Enter; sumário: Ctrl+Shift+O).
# Cada função da ClaRa responde a uma pergunta da pesquisa. Para entender
# uma: ajuda(relacionar_variaveis). Para ver o R por trás dela, acrescente
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

# 3. Preparar a base da regressão ------------------------------------------
{{TRECHO_PREPARO}}

# A base pronta: a resposta e o preditor devem ser números (dbl).
glimpse(base)

# 4. Ajustar a reta --------------------------------------------------------
{{COMENTARIO_RELACIONAR}}
{{CHAMADA_RELACIONAR}}

resultado                     # um pequeno relatório no console

# Tamanho de efeito: r de Pearson e R², com intervalo e a leitura de Cohen.
efeito <- resultado |>
  medir_efeito()

efeito

# 5. Tabelas ---------------------------------------------------------------
resultado$coeficientes        # intercepto e inclinação: estimativa, EP, IC, t e p
resultado$ajuste              # n, R², R² ajustado, erro padrão dos resíduos e F
resultado$pressupostos        # {{COMENTARIO_PRESSUPOSTOS}}
resultado$influencia          # observações para conferir na planilha (linha_da_base)

# 6. Gráficos --------------------------------------------------------------
# 6.1 Figura principal, a que vai para o artigo: todas as escolhas
# escritas, com as opções ao lado.
grafico_principal <- resultado |>
{{FIGURA_RETA}}

grafico_principal

# 6.2 Resíduos contra ajustados: pontos espalhados em torno do zero, sem
# curva e sem funil, indicam que a reta serve e a variância é constante.
grafico_ajustados <- resultado |>
  grafico_residuos()

grafico_ajustados

# 6.3 Q-Q: pontos perto da reta, resíduos compatíveis com a normal.
grafico_normal <- resultado |>
  grafico_qq()

grafico_normal

# 7. Textos dinâmicos ------------------------------------------------------
# Frases que mudam junto com os dados. No Quarto: `r textos$teste`.
textos <- resultado |>
  escrever_resultados(casas = 2)  # casas dos coeficientes: a precisão da medição

textos

# Cada frase também pode ser vista sozinha, pelo nome depois do $:
textos$equacao
textos$influencia

# 8. Salvar cópias ---------------------------------------------------------
# Cópias para compartilhar: o relatório não lê estes arquivos. O nome antes
# do = vira o nome do arquivo (coeficientes = resultado$coeficientes grava
# coeficientes.csv). As tabelas saem em CSV que o Excel em português abre.
salvar_tabelas(base                = base,     # a base preparada pela receita
               coeficientes        = resultado$coeficientes,
               ajuste              = resultado$ajuste,
               testes_pressupostos = resultado$pressupostos,
               influencia          = resultado$influencia,
               tamanho_efeito      = efeito,
               pasta               = here("saida", "tabelas"))

salvar_figuras(reta      = grafico_principal,
               residuos  = grafico_ajustados,
               qq        = grafico_normal,
               pasta     = here("saida", "figuras"),
               largura   = 18,                  # em centímetros
               altura    = 12)

# 9. Registrar o ambiente --------------------------------------------------
# As versões da ClaRa, do R e dos pacotes usadas nesta execução.
registrar_ambiente(arquivo = here("saida", "sessionInfo.txt"))
