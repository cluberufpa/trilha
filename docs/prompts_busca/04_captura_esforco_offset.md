# Busca 04 — captura de peixes com esforço de pesca (offset)

Substitui: `navios_incidentes` (`MASS::ships`) e `seguros_sinistros`
(`MASS::Insurance`), os dois da regressão de Poisson com offset. Um só conjunto
serve para os dois. Escrito em 12/10/2026. Cole o texto abaixo da linha numa IA
com busca na web.

> Os dois conjuntos de origem têm a mesma forma: uma **contagem** por célula
> (incidentes, sinistros), uma **exposição** (meses de serviço, titulares de
> apólice) e dois ou três fatores. Aqui, a contagem é de peixes capturados, a
> exposição é o esforço de pesca e os fatores descrevem onde, quando e com que
> aparelho.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Regressão de contagem com offset de esforço**: Poisson e binomial negativa,
com `log(esforço)` como offset, para modelar a **taxa** de captura (CPUE) e não
a captura bruta. O exercício central é este: o aluno vê que uma estação com mais
horas de pesca captura mais peixes só por ter pescado mais, ajusta o modelo
sem o offset e com ele, e compara os efeitos dos fatores (aparelho, local,
estação do ano) nas duas versões. O conjunto também deve permitir o diagnóstico
de superdispersão, para o aluno chegar à binomial negativa quando a razão
deviance/gl passar de 1.

## Estrutura exigida

- **Uma linha por unidade de esforço**: um lance, uma saída de pesca, uma
  armadilha em um dia, uma estação em um mês, uma combinação de fatores
  (o dado agregado por célula também serve, desde que o esforço de cada célula
  esteja nele).
- **Uma coluna de contagem**: número de indivíduos capturados (inteiros, de
  0 para cima). Não serve peso de captura em kg, a menos que haja também a
  contagem.
- **Uma coluna de esforço (a exposição)**, positiva e na mesma unidade em todas
  as linhas: horas de pesca, número de anzóis, número de lances, metros de rede
  vezes horas, dias de armadilha, área varrida, volume filtrado. A unidade
  precisa estar dita.
- **De 2 a 3 fatores** que descrevam a linha, com poucos níveis cada (de 2 a 6):
  por exemplo aparelho de pesca, local ou estrato, estação do ano ou mês, ano,
  isca, profundidade em classes. É desejável um fator que o aluno consiga
  interpretar biologicamente.
- **O esforço varia de verdade** entre as linhas (por exemplo, de 1 a 20 horas),
  senão o offset não ensina nada.
- **Alguns zeros** são bem-vindos, mas não uma fração enorme: mais de 60% de
  zeros pede outro modelo.
- **Espécie ou grupo único** de preferência (uma contagem por linha). Se o
  arquivo vier com várias espécies em colunas, diga quais têm contagem boa.
- **Tamanho:** de 40 a 500 linhas; no máximo 2.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Pesca (artesanal ou científica) de peixes ou crustáceos: pesca de linha,
   espinhel, rede de emalhar, tarrafa, armadilha, arrasto, censos visuais
   subaquáticos, pesca esportiva; de preferência em águas brasileiras ou de
   espécies conhecidas no Brasil;
2. Pesca de pesquisa e monitoramento de órgãos públicos (NOAA, ICMBio, IBAMA,
   institutos de pesca), que são de domínio público;
3. Outras áreas com contagem e exposição, só se não houver nada nas duas
   primeiras: contagem de parasitos por tempo de exame, ocorrência de doenças
   por animal-dia, ovos por área.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, PANGAEA, OSF,
DataverseNO e outros Dataverse, o portal de dados abertos do governo
brasileiro e os dados de monitoramento da NOAA e do ICES, e os dados
suplementares de *Data in Brief*, *Scientific Data*, *Fisheries Research*,
*Fisheries Management and Ecology*, *Fishes* (MDPI), PLOS ONE e *Marine and
Freshwater Research*. Termos úteis: "catch per unit effort", "CPUE raw data",
"fishing effort", "catch and effort", "longline hooks", "gillnet soak time",
"trap deployments", "set-level data", "haul-level data", "bycatch", "count
data".

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
4. Espécie ou grupo contado, aparelho de pesca e local.
5. O que é uma linha (um lance, uma saída, uma estação-mês, uma célula).
6. A coluna de contagem e a de esforço, com a unidade do esforço e o intervalo
   dele (mínimo, máximo).
7. Os fatores, com os níveis e quantas linhas há em cada um.
8. A proporção de zeros na contagem e uma ideia de superdispersão (média e
   variância da contagem), se der para ver.
9. Problemas para limpar (NA, esforço zerado ou ausente, várias tabelas a
   juntar, formato largo com uma espécie por coluna, códigos a traduzir).
10. Quais análises ele cobre: Poisson com offset, binomial negativa, ANOVA ou
    Kruskal-Wallis sobre a CPUE, mapa de pontos, ou outras.
11. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
