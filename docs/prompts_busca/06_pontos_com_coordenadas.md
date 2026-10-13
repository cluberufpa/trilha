# Busca 06 — pontos de pesca ou coleta com coordenadas

Substitui: `terremotos_fiji` (D47; `datasets::quakes`, 1.000 eventos sísmicos com
latitude, longitude, profundidade, magnitude e estações detectoras; GPL; tema
geofísico, sem contexto pesqueiro). Escrito em 12/10/2026. Cole o texto abaixo
da linha numa IA com busca na web.

> Os mapas do curso são o de **pontos/estações** e o de **bolhas
> proporcionais**. O `quakes` ensina os dois com uma tabela simples: onde (lat,
> long), quanto (magnitude) e a que profundidade. Aqui a tabela é de pontos reais
> de pesca ou de coleta, com uma quantidade medida em cada ponto.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Mapas de pontos e de bolhas proporcionais** com `ggplot` (sem satélite, sem
web): o aluno plota os pontos sobre o contorno do Brasil, ou do estado, ou da
costa, e depois faz o tamanho da bolha seguir uma quantidade. Também precisa
servir à **estatística descritiva** da quantidade e a um **gráfico de dispersão
com profundidade** (o mesmo papel de `depth` e `mag` no conjunto de origem).

O exercício central é este: o aluno olha o mapa, percebe onde as bolhas são
grandes (onde a captura, a abundância ou o parâmetro é maior) e formula uma
hipótese sobre o porquê (profundidade, distância da costa, tipo de fundo,
estação do ano).

## Estrutura exigida

- **Uma linha por ponto**: um lance de pesca, uma estação de coleta, um local de
  amostragem, um registro de ocorrência. Dados individuais, não médias por
  região.
- **Latitude e longitude em graus decimais** (duas colunas numéricas, WGS84,
  longitude negativa no hemisfério oeste). Se estiverem em graus, minutos e
  segundos, diga: eu converto, mas preciso saber.
- **Uma quantidade por ponto, para a bolha**: captura (número de peixes ou
  peso), abundância, biomassa, CPUE, densidade, riqueza de espécies, ou um
  parâmetro de qualidade da água (clorofila, oxigênio, salinidade).
- **Uma segunda variável numérica** que se relacione com a primeira, para o
  gráfico de dispersão e o efeito na bolha: profundidade, distância da costa,
  temperatura, salinidade, esforço.
- **Pelo menos uma variável qualitativa** para colorir os pontos: espécie,
  aparelho de pesca, estação do ano, ano, região, tipo de fundo.
- **Os pontos espalhados** por uma região de tamanho razoável (do estuário a
  uma costa inteira, ou uma bacia), e **não** todos no mesmo lugar: se houver
  só 3 ou 4 localidades repetidas, o mapa fica pobre.
- **Tamanho:** de 100 a 1.000 linhas; no máximo 5.000.
- **Poucos NA** nas coordenadas e na quantidade. Diga quantos há.
- **Sem dados sensíveis**: locais exatos de espécies ameaçadas ou de pesca
  ilegal costumam vir com coordenadas arredondadas ou censuradas pelos autores.
  Diga se é o caso.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.
- Para registros do GBIF, **cada conjunto tem a própria licença** (CC0, CC BY ou
  CC BY-NC). Aceite apenas os CC0 ou CC BY, e informe a licença do conjunto
  específico, não a do portal.

## Ordem de preferência das áreas

1. Pesca e coleta de organismos aquáticos **no Brasil**, de preferência na costa
   Norte (Pará, Amapá, Maranhão), na bacia amazônica ou no Nordeste: lances de
   pesca de arrasto, de camarão ou de pargo; estações de ictiofauna; pontos de
   coleta em estuários, manguezais ou rios;
2. Pesca de pesquisa e monitoramento de órgãos públicos (NOAA, ICMBio, IBAMA,
   institutos de pesca, ICES), que são de domínio público, de qualquer região;
3. Registros de ocorrência de espécies aquáticas (GBIF, OBIS, SiBBr), com a
   quantidade medida por ponto (abundância, tamanho, biomassa) e não só a
   presença.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, PANGAEA, OSF,
DataverseNO e outros Dataverse, o portal de dados abertos do governo brasileiro,
SiBBr, GBIF e OBIS (filtrando pela licença), e os dados suplementares de *Data
in Brief*, *Scientific Data*, *Biodiversity Data Journal*, *Fisheries
Research*, *Aquaculture Reports*, *Fishes* (MDPI), *PLOS ONE* e *Marine
Ecology Progress Series*. Termos úteis: "trawl survey", "station data",
"sampling stations coordinates", "catch per haul", "latitude longitude
abundance", "CPUE by station", "haul-level data", "estuary sampling points",
"biomass by station", "raw data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. O que é uma linha (um lance, uma estação, uma ocorrência) e quantas há.
5. A região coberta: limites de latitude e longitude (mínimo e máximo) e o nome
   do lugar.
6. As colunas de latitude e longitude, com o formato (graus decimais, ou graus,
   minutos e segundos).
7. A quantidade para a bolha, com a unidade e o intervalo dela (mínimo, máximo,
   mediana).
8. A segunda variável numérica e a variável qualitativa para as cores, com os
   níveis e quantas linhas há em cada um.
9. Se as coordenadas foram arredondadas ou censuradas pelos autores.
10. Problemas para limpar (NA, coordenadas trocadas ou fora da região, pontos
    sobre a terra, várias tabelas a juntar, códigos a traduzir).
11. Quais análises ele cobre: mapa de pontos, mapa de bolhas, dispersão,
    estatística descritiva, comparação entre grupos, ou outras.
12. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
