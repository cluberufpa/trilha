# Emenda — dados de pacotes R lidos na hora, não copiados

> Decisão do professor de 11/10/2026 (noite). Emenda a seção "Dados que vêm de
> outros pacotes R" do `PROMPT_MIGRACAO_DADOS_CLARA.md` e vale para a sessão dos
> dados da ClaRa e, depois, para a sessão da Trilha.

## O que muda

A ClaRa é MIT e, na passada 1, recebeu cópias traduzidas de conjuntos de
pacotes GPL. Daqui em diante, **só um pacote de fora fornece dados: o
`FSAdata`**. A ClaRa guarda só a **receita da tradução** (o de-para de colunas e
categorias, que é código próprio e MIT) e lê o dado do `FSAdata` na hora em que
o aluno pede. O dado continua no pacote de origem, sob a licença de lá, e o
aluno recebe o objeto em português.

| Pacote | Decisão |
|---|---|
| `FSAdata` | fonte de dados de pesca, lida na hora; `Suggests` na ClaRa, `Imports` na Trilha (o `instalar_trilha.R` já deixa instalado) |
| `datasets` | **nenhum conjunto**: os oito saem (uns vão para a busca, outros saem de vez) |
| `MASS` | **só o `crabs`**, até haver substituto; lido na hora, como o `FSAdata`, porque o `MASS` já vem com o R (`Suggests` na ClaRa) |
| `ade4`, `astsa` | não entram; `doubs` e `rec` vão para a busca |
| `QFASA`, `agridat` | são MIT; os conjuntos seguem como cópia, sem mudança |

## O FSAdata

Os oito conjuntos já migrados passam a ser lidos na hora:

| Original | Nome na ClaRa |
|---|---|
| `DarterOnt` | `darter_ontario` |
| `ShadCR` | `idades_savel_repetibilidade` |
| `SnapperHG1` | `snapper_hg` |
| `WhiteGrunt2` | `haemulon_crescimento` |
| `Cabezon` | `cabezon_maturidade` |
| `RuffeSLRH92` | `ruffe_biometria` |
| `BGHRsample` | `bighill_amostras` |
| `BGHRfish` | `bighill_peixes` |

**Só os conjuntos que o professor pedir** (decisão de 11/10/2026): o seletor
mostra apenas os conjuntos do `FSAdata` que estão no catálogo, todos
traduzidos. Um conjunto novo do pacote entra pelo fluxo de sempre (proposta,
aprovação, ficha, receita de tradução) e só então aparece; os demais
conjuntos do pacote não são oferecidos.

## O MASS: só o crabs

| Original | Nome na ClaRa | Situação |
|---|---|---|
| `crabs` | `crabs_morfometria` | lido na hora até chegar um substituto aberto |

## Os que saem da ClaRa

**Saem de vez (sem busca):**

| Nome na ClaRa | Original | Motivo |
|---|---|---|
| `ervilhas_adubacao` | `datasets::npk` | estrutura rara fora da agronomia |
| `aveia_parcelas` | `MASS::oats` | estrutura rara fora da agronomia |
| `carros_frenagem` | `datasets::cars` | o cangulo já mostra curvatura |
| `puromicina_reacao` | `datasets::Puromycin` | fora do contexto; não será substituído |

**Saem quando o substituto for aprovado** (busca do professor, ver
`prompts_busca/SUBSTITUTOS_LITERATURA.md`):

| Nome na ClaRa | Original | Substituto buscado |
|---|---|---|
| `insetos_inseticidas` | `datasets::InsectSprays` | parasitos por peixe, por tratamento |
| `paciente_peso` | `MASS::wtloss` | perda de umidade na secagem ou salga do pescado |
| `plantas_crescimento` | `datasets::PlantGrowth` | DIC em tanques (talvez dispensável: bagre e tilápia já cobrem) |
| `navios_incidentes` e `seguros_sinistros` | `MASS::ships`, `MASS::Insurance` | um só conjunto de captura com esforço (offset) |
| `terremotos_fiji` | `datasets::quakes` | lances de pesca ou estações de coleta com coordenadas |
| `laranjeiras_crescimento` | `datasets::Orange` | crescimento de lotes ou peixes marcados ao longo do tempo |
| `plantas_absorcao_co2` | `datasets::CO2` | respirometria: o mesmo peixe em várias temperaturas |
| `bacterias_tratamento` | `MASS::bacteria` | infecção antes e depois do tratamento, no mesmo animal |
| `doubs_ambiente` | `ade4::doubs` | estações de rio com variáveis de qualidade da água |
| `peixes_recrutamento` | `astsa::rec` | série mensal de 10 a 30 anos |

**Já substituído:** `escolares_ausencias` (`MASS::quine`) saiu da ClaRa em
11/10/2026. O código D50 passou a ser `molinesias_parasitos` (molinésias e
carga de parasitos; Sheehy e colaboradores, Dryad, CC0), publicado na `main`
da ClaRa.

Até o substituto chegar, esses ficam como estão; nenhum ganha leitura na hora,
porque `datasets`, `ade4` e `astsa` não serão fontes.

## Como deve ficar na ClaRa (proposta para a sessão dos dados)

- **Uma porta de entrada para todos os conjuntos**, por exemplo
  `carregar_dados("snapper_hg")` (nome a confirmar com o professor). Para os
  conjuntos copiados, ela devolve o `.rda`; para os do `FSAdata` e o `crabs`, confere o pacote com
  `requireNamespace()`, lê o objeto original e aplica a receita. Se o pacote
  faltar, a mensagem diz em português como instalá-lo
  (`install.packages("FSAdata")`).
- **Receita em código, visível:** um arquivo `R/dados_pacotes.R` com um
  registro (pacote, objeto, função que traduz). A tradução é a mesma que a
  passada 1 já fez no `preparar.R` de cada conjunto; só passa a rodar na hora.
- **`catalogo_dados`** continua com os 60 (ou menos, conforme as saídas) e
  ganha a coluna `fonte_dados`: `"clara"`, `"FSAdata"` ou `"MASS"`. É ela que a Trilha usa para o seletor.
- **`data/`** perde os `.rda` do `FSAdata` e do `crabs` só depois que a leitura na hora estiver
  testada.
- **A documentação de cada conjunto continua** (`?snapper_hg` ou equivalente),
  com "Adaptado de `FSAdata::SnapperHG1`", versão, autores, referência
  original, licença do pacote de origem e o de-para.
- **Teste:** para cada conjunto lido na hora, o objeto traduzido tem as linhas, as colunas
  e os níveis registrados na ficha. É o teste que avisa se uma versão nova do
  pacote mudar o conjunto. Com `Suggests`, o teste usa `skip_if_not_installed()`.
- **A fonte congelada** (`data-raw/<nome>/fonte/*.rds`) deixa de ser necessária
  para os lidos na hora e não deve ir para o repositório, porque seria uma cópia.

## Como deve ficar na Trilha (fase seguinte, sessão da Trilha)

- O seletor de dados de exemplo fica em dois passos (decisão do professor,
  12/10/2026):
  1. **Origem**, com duas escolhas: **ClaRa** ou **Outros pacotes**.
  2. **Conjunto**: só os conjuntos do catálogo daquela origem. Em "Outros
     pacotes", cada item aparece como `nome_do_dado (Pacote)`, por exemplo
     `snapper_hg (FSAdata)` e `crabs_morfometria (MASS)`.
- O Projeto R exportado escreve a mesma chamada que a tela usa
  (`carregar_dados("snapper_hg")`), e o README diz quando o projeto precisa do
  `FSAdata`. O carimbo com `stopifnot()` nas linhas segue valendo.
- `FSAdata` entra em `Imports` da Trilha.
