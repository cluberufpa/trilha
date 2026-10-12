# Substitutos da literatura para os conjuntos de licença restrita

> **Atualização de 11/10/2026 (noite):** a única fonte de fora é o `FSAdata`,
> lido na hora, sem cópia (`docs/EMENDA_DADOS_DE_PACOTES.md`); os conjuntos do
> FSAdata saem da busca. Do `datasets` não fica nenhum; do `MASS`, só o `crabs`.
>
> **Saem do acervo, sem busca:** `npk`, `oats`, `cars`, `Puromycin`.
>
> **Lidos na hora do `FSAdata`, sem busca:** `DarterOnt`, `ShadCR`,
> `SnapperHG1`, `WhiteGrunt2`, `Cabezon`, `RuffeSLRH92`, `BGHRsample` e
> `BGHRfish` (a seção 1 traz a tabela). `WalleyeErie2` não está entre os oito;
> ver a nota na mesma seção.
>
> **A busca que continua:**
>
> | Conjunto atual | Substituto buscado |
> |---|---|
> | `InsectSprays` | parasitos por peixe, por tratamento |
> | `wtloss` | perda de umidade na secagem ou salga do pescado; busca 08 |
> | `PlantGrowth` | DIC em tanques (talvez dispensável) |
> | `ships` + `Insurance` | um só conjunto de captura com esforço (offset); busca 04 |
> | `quakes` | lances de pesca ou estações de coleta com coordenadas; busca 06 |
> | `Orange` | crescimento de lotes ou peixes marcados ao longo do tempo; busca 05 |
> | `CO2` | respirometria: o mesmo peixe em várias temperaturas; busca 05 |
> | `bacteria` | infecção antes e depois do tratamento, no mesmo animal; busca 07 |
> | `doubs` (ade4) | **já substituído (12/10/2026)** por `lago_vitoria` (D04, Dryad, CC0); busca 02 encerrada |
> | `rec` (astsa) | série mensal de 10 a 30 anos; busca 09 |
> | `crabs` (MASS) | opcional; até lá, lido do MASS na hora |
> | `brine_carbonatos` (Davis, 2002) | **já substituído (12/10/2026)** por `solha_baltico_2008_t4` (D17, Dryad, CC0 1.0; 179 linhas; regressão múltipla com R² = 0,646) |
> | `camaroes_sexo` (D19, tabela de livro sem referência) | **já substituído (12/10/2026)** por `lebistes_parasitos` (D19, Walsman 2022, Dryad, CC0; 4.715 peixes, sexo × parasito); busca 10 encerrada |
> | `isoproteica_bagre`, `cpue_tubarao`, `cangulo_crescimento` | **decididos:** ficam na v1 (livro, dado próprio inédito, livro antigo); fora desta busca |
> | `camarao_ecogreen` (D17, provisório) | **substituído (12/10/2026)** por `solha_baltico_2008_t4`; busca 11 encerrada |
> | `quine` (MASS) | **já substituído** por `molinesias_parasitos` (D50, Dryad, CC0) |
> | origem incerta (seção 2) | resolver na passada 2 |
> | `cabritos_acidos_graxos` (licença não localizada) | ácidos graxos de peixes sob dietas (busca 03) |
>
> As tabelas abaixo ficam como guia da estrutura de cada substituto.

Lista de trabalho de 11/10/2026, para a busca do professor. Não é decisão de
corte: um conjunto só sai da ClaRa quando houver substituto aprovado, ou
quando se decidir pela licença GPL-3 na ClaRa.

## Por que esta lista

A ClaRa é MIT. Os dados que vêm de pacotes GPL (`datasets`, que é parte do R,
`MASS`, `FSAdata`, `astsa`, `ade4`, `QFASA`) não combinam com essa licença
sem cuidado. A saída preferida é trocar cada um por dados abertos da
literatura (CC0 ou CC BY 4.0), que ainda trazem o contexto aplicado. Os que não
tiverem substituto vão para a lista dos difíceis, e então se decide entre
outras áreas do conhecimento ou a GPL-3 na ClaRa.

Não precisam de substituto, porque a licença é compatível: `palmerpenguins`
(CC0), `agridat` (MIT) e as bases de literatura já em CC0 ou CC BY (truta,
tilápia com microalgas, barbo, salvelino, Bagley, camarão vannamei, gammarus,
lagostas).

## Critérios para um substituto

- **Ordem das áreas:** pesca e aquicultura → ciência animal → engenharia de
  alimentos → biologia → química aplicada aos animais.
- **Tamanho:** de preferência entre 40 e 500 linhas; no máximo 2.000.
- **Estrutura:** a mesma do conjunto que sai (o mesmo delineamento, o mesmo
  tipo de resposta, réplicas verdadeiras e não médias). É isso que a coluna
  "o substituto precisa ter" descreve.
- **Dados limpos e bem documentados:** unidades conhecidas, unidade amostral
  clara, artigo ou repositório citável.
- **Licença:** CC0 ou CC BY 4.0. Evitar CC BY-NC (a ClaRa vai ao CRAN) e
  dados "disponíveis a pedido".
- **Onde procurar:** Dryad (quase tudo CC0), Mendeley Data, Zenodo,
  DataverseNO, figshare, PANGAEA, Data in Brief, Scientific Data, Aquaculture
  Reports, e os dados de órgãos públicos (NOAA, IBGE, ICMBio), que são de
  domínio público.

Dificuldade: **fácil** (há muitos estudos assim), **média** (existe, mas pede
busca e conferência), **difícil** (estrutura rara fora da área de origem).

## 1. Conjuntos de pacotes GPL

### Delineamentos e comparações

| Conjunto (origem) | O que ensina | O substituto precisa ter | Ideias de busca | Dificuldade |
|---|---|---|---|---|
| `PlantGrowth` (datasets) | DIC, ANOVA de um fator | 3–5 tratamentos, 5–10 réplicas cada, resposta contínua | ganho de peso por dieta em tanques; talvez dispensável, porque bagre e tilápia já cobrem | fácil |
| `InsectSprays` (datasets) | contagens; Poisson, binomial negativa, Kruskal-Wallis | contagem por unidade, 4–6 tratamentos, ~10 réplicas | parasitos (piolho-do-mar, monogenéticos) por peixe e por tratamento antiparasitário | fácil |
| ~~`npk`~~ (datasets) — **saiu do acervo, sem busca** | fatorial 2³ em blocos | três fatores de dois níveis, em blocos | fatorial de dietas (proteína × lipídio × aditivo) com blocos de tanques ou de tempo | difícil |
| `CO2` (datasets) | medidas repetidas no mesmo indivíduo | indivíduos medidos em 5–7 níveis, com dois fatores entre indivíduos | consumo de oxigênio do mesmo peixe em várias temperaturas; respirometria | média |
| ~~`oats`~~ (MASS) — **saiu do acervo, sem busca** | parcelas subdivididas | fator na parcela (tanque) e fator na subparcela (gaiola ou rede dentro do tanque), em blocos | temperatura no tanque × dieta nas gaiolas; na ciência animal, baia × ração | difícil |
| `bacteria` (MASS) | McNemar, pares binários | presença ou ausência no mesmo animal antes e depois, 40–100 animais | infecção ou parasito antes e depois do tratamento; cura de mastite | média |

### Contagens com exposição e superdispersão

| Conjunto (origem) | O que ensina | O substituto precisa ter | Ideias de busca | Dificuldade |
|---|---|---|---|---|
| `ships` (MASS) | Poisson com offset | contagem e esforço (exposição) por célula, mais dois ou três fatores | captura em número de peixes com horas de pesca ou número de anzóis (CPUE com offset); **um só serve para `ships` e `Insurance`** | média |
| `Insurance` (MASS) | contagem com offset | o mesmo | o mesmo | média |
| `quine` (MASS) | binomial negativa | contagem superdispersa por indivíduo, com 2–4 fatores | abundância de parasitos por peixe (o exemplo clássico de agregação), com sexo, local e classe de tamanho | fácil |

### Curvas e crescimento

| Conjunto (origem) | O que ensina | O substituto precisa ter | Ideias de busca | Dificuldade |
|---|---|---|---|---|
| ~~`cars`~~ (datasets) — **saiu do acervo, sem busca** | modelo quadrático | 40–100 pares com relação curva | talvez dispensável: o cangulo (peso × comprimento) já mostra curvatura | fácil |
| `wtloss` (MASS) | curva exponencial | uma série de 30–60 medidas ao longo do tempo, com decaimento | perda de umidade na secagem ou salga de pescado (engenharia de alimentos); perda de peso no jejum | fácil |
| `Orange` (datasets) | curva logística, dados longitudinais | 4–8 indivíduos ou unidades, cada um medido 6–10 vezes | crescimento de peixes marcados ou de lotes em tanques ao longo de semanas; curvas de crescimento de aves ou suínos | média |
| ~~`Puromycin`~~ (datasets) — **saiu do acervo, sem busca** | saturação, Michaelis-Menten | taxa em 6–10 concentrações, em duas condições | atividade de enzimas digestivas por concentração de substrato; absorção de nutrientes | média |

### Mapas e séries

| Conjunto (origem) | O que ensina | O substituto precisa ter | Ideias de busca | Dificuldade |
|---|---|---|---|---|
| `quakes` (datasets) | mapa de pontos e bolhas | 100–1.000 pontos com latitude, longitude e uma ou duas medidas | estações de coleta ou lances de pesca com captura; registros de ocorrência (GBIF, com CC0 ou CC BY) | média |
| `rec` (astsa) | série mensal, decomposição, ACF | 10–30 anos de dados mensais | desembarques mensais (NOAA, domínio público); temperatura da água mensal | média |

### Já são de pesca e vêm do FSAdata: lidos na hora, sem busca

**Decisão de 11/10/2026** (`docs/EMENDA_DADOS_DE_PACOTES.md`): o `FSAdata` é a
única fonte de fora. A ClaRa guarda só a receita da tradução (MIT) e lê o dado
do pacote na hora em que o aluno pede, sob a licença de lá, sem cópia
redistribuída. Por isso estes oito **não têm substituto a buscar**; as colunas
"O substituto precisaria ter" valem só se um dia a ClaRa deixar de depender do
`FSAdata`.

| Original | Nome na ClaRa | O que ensina | O substituto precisaria ter |
|---|---|---|---|
| `WhiteGrunt2` | `haemulon_crescimento` | tamanho da amostra para a média (piloto) | comprimentos de uma amostra-piloto de uma espécie |
| `Cabezon` | `cabezon_maturidade` | tamanho da amostra para uma proporção | maturidade ou sexo (sim/não) numa amostra-piloto |
| `RuffeSLRH92` | `ruffe_biometria` | ficha de coleta, fator ordenado | registros individuais com estágio de maturidade ordenado |
| `BGHRsample` + `BGHRfish` | `bighill_amostras` + `bighill_peixes` | amostragem por conglomerados, junção de tabelas | tabela de amostras (esforço) e tabela de peixes ligadas por um código (a mais rara de achar) |
| `DarterOnt` | `darter_ontario` | Mann-Whitney por rio | uma medida em dois ou três locais, 15–30 por local |
| `ShadCR` | `idades_savel_repetibilidade` | Wilcoxon pareado, concordância entre leitores | a mesma estrutura lida duas vezes (otólitos, escamas), 40–100 peixes |
| `SnapperHG1` | `snapper_hg` | von Bertalanffy, idade e comprimento | idade e comprimento individuais, 200–1.000 peixes |

**`WalleyeErie2` (`walleye_erie`) fica fora desta decisão.** Não está entre os
oito da emenda. O professor autorizou mantê-lo completo, e a documentação do
`FSAdata` registra que a fonte é o Ohio DNR, com uso não educacional sujeito a
permissão. Há um candidato a substituto em avaliação (Cowichan, Dryad, CC0), em
`ClaRa/data-raw/propostas_nao_integradas/cowichan_amostragem/AVALIACAO.md`.

### Outros pacotes GPL

| Conjunto (origem) | O que ensina | O substituto precisa ter | Dificuldade |
|---|---|---|---|
| `doubs_ambiente` (ade4, GPL ≥ 2, a confirmar) | PCA, gradiente ambiental | 20–60 estações com 8–15 variáveis de qualidade da água | média |
| `crabs_morfometria` (MASS::crabs) | ANCOVA, PCA, amostragem estratificada | 5 medidas morfométricas por animal, duas espécies ou formas, dois sexos, ~200 animais | média |
| `qfasa_presas`, `qfasa_predadores` (QFASA, licença a confirmar) | assinaturas de ácidos graxos | talvez dispensáveis: `peixes_nutricao_portugal` e `cabritos_fa_coltro` já cobrem PCA de perfis | — |

## 2. Fora da GPL, mas com origem a resolver

Não são GPL, mas a licença não está clara. Convém resolver na passada 2:

| Conjunto | Situação |
|---|---|
| `isoproteica_bagre` (**D-001, o piloto**) | tabela de livro comercial (Bhujel, 2011, *Statistics for Aquaculture*, Wiley, tab. 7.4); sem licença aberta |
| `camaroes_sexo` | "dados reais extraídos de livro", sem referência |
| `brine_carbonatos` | livro comercial (Davis, 2002) |
| `cpue_tubarao` | "fonte e créditos a completar" |
| `cangulo_crescimento` | fonte descrita de forma vaga |

Uma tabela pequena de livro é, em geral, fato e não obra, mas a skill de
curadoria pede o status `livro_com_autorizacao_pendente` para esses casos.
Achar substitutos abertos para eles também ajudaria.

## 3. Os difíceis

**Nenhum difícil pendente** (atualização de 12/10/2026). Os três que estavam
aqui foram resolvidos sem busca:

- `npk` (fatorial 2³ em blocos) e `oats` (parcelas subdivididas) saíram do
  acervo, porque a estrutura é rara fora da agronomia;
- `BGHRsample` + `BGHRfish` (conglomerados com duas tabelas ligadas) são lidos
  na hora do `FSAdata`, sem cópia.

A lista cresce conforme a busca não achar substituto para os de dificuldade
média.
