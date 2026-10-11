---

editor_options: 
  markdown: 
    wrap: 72
---

# Pedido: os dados que a Trilha usa hoje, para a ClaRa

Complemento de `docs/PROMPT_MIGRACAO_DADOS_CLARA.md`, escrito em 11/10/2026 pela sessão que trabalha na Trilha, para a sessão que cuida da migração dos dados do EAPADados para a ClaRa. Siga o prompt para tudo o que ele já define, a começar pela seção "Mudança de plano": todos os conjuntos entram agora, como estão, e a curadoria fina vem depois. Este documento diz **o que a Trilha lê em cada conjunto** e **o que não pode mudar neles**, para que a Trilha passe a carregar os dados da ClaRa, e não mais do EAPADados.

Objetivo do professor: fazer a troca agora, e não deixar para depois.

## 1. Como registrar: `Dxx_duas_palavras`

Decisão do professor (11/10/2026), que ajusta a regra de "Nome e número de registro" do prompt:

- **O código** tem a letra D e **dois dígitos**: `D01`, `D02`, ..., `D99`. Os números são de chegada, para sempre, sem renumerar.
- **O registro** é o código, um `_` e **no máximo duas palavras**, ligadas por `_`, em minúsculas e sem acento: `D01_bagre_racao`. As palavras dizem do que é o conjunto (o animal e o assunto, por exemplo). É o nome da pasta em `data-raw/`, o identificador da ficha e o que vai na coluna `registro` do catálogo; a coluna `codigo` fica com `D01`.
- Exemplos: `D01_bagre_racao`, `D02_barbo_morfometria`, `D03_tubarao_cpue`, `D04_doubs_ambiente`. Duas palavras bastam para achar o conjunto; a descrição completa fica no título e na ficha.
- **O nome do objeto não muda**: o aluno continua digitando `bagre_racao_isoproteica` (`data(bagre_racao_isoproteica)`, `clara::bagre_racao_isoproteica`). O registro curto não é o nome do objeto, e o nome do objeto, depois de integrado, é definitivo.
- O primeiro conjunto, hoje `D001` e `D001_bagre_racao`, passa a `D01` e `D01_bagre_racao` (pasta, ficha, `preparar.R`, catálogo, título da ajuda, `LEIA-ME.md`). Os commits antigos ficam como estão.

## 2. Uma coluna no catálogo: o nome antigo no EAPADados

A Trilha, os testes e os projetos que os alunos já exportaram usam os nomes do EAPADados (`isoproteica_bagre`). Para a troca não quebrar nada, o catálogo precisa dizer de onde cada conjunto veio:

- `nome_eapadados`: o nome do objeto no EAPADados (`isoproteica_bagre`), ou vazio para os que não vêm de lá.

O D01 já tem essa coluna. Com ela, a Trilha troca os nomes antigos pelos novos num lugar só.

## 3. O que a Trilha lê em cada conjunto

Todos entram na passada 1. A ordem abaixo só diz quais a Trilha usa mais de perto e, por isso, convém integrar primeiro.

### 3.1 Os presos ao código da Trilha

A tela de importação lista todos os conjuntos sozinha, mas estes estão presos ao código pelo nome.

| Conjunto no EAPADados | Onde a Trilha depende dele | O que não pode mudar |
|------------------------|------------------------|------------------------|
| `isoproteica_bagre` | testes da ANOVA, do Kruskal-Wallis e da rota ClaRa | **já pronto** como `D01_bagre_racao`; as colunas `racao` (fator) e `peso_g` são lidas pelo nome nos testes e no dicionário da exportação |
| `morfometria_barbo` | exemplo da regressão; o exportador escreve textos próprios para ele (Introdução, Métodos, Discussão, com a referência `takacs2022`) | as colunas `altura_maxima_corpo`, `distancia_dorsal_pelvica`, `comprimento_cabeca`, `distancia_pre_peitoral` e `populacao` (fator, cinco níveis) são lidas pelo nome; as medidas são corrigidas pelo comprimento padrão, e isso precisa continuar dito na documentação |
| `cpue_tubarao` | a tela de Séries Temporais carrega ele direto, como exemplo | precisa de uma coluna de data (classe `Date`) e de uma resposta numérica; a tela acha a data pelo nome (`data`, `date`, `ano`, `year`, `mes`), então a tradução de `Year`, `Month` e `Data` para o português deve manter esses radicais |
| `doubs_ambiente` | o PCA abre com uma configuração própria para ele | as colunas `riqueza` (suplementar quantitativa) e `trecho` (fator, variável de grupo) são lidas pelo nome |
| `artemia` | é o conjunto que abre por padrão na importação; testes do Mann-Whitney | **não entra**: o professor recusou o sintético. A fonte real (`artemia_fitoesterois`) entra como conjunto próprio, com os nomes dela, e a Trilha troca o conjunto padrão e os testes |

### 3.2 Os usados pelos testes da Trilha

| Conjunto no EAPADados | Teste da Trilha | Observação |
|------------------------|------------------------|------------------------|
| `abalone_adultos` | cinco testes da exploração e da descrição | os testes leem `sexo` e as medidas numéricas |
| `salvelino_formalina_remocao` | ANOVA de dois fatores | hoje o teste o lê de `EAPADados/data-raw/`, não de `data/` |
| `camarao_vannamei_biometria` | roteiro antigo da regressão |  |
| `pinguins` | guia de exploração |  |

### 3.3 A lista de segurança da importação

Se o pacote de dados faltar, a importação usa uma lista fixa de oito conjuntos, e a exportação tem um dicionário de variáveis escrito à mão para sete deles: `artemia`, `biometria_caranguejos`, `camaroes_sexo`, `cangulo_crescimento`, `captura_petrechos`, `isoproteica_bagre`, `tilapia_crescimento` e `walleye_erie`. Na troca, a Trilha passa a tirar essa lista do catálogo; os que não estiverem no Núcleo 60 saem dela.

### 3.4 O resto

Os demais só aparecem no menu e seguem a ordem da aba Núcleo 60.

## 4. Pontos de curadoria já encontrados

- **`cangulo_crescimento`:** as colunas `ln_peso` e `ln_comp` parecem trocadas. `ln_peso` = 2,48 corresponde a ln(12), que é o comprimento de 12 cm da primeira linha, e `ln_comp` = 3,76 a ln(43), o peso. Pela regra do prompt, colunas derivadas que o aluno calcula na Trilha nem deveriam entrar. Na passada 1, anote nas pendências da ficha; se as colunas entrarem, que já entrem certas.
- **Autorização dos autores:** diga na coluna `situacao` do catálogo quais conjuntos ainda não têm autorização, como já faz o D01, para a Trilha marcá-los como provisórios ou escondê-los dos alunos.
- **Tamanho:** no máximo 3 MB para a pasta `data/` inteira, como diz o prompt. A Trilha lê o catálogo inteiro ao abrir, então ele também deve ficar pequeno.

## 5. O que fica com a Trilha (não faça)

A outra sessão não altera a `TRILHA/`. Quando todos os conjuntos da passada 1 estiverem na `main` da ClaRa, com a versão subida, a sessão da Trilha:

- revisa a integração: catálogo, registros, fichas, se os objetos batem com os do EAPADados, o tamanho e o `R CMD check`;
- faz a importação ler `clara::catalogo_dados`, e o EAPADados sai da Trilha;
- troca os nomes antigos pelos novos no código (conjunto padrão, Séries Temporais, PCA, textos do barbo no exportador, dicionário da exportação) e nos testes.

Os Projetos R exportados continuam levando uma cópia da planilha, então os já entregues aos alunos não quebram.

Na passada 2, quando o professor mudar colunas de um conjunto do item 3.1, a sessão da Trilha acompanha na mesma rodada. Avise o professor quando a passada 1 terminar. Só uma sessão trabalha por vez: a Trilha só começa depois disso.
