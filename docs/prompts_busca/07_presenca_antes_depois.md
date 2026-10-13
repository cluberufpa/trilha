# Busca 07 — presença ou ausência no mesmo animal, antes e depois

Substitui: `bacterias_tratamento` (D12; `MASS::bacteria`, 50 crianças, presença
de *H. influenzae* em até 5 semanas, 220 observações, medicamento × placebo;
GPL). Escrito em 12/10/2026. Cole o texto abaixo da linha numa IA com busca na
web.

> No conjunto de origem, o McNemar usa só as semanas 0 e 11: 44 pares completos
> de crianças, cada uma com uma resposta binária antes e outra depois. É essa
> estrutura que se procura, trocando a criança por um peixe, um lote ou um
> animal de criação.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Teste de McNemar para pares binários**: o mesmo animal é avaliado duas vezes,
antes e depois de uma intervenção, e a resposta é **sim ou não** (infectado ou
não, parasitado ou não, com lesão ou não, maduro ou não, positivo ou negativo
no exame). O aluno monta a tabela 2 × 2 de pares, vê que só os pares que
**mudaram** contam (curados e infectados de novo) e compara com o qui-quadrado
de independência, que ignoraria o pareamento.

Como segundo uso, o conjunto deve permitir **preparar dados pareados** (passar
do formato longo ao largo, uma linha por animal, e descartar quem perdeu uma das
medidas) e, se tiver um grupo-controle, uma **regressão logística** com a
semana e o tratamento.

## Estrutura exigida

- **O mesmo indivíduo avaliado antes e depois**, com um código que o identifique:
  peixe marcado, tanque, gaiola, viveiro, lote ou animal individual de criação.
  Se a unidade for o tanque, diga quantos peixes ele tem e se a resposta é do
  tanque ou de cada peixe.
- **Resposta binária** (sim/não, presente/ausente, 0/1), em **dois momentos
  pelo menos**. Mais momentos servem, desde que dois deles possam ser pareados.
- **De 30 a 300 pares** (animais ou unidades). Menos de 30 deixa o teste sem
  graça; mais de 1.000 é desnecessário.
- **Os dois tipos de discordância existem**: há animais que passaram de sim para
  não **e** animais que passaram de não para sim, mesmo que em números
  diferentes. Um conjunto em que ninguém muda no sentido oposto também serve,
  mas diga isso.
- **A intervenção bem descrita**: tratamento antiparasitário, antibiótico,
  vacina, probiótico, mudança de dieta, transferência de ambiente, depuração,
  refrigeração (para pescado, antes e depois do armazenamento).
- **De preferência, um grupo-controle** (placebo, sem tratamento) ao lado do
  tratado, com os mesmos dois momentos, para comparar quantos mudaram nos dois.
- **Formato longo ou largo**, tanto faz; informe qual.
- **Poucas perdas.** Animais que morreram, foram descartados ou não foram
  reavaliados ficam sem par: diga quantos são.
- **Tamanho do arquivo:** de 60 a 600 linhas; no máximo 2.000.

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Peixes e crustáceos cultivados ou de laboratório: infecção ou infestação por
   parasito (monogenéticos, piolho-do-mar, protozoários), bactéria ou vírus,
   antes e depois de um tratamento (banho de sal, formalina, peróxido,
   antibiótico, vacina), ou presença de lesão, de ovócitos, de maturidade;
2. Peixes de ambiente natural marcados e reavaliados, ou pescado (presença de
   bactéria, de histamina acima do limite, de parasito em dois momentos do
   armazenamento);
3. Ciência animal (mastite em vacas ou cabras, metrite, claudicação, coccidiose
   em aves), só se não houver nada nas duas primeiras.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse, PANGAEA, OSF, e os dados suplementares de *Data in Brief*,
*Scientific Data*, *Aquaculture Reports*, *Journal of Fish Diseases*, *Diseases
of Aquatic Organisms*, *Parasites & Vectors*, *Veterinary Parasitology*, *Fishes*
(MDPI), *Animals* (MDPI) e PLOS ONE. Termos úteis: "prevalence before and
after treatment", "paired infection status", "treated and untreated fish",
"post-treatment parasite presence", "cure rate", "individually tagged fish
infection", "repeated binary", "raw data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite uma tabela de **prevalência por grupo e momento** (por exemplo,
  "40% antes, 15% depois") como se fosse dado pareado. Sem o código do
  indivíduo, não dá para formar os pares. Se o artigo só traz isso, diga que o
  candidato falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Espécie, o que é o indivíduo (peixe, tanque, lote, animal) e o ambiente.
5. A resposta binária: o que significa sim e não, e como foi medida (exame,
   contagem, histologia, cultura).
6. Os momentos de avaliação (por exemplo, dia 0 e dia 14) e a intervenção entre
   eles.
7. Quantos indivíduos há com os **dois momentos completos** (os pares), quantos
   perderam um deles e quantas linhas no total.
8. A tabela 2 × 2 dos pares, se der para montar (sim→sim, sim→não, não→sim,
   não→não), ou ao menos quantos mudaram em cada sentido.
9. Se há grupo-controle, com os mesmos números.
10. Problemas para limpar (NA, formato largo ou longo, código do indivíduo que
    se repete ou falta, rótulos a traduzir, várias tabelas a juntar).
11. Quais análises ele cobre: McNemar, qui-quadrado de independência
    (para mostrar o erro), regressão logística, comparação de proporções entre
    tratado e controle, ou outras.
12. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
