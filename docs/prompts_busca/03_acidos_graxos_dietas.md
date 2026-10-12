# Busca 03 — ácidos graxos de peixes sob diferentes dietas

Substitui: `cabritos_acidos_graxos` (D18; ácidos graxos de cabritos sob quatro
dietas, 32 amostras, licença dos dados não localizada). Escrito em 12/10/2026.
Cole o texto abaixo da linha numa IA com busca na web.

> Não substitui o `doubs_ambiente`: aquele ensina um gradiente ambiental
> contínuo (busca 02). Este ensina grupos definidos pelo experimento, que o
> agrupamento hierárquico tenta reencontrar.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Análise multivariada de perfis de ácidos graxos**: análise de componentes
principais (PCA) e agrupamento hierárquico (HCA). O tema é o efeito da dieta
sobre a composição de ácidos graxos do peixe, como na troca do óleo de peixe
por óleos vegetais na ração.

O exercício central é este: o aluno agrupa as amostras **sem olhar a dieta** e
depois confere se os grupos encontrados correspondem às dietas. Na PCA, a
dieta entra como variável qualitativa suplementar, e os eixos devem ter
leitura biológica (por exemplo, EPA e DHA de um lado; ácido linoleico e oleico
do outro).

## Estrutura exigida

- **Uma linha por amostra** (dados individuais brutos, não médias por dieta,
  não tabelas de resumo com média ± desvio).
- **De 3 a 5 dietas**, com **pelo menos 4 réplicas por dieta**; de preferência
  o mesmo número em todas.
- **A unidade experimental bem descrita.** Se a dieta foi aplicada ao tanque, o
  ideal é uma amostra por tanque (ou um pool de peixes por tanque), com vários
  tanques por dieta. Se houver vários peixes por tanque, a coluna do tanque
  precisa estar nos dados.
- **Perfil em porcentagem do total de ácidos graxos** (ou em mg/g, com a
  unidade dita), com **10 a 20 ácidos graxos ou grupos**: por exemplo 16:0,
  18:0, 18:1n-9, 18:2n-6, 18:3n-3, 20:4n-6, EPA (20:5n-3), DHA (22:6n-3), e os
  somatórios SFA, MUFA, PUFA, n-3, n-6 e a razão n-3/n-6. Se o artigo trouxer
  40 colunas ou mais, tudo bem: diga quais são as principais.
- **Tecido:** filé (músculo), de preferência; fígado ou corpo inteiro também
  servem. Se houver mais de um tecido, diga quais.
- **Bônus (não obrigatório):** o perfil de ácidos graxos das próprias rações
  (para o aluno ver o peixe "copiando" a dieta) e medidas de desempenho por
  réplica (peso final, ganho de peso, conversão alimentar), que permitem uma
  ANOVA no mesmo conjunto.
- **Tamanho:** de 15 a 200 linhas.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Peixes cultivados (tilápia, tambaqui, pirarucu, salmão, truta, bagres,
   robalo, dourada), de preferência espécies cultivadas no Brasil;
2. Camarões e outros crustáceos cultivados, ou moluscos;
3. Ciência animal (aves, suínos, ruminantes), só se não houver nada nas duas
   primeiras.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse (o Instituto de Pesquisa Marinha da Noruega e a Nofima depositam
muitos dados de salmão), PANGAEA, OSF, e os dados suplementares de *Data in
Brief*, *Scientific Data*, *Aquaculture Reports*, *Aquaculture Nutrition*,
*Animal Feed Science and Technology*, *Fishes* (MDPI), *Animals* (MDPI) e PLOS
ONE (que exige dados abertos). Termos úteis: "fish oil replacement",
"vegetable oil", "fatty acid composition", "fillet", "dietary lipid source",
"raw data".

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
4. Espécie, tecido analisado e unidade amostral (o que é uma linha: um peixe,
   um pool, um tanque).
5. As dietas: quantas, o que muda entre elas e quantas réplicas há em cada
   uma; se a dieta foi aplicada ao tanque, quantos tanques por dieta.
6. A lista dos ácidos graxos ou grupos, com a unidade (% do total, mg/g).
7. Se há o perfil das rações e medidas de desempenho.
8. Problemas para limpar (NA, valores abaixo do limite de detecção, colunas
   desnecessárias, formato largo, várias tabelas a juntar).
9. Quais análises ele cobre: PCA, HCA, ANOVA ou MANOVA entre dietas,
   correlação, ou outras.
10. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
