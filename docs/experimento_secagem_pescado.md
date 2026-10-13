# Experimento de secagem de pescado — plano

Escrito em 13/10/2026 para substituir `secagem_beterraba_gengibre` (D52) por dados
próprios, depois de as buscas 14 e de teses brasileiras não acharem curvas de
secagem de pescado com dados brutos e licença aberta.

## A pergunta

> **A que taxa um filé de peixe perde água na estufa, e quanto a temperatura e a
> salga mudam essa taxa?**

Dessa pergunta saem quatro lições do livro e da Trilha, com um só conjunto de
dados:

| Lição | Com que parte dos dados |
|---|---|
| Regressão não linear (`nls()`): Lewis, Page, Henderson-Pabis, logarítmico; comparar ajustes e ver por que a reta erra o patamar | uma curva (uma amostra) |
| Uma curva por amostra: a unidade amostral é a amostra, não a pesagem | todas as curvas |
| Regressão linear na escala de Arrhenius: ln *k* × 1/*T* | o *k* de cada curva |
| ANOVA de dois fatores com bloco: temperatura × salga, dia como bloco | o *k* de cada curva |

A salga dá o contexto (o peixe salgado-seco é o produto da pesca artesanal do
Norte e do Nordeste) e um segundo fator com efeito esperado nítido: o sal tira
água por osmose e muda a velocidade da secagem.

## Desenho (versão recomendada)

**Fatorial 3 × 2 em blocos, com 3 amostras por tratamento em cada corrida.**

- **Temperatura:** 50, 60 e 70 °C (estufa com circulação forçada de ar).
- **Pré-tratamento:** sem sal × salmoura (150 g de NaCl por litro, 1 h na
  geladeira, depois escorrer e secar a superfície com papel-toalha).
- **Bloco = dia (corrida):** cada temperatura roda em **2 dias diferentes**. Em
  cada corrida vão 6 amostras: 3 sem sal e 3 salgadas, em posições sorteadas na
  bandeja.

| | 50 °C | 60 °C | 70 °C |
|---|---|---|---|
| Dia A | 3 sem sal + 3 salgadas | idem | idem |
| Dia B | 3 sem sal + 3 salgadas | idem | idem |

Total: **6 corridas, 36 curvas, cerca de 15 pesagens por curva ≈ 540 medições**.

Por que repetir cada temperatura em dois dias: com uma só corrida por
temperatura, "temperatura" e "dia" ficam misturadas (o peixe, a umidade da
sala e a estufa daquele dia). As 3 amostras dentro da mesma corrida são réplicas
da salga, mas não da temperatura. Dois dias por temperatura dão réplica
verdadeira, e a diferença entre as duas situações vira uma aula sobre
pseudorrepetição.

**Se houver duas ou três estufas**, melhor ainda: rodar as três temperaturas no
mesmo dia, e cada dia vira um bloco completo. Com isso bastam 2 dias de trabalho
em vez de 6.

**Versão mínima** (se faltar tempo): 3 corridas, uma por temperatura, ou 18 curvas
e cerca de 270 medições. Serve para todo o `nls()`; a comparação entre
temperaturas fica descritiva.

## Matéria-prima e amostras

- **Peixe:** filé de tilápia congelado comercial (espessura e composição
  uniformes, fácil de comprar de novo) ou uma espécie local de carne branca e
  magra (pescada-amarela, serra). Um só lote para o experimento inteiro, comprado
  de uma vez e mantido congelado; descongelar na geladeira na véspera de cada
  corrida.
- **Corte:** tiras de **5 × 3 cm com 0,5 cm de espessura** (cerca de 8–10 g),
  sem pele e sem a parte fina da barriga. A espessura é a variável que mais pesa
  na secagem: medir com paquímetro e anotar. Com 0,5 cm, a curva chega perto do
  patamar em um expediente; o piloto confirma.
- **Suporte:** cada amostra sobre um quadrado de tela de aço inox ou alumínio
  numerado (pesado vazio antes), para pesar sem tocar no peixe.

## Medições

1. **Antes:** massa da tela vazia; espessura; massa inicial da amostra (tempo 0).
2. **Durante:** pesar nos tempos **0, 10, 20, 30, 45, 60, 75, 90, 120, 150, 180,
   210, 240, 300 e 360 min** (15 pontos; mais densos no começo, onde a curva
   cai rápido). Tirar a bandeja, pesar as 6 amostras na mesma ordem e devolver
   em menos de 2 min. Anotar a hora real de cada pesagem.
3. **Depois:** levar cada amostra à estufa a **105 °C por 24 h** para obter a
   **massa seca daquela amostra**. Com isso cada curva tem a própria matéria
   seca, inclusive as salgadas, em que o sal entra como sólido.
4. **Ambiente:** temperatura real da estufa (termômetro independente, a cada
   hora) e temperatura e umidade relativa da sala no início e no fim da corrida.

Balança analítica ou semianalítica com precisão de **0,01 g**.

Com a massa seca *m*ₛ, a umidade em base seca em cada instante é
*X*(*t*) = (*m*(*t*) − *m*ₛ) / *m*ₛ e a razão de umidade é
*MR* = *X*(*t*) / *X*₀. A planilha guarda **só as massas**; as contas ficam
para o aluno fazer, como etapa da Trilha de Preparo.

## Planilha de campo (formato *tidy*)

Aba `pesagens`, uma linha por pesagem:

| corrida | data | temperatura_c | pre_tratamento | amostra | posicao | tempo_min | hora | massa_bruta_g | observacao |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 2026-11-03 | 60 | salmoura | 1-S2 | 4 | 30 | 09:12 | 14.87 | |

Aba `amostras`, uma linha por amostra: `amostra`, `corrida`, `pre_tratamento`,
`posicao`, `tela_g`, `espessura_mm`, `massa_seca_bruta_g`.

Aba `corridas`: `corrida`, `data`, `temperatura_c`, `temp_real_media_c`,
`sala_temp_c`, `sala_ur_pct`, `responsavel`.

A massa da tela fica separada (`massa_bruta_g` − `tela_g`): isso exercita um
cálculo na Trilha e evita erro de conta à mão no laboratório.

## Cronograma

| Etapa | Duração |
|---|---|
| Compra do lote, corte de teste, pesagem das telas | 1 dia |
| **Corrida piloto** a 60 °C (confirma tempos, espessura e se 6 h chegam perto do patamar) | 1 dia |
| 6 corridas, ordem das temperaturas sorteada | 6 dias (2 com três estufas) |
| Massa seca a 105 °C | +1 dia após cada corrida |

## Cuidados

- **Sortear** a ordem das temperaturas entre os dias e a posição das amostras na
  bandeja: estufa tem gradiente de temperatura entre a frente e o fundo.
- Abrir a estufa só nas pesagens e sempre pelo mesmo tempo.
- Amostra que cair, rasgar ou grudar: anotar em `observacao` e **não apagar** a
  linha. Isso também ensina.
- Higiene de manipulação de pescado; o material seco não é para consumo.

## Variante solar (opcional, para o contexto)

Se houver secador solar: **secador solar × sol aberto**, lado a lado, amostras
salgadas (o produto artesanal), 3 por condição, pesando de hora em hora das 8 h
às 17 h, por 3 dias; à noite as amostras vão cobertas para dentro. Registrar a
temperatura e a umidade dentro e fora do secador a cada pesagem. As curvas não
são isotérmicas e mostram a reabsorção noturna: é um bom segundo conjunto para
discussão, mas não substitui a estufa para ensinar os modelos.

## Depois do experimento

- Os dados entram no EAPADados no lugar de `secagem_beterraba_gengibre`, com
  nome e documentação em português.
- **Depositar a planilha bruta no Zenodo com CC BY 4.0** e citar o DOI no pacote,
  para que o próximo professor que procurar curvas de secagem de pescado com
  dados abertos encontre estas.
