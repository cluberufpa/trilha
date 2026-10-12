# Busca 10 — sexo × outra categoria, dados individuais

Busca de **12/10/2026**, conforme `10_sexo_por_especie_individuos.md`. A busca
por camarões (DataCite, Dryad, Zenodo, Figshare, PANGAEA; arquivos nesta pasta)
não achou registro individual de sexo × espécie que cumprisse os critérios.
O professor trouxe, no lugar, o conjunto abaixo (`peixes_parasitismo_individuos_tidy.xlsx`,
nesta pasta). **Nenhum dado foi incorporado ao pacote.**

## Candidato: guppies de Trinidad × Gyrodactylus

**Título:** Data from: Shoaling guppies evade predation but have deadlier parasites.
**Autores:** Walsman, Janecka, Clark, Kramp, Rovenolt et al. (2022).
[Dryad, doi:10.5061/dryad.k3j9kd59h](https://datadryad.org/dataset/doi:10.5061/dryad.k3j9kd59h).
[Artigo: Nature Ecology & Evolution](https://doi.org/10.1038/s41559-022-01772-5).

**Licença conferida (12/10/2026):** CC0 1.0, campo `license` da API do Dryad
(`spdx.org/licenses/CC0-1.0`). Título, autores e DOI conferem com a aba
`documentacao` da planilha. A planilha parece ser o `SI_ParasiteCountsOther.csv`
(260 KB) arrumado e traduzido; **a conferência linha a linha com o CSV original
não foi feita** (falta baixá-lo e registrar o hash).

**Unidade:** um guppy selvagem (*Poecilia reticulata*), 4.715 linhas × 17
colunas, 69 combinações rio × sítio × ano (2003–2009), 17 bacias. Colunas
principais: `classe_sexo` (Fêmea 1.951, Macho 1.520, Juvenil 1.244),
`presenca_parasito` (0/1), `contagem_parasitos` (*Gyrodactylus*), `peso_g`,
`trecho_rio` (Alto, Médio, Baixo curso, Lago), `bacia`, `rio`, `sitio_id`, `ano`
e nove colunas `presenca_*`/`riqueza_*` de outros organismos.

### Tabela cruzada sexo × parasito (calculada na planilha)

| | sem | com |
|---|---:|---:|
| Fêmea | 1229 | 722 |
| Juvenil | 1067 | 177 |
| Macho | 1019 | 501 |

Menor esperado: 369. χ² = 200,3 (gl 2, p < 0,001). Só fêmea × macho:
χ² = 5,95 (p = 0,015). Razão sexual de adultos: 56,2% de fêmeas
(IC 54,5–57,9%; teste de proporções, p < 0,001). Sexo × trecho do rio é um
segundo 3 × 4 (menor esperado 51,7).

### Cobre
Qui-quadrado de independência (3 × 2, 2 × 2, 3 × 4), teste de proporções (1:1),
peso por sexo ou por infecção (t, Mann-Whitney), contagem de parasitos por sexo
(Kruskal-Wallis).

### Limites e cuidados
- **Fora do tema:** peixe de aquário em estudo de ecologia parasitária, não pesca
  nem aquicultura. Serve como ferramenta didática; o contexto vem do texto.
- **Tamanho:** 4.715 linhas, acima das 2.000 do pedido; em `xz` o objeto é pequeno.
- **Dependência:** peixes agrupados em 69 sítios; o p-valor do qui-quadrado é
  otimista. Dizer isso na ficha.
- **NA:** 113 em `peso_g` (fêmeas 49, machos 51, juvenis 13). Manter.
- **Linhas idênticas:** 723, na maioria juvenis de mesmo peso, sem ID do peixe.
  Não aplicar `distinct()`.
- **Inconsistência:** em 3 linhas `presenca_parasito` não bate com
  `contagem_parasitos > 0`; conferir na fonte antes de incorporar.
- **Juvenil** não é sexo; a coluna é uma classe demográfica. Os juvenis têm
  parasitismo bem menor (14%), o que dá ao 3 × 2 parte do χ².
- Tema parecido com o D50 (`molinesias_parasitos`).

### Pergunta para o aluno
A prevalência de *Gyrodactylus* depende do sexo (e da fase juvenil) do guppy?

## Decisão (12/10/2026)
O professor autorizou o uso. Incorporado à ClaRa como `lebistes_parasitos`, no
lugar do D19 (`camaroes_sexo`, que foi para `data-raw/substituidos/`). O código D19
foi reaproveitado, sem criar D63. A tabela de contingência não vem pronta: o aluno
a monta no preparo, depois da base compartilhada. Ficha:
`ClaRa/data-raw/D19_lebistes_parasitos/FICHA.md`.
