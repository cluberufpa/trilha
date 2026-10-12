# Busca 01 — contagens: parasitos por peixe

Substitui: `InsectSprays` (datasets) e `quine` (MASS). Escrito em 11/10/2026.
Cole o texto abaixo da linha numa IA com busca na web.

> **Ativa de novo (11/10/2026, noite):** buscar só o substituto do
> `InsectSprays` (parasitos por peixe); o do `quine` já foi feito
> (`molinesias_parasitos`, D50). As molinésias não servem para o
> `InsectSprays`: os grupos são observacionais e desbalanceados, e ele pede um
> experimento com tratamentos balanceados.

---

Preciso encontrar **dois conjuntos de dados reais e abertos** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes
de graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados
e redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

Análise de **contagens**: regressão de Poisson, binomial negativa (contagens
superdispersas, com muitos zeros e alguns valores altos) e Kruskal-Wallis
entre grupos. O caso ideal é a **abundância de parasitos por peixe** (ou por
camarão, ostra, mexilhão), que é o exemplo clássico de contagem agregada.

## Estrutura exigida

- **Uma linha por animal** (dados individuais brutos, não médias, não
  prevalência agregada, não tabelas de resumo).
- **Uma contagem inteira** por animal: número de parasitos, de lesões, de
  ovos, de piolhos-do-mar etc.
- **Um fator de grupo com 3 a 6 níveis**, com pelo menos 8 animais por nível:
  tratamento antiparasitário, dieta, local, estação do ano, sistema de
  cultivo.
- **De preferência, mais 2 ou 3 variáveis do animal**: sexo, comprimento ou
  peso, idade, local. Elas permitem a binomial negativa com vários preditores.
- **Bônus (não obrigatório):** uma variável de esforço ou exposição (tempo de
  exposição, área amostrada, peso do hospedeiro) que permita um *offset*.
- **Tamanho:** de preferência entre 40 e 500 linhas; no máximo 2.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, "disponível a pedido", "uso acadêmico
  apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Pesca e aquicultura (peixes, crustáceos, moluscos);
2. Ciência animal (aves, suínos, bovinos, ovinos, caprinos);
3. Biologia (fauna silvestre, ecologia de parasitos).

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse, PANGAEA, OSF, os dados suplementares de *Data in Brief*,
*Scientific Data*, *Aquaculture Reports*, *Parasites & Vectors*,
*International Journal for Parasitology: Parasites and Wildlife*, e PLOS ONE
(que exige dados abertos).

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os
  mesmo assim e diga qual critério falha.

## O que entregar

Para **cada um dos dois candidatos** (pode trazer até quatro, se houver
empate):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Unidade amostral (o que é uma linha) e número de linhas e colunas.
5. A lista de colunas, com a unidade de cada uma, quando houver.
6. O fator de grupo: os níveis e quantos animais há em cada um.
7. A contagem: valor mínimo, máximo, proporção de zeros, e se a variância
   parece bem maior que a média.
8. Problemas para limpar (NA, colunas desnecessárias, códigos sem legenda).
9. Quais análises ele cobre: Poisson, binomial negativa, Kruskal-Wallis,
   *offset*, ou outras (ANOVA, regressão, qui-quadrado), se servir também.
10. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
