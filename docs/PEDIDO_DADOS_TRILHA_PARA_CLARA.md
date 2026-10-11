# Pedido: os dados que a Trilha usa hoje, para a ClaRa

Complemento de `docs/PROMPT_MIGRACAO_DADOS_CLARA.md`, escrito em 11/10/2026
pela sessão que trabalha na Trilha, para a sessão que cuida da migração dos
dados do EAPADados para a ClaRa. Siga o prompt para tudo o que ele já define
(ficha, `preparar.R`, documentação, catálogo, teste genérico, uma
integração por vez). Este documento diz **quais conjuntos a Trilha precisa
primeiro** e **o que não pode mudar neles**, para que a Trilha passe a carregar
os dados da ClaRa, e não mais do EAPADados.

Objetivo do professor: fazer a troca agora, e não deixar para depois.

## 1. Como registrar: `D001_bagre-racao`

Decisão do professor (11/10/2026), que ajusta a regra de "Nome e número de
registro" do prompt:

- **O registro** de cada conjunto tem a forma `D001_bagre-racao`: a letra D,
  **três dígitos**, um `_` e **no máximo duas palavras**, ligadas por `-`.
  As palavras dizem do que é o conjunto (o animal e o assunto, por exemplo),
  em minúsculas e sem acento. É o nome da pasta em `data-raw/`, o
  identificador da ficha e o que vai na coluna `codigo` do catálogo (ou numa
  coluna `registro`, se `codigo` ficar só com `D001`; o importante é o
  catálogo ter as duas coisas, número e nome).
- Exemplos: `D001_bagre-racao`, `D002_artemia-racao`, `D003_barbo-morfometria`,
  `D004_tubarao-cpue`, `D005_doubs-ambiente`. Duas palavras bastam para
  achar o conjunto; a descrição completa fica no título e na ficha.
- **O nome do objeto não muda**: o aluno continua digitando
  `bagre_racao_isoproteica` (`data(bagre_racao_isoproteica)`,
  `clara::bagre_racao_isoproteica`). O registro curto não é o nome do objeto.
- O primeiro registro, hoje `D001_bagre_racao_isoproteica` no NEWS e na
  pasta, passa a `D001_bagre-racao`. Os commits antigos dizem "D-001" e ficam
  como estão. Os números continuam sendo de chegada, para sempre, sem
  renumerar.

## 2. Uma coluna nova no catálogo: o nome antigo no EAPADados

A Trilha, os testes e os projetos que os alunos já exportaram usam os nomes
do EAPADados (`isoproteica_bagre`). Para a troca não quebrar nada, o catálogo
precisa dizer de onde cada conjunto veio:

- `nome_eapadados`: o nome do objeto no EAPADados (`isoproteica_bagre`), ou
  vazio para os que não vêm de lá.

Com ela, a Trilha troca os nomes antigos pelos novos num lugar só e mostra os
conjuntos da ClaRa sem duplicar os que ainda estão no EAPADados durante a
transição.

## 3. A ordem de que a Trilha precisa

### 3.1 Primeiro: os presos ao código da Trilha

A tela de importação lista todos os conjuntos sozinha, mas estes cinco estão
presos ao código pelo nome. Com eles prontos, a Trilha já pode trocar de fonte.

| Conjunto no EAPADados | Onde a Trilha depende dele | O que não pode mudar |
|---|---|---|
| `isoproteica_bagre` | testes da ANOVA, do Kruskal-Wallis e da rota ClaRa | **já pronto** como `D001_bagre-racao`; as colunas `racao` (fator) e `peso_g` são lidas pelo nome nos testes e no dicionário da exportação |
| `artemia` | é o conjunto que abre por padrão na importação; testes do Mann-Whitney | as colunas `racao` (fator, dois níveis) e `taxa_crescimento_mg_dia` são lidas pelo nome |
| `cpue_tubarao` | a tela de Séries Temporais carrega ele direto, como exemplo | precisa de uma coluna de data (classe `Date`) e de uma resposta numérica; a tela acha a data pelo nome (`data`, `date`, `ano`, `year`, `mes`), então a tradução de `Year`, `Month` e `Data` para o português deve manter esses radicais |
| `morfometria_barbo` | exemplo da regressão; o exportador escreve textos próprios para ele (Introdução, Métodos, Discussão, com a referência `takacs2022`) | as colunas `altura_maxima_corpo`, `distancia_dorsal_pelvica`, `comprimento_cabeca`, `distancia_pre_peitoral` e `populacao` (fator, cinco níveis) são lidas pelo nome; as medidas são corrigidas pelo comprimento padrão, e isso precisa continuar dito na documentação |
| `doubs_ambiente` | o PCA abre com uma configuração própria para ele | as colunas `riqueza` (suplementar quantitativa) e `trecho` (fator, variável de grupo) são lidas pelo nome |

### 3.2 Depois: os usados pelos testes da Trilha

| Conjunto no EAPADados | Teste da Trilha | Observação |
|---|---|---|
| `abalone_adultos` | cinco testes da exploração e da descrição | os testes leem `sexo` e as medidas numéricas |
| `salvelino_formalina_remocao` | ANOVA de dois fatores | hoje o teste o lê de `EAPADados/data-raw/`, não de `data/` |
| `camarao_vannamei_biometria` | roteiro antigo da regressão | |
| `pinguins` | guia de exploração | |

### 3.3 Por fim: a lista de segurança da importação

Se o pacote de dados faltar, a importação usa uma lista fixa de oito
conjuntos, e a exportação tem um dicionário de variáveis escrito à mão para
sete deles: `artemia`, `biometria_caranguejos`, `camaroes_sexo`,
`cangulo_crescimento`, `captura_petrechos`, `isoproteica_bagre`,
`tilapia_crescimento` e `walleye_erie`.

### 3.4 O resto

Os outros, cerca de trinta, só aparecem no menu e podem seguir a fila do
prompt, sem pressa.

## 4. Pontos de curadoria já encontrados

- **`cangulo_crescimento`:** as colunas `ln_peso` e `ln_comp` parecem
  trocadas. `ln_peso` = 2,48 corresponde a ln(12), que é o comprimento de 12
  cm da primeira linha, e `ln_comp` = 3,76 a ln(43), o peso. Pela regra do
  prompt, colunas derivadas que o aluno calcula na Trilha nem deveriam
  entrar; se entrarem, que estejam certas.
- **Autorização dos autores:** o NEWS da ClaRa diz que a do D001 está
  pendente. Diga no catálogo (coluna de licença ou de situação) quais
  conjuntos ainda não têm autorização, para a Trilha marcá-los como
  provisórios ou escondê-los dos alunos.

## 5. O que fica com a Trilha (não faça)

A outra sessão não altera a `TRILHA/`. Quando os cinco conjuntos do item 3.1
estiverem na `main` da ClaRa, com a versão subida, a sessão da Trilha faz:

- a importação ler `clara::catalogo_dados`, com o EAPADados como reserva
  durante a transição, sem duplicar o que já migrou;
- a troca dos nomes antigos pelos novos no código (conjunto padrão, Séries
  Temporais, PCA, textos do barbo no exportador, dicionário da exportação);
- a troca nos testes;
- os Projetos R exportados continuam levando uma cópia da planilha, então os
  já entregues aos alunos não quebram.

Avise o professor quando os cinco estiverem prontos. Para não haver duas
sessões mexendo no mesmo repositório ao mesmo tempo, a Trilha só começa
depois disso.
