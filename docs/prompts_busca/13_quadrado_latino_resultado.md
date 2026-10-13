# Busca 13 — resultado: quadrado latino

Pesquisa realizada em 12/10/2026. A separação abaixo é deliberada: **conferido** significa que a página do repositório e/ou o arquivo foram abertos; o que dependeria de uma inferência está marcado como tal.

## Recomendado — vacas leiteiras em pastagem

**Conjunto.** Merino, V.; Rivero, J.; Pulido, R. (2021), *Metabolic and productive response and grazing behavior of lactating dairy cows supplemented with high moisture maize or cracked wheat grazing at two herbage allowances in spring*. [Figshare, DOI 10.6084/m9.figshare.13818920.v3](https://doi.org/10.6084/m9.figshare.13818920.v3). Artigo: Merino et al. (2021), *Animals* 11, 919, [DOI 10.3390/ani11040919](https://doi.org/10.3390/ani11040919).

**Licença.** CC BY 4.0, exibida na ficha do Figshare. Portanto a adaptação, tradução e redistribuição são permitidas com atribuição.

**Arquivo aberto.** [data fistulated cows.xlsx](https://ndownloader.figshare.com/files/26999174) (XLSX, 112 linhas × 15 colunas; o endereço é o download direto do arquivo listado na ficha). O conjunto contém `Period`, `Time`, `Cow No`, `Herbage mass`, `Supplement type`, `N-NH3 MMOL/L`, `PH` e as concentrações de AGV.

**Contexto e unidade.** Quatro vacas Holstein-Friesian fistuladas, em pastagem, passaram por quatro períodos de 14 dias. Cada célula vaca × período foi medida em sete horários no último dia. Os tratamentos são as quatro combinações dos dois níveis codificados de `Herbage mass` e dos dois níveis codificados de `Supplement type`; o artigo os descreve como dois níveis de oferta de forragem e suplementação por milho úmido ou trigo moído. A planilha só guarda os níveis como `1` e `2`: confirme o pareamento exato código → rótulo antes de traduzir os tratamentos.

**Quadrado conferido.** Ao agrupar as sete medições horárias em uma média de pH, há 16 células, sem `NA` em `PH`:

| Checagem | Resultado |
| --- | --- |
| Linhas | vacas 1844, 2231, 2243 e 5182 (k = 4) |
| Colunas | períodos 1–4 (k = 4) |
| Tratamentos | combinações `HM1_ST1`, `HM1_ST2`, `HM2_ST1`, `HM2_ST2` (k = 4) |
| Cada tratamento por vaca | 1 vez |
| Cada tratamento por período | 1 vez |
| Células faltantes | 0 de 16 |

Assim, a tabela didática tem uma linha por vaca × período, e não uma por horário. `pH` é uma resposta contínua; `N-NH3` também pode ser usado. A coluna `VFA` tem 25 ausências no arquivo bruto, por isso não é a melhor primeira resposta para a aula.

**ANOVA para conferência.** O artigo analisa o ensaio como fatorial 2 × 2 e relata que os parâmetros ruminais não diferiram entre tratamentos; ele não publica uma tabela de ANOVA com os três fatores `tratamento + vaca + período`. Recalculei localmente a ANOVA de quadrado latino para o pH médio das 16 células:

| Termo | gl | F | p |
| --- | ---: | ---: | ---: |
| tratamento (quatro combinações) | 3 | 0,183 | 0,9044 |
| vaca/linha | 3 | 0,515 | 0,6871 |
| período/coluna | 3 | 13,135 | 0,00479 |
| resíduo | 6 | — | — |

É um bom caso para o objetivo central do prompt: o efeito de período é claro, e o erro médio quadrático cai de 0,08046 na ANOVA de um fator para 0,02057 no quadrado latino. Não há efeito de tratamento, portanto ele ensina sobretudo o ganho de controle dos blocos, e não um tratamento vencedor.

**Pergunta didática.** “Depois de controlar a vaca e o período, as quatro combinações de oferta de forragem e suplemento alteram o pH ruminal médio?”

**Limpeza proposta.** Média dos sete horários por célula; nomes em português (`vaca`, `período`, `oferta_forragem`, `suplemento`, `pH`); uma tabela de correspondência documentada para os códigos 1/2; excluir `VFA` da primeira aula ou tratar as suas ausências separadamente. Manter `Time` apenas no arquivo bruto, pois as sete coletas da mesma célula não são 112 unidades independentes.

## Candidatos examinados, mas não indicados

| Candidato | O que foi conferido | Por que não serve como substituto imediato |
| --- | --- | --- |
| Gaffney (2016), [dados de preferência de cor em salmão coho](https://doi.org/10.6084/m9.figshare.3083704.v1); artigo [10.1371/journal.pone.0151325](https://doi.org/10.1371/journal.pone.0151325) | CC BY 4.0; três XLSX abertos; dez tanques e testes em desenho 5 × 5, com efeito publicado de preferência pela cor escura (p < 0,0001). | Os XLSX trazem tanque, cor comparada e contagens por tempo, mas não trazem dia/sessão (a coluna que permitiria reconstituir o quadrado). Sem essa coluna, não se pode verificar o balanceamento nem montar linha × coluna × tratamento sem inferir informação ausente. |
| Vargas Bello Pérez et al. (2023), [*Chia seeds and pumpkin seeds in dairy sheep diets*](https://doi.org/10.6084/m9.figshare.24424525.v1); artigo [10.1371/journal.pone.0300864](https://doi.org/10.1371/journal.pone.0300864) | CC BY 4.0; XLSX aberto; colunas `periodo`, `Animal` e `Trat`; resultados publicados com diferenças em consumo de NDF, produção de leite e componentes. | É um arranjo de **quatro quadrados 3 × 3** (12 ovelhas, três dietas), portanto k = 3 e o resíduo de cada quadrado teria somente dois gl. Falha na exigência explícita de k entre 4 e 8. |
| Parodi Thexeira et al. (2026), [*Field evaluation of Nzi and modified Nzi traps*](https://doi.org/10.5061/dryad.xsj3tx9vs) | Página e README abertos: XLSX com fazenda, semana, dia, posição e armadilha; cinco réplicas 4 × 4 em cada uma de duas fazendas. | Estrutura de quadrados repetidos é excelente, mas a resposta é contagem de moscas (não contínua). Além disso, a licença específica não ficou visível na página que foi possível consultar; não é prudente redistribuir antes de confirmá-la na ficha do Dryad. |

## Decisão

Use **Merino et al. (2021)**. É o único candidato acima com arquivo aberto, licença explícita aceitável, quadrado 4 × 4 verificável e resposta contínua. O efeito forte de período oferece uma demonstração honesta do motivo para ajustar os dois bloqueios, mesmo sem diferença de tratamento. Antes de incorporar no pacote, preserve a citação e resolva documentalmente o significado dos códigos `1` e `2` das duas variáveis de tratamento.

