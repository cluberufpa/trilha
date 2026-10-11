# Prompt — migração dos dados do EAPADados para a ClaRa (e, depois, para a Trilha)

> Cole tudo abaixo da linha numa sessão nova, aberta na pasta-mãe
> `D:\Claude\EAPA-Ecossistema` (para enxergar `EAPADados/`, `ClaRa/` e `TRILHA/`).
> Escrito em 11/10/2026. A seção "Mudança de plano", logo abaixo, foi
> acrescentada no fim do mesmo dia e vence o resto do prompt onde houver
> conflito.

---

## Mudança de plano (11/10/2026): integrar todos agora, ajustar depois

O professor parou o fluxo de um conjunto por vez. A migração passa a ter duas
passadas, e esta sessão faz só a primeira.

### Passada 1 (agora): todos os conjuntos na ClaRa, como estão

Integre **todos** os conjuntos da aba **Núcleo 60** da planilha
`balanco_fase2_60_conjuntos.xlsx`, sem parar a cada um para proposta e
aprovação. O objetivo é que, ao fim, todos estejam disponíveis para a ClaRa e
a Trilha fazerem qualquer análise. A arrumação fina vem depois, com o
professor.

**O que você aplica nesta passada:**

- **O nome do objeto, definitivo.** Decida-o agora: depois que a Trilha passar
  a ler da ClaRa, ele não muda mais. Use o nome já decidido na curadoria
  (`curadoria_eapadados_revisao.xlsx`, `decisoes_lidas.json`, planilha dos 60);
  se não houver decisão, o nome atual do EAPADados, desde que siga a regra
  `<organismo ou tema>_<assunto>`. Nome duvidoso vai para a lista de
  pendências (abaixo), com a sua sugestão, e o conjunto entra com ela.
- **As decisões que o professor já tomou** sobre colunas e categorias nas
  planilhas de curadoria. Não reabra nenhuma.
- **A tradução mínima dos dados de pacotes R** (colunas e categorias em inglês
  para `snake_case` em português, ASCII), porque sem ela o conjunto não serve
  ao aluno. O de-para vai na ficha.
- **A convenção do D01** para acentos nas categorias e para o texto do
  catálogo.
- **As decisões já tomadas nesta migração.** O sintético `artemia` foi recusado
  pelo professor e não entra; a fonte real (`artemia_fitoesterois`) entra como
  conjunto próprio, com os nomes dela. A Trilha ajusta o seu conjunto padrão.

**O que você não aplica:** mudanças novas em nomes de colunas e categorias dos
conjuntos do EAPADados. Ficam como estão. Sugestões vão para a seção
"Pendências para a curadoria" da ficha.

**Ficha enxuta.** Na passada 1, a `FICHA.md` precisa de: identidade (código,
registro, nome do objeto, rótulo, título, unidade amostral, dimensões),
natureza, origem e licença, de-para (só do que mudou), linhas (preservadas ou
o filtro aplicado), uso didático (análises da Trilha) e "Pendências para a
curadoria". O resto do modelo da ficha se completa na passada 2.

**Catálogo.** Cada conjunto entra no `catalogo_dados` com as colunas que o D01
já usa, inclusive `registro`, `nome_eapadados` e `situacao`. Na passada 1,
`situacao` começa por `"provisório"`, seguida das pendências que importam ao
aluno (por exemplo, `"provisório; autorização dos autores pendente"`). O D01,
já revisado, fica como está.

**Pare e pergunte só quando:**

- a licença impedir a cópia;
- o objeto do EAPADados não bater com a fonte original;
- o conjunto for sintético e não houver autorização explícita para ele;
- faltar algo sem o qual o conjunto não pode entrar.

Nos demais casos, anote na lista de pendências de `data-raw/LEIA-ME.md` e siga
para o próximo. Leve a lista ao professor ao fim de cada bloco.

**Conferência.** A cada conjunto, o `preparar.R` termina com `stopifnot()` nas
dimensões, e `roxygen2::roxygenise()` e `devtools::test()` passam. O `R CMD
check` completo roda ao fim de cada bloco de cerca de dez conjuntos, com a meta
do `ClaRa/CLAUDE.md`. Os produtos da verificação (`clara.Rcheck/`, o
`.tar.gz`, bibliotecas temporárias) ficam fora de `data-raw/`, numa pasta
temporária fora do repositório.

**Tamanho: no máximo 3 MB para a pasta `data/` inteira** (meta do professor,
cerca de 20 a 50 KB por conjunto). Meça com `tools::checkRdaFiles("data")`
depois de cada conjunto, sempre com `compress = "xz"`. Um conjunto acima de
100 KB só entra depois de o professor ver o tamanho; diga o que o faz grande
(linhas, colunas de texto longas) e se há como reduzir sem perder o uso
didático. Ao fim de cada bloco, informe o total.

**Git.** Agora só uma IA trabalha por vez, então o fluxo fica mais leve: um
commit por conjunto na branch `dados`, com a mensagem
`dados: Dxx <nome> (de EAPADados::<antigo>)`, e o merge na `main` ao fim de
cada bloco, com as conferências de "Seu espaço de trabalho" (a `main` parada e
a `ClaRa/` limpa). O `push`, só quando o professor pedir.

**Ordem.**

1. Os presos ao código da Trilha: `bagre_racao_isoproteica` (já é o D01),
   `morfometria_barbo`, `cpue_tubarao` e `doubs_ambiente`.
2. Os usados pelos testes da Trilha: `abalone_adultos`,
   `salvelino_formalina_remocao`, `camarao_vannamei_biometria` e `pinguins`.
3. Os demais, na ordem da aba Núcleo 60.

Os detalhes do que a Trilha lê em cada um estão em
`TRILHA/docs/PEDIDO_DADOS_TRILHA_PARA_CLARA.md`.

**Ao terminar**, avise o professor. A sessão da Trilha revisa a integração
inteira e só então troca a fonte da Trilha para a ClaRa.

### Passada 2 (depois, com o professor): a curadoria

Um conjunto por vez, seguindo "O fluxo de um conjunto", mais abaixo: nomes de
colunas, categorias, ficha completa. Ao terminar, `situacao` passa a
`"revisado"`. Mudança de coluna nos quatro conjuntos presos ao código da
Trilha precisa de aviso, para a Trilha acompanhar.

### Registro: `Dxx_duas_palavras`

Decisão do professor (11/10/2026), que substitui o formato de três dígitos:

- **Código:** `D01`, `D02`, ..., `D99`: dois dígitos, pela ordem de chegada,
  sem renumerar.
- **Registro:** o código, um `_` e **no máximo duas palavras** em
  `snake_case`, sem acento: `D01_bagre_racao`, `D02_barbo_morfometria`. É o
  nome da pasta em `data-raw/` e vai na coluna `registro` do catálogo e na
  ficha.
- **Nome do objeto:** sem número, por extenso e definitivo
  (`bagre_racao_isoproteica`).
- **O que já existe muda para o formato novo:** `D001` vira `D01`, e
  `D001_bagre_racao` vira `D01_bagre_racao` (pasta, ficha, `preparar.R`,
  catálogo, título da ajuda, `LEIA-ME.md` e a planilha de acompanhamento). Os
  commits antigos ficam como estão.

## Quem você é nesta tarefa

Você é o **criador e arrumador da estrutura de dados da ClaRa**. Seu trabalho é
levar, **um conjunto por vez**, os cerca de 60 conjuntos de dados já
pré-selecionados (pelo professor e por uma IA anterior) para dentro do pacote R
`clara`, limpos, arrumados no formato *tidy*, com nomes claros em português e
documentação completa da origem e das adaptações. Depois, numa fase seguinte, a
Trilha passa a oferecer esses dados no seu menu lendo-os da `clara`.

Você trabalha com o professor (Evaldo) numa **curadoria rigorosa**: propõe,
espera a decisão, aplica só o que foi aprovado e documenta o que fez. Nada de
migração em lote.

Todo o trabalho é em **português do Brasil**: código, comentários, mensagens,
documentação e conversa.

## Pastas que você usa

| Pasta | O que é | O que você faz nela |
|---|---|---|
| `EAPADados/` | pacote atual de dados (`astuciasnor/EAPADados`) | **só lê**: objetos em `data/`, documentação em `R/data_*.R`, preparo em `data-raw/`, curadoria em `dev/curadoria_2026/` e `nova_estetegia_levantamento/` |
| `ClaRa/` | pacote `clara` (`cluberufpa/ClaRa`) | **é aqui que os dados nascem**: `data-raw/`, `data/`, `R/dados_*.R`, testes, NEWS |
| `TRILHA/` | IDE Shiny, pacote `trilha` (`cluberufpa/trilha`) | nesta fase, **só lê** (para entender como o menu de dados funciona hoje); a integração é a Fase 3 |

O resto do ecossistema (`EAPA/`, `EAPACadernos/`, `APOIO/`, `ATIVIDADES/`) você
pode consultar, mas não altera.

## Seu espaço de trabalho: só os dados, numa branch própria

Enquanto você migra os dados, **outras sessões continuam trabalhando na ClaRa**
(funções novas, verbos, testes, exemplos, a ligação com a Trilha). O seu papel é
mexer nos dados e disponibilizá-los. Não toque no resto.

**Os arquivos que são seus:**

- `data-raw/` (a pasta inteira) e `data/`;
- `R/dados_*.R` (a documentação de cada conjunto e do catálogo);
- `tests/testthat/test-dados.R`;
- `man/` só para as páginas que o roxygen gera dos seus `R/dados_*.R`.

**Os arquivos que você toca só no ponto necessário, porque são compartilhados:**

- `DESCRIPTION`: uma vez, para `LazyData: true` (e, se for preciso,
  `Depends: R (>= ...)` por causa do formato do `.rda`). Não mexa em versão,
  `Imports` nem `Collate`;
- `NEWS.md`: uma linha por conjunto, sob o título da versão em desenvolvimento;
- `.Rbuildignore`: uma linha para `^data-raw$`;
- `ClaRa/CLAUDE.md`: só a linha da estrutura que registra `data-raw/` e
  `data/`, depois da autorização do professor.

**Os que não são seus:** as funções em `R/clara_*.R`, os outros testes,
`exemplos/`, `dados_treino/`, `ferramentas/`, `docs/`, `README.md`, `NAMESPACE`
escrito à mão. Se um conjunto pedir mudança neles (por exemplo, trocar a fonte
de uma base `real_*` de `dados_treino/`, ou criar a função
`conjuntos_de_dados()`), **não faça: anote na ficha e proponha ao professor**,
que decide quem faz e quando. Se uma verificação falhar por causa de código que
não é seu, relate e não corrija.

**Como trabalhar no Git:**

1. **Não troque de branch na pasta `ClaRa/`.** Outras sessões usam essa pasta
   na `main`; trocar a branch ali mudaria os arquivos debaixo delas. Crie uma
   pasta de trabalho separada com `git worktree`, ao lado da ClaRa:

   ```bash
   cd D:/Claude/EAPA-Ecossistema/ClaRa
   git fetch origin
   git worktree add ../ClaRa-dados -b dados origin/main
   ```

   Todo o seu trabalho acontece em `D:\Claude\EAPA-Ecossistema\ClaRa-dados`.
2. **Uma só branch, `dados`, para toda a migração.** Basta uma porque o fluxo
   já é um conjunto por vez: cada conjunto termina integrado na `main` antes de
   o próximo começar, e a branch continua viva. Um commit por conjunto, com o
   número no título, deixa o histórico separado por conjunto do mesmo jeito.
   Antes de começar cada conjunto novo, traga a `main` atual
   (`git fetch origin` e `git merge origin/main`), para partir do que as outras
   sessões já fizeram.
3. **Quando o conjunto estiver pronto e aprovado**, antes de pedir a
   integração:
   - `git fetch origin` e traga a `main` atual para a sua branch
     (`git merge origin/main`);
   - se houver conflito, resolva só nos arquivos que são seus. Nos
     compartilhados (`DESCRIPTION`, `NEWS.md`), preserve a versão da `main` e
     reaplique por cima só a sua linha. Conflito em arquivo que não é seu:
     pare e pergunte;
   - rode de novo, na branch atualizada, `roxygen2::roxygenise()`,
     `devtools::test()` (todos os testes, não só os seus) e o `R CMD check`
     com a meta do `ClaRa/CLAUDE.md`;
   - mostre ao professor o resumo da integração: os arquivos alterados
     (`git diff --stat origin/main...`), se houve conflito e como foi
     resolvido, e o resultado dos testes e do check.
4. **Peça a integração na `main` e espere o "sim".** Quem integra é você, não
   as sessões que trabalham em outras partes da ClaRa: você conhece o que
   mudou e resolve qualquer conflito nos seus arquivos. A `main` está aberta na
   pasta `ClaRa/` (o Git não deixa a mesma branch aberta em duas pastas), então
   o merge é feito lá. Logo antes dele, confira:
   - **a `main` não andou desde os seus testes** (compare `git rev-parse main`
     com a `main` que você trouxe no passo 3). Se andou, volte ao passo 3:
     traga de novo, teste de novo;
   - **a `ClaRa/` está limpa** (`git status` sem alterações por salvar).

   Com as duas conferências em ordem, rode na `ClaRa/`
   `git merge --no-ff dados`, sem reescrever o histórico, e avise o professor.
   Se a `ClaRa/` tiver trabalho por salvar de outra sessão, **não faça o
   merge**: diga ao professor que a branch `dados` está testada e pronta, e
   espere. Ele escolhe entre pedir à outra sessão que faça o commit do trabalho
   dela (e então você integra) ou pedir a ela que rode `git merge --no-ff dados`
   num momento de pausa, o que é seguro porque a branch já foi testada sobre a
   `main` atual.

   O `push`, só se o professor pedir. Se ele preferir revisar no GitHub, envie
   a branch `dados` e abra um pull request em vez do merge local.
5. Ao terminar toda a migração, remova a pasta de trabalho com
   `git worktree remove ../ClaRa-dados`, com a autorização do professor.

## Leia antes de começar (nesta ordem)

1. `CLAUDE.md` (raiz do ecossistema) e `ClaRa/CLAUDE.md` — convenções gerais, a
   gramática da ClaRa, a meta do `R CMD check` e o R desta máquina
   (`C:/R/R-4.6.1/bin/Rscript.exe`; no Git Bash, grave o teste num `.R` e rode o
   arquivo, porque um `-e` com várias linhas derruba o Rscript).
2. `EAPADados/nova_estetegia_levantamento/balanco_levantamento_fechado.md` e a
   planilha `balanco_fase2_60_conjuntos.xlsx` (abas **Núcleo 60**,
   **Inventário**, **Pendências**). É a lista dos ~60 conjuntos, com a origem, a
   análise que cada um atende, a situação e o que se propõe mudar.
3. `EAPADados/dev/curadoria_2026/README.md` — sobretudo a seção **"Documentação
   obrigatória de cada adaptação"**, que é exigência do professor e vale
   integralmente aqui, e os **"Achados do levantamento"** (armadilhas já
   descobertas: `camaroes_sexo` não pode passar por `distinct()`,
   `gammarus_..._resumo` não tem réplicas, `qfasa_acidos_graxos` é 39 × 1, etc.).
4. `EAPADados/dev/curadoria_2026/curadoria_eapadados_revisao.xlsx` e
   `decisoes_lidas.json` — decisões **já tomadas** pelo professor sobre nomes,
   variáveis e categorias. Não reabra o que já foi decidido; parta delas.
5. `APOIO/CURADORIA_DADOS/SKILL_curadoria_dados_EAPA.md` — critérios de
   curadoria, status jurídico (`publico_aberto`, `artigo_aberto`, `simulado`…).
6. `EAPADados/dev/CHECKLIST_novo_dataset.md` e `EAPADados/data-raw/preparar_curados_2026.R`
   — como os dados entram hoje num pacote; o novo fluxo herda isso.
7. `ClaRa/dados_treino/preparar_dados_treino.R` — as bases `real_*` da ClaRa já
   vêm do EAPADados; elas mostram o formato que a ClaRa espera (grupos como
   fator na ordem natural, `id_*` como texto).
8. `TRILHA/inst/app/app.R`, por volta das linhas 179–200 e 2870–2890 — como a
   Trilha lista hoje os conjuntos (`data(package = "EAPADados")`) e carrega um
   deles. Só para entender; não altere.

## A estrutura que você vai criar na ClaRa

```
ClaRa/
  data-raw/                       (no .Rbuildignore: não vai no pacote)
    LEIA-ME.md                    como a pasta funciona e o fluxo de um conjunto
    <nome_do_conjunto>/           UMA PASTA POR CONJUNTO
      fonte/                      os arquivos originais, intocados
                                  (CSV/XLSX baixado, ou o objeto do EAPADados
                                  ou do pacote R salvo em .rds), com SHA256
      preparar.R                  da fonte ao objeto final, comentado, que
                                  termina em usethis::use_data(<nome>,
                                  overwrite = TRUE, compress = "xz")
      FICHA.md                    a ficha de curadoria (modelo abaixo)
  data/<nome>.rda                 o conjunto pronto (LazyData)
  R/dados_<nome>.R                a documentação roxygen (vira ?<nome>)
  R/dados_catalogo.R              a documentação do catálogo
  data/catalogo_dados.rda         o catálogo de todos os conjuntos (ver adiante)
  tests/testthat/test-dados.R     conferência genérica de todos os conjuntos
```

Essa é a pasta dos dados individuais: **cada conjunto é uma subpasta de
`ClaRa/data-raw/`**, autossuficiente, que reproduz o `.rda` a partir da fonte.
Antes de criá-la, confira no `ClaRa/CLAUDE.md` a "regra 1 de crescimento" (a
pasta `dados_treino/` precisou de autorização como exceção): **peça ao
professor a autorização para criar `data-raw/` e `data/` na ClaRa** e registre
a decisão no `ClaRa/CLAUDE.md`, na seção de estrutura.

### A ficha de curadoria (`FICHA.md`) de cada conjunto

1. **Identidade:** número de registro (`Dnn`), nome final do objeto, rótulo
   curto e título em português, uma frase sobre
   o que é, unidade amostral (o que é uma linha), dimensões finais.
2. **Natureza:** medição real · dado agregado · reconstrução/digitalização ·
   sintético de treino. Nunca apresentar sintético ou agregado como medição.
3. **Origem e créditos:** autores, título, ano, DOI/URL; se vier de pacote R:
   pacote, objeto e versão. Licença da origem e status jurídico da skill de
   curadoria. Não inventar referência ausente: escrever "não localizada".
4. **De-para das colunas:** tabela `nome original → nome final`, unidade,
   tipo, e o motivo de cada coluna removida.
5. **De-para das categorias:** para cada fator, `nível original → nível final`
   e a ordem dos níveis.
6. **Linhas:** filtros e critérios, número de linhas antes e depois; se nada
   foi excluído, dizer que as linhas foram preservadas. Motivo de cada `NA`
   que permanecer.
7. **Cálculos e formatos:** colunas derivadas, conversões de unidade,
   largo → longo, junções.
8. **Uso didático:** análises da Trilha que ele atende, a pergunta de pesquisa
   em uma frase e a chamada da ClaRa que responde a ela (quando o verbo já
   existe).
9. **Limites científicos:** o que o conjunto **não** permite (pseudorréplica,
   pareamento ausente, uma só campanha por fase…).
10. **Decisões do professor:** data e o que foi aprovado, ajustado ou recusado.
11. **Conferência:** `stopifnot()` que o `preparar.R` roda, e a confirmação de
    que a documentação bate com o objeto.

## Padrão de arrumação (o que é um conjunto "pronto")

- **Tidy:** uma linha por observação da unidade amostral, uma coluna por
  variável, um valor por célula. Formatos largos só quando o conjunto existe
  justamente para treinar o "arrumar" (ex.: `treino_desembarque`), e isso fica
  dito na ficha.
- **Nomes do objeto:** `snake_case`, português, sem acento, de
  `<organismo ou tema>_<assunto>` (`bagre_racao_isoproteica`,
  `camarao_vannamei_biometria`). Não pode colidir com uma função da `clara`, com
  um conjunto do pacote `datasets` nem com nomes comuns do R (`data`, `df`, `t`).
  Ao renomear um conjunto do EAPADados, registre o nome antigo na ficha e no
  `@details`, para quem vem do livro.
- **Nomes das colunas:** `snake_case`, português, ASCII (sem acento nem `ç`),
  curtos mas inteiros (`comprimento_total`, não `ct`), com a **unidade como
  sufixo** quando houver (`peso_g`, `comprimento_total_mm`, `temperatura_c`,
  `captura_kg`). Identificadores começam com `id_` e são texto. Nada de colunas
  repetidas (código + rótulo da mesma coisa) nem de colunas derivadas que o
  aluno deve calcular na Trilha (`log_peso`), salvo decisão contrária do
  professor.
- **Nome e número de registro: duas coisas separadas.**
  - O **nome do objeto** (`bagre_racao_isoproteica`) é o que o aluno digita no
    R. Não tem número, não lista análises e nunca muda depois de publicado.
  - O **número de registro** (`D01`, `D02`, …, `D99`; pasta no formato
    `Dxx_duas_palavras`, ver "Mudança de plano") funciona como uma
    matrícula. O conjunto recebe o próximo número livre **quando entra** na
    ClaRa, e o número é dele para sempre. Não indica posição, capítulo nem
    análise, só a ordem de chegada; por isso nunca se renumera. Um conjunto
    retirado não cede o número a outro. O número fica só na coluna `codigo` do
    catálogo, no título da ajuda ("D04 · Bagres: rações isoproteicas") e na
    ficha. Serve para citar em aula e no livro ("abram o D04") e para buscar na
    Trilha. Nunca vai no nome do objeto, que no R não pode começar por dígito.
  - O piloto recebe o `D01`, e assim por diante na ordem em que forem
    aprovados. A tabela da fila em `data-raw/LEIA-ME.md` mostra o número de
    cada um.
- **Tipos:** grupos e tratamentos como `factor` na **ordem natural** (baixa,
  media, alta; controle primeiro; meses em ordem do calendário), não
  alfabética; datas como `Date`; contagens como `integer`; medidas como
  `double`; sim/não como `logical` ou fator, conforme a análise pedir.
- **Categorias:** podem e devem ser mexidas na curadoria, como já se faz:
  traduzir, padronizar caixa e grafia, tirar códigos obscuros. Proponha o
  de-para e espere a aprovação.
- **Objeto:** `tibble` ou `data.frame` simples, sem atributos estranhos, sem
  `rownames` com informação (vira coluna).
- **Nada de fabricar:** não inventar réplicas, níveis, unidades ou valores; não
  imputar `NA` para "limpar" a base (imputação é tarefa da Trilha de Preparo).
  Unidade desconhecida fica pendente, não presumida.

### Decisão a levar ao professor logo no início: acentos nas categorias

A meta do `R CMD check` da ClaRa é 0 erros, 0 notas e um só aviso conhecido (os
acentos no código, resolvidos por `ferramentas/preparar_cran.R`). Categorias
com acento dentro de um `.rda` geram uma **nota** nova ("found N marked UTF-8
strings"). As opções são: (a) níveis sem acento (`media`, `racao_comercial`),
como já fazem as bases de `dados_treino/`; (b) níveis com acento e aceitar a
nota, documentando-a; (c) níveis sem acento no `.rda` e rótulos com acento
aplicados pelas funções de gráfico/tabela da ClaRa. Recomende a (a) para
começar, por ser simples e coerente com o que existe, e **pergunte antes de
migrar o primeiro conjunto**. Nomes de colunas são sempre ASCII.

## Integração com a ClaRa: como tem de ficar fluida

O critério é: **o aluno faz `library(clara)` e o dado já está lá, com nome que
se lê em voz alta, e a primeira análise sai em uma linha.**

1. **Disponível pelo nome.** `LazyData: true` no `DESCRIPTION` da ClaRa: depois
   de `library(clara)`, `pinguins` já é o conjunto, sem `data()`.
2. **Ajuda em português.** `?bagre_racao_isoproteica` abre a página com título,
   descrição, unidade amostral, cada coluna com unidade, origem e licença, as
   adaptações (resumo da ficha) e a natureza do dado (real, agregado, sintético).
3. **Exemplo que roda com um verbo da ClaRa.** Quando o verbo já existe
   (`comparar_medias()`, `comparar_medianas()`, `relacionar_variaveis()`), o
   `@examples` mostra a pergunta da pesquisa respondida com ele, com os
   argumentos explícitos (a ClaRa esconde a mecânica, mas mostra o que se
   analisa; nada de padrões escondidos). Quando o verbo ainda não existe, o
   exemplo usa R comum curto (`summary()`, `table()`) e a ficha anota "aguarda
   verbo da ClaRa: <qual>".
4. **Pronto para o verbo, sem preparo escondido.** As colunas já têm o tipo que
   os verbos esperam (fator ordenado para o grupo, número para a resposta), para
   que `comparar_medias(dados = x, resposta = ganho_peso_g, grupo = racao)`
   funcione direto.
5. **Um catálogo.** O objeto `catalogo_dados` (um `data.frame`, um conjunto por
   linha) com:
   - `codigo`: o número de registro (ver "Nome e número de registro", abaixo);
   - `nome`: o nome do objeto (`bagre_racao_isoproteica`);
   - `rotulo`: o título curto que a Trilha mostra ("Bagres: rações
     isoproteicas");
   - `titulo`: o título completo da ajuda;
   - `natureza` (real / agregado / reconstruido / sintetico);
   - `origem` (EAPADados / literatura / pacote R: `<pacote>`);
   - `unidade_amostral`, `linhas`, `colunas`;
   - `analises`: todas as análises da Trilha que ele atende, com os mesmos
     nomes do menu da Trilha (confira-os em
     `EAPADados/dev/curadoria_2026/funcionalidades_trilha.md`);
   - `analise_principal`: a análise da qual ele é o melhor exemplo (uma só);
   - `palavras_chave`: organismo, tema e termos que o aluno digitaria na busca
     ("bagre", "racao", "proteina", "piscicultura");
   - `verbo_clara`, `licenca`, `referencia`.

   É a fonte única que a Trilha vai ler na Fase 3. Uma função simples, `conjuntos_de_dados()` (nome a
   confirmar com o professor), pode filtrar o catálogo por análise
   (`conjuntos_de_dados(analise = "anova")`). Crie a função só depois de três ou
   quatro conjuntos migrados, quando o formato do catálogo estiver estável, e
   siga a skill `ClaRa/.claude/skills/clara-nova-funcao/SKILL.md`.
6. **Um teste genérico.** `tests/testthat/test-dados.R` percorre o catálogo e
   confere, para cada conjunto: existe; dimensões batem com o catálogo; nomes de
   colunas são ASCII `snake_case`; as colunas documentadas em `R/dados_<nome>.R`
   são exatamente as do objeto; fatores não têm níveis vazios; `id_*` é texto.
7. **`dados_treino/` passa a beber da própria ClaRa.** Quando um conjunto que
   originou uma base `real_*` for migrado, o `preparar_dados_treino.R` passa a
   lê-lo da `clara` em vez do EAPADados. Confira que a base de treino e os
   testes continuam iguais (ou atualize-os, se o professor aprovou mudanças de
   nome).
8. **Dependências.** A ClaRa só pode depender de pacotes do CRAN. Dados não
   criam dependência: o `.rda` é autossuficiente. Pacotes usados só no
   `preparar.R` (`readxl`, `janitor`, `FSAdata`…) não entram no `DESCRIPTION`.
9. **Tamanho.** A meta do professor é no máximo 3 MB para toda a pasta
   `data/` (o CRAN aceita até ~5 MB). O núcleo de 60 foi estimado em 0,66 MB,
   mas confira após cada conjunto com `tools::checkRdaFiles("data")` e use
   `compress = "xz"`. Registre o tamanho na ficha.

## Dados que vêm de outros pacotes R — entram na ClaRa, traduzidos

Cerca de 21 dos 60 vêm de pacotes R (`datasets`, `MASS`, `FSAdata`, `astsa`,
`agridat`). **Decisão do professor (11/10/2026): eles entram na ClaRa**, como
cópia traduzida e arrumada, porque quase sempre é preciso traduzir nomes de
colunas e categorias, e o aluno precisa do dado em português, pronto para os
verbos. Seguem o mesmo fluxo dos demais (proposta, aprovação, ficha, número de
registro), com três cuidados a mais:

- **A origem fica visível em todo lugar.** O catálogo diz
  `origem = "pacote R: MASS (ships)"`; a ajuda abre com "Adaptado de
  `MASS::ships`", com a versão do pacote, os autores, a referência original que
  o pacote cita e a licença; a ficha guarda o de-para completo do original para
  o traduzido, para quem quiser voltar ao objeto em inglês.
- **A fonte é congelada.** Em `data-raw/<nome>/fonte/`, salve o objeto original
  em `.rds`, com o nome e a versão do pacote no nome do arquivo
  (`MASS_7.3-61_ships.rds`), e o texto da página de ajuda original. O
  `preparar.R` lê esse `.rds`, não o pacote instalado: assim a ClaRa não ganha
  dependência e o `.rda` se reproduz mesmo se o pacote mudar.
- **A licença é conferida antes da proposta.** A ClaRa é MIT, e vários desses
  pacotes são GPL. Confira a licença de cada pacote e o que a documentação diz
  sobre a origem de cada conjunto, e diga ao professor, na proposta, o que ela
  permite e se há alguma restrição (por exemplo, exigência de manter o crédito
  ou de declarar a modificação). Se a licença impedir a cópia, não copie:
  relate e espere a decisão.

## O fluxo de um conjunto (sempre um por vez)

1. **Escolher** o próximo da fila (ordem abaixo) e anunciar ao professor qual é.
2. **Ler tudo sobre ele:** o objeto atual no EAPADados (`str()`, `summary()`,
   níveis, `NA`, linhas repetidas), a documentação `R/data_<nome>.R`, o script
   de preparo de origem, a linha dele na planilha dos 60 e as decisões já
   tomadas na `curadoria_eapadados_revisao.xlsx`. Se a fonte original estiver
   disponível (CSV/XLSX de `data-raw/` ou `fontes_containers_originais/`),
   confira se o objeto do EAPADados corresponde a ela.
3. **Propor** ao professor, de forma curta e em tabelas: nome final do objeto,
   de-para das colunas (com unidade), de-para das categorias e ordem dos níveis,
   colunas a remover e por quê, linhas a filtrar e por quê, a natureza do dado,
   os limites científicos e as dúvidas abertas. Diga o que você recomenda.
4. **Esperar a decisão.** Não aplique nada antes da aprovação. Se o professor
   ajustar, refaça a proposta só no ponto ajustado.
5. **Aplicar:** criar `data-raw/<nome>/` (fonte com SHA256, `preparar.R`,
   `FICHA.md`), rodar o `preparar.R` (que termina com `stopifnot()` nas
   dimensões e nos pontos críticos), gerar `data/<nome>.rda`, escrever
   `R/dados_<nome>.R`, acrescentar a linha no catálogo.
6. **Conferir:** `Rscript -e "roxygen2::roxygenise()"`, `devtools::test()`,
   rodar o `@examples`, e o `R CMD check` com a meta do `ClaRa/CLAUDE.md`
   (qualquer aviso ou nota novos são problema; explique-os).
7. **Registrar:** entrada no `NEWS.md` da ClaRa (sem subir a versão a cada
   conjunto: combine com o professor de quantos em quantos sobe), e o conjunto
   marcado como migrado na ficha. Não mexa nas planilhas do EAPADados: a fila
   de migração fica num arquivo próprio, `ClaRa/data-raw/LEIA-ME.md`, com uma
   tabela "conjunto · situação · data".
8. **Commit na branch `dados`**, um por conjunto, com mensagem
   `dados: Dnn <nome> (de EAPADados::<antigo>)`.
9. **Integrar** seguindo "Seu espaço de trabalho": trazer a `main` atual,
   resolver conflitos só no que é seu, verificar tudo de novo e pedir ao
   professor a integração na `main`. Não faça `push` sem ele pedir.
10. **Parar e relatar** ao professor (o que entrou, o que ficou pendente) antes
    de começar o próximo.

## Ordem sugerida da fila

Comece pelo que já é usado pela ClaRa e pela Trilha, e é simples, para fixar o
molde antes dos casos difíceis:

1. **Piloto:** `isoproteica_bagre` (19 × 2, já enxuto; é a base `real_bagre_racoes`
   e o exemplo `anova_bagres.R`). Com ele se fecham o molde da ficha, do
   `preparar.R`, da documentação, do catálogo e do teste genérico. Revise o
   molde com o professor antes do segundo conjunto.
2. Os outros que já alimentam a ClaRa: `artemia`, `tilapia_microalgas`,
   `morfometria_barbo`, `cangulo_crescimento`, `biometria_caranguejos`.
3. Os do EAPADados marcados "já ajustado" na planilha dos 60 (`darter_ontario`,
   `pinguins`, `salvelino_formalina_remocao`, `lagostas_kelp_sexo`…).
4. Os do EAPADados marcados "precisa de ajuste".
5. Os de literatura e base aberta (`tilapia_sensorial`, `enobieta_baci`,
   `artemia_fitoesterois`, `whitefish_salinidade`, `mesocosmos_secagem`), que
   pedem conferência de licença, unidades e desenho antes da proposta.
6. Os de pacotes R, com a conferência de licença descrita acima.

Os treinos sintéticos autorizados (`treino_coletas`, `treino_desembarque`)
entram como **sintéticos**, com a natureza dita no título. Os seis sintéticos
extras e os de reserva não entram sem decisão explícita.

## O que você não faz

- Não altera nada em `EAPADados/` (nem dados, nem planilhas de curadoria): ele
  continua funcionando até a migração terminar e a Trilha trocar de fonte.
- Não altera a `TRILHA/` nesta fase.
- Não mexe em funções, testes, exemplos ou documentos da ClaRa que não sejam
  os dos dados, e não troca de branch na pasta `ClaRa/` (trabalha em
  `ClaRa-dados/`).
- Não integra nada na `main` sem verificar conflitos e sem o "sim" do professor.
- Não migra dois conjuntos de uma vez, nem aplica proposta não aprovada.
- Não exclui linhas por conveniência, não usa `distinct()` sem saber se as
  repetições são indivíduos, não imputa, não inventa unidade ou referência.
- Não acrescenta dependência ao `DESCRIPTION` da ClaRa além do CRAN, nem pacote
  fora do CRAN em lugar nenhum.
- Não sobe versão, não faz `push` e não envia ao CRAN sem pedido.

## Fase 3 (depois, não agora): a Trilha passa a ler da ClaRa

Para orientar as escolhas desde já, é assim que a integração deve ficar quando
o professor a abrir:

- O seletor "Pacote de dados" da Trilha (`app.R`) lê `clara::catalogo_dados` em
  vez de `data(package = "EAPADados")`. Ele **agrupa os conjuntos por análise**
  (coluna `analises`), e um conjunto aparece em todos os grupos que atende. Cada
  item mostra código, rótulo, tamanho e natureza. A busca encontra por código,
  nome, organismo, análise ou palavra-chave. Na tela de uma análise, o seletor
  já abre filtrado nos conjuntos que servem a ela, com a opção "ver todos":

  ```
  ANOVA de um fator
    D01 · Bagres: rações isoproteicas          19 tanques · real
    D03 · Tilápia: microalgas na dieta         15 tanques · real
  Teste t (duas amostras)
    D02 · Artêmia: duas rações                 ...        · real
  Arrumar (largo → longo)
    D07 · Desembarques por mês (treino)        12 linhas  · sintético
  ```

- O **painel da direita**, ao carregar um conjunto, mostra o cartão dele com a
  lista **"Útil para"**, tirada da coluna `analises`; a `analise_principal`
  vem marcada:

  ```
  D01 · Bagres: rações isoproteicas
  bagre_racao_isoproteica · dado real · 19 tanques, 2 colunas

  Útil para:
    ★ ANOVA de um fator          (melhor exemplo)
    • ANOVA de Welch
    • Kruskal-Wallis
    • Estatística descritiva / boxplot

  Fonte: <autores, ano> · ?clara::bagre_racao_isoproteica
  ```

  Ideia para depois, fora desta etapa: cada item do "Útil para" ser um link
  que abre a análise no menu com o conjunto já carregado.
- A documentação completa continua em `?clara::<nome>`.
- O Projeto R exportado, quando a base vier da ClaRa, começa de
  `library(clara)` e do nome do conjunto, sem precisar do EAPADados; a receita
  de preparo continua visível no `analise.R`.
- O EAPADados fica como reserva até todos os conjuntos usados pela Trilha e pelo
  livro estarem na ClaRa; o que fazer com ele depois é decisão do professor.

## Primeira resposta esperada

Depois de ler o material, responda ao professor com:

1. um resumo de uma tela do que você entendeu (quantos conjuntos, de onde vêm,
   o que já foi decidido);
2. as decisões que precisa dele antes de começar: autorização das pastas
   `data-raw/` e `data/` na ClaRa, acentos nas categorias, cadência de versão;
3. a proposta completa do piloto (`isoproteica_bagre`) no formato do passo 3
   do fluxo.

E pare aí, esperando a resposta.
