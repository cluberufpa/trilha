# Busca 08 — decaimento exponencial até um patamar

Busca realizada em **12/10/2026**, conforme 08_decaimento_exponencial.md. As duas bases selecionadas foram adaptadas e incorporadas ao EAPADados.

**Decisão didática e incorporação (12/10/2026):** estes dois conjuntos foram selecionados para a rota ClaRa e incorporados ao EAPADados: `secagem_beterraba_gengibre` (594 linhas) e `chinook_digestao` (recorte de 91 peixes). O primeiro preserva os códigos e a unidade de tempo pendente; o segundo preserva zeros e não detecções de qPCR. A seleção não elimina as ressalvas de limpeza e de modelagem abaixo.

## 1. Beterraba e gengibre secos — selecionado para a ClaRa

**Conjunto:** *Drying kinetics (MR) data and AI model scripts for ethanol-pretreated beetroot and ginger*, Suian Granella (2025), [Mendeley Data, DOI 10.17632/zkvb73tn79.1](https://doi.org/10.17632/zkvb73tn79.1). A página não lista artigo associado.

**Licença conferida:** CC BY 4.0, no campo **Licence** da [página do depósito](https://data.mendeley.com/datasets/zkvb73tn79/1).

**Arquivo aberto:** [moisture ratio MR, drying kinetics, raw drying data.csv](https://data.mendeley.com/public-files/datasets/zkvb73tn79/files/6033bd32-3e08-4ca4-acd0-765534c91107/file_downloaded). Apesar do nome, é XLSX (35.308 bytes), preservado como beterraba_gengibre_fonte.xlsx; SHA-256 conferido: 442106f001b6d6808856d0bc89ce610c15d6057df3a89bbe0e04d97fd806ff5c.

O depósito descreve cubos de beterraba de 10 mm e fatias de gengibre de 2 mm em ar forçado a 60, 70 e 80 °C, com ou sem etanol a 50% por 15 min. A planilha tem **594 linhas**, 8 colunas, nenhum NA em mr e nenhuma duplicata de série–tempo. São **36 séries** (2 produtos × 2 tratamentos × 3 temperaturas × 3 réplicas), com **14–20 pontos por série**; cada condição com três réplicas tem 42–60 linhas. A unidade amostral é uma amostra de produto em uma réplica de secagem.

A variável time é numérica, inicia em 0 e vai de 181 a 633 conforme a condição, mas **a unidade não é declarada**. temp é °C pela página. A resposta mr é razão de umidade sem unidade, de 1 até 0,0041–0,2894 nas séries individuais. Para G/C/60 °C, as médias dos quatro últimos tempos são 0,149; 0,170; 0,145; 0,135 (54 linhas, 18 tempos), compatíveis com aproximação de patamar.

**Limpeza/ressalvas:** mapear e traduzir os códigos B/G e C/E — a associação a beterraba/gengibre e controle/etanol é uma inferência a confirmar; arredondar tempos como 4,99999999999998; registrar a unidade de tempo. Embora a descrição prometa massa bruta, a planilha contém apenas mr; o exemplo parte de uma razão já calculada.

**Cobertura:** nls(mr ~ a + b * exp(-k * tempo)), meia-vida, resíduos e comparação com reta; após confirmar os códigos, comparação de k por temperatura/pré-tratamento. Pergunta: “A que taxa a razão de umidade do gengibre a 60 °C cai e por que uma reta erra o nivelamento final?”

## 2. Depuração viral de ostras-pacíficas — arquivo conferido; rejeitado

**Conjunto:** *Microbiological data from studies to optimise depuration of viruses from Pacific oysters (Crassotrea gigas)*, Anna Neish, David Ian Walker, Tina Stapleton e Andrew Younger (2019), [Zenodo, DOI 10.5281/zenodo.2791858](https://doi.org/10.5281/zenodo.2791858). Não há artigo associado no registro.

**Licença:** CC BY 4.0, no campo metadata.license dos [metadados do Zenodo](https://zenodo.org/api/records/2791858).

**Arquivos abertos:** [dados](https://zenodo.org/api/records/2791858/files/Depuration%20trial%20data.csv/content) e [descritores](https://zenodo.org/api/records/2791858/files/Depuration%20trial%20data%20-%20Field%20descriptors.csv/content), preservados localmente. Os MD5 conferem com o Zenodo.

São **155 linhas**, seis experimentos e tempos de 0 a 138 **horas**. Cada linha é uma amostra laboratorial, com réplicas A–D (ou A–C); o depósito não esclarece se é ostra individual ou pool. Respostas: norovírus GI/GII e FRNAP-II em cópias/g, FRNAP-II em MPN/g e *E. coli* em MPN/100 g. Há 47 valores invalid nas três respostas de cópias e 136 observações de *E. coli* como <18.

Falha decisiva: tempo e condição mudam juntos. Por exemplo, em V há 0, 42, 72 e 138 h, mas os pontos posteriores também diferem em luz, temperatura ou alimentação. Os demais experimentos têm só 0 e dois tempos posteriores. Não há série longa sob condição constante, logo não cabe chamar os últimos pontos de patamar de uma única curva. É útil para limite de detecção e fatores de depuração, mas não para este nls().

## 3. Digestão de Chinook em predadores — selecionado para a ClaRa, com recorte explícito

**Conjunto:** *Chinook salmon digestion data within predatory largemouth bass and channel catfish through controlled feed trials*, Cory Dick, Wesley Larson, Kirby Karpan, Diana Baetscher, Yue Shi e Nann Fangue (2023), [Dryad, DOI 10.5061/dryad.fj6q5740x](https://doi.org/10.5061/dryad.fj6q5740x). Não identifiquei DOI de artigo na página.

**Licença:** CC0 1.0 no campo license dos [metadados públicos](https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.fj6q5740x). O arquivo listado é [Dick_et_al_2023_data.xlsx](https://datadryad.org/downloads/file_stream/2346250), XLSX de 180.477 bytes.

O protocolo tem respostas de DNA de presas no trato digestivo de black bass e bagre-do-canal, sob 15,5 ou 18,5 °C e uma ou três presas. São dez tempos: 6, 12, 24, 36, 48, 60, 72, 84, 96 e 120 h; havia alvo de cinco peixes por combinação/tempo. Isso parece muito promissor para esvaziamento gástrico e meia-vida.

O XLSX original foi depois obtido manualmente e conferido: SHA-256 `375d374eb74670b1fa325e89abb6f638e0f9291aabc3675ffbdd6f4267ce5692`, igual ao divulgado pelo Dryad. Há duas abas: `DNA Analysis` (1.811 leituras laboratoriais) e `Controlled Feeding` (588 peixes, 17 colunas). Esta última contém `Time Ingested` em horas, `Read Count (metabarcoding)`, `Copy Number (qPCR)`, espécie predadora, temperatura e ração.

O arquivo integral excede por pouco o teto de 500 linhas da busca, mas o recorte **LMB, 18,5 °C, três smolts** tem 91 peixes, dez classes temporais e 8–10 peixes por tempo; serve como uma série curta e rastreável. As médias de leituras caem de 6.031 no início para 439, 55 e 19 nas classes de 84, 96 e 120 h. O `nls()` em todas as 91 observações, apenas como diagnóstico, dá `a` no limite zero, `k = 0,0361 h⁻¹`, meia-vida de 19,2 h e R² de 0,757 (reta: 0,618).

**Ressalva importante:** a resposta é uma contagem com zeros e dispersão não constante; portanto é um exemplo aplicado de perda de sinal/digestão, não a curva contínua ideal para apresentar os três parâmetros. O qPCR é ainda mais problemático: há 163 valores ausentes/não detectados no arquivo completo. Cada peixe é dissecado uma única vez após a alimentação, logo as réplicas por tempo são independentes, e não medidas repetidas no mesmo animal.

## 4. Secagem infravermelha de mexilhões — tema ideal, mas só PDF

**Conjunto:** *Temperature controlled infrared drying kinetics of mussels*, Sema Sevim, Emek Derun, Nurcan Tuğrul, İbrahim Doymaz e Azmi Seyhun Kıpçak (2019), [Zenodo, DOI 10.5281/zenodo.5643531](https://doi.org/10.5281/zenodo.5643531); artigo em [*Journal of the Indian Chemical Society*](https://avesis.yildiz.edu.tr/yayin/089c1f6a-daf4-4d81-a2e3-e2f8af0d2f6d/temperature-controlled-infrared-drying-kinetics-of-mussels). Não localizei DOI do artigo.

**Licença:** CC BY 4.0 nos [metadados do Zenodo](https://zenodo.org/api/records/5643531). O único arquivo é [PDF](https://zenodo.org/api/records/5643531/files/20%20-%20Sep%2019.pdf/content), 368.565 bytes.

O artigo descreve mexilhões secos a 60, 70 e 80 °C por 405, 255 e 165 min. É o melhor contexto de tecnologia do pescado, mas não há CSV/XLSX: digitalizar figuras seria criar dados derivados. Rejeitado até a publicação da planilha original.

## Comparação

| Candidato | Arquivo aberto | Licença | Parecer |
|---|---:|---|---|
| Beterraba/gengibre | Sim, 594 linhas | CC BY 4.0 | Selecionado: secagem; confirmar unidade e códigos |
| Ostras, depuração | Sim, 155 linhas | CC BY 4.0 | Tempo confundido com tratamento |
| Digestão de Chinook | Sim, 588 linhas; recorte de 91 | CC0 | Selecionado: caso aquático, com contagens e limite de detecção |
| Mexilhões infravermelhos | Não; só PDF | CC BY 4.0 | Sem microdados |

## Utilidade na rota ClaRa

- **`secagem_beterraba_gengibre`** é a porta de entrada para a curva: o estudante escolhe uma `id_serie`, ajusta `razao_umidade ~ a + b * exp(-k * tempo_origem)`, interpreta amplitude, taxa e patamar e compara o ajuste com uma reta. As 36 séries permitem, depois da confirmação dos códigos e da unidade de tempo, comparar a taxa `k` entre temperatura e pré-tratamento.
- **`chinook_digestao`** oferece o contexto de pesca e aquicultura: a mesma curva descreve a perda do sinal de DNA de Chinook no trato digestivo. Serve para discutir meia-vida, leituras próximas ao limite de detecção, contagens com zeros, qPCR não detectado e por que a curva simples tem uso descritivo.

Os dois objetos foram incorporados à camada de dados `EAPADados`, que é a fonte usada pela CatalyseR e pela rota ClaRa. Para o primeiro, confirmar previamente o dicionário B/G, C/E e a unidade de `time`; para o segundo, manter sempre documentado o recorte LMB–18,5 °C–três smolts. Não transformar a base de ostras em curva única: isso esconderia a confusão entre tratamento e tempo.

## Evidências locais

- beterraba_gengibre_fonte.xlsx: arquivo fonte aberto, hash conferido.
- chinook_dryad_fonte.xlsx: XLSX original do Dryad aberto, com hash conferido.
- depuracao_ostras_fonte.csv e depuracao_ostras_descritores_fonte.csv: fontes abertas, hashes conferidos.
- Os dois objetos curados foram incorporados ao `EAPADados`; os arquivos-fonte permanecem preservados para reprodução e auditoria.

