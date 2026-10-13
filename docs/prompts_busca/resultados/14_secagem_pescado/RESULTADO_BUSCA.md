# Busca 14 — secagem de pescado

## Decisão (13/10/2026)

Selecionado, por decisão do professor, o recorte de **80 °C** de Ohijeagbon
et al. (2018). É uma exceção consciente ao alvo inicial de três curvas com dez
ou mais pontos: há uma única curva, mas ela é completa, tabular, aberta e tem
dez medições de 0 a 540 min. O uso didático será a regressão não linear de uma
curva de massa, não a comparação inferencial entre temperaturas.

## Fonte e direitos — conferidos

- Ohijeagbon, I. O.; Lasode, O. A.; Adebayo, S.; Ajayi, O. O.; Omotosho, O. A.
  (2018). *Data on drying kinetics of a semi-automated gas-fired fish dryer*.
  **Data in Brief**, 18, 641–647. DOI:
  [10.1016/j.dib.2018.03.072](https://doi.org/10.1016/j.dib.2018.03.072).
- Texto, licença e tabelas: [PMC5996308](https://pmc.ncbi.nlm.nih.gov/articles/PMC5996308/).
- Licença declarada no artigo: **CC BY 4.0**. Ela permite copiar, adaptar e
  redistribuir com atribuição.
- Produto: bagre-africano (*Clarias gariepinus*) em secador a gás.

## Arquivo preparado

`secagem_bagre_80c_fonte.csv` é uma transcrição literal das colunas de 80 °C
das Tabelas 1 e 2 do artigo. Tem dez linhas e seis campos:

| Campo | Papel |
|---|---|
| `tempo_min` | tempo desde o início, em minutos |
| `massa_peixe_kg` | resposta primária, medida observada |
| `massa_gas_kg` | massa de gás usada, como publicada |
| `temperatura_secador_c` | temperatura medida no secador |
| `umidade_publicada_kg_agua_por_kg_peixe_seco` | valor calculado pelos autores, preservado somente como referência |
| `energia_utilizada_mj` | valor calculado pelos autores |

## Limites que devem acompanhar o conjunto

- Há **uma curva** a 80 °C, sem réplicas: ela ensina forma funcional, patamar,
  ajuste de Lewis/Page/Henderson-Pabis e diagnóstico de resíduos; não testa
  efeito de temperatura.
- A variável para a aula é `massa_peixe_kg`. A coluna de umidade não entra no
  ajuste inicial: o rótulo do artigo é base seca, mas seu valor inicial não é
  conciliável diretamente com as massas publicadas e o final é 0,000. Ela fica
  preservada para uma discussão de documentação, unidades e dados derivados.
- Não inventar uma massa seca nem converter essa umidade até localizar ou obter
  a memória de cálculo dos autores.

## Pergunta didática sugerida

> Como a massa de um lote de bagre muda durante 9 horas de secagem a 80 °C, e
> qual modelo não linear descreve melhor a aproximação ao valor final?

O zero de tempo e os nove intervalos horários tornam o exemplo curto o bastante
para a primeira aula de `nls()`. O termo assintótico deve ser interpretado como
**massa final estimada nas condições do experimento**, não como massa seca
> comprovada.

## Teste de regressão (13/10/2026)

O teste foi executado em R 4.6.1, sem alterar os dados. A resposta foi a massa
relativa, `massa_peixe_kg / 8.53`, para tornar a curva comparável a uma razão de
umidade sem inventar uma massa seca.

| Modelo | AIC | RMSE | R² |
|---|---:|---:|---:|
| Page, `exp(-(k * tempo)^n)` | -50,16 | 0,0146 | 0,9968 |
| Linear, `massa_relativa ~ tempo` | -43,09 | 0,0208 | 0,9935 |
| Lewis, `exp(-k * tempo)` | -27,10 | 0,0511 | 0,9605 |

No modelo de Page, `k = 0,002416 min^-1` (IC aproximado de 95%: 0,002336 a
0,002494) e `n = 1,421` (1,309 a 1,540). Portanto, há uma curva de decaimento
não linear bem ajustada e ela vence a reta e Lewis pelos critérios acima.

Ressalva: ao permitir uma assíntota de massa livre, ela converge para zero; as
dez medições não demonstram um patamar físico acima de zero. A atividade deve
ensinar **curvatura de decaimento e comparação de modelos**, não estimar massa
seca nem extrapolar, por exemplo, para 720 min.
