# Plano: Trilha e ClaRa, do mouse ao relatório

**Rascunho de 9 de outubro de 2026**, para discutir com o professor. Este
documento continua o [PLANO_TRILHA.md](PLANO_TRILHA.md), que trata da troca
de nome, e acrescenta o que vem agora: a ClaRa como pacote, a Trilha
chamando a ClaRa e um relatório Word satisfatório no fim de cada análise.

## Onde estamos

O que já foi conquistado e não se discute mais:

1. **Nome e marca.** A IDE se chama **Trilha** (pacote `trilha`), com o
   slogan *Da pergunta ao relatório, uma só trilha de análise* e o logo do
   hexágono com o R serifado e a trilha tracejada
   ([identidade_visual/Trilha/](identidade_visual/Trilha/LEIA-ME.md)). O
   nome conta o percurso inteiro: planejar, preparar, explorar, analisar e
   comunicar, com o mouse no começo e o código no fim.
2. **Um só relatório.** Na rota ClaRa, o Projeto R exportado tem um único
   `relatorios/relatorio.qmd`, que vira Word com o que a análise precisa
   mostrar num artigo ou numa tese: tabela, resumo por grupo, figura
   principal e o texto estatístico. O estudo fica no `R/analise.R`.
3. **Uma codificação mais fácil.** A ClaRa (versão 0.8.9) escreve as
   análises com funções em português, uma por pergunta da pesquisa
   (`comparar_medias()`, `comparar_medianas()`, `grafico_medias()`,
   `escrever_resultados()`), e mostra o R comum que rodou por baixo quando
   se pede `mostrar_codigo = TRUE`. Hoje cobre teste t (Welch e Student),
   ANOVA de um fator (clássica e de Welch), Mann-Whitney e Kruskal-Wallis.
4. **O primeiro encontro.** A ANOVA de um fator já sai da Trilha em ClaRa,
   nos três métodos da tela, e o Word nasce no Render do RStudio.

O que ainda falta:

- a ClaRa é uma pasta de scripts carregada com `source()`, num repositório
  privado; a Trilha só copia esses scripts para o projeto, não os executa;
- a cópia em `inst/app/templates/clara/` é feita à mão e pode atrasar;
- só a ANOVA de um fator tem a rota ClaRa; as outras análises da Trilha
  ainda exportam pelos moldes antigos (`relatorio_*.qmd`, `anova_projeto/`,
  `teste_t_*`, `regressao_linear/`);
- nem a Trilha nem a ClaRa estão prontas para o CRAN.

## Aonde queremos chegar

1. A **ClaRa vira um pacote R estruturado** (`clara`), que cresce por
   análise sem mexer no resto, e que um dia vai para o CRAN.
2. A **Trilha chama a ClaRa**: o resultado que a tela mostra sai da mesma
   chamada da ClaRa que vai escrita no projeto exportado.
3. A **integração é fluida** nos dois sentidos: quem clica vê a chamada;
   quem programa reconhece a tela.
4. **Cada análise termina num relatório Word satisfatório** (critérios
   abaixo), gerado por um só `relatorio.qmd`.
5. A **Trilha também vai para o CRAN**, depois da ClaRa.

## Decisão nova: a ClaRa vira pacote

Isso substitui a regra 4 do `ClaRa/CLAUDE.md` ("não transformar em pacote
por antecipação") e a seção "A ClaRa na Trilha" do `PLANO_TRILHA.md`. O
motivo concreto que a regra pedia agora existe: **a Trilha vai executar a
ClaRa**, e não só copiá-la. Com isso, um pacote instalado é o único jeito de
a tela e o projeto rodarem a mesma versão.

Os dois obstáculos anotados em 8/10 se resolvem assim:

- **Repositório privado:** tornar `cluberufpa/ClaRa` público (os alunos
  instalam de lá, como já fazem com a Trilha). A licença MIT já está lá.
- **Projeto só com CRAN:** enquanto a `clara` não estiver no CRAN, o projeto
  exportado continua levando a cópia em `R/clara/`, mas essa cópia passa a
  sair do pacote instalado, não de uma pasta mantida à mão. Quando a `clara`
  entrar no CRAN, o projeto troca o `source("R/clara/clara.R")` por
  `library(clara)` e volta a depender só do CRAN, sem cópia.

Nome do pacote: **`clara`**, minúsculo, como `trilha`. Na prosa, "ClaRa".
Os dois nomes estão livres no CRAN (consulta de 9/10/2026).

## Como as peças conversam

```
Tela da Trilha            escolhas do aluno (variáveis, método, confiança...)
      │
      ▼
chamada ClaRa (texto)     comparar_medias(resposta = peso, grupos = racao,
      │                                   variancias_iguais = TRUE, ...)
      ├──► a Trilha executa com o pacote clara e mostra o resultado na tela
      ├──► o exportador escreve a mesma chamada em R/analise.R
      └──► e repete as chamadas de apresentação em relatorios/relatorio.qmd
                                   │
                                   ▼  Render no RStudio
                              relatorio.docx
```

A regra que a ClaRa já segue ("o código mostrado é exatamente o que rodou")
passa a valer para a Trilha inteira: **a chamada que a tela rodou é a que o
projeto roda**. Na prática:

- cada análise da Trilha ganha uma função que transforma as escolhas da
  tela no texto da chamada da ClaRa, com todas as escolhas que importam
  escritas por extenso, mesmo quando são o padrão;
- a tela avalia esse texto (o mesmo `eval(parse())` que a ClaRa já usa) e
  mostra o resultado; o botão "Ver código" mostra a chamada e, com
  `mostrar_codigo = TRUE`, o R comum por baixo;
- o exportador não monta código próprio para a análise: escreve o mesmo
  texto.

Assim, o caminho de volta também existe: o aluno que lê o `analise.R`
reconhece nos argumentos os campos da tela.

## O que é um relatório satisfatório

Critérios para dar uma análise como pronta na rota ClaRa. O Word deve ter:

1. **Material e métodos:** o preparo da base (a trilha de tratamentos, em
   frases), o teste escolhido e por quê, os pressupostos conferidos e o
   nível de significância.
2. **Resultados:** a tabela principal do teste (tema Ocean, numerada e
   citada no texto), o resumo por grupo ou os coeficientes, a figura
   principal com legenda de artigo e o texto estatístico dinâmico (`escrever_resultados()`),
   com estatística, graus de liberdade, p, tamanho de efeito e intervalo.
3. **Pressupostos honestos:** frase que diz o que o teste mostrou, nunca
   "o pressuposto foi atendido"; se algum foi rejeitado, a recomendação.
4. **Referências** no estilo ABNT (ou APA, como alternativa).
5. **Renderiza do zero** numa sessão limpa do R, no Windows, com só os
   pacotes declarados. Esse é o teste que aprova.

O que não cabe no corpo do artigo vai para um apêndice do próprio Word,
nunca para um segundo documento.

## Fases

### Fase 0 · Decisões e arrumação

- Professor aprova este plano (ou o corrige).
- Atualizar a regra 4 do `ClaRa/CLAUDE.md` e a seção "A ClaRa na Trilha"
  do `PLANO_TRILHA.md` com a decisão nova.
- Tornar `cluberufpa/ClaRa` público.
- Fechar as etapas 2 e 3 do renome da Trilha (prefixo `catalyser_` →
  `trilha_` e textos da tela), para o pacote `clara` nascer conversando com
  uma `trilha` já sem o nome antigo.

### Fase 1 · A ClaRa como pacote

- `DESCRIPTION` (`Package: clara`), `NAMESPACE` e documentação pelo
  roxygen2. Os cabeçalhos atuais (Pergunta, Argumentos, Devolve, Exemplo)
  viram blocos `#'`; a `ajuda()` passa a abrir a página do painel Help.
- `exemplos/` vira vinhetas (uma por pergunta), e `dados_treino/` vira
  dados do pacote (`data/` para os `.rds`, `inst/extdata/` para os `.csv`).
- Testes com testthat usando as bases de treino: cada situação da tabela
  de `dados_treino/` vira um teste (Levene rejeita, pouco poder, faltantes,
  mais de 8 grupos...).
- Manter a organização de hoje: um arquivo por pergunta em `R/`, receitas
  em listas, o motor à parte. Pergunta nova = arquivo novo + receitas.
- `R CMD check` sem erros nem avisos desde o começo, mesmo antes de pensar
  no CRAN.

### Fase 2 · A Trilha chama a ClaRa

- A Trilha declara `clara (>= x.y.z)` em `Imports` e `Remotes:
  cluberufpa/ClaRa`; o `instalar_trilha.R` instala as duas.
- A ANOVA de um fator passa a mostrar na tela o resultado da chamada da
  ClaRa (hoje a tela tem cálculo próprio). É o teste da arquitetura.
- A cópia de `inst/app/templates/clara/` deixa de existir: o exportador
  copia os arquivos do pacote instalado (`system.file()`), na versão que a
  tela usou, e grava essa versão no README do projeto.
- Um teste da Trilha que, para cada análise com rota ClaRa, gera o projeto,
  roda o `analise.R` e renderiza o `relatorio.qmd` numa sessão limpa.

### Fase 3 · Uma rota só de exportação

- Cada análise que ganha a rota ClaRa perde o molde antigo no mesmo
  commit: os `relatorio_*.qmd`, `funcoes_*.R` e pastas de molde vão
  saindo, um por análise, até sobrar só a rota ClaRa.
- O exportador fica com um contrato por análise: chamada da análise,
  chamadas de apresentação (tabela, figura, textos) e trecho de métodos.

### Fase 4 · As análises, em ondas

A ordem segue o que a ClaRa já sabe fazer e o que é mais frequente no
curso:

| Onda | Análises | Na ClaRa | Na Trilha |
|---|---|---|---|
| 1 | teste t (Welch e Student), Mann-Whitney, Kruskal-Wallis | já existem | ligar à tela e ao exportador |
| 2 | regressão linear simples, correlação | `relacionar_variaveis()` (nova) | ligar |
| 3 | qui-quadrado, teste de proporções | `comparar_proporcoes()` (nova) | ligar |
| 4 | estatística descritiva | `descrever_variaveis()` (nome a decidir) | ligar |
| depois | ANOVA de dois fatores, ANCOVA, não linear, PCA, HCA | a decidir caso a caso | ficam no molde antigo até migrarem |

Uma onda por vez, e uma análise só fecha quando o projeto exportado
renderiza o Word e passa nos critérios acima (regra 2 da ClaRa, estendida).
Mapas, planejamento amostral e o Laboratório de Conceitos não precisam da
ClaRa: não são análises com relatório estatístico.

### Fase 5 · CRAN

Primeiro a `clara` (menor e sem interface), depois a `trilha`. O que o CRAN
vai cobrar e já se sabe hoje:

- **Acentos no código.** Dez arquivos de `R/` (das duas) têm caracteres fora
  do ASCII em textos. O CRAN pede escapes (`ç` no lugar de `ç`) no
  código do pacote; as mensagens continuam em português na tela. Convém um
  script que faça a troca automaticamente antes do envio, para o código-fonte
  seguir legível.
- **`library()` dentro de funções.** O `executar_receita()` da ClaRa carrega
  pacotes com `library()`, o que o CRAN não aceita em código de pacote. Saída
  a estudar: avaliar a receita num ambiente que já enxerga os pacotes
  importados, deixando o `library()` só no texto mostrado ao aluno (que precisa
  dele para rodar a receita copiada).
- **Arquivos gravados.** `salvar_tabelas()`, `salvar_figuras()` e
  `registrar_ambiente()` só podem gravar onde o usuário mandar, nunca por
  padrão na pasta de trabalho durante exemplos e testes.
- **EAPADados.** A Trilha importa o EAPADados, que está só no GitHub. Ou ele
  vai antes para o CRAN, ou passa para `Suggests` e a Trilha funciona sem ele.
- **Tamanho e dependências.** A Trilha tem cerca de 45 pacotes em `Imports`;
  vale revisar quais podem ir para `Suggests` antes do envio.

## Sobre a crítica de que "isso não é R"

A escolha foi difícil e continua defensável. A posição a sustentar, no
livro e na apresentação do projeto:

- **A ClaRa é R.** São funções comuns, num pacote comum, chamadas num script
  comum. Não há sintaxe nova, parser nem tradução de `filter` e
  `summarise`: o aluno precisa reconhecê-los quando vê a receita.
- **O R fica sempre à vista.** Cada chamada mostra, quando se pede, o código
  tidyverse que rodou, e esse código roda sozinho, sem a ClaRa.
- **É uma ponte, não um muro.** O aluno começa no mouse, passa pela ClaRa e
  termina lendo R. Um capítulo do livro pode mostrar a mesma análise nos três
  níveis: a tela da Trilha, a chamada da ClaRa e o R comum.

## Riscos e decisões em aberto

1. **Duas manutenções durante a transição.** Enquanto houver análises no
   molde antigo, o exportador terá duas rotas. A Fase 3 existe para isso não
   durar: cada migração apaga o molde antigo da análise.
2. **Cálculo da tela × cálculo da ClaRa.** Hoje a tela da ANOVA calcula por
   conta própria. Se a tela passar a usar a ClaRa, os números podem mudar em
   detalhes (arredondamento, ordem dos grupos). Conferir com os dados de
   treino antes de trocar.
3. **Versões descasadas.** Um aluno com a Trilha nova e a `clara` velha. O
   `Imports` com versão mínima resolve na instalação; a tela pode avisar se
   a versão carregada for menor.
4. **Ritmo.** Cada onda mexe nos dois repositórios. Para não se perder:
   mudança nasce na ClaRa (com versão nova), e a Trilha sobe o
   `clara (>= ...)` no mesmo dia.

## Próximo passo

Fase 0: o professor lê este plano, corrige o que for preciso e aprova a
decisão de empacotar a ClaRa. Depois disso, o primeiro trabalho concreto é o
esqueleto do pacote `clara` (Fase 1), com a ANOVA de um fator passando no
`R CMD check`.
