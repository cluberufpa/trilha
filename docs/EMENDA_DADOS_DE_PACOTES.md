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

**Substituídos em 12/10/2026** (ClaRa 0.16.0, `main`; o código D se mantém, o
objeto antigo saiu do pacote e a fonte ficou em `data-raw/substituidos/`):

| Código | Saiu | Entrou | Licença |
|---|---|---|---|
| D12 | `bacterias_tratamento` (`MASS::bacteria`) | `garoupa_pcr_histologia` | CC BY 3.0 AU |
| D18 | `cabritos_acidos_graxos` | `truta_acidos_graxos` | CC BY 4.0 |
| D44 | `plantas_absorcao_co2` (`datasets::CO2`) | `percas_hipoxia` | CC0 |
| D47 | `terremotos_fiji` (`datasets::quakes`) | `pollock_alasca` | CC0 |
| D48 | `laranjeiras_crescimento` (`datasets::Orange`) | `molinesias_crescimento` | CC BY 4.0 |
| D52 | `paciente_peso` (`MASS::wtloss`) | `secagem_bagre` (13/10/2026; antes, `secagem_beterraba_gengibre`, que saiu por ser de vegetais) | CC BY 4.0 |

Entraram também, sem trocar nada: D61 `anchova_norte_california` (série
mensal, no lugar que seria do `astsa::rec`) e D62 `larvas_peixes_captura`
(contagem com esforço, o conjunto que serviria a `ships` e `Insurance`).

**Ainda no pacote, à espera de decisão do professor** (catálogo com 62
conjuntos; com estas dez saídas ficariam 52):

| Nome na ClaRa | Original | Situação |
|---|---|---|
| `navios_incidentes` e `seguros_sinistros` | `MASS::ships`, `MASS::Insurance` | o substituto (D62, larvas) já está no pacote; falta decidir a retirada |
| `peixes_recrutamento` | `astsa::rec` | o substituto (D61, anchova) já está no pacote; falta decidir a retirada |
| `doubs_ambiente` | `ade4::doubs` | **substituído em 12/10/2026** por `lago_vitoria` (D04; Okechi et al. 2025, Dryad, CC0; 217 leituras × 25 colunas; gaiolas de tilápia e controle em 4 locais do Lago Vitória). Na ClaRa falta só decidir o commit; na Trilha, `papeis_sugeridos_pca` troca `riqueza`/`trecho` por `clorofila_a`/`estacao` |
| `brine_carbonatos` (D17) | Davis (2002), livro | **substituído em 12/10/2026** por `solha_baltico_2008_t4` (D17; Dryad, CC0 1.0; 179 linhas de 2008, 4º trimestre; regressão de `log_cpue_g` com seis preditores tem R² = 0,646 e VIF máximo 4,21). O `camarao_ecogreen` provisório fica arquivado por ter só 7 perfis de água distintos. |
| `camaroes_sexo` (D19) | tabela de livro sem referência | busca 10: dados individuais de estudo rigoroso |
| `insetos_inseticidas`, `plantas_crescimento` | `datasets::InsectSprays`, `datasets::PlantGrowth` | provavelmente dispensáveis |
| `puromicina_reacao`, `ervilhas_adubacao`, `carros_frenagem`, `aveia_parcelas` | `datasets::Puromycin`, `npk`, `cars`, `MASS::oats` | saem de vez, sem busca; ainda falta retirar do pacote |

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
