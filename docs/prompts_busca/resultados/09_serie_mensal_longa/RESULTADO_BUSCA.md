# Busca 09 — série mensal longa

Busca realizada em **12/10/2026**, conforme
`TRILHA/docs/prompts_busca/09_serie_mensal_longa.md`.

**Recomendação:** usar os **desembarques mensais de anchova-do-norte
(*Engraulis mordax*) na Califórnia, agregados no conjunto em todos os portos,
de **janeiro de 1971 a dezembro de 1991**. O recorte tem 252 meses
consecutivos, todos positivos, traz uma safra anual bastante visível e uma
queda marcada entre as décadas de 1970 e 1980. É uma série de pesca, em vez
de um substituto ambiental, e já vem com mês, ano e valor de desembarque.

Esta é uma triagem documentada: nenhum conjunto foi incorporado ao pacote,
traduzido ou modificado. As cópias de fonte nesta pasta servem apenas para
conferir a busca.

## 1. Anchova-do-norte: desembarques mensais da Califórnia — recomendado

**Título:** *California Fish Market Catch Landings, Short List, 1928–2002,
Monthly*. **Órgãos:** California Department of Fish and Game (fonte) e NOAA
NMFS Southwest Fisheries Science Center / Environmental Research Division
(montagem e distribuição). Página de metadados:
[ERDDAP/NOAA](https://coastwatch.pfeg.noaa.gov/erddap/info/erdCAMarCatSM/index.html).

O próprio metadado não aponta um artigo ou DOI específico para este recorte;
portanto, não atribuo um DOI. A documentação do órgão da Califórnia confirma
que as fichas de desembarque registram espécie, peso, data, porto e arte de
pesca, e que suas visualizações públicas oferecem desembarques mensais desde
1980. O artigo do CALFISH encontrado na busca é apenas contextual, não foi
tratado aqui como artigo associado ao arquivo escolhido.

**Licença conferida:** o atributo `license` da página do próprio ERDDAP diz
que os dados “may be used and redistributed for free” e traz apenas a ressalva
de não uso legal/garantia. É uma distribuição pública de um órgão
governamental dos EUA, com permissão explícita de redistribuição; não é
rotulada CC0 ou CC BY. Registre essa frase e o crédito à Califórnia/NOAA no
README do pacote, em vez de rebatizar a licença.

**Arquivo direto aberto:**
[Anchovy, Northern — All ports, NetCDF clássico](https://coastwatch.pfeg.noaa.gov/erddap/files/erdCAMarCatSM/All/Anchovyx2cx20Northern.nc).
O arquivo foi baixado e lido. Tem 900 meses de janeiro de 1928 a dezembro de
2002 e as variáveis `time`, `year`, `fish`, `port` e `landings` (libras).
Escolhi o segmento contínuo de 1971–1991 porque satisfaz a exigência de valor
positivo sem tratar zeros como faltantes.

Em 12/10/2026, a mesma consulta foi obtida também como CSV diretamente do
ERDDAP, filtrada para a categoria e o intervalo recomendados. A segunda linha
desse CSV (`UTC,,,,pounds`) descreve as unidades; não é uma observação.

**O que mede:** peso desembarcado de anchova-do-norte em todos os portos da
Califórnia, em **libras**. É desembarque comercial bruto agregado, não CPUE e
não abundância de peixes no mar. Uma linha da série é um mês; `fish` é sempre
`Anchovy, Northern` e `port` é sempre `All` no arquivo selecionado.

| Conferência do recorte recomendado | Resultado |
|---|---:|
| Primeiro / último mês | 1971-01 / 1991-12 |
| Meses esperados e presentes | 252 / 252 |
| Meses faltantes | 0 |
| Zeros | 0 |
| Média | 7.677.088,20 lb |
| Mínimo | 4.950 lb |
| Máximo | 60.042.632 lb |
| ACF no atraso 1 / 12 | 0,5956 / 0,5224 |

**Padrão visto:** há valores médios baixos em julho–agosto (449.665 e
1.270.535 lb) e picos em outubro–janeiro; novembro é o maior mês médio
(14.419.967 lb). A inclinação linear simples é de aproximadamente
**−1.008.499 lb por ano**. A média mensal foi 13.967.322 lb em 1971–1980 e
1.958.694 lb em 1981–1991: uma ruptura/queda didaticamente muito clara. A
ACF positiva nos atrasos 1 e 12 sustenta a conversa sobre dependência entre
meses e sobre o que sobra nos resíduos depois de retirar tendência e
sazonalidade.

**Segunda série:** não há uma covariável ambiental no NetCDF conferido. Não
tratar as séries por porto como covariáveis independentes: elas são partes do
mesmo total. Uma extensão posterior pode parear SST ou clorofila pública do
mesmo litoral, mantendo fontes e unidades separadas.

**Limpeza e ressalvas:** NetCDF clássico, nomes em inglês, unidade em libras e
datas centradas no dia 16 do mês; para o material didático, criar `data` como
`AAAA-MM-01`, converter libras para toneladas métricas se isso for explicado,
e manter o valor original/crédito. A descrição de `fish` do metadado alerta que
uma categoria de mercado não é necessariamente uma espécie; neste caso, o
nome é “Anchovy, Northern”, mas a apresentação deve chamá-la de **categoria de
mercado de anchova-do-norte**, não prometer biometria ou estoque puro.

No arquivo completo há dois zeros posteriores ao recorte (1993-01 e 1998-02).
Não os troque por `NA`. Eles são o motivo de preferir 1971–1991 a 1971–2000
para a primeira atividade. O fechamento em 1991 é uma escolha didática de
recorte, não o fim do conjunto de origem.

**Cobertura:** gráfico de série, decomposição aditiva ou multiplicativa após
inspecionar a amplitude, ACF/PACF, regressão com tempo e mês, diagnóstico dos
resíduos e previsão simples. A série de desembarque pode ter fechamento,
regulação, mercado e esforço misturados à disponibilidade do peixe; uma
previsão é previsão de desembarque, não estimativa de população.

**Pergunta para o aluno:** “Os desembarques mensais de anchova-do-norte na
Califórnia diminuíram de 1971 a 1991 depois de considerar a safra anual, e os
resíduos ainda são autocorrelacionados?”

## 2. Chuva mensal em Belém — boa opção brasileira, mas licença a esclarecer

**Título:** *Global Historical Climatology Network (GHCN) Monthly
Precipitation, Version 4*. **Autores:** Scott Applequist, Imke Durre e Russell
Vose (2024), NOAA NCEI. [DOI do conjunto](https://doi.org/10.25921/67zp-5m03);
[artigo associado](https://doi.org/10.1038/s41597-024-03457-z).

**Arquivo direto aberto:**
[BRM00082191.csv — Belém](https://www.ncei.noaa.gov/data/ghcnm/v4/precipitation/access/BRM00082191.csv), CSV sem cabeçalho. O
[leia-me oficial](https://www.ncei.noaa.gov/data/ghcnm/v4/precipitation/doc/ghcn-m_v4_prcp_readme.txt)
define a coluna de mês (`AAAAMM`), a precipitação em décimos de milímetro e as
flags. O inventário oficial identifica a estação `BRM00082191` como Belém,
com registro de 1923 a 2026.

**Licença:** a página de metadados da GHCN pede a citação e informa as
ressalvas de responsabilidade, mas **não declara CC0, CC BY ou uma licença de
redistribuição nominal**. Como há fontes internacionais no arquivo, não é
prudente deduzir domínio público somente por ele estar hospedado pela NOAA.
Assim, esta candidata é tecnicamente excelente, mas fica **pendente de
confirmação formal de licença para redistribuí-la dentro do EAPADados**. Não
incorporar antes disso.

**O que mede:** precipitação mensal acumulada em Belém, Pará, em milímetros;
é uma observação/compilação meteorológica, não pesca. Para 1982–2021 o arquivo
tem 478 linhas válidas, de 1982-01 a 2021-12. Faltam exatamente **1992-09** e
**1994-12** (não são linhas com `NA`, mas meses ausentes do CSV).

| Medida, 1982–2021 | Resultado |
|---|---:|
| Meses esperados / presentes | 480 / 478 |
| Média | 273,58 mm |
| Mínimo / máximo | 8,0 / 931,0 mm |
| Mês médio mais úmido | março: 481,48 mm |
| Mês médio mais seco | outubro: 132,36 mm |
| Inclinação linear simples | +1,66 mm/ano |

Há um ciclo anual muito visível: janeiro–abril concentram a chuva, enquanto
julho–novembro são mais secos. A tendência linear é discreta frente à
variabilidade; a média anual mínima é 192,3 mm em 1983 e a máxima, 375,7 mm em
2020. A série serve muito bem para decomposição, ACF/PACF e previsão, mas os
dois buracos precisam aparecer no roteiro: interpolar só para a demonstração
de decomposição/ACF, ou separar o trecho, nunca apagá-los silenciosamente.

**Segunda série:** não veio outra variável no arquivo aberto. Há pequenas
mudanças no nome/coordenada/altitude da estação ao longo do registro; documentar
isso como possível descontinuidade de observação. As flags de qualidade estão
vazias no recorte e o campo de fonte muda conforme a compilação. O formato sem
cabeçalho, os valores em décimos de mm e os dois meses ausentes são as limpezas
necessárias.

**Pergunta para o aluno:** “Qual é a estação chuvosa de Belém e quanto da
dependência mensal resta depois de retirar a sazonalidade?”

## 3. Nível médio mensal do Lago Huron — plenamente licenciado, porém distante do contexto

**Título:** *Water Level — Verified Monthly Mean*. **Órgão:** NOAA NOS,
Center for Operational Oceanographic Products and Services (CO-OPS).
[Página do conjunto](https://catalog.data.gov/dataset/water-level-verified-monthly-mean);
[coleção arquivada/DOI](https://doi.org/10.25921/dt9g-2p60).

**Licença conferida:** **CC0 1.0**, no campo `license` da página do data.gov.
O metadado do ERDDAP também afirma que informações em servidores governamentais
estão em domínio público, salvo anotação contrária, e podem ser usadas
livremente. É o candidato de licença mais simples desta busca.

**Arquivo direto aberto:**
[consulta JSON da API CO-OPS: Harbor Beach, 1982–2021](https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?begin_date=19820101&end_date=20211231&station=9075014&product=monthly_mean&datum=IGLD&time_zone=gmt&units=metric&format=json&application=eapa).
O JSON foi baixado e lido. A estação 9075014 fica em Harbor Beach, Michigan,
no Lago Huron. A resposta traz `year`, `month`, `MSL`, `highest`, `lowest` e
o indicador `inferred`.

**O que mede:** nível médio mensal da água (`MSL`) em metros, no datum IGLD;
é valor ambiental contínuo, não uma medida de captura. No recorte há 480 meses
de 1982-01 a 2021-12, sem lacunas e sem valores inferidos.

| Medida | Resultado |
|---|---:|
| Média / mínimo / máximo | 176,492 / 175,592 / 177,493 m |
| Meses faltantes / inferidos | 0 / 0 |
| ACF no atraso 1 / 12 | 0,9874 / 0,8217 |
| Inclinação linear simples | −5,916 mm/ano |

O ciclo médio sobe de cerca de 176,36 m em fevereiro para 176,65 m em julho e
recuo posterior; a amplitude sazonal média é aproximadamente 0,29 m. A série
também mostra uma descida até os mínimos anuais de 2003/2013 e forte recuperação
até 2019–2020. Essa não linearidade é uma boa advertência contra interpretar
uma única reta como toda a história.

As colunas `highest` e `lowest` não são segunda série independente — são
resumos do mesmo nível d'água. A limpeza é simples: converter `year`/`month`
em data mensal, manter `MSL` e preservar o datum. Ele cobre decomposição,
ACF/PACF, tendência, previsão e discussão de ruptura. Seu defeito é didático:
é ambiental e de um lago norte-americano, com ligação apenas indireta a habitat
e pesca costeira.

**Pergunta para o aluno:** “Como a sazonalidade e a autocorrelação do nível
do Lago Huron mudam a previsão para os próximos meses?”

## Comparação e decisão

| Candidato | Tema | Licença verificada | Recorte que atende | Sazonalidade / ruptura | Decisão |
|---|---|---|---|---|---|
| Anchova-do-norte, Califórnia | Desembarque pesqueiro | Permite uso e redistribuição gratuita no ERDDAP/NOAA | 252 meses, 1971–1991, sem lacunas nem zeros | Forte / queda muito clara | **Recomendar** |
| Chuva, Belém | Ambiente amazônico | Sem licença nominal na página GHCN | 478 de 480 meses, 1982–2021 | Muito forte / tendência fraca | Reserva, confirmar licença |
| Nível do Lago Huron | Ambiente aquático | CC0 | 480 meses, 1982–2021, sem lacunas | Clara / mudança de nível | Reserva plenamente aberta |

O candidato recomendado oferece o melhor encaixe no objetivo: é pesca
comercial real, tem uma única resposta mensal simples, tamanho adequado,
sazonalidade e tendência/ruptura que se leem no gráfico, e a dependência serial
é material. Para a adaptação didática, a decisão mais honesta é explicar que
desembarques não equivalem diretamente à abundância e que a transformação de
libras para toneladas, se adotada, é uma transformação de unidade, não uma nova
medida.

## Evidências locais

- `california_anchovy_northern_all_fonte.nc`: NetCDF original baixado da
  distribuição ERDDAP/NOAA; dele foram conferidos os 900 meses e o recorte
  recomendado.
- `california_anchovy_northern_all_1971_1991_fonte.csv`: resposta CSV original
  da consulta ERDDAP para `Anchovy, Northern`, `All`, 1971–1991. A linha de
  unidades foi preservada como recebida.
- `anchova_norte_california_1971_1991_bruto.csv`: cópia tabular de trabalho,
  com 252 observações. Só normaliza `data` para o primeiro dia de cada mês e
  nomeia os campos; `desembarque_lb` continua o valor original em libras.
- `ghcnm_v4_prcp_inventory_fonte.txt` e
  `ghcnm_v4_precip_belem_82191_fonte.csv`: inventário e CSV oficiais da GHCN,
  sem alterações.
- `noaa_coops_harbor_beach_mensal_1982_2021.json`: resposta original da API
  pública CO-OPS, sem alterações.

As estatísticas desta nota foram recalculadas diretamente dos arquivos-fonte.
O CSV tabular foi conferido contra os 252 meses esperados, de 1971-01 a
1991-12. Em 12/10/2026, o recorte passou a integrar o EAPADados como
`anchova_norte_california`, com colunas em português e a categoria de mercado
explicitamente identificada.
