# Busca 07 — presença ou ausência no mesmo animal, antes e depois

Busca iniciada em **12/10/2026**, conforme `07_presenca_antes_depois.md`. Este arquivo registra a triagem até aqui. O requisito que mais elimina candidatos é haver o **mesmo identificador individual em dois exames binários**, e não apenas prevalência agregada antes/depois. A primeira recomendação que atende aos critérios está na seção 9; ela é de saúde animal terrestre, depois de a busca aquática não produzir um arquivo individual aberto adequado.

## O que foi conferido

### 1. Peixe-galaxiídeo após exposição bacteriana — não serve para McNemar

**Conjunto:** *Decreased energy acquisition, not the energetic costs of an immune response, can explain increased host activity and metabolic rate following infection*, Alan Lymbery (2026), [Mendeley Data, DOI 10.17632/2dyfdwpphd.2](https://data.mendeley.com/datasets/2dyfdwpphd/2).

A página do repositório declara **CC BY 4.0**. Ela descreve, no experimento 1, um grupo exposto a infecção bacteriana e um controle, com três avaliações antes e três depois da exposição. O arquivo aberto nesta busca foi [`Experiment_One_data.csv`](https://data.mendeley.com/public-files/datasets/2dyfdwpphd/files/d1b0f766-7385-4d16-bf47-5487f8390b76/file_downloaded), preservado localmente como `Experiment_One_data_fonte.csv`.

**Conferência do arquivo:** ele tem `ID`, `TIME` (`Before`/`After`), `Treatment` (`control`/`infected`) e as medidas contínuas `Length`, `SMR`, `TL` e `ET`. Logo, há indivíduos repetidos e controle, mas **não há desfecho binário de infecção, lesão ou parasitismo**. Transformar arbitrariamente uma dessas medidas em sim/não ensinaria outra análise, não um McNemar de presença/ausência.

**Parecer:** bom candidato para medidas repetidas, rejeitado para esta busca.

### 2. Guppies infestados por *Gyrodactylus* — promissor no tema, mas sem o pós-tratamento

**Conjunto:** *Host genetics and the skin microbiome independently predict parasite resistance*, Rachael Kramp e colaboradores (2026), [Dryad, DOI 10.5061/dryad.zs7h44jmn](https://datadryad.org/dataset/doi:10.5061/dryad.zs7h44jmn); artigo associado [DOI 10.1002/ece3.72923](https://doi.org/10.1002/ece3.72923).

O depósito Dryad foi aberto. A página lista `ParentalSelection.csv` (143,32 KB) e `SelectionData2.csv` (281,58 KB), além de README, e o próprio artigo remete ao depósito. O README diz que **200 guppies** foram infectados com *Gyrodactylus turnbulli* e acompanhados; é exatamente o contexto temático desejável.

**Falha estrutural:** o protocolo relata que os peixes foram tratados com levamisol depois do acompanhamento da infecção, para limpar os parasitos antes da reprodução. O README do depósito descreve severidade/área sob a curva da infecção, mas não descreve uma medição individual de presença/ausência **após** o levamisol. Assim, ainda que os dados tenham ID e contagens repetidas, não se pode assumir que o arquivo tenha o par pré/pós necessário. A tentativa de baixar `ParentalSelection.csv` diretamente encontrou a página de validação automática do Dryad, e não o CSV; portanto, não afirmo que a coluna pós-tratamento esteja ausente. Este candidato só volta à lista se a inspeção do arquivo revelar explicitamente um exame posterior ao tratamento.

### 3. Piolhos-do-mar em salmão — rejeitado por não parear o peixe

O artigo *Assessment of Salinity Tolerance in* *Lepeophtheirus salmonis* *Following Five Generations of Freshwater Treatment Selection* descreve contagens antes e depois de banho de água doce, mas declara que as contagens pré e pós vieram de **peixes diferentes**. Portanto, mesmo que uma base seja encontrada, não há par de animal para McNemar. Não avançar com ele.

### 4. Mastite ovina com três antibióticos — tabela de pares, mas sem microdados redistribuíveis

O artigo aberto *Ecological Dynamics of* *Staphylococcus aureus* *in Raw Ewe Milk Following Different Mastitis Treatment Protocols* tem uma estrutura estatística muito boa: mesma ovelha antes e depois, presença/ausência por cultura, três protocolos e os dois sentidos de discordância. Para os protocolos 1, 2 e 3, respectivamente, o texto informa as tabelas de pares:

| Protocolo | Pares | positivo→positivo | positivo→negativo | negativo→positivo | negativo→negativo |
|---|---:|---:|---:|---:|---:|
| Penicilina/estreptomicina | 100 | 10 | 20 | 12 | 58 |
| Oxitetraciclina | 50 | 3 | 8 | 8 | 31 |
| Enrofloxacina | 50 | 2 | 10 | 8 | 30 |

São **200 pares**, intervenções bem descritas e um excelente exemplo de que o McNemar usa apenas as duas células de mudança. Porém, a declaração de dados do artigo é “data are contained within the article”: há contagens agregadas, sem IDs e sem arquivo de microdados num repositório com licença declarada. Portanto não atende à exigência de preparar formato longo/largo nem à regra de checar a licença na página do repositório. Fica somente como referência metodológica, não como fonte a redistribuir.

### 5. Bagre com *Trichodina nigra* — licença adequada, mas unidade errada e sem o par pré/pós

**Conjunto:** *In vitro synergy and in vivo efficacy of Melia azedarach–Millettia pachyloba leaf extracts against Trichodina nigra infection and oxidative stress in juvenile white-spotted catfish (Clarias fuscus)*, [Figshare, DOI 10.6084/m9.figshare.34297458.v1](https://doi.org/10.6084/m9.figshare.34297458.v1). A página do depósito declara **CC BY 4.0** e oferece o [suplemento](https://ndownloader.figshare.com/files/69833643), guardado nesta busca como `bagre_trichodina_suplemento_fonte.docx`.

O tema é excelente: parasitismo em peixe de cultivo, grupo infectado sem tratamento, formalina e três tratamentos vegetais. O suplemento informa seis grupos de 40 peixes (cinco tanques com oito peixes) e perdas até o dia 28: 0, 7, 1, 3, 1 e 0, respectivamente. Há também contagens de *Trichodina* em pele e brânquias, mas elas são resumidas como **uma média por tanque**, depois de escolher um peixe de cada tanque em cada momento de amostragem.

Isso impede o McNemar: não existe uma coluna de identificador ligando o exame de um peixe infectado antes da intervenção ao exame daquele mesmo peixe depois dela. Além disso, a medida é abundância contínua de parasitos, não o resultado binário individual solicitado. Dicotomizar as médias ou tratar cinco tanques como 40 pares criaria uma pseudorrepetição.

**Parecer:** rejeitado; é uma boa fonte para discutir unidade experimental e não para uma análise pareada de presença/ausência.

### 6. Pangasius infectado por *Aeromonas* — planilha aberta, mas só três réplicas por tratamento

**Conjunto:** *Hematology and health status of Pangasianodon hypophthalmus fed with Moringa oleifera enriched pellets and infected with Aeromonas hydrophila*, [Zenodo, DOI 10.5281/zenodo.7811971](https://doi.org/10.5281/zenodo.7811971), [planilha original](https://zenodo.org/api/records/7811971/files/Research%20Data.xlsx/content). A página declara **CC BY 4.0**. A cópia aberta, `pangasius_moringa_fonte.xlsx`, contém três abas com leucócitos, eritrócitos, glicose e sobrevivência.

O desenho tem cinco grupos (controle negativo, controle infectado e três doses de *Moringa*), infecção por *Aeromonas hydrophila* no dia 31 e leituras no dia 30 e no 14º dia pós-desafio. Contudo, cada linha é `Treatment` + `Replication` (1–3), com valores já agregados por réplica; na aba de sobrevivência, o desfecho também aparece como porcentagem por réplica. Não há identificador de peixe nem estado de infecção individual antes e depois.

**Parecer:** rejeitado. Apesar do ótimo contexto de aquicultura, converter 100% ou 86,67% de sobrevivência em registros individuais inventaria dados e não permitiria formar a tabela 2 × 2 dos mesmos animais.

### 7. Guppies com *Gyrodactylus turnbulli* e banho antiparasitário — desenho quase ideal, mas dados não abertos

**Estudo:** Jawaji, Zilberg e Khozin-Goldberg, [*Using byproduct of fucoxanthin production by Phaeodactylum tricornutum for the development of a treatment against monogenean infection in fish*](https://doi.org/10.1007/s10811-023-02990-5), 2023.

Este é o melhor **desenho** encontrado na frente aquática: guppies infectados, banho de 24 h e contagem de parasitos na cauda de **cada peixe antes e depois** do tratamento; a fonte descreve 10 peixes por grupo. A partir das contagens, `presente = contagem > 0` poderia ser criado de modo transparente e os pares seriam reais. Contudo, nesta triagem não apareceu depósito de dados com os valores individuais nem licença de dados reutilizável: o registro bibliográfico indica licença editorial exclusiva da Springer. Sem uma página própria de repositório que declare CC0/CC BY/ODC e ofereça o arquivo cru, o conjunto não atende ao critério de incorporação.

**Parecer:** não usar nem solicitar informalmente para o pacote. É a referência de desenho mais próxima da busca, mas falha exatamente na abertura/licença que permite redistribuir a base didática.

### 8. Macacos-de-gibraltar reinfectados após vermifugação — primeiro candidato aberto realmente compatível

**Conjunto:** Müller-Klein et al., *Exposure and susceptibility drive reinfection with gastrointestinal parasites in a social primate*, [Dryad, DOI 10.5061/dryad.rr379bp](https://doi.org/10.5061/dryad.rr379bp); artigo associado [DOI 10.1111/1365-2435.13313](https://doi.org/10.1111/1365-2435.13313).

Este é o primeiro candidato fora da área aquática que passa na triagem estrutural e de licença: o Dryad declara **CC0**, fornece o arquivo cru `Strongyle_presence_data.csv` e explica que ele deriva de contagens fecais, codificadas como presença/ausência de ovos de estrongilídeos. O estudo acompanhou **57 macacos-de-gibraltar** (*Macaca sylvanus*) identificados, tratados com anti-helmíntico e repetidamente amostrados antes e depois. O artigo informa 953 amostras (338 pré-tratamento e 615 pós-tratamento), até quatro por indivíduo por semana, e explicita que a desparasitação foi bem-sucedida por pelo menos três semanas antes das reinfecções.

O arquivo é o tipo certo de matéria-prima para construir uma base por animal: ID, semana/fase e presença. Há também uma página própria de repositório com licença verificável, diferentemente dos artigos que só mostram tabelas. O [link direto do arquivo](https://datadryad.org/downloads/file_stream/82238) está registrado, assim como a [página do conjunto](https://datadryad.org/dataset/doi%3A10.5061%2Fdryad.rr379bp).

**Estado da conferência:** promissor, mas ainda não recomendado. O acesso automatizado do Dryad está entregando uma página de validação no lugar do CSV. Sem abrir o arquivo verdadeiro, ainda não é possível confirmar os nomes das colunas, escolher uma janela pós-tratamento didática, contar perdas, nem calcular honestamente as quatro células da tabela pareada. Esses números serão preenchidos somente a partir do CSV, não estimados pelo texto do artigo.

### 9. Búfalos-africanos após vermifugação — **recomendado**

**Conjunto:** Ezenwa e Jolles, *Opposite effects of anthelmintic treatment on microbial infection at individual versus population scales*, [Zenodo, DOI 10.5061/dryad.q2m38](https://zenodo.org/records/4944360), artigo associado [DOI 10.1126/science.1261714](https://doi.org/10.1126/science.1261714). A página do Zenodo declara **CC0**. Os arquivos relevantes são [`pre-treatment_worms.csv`](https://zenodo.org/api/records/4944360/files/pre-treatment_worms.csv/content) e [`worms.csv`](https://zenodo.org/api/records/4944360/files/worms.csv/content), ambos preservados sem alteração nesta busca.

São búfalos-africanos (*Syncerus caffer*) acompanhados em campo e distribuídos entre `bolus` (fenbendazol de liberação lenta) e `control`. Cada arquivo tem `animalID`, grupo (`trt`) e `worms_yn`; este último já é o desfecho binário pedido (0 = ovos de estrongilídeos ausentes; 1 = presentes). O arquivo pré tem uma medição por animal e o arquivo de acompanhamento contém as recapturas posteriores, com `captureinterval` em dias. Portanto, o pareamento vem do identificador do próprio estudo, sem reconstrução artificial.

**Recorte didático verificável.** Para evitar misturar a primeira aplicação com as redoses posteriores, foi escolhido, para cada animal, o **primeiro resultado válido até 180 dias após a linha de base**. Assim, o pós varia de 25 a 180 dias (mediana 121 no tratado e 117 no controle). O recorte não altera nenhum dado-fonte: apenas seleciona duas observações documentadas por animal.

| Grupo | Linhas basais | Sem resultado binário basal | Pares dentro de 180 dias | Excluídos por não ter pós válido na janela | antes 0 → depois 0 | antes 0 → depois 1 | antes 1 → depois 0 | antes 1 → depois 1 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Fenbendazol (`bolus`) | 108 | 1 | 98 | 9 | 47 | 2 | 45 | 4 |
| Controle | 108 | 5 | 98 | 5 | 27 | 16 | 16 | 39 |

No grupo tratado, há 47 discordâncias: 2 aquisições e 45 eliminações de ovos. O McNemar exato bilateral para esse recorte é **p = 1,60 × 10⁻¹¹**. No controle, as discordâncias se equilibram (16 e 16; p = 1). Isso é particularmente didático: os dois sentidos de mudança aparecem, o controle não é mascarado, e fica visível que o teste pareado usa as discordâncias — não as células 0→0 e 1→1.

**Limitações honestas:** é um estudo de fauna terrestre, não de pesca/aquicultura; a observação pós não ocorre no mesmo dia para todos os animais; e a fonte não identifica o motivo de cada pareamento ausente como morte, emigração ou falta de recaptura. Por isso, o material deve registrar “sem pós válido na janela” em vez de chamar os 14 casos de mortes ou perdas clínicas.

**Decisão do autor (12/10/2026): adotado.** A cópia didática em formato longo, `EAPADados::bufalos_estrongilos`, preserva as linhas sem par para o exercício de preparação e seleciona o primeiro pós válido até 180 dias. A receita, os dois CSVs brutos, a documentação e o objeto `.rda` ficam no repositório EAPADados; atribuição ao estudo e a licença CC0 acompanham o conjunto.

**Utilidade didática adicional:** o aluno começa com a base longa, confere o mesmo `id_bufalo` nos dois momentos, transforma `momento` em colunas `antes` e `depois`, identifica os pares incompletos e só então aplica o McNemar. Assim, a passagem longo → largo é ensinada como parte necessária do raciocínio sobre dados pareados — não como uma etapa técnica escondida. O controle permite fazer a mesma transformação e contrastar as mudanças nos dois grupos.

## Próxima frente de busca

Manter uma frente menor na área aquática, mas com um critério claro: só avançar quando houver arquivo individual aberto. A rodada complementar em Zenodo e Figshare localizou estudos de peixes com licença CC BY, mas os candidatos trazem infecção em uma única observação, medidas contínuas, ou repetição por tanque/sessão — não os dois estados binários do mesmo peixe. A triagem de ensaios em peixes reforçou que grupo-controle e acompanhamento temporal não bastam quando se amostram peixes diferentes a cada data ou se reduzem os resultados ao tanque. O candidato de búfalos já fornece uma rota de implementação honesta caso se aceite o contexto de saúde animal terrestre. Nenhum dado foi adaptado nem incluído no EAPADados.

## Evidência local

- `Experiment_One_data_fonte.csv`: cópia sem alterações do CSV público do candidato de *Nannoperca vittata*, aberta para verificar as colunas.
- `bagre_trichodina_suplemento_fonte.docx`: suplemento CC BY aberto para conferir a unidade experimental e as perdas; não contém microdados pareados.
- `pangasius_moringa_fonte.xlsx`: planilha CC BY aberta para conferir a granularidade; os registros são três réplicas agregadas por tratamento, não peixes identificados.
- `bufalo_vermes_pre_fonte.csv` e `bufalo_vermes_fonte.csv`: cópias sem alteração dos dois CSVs CC0 usados para confirmar IDs, tratamento, presença/ausência e os pares do candidato adotado. As cópias que passam a integrar a receita do pacote ficam em `EAPADados/data-raw/bufalos_estrongilos/fonte/`.
- `bufalo_btb_readme_fonte.txt` e `bufalo_btb_risco_fonte.csv`: material complementar CC0 do mesmo depósito, aberto para verificar o desenho longitudinal; não entra no recorte de McNemar de vermes.

