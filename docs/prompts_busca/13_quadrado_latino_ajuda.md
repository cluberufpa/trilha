# Quadrado latino: ficha de uso e possibilidades na aquicultura

## Planilha didática deste estudo

A tabela [13_quadrado_latino_vacas_limpo.csv](13_quadrado_latino_vacas_limpo.csv)
é uma **planilha de análise**, não a planilha bruta. Cada linha corresponde a uma
célula independente do delineamento: uma vaca em um período.

| Papel | Coluna | Neste estudo |
| --- | --- | --- |
| Resposta principal | `ph_ruminal_medio` | média das sete leituras de pH da vaca no período |
| Fator de interesse | `tratamento_dietetico` | quatro combinações de oferta de forragem e suplemento |
| Bloco de linhas | `animal` | a vaca; controla diferenças persistentes entre animais |
| Bloco de colunas | `periodo` | o período; controla mudanças comuns no tempo |
| Resultados auxiliares | `nitrogenio_amonical_mmol_l_medio`, `agv_total_mmol_l_medio` | respostas para novas análises, não réplicas adicionais de pH |

Portanto, para a primeira ANOVA, a pergunta é: **as quatro dietas diferem no pH
ruminal médio, depois de controlar animal e período?** O modelo didático é:

```r
aov(ph_ruminal_medio ~ tratamento_dietetico + animal + factor(periodo),
    data = dados)
```

A planilha original tinha sete horários por célula. Eles foram resumidos em uma
média porque não são sete animais independentes nem sete novas parcelas do
quadrado latino. As colunas `n_horarios_*` preservam essa procedência.

O estudo original é um fatorial 2 × 2 dentro de um quadrado latino. Por isso,
`tratamento_dietetico` reúne as quatro combinações para a aula introdutória de
quadrado latino. Em uma aula posterior, as colunas
`oferta_forragem_codigo` e `suplemento_codigo` permitem discutir os dois
fatores e a interação. A fonte guarda esses níveis como 1 e 2; só substitua os
códigos pelos nomes completos após conferir a correspondência no protocolo
original.

## Como reconhecer um caso na pesca e na aquicultura

Use quadrado latino quando houver **um tratamento de interesse** e **dois
gradientes que precisam ser controlados**, com k níveis em todos os três fatores.
A unidade experimental tem de receber apenas um tratamento e cada tratamento
precisa ocorrer uma vez por linha e uma vez por coluna.

### Exemplo 1 — camarões em tanques

Quatro dietas para juvenis de camarão podem ser distribuídas em 16 tanques
independentes de uma estufa (4 × 4). As linhas representam a fileira de tanques
(gradiente de incidência lateral de luz) e as colunas representam a posição em
relação à entrada de água ou aeração. A resposta pode ser ganho de peso médio
por tanque, conversão alimentar ou sobrevivência transformada quando apropriado.

- Tratamento: dieta A, B, C ou D.
- Linha: fileira 1–4.
- Coluna: posição 1–4.
- Unidade experimental: tanque, nunca cada camarão individual.
- Precaução: padronizar densidade, biomassa inicial, renovação de água e
  manejo; se os tanques compartilham fortemente a mesma água, discutir
  pseudorrepetição.

### Exemplo 2 — peixes em sistema de recirculação

Em 16 tanques de tilápia, quatro probióticos/dietas podem ser alocados em um
quadrado 4 × 4. Linhas podem captar circuitos de recirculação e colunas a
distância da janela ou do soprador. A resposta é, por exemplo, taxa específica
de crescimento do tanque ao final de 30 dias.

- Não usar como bloco uma variável que já seja consequência da dieta.
- Medir oxigênio, temperatura e amônia para verificar se os gradientes locais
  realmente existem; essas medidas não viram novas repetições.
- Se houver mortalidade, conservar a informação e avaliar se faltas quebram o
  balanceamento.

### Exemplo 3 — cruzamento de dietas em peixes, camarões ou moluscos

Quando cada unidade (tanque, lote ou animal) recebe todas as quatro dietas em
quatro períodos, a estrutura é semelhante à das vacas: unidade = linha, período
= coluna e dieta = tratamento. Só é adequado se houver adaptação/lavagem
suficiente e se o efeito de carregamento for plausivelmente pequeno ou
planejado; isso deve ser discutido, não ignorado.

## Checklist antes da análise

1. Há exatamente k linhas, k colunas e k tratamentos?
2. Cada tratamento aparece uma vez em cada linha e uma vez em cada coluna?
3. A resposta pertence à unidade experimental, e não a subamostras contadas
   como réplicas?
4. Os gradientes escolhidos para linhas e colunas são anteriores ao tratamento?
5. Há no máximo poucas células ausentes, todas documentadas?
6. A pergunta e a unidade permanecem compreensíveis após traduzir os rótulos?

Fonte dos dados: Merino et al. (2021), [Figshare CC BY 4.0](https://doi.org/10.6084/m9.figshare.13818920.v3); artigo associado [DOI 10.3390/ani11040919](https://doi.org/10.3390/ani11040919).

