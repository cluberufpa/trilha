# Busca 05 — mesmo indivíduo medido várias vezes (crescimento e resposta)

Substitui: `plantas_absorcao_co2` (D44; `datasets::CO2`, 12 plantas, 7
concentrações por planta, 84 linhas) e `laranjeiras_crescimento` (D48;
`datasets::Orange`, 5 árvores, 7 idades, 35 linhas). Escrito em 12/10/2026. Cole
o texto abaixo da linha numa IA com busca na web.

> Os dois conjuntos de origem têm a mesma forma: poucos **indivíduos**, cada um
> medido **várias vezes** ao longo de uma variável contínua (tempo no `Orange`,
> concentração no `CO2`), com uma resposta que **curva e satura**. Um único
> conjunto de peixes marcados, ou de lotes em tanques, medidos ao longo do
> tempo pode substituir os dois. Se não houver um que sirva aos dois, aceito um
> candidato para cada, e quero saber a qual deles cada um serve.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

Três coisas, em ordem de importância. Basta que o conjunto cubra a primeira e
mais uma.

1. **Curva de crescimento ou de resposta que satura** (logística, von
   Bertalanffy, Gompertz, ou saturação do tipo Michaelis-Menten): o aluno ajusta
   uma curva não linear a cada indivíduo e à média, e lê os parâmetros
   (assíntota, taxa, ponto de inflexão).
2. **Medidas repetidas**: as linhas do mesmo indivíduo **não são independentes**.
   O aluno vê o erro de tratar 84 medições como 84 réplicas e passa a usar o
   indivíduo como unidade (modelo misto, ou ANOVA de medidas repetidas, ou o
   resumo por indivíduo).
3. **Comparação entre grupos de indivíduos**: dois fatores entre indivíduos (por
   exemplo, dieta × temperatura, ou linhagem × tratamento) e o efeito deles na
   curva ou na resposta.

## Estrutura exigida

- **Formato longo**: uma linha por medição, com o código do indivíduo (ou do
  tanque, ou do lote) em uma coluna, a variável de medição (tempo, idade,
  temperatura, concentração) em outra e a resposta numa terceira.
- **De 6 a 40 indivíduos** (ou tanques, ou lotes), com **pelo menos 5 medições
  por indivíduo**, de preferência de 6 a 12, e **o mesmo número de medições em
  todos** (ou quase). Menos de 4 indivíduos por grupo não deixa comparar grupos.
- **A unidade do indivíduo bem descrita**: peixe marcado (PIT tag, anel, marca),
  tanque, gaiola, lote ou animal identificado. Se for o tanque, diga quantos
  peixes ele tem e se a resposta é a média do tanque ou um peixe.
- **Resposta contínua**: comprimento, peso, taxa metabólica, consumo de
  oxigênio, taxa de ingestão, glicemia, atividade enzimática, concentração de
  alguma substância no sangue. Não serve contagem nem proporção.
- **A variável de medição com pontos bem espaçados**: tempo (dias, semanas,
  meses, idade em anos) ou nível de um fator contínuo (temperatura, salinidade,
  concentração de substrato), com **6 a 12 níveis**, cobrindo o trecho em que a
  curva sobe **e** o patamar em que ela se achata.
- **Um ou dois fatores entre indivíduos** (opcional para a comparação de grupos):
  dieta, temperatura, linhagem, sexo, tratamento, com 2 a 4 níveis cada.
- **Poucos NA.** Perdas por morte ou perda da marca são normais, mas diga
  quantas e se o conjunto ficou desbalanceado.
- **Tamanho:** de 30 a 500 linhas; no máximo 2.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Peixes e crustáceos cultivados ou de laboratório, com crescimento ao longo do
   tempo (tilápia, tambaqui, pirarucu, salmão, truta, bagres, camarão, zebrafish)
   ou resposta fisiológica em vários níveis de um fator (respirometria, consumo
   de oxigênio em várias temperaturas, consumo alimentar em várias densidades);
2. Peixes marcados e recapturados em ambiente natural (crescimento individual),
   moluscos e outros organismos aquáticos;
3. Ciência animal (aves, suínos, ruminantes: curvas de crescimento individuais) e
   fisiologia animal (enzimas digestivas, absorção por substrato), só se não
   houver nada nas duas primeiras.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse, PANGAEA, OSF, e os dados suplementares de *Data in Brief*,
*Scientific Data*, *Aquaculture Reports*, *Journal of Experimental Biology*
(muitos depositam no Dryad), *Journal of Fish Biology*, *Conservation
Physiology*, *Fishes* (MDPI), *Animals* (MDPI) e PLOS ONE. Termos úteis: "growth
trajectories", "individual growth", "repeated measures", "longitudinal growth
data", "tagged fish growth", "oxygen consumption temperature", "metabolic rate
across temperatures", "thermal performance curve", "raw data", "von Bertalanffy
individual".

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
4. Espécie, o que é o indivíduo (peixe marcado, tanque, lote) e o ambiente.
5. Quantos indivíduos há, quantas medições por indivíduo (mínimo e máximo) e
   quantas linhas no total.
6. A variável de medição (tempo, temperatura, concentração), com a unidade e os
   valores que ela assume.
7. A resposta, com a unidade e o intervalo dela.
8. Os fatores entre indivíduos, com os níveis e quantos indivíduos há em cada
   combinação.
9. Se a curva realmente satura nos dados (descreva o que se vê em uma figura do
   artigo ou na tabela: patamar, assíntota).
10. Problemas para limpar (NA, perdas de indivíduos, formato largo com uma coluna
    por data, várias tabelas a juntar, códigos a traduzir).
11. Quais análises ele cobre: curva não linear por indivíduo, modelo misto,
    ANOVA de medidas repetidas, regressão por grupo, ou outras.
12. A qual dos dois conjuntos de origem ele serve: **crescimento ao longo do
    tempo** (como `Orange`), **resposta em níveis de um fator** (como `CO2`),
    ou os dois.
13. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar. Se nenhum servir aos dois, recomende o melhor para cada um.
