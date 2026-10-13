# Busca 04 — captura com esforço de pesca

Busca realizada em **12/10/2026**, conforme `04_captura_esforco_offset.md`.

**Atualização após receber o CSV do autor: larvas de peixes de Catalina é o
candidato recomendado para adaptação didática.** Tem 58 eventos, esforço de
8,17–18,83 horas, 13,8% de zeros e contagens inteiras. A análise exploratória
mostra superdispersão forte e mudança de alguns efeitos com o offset. Há
limitações de delineamento e capturas extremas a explicar. Nenhum dado foi
incorporado ao pacote. Caranguejo-verde fica como reserva; Malawi foi rejeitado.

Foram pesquisados pesca científica/artesanal e repositórios Dryad e Mendeley,
incluindo buscas por dados brasileiros. Não foi necessário procurar exemplos de
outras áreas. Esta é uma triagem documentada, não um inventário exaustivo.

## 1. Caranguejo-verde: quatro iscas — arquivo conferido

**Título:** Data for: Comparison of catch per unit effort of invasive European
green crab (Carcinus maenas) across four bait types.
**Autores:** Brett Favaro, Mary Alliston Butt e Jonathan Bergshoeff (2020).
[Repositório e DOI](https://data.mendeley.com/datasets/65zmvmggsh/1).
[Artigo: Fisheries Research, 225, 105484](https://doi.org/10.1016/j.fishres.2020.105484).

**Licença conferida:** CC BY 4.0, seção **Licence** da página do Mendeley.
[ZIP direto](https://data.mendeley.com/public-files/datasets/65zmvmggsh/files/25521bcd-9d10-4ead-83b3-e54d757c9dbc/file_downloaded).
O ZIP foi baixado e os CSVs e scripts foram lidos; os scripts originais não foram
executados. Arquivo principal: `data/MAB_Overview.csv`.

**Contexto:** captura de *Carcinus maenas* em armadilhas Fukui, em Fox Harbour e
North Harbour, Placentia Bay, Newfoundland, Canadá. Uma linha é um lançamento de
armadilha, identificado por `TrapID`. A base bruta contém **176 linhas**;
as **140** do artigo resultam dos filtros do script original.

**Contagem:** `Total Catch`, indivíduos inteiros não negativos. **Esforço:** horas
por armadilha, calculadas de `Date In` + `Time Set` até `Date Out` + `Time Hauled`.
É preciso criar essa coluna; ela não vem pronta no CSV. Em R, usar explicitamente
`as.numeric(difftime(fim, inicio, units = "hours"))`, com fuso
`America/St_Johns`. Os comentários do script original sobre a unidade de
`as.numeric(End - Start)` são inconsistentes; não convém copiá-los.

| Medida calculada | Base bruta | Recorte dos autores |
|---|---:|---:|
| Linhas | 176 | 140 |
| Esforço mínimo (h) | 15,5333 | 23,4000 |
| Esforço máximo (h) | 27,0833 | 27,0833 |
| Mediana do esforço (h) | 24,0750 | 24,0833 |
| CV do esforço | 8,48% | 3,76% |
| Total capturado | 6.437 | 4.145 |
| Zeros | 1 (0,568%) | 1 (0,714%) |
| Média da contagem | 36,5739 | 29,6071 |
| Variância amostral da contagem | 1.197,9488 | 552,1971 |

O recorte reproduz o código original: esforço **> 22 horas** e exclusão de agosto.
São retirados 12 lançamentos curtos e 24 de agosto. Não aplicar esses filtros
silenciosamente: fazem parte das decisões analíticas do estudo, não de uma
correção de erro de digitação.

**Fatores e frequências:**

| Coluna | Base bruta | Recorte dos autores |
|---|---|---|
| `Bait` | `1_Herring`, `2_Mussels`, `3_Squid`, `4_Cod`: 44 cada | 35 cada |
| `Block` | A=56; B=56; C=32; D=32 | A=40; B=40; C=32; D=28 |
| `Location` | FH=112; NH=64 | FH=80; NH=60 |
| Mês, derivado da data inicial | junho=96; julho=56; agosto=24 | junho=92; julho=48 |

As iscas são arenque, mexilhões, lula e bacalhau. Os blocos A/B pertencem a FH e
C/D a NH: `Block` e `Location` não devem entrar juntos como fatores independentes.
Há repetição de posições e agrupamento por datas. O script original explicita
essa dependência e utiliza modelo misto; um GLM simples serve como exploração
didática, mas não substitui a análise inferencial do delineamento.

**Conferência do objetivo central:** ajustei Poisson com `Bait + Block`, com e sem
`offset(log(esforco_h))`, mantendo as mesmas linhas e fatores. Com offset,
deviance/gl foi **19,3683** na base bruta e **9,1879** no recorte dos autores;
Pearson/gl foi **21,7747** e **9,5306**, respectivamente. São sinais fortes de
dispersão residual nesses GLMs exploratórios, que também omitem a dependência
temporal. Média e variância marginais, sozinhas, não diagnosticam a dispersão
condicional do modelo.

| Razão de taxas versus arenque | Sem offset, bruta | Com offset, bruta |
|---|---:|---:|
| Mexilhões | 0,506988 | 0,506821 |
| Lula | 1,610248 | 1,610212 |
| Bacalhau | 1,880435 | 1,881045 |

Portanto, não há o contraste didático forte procurado. O intercepto muda de
unidade ao incluir o offset; isso não significa mudança do efeito da isca.
Além disso, a captura em armadilhas pode não crescer proporcionalmente ao tempo
por saturação, fuga ou esgotamento da isca. A proporcionalidade é uma hipótese
a avaliar, não uma consequência de haver uma coluna de duração.

**Limpeza:** contagem e datas/horários completos, durações positivas e IDs únicos
na tabela principal; traduzir códigos e interpretar datas em inglês. O CSV usa
quebras de linha redundantes. Para mapas, juntar `MAB_Positions.csv` por
`Position`, com `Lat` e `Long`. A tabela biométrica é outra unidade de observação
e tem registros `ND` e problemas de codificação documentados nos scripts.

**Cobertura:** Poisson/binomial negativa com esforço, exploração da CPUE e mapa
de posições. ANOVA/Kruskal–Wallis simples sobre todas as linhas ignorariam a
dependência; só considerar com desenho analítico adequado.

**Pergunta:** “Qual isca captura mais caranguejos por hora, levando em conta os
blocos de amostragem?”

**Parecer:** reserva para contagens/superdispersão e delineamento em blocos;
fraco como substituto principal de `ships`/`Insurance` para ensinar offset.

## 2. Larvas em armadilhas luminosas — arquivo conferido; candidato preferido

**Using light traps to assess larval fish and octopus paralarvae diversity and
ontogenetic structure around Santa Catalina Island, CA**, Katherine Dale,
Elena Pilch, Mary Gomes, Nora Laszlo, Adam Mercer e Rita Mehta (2025).
[Dryad](https://datadryad.org/dataset/doi:10.7291/D1S38T);
[artigo](https://doi.org/10.5343/bms.2024.0135).

**Licença:** CC0, declarada no campo `license` dos
[metadados do próprio Dryad](https://datadryad.org/api/v2/datasets/doi%3A10.7291%2FD1S38T);
os [termos vinculados à página](https://datadryad.org/terms) também explicitam CC0
para datasets. Não confundir com a licença do conteúdo institucional do site.

[CSV direto: Dale_Light_Trap_Data_Dryad.csv](https://datadryad.org/downloads/file_stream/4344097).
O download automático inicialmente falhou, mas o autor disponibilizou o CSV em
`C:/Users/evaldoms/Downloads/`. Ele foi aberto e copiado integralmente para esta
pasta. O SHA-256 coincide com o digest do arquivo nos metadados do Dryad:
`6a9c1b77c8ea34cdfe9e039c7368cec4663686c770307b4ddf903e8c330014e5`.

**Contexto e unidade:** larvas de peixes capturadas em armadilhas luminosas nas
três enseadas de Santa Catalina, Califórnia, EUA. Uma linha é um evento de
armadilha, com `sample` único. São larvas de várias espécies somadas, não uma
espécie única. `n_fish` é a contagem; `soak_time_standardized` é o esforço em
horas por armadilha. Não é necessário juntar tabelas para o exercício principal.

| Medida calculada | Valor |
|---|---:|
| Linhas / colunas | 58 / 22 |
| Esforço mínimo / máximo (h) | 8,17 / 18,83 |
| Mediana / média do esforço (h) | 12,71 / 12,6102 |
| CV do esforço | 21,65% |
| Total de larvas de peixes | 15.919 |
| Contagem mínima / máxima | 0 / 5.739 |
| Média / mediana da contagem | 274,4655 / 20 |
| Variância amostral da contagem | 682.299,9023 |
| Zeros em `n_fish` | 8 (13,79%) |

O esforço máximo é 2,30 vezes o mínimo. O intervalo efetivo é mais amplo que
as aproximadamente 12–14 h descritas no método, corrigindo a avaliação inicial
baseada apenas no README. Não excluir os eventos fora de 12–14 h por esse motivo.

**Fatores e frequências conferidos:**

| Coluna | Níveis e número de linhas |
|---|---|
| `site` | BFC: Big Fisherman's Cove=22; CH: Cat Harbor=17; TH: Two Harbors=19 |
| `season` | Spring=13; Summer=45 |
| `year` | 2018=29; 2019=29 |
| `month` | março=13; junho=12; julho=33 |
| `mpa` | MPA=39; Non MPA=19 |
| `n_s` | N=41; S=17 |

Todos os locais têm primavera e verão: BFC=5/17, CH=4/13, TH=4/15. Entretanto,
2018 tem apenas verão (29 eventos); 2019 tem primavera=13 e verão=16. Isso
impede estimar a interação completa ano × estação e limita a generalização do
efeito sazonal. `mpa` e `n_s` são determinados pelo local nesta base; não oferecem
replicação independente para efeitos de proteção ou orientação geográfica.
Eventos repetidos nos mesmos locais e datas próximas exigem atenção à
dependência temporal. Um GLM inicial não a resolve automaticamente.

**Comparação exploratória:** Poisson com `site + season + year`, com e sem
`offset(log(soak_time_standardized))`, nas mesmas 58 linhas:

| Razão multiplicativa | Sem offset | Com offset |
|---|---:|---:|
| CH versus BFC | 0,1669 | 0,1763 |
| TH versus BFC | 0,0264 | 0,0299 |
| Verão versus primavera | 2,4642 | 2,6419 |
| 2019 versus 2018 | 1,3081 | 1,1482 |

Esses resultados ilustram a diferença entre modelar contagem por evento e taxa
por hora. A média do esforço no verão é menor que na primavera em cada local.
O efeito de ano, em particular, muda apreciavelmente, embora não haja inversão
de sinal. Não prometer que o offset necessariamente inverta uma conclusão.

No Poisson com offset, **deviance/gl=632,9507** e **Pearson/gl=1.041,4502**.
Uma binomial negativa NB2 (`MASS::glm.nb`) com os mesmos termos e offset
convergiu, com **theta=0,3217** e **Pearson/gl=1,5311**. AIC passou de
33.827,41 (Poisson) para 612,65 (NB). Isso favorece fortemente NB entre esses
dois ajustes exploratórios; não comprova adequação final dos resíduos ou da
independência. Na NB, a razão verão/primavera é 1,5113: também é didaticamente
útil mostrar que a escolha da distribuição altera o ajuste.

**Limpeza e ressalvas:** não há campos vazios/NA, IDs duplicados ou esforço
não positivo. As contagens são inteiras não negativas. As horas decimais têm
arredondamento: a diferença para `soak_hours + soak_min/60` chega a 0,2 minuto.
Recalcular CPUE a partir da contagem e do esforço escolhido, em vez de usar as
colunas de razões prontas com arredondamentos distintos. A conferência em R
também compara o ajuste com horas reconstruídas dos componentes.

O evento BFC-006 contém **5.739 peixes**, cerca de **36,1% de toda a captura**.
Outros eventos de BFC também têm contagens altas. Não apagar esses registros
como “outliers” sem evidência de erro; investigar influência e pulsos de
recrutamento. A proporcionalidade captura–tempo continua sendo hipótese do
offset, a conferir frente à operação das armadilhas luminosas.

**Resposta alternativa desaconselhada:** `n_ceph` tem 35 zeros (60,34%), soma
207, média 3,5690 e variância 105,9338. O resumo do depósito informa 205
paralarvas; essa divergência pede esclarecimento antes de usar cefalópodes.
Ela não ocorre com `n_fish`, cuja soma coincide com os 15.919 informados.

**Cobertura:** Poisson com offset, diagnóstico de superdispersão, NB com offset
e exploração gráfica da CPUE. ANOVA/Kruskal–Wallis simples não são recomendados
como caminho principal devido à assimetria, delineamento e dependência. O CSV
não traz latitude/longitude por evento; um mapa dos três locais exige as
coordenadas documentadas no método, não coordenadas individuais inventadas.

**Pergunta:** “Como a taxa de captura de larvas por hora varia entre as três
enseadas e entre primavera e verão, considerando o ano amostrado?”

**Parecer:** melhor candidato dos três para adaptação didática, com `n_fish`
como resposta. Cumpre tamanho, licença, contagem, esforço variável, zeros
moderados e três fatores de poucos níveis. A contagem multiespecífica, o
delineamento incompleto e a influência de eventos muito abundantes devem
ficar explícitos. Recomendação técnica de candidato não é aprovação didática
do autor nem incorporação ao pacote.

## 3. Tilápias no Malawi — planilha conferida; rejeitado

**Chiwondo and Mlare Lagoon Fish Length-weight data for Oreochromis karongae and
Oreochromis shiranus**, Joseph Chombo (2026).
[Mendeley, DOI 10.17632/ryyzzs6mvy.1](https://data.mendeley.com/datasets/ryyzzs6mvy/1).
Artigo associado com DOI: **não identificado na página consultada**.
**Licença:** CC BY 4.0, seção **Licence**.

[XLSX direto: Chiwondo and Mlare Fish Secies count and Catch data.xlsx](https://data.mendeley.com/public-files/datasets/ryyzzs6mvy/files/b37d30d5-4877-45c5-b084-1fa72e78320d/file_downloaded).
Baixado e aberto: `Sheet1`, **17 linhas de dados**, três colunas:
`Specis Name`, `Count of Fish Species`, `Contribution by weight (grams)`.
Uma linha é um rótulo de espécie agregado, não um lance ou estação.

O protocolo descreve rede de praia e esforço em número de arrastos, nas lagoas
Chiwondo e Mlare. **Essa exposição não está na planilha aberta**, nem há
identificadores de lagoa/data por linha. Não calcular CPUE usando um esforço
suposto. O segundo XLSX é anunciado como biometria; não foi aberto, portanto
não afirmo que o esforço esteja ausente de todos os arquivos do depósito.

As contagens de *O. karongae* e *O. shiranus* são 141 e 341. Os 17 registros
não têm zeros. Média/variância entre espécies seriam irrelevantes ao exercício.
Não há fatores amostrais ou intervalo de esforço disponíveis. Há espaços
redundantes e grafias taxonômicas diferentes a revisar.

**Cobertura confirmada:** composição de captura por espécie. **Não confirmada:**
Poisson/NB com offset, CPUE, ANOVA/Kruskal–Wallis ou mapa por unidade amostral.
Pergunta possível: “Quais espécies predominam na captura total?”

**Parecer:** rejeitado para esta busca: agregação inadequada, esforço ausente
na tabela de contagens e amostra abaixo do mínimo solicitado.

## Comparação e recomendação

| Candidato | Arquivo aberto | Licença | Contagem + esforço | Tamanho | Limitação decisiva |
|---|---|---|---|---|---|
| Caranguejo, quatro iscas | Sim | CC BY 4.0 | Sim, esforço derivável | 176; 140 após filtros | Esforço concentrado; dependência; pouco contraste com offset |
| Larvas, Catalina | Sim; hash confirmado | CC0 | Sim, horas prontas | 58 | Capturas extremas; primavera só em 2019; dependência temporal |
| Tilápias, Malawi | Sim, tabela de captura | CC BY 4.0 | Contagem sem esforço na tabela | 17 rótulos | Não há unidades amostrais nem exposição |

**Recomendação atualizada:** escolher **larvas de peixes de Catalina** para a
próxima etapa de adaptação didática de `navios_incidentes` e
`seguros_sinistros`, preservando o caranguejo como reserva. O CSV recebido
resolveu a pendência e revelou variação de esforço maior que a sugerida pelo
método. A comparação com/sem offset e Poisson/NB foi executada em R; não foi
feita alteração do pacote ou substituição dos dados existentes.

Um resultado brasileiro localizado foi
[Functional responses of fisheries to hydropower dams in the Amazonian Floodplain
of the Madeira River](https://datadryad.org/dataset/doi:10.5061/dryad.9p8cz8whj),
Arantes e colaboradores (depósito 2022;
[artigo](https://doi.org/10.1111/1365-2664.14082)). A página descreve captura em
kg e CPUE por táxon, sem demonstrar contagens de indivíduos. Por isso não passou
para a lista principal. Também foi descartado o
[atum-amarelo do oceano Índico](https://data.mendeley.com/datasets/p46tx55872/1):
embora a descrição mencione número de peixes e anzóis, a licença é CC BY-NC 3.0.

Se for indispensável ter uma única espécie ou um delineamento mais simples,
continuar a busca por pesca de linha com sessões de duração variável ou células
com número variável de lances/anzóis. Esses requisitos adicionais não foram
resolvidos pelo CSV de Catalina.

## Evidências locais

- `caranguejo_fonte/`: CSVs e scripts originais extraídos do ZIP, preservados.
- `caranguejo_conferencia.csv`: cópia para conferência, com duração em horas,
  contagem e mês derivados; não é um dataset já incorporado ao pacote.
- `caranguejo_resumo.json`: medidas e frequências calculadas.
- `conferir_caranguejo.R`: conferência independente das durações e dos GLMs.
- `Chiwondo_Mlare_contagens_fonte.xlsx`: planilha original, sem alterações.
- `light_metadata.json`, `light_files_metadata.json`, `light_page.html`:
  evidências da consulta ao Dryad.
- `Dale_Light_Trap_Data_Dryad.csv`: arquivo fornecido pelo autor, preservado;
  SHA-256 coincidente com o do repositório.
- `larvas_resumo.json`: medidas e frequências conferidas no CSV.
- `conferir_larvas.R`: comparação exploratória Poisson/NB, com/sem offset.

O roteiro menciona deviance/gl > 1 como passagem para NB. Usar essa razão como
sinal exploratório, junto de Pearson, resíduos e delineamento; um valor apenas
ligeiramente superior a 1 não é uma regra automática de troca de família.
Também não há limiar universal de 60% de zeros que, isoladamente, imponha outro
modelo: a frequência esperada depende da média e da distribuição ajustada.
