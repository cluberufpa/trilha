# Molinésias e percas — aprofundamento da busca 05

Conferência de 12/10/2026. Objetivo: avaliar substitutos de `datasets::Orange`
e `datasets::CO2`. Dados baixados, arquivos abertos e ajustes exploratórios
executados. Esta curadoria não incorpora dados à ClaRa, ao EAPADados ou à TRILHA.

**Recomendação:** avançar com as molinésias para crescimento e com as percas
para resposta fisiológica e medidas repetidas. São complementares. As
molinésias têm o encaixe mais direto; as percas exigem explicar o delineamento
em três grupos e escolher a curva com cuidado.

| Critério | Molinésias | Percas |
| :--- | :--- | :--- |
| Espécie | *Poecilia formosa* | *Perca fluviatilis* |
| Unidade acompanhada | Peixe identificado | Peixe identificado no ensaio de respirometria |
| Indivíduos no arquivo selecionado | 34 | 40 |
| Linhas | 1.178; alternativa equilibrada com 340 | 449; 426 respostas disponíveis |
| Medições válidas por peixe | 30–38; alternativa com exatamente 10 | 8–12 |
| Eixo contínuo | Idade, 0–280 dias | Saturação de ar na água, 15–90% com resposta disponível |
| Resposta | Comprimento padrão, cm | Consumo de O₂, mg O₂ kg⁻¹ h⁻¹ |
| Faixa observada | 0,800–4,908 cm | 32,092–206,714 mg O₂ kg⁻¹ h⁻¹ |
| Fatores entre peixes | Sem tratamento; três mães identificadas | Três grupos de origem/história térmica |
| Curva e patamar | Crescimento desacelera e se aproxima da assíntota | Consumo sobe com a disponibilidade de O₂ e se aproxima de um patamar |
| Licença conferida no repositório | CC BY 4.0 | CC0 1.0 |
| Substitui melhor | `Orange` | `CO2` |

## 1. Molinésias: crescimento individual

### Fonte, licença e arquivo

Scherer, Ulrike; Ehlman, Sean M.; Bierbach, David; Krause, Jens; Wolf, Max
(2023). *Reproductive individuality of clonal fish raised in identical
environments and its link to early-life behavioral individuality*.

- [Registro do Figshare, versão 1](https://doi.org/10.6084/m9.figshare.23971599.v1).
- [Metadados oficiais do registro](https://api.figshare.com/v2/articles/23971599).
  O campo `license.name` declara **CC BY 4.0**; `license.url` aponta para a licença.
- [Download direto de growth.csv](https://ndownloader.figshare.com/files/42593824).
- [Artigo, Nature Communications 14, 7652](https://doi.org/10.1038/s41467-023-43069-6).
- [Correção de abril de 2026](https://doi.org/10.1038/s41467-026-71983-y).

O CSV baixado tem MD5 `d861757ef46947b6a2f1e2f2e423cbdd`, igual ao
`computed_md5` informado pelo Figshare. A licença é a do conjunto de dados,
verificada separadamente da licença do artigo. Ao redistribuir, creditar os
autores, citar o DOI, indicar tradução/seleção de colunas/datas e manter o
link da CC BY 4.0.

### O que foi acompanhado

São fêmeas clonais criadas individualmente desde o nascimento. O comprimento
foi medido em fotografias. Durante a fase reprodutiva, as fêmeas foram
alternadas entre aquários e machos; portanto, **o aquário não é a identidade
longitudinal do peixe**. O código `test_fish_ID` acompanha o animal.
As mães eram aparentadas. [Métodos do artigo](https://pmc.ncbi.nlm.nih.gov/articles/PMC10673926/).

A correção acrescenta uma fase de nove dias de ensaios comportamentais entre
a observação inicial e a transferência para reprodução. Os autores informam
que isso não altera os resultados. Não há motivo identificado nessa correção
para descartar o crescimento, mas ela deve acompanhar a referência
metodológica. [Texto da correção](https://pmc.ncbi.nlm.nih.gov/articles/PMC13076886/).

### Estrutura conferida no CSV

| Coluna original | Significado e destino |
| :--- | :--- |
| `Unnamed: 0` | Índice exportado; dispensável como variável de análise |
| `test_fish_ID` | Identificador do peixe → `peixe` |
| `mother_ID` | Identificador materno → `mae` |
| `fish_age_in_days` | Idade em dias → `idade_dias` |
| `standard_length_in_cm` | **Comprimento observado**, cm → `comprimento_cm` |
| `predicted_standard_length_in_cm` | Predição já calculada pelos autores; não é nova medição |
| `lower_CI`, `upper_CI` | Limites associados à predição original; dispensáveis na base didática inicial |

Não há NA nessas oito colunas nem duplicatas de peixe × idade. Existem,
porém, datas ausentes para alguns peixes: ausência de uma linha também é
falta de observação. Há 40 idades distintas no arquivo, em passos de sete
dias, exceto a ausência geral do dia 266. Não atribuí uma causa a cada lacuna.

As idades observadas são: 0, 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84,
91, 98, 105, 112, 119, 126, 133, 140, 147, 154, 161, 168, 175, 182, 189, 196,
203, 210, 217, 224, 231, 238, 245, 252, 259, 273 e 280 dias.

| Número de medições | Quantidade de peixes |
| :--- | ---: |
| 30 | 1 |
| 32 | 2 |
| 33 | 8 |
| 34 | 6 |
| 35 | 3 |
| 36 | 8 |
| 37 | 5 |
| 38 | 1 |

Os grupos maternos têm 14 (`m1`), 4 (`m2`) e 16 (`m4`) peixes. **Mãe não é
tratamento**, e três mães aparentadas não sustentam uma generalização ampla
sobre efeitos maternos. Não inventar dieta, linhagem ou temperatura como
fatores desse conjunto. O primeiro uso deve ser a variação das trajetórias
individuais.

### A curva realmente se aproxima de um patamar?

Sim, no período observado há forte desaceleração. A média dos mesmos 34
peixes passa de 0,896 cm no dia 0 para 4,366 cm no dia 280. A figura abaixo
mostra as medições, sem substituir a resposta pelas predições publicadas.

Reajustei por peixe a forma:

`comprimento = L_inf * (1 - exp(-k * (idade - t0)))`.

Os 34 ajustes convergiram. A assíntota estimada ficou entre 3,938 e 4,949 cm;
a mediana foi 4,575 cm. A taxa `k` ficou entre 0,008509 e 0,015441 dia⁻¹.
O RMSE por peixe ficou entre 0,090 e 0,173 cm. No dia 280, a medição individual
correspondeu, na mediana, a 95,8% da respectiva assíntota ajustada. Essa fração
depende do modelo; não é prova de que o crescimento cessou definitivamente.

Também ajustei logística e Gompertz. Todos convergiram. Na comparação
exploratória por AIC dentro de cada peixe, von Bertalanffy foi o menor em
28 peixes e Gompertz em 6; a logística não foi a menor em nenhum. Isso dá
apoio ao uso didático de von Bertalanffy, sem exigir que todos os peixes
sigam exatamente a mesma forma. A correlação entre resíduos consecutivos
variou de −0,368 a 0,474; a independência residual não foi estabelecida.

**Convergir não valida pressupostos.** Os AIC usam erros gaussianos sem
estrutura temporal e servem aqui como comparação exploratória. Não calculei
p-valores tratando 1.178 linhas como réplicas independentes.

O maior desvio entre nossas predições de von Bertalanffy e as predições
presentes no CSV foi 0,0101 cm. É uma reprodução próxima, não idêntica, do
ajuste publicado; não foi recuperado o procedimento exato de otimização dos autores.

### Base completa ou versão curta?

As dez datas com todos os 34 peixes são **0, 14, 21, 42, 49, 56, 77, 154,
224 e 280 dias**. Selecioná-las produz **340 linhas, dez medições por peixe,
zero NA e nenhuma imputação**. O critério é a cobertura comum, não a qualidade
do resultado. Os intervalos são desiguais e precisam aparecer como dias
reais no eixo, nunca como dez semanas igualmente espaçadas.

Reajustei as curvas nesse recorte. Na comparação com a base completa:

| Parâmetro | Mediana da mudança absoluta relativa | Extremos da mudança com sinal |
| :--- | ---: | :--- |
| Assíntota | 1,69% | −8,04% a +5,02% |
| Taxa `k` | 4,49% | −16,83% a +21,47% |

**Proposta:** usar as 340 linhas como alternativa compacta para introdução,
gráficos e medidas repetidas. Preservar as 1.178 linhas como referência para
estimar parâmetros individuais. O recorte conserva a história geral, mas
altera algumas taxas de forma perceptível.

### O que ensina e o que não oferece

O conjunto cobre curva não linear por indivíduo, comparação das trajetórias,
resumo de parâmetros por peixe e uma futura análise não linear de efeitos
mistos. A versão de dez datas também permite discutir medidas repetidas;
uma ANOVA temporal exigiria checar seus pressupostos e não aproveitaria a
idade como variável contínua.

`t0` é um parâmetro extrapolado, não o dia real de nascimento. A curva de
von Bertalanffy usada aqui não tem um ponto de inflexão interno como a
logística ou a Gompertz. Não prometer ensinar esse parâmetro com ela.

Pergunta inicial: **peixes criados sob condições semelhantes chegam ao
mesmo tamanho e crescem à mesma taxa?** É um substituto forte de `Orange`.
Não substitui o experimento de resposta em vários níveis de um fator de `CO2`.

## 2. Percas: consumo de oxigênio durante hipóxia

### Fonte, licença e arquivo

Ekström, Andreas (2021). *Data from: Cardiorespiratory adjustments to chronic
environmental warming improves hypoxia tolerance in European perch*.

- [Registro do Dryad](https://doi.org/10.5061/dryad.tmpg4f4z3).
- [Metadados oficiais do Dryad](https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.tmpg4f4z3).
  O campo `license` declara `https://spdx.org/licenses/CC0-1.0.html`.
- [Cópia do mesmo DOI no Zenodo](https://zenodo.org/records/4591899).
  A API do registro declara `metadata.license.id = cc-zero`.
- [Download direto da planilha XLSX](https://zenodo.org/api/records/4591899/files/Dataset_-_Cardiorespiratory_adjustments_to_chronic_environmental_warming_improves_hypoxia_tolerance_in_European_perch.xlsx/content).
- [Artigo associado, DOI 10.1242/jeb.241554](https://doi.org/10.1242/jeb.241554),
  de Ekström, Sundell, Morgenroth, McArley, Gårdmark, Huss e Sandblom.

O download público do Dryad retornou uma página de verificação. A planilha
válida foi obtida pelo registro do Zenodo que identifica o mesmo DOI.
Seu MD5, `09ba220844c4c8ddd36d2a5c4d8fa1b6`, confere com o registro do Zenodo.
A licença foi conferida nos dois repositórios. Manter a citação científica
mesmo com a dedicação CC0.

### Unidade, ambiente e delineamento

Cada peixe foi acompanhado durante a queda progressiva do oxigênio no
respirometro. A resposta é consumo por unidade de massa e tempo, não uma
contagem nem a porcentagem de oxigênio da água. A unidade mg O₂ kg⁻¹ h⁻¹ foi
conferida na seção de análise do artigo, em
[cópia do artigo depositada por autor](https://www.researchgate.net/publication/349201594_Cardiorespiratory_adjustments_to_chronic_environmental_warming_improve_hypoxia_tolerance_in_European_perch_Perca_fluviatilis).

| Código da fonte | Interpretação | Peixes na aba metabólica |
| :--- | :--- | ---: |
| `Baltic` | Referência, testada a 18 °C | 13 |
| `Biotest` | Origem em ambiente aquecido cronicamente, testada a 23 °C | 11 |
| `Balt@Bio` | Referência aquecida agudamente e testada a 23 °C | 16 |

O artigo distingue aquecimento agudo de exposição crônica e analisa medidas
repetidas. A sequência do ensaio é de **queda** de oxigênio; ler o gráfico
da esquerda para a direita não significa que os peixes receberam oxigênio
em ordem crescente. [Artigo](https://doi.org/10.1242/jeb.241554).

**Não é um fatorial completo origem × temperatura.** Falta, por exemplo, o
grupo Biotest testado a 18 °C. Usar um fator com três grupos é a descrição
mais clara. A origem e a história de exposição também limitam a interpretação
causal de uma comparação simples.

### A aba apropriada e as ausências

A planilha tem quatro abas. Para substituir `CO2`, a escolha é
**`Hyp. Prot. - RMR`**, já em formato longo, com quatro colunas:

| Coluna original | Significado e destino |
| :--- | :--- |
| `ID` | Identificador do peixe → `peixe` |
| `Treatment Group` | Grupo entre indivíduos → `grupo` |
| `Air saturation level` | Saturação de ar na água, % → `saturacao_ar_pct` |
| `Resting metabolic rate ` | Consumo de O₂ → `consumo_o2_mg_kg_h` |

O nome da resposta tem um espaço ao final, removido na conferência. O título
da aba/coluna usa RMR; o artigo descreve consumo de rotina. **Não renomear
como metabolismo padrão (SMR)** sem justificar outra definição fisiológica.

São 449 linhas, 40 IDs e nenhuma duplicata de peixe × nível. Há 23 NA na
resposta. Três deles são as únicas linhas com nível 100%; portanto, **não
há resposta metabólica disponível a 100% nessa aba**. Sobram 446 linhas nos
12 níveis com alguma resposta, das quais 426 têm consumo medido. A cópia
preparada preserva as 449 linhas e os NA.

Os níveis com resposta são **15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80 e
90%**. O nível 15% aparece somente em `Biotest`. Não imputar os demais grupos
nesse nível nem supor um experimento equilibrado.

| Medições válidas por peixe | Quantidade de peixes |
| :--- | ---: |
| 8 | 3 |
| 9 | 2 |
| 10 | 8 |
| 11 | 20 |
| 12 | 7 |

As outras abas têm variáveis individuais, cardiovasculares e mudança de
frequência cardíaca. A aba de variáveis individuais tem 44 IDs, enquanto a
metabólica tem 40. Os nomes dos IDs também variam entre abas. Não unir todas
automaticamente nem usar um valor basal de outra aba para preencher o nível
100%: isso exigiria conferir a equivalência do momento e da medição.

Não associei cada NA a morte, exclusão ou término do ensaio. Ausências nos
níveis mais baixos podem carregar informação sobre tolerância; a hipótese
de faltas aleatórias não está estabelecida.

### Há saturação? Qual modelo merece entrar?

O patamar aparece, mas varia de peixe para peixe. Calculei primeiro a média
das respostas baixas (até 30%) e altas (a partir de 60%) **dentro de cada
peixe**, depois a média dos peixes em cada grupo:

| Grupo | Faixa baixa | Faixa alta |
| :--- | ---: | ---: |
| `Baltic` | 68,21 | 99,03 |
| `Biotest` | 76,61 | 128,05 |
| `Balt@Bio` | 91,38 | 164,45 |

Unidade: mg O₂ kg⁻¹ h⁻¹. Esses resumos são descritivos e as faixas não têm
exatamente a mesma cobertura em todos os peixes.

Comparei por indivíduo três formas: Michaelis–Menten com dois parâmetros,
exponencial assintótica com dois parâmetros e reta seguida de platô, com
intercepto livre, inclinação e limiar. As duas curvas suaves convergiram
para os 40 peixes. A reta-platô foi pesquisada em uma grade de limiares de
20 a 75%, com incremento de 0,1 ponto percentual e inclinação não negativa.

| Menor AIC exploratório por peixe | Número de peixes |
| :--- | ---: |
| Reta-platô | 23 |
| Exponencial assintótica | 12 |
| Michaelis–Menten | 5 |

A penalização da reta-platô inclui a estimação do limiar. Ainda assim, esses
AIC não modelam a autocorrelação dos resíduos e não constituem uma seleção
inferencial definitiva. Em dois peixes o limiar encostou no teto de 75% da
grade, sinal de que a estimativa não está bem delimitada nessa busca.

**Minha leitura:** é uma boa base de resposta que se aproxima de um patamar,
mas Michaelis–Menten não deve ser imposta como a única explicação. A reta-platô
é uma comparação didática útil. Seu limiar exploratório em porcentagem não
é uma reprodução do `Pcrit` original do artigo, nem deve receber esse nome:
o procedimento original usa outra parametrização e outra escala.

### O que ensina e onde pede mais cuidado

O conjunto permite discutir pseudorreplicação, curvas individuais,
parâmetros/resumos por peixe e modelos mistos com grupo, nível de oxigênio
e interação. Para uma ANOVA de medidas repetidas, o desequilíbrio exige
tratamento explícito. Para inferência, um modelo que represente a dependência
dentro do peixe é uma opção mais natural do que ignorar os NA para obter
uma tabela artificialmente equilibrada.

Há ainda a ordem de exposição: concentração de O₂ e avanço do ensaio
mudam juntos. Não interpretar o desenho como doses aleatorizadas.

Pergunta inicial: **até que disponibilidade de oxigênio cada peixe mantém
seu consumo próximo do patamar, e como isso varia entre os três grupos?**
É um bom substituto estrutural de `CO2`, com resposta contínua e várias
medições por indivíduo; não reproduz seus dois fatores cruzados. Não serve
para crescimento em idade como `Orange`.

## 3. Encaixe no ecossistema e arquivos entregues

A TRILHA já apresenta von Bertalanffy em
`inst/app/modules/mod_regression.R`. Isso favorece a entrada das molinésias
sem ampliar o catálogo de análises. Esse módulo não comprova, por si só,
um ajuste que modele medidas repetidas. Não usar o ajuste de todas as linhas
juntas como inferência independente.

Os modelos adicionais avaliados neste parecer são ferramentas da curadoria.
Sua avaliação aqui **não propõe adicionar automaticamente** Gompertz,
Michaelis–Menten, reta-platô ou modelos mistos ao menu da v1.

![Medições individuais e médias observadas dos dois conjuntos](aprofundamento/curvas_dois_conjuntos.png)

As linhas claras representam peixes. Nas molinésias, a linha escura usa
somente as dez datas completas, com os mesmos indivíduos. Nas percas, as
linhas espessas são médias por grupo e nível e podem mudar de composição
com as ausências. Não são curvas ajustadas nem intervalos de confiança.

| Arquivo em `aprofundamento/` | Uso |
| :--- | :--- |
| `molinesias_crescimento_completo.csv` | 1.178 observações, quatro colunas em português |
| `molinesias_crescimento_10_datas.csv` | 340 observações, dez datas completas |
| `percas_hipoxia.csv` | 449 registros, quatro colunas em português, NA preservados |
| `molinesias_modelos_completos.csv` | Comparação exploratória de três curvas por peixe |
| `molinesias_modelos_10_datas.csv` | Mesma comparação no recorte equilibrado |
| `molinesias_sensibilidade_recorte.csv` | Mudança das estimativas com a seleção de datas |
| `percas_modelos_individuais.csv` | Comparação exploratória das três formas de resposta |
| `percas_cobertura.csv` | Número de respostas disponíveis por grupo e nível |
| `percas_resumo_por_peixe.csv` | Resumos individuais nas faixas baixa e alta |
| `resumo_modelos.txt`, `proveniencia_e_limites.json` | Resultados agregados, integridade e limites |
| `curvas_dois_conjuntos.png` | Figura de conferência das medições |

O código de conferência está na pasta-mãe destes resultados. A sequência é
`conferir_dados.py` → `aprofundar_dois_conjuntos.R` → `verificar_proveniencia.py`.
Python lê as planilhas; os modelos e a figura usam R. O script R roda com
`Rscript --encoding=UTF-8`; nesta máquina foi necessário usar a localidade
`Portuguese_Brazil.utf8` para preservar os acentos. As fontes e os metadados
baixados permanecem separados das cópias preparadas.

**Decisão sugerida ao autor:** molinésias como substituto de `Orange`,
mantendo a base completa e oferecendo a seleção de dez datas para uma aula
curta; percas como substituto de `CO2` para resposta fisiológica e dependência
entre medições, com três grupos e escolha explícita da forma da curva.
Nenhum dos dois foi incorporado ao pacote nesta etapa.
