# Busca 11 — regressão linear múltipla (uma resposta, vários preditores)

**Busca encerrada em 12/10/2026.** O D17 passou a ser
`solha_baltico_2008_t4`: 179 registros de solha-europeia no quarto trimestre de
2008, da Dryad (CC0 1.0; DOI 10.5061/dryad.kb2f352). No modelo-base,
`log_cpue_g` é explicado por seis preditores ambientais e espaciais (R² = 0,646;
VIF máximo = 4,21). Há 37 CPUEs zero, preservadas por `log1p()`. O recorte e seus
limites estão documentados no D17; ele é didático, não uma base para inferir todo
o Mar Báltico.

Registro da motivação original: `camarao_ecogreen` entrou como provisório para
correlação e regressão, mas tinha 70 linhas e só 7 perfis de água distintos (os
valores eram médias), relações fracas e colinearidade perfeita com as 11 variáveis
de água. A busca abaixo fica preservada como critério de curadoria.

> O que se quer: um conjunto em que a regressão múltipla **funcione e conte uma
> história**: uma resposta contínua, três a seis preditores que variam de
> verdade entre unidades independentes, relação real (R² entre 0,3 e 0,8) e
> colinearidade moderada, que o aluno consiga diagnosticar com o VIF e resolver
> escolhendo preditores. A Trilha ainda não tem a tela de regressão múltipla;
> o conjunto chega antes da ferramenta.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Regressão linear múltipla**: explicar uma variável resposta contínua por
vários preditores ao mesmo tempo. O aluno deve poder:

- ajustar o modelo completo e ler os coeficientes ("efeito de X mantendo os
  outros fixos");
- ver que o R² sobe ao acrescentar preditores e por que o R² ajustado importa;
- **diagnosticar colinearidade** com a matriz de correlação e o fator de
  inflação da variância (VIF), e resolver tirando ou combinando preditores;
- **escolher o modelo** (comparar com AIC ou com o teste F entre modelos
  encaixados);
- olhar os resíduos (normalidade, variância constante, pontos influentes);
- se houver um preditor categórico (sexo, local, tratamento), usá-lo junto com
  os contínuos, como passo para a ANCOVA.

Segundo uso desejado: o mesmo arquivo permitir a **regressão simples** de uma
das relações (para mostrar que o efeito muda ao entrar os outros preditores) e a
**matriz de correlação**.

## Estrutura exigida

- **Uma linha por unidade independente**: peixe, lance, viveiro, tanque, lote,
  estação ou ano. **Não aceito médias de grupo** nem dados em que vários
  registros compartilham os mesmos valores de preditores (foi o problema do
  conjunto que se quer substituir: 70 linhas, mas só 7 combinações distintas).
- **Resposta contínua** (peso, comprimento, taxa de crescimento, captura por
  unidade de esforço, biomassa, concentração de uma substância, rendimento).
  Se a resposta for contagem ou proporção, diga, mas prefiro contínua.
- **De 3 a 6 preditores contínuos** que variem de verdade (nada constante nem
  quase constante), mais, de preferência, **um preditor categórico** com 2 a 4
  níveis.
- **Relação real e moderada:** o modelo completo deve ter R² entre 0,3 e 0,8.
  Menos que isso o aluno não aprende nada; mais que 0,95 costuma indicar que um
  preditor é função da resposta (por exemplo, peso explicado pelo volume).
- **Colinearidade moderada:** pelo menos um par de preditores com |r| entre 0,6
  e 0,9. Isso é desejado, para o VIF aparecer. Colinearidade perfeita
  (|r| > 0,98 ou um preditor soma dos outros) é defeito.
- **De 60 a 400 linhas**; no máximo 2.000.
- **Poucos NA** (no máximo 10% por coluna) e sem dados imputados pela fonte.
- **Unidades e métodos descritos:** como cada variável foi medida.
- **Sem extremos absurdos** que dominem o ajuste (se houver, diga quantos e
  onde).

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Peixes e crustáceos de cultivo: crescimento, peso final, sobrevivência ou
   conversão alimentar explicados por temperatura, densidade, oxigênio,
   salinidade, dose de ração, tamanho inicial, idade;
2. Pesca e ambiente: captura por unidade de esforço, biomassa, abundância ou
   comprimento médio explicados por temperatura, profundidade, salinidade,
   transparência, latitude, tempo de arrasto;
3. Biometria: peso explicado por comprimento, altura, largura e idade juntos
   (cuidado com a colinearidade perfeita: as medidas corporais correlacionam
   alto, mas não perfeito);
4. Ciência animal ou engenharia de alimentos (rendimento, composição, tempo de
   secagem), só se não houver nada nas áreas anteriores.

Só passe para a área seguinte se não achar bons candidatos na anterior. **Não
repetir** conjuntos que a ClaRa já tem: `lago_vitoria` (água sob gaiolas),
`camarao_ecogreen`, `pollock_alasca`, as molinésias, as percas, o cangulo, o
barbo, os caranguejos, a pescada-amarela e o camarão vannamei.

## Onde procurar

Dryad (quase sempre CC0), Mendeley Data, Zenodo, figshare, DataverseNO e outros
Dataverse, PANGAEA, OSF, NOAA e os dados de órgãos públicos, e os dados
suplementares de *Data in Brief*, *Scientific Data*, *Aquaculture Reports*,
*Fisheries Research*, *Journal of Fish Biology*, *Fishes* (MDPI), PeerJ e PLOS
ONE. Termos úteis: "multiple regression raw data fish growth temperature
density", "individual fish growth water quality dataset", "tilapia growth
temperature salinity dissolved oxygen dataset", "CPUE environmental covariates
raw data", "shrimp growth stocking density oxygen individual data".

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- **Calcule, se conseguir abrir o arquivo,** o R² do modelo completo, as
  correlações entre os preditores e quantas linhas distintas os preditores têm.
  Se não conseguir calcular, diga que não calculou e não estime.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.
- Não aceite um artigo que traga só **médias por tratamento** ou uma tabela
  resumida. Sem os registros individuais, o candidato falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Espécie, sistema (cultivo, rio, mar) e como os dados foram obtidos.
5. O que é cada linha, quantas linhas e quais colunas, com unidades.
6. A resposta e os preditores candidatos (contínuos e categóricos), com a faixa
   de valores de cada um.
7. O que você conseguiu calcular: R² do modelo completo, o maior |r| entre
   preditores, o maior VIF aproximado e o número de combinações distintas dos
   preditores.
8. Problemas para limpar (NA, extremos, unidades misturadas, várias tabelas a
   juntar, rótulos a traduzir).
9. Quais análises ele cobre: regressão múltipla, seleção de modelo,
   colinearidade, regressão simples, ANCOVA, correlação.
10. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
