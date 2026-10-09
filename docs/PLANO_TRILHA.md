# Plano: de CatalyseR para trilha

**Decisão do professor (8 de outubro de 2026):** a IDE passa a se chamar
**Trilha**, e o pacote R, **`trilha`** (minúsculo, como se digita em
`library(trilha)`). O nome diz o que a ferramenta é: uma trilha de análise,
da pergunta ao relatório, com o jeito de um estúdio de pesquisa, análise e
escrita, sem precisar de "Studio" no nome. Slogan: *Da pergunta ao
relatório, uma só trilha de análise.* Logo e cores: ver
[identidade_visual/Trilha/LEIA-ME.md](identidade_visual/Trilha/LEIA-ME.md).

**Repositório:** desde 9 de outubro de 2026, a Trilha vive em
`cluberufpa/trilha` (público), na conta do Clube do Código no GitHub. O
`astuciasnor/catalyser` continua com o pacote `catalyser` dos alunos.

## Andamento

- **Etapa 1 feita** (branch `trilha`, 8/10/2026): o pacote se chama `trilha`
  (versão 0.2.0), com `trilha.Rproj`, `instalar_trilha.R` e todas as
  chamadas `catalyser::`, `library(catalyser)` e `asNamespace("catalyser")`
  trocadas, inclusive nos projetos que o exportador gera. As funções seguem
  com o prefixo `catalyser_` (etapa 2), e a interface ainda diz "CatalyseR"
  (etapa 3). O `instalar_catalyser.R` virou uma linha que chama o
  `instalar_trilha.R`, para o endereço antigo continuar funcionando. A suíte
  passou em 34 de 38 arquivos; os 4 que falham (`test_descrevendo_interface`,
  `test_estados_execucao`, `test_logisticas_separadas`, `test_anova_mista`)
  já falhavam antes do renome.

## Tamanho do trabalho (levantamento de 8/10/2026)

- cerca de 410 menções a "CatalyseR" (interface, documentos, comentários) e
  230 a "catalyser" (pacote, chamadas `catalyser::`, arquivos);
- umas 30 funções exportadas com o prefixo `catalyser_` (`catalyser_num`,
  `catalyser_executar`, `catalyser_conferir_base`, `catalyser_letras_tukey`,
  `catalyser_ou`...), com as páginas de `man/` e o `NAMESPACE`;
- arquivos com o nome: `catalyser.Rproj`, `instalar_catalyser.R`,
  `inst/app/tests/carregar_catalyser.R`, a skill
  `skills/refinar-analises-catalyser/`;
- fora deste repositório: o `CLAUDE.md` do ecossistema, o livro (`eapa/`), o
  EAPACadernos, a ClaRa (`CLAUDE.md`, README) e o script de apoio
  `APOIO/instalacoes_catalyser.R`.

## Etapas

Cada etapa é um commit, numa branch própria (`trilha`), com os testes de
`inst/app/tests/` passando no fim de cada uma.

1. **Pacote.** `DESCRIPTION` (`Package: trilha`, `Title`, `Description`),
   `catalyser.Rproj` → `trilha.Rproj`, `instalar_catalyser.R` →
   `instalar_trilha.R` (e a função `instalar_trilha()`), `run.R`.
2. **Funções.** Prefixo `catalyser_` → `trilha_` em `R/`, `NAMESPACE`
   regenerado pelo roxygen, `man/` refeito. `catalyser::run_app()` →
   `trilha::run_app()`.
3. **Interface.** Título, logo (hexágono com o R), favicon e textos da tela:
   "CatalyseR" → "Trilha".
4. **Exportador e moldes.** As chamadas `catalyser::` dos projetos gerados
   pelo molde antigo (`anova_projeto`, `teste_t_*`, `regressao_linear`), os
   README gerados ("Este Projeto R foi gerado pela Trilha") e o
   `exportacao_comunicacao.R`. A rota ClaRa não chama o pacote (é só CRAN):
   muda apenas o texto.
5. **Testes.** `carregar_catalyser.R` → `carregar_trilha.R`, e as conferências
   que procuram "catalyser" nos projetos gerados.
6. **Documentos deste repositório.** README, contratos, `ARQUITETURA.md`,
   `AGENTS.md`, `docs/` e a skill. O que está em `docs/historico/` fica como
   está: é registro do passado.
7. **Ecossistema.** `CLAUDE.md` do ecossistema, livro, EAPACadernos, ClaRa e
   `APOIO/`. No livro, "do mouse ao código" continua; troca só o nome da
   ferramenta.
8. **Repositório (depois).** Transferir para a conta do Clube do Código pelo
   próprio GitHub (Settings → Transfer), que mantém o histórico e redireciona
   o endereço antigo por um tempo. Em seguida: `git remote set-url`, o
   endereço do `install_github()` no instalador e no README, e renomear o
   repositório para `trilha`.

## Cuidados

- **Projetos já exportados.** Os projetos do molde antigo chamam
  `catalyser::catalyser_letras_tukey()` e parentes. Depois do renome, eles só
  rodam enquanto o pacote `catalyser` antigo continuar instalado na máquina
  do aluno. Opções: (a) avisar no README do instalador que projetos antigos
  pedem o `catalyser` antigo; (b) publicar uma última versão do `catalyser`
  que só carrega a `trilha` e reexporta as funções com o nome antigo. A (a) é
  a mais simples; a (b) só vale a pena se houver muitos projetos antigos em
  uso. Os projetos da rota ClaRa não têm esse problema.
- **A pasta local** `D:\Claude\EAPA-Ecossistema\CATALYSER` pode ser renomeada
  para `TRILHA` na etapa 1. A memória do Claude Code fica ligada ao caminho
  da pasta: depois da troca, ela precisa ser copiada para o caminho novo.
- **Um nome só nos textos:** "Trilha" na prosa e na interface; `trilha` só
  no código. Não usar "TrilhaR", "Trilha do R" nem "Trilha Studio".

## A ClaRa na Trilha

A ClaRa **já vem junto** com a Trilha: a cópia em `inst/app/templates/clara/`
é instalada com o pacote, e o exportador a põe em `R/clara/` de cada projeto,
que a carrega com `source()`. Assim o projeto do aluno roda só com o CRAN.

Transformar a ClaRa em pacote (`library(clara)`) não é preciso para isso, e
a regra 4 do `ClaRa/CLAUDE.md` pede para não empacotar por antecipação. O
pacote ganharia sentido para quem usa a ClaRa **fora** dos projetos
exportados (roteiros do livro, EAPACadernos). Mesmo assim, há dois
obstáculos: o repositório da ClaRa é privado, e o projeto exportado deixaria
de ser só CRAN. Se isso acontecer, a Trilha declara a ClaRa como dependência,
mas o projeto exportado continua levando a cópia.

O risco real hoje é a cópia de `templates/clara/` ficar atrasada em relação
ao repositório da ClaRa. Para isso, um teste pequeno: comparar a
`versao_clara` da cópia com a do repositório irmão (`../ClaRa/R/clara.R`),
quando ele existir na máquina, e avisar se as versões forem diferentes.
