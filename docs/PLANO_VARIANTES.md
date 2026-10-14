# Plano das variantes de delineamento (14/10/2026)

Estado: planejamento aprovado em 14/10/2026. **Impacto implementado** (registro
em `modules/registro_variantes.R`, ficha com `variante` e `analises_previstas`);
os demais módulos seguem a ordem da seção 7. Este documento registra o que foi
decidido e o que ainda está em aberto.

## 1. A ideia

Cada módulo do menu "Planejando sua Pesquisa" guarda uma **característica
comum** (o que todos os desenhos daquele módulo compartilham). Dentro dele, uma
**variante** (um sub-delineamento) escolhida no topo da tela decide:

1. quais campos o formulário mostra;
2. a família de análises que o desenho comporta;
3. o texto da ficha de planejamento.

Ganho para o aluno: menos opções por tela, a pergunta de pesquisa conduz a
escolha, e a análise provável aparece **antes da coleta** ("planejar a coleta é
escolher o teste"). Ganho para o código: crescer é acrescentar uma entrada num
registro, sem mexer no resto.

## 2. Interface

- Um **dropdown de destaque**, bem desenhado, logo abaixo do nome do módulo,
  com o rótulo "Qual é o seu desenho?".
- As opções ficam **visíveis na tela**: ao lado ou abaixo do dropdown, um painel
  que muda com a escolha, com pergunta guia, mini-esquema do desenho (SVG, como
  na Trilha de Preparo), análise provável e um exemplo de pesca.
- O formulário é **montado no servidor** a partir da variante (`renderUI`), em
  vez de `conditionalPanel` espalhados.
- Textos claros e curtos, sem prolixidade.
- Um **segundo dropdown, menor**, dentro do cartão da UA, para "Como a UA é
  formada?" (ver seção 5.1), quando o módulo precisar.

## 3. Registro de variantes

Um arquivo por família de módulos, no molde de `registro_tratamentos.R`. Cada
entrada declara:

| Campo | Para quê |
|---|---|
| `rotulo` | nome no dropdown |
| `pergunta_guia` | a pergunta de pesquisa que leva a esta variante |
| `esquema` | mini-desenho SVG |
| `campos` | quais campos do formulário aparecem e seus valores iniciais |
| `analises` | lista de análises possíveis, cada uma com `id`, rótulo curto e `principal` (TRUE/FALSE) |
| `ficha` | texto e campos que a variante grava na ficha |
| `avisos` | regras de alerta (ex.: poucas estações para regressão) |

Crescer = acrescentar uma entrada. Nenhum outro arquivo muda.

## 4. Ficha de planejamento

`ficha_planejamento.R` já tem `tipo` e `analise_sugerida`. Passa a ter:

- `variante`: id da variante escolhida;
- `analises_previstas`: as análises **marcadas** pelo aluno (caixas de
  marcação, letra pequena; as principais já vêm marcadas);
- `analise_sugerida` continua existindo e vira a primeira marcada, para não
  quebrar quem já a lê.

Na tela de cada análise, o aviso "Sugestão do planejamento"
(`ficha_aviso_analise_ui`) passa a dizer se a análise está **prevista** ou
**não prevista** na ficha. Isso declara as análises antes da coleta e reforça a
postura anti-p-hacking do ecossistema.

## 5. Variantes por módulo

### 5.1 Observacionais

**Impacto** (fechado): CI, BA e BACI. Já existem no código (`tipo_impacto`).

| Variante | Pergunta guia | Análises (principal em negrito) |
|---|---|---|
| CI (controle–impacto) | Sítio afetado × sítio de referência, só depois | **t de duas amostras**, Mann-Whitney, ANOVA se houver vários sítios |
| BA (antes–depois) | O mesmo sítio, antes e depois | **t pareado**, Wilcoxon pareado |
| BACI | Antes–depois com sítios de referência | **ANOVA de dois fatores com interação (período × condição)**, sítio como unidade de réplica |

**Transversal comparativo.** Característica comum: cada UA é medida **uma única
vez**.

| Variante | Análises |
|---|---|
| Um fator (espécie, sexo, local específico, faixa) | **t**, **ANOVA de um fator**, Kruskal-Wallis |
| Dois fatores | **ANOVA de dois fatores**, ANCOVA |
| Fator com sítios dentro das categorias | **ANOVA nos sítios**, modelo misto |
| Tempo como fator (UAs diferentes em cada tempo) | **ANOVA de um ou dois fatores** |

Fronteira com o longitudinal, que deve aparecer escrita e curta na interface:

- Se **a mesma UA** é medida de novo (mesma mesa, mesmo viveiro), é
  **longitudinal**, mesmo que os indivíduos mudem (amostragem destrutiva).
- Se **as UAs são diferentes** em cada tempo (novos peixes, novos pontos), é
  **transversal com tempo como fator**.

Sobre "locais" e "ambientes": locais específicos e ambientes específicos são a
mesma coisa e entram em "um fator". Só **categorias de ambientes com vários
sítios** pede variante própria, porque o sítio é a unidade de réplica e medir
vários pontos no mesmo reservatório é pseudo-réplica. Faixas ordenadas viram
opção de "um fator com níveis ordenados".

**Como a UA é formada** (segundo dropdown, menor; na tela, "composição da UA" no
lugar de "pool"; a coluna `pool` pode continuar internamente):

| Caso | Exemplo | Medidas por UA | Consequência |
|---|---|---|---|
| UA individual | um peixe | 1 | caso simples |
| UA composta | bexigas de vários peixes; água ou solo combinados de várias profundidades | 1 (a mistura é medida uma vez) | variância entre indivíduos se perde; aviso se a composição for desigual entre grupos |
| UA-conjunto, já formada | mesa de ostras, viveiro | vários indivíduos | indivíduos são subamostras, não réplicas: resumir por UA ou modelo misto |

**Gradiente.** A variante muda a **planilha** e a análise sugerida.

| Variante | Análises |
|---|---|
| Gradiente contínuo (muitas estações, ≥ 5 ou 6) | **regressão linear**, não linear |
| Gradiente em poucos níveis (2 a 4 pontos ordenados) | **ANOVA de um fator** com contraste de tendência |
| Gradiente com dois eixos | **regressão múltipla**, ANOVA de dois fatores |

**Longitudinal.** **Fica por último.** O conceito de linha de base e a divisão
em variantes só serão decididos depois de Impacto e Transversal prontos.
Hipótese em estudo: linha de base como *opção*, e variantes por número de
grupos (um grupo, vários grupos) e por UA marcada × amostragem destrutiva da
mesma UA.

**Monitoramento (séries temporais).** Característica comum: acompanhar os mesmos
locais ao longo do tempo. Variantes pela frequência, esforço e número de
grupos:

| Variante | Análises |
|---|---|
| Série simples (um local) | série temporal, tendência e sazonalidade |
| Vários locais ou grupos (mesmo calendário) | série por grupo, comparação de tendências entre dois ou três grupos ou categorias |
| Com esforço registrado (ex.: CPUE) | resposta padronizada pelo esforço antes da análise |

A diferença para o longitudinal: no monitoramento a série é o objeto; no
longitudinal, UAs marcadas são acompanhadas para comparar trajetórias.

### 5.2 Experimentais

Quatro módulos, pelo arranjo do controle da variação:

| Módulo | Variantes |
|---|---|
| DIC | um fator; dois fatores (fatorial em DIC) |
| DBC | um fator; dois fatores (fatorial em DBC) |
| DQL | um fator |
| Split-plot | parcela principal × subparcela |

O painel "Fatorial (em DIC)" some do menu e vira a variante "dois fatores" de
DIC e de DBC.

## 6. Compatibilidade com o código

- Os testes (`test_observacional_impacto.R`, `test_transversal_saidas.R`,
  `test_observacional_gradiente.R`, `test_observacional_longitudinal.R`) amarram
  **nomes de inputs**. Manter nomes e valores como `input$tipo_impacto` quando
  possível; o que muda é a montagem da tela (de `conditionalPanel` para
  `renderUI`). Se um nome precisar mudar, atualizar o teste na mesma etapa.
- Cada módulo é feito **em etapa própria**; a suíte de testes roda ao fim de
  cada etapa.
- `tipo_resolvido` (junção de `transversal` e `comparativo`) continua: o módulo
  chama-se "transversal comparativo" e ganha as variantes.

## 7. Ordem de trabalho

Primeiro os **observacionais**, depois os experimentais, depois o
monitoramento, e o longitudinal por último.

1. Contrato do registro de variantes e extensão da ficha (`variante`,
   `analises_previstas`).
2. Componente do dropdown de destaque com painel de explicação, reaproveitável.
3. **Impacto** (piloto), **já com as caixas de análises**.
4. **Transversal comparativo**, com o dropdown "Como a UA é formada?".
5. **Gradiente**.
6. **Experimentais** (DIC, DBC, DQL, Split-plot; fusão do fatorial).
7. **Monitoramento**.
8. **Longitudinal**.
9. Quadro "desenho → análise provável" no livro (Unidade II, "Antes da
   análise"), derivado do mesmo registro.

**Regra de processo:** antes de começar cada módulo, o assistente apresenta um
**resumo do que vai fazer** e só implementa depois da aprovação.

## 8. Fora do v1 (a avaliar depois)

Depois de fechado o registro, fazer uma busca para estimar a **cobertura** dos
desenhos nas ciências agrárias, zootecnia e recursos pesqueiros e bioecológicos.
Candidatos já apontados que costumam ficar de fora:

- medidas repetidas em experimentos;
- látice e blocos incompletos;
- parcelas subsubdivididas;
- análise conjunta de experimentos;
- delineamentos com covariável (ANCOVA).

Cada um será avaliado depois: vira módulo, vira variante de um módulo existente
ou fica para versão futura. Entra no v1 só o que for necessário e fácil de
implementar.

## 9. Pendências

- Texto exato das perguntas guia e dos mini-esquemas (a definir ao refazer a
  interface de cada módulo).
- **Fatorial:** decidido em 14/10/2026. Funde-se no DIC e no DBC, e cada um
  tem duas opções (um fator; dois fatores). Sem pendência.
- Longitudinal: ver seção 5.1.
