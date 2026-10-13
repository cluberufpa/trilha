# Busca 12 — McNemar a partir de uma tabela 2 × 2 publicada

Substitui: `erva_marinha_lesoes` (D12), cujo "antes" foi construído como zero
para todas as plantas, o que deixa a tabela de pares degenerada
(`mcnemar.test()` não roda). Escrito em 12/10/2026. Cole o texto abaixo da
linha numa IA com busca na web.

> Estratégia combinada: quase nenhum artigo de aquicultura publica a linha por
> indivíduo de dados pareados. Publicam a **tabela de contingência 2 × 2 dos
> pares**. Se essa tabela é real e citável, o pacote pode **reconstruir** o
> banco bruto a partir dela, com uma nota clara de que a tabela é do artigo e as
> linhas são reconstruídas. Antes de aceitar essa saída, procura-se a
> alternativa melhor: dados brutos de verdade (ver a busca 07).

---

Preciso de um conjunto para ensinar o **teste de McNemar** num pacote R didático
de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Duas rotas são aceitas, nesta ordem de preferência.

## Rota A (preferida): dados brutos reais, uma linha por indivíduo

Um arquivo aberto em que o **mesmo indivíduo** (peixe, camarão, ostra, tanque,
lote) tem **duas respostas binárias pareadas**, com um código que o identifique.

## Rota B (aceita): tabela 2 × 2 de pares publicada num artigo

O artigo traz a tabela de contingência dos pares, com as quatro frequências, e
eu reconstruo as linhas. **A tabela precisa ser dos pares**, isto é, cada animal
contado uma vez nas duas avaliações.

## O que o estudo precisa ter

- **O mesmo animal avaliado duas vezes**, de um destes dois jeitos:
  1. **Dois métodos diagnósticos no mesmo animal**: PCR × histologia, PCR ×
     cultura, teste rápido × PCR, ELISA × PCR, exame visual × microscopia,
     qPCR × PCR convencional, exame de campo × laboratório;
  2. **Antes e depois** de um manejo ou intervenção: tratamento, vacina,
     depuração, transferência de ambiente, armazenamento do pescado.
- **A resposta é binária** nas duas avaliações: positivo/negativo,
  presente/ausente, infectado/não, com lesão/sem lesão.
- **As quatro células existem e estão informadas**: concordância nos dois
  sentidos (+/+ e −/−) e discordância nos dois sentidos (+/− e −/+). Se uma
  célula discordante for zero, diga isso, porque o McNemar fica degenerado
  (não roda no R base) e o conjunto perde o valor didático.
- **Discordantes suficientes**: b + c de pelo menos 10 (melhor 15 ou mais), com
  b e c **diferentes de zero** e de preferência diferentes entre si, para o
  teste ter o que comparar.
- **De 40 a 400 animais** no total.
- **Os dois "momentos" são medidas reais.** Não aceito tabela em que uma das
  duas colunas foi suposta, imputada ou fixada por delineamento (por exemplo,
  "todos começaram sem a doença"). Esse foi exatamente o defeito do conjunto que
  estamos trocando.
- **Pares de fato.** Não aceito prevalência por grupo ("40% antes, 15%
  depois") nem pools de animais PCR contra indivíduos na histologia, porque
  isso quebra o pareamento. Se a unidade for tanque ou viveiro, diga quantos
  peixes cada um tem.
- **Sem agrupamento forte** (vários animais do mesmo tanque tratados como
  independentes). Se houver, descreva o agrupamento.

## Licença

- Aceito: **CC0**, **CC BY 4.0**, **CC BY-SA**, ou domínio público. Para a
  Rota B, o artigo deve estar em **acesso aberto com licença CC BY** ou
  equivalente, porque vamos reproduzir uma tabela de contagens com crédito.
  Tabelas de contagem são fatos, mas a licença do artigo importa para a
  citação.
- Não aceito: CC BY-NC, CC BY-ND, "uso acadêmico apenas", ou artigo fechado
  cuja tabela eu não consiga conferir.
- **Confira a licença na página do artigo ou do repositório** e diga onde ela
  aparece. Não a deduza pelo periódico.

## Ordem de preferência das áreas

1. **Sanidade de organismos aquáticos**: vírus (WSSV, IHHNV, TSV, EHP, IMNV),
   bactérias (*Vibrio*, *Aeromonas*, *Streptococcus*), parasitos (*Bonamia*,
   *Perkinsus*, mixosporídeos, monogenéticos, *Ichthyophthirius*) em camarão,
   ostra, tilápia, salmonídeos, bagre, peixes ornamentais;
2. **Pescado**: presença de *Salmonella*, *Listeria*, histamina acima do limite,
   parasito (*Anisakis*) por dois métodos (visual × digestão péptica), ou antes
   e depois de armazenamento;
3. **Reprodução e crescimento**: maturidade ou sexo por dois métodos (macro ×
   histologia, ultrassom × histologia, ensaio hormonal × gônada), presença de
   ovos, deformidade antes e depois de uma mudança de manejo;
4. Ciência animal (mastite, claudicação), só se nada acima servir.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Para a Rota A: Dryad, Zenodo, figshare, Mendeley Data, PANGAEA, OSF e os dados
suplementares de *Data in Brief*, *Scientific Data*, *Aquaculture Reports*,
*Journal of Fish Diseases*, *Diseases of Aquatic Organisms*, *Parasites &
Vectors*, *Fishes*, *Animals* e PLOS ONE.

Para a Rota B: PubMed Central, Frontiers, MDPI, PLOS ONE, *Veterinary
Research*, *BMC Veterinary Research*, *Aquaculture Reports*, *Journal of Fish
Diseases*, *Pathogens*. Termos úteis: "McNemar" com "shrimp", "oyster",
"tilapia", "salmon", "fish", "aquaculture"; "agreement between" PCR e
"histology"; "concordance" e "kappa" em organismos aquáticos; "paired" com
"diagnostic"; "before and after treatment" com "McNemar's test"; "discordant
pairs".

## Regras de honestidade (leia com atenção)

- **Não invente** autores, DOI, link, periódico, ano, nem as quatro frequências.
  Se não conseguiu abrir o texto completo e ver a tabela, diga isso e informe o
  que viu na página. Um candidato sem tabela conferida **não vale**.
- **Não crie um cenário "baseado na literatura".** Cada candidato deve ser um
  artigo real, aberto por você, com a tabela vista. Se não houver, diga que não
  achou; prefiro um "não achei" a um número plausível inventado.
- Separe o que você **conferiu** (abriu a página, viu a tabela, leu a licença)
  do que você **supõe**.
- **Copie a tabela exatamente** como aparece, com a legenda e o número da
  tabela ou da página, e diga quais são as linhas e as colunas. Se o artigo usa
  a ordem "teste A positivo/negativo nas linhas", respeite.
- Confira que **a soma das quatro células é o n do estudo** e que bate com o
  texto. Se não bater, avise.
- Se o artigo aplicou McNemar, diga o valor da estatística e o p que ele
  relatou, para eu conferir com o `mcnemar.test()`.
- Se só encontrar candidatos com falha (célula discordante zero, pools,
  prevalências), apresente-os mesmo assim e diga qual critério falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Rota (A ou B), título, autores, ano, periódico, DOI do artigo e, na Rota A,
   o DOI ou link do repositório de dados.
2. Licença e onde ela aparece na página.
3. Espécie, o que é o indivíduo (peixe, camarão, ostra, tanque) e o ambiente
   (cultivo, laboratório, mar, mercado).
4. Os **dois eventos pareados**: os dois métodos, ou os dois momentos e a
   intervenção entre eles. O que significa positivo e negativo em cada um.
5. **A tabela 2 × 2 dos pares**, com as quatro frequências, o número da tabela
   no artigo e quem está nas linhas e nas colunas:

   | | B positivo | B negativo |
   |---|---:|---:|
   | **A positivo** | a | b |
   | **A negativo** | c | d |

6. O n total, quantas são concordantes (a + d) e quantas discordantes (b + c).
7. O que o artigo concluiu (McNemar, p, kappa, sensibilidade) e se a tabela
   respalda isso.
8. Limites do pareamento: pools, agrupamento por tanque, perdas, método de
   referência imperfeito.
9. Uma **pergunta de pesquisa simples** que um aluno responderia com a tabela.
10. Se for Rota B, **um script em R** que reconstrói o banco bruto:
    - cria um `data.frame` com uma linha por indivíduo, com um `id`, as duas
      avaliações e, se existir, o tratamento ou a espécie;
    - garante que as frequências batem **exatamente** com a tabela do artigo;
    - embaralha as linhas com `set.seed()` e `sample()`;
    - gera `table()` a partir dos dados e mostra que reproduz a tabela;
    - aplica `mcnemar.test()` e compara o resultado com o que o artigo relatou;
    - traz um comentário dizendo que **as linhas são reconstruídas** e que a
      única informação real é a tabela 2 × 2.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê. A
Rota A vale mais que a B; entre candidatos da mesma rota, vale mais o que tiver
mais discordantes nos dois sentidos e uma pergunta mais simples de explicar.
