# Busca 13 — quadrado latino com dados reais de pesca, aquicultura ou criação animal

Substitui: `trigo_quadrado_latino` (D60; seis parcelas de trigo, seis operadores,
seis sequências; resposta = diferença entre altura medida e verdadeira). O
conjunto não é do contexto do ecossistema. Escrito em 12/10/2026. Cole o texto
abaixo da linha numa IA com busca na web.

> O que precisa sobrar: um delineamento em **quadrado latino** (cada tratamento
> aparece uma vez em cada linha e uma vez em cada coluna), com resposta contínua,
> para o aluno fazer a ANOVA com três fatores (tratamento, linha, coluna), ver
> que o resíduo tem poucos graus de liberdade e entender por que o quadrado
> controla dois gradientes ao mesmo tempo.

---

Preciso encontrar **um conjunto de dados real e aberto** de um experimento em
**quadrado latino** (ou em quadrados latinos repetidos) para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Delineamento em quadrado latino**: um fator de interesse (tratamento) com *k*
níveis e **dois fatores de bloqueio** (linha e coluna), cada um também com *k*
níveis, de modo que cada tratamento aparece **exatamente uma vez** em cada linha
e **exatamente uma vez** em cada coluna. A análise é a ANOVA com três fatores
(tratamento, linha, coluna), sem interação, com *(k − 1)(k − 2)* graus de
liberdade no resíduo; o aluno compara com a ANOVA de um fator que ignora os
blocos e com o delineamento em blocos casualizados.

Formas aceitas, todas verdadeiras quadrados latinos:

1. **Ensaio de cruzamento (*crossover*)**: os animais (ou tanques, ou lotes) são
   as linhas, os **períodos** são as colunas, e as dietas, rações, aditivos ou
   probióticos são os tratamentos. É a forma mais comum em nutrição animal.
2. **Gradientes espaciais**: tanques, gaiolas ou viveiros dispostos em uma grade
   com dois gradientes (posição na prateleira e distância da janela; fileira e
   profundidade; margem e fundo do viveiro).
3. **Dois gradientes de tempo e espaço**: dia de coleta e posição, lote e
   operador, turno e embarcação.
4. **Análise sensorial**: provadores (linhas), ordem de apresentação ou sessão
   (colunas) e amostras de pescado (tratamentos).
5. **Quadrados latinos repetidos** (dois ou mais quadrados com os mesmos
   tratamentos): aceitos, desde que o conjunto traga o código de cada quadrado.

## Estrutura exigida

- **Tabela tidy, uma linha por observação**, com as colunas de **linha**,
  **coluna**, **tratamento** e a **resposta**. O código do indivíduo ou da
  unidade, quando existir, em outra coluna.
- **Tamanho do quadrado: de 4 × 4 a 8 × 8** (de 16 a 64 observações por
  quadrado). Quadrado 3 × 3 não serve (resíduo com 2 graus de liberdade).
- **Quadrado completo e balanceado**: sem perdas, ou com, no máximo, uma ou duas
  parcelas ausentes (diga quais). Confira que cada tratamento aparece uma vez em
  cada linha e em cada coluna.
- **Resposta contínua**: peso, ganho de peso, taxa de crescimento, conversão
  alimentar, consumo, digestibilidade, teor de proteína ou lipídio, oxigênio,
  nota sensorial (em escala de pelo menos 7 pontos, tratada como numérica).
- **Tratamentos bem descritos** (dietas, doses, temperaturas, tipos de
  aeração), com nomes e unidades.
- **De preferência com um efeito de tratamento visível** (p < 0,05 na ANOVA
  publicada), e com os blocos explicando parte da variação, para o aluno ver o
  ganho do quadrado.
- **Tamanho do arquivo:** de 16 a 400 linhas.

## Licença

- Aceito: **CC0**, **CC BY 4.0**, **CC BY-SA** ou domínio público (órgão
  governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso acadêmico
  apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. **Aquicultura**: peixes, camarões, moluscos ou algas em tanques, gaiolas ou
   viveiros; ensaios de dieta, ração, aditivo, probiótico, densidade de
   estocagem, aeração, temperatura;
2. **Pesca e tecnologia do pescado**: avaliação sensorial de pescado,
   armazenamento, defumação, salga, secagem, congelamento; capturas por
   embarcação, aparelho ou período;
3. **Pequenos animais de criação**: coelhos, aves (frangos, galinhas, codornas),
   cabras e ovelhas em ensaios de cruzamento com dietas ou aditivos
   (digestibilidade, consumo, produção);
4. Ciência animal em geral ou agricultura, só se não houver nada nas áreas
   anteriores. **Evite** cultivos, solos e fitotecnia (é o que estamos
   trocando).

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, PANGAEA, OSF,
Dataverse, repositórios de universidades brasileiras e portuguesas, e os dados
suplementares de *Aquaculture Reports*, *Aquaculture Nutrition*, *Data in
Brief*, *Scientific Data*, *Animals* (MDPI), *Fishes* (MDPI), *Journal of Animal
Science*, *Animal Feed Science and Technology*, *Brazilian Journal of Animal
Science*, *Pesquisa Agropecuária Brasileira*, *Boletim do Instituto de Pesca*,
*Revista Brasileira de Zootecnia* e *Acta Scientiarum*. Termos úteis (em inglês
e em português): "Latin square design" com "tilapia", "shrimp", "fish",
"rabbits", "broilers", "digestibility", "crossover"; "quadrado latino",
"delineamento em quadrado latino" com "peixe", "ração", "digestibilidade",
"tanques"; "Latin square" e "sensory evaluation" com "fish"; "replicated Latin
square"; "raw data" e "supplementary".

Atenção: muitos artigos dizem "quadrado latino" no método e publicam só as
médias por tratamento. **Médias não servem**: preciso das observações, com as
colunas de linha e de coluna.

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença, verificou o balanceamento do quadrado) do que você **supõe**.
- **Verifique o quadrado**: conte quantas vezes cada tratamento aparece em cada
  linha e em cada coluna, e diga se é um quadrado latino de verdade ou um
  delineamento só parecido (por exemplo, blocos casualizados com repetições).
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite tabela de médias, mesmo que o artigo cite o quadrado latino.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Espécie, o ambiente (tanques, gaiolas, viveiros, laboratório, mercado) e o
   que é cada unidade (animal, tanque, provador, sessão).
5. O que são as **linhas**, as **colunas** e os **tratamentos**, com o número
   de níveis de cada um (o tamanho *k* do quadrado) e o número de quadrados.
6. A resposta medida, a unidade e a escala.
7. A **verificação do balanceamento** (cada tratamento uma vez por linha e por
   coluna) e quantas observações há no total e quantas faltam.
8. O que a ANOVA publicada mostra (tratamento, linha, coluna), com os p, para eu
   conferir no R.
9. Problemas para limpar (NA, rótulos a traduzir, códigos que se repetem, várias
   tabelas a juntar).
10. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê. Um
conjunto que mostre claramente o ganho do quadrado sobre blocos casualizados
vale mais, desde que continue simples de explicar.
