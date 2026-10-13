# Busca 06 — pontos de pesca e coleta com coordenadas

Conferência em **12/10/2026**. Substituto procurado: `terremotos_fiji` / `datasets::quakes` (D47).

**Recomendo o recorte NOAA de pollock no Golfo do Alasca, em 2023, para avançar à revisão do professor.** São 523 lances/pontos distintos, com CPUE em peso, profundidade e nenhum dado faltante nessas variáveis ou nas coordenadas. A licença CC0 está declarada no catálogo do próprio conjunto. O principal inconveniente didático é a variável de cor: os estratos originais têm 54 níveis codificados.

O melhor candidato brasileiro foi o dos 100 recifes da costa tropical. Ele tem riqueza/diversidade e profundidade, com licença CC BY 4.0, mas resume censos por recife e combina esforços amostrais muito diferentes. Portanto, não cumpre integralmente a exigência de observações individuais. **Nenhum dos candidatos brasileiros foi aprovado sem ressalvas.** Isso motivou a passagem à segunda área de preferência, a pesca de pesquisa de órgãos públicos. A busca não demonstra que inexista uma fonte brasileira melhor.

As quatro fichas abaixo distinguem **página/metadados**, **arquivo conferido** e **pendência**. Não houve alteração no catálogo da ClaRa/TRILHA, nem incorporação de dados ao pacote.

## 1. NOAA — pollock no Golfo do Alasca, 2023

1. **Identificação.** *Survey Catch-per-unit-effort CURRENT*, NOAA/NMFS Office of Science and Technology, catálogo 2026; dados originados no Alaska Fisheries Science Center. [Registro oficial](https://www.fisheries.noaa.gov/inport/item/69743). Recorte conferido: `Year = 2023`, `CommonName LIKE '%pollock%'`; todos os registros retornados são *Gadus chalcogrammus*. Relatório técnico associado: *Data Report: 2023 Gulf of Alaska bottom trawl survey*, 2024, [DOI 10.25923/gbb1-x748](https://doi.org/10.25923/gbb1-x748). Trata-se de relatório técnico, não de artigo de periódico; autoria pessoal não foi conferida. A autoria institucional dos dados está identificada.

2. **Licença.** **CC0-1.0**, seção **Access Information → Data License** do registro 69743. A declaração abrange a renúncia mundial de direitos. Não foi deduzida da licença do relatório nem do código no GitHub.

3. **Arquivo e acesso.** Fonte em [ArcGIS REST — GOA, camada 0](https://services2.arcgis.com/C8EMgrsFcRFL6LrL/arcgis/rest/services/GOA_Sample_Locations_CURRENT/FeatureServer/0). [Download direto do recorte em JSON, com geometria WGS84](https://services2.arcgis.com/C8EMgrsFcRFL6LrL/arcgis/rest/services/GOA_Sample_Locations_CURRENT/FeatureServer/0/query?f=pjson&where=Year%3D2023%20AND%20CommonName%20LIKE%20%27%25pollock%25%27&outFields=*&returnGeometry=true&outSR=4326). Cópia local: `noaa_pollock_2023_wgs84.json`; conversão tabular de conferência: `noaa_pollock_2023_conferencia.csv`. O recorte inteiro retornou sem indicador de truncamento. `CURRENT` é mutável: o catálogo menciona fevereiro de 2026, mas o nome da camada acessada termina em **20260601**. A cópia e seu SHA-256 preservam exatamente o material examinado.

4. **Unidade e tamanho.** Uma observação da espécie em um lance identificado por `SampleID`: **523 linhas, 523 IDs únicos e 523 pares de coordenadas distintos**. É um recorte transparente por ano e espécie, não uma amostra aleatória da base nem média regional. Não representa todos os lances históricos do programa.

5. **Região.** Golfo do Alasca e sua porção ocidental: latitude **52,463480 a 60,271130**; longitude **−169,898030 a −133,138620**, arredondadas aqui a seis casas. Estes limites foram calculados no recorte, não copiados da extensão de todo o portal.

6. **Coordenadas.** Campos originais `Latitude` e `Longitude`, numéricos em graus decimais. Para eliminar ambiguidade de datum, a consulta pediu `outSR=4326`; a resposta confirmou `wkid: 4326`. O CSV guarda a geometria retornada como `latitude_wgs84` e `longitude_wgs84`. A diferença máxima para os campos originais foi inferior a 0,00000005 grau. A geometria nativa do serviço é projetada: não se deve usar seu x/y nativo como longitude/latitude.

7. **Bolha.** `WTCPUE`, **kg/ha**: mínimo **0**, mediana **2,52302846**, máximo **1.345,89633822**. Há **91 zeros**, que precisam aparecer como pontos de ausência de captura, pois uma bolha de área zero desaparece. Usar área proporcional à CPUE, por exemplo `scale_size_area()`. `MapValue` é a raiz cúbica já preparada pelo portal (`TransformUnit = cuberoot`); não é a CPUE original e não deve substituí-la num exercício de proporcionalidade.

8. **Dispersão e cores.** `Depth`, profundidade em metros: **19–584**, mediana **129**. O [código oficial de compilação](https://github.com/nmfs-ost/DisMAP/blob/main/data_processing_rcode/code/Compile_Dismap_Current.R) renomeia `depth_m` para `depth` e `cpue_kgha` para `wtcpue`. A variável qualitativa original é `Stratum`, estrato amostral, com 54 níveis. Frequências completas:

   ```text
   10:8; 11:28; 12:16; 13:23; 20:13; 21:11; 22:24;
   30:10; 31:32; 32:9; 33:11; 35:7; 40:10; 41:7; 50:3;
   110:5; 111:18; 112:3; 120:15; 121:21; 122:22;
   130:22; 131:23; 132:16; 133:17; 134:16;
   140:6; 141:5; 142:7; 143:11; 150:7; 151:15;
   210:11; 220:7; 221:5; 230:7; 231:3; 232:3;
   240:5; 241:6; 250:2; 251:6;
   310:2; 320:2; 330:4; 340:2; 341:3; 350:3; 351:1;
   410:2; 420:2; 430:2; 440:2; 450:2.
   ```

   A legenda com 54 cores é inadequada para uma primeira aula. Uma adaptação possível é criar poucas classes de profundidade, explicitamente derivadas, preservando `Stratum`; não apresentar essas classes como categorias originais. `Species` e `Year` são constantes neste recorte, e `Season` está vazio nas 523 linhas.

9. **Arredondamento/sensibilidade.** Os campos decimais originais têm precisão limitada; não foi encontrada declaração de censura para proteção de espécies ou ocultação de pesca. Trata-se de pesquisa, não de registro de pesca ilegal. A ausência dessa declaração não prova que nunca tenha havido generalização na origem.

10. **Limpeza e limites.** **0 NA** em coordenadas, CPUE, profundidade, ID e estrato. `StratumArea` tem **523 NA** e deve ficar fora da versão didática enxuta. `Season` tem **523 strings vazias**, embora não apareça como NA no leitor JSON. `StdTime` é constante e não permite reconstruir a data real de cada lance. Não houve coordenada fora dos limites globais nem longitude positiva; a interseção ponto–terra com uma costa detalhada ainda não foi executada. O processamento DisMAP inclui padronização e preenchimento de zeros; preservar essa proveniência, sem chamar a tabela de captura bruta.

11. **Análises.** Mapas de pontos e bolhas, descritiva da CPUE, frequência de captura zero, dispersão CPUE × profundidade e exploração por estrato. Comparações são observacionais, sujeitas ao desenho estratificado e à dependência espacial; a média simples dos pontos não é uma estimativa automática de biomassa total do Golfo.

12. **Pergunta do aluno.** “Em 2023, onde ocorreram os maiores valores de CPUE de pollock no Golfo do Alasca, e como eles se relacionam com a profundidade?”

## 2. Brasil — diversidade de peixes em 100 recifes

1. **Identificação.** Feitosa, João; Sampaio, Claudio; Araújo, Maria Elisabeth; Mattos, Felipe; Kikuchi, Ruy; Leao, Zelinda; Macedo, Claudio; Ferreira Jr., Antonio; Nunes, Jorge; Melo, Felipe; Chaves, Lais; Feitosa, Caroline; Lippi, Daniel Lino; Pereira, Pedro Henrique; Félix-Hackradt, Fabiana; Hackradt, Carlos (2020). *Data for: Patterns of diversity of Brazilian reef fish fauna*. [Mendeley Data, DOI 10.17632/7km8mjtxgv.1](https://data.mendeley.com/datasets/7km8mjtxgv/1). Artigo associado: Araújo et al. (2020), *Diversity patterns of reef fish along the Brazilian tropical coast*, [DOI 10.1016/j.marenvres.2020.105038](https://doi.org/10.1016/j.marenvres.2020.105038).

2. **Licença.** **CC BY 4.0**, seção **Licence** da página do conjunto; a ficha do arquivo no navegador também identifica essa licença.

3. **Arquivo.** CSV, *Patterns of diversity of Brazilian reef fish fauna - alpha diversity dataset.csv*, 9.902 bytes. [Download direto](https://data.mendeley.com/public-files/datasets/7km8mjtxgv/files/0b3f4bcc-50dc-4599-849b-56d91acfe45d/file_downloaded). Cópia local: `recifes_original.csv`. Leitura com Windows-1252 preserva os acentos e o símbolo de área.

4. **Unidade e tamanho.** **100 linhas × 13 colunas**, uma por recife; 100 códigos únicos, **78 coordenadas distintas**, 31 nomes de local. São medidas de diversidade calculadas a partir de censos agrupados por recife. **Falha na exigência estrita de dado individual**, embora não seja uma tabela de médias por estado.

5. **Região.** Costa do Nordeste: CE, RN, PB, PE, AL e BA. Latitude **−17,97978056 a −3,396555556**; longitude **−39,12991667 a −34,785**.

6. **Coordenadas.** `Latitude (decimal degrees)` e `Longitude  (decimal degrees)` — o segundo cabeçalho contém dois espaços antes do parêntese. Graus decimais conferidos; hemisférios coerentes. **Datum WGS84 não foi explicitado na documentação consultada**, portanto permanece pendente.

7. **Bolha.** `Alpha diversity (q = 0)`, riqueza em número de espécies por recife: **15–59**, mediana **33**. Alternativas: q = 1, **1,93–22,52**, mediana **10,405**; q = 2, **1,25–13,35**, mediana **6,46**, ambas em número efetivo de espécies. Não chamar essas variáveis de abundância de indivíduos.

8. **Dispersão e cores.** `Mean Depth (m)`: **0,5–23 m**, mediana **3,85 m**. `Linear distance from coast (m)`: **50–60.000 m**, mediana **2.000 m**. Morfotipos: `Bank reefs` **50**, `Pinnacle reefs` **18**, `Patch reefs` **15**, `Fringing reefs` **14**, `Cemented terraces` **3**. Estados: BA **51**, PE **24**, RN **11**, PB **6**, AL **6**, CE **2**. Os morfotipos precisam de tradução acompanhada da definição ecológica dos autores.

9. **Arredondamento/sensibilidade.** Nenhuma declaração de censura foi localizada. Há coordenadas repetidas entre recifes diferentes; não se deve acrescentar deslocamento artificial e apresentá-lo como posição medida.

10. **Limpeza e limites.** **0 NA em todas as 13 colunas**; nenhuma coordenada globalmente inválida. Esforço em `Sampled area (m²)` varia de **100 a 40.180 m²**, mediana **1.200 m²**. A riqueza pode refletir esforço e origem dos censos, além do ambiente. O campo `Source` tem nove níveis, com 79 linhas de `This work`; não é uma campanha uniforme. A relação ponto–terra não foi conferida geometricamente. Evitar somar riquezas de recifes sobrepostos para criar uma “riqueza local”: haveria dupla contagem de espécies.

11. **Análises.** Pontos e bolhas de riqueza, descritiva, riqueza × profundidade ou distância da costa, comparação exploratória por morfotipo. É simples como tabela, mas a explicação da unidade e do esforço é mais exigente que em `quakes`.

12. **Pergunta do aluno.** “Os recifes com maior riqueza estão mais afastados da costa, e esse padrão muda entre morfotipos?”

## 3. Brasil — TimeFISH 2.0

1. **Identificação.** Quimbayo, Juan P. e colaboradores (2025), *TimeFISH 2.0: Fish assemblages in a 18-year monitoring program*, [Zenodo, DOI 10.5281/zenodo.15353415](https://zenodo.org/records/15353415). A página lista 18 colaboradores mais Sergio R. Floeter como patrocinador. Artigo associado: *TimeFISH: Long-term assessment of reef fish assemblages in a transition zone in the Southwestern Atlantic*, [DOI 10.1002/ecy.3966](https://doi.org/10.1002/ecy.3966). A ficha do Zenodo atribui 2025 ao vínculo editorial; o ano da edição do artigo não foi verificado separadamente.

2. **Licença.** **Não aprovado pelo filtro solicitado.** A [API do registro](https://zenodo.org/api/records/15353415) declara `metadata.license.id = other-open`. A seção Rights da versão textual da página não explicita CC0/CC BY 4.0. O README permite uso com citação, mas isso não autoriza rotular o depósito como uma dessas duas licenças.

3. **Arquivos.** CSVs: [censos](https://zenodo.org/records/15353415/files/TimeFISH_Version_2.0_census_data.csv?download=1), [locais](https://zenodo.org/records/15353415/files/TimeFISH_Version_2.0_location_information.csv?download=1), [taxonomia](https://zenodo.org/records/15353415/files/TimeFISH_Version_2.0_taxonomic_information.csv?download=1), mais [README](https://zenodo.org/records/15353415/files/README.txt?download=1). Foram baixados; a conferência numérica usou censos e locais.

4. **Unidade e tamanho.** Censos: **30.121 linhas**, cada uma combinando transecto, espécie e classe de comprimento. Locais: **2.123 linhas**, mas **2.121 IDs de transecto distintos**. Abundância por transecto exige soma dentro de `transect_id` e junção com locais. Não são 30 mil pontos independentes. Após resolver os IDs repetidos, o tamanho caberia no teto de 5 mil, mas ultrapassaria a preferência de mil.

5. **Região.** Arquivo efetivamente baixado: litoral de Santa Catarina, latitude **−27,844774 a −27,119989**; longitude **−48,526956 a −48,328687**. São **26 pares de coordenadas distintos** em oito locais. A descrição geral menciona nove locais e faixa de 25°S–29°S; para este parecer, prevalecem os limites e locais observados na versão do arquivo.

6. **Coordenadas.** `latitude`, `longitude`, numéricas em graus decimais. Datum não confirmado. As posições se repetem para muitos transectos: um mapa do arquivo inteiro sobrepõe muitas réplicas.

7. **Bolha.** Soma de `abundance` por ID: **1–10.646 indivíduos por transecto de 40 m²**, mediana **61** entre os 2.121 IDs. Total conferido nos censos: **227.944 indivíduos**. Não há NA em `abundance` original nem ID de censo sem local, e todos os IDs de local têm censo. Datas divergentes dos IDs repetidos ainda impedem uma junção final aprovada.

8. **Dispersão e cores.** `depth`: **1,1–25 m**, mediana **6,2 m**, quatro NA no arquivo de locais. `temperature`: 16–28 °C, **800 NA**. Categorias no arquivo original de **2.123 linhas**, antes de qualquer correção: `no_take_zone`: yes **1.164**, no **959**; `thermal_category`: warmer **1.637**, colder **486**. Locais: arvoredo_island **774**, deserta_island **431**, gale_island **341**, xavier_island **303**, campeche_island **102**, porto_belo **91**, aranhas_island **41**, moleques_do_sul_island **40**. Não apresentar essas frequências como as de 2.121 transectos únicos.

9. **Arredondamento/sensibilidade.** Não localizada declaração de censura. Há coordenadas de sítios compartilhadas pelas réplicas, sem georreferenciamento individual distinto de cada transecto demonstrado.

10. **Limpeza e limites.** Coordenadas sem NA e dentro dos limites globais; profundidade tem quatro NA; `visibility` tem 1.859 NA, `complexity` 292. **IDs `2019_86` e `2019_91` aparecem duas vezes cada, com dia 10 versus 11 de dezembro.** As linhas não são duplicatas exatas: escolher uma data sem evidência seria arbitrário. O mapa precisa de filtro temporal/sítio ou agregação claramente declarada; isso reduz sua vantagem como substituto direto.

11. **Análises.** Abundância e riqueza por transecto, dispersão com profundidade, comparação exploratória entre áreas protegidas e abertas, séries por local. A dependência espacial e temporal das réplicas precisa ser preservada; não é uma base simples de pontos espalhados.

12. **Pergunta do aluno.** “Como a abundância por transecto varia com a profundidade em áreas protegidas e abertas?”

## 4. Brasil — ictioplâncton do REVIZEE, cruzeiro 3

1. **Identificação.** Muelbert, Jose H.; de Macedo-Soares, Luis Carlos Pinto; Favareto, L. R.; Costa, M. D. P. (2018). *Ichthyoplankton composition form REVIZEE cruise 3, South-Southeastern Brazilian Shelf, in 1997*, [DOI 10.1594/PANGAEA.887710](https://doi.pangaea.de/10.1594/PANGAEA.887710). Artigo vinculado no depósito: Franco, Muelbert e Mata (2006), [DOI 10.1111/j.1365-2419.2005.00359.x](https://doi.org/10.1111/j.1365-2419.2005.00359.x).

2. **Licença.** **CC BY-SA 3.0**, seção **License** do depósito e cabeçalho do arquivo. **Excluído**: não pertence às licenças aceitas no prompt.

3. **Arquivo.** [Texto tabulado, download direto](https://doi.pangaea.de/10.1594/PANGAEA.887710?format=textfile), UTF-8; cópia `revizee_original.tsv`. Cabeçalho documental termina em `*/` e antecede a tabela.

4. **Unidade e tamanho.** Conferidas **317 linhas × 19 colunas**, porém só **33 eventos/estações e 33 coordenadas distintas**. O `Flag = 1` marca o começo de estação. A cifra “4.177 data points” na página **não significa 4.177 linhas**. As demais linhas detalham táxons; os totais de ovos e larvas se repetem.

5. **Região.** Plataforma Sul–Sudeste: latitude **−34,41 a −22,24**; longitude **−51,41 a −40,08**, calculadas na tabela.

6. **Coordenadas.** `Latitude`, `Longitude`, em graus decimais; sem NA. Precisão publicada de duas casas decimais nos valores tabulares. Datum não confirmado.

7. **Bolha.** Entre as **33 linhas de início de estação**, `Fish larv [#]`: **0–596**, mediana **117**; `Fish eggs [#]`: **0–189**, mediana **29**, sem NA. A unidade rotulada na coluna é contagem (#). Embora a documentação mencione padronização por volume em parte do programa, **não tratar estes campos automaticamente como indivíduos/100 m³** sem esclarecer essa diferença.

8. **Dispersão e cores.** `Bathy depth [m]`: **93–2.000 m**, mediana **134,5**, um NA entre as 33 estações. `Depth water [m] (haul depth)`: **15–150 m**, mediana **50**, mas **18 NA** nessa mesma seleção. `Device`: Bongo fechamento A **22**, Bongo A **11**; tipo de lance HST **22**, OB **11**. As frequências são por estação, não pelas 317 linhas taxonômicas.

9. **Arredondamento/sensibilidade.** Coordenadas de baixa precisão; não localizada justificativa de censura por sensibilidade. Não inferir precisão de GPS a partir dos zeros adicionais mostrados pelo portal.

10. **Limpeza e limites.** Falha também no mínimo de 100 pontos. Não somar totais de larvas/ovos pelas linhas de táxons. Temperatura e salinidade têm 13 NA entre as 33 estações. A seleção `Flag = 1` serve à conferência dos totais, mas não substitui uma validação do protocolo para produzir uma base final. Não houve teste de interseção com terra.

11. **Análises.** Pontos e bolhas, descritiva e dispersão com profundidade de fundo; comparação exploratória por aparelho seria confundida com o tipo de lance.

12. **Pergunta do aluno.** “Em quais estações se observaram mais larvas de peixes, e qual a relação com a profundidade de fundo?”

## Comparação e decisão sugerida

| Candidato | Licença | Linhas / posições distintas | Bolha e profundidade | Principal limite | Encaminhamento |
|---|---|---|---|---|---|
| NOAA, pollock 2023 | CC0 confirmada | 523 / 523 | CPUE kg/ha + profundidade, sem NA | Fora do Brasil; 54 estratos codificados | **Prioridade para revisão do professor** |
| Recifes brasileiros | CC BY 4.0 confirmada | 100 / 78 | Riqueza + profundidade, sem NA | Resumos por recife; esforço desigual; datum pendente | Melhor alternativa brasileira, com exceção explícita à unidade exigida |
| TimeFISH 2.0 | `other-open`; CC0/BY não confirmadas | 2.123 locais, 2.121 IDs / 26 | Abundância exige soma/junção; quatro NA em profundidade | Licença, dois IDs com datas divergentes e forte sobreposição espacial | Não incorporar nesta condição |
| REVIZEE 3 | CC BY-SA 3.0 | 317 táxon–estação, 33 estações / 33 | Contagens repetidas; profundidade com NA | Licença excluída e menos de 100 pontos | Descartar para esta substituição |

O recorte NOAA preserva o exercício de `quakes` com poucas colunas: **onde** (latitude/longitude), **quanto** (CPUE) e **a que profundidade**. Ele mantém zeros, tem quantidade muito assimétrica e permite discutir por que a maior bolha não corresponde necessariamente à maior captura absoluta: o esforço foi padronizado por área varrida. A costa de referência deve ser a do Alasca, não a do Brasil.

Antes da incorporação definitiva, falta a revisão cartográfica ponto–terra com contorno adequado, escolher como apresentar as categorias de cor e escrever a documentação didática da proveniência. A licença e a estrutura numérica do recorte NOAA foram verificadas; não há bloqueio de acesso ao material examinado. As ressalvas não exigem fabricar dados nem apagar zeros.

## Evidências locais e reprodução

`conferir_dados.py` lê as cópias baixadas e produz `resumo_conferencia.json`, `sha256.json` e o CSV de conferência NOAA. Executado com Python 3.13 e pandas 2.3.3. Para repetir a conferência, a partir desta pasta:

```powershell
python conferir_dados.py
```

As contagens, limites, medianas, NA e frequências deste parecer vêm desse script. O script não faz downloads nem modifica os arquivos originais. Sua função é auditoria da busca, não infraestrutura para os projetos dos alunos.

Foi investigado ainda o depósito amazônico de Leitão et al. (2017), [DOI 10.5061/dryad.j7d32](https://datadryad.org/dataset/doi:10.5061/dryad.j7d32), com CC0 identificada nos metadados do próprio registro. O download pela API exigiu token e o link da página devolveu HTML em vez de XLSX. **O arquivo não foi examinado**, e não se afirmam coordenadas, tamanho ou adequação. Os metadados e a resposta recebida foram preservados como evidência; não entram na comparação de quatro candidatos examinados.
