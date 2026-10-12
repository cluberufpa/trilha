# Pedido à sessão dos dados — tirar da ClaRa as cópias do FSAdata

> Escrito em 12/10/2026 pela sessão da Trilha, a pedido do professor. Aplica a
> `EMENDA_DADOS_DE_PACOTES.md` (nesta mesma pasta). Cole numa sessão aberta em
> `D:\Claude\EAPA-Ecossistema` e trabalhe na branch `dados` (`ClaRa-dados/`).

## O que se pede

Os conjuntos abaixo vieram do `FSAdata` (GPL) e hoje estão **copiados** em
`data/` da ClaRa. Eles deixam de ser cópia: a ClaRa passa a ler o objeto do
`FSAdata` na hora e a aplicar a tradução por código. Os `.rda` saem, a ficha e o
registro ficam, e o aluno continua recebendo o mesmo objeto em português.

## Os oito conjuntos do FSAdata

| Código | Registro | Objeto na ClaRa | Original no FSAdata | Linhas × colunas | Veio por |
|---|---|---|---|---|---|
| D24 | `D24_percina_ontario` | `darter_ontario` | `DarterOnt` | 54 × 3 | EAPADados |
| D27 | `D27_savel_idades` | `idades_savel_repetibilidade` | `ShadCR` | 53 × 8 | EAPADados |
| D34 | `D34_snapper_idades` | `snapper_hg` | `SnapperHG1` | 1331 × 6 | EAPADados |
| D54 | `D54_haemulon_crescimento` | `haemulon_crescimento` | `WhiteGrunt2` | 465 × 3 | FSAdata direto |
| D55 | `D55_cabezon_maturidade` | `cabezon_maturidade` | `Cabezon` | 525 × 5 | FSAdata direto |
| D56 | `D56_ruffe_biometria` | `ruffe_biometria` | `RuffeSLRH92` | 738 × 11 | FSAdata direto |
| D57 | `D57_bighill_amostras` | `bighill_amostras` | `BGHRsample` | 20 × 4 | FSAdata direto |
| D58 | `D58_bighill_peixes` | `bighill_peixes` | `BGHRfish` | 266 × 6 | FSAdata direto |

**E o crabs, na mesma rodada** (decisão do professor, 12/10/2026):

| Código | Registro | Objeto na ClaRa | Original | Linhas × colunas | Veio por |
|---|---|---|---|---|---|
| D23 | `D23_caranguejos_morfometria` | `crabs_morfometria` | `MASS::crabs` | 200 × 10 | EAPADados |

Ele segue os mesmos passos abaixo, com `MASS` em `Suggests`, `fonte_dados =
"MASS"` e `skip_if_not_installed("MASS")`. Como veio pelo EAPADados, também
pede a conferência do passo 2. Na Trilha, ele aparece na mesma lista dos oito
do FSAdata.

## Como fazer

1. **Receita por conjunto.** Num arquivo `R/dados_pacotes.R`, um registro com
   pacote, objeto original e a função que traduz. A tradução é a que o
   `preparar.R` de cada pasta já faz; ela só passa a rodar na hora.
2. **Os quatro que vieram pelo EAPADados (D23, D24, D27, D34) pedem conferência.** O
   EAPADados pode ter filtrado linhas ou recalculado colunas no caminho. Antes
   de tirar o `.rda`, a receita aplicada ao objeto do `FSAdata` precisa
   reproduzir **exatamente** o objeto atual (`identical()` ou `all.equal()`).
   Se não reproduzir, relate a diferença ao professor e espere a decisão.
3. **Uma porta de entrada.** Por exemplo `carregar_dados("snapper_hg")` (nome a
   confirmar com o professor), que confere o `FSAdata` com `requireNamespace()`
   e, se faltar, diz em português como instalá-lo.
4. **`DESCRIPTION`:** `FSAdata` e `MASS` em `Suggests`.
5. **Catálogo:** os nove continuam no `catalogo_dados` (o código D e o registro
   não mudam), com a coluna nova `fonte_dados = "FSAdata"` (ou `"MASS"`, no
   crabs); os demais, `"clara"`.
6. **Documentação:** a ajuda de cada um continua, dizendo "Adaptado de
   `FSAdata::<objeto>`", com a versão, os autores, a referência original, a
   licença GPL do pacote de origem e o de-para.
7. **Testes:** para cada um dos nove, linhas, colunas e níveis iguais aos da
   ficha, com `skip_if_not_installed("FSAdata")`.
8. **Só então sair do repositório:** `data/<objeto>.rda` e as cópias do
   original em `data-raw/<registro>/fonte/` (`.rds`/`.rda` do FSAdata e do MASS). A
   `FICHA.md` e o de-para ficam.
9. **Check completo** no Windows, `NEWS.md` e versão nova da ClaRa antes de
   integrar na `main`, com o "sim" do professor.

## O que não fazer

- Não mexer nos outros conjuntos nem nas funções de análise da ClaRa.
- Não mexer na `TRILHA/`. A troca da fonte na Trilha (seletor em dois passos e
  `FSAdata` em `Imports`) é de outra sessão.

## Observação

A pasta `data/` diminui pouco: os nove `.rda` somam cerca de 15 KB, porque o
`xz` já comprime bem. O ganho está na licença e em ter menos cópias para
manter, não no tamanho.
