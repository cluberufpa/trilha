# Busca 09 — série mensal de 10 a 30 anos

Substitui: `peixes_recrutamento` (D59; `astsa::rec`, índice mensal de
recrutamento, 453 meses, de janeiro de 1950 a setembro de 1987; GPL). Escrito em
12/10/2026. Cole o texto abaixo da linha numa IA com busca na web.

> O conjunto de origem ensina **séries temporais**: tendência, sazonalidade,
> decomposição e autocorrelação. O substituto é uma série mensal contínua de
> pesca ou ambiente, com a mesma finalidade. Os desembarques e capturas dos
> órgãos públicos (NOAA, ICMBio, institutos de pesca) são de domínio público e
> são o primeiro lugar a olhar.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Análise de séries temporais mensais**: o aluno desenha a série, separa
tendência, ciclo sazonal e resíduo (decomposição), vê a autocorrelação (ACF e
PACF) e percebe que valores de meses vizinhos **não são independentes**, o que
quebra os testes comuns. Também precisa servir à **regressão com tendência
linear** e a uma previsão simples para os próximos meses.

O exercício central é este: o aluno olha o gráfico, enxerga o ciclo anual (a
safra, o defeso, a estação das chuvas), mede a tendência (a captura caiu ou
subiu em 20 anos?) e entende por que a ACF dos resíduos não deve ficar de fora.

## Estrutura exigida

- **Uma data mensal e um valor por mês**, numa tabela de duas colunas (ou mais,
  desde que uma seja a série principal): `ano`/`mes` ou data no formato
  `AAAA-MM`. Um valor por mês, sem meses repetidos.
- **De 120 a 480 meses** (10 a 40 anos), **sem buracos** ou com poucos buracos,
  que sejam **contáveis**: diga quantos meses faltam e onde.
- **O ciclo sazonal visível**: a série oscila de forma parecida a cada ano
  (picos de safra, defeso, estação chuvosa). Séries sem nenhuma sazonalidade
  servem menos.
- **Uma tendência ou ruptura** (opcional, mas desejável): a série sobe, desce ou
  muda de nível em algum ponto, para o aluno enxergar o que é tendência.
- **Valor contínuo e positivo**: desembarque em toneladas, CPUE, captura total,
  preço médio do pescado, temperatura da água, clorofila, vazão do rio, nível
  de oxigênio. Contagem pequena (poucos peixes por mês) serve pouco.
- **A unidade e a origem dos números ditas**: toneladas desembarcadas num porto,
  CPUE de uma frota, média mensal de uma estação de monitoramento. Diga se o
  valor é bruto ou um índice.
- **Uma segunda série do mesmo período** (opcional): temperatura da água,
  chuva, esforço, preço, índice climático. Permite uma correlação cruzada ou uma
  regressão com defasagem. Não é obrigatória.
- **Tamanho:** de 120 a 480 linhas; no máximo 1.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.
- Dados de órgãos governamentais (NOAA, ICMBio, IBGE, ANA, INPE) costumam ser
  públicos; mesmo assim, informe a página e a frase de uso.

## Ordem de preferência das áreas

1. **Desembarques, capturas ou CPUE mensais no Brasil**, de preferência da costa
   Norte (Pará, Amapá, Maranhão) ou da bacia amazônica (pirarucu, tambaqui,
   piramutaba, camarão, caranguejo-uçá, lagosta, sardinha): estatística pesqueira
   de um porto, de uma frota ou de uma colônia de pescadores;
2. **Desembarques e capturas mensais de outros países**, de órgãos públicos
   (NOAA Fisheries, ICES, FAO, institutos de pesca europeus e latino-americanos),
   com uma espécie ou frota bem descrita;
3. **Séries ambientais mensais** ligadas à pesca ou à aquicultura:
   temperatura da água, clorofila-a, salinidade, vazão e nível de rios,
   chuva, índices climáticos (ENSO, SOI), com fonte pública (ANA, INPE, NOAA,
   Copernicus).

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Os portais de estatística pesqueira dos órgãos públicos (NOAA Fisheries
Commercial Landings, ICES, FAO FishStat, o Ministério da Pesca e Aquicultura, o
Sistema de Informações da Pesca, o Boletim Estatístico, institutos estaduais),
o portal de dados abertos do governo brasileiro, ANA (Hidroweb), INPE, Dryad,
Zenodo, figshare, PANGAEA, Mendeley Data, e os dados suplementares de *Data in
Brief* e *Scientific Data*. Termos úteis: "monthly landings", "monthly catch",
"CPUE monthly time series", "commercial landings by month", "desembarque mensal",
"estatística pesqueira mensal", "série temporal", "monthly sea surface
temperature station", "raw data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite uma série **anual** ou **trimestral** como se fosse mensal, nem um
  gráfico sem a tabela por trás.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores ou órgão, ano, DOI ou link do repositório e o
   artigo ou relatório associado.
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. O que a série mede (espécie, porto, frota, ou variável ambiental), em que
   unidade, e se é valor bruto ou índice.
5. O primeiro e o último mês, quantos meses há e quantos faltam, com os
   intervalos que faltam.
6. A média, o mínimo e o máximo da série, e uma descrição curta do que se vê: há
   ciclo anual? tendência? ruptura?
7. Se há uma segunda série do mesmo período, qual é.
8. Problemas para limpar (NA, formato largo com um mês por coluna, anos em
   linhas e meses em colunas, valores em texto com vírgula, mudança de
   metodologia no meio da série).
9. Quais análises ele cobre: decomposição, ACF e PACF, regressão com
   tendência, previsão, correlação cruzada, ou outras.
10. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
