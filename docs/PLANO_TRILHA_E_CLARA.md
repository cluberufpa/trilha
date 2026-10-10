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
- **Projeto só com CRAN:** ~~enquanto a `clara` não estiver no CRAN, o
  projeto exportado continua levando a cópia em `R/clara/`~~. **Decidido em
  9/10/2026 (opção b do professor): o projeto usa `library(clara)`**, sem
  cópia. A `clara` só depende do CRAN e é leve; enquanto não estiver no
  CRAN, instala-se do GitHub (`remotes::install_github("cluberufpa/ClaRa")`,
  o mesmo que o `instalar_trilha.R` fará). A regra do projeto exportado
  passa a ser "só CRAN e a `clara`".

**Nomes das funções de apresentação** (confirmado em 9/10/2026): `exibir_*`
recebe um resultado já calculado e devolve a tabela (`exibir_teste()`,
`exibir_resumo()`, `exibir_tabela()`); "mostrar" fica para o código
(`mostrar_codigo = TRUE`). Nos moldes antigos da Trilha, `mostrar_*`
(`mostrar_anova()`) recebe os dados e roda o teste; esses saem com a Fase 3,
e nenhuma função nova, na ClaRa ou na Trilha, usa `mostrar_` para tabela.

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

**Andamento (9/10/2026):** plano aprovado pelo professor, com as decisões
A a M registradas na regra 4 do `ClaRa/CLAUDE.md`; regra 4 e
`PLANO_TRILHA.md` atualizados; prefixo `catalyser_` → `trilha_` feito
(etapa 2). Faltam tornar `cluberufpa/ClaRa` público (no GitHub, pelo
professor) e a etapa 3 do renome (textos da tela).

### Fase 1 · A ClaRa como pacote

**Feita em 9/10/2026** (ClaRa 0.9.0, ramo `pacote` do `cluberufpa/ClaRa`):
`R CMD check` com 0 erros, 0 notas e só o aviso conhecido dos acentos
(decisão J); 71 verificações no testthat; os seis roteiros de `exemplos/`
dão os mesmos números e figuras da 0.8.9. As vinhetas e os dados
exportados ficaram para depois (dados só nos testes, decisão I).

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
- A cópia de `inst/app/templates/clara/` deixa de existir, e o projeto
  exportado também não leva mais `R/clara/`: o `analise.R` e o
  `relatorio.qmd` carregam `library(clara)`, e o README do projeto diz a
  versão da `clara` que a tela usou e como instalá-la.
- O `relatorio.qmd` da rota ClaRa troca o `transmute()` + `flextable_ocean()`
  das duas tabelas por `exibir_teste()` e `exibir_resumo()` (ClaRa 0.10.0),
  e o `funcoes.R` do projeto deixa de precisar de `fmt()`, `formatar_p()` e
  `flextable_ocean()`.
- Um teste da Trilha que, para cada análise com rota ClaRa, gera o projeto,
  roda o `analise.R` e renderiza o `relatorio.qmd` numa sessão limpa.

**Andamento:** feita (9 e 10/10/2026).

- `DESCRIPTION` com `clara (>= 0.10.0)` em `Imports` e `cluberufpa/ClaRa`
  em `Remotes`; o `instalar_trilha.R` instala a `clara` do GitHub antes da
  IDE.
- O projeto da rota ClaRa (ANOVA de um fator, clássica, Welch e automático)
  carrega `library(clara)` no `analise.R` e no `relatorio.qmd`; saíram
  `R/clara/`, `R/funcoes.R` e `inst/app/templates/clara/`. As tabelas do
  relatório são `resultado |> exibir_teste()` e `resultado |>
  exibir_resumo(casas = casas, nota = textos$nota_tabela)`. Quando a receita
  de preparo usa `moda()` ou `converter_datas()`, a definição delas fica no
  próprio roteiro e no relatório, antes da receita. O README diz a versão da
  `clara` da exportação e como instalá-la.
- `test_clara_projeto_render.R`, na suíte: para cada entrada do registro
  com rota ClaRa, gera o projeto, roda o `analise.R` com `Rscript --vanilla`
  e o `quarto render`, e confere as tabelas da ClaRa no Word. Uma rota nova
  sem caso no teste faz o teste parar.
- **A tela da ANOVA de um fator roda a ClaRa** (10/10/2026). A chamada
  `comparar_medias(...)` nasce numa fonte só,
  `exportacao_anova_clara_chamada()`, em três formas com os mesmos
  argumentos: a da tela, sem comentários, que a tela avalia com o pacote
  `clara`; a do `analise.R` e a do relatório, com os comentários de cada um.
  As tabelas da tela são as da ClaRa no tema cinza, as figuras são as da
  ClaRa, e a aba "Código e console" mostra a chamada, o que a ClaRa imprime
  e o R comum por trás (`mostrar_codigo = TRUE`). No automático, a tela
  escolhe pelo Levene e a escolha entra em `variancias_iguais`. Saiu o
  seletor de tema do gráfico (a figura é a da ClaRa). Com dois grupos, a
  tela faz o teste t da ClaRa, e o projeto, até o teste t ganhar a sua rota
  ClaRa, sai pelo molde da ANOVA, com o mesmo p. Os testes conferem que as
  três formas dão a mesma expressão e que a chamada da tela é a que o
  estado registrado produz.
- O risco 2 se confirmou em parte. Comparação feita antes da troca, com as
  bases de `ClaRa/dados_treino` (rds e csv, confiança de 95% e 90%, os três
  métodos): F, p, GL, SQ, QM, médias, DP, EP, IC das médias, os pares
  (diferença, intervalo e p ajustado), o Shapiro dos resíduos e o Levene
  são **idênticos**. Mudaram, e o professor aceitou a forma da ClaRa:
  1. **Intervalo do η² e do ω² (clássica):** a tela usa o padrão do
     `effectsize`, unilateral (limite superior 1; bagres: η² de 0,649 a 1);
     a ClaRa, bilateral (0,597 a 0,906). As estimativas são as mesmas.
  2. **Pressupostos na ANOVA de Welch:** a tela mostra o Shapiro dos
     resíduos, o Levene e o Bartlett; a ClaRa, o Shapiro em cada grupo.
  3. **Letras:** com os mesmos p, a tela e a ClaRa (`multcompView`) podem
     dar nomes diferentes aos mesmos grupos (`sint_dez_tanques`, Welch a
     95%: o "b" de uma é o "c" da outra).
  4. **Bartlett:** a ClaRa não calcula.
  5. **Dois grupos:** a tela faz a ANOVA; a ClaRa, o teste t.
- Achado no caminho, anterior a esta fase: com empate (nenhum valor
  repetido), o `trat_moda()` da tela pegava o primeiro valor que aparece e o
  `moda()` / `trilha_moda()` do código exportado, o menor; a conferência do
  exportador barrava a exportação. **Corrigido em 10/10/2026** (decisão do
  professor): no empate, a tela também fica com o menor valor, como o
  "most_frequent" do scikit-learn; numa coluna numérica sem nenhum valor
  repetido, a etapa entra com um aviso que recomenda a mediana.


**Decisões do professor sobre as diferenças (10/10/2026):** em todas, a
forma da ClaRa. Intervalo do tamanho de efeito bilateral, o que se relata
em artigo. Pressupostos do Welch com o Shapiro em cada grupo: com variâncias
diferentes, juntar os resíduos mistura dispersões diferentes. Letras como na
ClaRa, que segue a regra pedida (o grupo de maior média recebe "a", e as
letras novas aparecem em ordem alfabética, descendo pelas médias; conferido
em todas as bases de treino; era a tela antiga que fugia dela em
`sint_dez_tanques`). Sem o Bartlett: ele confunde falta de normalidade com
variâncias diferentes, e o Levene já está lá. Com dois grupos, o teste t (a
ANOVA de dois fatores é outra tela e não muda).

### Fase 3 · Uma rota só de exportação

- Cada análise que ganha a rota ClaRa perde o molde antigo no mesmo
  commit: os `relatorio_*.qmd`, `funcoes_*.R` e pastas de molde vão
  saindo, um por análise, até sobrar só a rota ClaRa.
- O exportador fica com um contrato por análise: chamada da análise,
  chamadas de apresentação (tabela, figura, textos) e trecho de métodos.

**Andamento (10/10/2026): feita para a ANOVA de um fator e o teste t de
duas amostras**, depois do teste t em ClaRa (decisão do professor).

- Saiu a caixa "Escrever o código em ClaRa (experimental)" de Comunicação
  de Resultados: as duas análises saem sempre em ClaRa. O campo
  `codigo_clara` do manifesto ficou só para o exportador desligar a ClaRa
  (`FALSE`) nos registros antigos que dependem da fotografia da base; esses,
  e a ANOVA automática sem a escolha registrada, saem pelo exportador geral
  (o mesmo do projeto com várias análises, que ficou para depois).
- Saíram os moldes `templates/anova_projeto/` e
  `templates/teste_t_duas_amostras/`, as entradas deles no registro, as
  funções que só eles usavam e os testes que só os conferiam
  (`test_anova_molde_projeto`, `test_welch_molde`,
  `test_teste_t_molde_projeto`, `test_parametros_t_molde` e
  `test_figuras_molde`). `test_exportacao_preparo`,
  `test_preparo_comunicacao_completo` e `test_anova_preparo_projeto` passaram
  a conferir a receita da rota ClaRa (inclusive separar, empilhar e alargar).
- Contrato por análise: começou com a chamada
  (`exportacao_anova_clara_chamada()` e `exportacao_teste_t_clara_chamada()`,
  em três formas: tela, script e relatório); as apresentações e os métodos
  ainda moram nos moldes e nas funções de marcadores de cada rota.
- Fica para uma limpeza à parte: o painel antigo de exportação consolidada
  em `app.R` (`export_project_options_ui`, `download_consolidated_zip`),
  que nunca é posto na tela e cobre todas as análises.
- **Em aberto:** a ClaRa recusa grupos com hífen no nome ("ele atrapalha as
  letras das comparações"), e o molde antigo aceitava. Como a tela da ANOVA
  e a do teste t rodam a ClaRa, quem tem grupos assim precisa renomeá-los na
  Trilha antes. Decidir se a ClaRa passa a aceitar (letras sem
  `multcompView`, ou trocando o hífen por dentro).

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

**Andamento da onda 1 (10/10/2026): teste t de duas amostras feito.**
Decisões do professor no mesmo dia: o teste t vem antes da Fase 3 (fecha o
caso da ANOVA com dois grupos), e o projeto com várias análises juntas
fica para depois. A tela oferecia hipótese unilateral, que a ClaRa não
tinha; decidido que a ClaRa a ganha como argumento: ClaRa 0.11.0,
`comparar_medias(..., alternativa = "bilateral", "maior" ou "menor")`, só
com dois grupos, e a Trilha passa a pedir `clara (>= 0.11.0)`.

- A tela do teste t de duas amostras independentes roda a chamada de
  `exportacao_teste_t_clara_chamada()`, a mesma que o projeto escreve, e
  mostra as frases, as tabelas, o efeito, a figura e o Q-Q da ClaRa. As
  saídas comuns às três formas do teste t (hipóteses, tabela, distribuição
  t) leem os números da ClaRa. Uma amostra e pareado não existem na ClaRa
  e continuam com o `t.test()` direto.
- Molde `templates/teste_t_clara/` (roteiro, relatório Word e README), na
  entrada `teste_t_clara` do registro, usada com a caixa da ClaRa marcada.
  Ela também recebe a **ANOVA com dois grupos**: a tela da ANOVA, com dois
  grupos, roda a chamada do teste t, e o projeto sai por esta rota.
- `test_clara_projeto_render.R` cobre as duas rotas (seis casos: ANOVA
  clássica, Welch e automática; teste t de Welch bilateral, de Student
  unilateral e a ANOVA com dois grupos), e `test_teste_t_clara_tela.R`
  confere a tela nas três hipóteses.
- Faltam na onda 1: Mann-Whitney e Kruskal-Wallis (`comparar_medianas()`).
Mapas, planejamento amostral e o Laboratório de Conceitos não precisam da
ClaRa: não são análises com relatório estatístico.

**Andamento da onda 2 (10/10/2026): regressão linear simples feita.**
Decisões do professor no mesmo dia: `relacionar_variaveis(resposta,
preditor)`, figura principal `grafico_reta()`, uma reta só nesta versão (o
grupo da tela só colore os pontos, em `colorir_por`) e diagnóstico com
resíduos, Q-Q e uma tabela de influência. ClaRa 0.12.0; a Trilha passa a
pedir `clara (>= 0.12.0)` (versão 0.2.3).

- Com "Linear (reta)" e sem "uma reta por grupo", a tela da regressão roda a
  chamada de `exportacao_regressao_clara_chamada()`, a mesma que o projeto
  escreve, e mostra as frases, as tabelas (coeficientes e ajuste), o
  efeito, os pressupostos, as observações para conferir e as três figuras
  da ClaRa. O "Ver código R" mostra as chamadas da ClaRa e o R comum por
  trás delas. O Durbin-Watson da tela passa a ser o da ClaRa, com semente
  fixa (antes mudava a cada clique).
- Molde `templates/regressao_clara/` (roteiro, relatório Word e README), na
  entrada `regressao_clara` do registro. A receita da base com carimbo
  (`exportacao_clara_receita()`) aprendeu a ficar sem grupos: o carimbo traz
  as linhas e as médias da resposta e do preditor.
- Seguem no molde antigo (`regressao_linear`), sem ClaRa: as retas por grupo
  (outro modelo, com interação), a potência e o Von Bertalanffy.
- `test_clara_projeto_render.R` ganhou dois casos (reta simples; cor por
  população com Durbin-Watson) e `test_regressao_clara_tela.R` confere a tela.
- Falta na onda 2: a correlação.

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

### Fase 10 · Os dados dentro da ClaRa (ideia, sem decisão)

Registrada pelo professor em 9/10/2026, só como pensamento: a ClaRa
incorporar os conjuntos de dados do EAPADados, para que sobrem só dois
pacotes para manter, a `trilha` e a `clara`. Se a ideia vingar:

- **Não levar tudo.** O EAPADados tem hoje 43 arquivos em `data/`. O teto
  seria uns 25 conjuntos de tamanho médio a grande e uns 15 pequenos, sem
  inflar o pacote.
- **Dar boa cara a cada conjunto.** Nomes de variáveis revistos, colunas que
  nenhum exemplo usa retiradas, documentação de cada um.
- **Aproveitar o CRAN.** O que faltar para algum teste, exploração ou
  preparo pode vir de conjuntos de outros pacotes do CRAN, em vez de mais
  dados próprios.
- **Pacotes permitidos.** A regra continua: só CRAN, mais `clara`, `trilha`
  e `EAPADados` (este, enquanto existir).

Decidir só depois das Fases 4 e 5; até lá, os dados seguem no EAPADados.

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
