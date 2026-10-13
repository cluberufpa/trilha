# Busca 10 — dados individuais de duas categorias (sexo × espécie, ou parecido)

Substitui: `camaroes_sexo` (D19; 170 camarões, *P. brasiliensis* e
*P. schimitti* × fêmea e macho, tabela 2 × 2 de livro sem referência
localizada, possivelmente reconstruída). Escrito em 12/10/2026. Cole o texto
abaixo da linha numa IA com busca na web.

> O que se quer: os **dados originais, um registro por animal**, de um estudo
> rigoroso. A tabela de contingência é montada **depois**, no preparo (a Trilha
> contagem → tabela cruzada), e só então vem o qui-quadrado. Por isso uma tabela
> de contagens pronta, sem os indivíduos, não serve: o aluno precisa ver o
> caminho da planilha de campo até a tabela.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Teste qui-quadrado de independência** entre duas variáveis categóricas
medidas no mesmo animal, a partir de **dados individuais**: o aluno recebe a
planilha de campo (uma linha por animal), conta, monta a tabela de contingência
e testa. O exemplo que sai é sexo × espécie de camarão ou de peixe, mas serve
qualquer par de categorias de interesse na pesca:

- **sexo × espécie** (razão sexual diferente entre espécies);
- **sexo × local, estação do ano, ou classe de tamanho**;
- **estágio de maturidade × sexo, ou × época**;
- **presença de parasito (sim/não) × sexo ou espécie**;
- **tipo de apetrecho ou de arte de pesca × espécie capturada**.

Segundo uso desejado: o mesmo arquivo permitir o **teste de proporções** (razão
sexual 1:1 numa espécie) e, se houver tamanho individual, uma **comparação do
comprimento entre os grupos**.

## Estrutura exigida

- **Um registro por animal** (ou por captura, se o animal não for identificável),
  com as duas variáveis categóricas em colunas. Não aceito tabela de contagens
  pronta como única forma dos dados.
- **De 100 a 600 animais** no total; no máximo 2.000.
- **Cada categoria com contagem esperada de pelo menos 5** na tabela cruzada
  (para o qui-quadrado valer sem correção). Tabela 2 × 2, 2 × 3 ou 3 × 3.
- **Camarões ou peixes de pesca ou de cultivo**, de preferência espécies
  brasileiras ou do Atlântico Sul. Camarões *Penaeus*/*Litopenaeus*/
  *Xiphopenaeus* e peixes costeiros são bem-vindos.
- **Colunas extras úteis, não obrigatórias:** comprimento, peso, data, local,
  estágio de maturidade.
- **Unidade e método descritos:** como o sexo foi determinado (petasma e télico
  nos camarões, gônada nos peixes) e como o animal foi amostrado.
- **Um estudo rigoroso:** artigo revisado por pares, com os dados brutos
  publicados num repositório e não só uma tabela dentro do texto.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Camarões marinhos e de água doce (pesca ou cultivo), com sexo e espécie ou
   sexo e local;
2. Peixes e outros crustáceos (caranguejos, lagostas, siris), com sexo ou
   maturidade e espécie, local ou época;
3. Outros animais aquáticos (moluscos, quelônios), só se não houver nada nas
   duas primeiras.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse, PANGAEA, OSF, GBIF (registros com sexo), e os dados suplementares de
*Data in Brief*, *Scientific Data*, *Fisheries Research*, *Regional Studies in
Marine Science*, *Journal of Crustacean Biology*, *Fishes* (MDPI), PeerJ e PLOS
ONE. Termos úteis: "sex ratio shrimp raw data", "Penaeus sex species
individual data", "Xiphopenaeus kroyeri sex", "shrimp bycatch sex ratio",
"Dryad shrimp", "maturity stage by sex raw data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite um artigo que traga só a **tabela de contagens** (por exemplo,
  "45 fêmeas e 48 machos"). Sem o registro individual, o candidato falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Espécies, ambiente e como os animais foram amostrados.
5. O que é cada linha, quantas linhas e quais colunas, com unidades.
6. As duas variáveis categóricas candidatas e seus níveis.
7. A **tabela cruzada** dessas duas variáveis (as contagens), e o menor valor
   esperado, se der para calcular.
8. Como o sexo (ou a categoria) foi determinado.
9. Problemas para limpar (NA, rótulos a traduzir, duplicatas, várias tabelas
   a juntar).
10. Quais análises ele cobre: qui-quadrado de independência, teste de
    proporções, comparação de comprimento por grupo, ou outras.
11. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
