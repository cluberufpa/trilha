# {{TITULO}}

Este Projeto R foi gerado pela Trilha para estudar e comunicar uma regressão
linear simples, escrita em **ClaRa**, o R escrito com clareza. Abra
**{{PROJETO_RPROJ}}** no RStudio. O projeto funciona com a base local,
pacotes do CRAN e o pacote `clara` (a ClaRa, versão {{VERSAO_CLARA}} na
exportação); não precisa da Trilha instalada.

## Um convite a aprender programação

Na ClaRa, cada função responde a uma pergunta da pesquisa, em português:
`relacionar_variaveis()` ajusta a reta, confere os resíduos e aponta as
observações que merecem conferência; `grafico_reta()` desenha a figura
principal; `escrever_resultados()` escreve as frases do relatório. Por trás
de cada função roda R comum, no estilo do tidyverse. Para vê-lo, acrescente
`mostrar_codigo = TRUE` a qualquer chamada: a função imprime o código que
vai rodar, com os nomes das suas colunas, e o código mostrado é exatamente
o que rodou. Para entender uma função, digite `ajuda(relacionar_variaveis)`
no console.

## O que você encontra

```text
{{PROJETO_RPROJ}}
├── _quarto.yml
├── dados/
│   └── {{ARQUIVO_BRUTO_ARVORE}}a planilha, entrada preservada
├── R/
│   └── analise.R                  o roteiro da análise, em ClaRa
├── imagens/                       fotos e esquemas fornecidos pelo pesquisador
├── relatorios/
│   ├── relatorio.qmd              o relatório, que vira Word
│   ├── referencias.bib
│   ├── apa.csl
│   └── custom-reference.docx
└── saida/                         nasce quando o script roda
    ├── tabelas/
    ├── figuras/
    ├── relatorios/                o Word gerado no Render
    └── sessionInfo.txt
```

Cada arquivo tem um papel só:

- **`R/analise.R` é o caderno de estudo.** Rode as seções em ordem e examine
  os objetos no console: a receita de preparo, a reta, os diagnósticos dos
  resíduos, as observações influentes e os textos dinâmicos.
- **`relatorios/relatorio.qmd` é o relatório.** Nele você escreve o artigo ou
  a tese; o Render gera o Word com os resultados principais. Ele **repete as
  chamadas principais da ClaRa**, de forma mais enxuta, e roda sozinho: o
  Render não lê o script. Por isso, uma escolha mudada no script (um rótulo,
  a confiança, um detalhe da figura) precisa ser mudada também no relatório.

| No script e no relatório | O que guarda | Cópia salva pelo script |
|---|---|---|
| `resultado <- ... relacionar_variaveis(...)` | coeficientes, ajuste, pressupostos e influência | `saida/tabelas/coeficientes.csv`, `ajuste.csv` |
| `resultado \|> grafico_reta(...)` | a figura principal | `saida/figuras/reta.png` |
| `textos <- resultado \|> escrever_resultados()` | as frases do relatório | no texto: `` `r textos$teste` `` |

## Preparar o computador, uma vez

Instale R, RStudio e Quarto. No console do R, instale os pacotes do CRAN:

```r
install.packages(
{{PACOTES_INSTALAR}}
)
```

Depois, instale a ClaRa. Enquanto ela não estiver no CRAN, vem do GitHub
(os pacotes de que ela precisa vêm junto, todos do CRAN):

```r
remotes::install_github("cluberufpa/ClaRa")
```

Este projeto foi exportado com a ClaRa {{VERSAO_CLARA}}. Para conferir a sua,
rode `packageVersion("clara")`; se for mais antiga, repita a linha acima.
Quando a ClaRa entrar no CRAN, bastará `install.packages("clara")`.

Nenhum pacote é instalado automaticamente durante a análise.

## Gerar o relatório

1. Abra o `.Rproj` e reinicie o R para começar com uma sessão limpa.
2. Abra `relatorios/relatorio.qmd` e clique em **Render**: sai o Word, em
   `saida/relatorios/`.

Também é possível gerá-lo, na raiz do projeto, com:

```sh
quarto render
```

Os caminhos usam `here::i_am()` e `here::here()` para reconhecer este projeto.
Abra o `.Rproj` antes de executar.

## Dados e preparo

A entrada preservada é `dados/{{ARQUIVO_BRUTO}}`, a única coisa na pasta
`dados/`: com uma planilha só, não há subpastas. A Trilha exportou
a receita de preparo: a seção 3 do script a aplica à planilha, com pipe e
dplyr, e o script e o relatório partem da base que ela produz. No lugar de
uma cópia da base, o script traz um **carimbo**: o número de linhas e as
médias da resposta e do preditor que a Trilha mostrou na tela. Confira a
tabela do R com o carimbo; se a receita mudar o número de linhas, o
`stopifnot()` para o script e o Render. Para abrir a base fora do R, o
script grava uma cópia em `saida/tabelas/base.csv`, refeita a cada execução:
ela sempre bate com a receita.

A análise usa:

- resposta: **{{RESPOSTA}}**;
- preditor: **{{PREDITOR}}**;
- intervalo de confiança: **{{IC}}%**.

## Origem dos dados

Registre aqui a origem da planilha, a licença e o período de coleta. A
Trilha não conhece a proveniência dos seus dados e não a declara no lugar
do pesquisador. A planilha original fica em `dados/{{ARQUIVO_BRUTO}}` e
não é alterada.

## Método da regressão

A reta é ajustada por mínimos quadrados: a inclinação diz quanto a resposta
muda, em média, a cada unidade do preditor, e o R² diz quanto da variação
da resposta a reta explica. Os resíduos são conferidos quanto à
normalidade (Shapiro-Wilk) e à variância constante (Breusch-Pagan). A
independência vem do delineamento; o teste de Durbin-Watson só entra com
`avaliar_autocorrelacao = TRUE`, quando a ordem das linhas da planilha é a
ordem da coleta. Observações com resíduo extremo, alavancagem alta ou
distância de Cook alta aparecem em `resultado$influencia`, com a linha da
base: são sinais para conferir na planilha, nunca ordens para apagar
linhas. Qualquer troca vai no script e no relatório.

## Como ler a figura principal

Os pontos são as observações; a linha é a reta ajustada; a faixa sombreada é
o intervalo de confiança da reta, isto é, onde deve estar a **média** da
resposta para cada valor do preditor. A faixa não diz onde cairá uma
observação nova, que varia bem mais. A reta descreve a relação só dentro da
faixa observada do preditor: prolongá-la além dela é extrapolação.

## Como escrever e adaptar

O relatório traz sugestões em Introdução, Material e métodos, Resultados,
Discussão e Conclusão, com os resultados esperados em um artigo: a tabela
dos coeficientes, o ajuste do modelo e a figura principal. Os gráficos de
resíduos ficam no roteiro, onde se conferem. As frases de
`escrever_resultados()` mudam junto com os dados, mas a discussão e a
conclusão científica precisam ser revistas pelo pesquisador.

## Ambiente computacional

Ambiente registrado automaticamente na exportação:

{{AMBIENTE_COMPUTACIONAL}}

Ao executar, o script registra o ambiente efetivo em `saida/sessionInfo.txt`,
com a versão da ClaRa que rodou. A ClaRa é um pacote instalado uma vez no
computador, como os do CRAN: todos os projetos usam a mesma versão, e uma
atualização vale para todos.
