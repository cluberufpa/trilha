# Busca 08 — curva de decaimento exponencial ao longo do tempo

Substitui: `paciente_peso` (D52; `MASS::wtloss`, 52 pesagens de um único paciente
em 246 dias, `Days` e `Weight`; GPL; tema clínico, sem contexto aquático).
Escrito em 12/10/2026. Cole o texto abaixo da linha numa IA com busca na web.

> O conjunto de origem ensina o **ajuste de uma curva exponencial assintótica**:
> o peso cai rápido no começo e se achata num patamar. O substituto é uma
> perda (de massa, de umidade, de concentração) medida ao longo do tempo,
> com o mesmo desenho. Este prompt não pede medidas repetidas em vários
> indivíduos (isso é a busca 05); basta uma série ou poucas.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Regressão não linear com decaimento exponencial até um patamar**:
`y = a + b · exp(−k · t)`. O aluno ajusta a curva com `nls()`, lê os três
parâmetros (valor final **a**, amplitude **b**, taxa **k**), calcula a meia-vida
(`ln(2) / k`) e compara com um ajuste linear, que erra o patamar e dá resíduos
em forma de U. O exemplo é uma curva que um aluno entende sem teoria:
**secagem**, **salga**, **jejum**, **perda de calor**, **lixiviação**.

## Estrutura exigida

- **Uma resposta contínua que cai (ou sobe) até um patamar** ao longo do tempo:
  umidade, massa, peso, teor de sal, concentração de um composto, temperatura,
  carga bacteriana em escala log. Em fase de queda **e** no patamar, não só no
  trecho inicial.
- **A variável de tempo** (horas, dias) em uma coluna numérica, com a unidade
  dita.
- **De 25 a 150 medições** em uma série, ou em poucas séries do mesmo desenho
  (por exemplo, 3 a 6 amostras, ou 3 temperaturas), cada uma com 10 ou mais
  pontos.
- **Pontos bem espaçados** no tempo, com ao menos alguns no patamar. Medições
  só nas primeiras horas, sem o platô, não servem.
- **Ruído pequeno e visível**: os pontos devem acompanhar uma curva, com algum
  espalhamento, não ser a própria curva sem erro.
- **Se houver mais de uma série**, o código que as identifica (amostra, filé,
  lote, temperatura, tratamento) e a descrição do que muda entre elas. Séries
  de um mesmo experimento servem para comparar as taxas `k` entre tratamentos,
  um bônus.
- **A unidade amostral dita**: cada série vem de uma amostra, de um peixe, de um
  lote? Se for uma só amostra pesada várias vezes, diga, porque o ruído é de
  medição e não de réplica.
- **Tamanho do arquivo:** de 25 a 500 linhas; no máximo 2.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Engenharia de alimentos e tecnologia do pescado: **secagem** de peixe,
   camarão ou alga (umidade ou massa ao longo do tempo), **salga**, **defumação**,
   **cura**, **congelamento ou descongelamento** (temperatura ao longo do
   tempo), perda de água por gotejamento (*drip loss*), cinética de oxidação;
2. Aquicultura e fisiologia de peixes: **perda de peso no jejum**, depuração de
   um composto, esvaziamento gástrico (conteúdo do estômago ao longo das
   horas), excreção, eliminação de um fármaco (decaimento da concentração no
   plasma);
3. Outras áreas (química, ciência animal, biologia), só se não houver nada nas
   duas primeiras.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data (muitos dados de engenharia de
alimentos), Zenodo, figshare, DataverseNO e outros Dataverse, PANGAEA, OSF, e os
dados suplementares de *Data in Brief* (que publica muitos conjuntos de
secagem), *Scientific Data*, *Journal of Food Engineering*, *Drying Technology*,
*LWT*, *Aquaculture Reports*, *Fishes* (MDPI), *Foods* (MDPI) e PLOS ONE. Termos
úteis: "drying kinetics", "moisture ratio versus time", "drying curve fish",
"salting kinetics", "weight loss during drying", "gastric evacuation rate",
"starvation weight loss", "depuration", "drip loss", "raw data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite uma **curva já ajustada** ou uma tabela com poucos pontos médios
  (por exemplo, 5 tempos com média ± desvio) como se fosse a série bruta.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. O que se mediu (umidade, massa, concentração), em que material (espécie,
   produto) e sob que condições (temperatura, umidade do ar, salmoura).
5. Quantas séries há, quantos pontos por série e quantas linhas no total.
6. A variável de tempo, com a unidade e o intervalo (primeiro e último
   instante).
7. A resposta, com a unidade e o intervalo (valor inicial e valor no patamar).
8. Se há o patamar de verdade (os últimos pontos se estabilizam), descrito em
   poucas palavras.
9. Se há várias séries, o que as diferencia e quantas há de cada tipo.
10. Problemas para limpar (NA, tempo em formato de hora, razão de umidade já
    calculada em vez do dado bruto, várias abas a juntar, rótulos a traduzir).
11. Quais análises ele cobre: ajuste exponencial com `nls()`, comparação com o
    ajuste linear, comparação das taxas entre tratamentos, ou outras.
12. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
