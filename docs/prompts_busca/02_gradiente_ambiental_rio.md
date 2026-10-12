# Busca 02 — gradiente ambiental: estações ao longo de um rio

Substitui: `doubs_ambiente` (`ade4::doubs`, GPL). Escrito em 12/10/2026.
Cole o texto abaixo da linha numa IA com busca na web.

> O que o substituto precisa manter na Trilha: a tela de PCA sugere uma
> variável quantitativa suplementar (hoje `riqueza`) e uma qualitativa
> suplementar (hoje `trecho`). O substituto precisa ter as duas, ou algo que
> faça o mesmo papel. Quando ele entrar, a sugestão em `mod_pca.R`
> (`papeis_sugeridos_pca`) troca de nome.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Análise multivariada de um gradiente ambiental**: análise de componentes
principais (PCA) e agrupamento hierárquico (HCA) das estações de coleta a
partir de variáveis de qualidade da água e do habitat. O aluno deve ver as
estações se ordenarem ao longo do gradiente (da nascente para a foz, do rio
para o estuário, do trecho preservado para o impactado) e relacionar esse
gradiente com a comunidade de peixes.

O modelo é o clássico conjunto do rio Doubs (Verneaux, 1973): 30 estações ao
longo de um rio, com distância da nascente, altitude, declividade, vazão, pH,
dureza, fosfato, nitrato, amônio, oxigênio dissolvido e DBO, mais a riqueza de
peixes de cada estação. Quero algo **com essa estrutura**, mas com licença
aberta e, de preferência, em contexto de pesca, de preferência na América do
Sul.

## Estrutura exigida

- **Uma linha por estação de coleta** (ou por estação e campanha, se houver
  mais de uma campanha; nesse caso, diga quantas campanhas há por estação).
- **De 20 a 60 estações.**
- **De 8 a 15 variáveis ambientais numéricas**, com unidade conhecida:
  físico-químicas da água (temperatura, oxigênio dissolvido, pH,
  condutividade, turbidez, salinidade, nutrientes, DBO, clorofila) e de
  habitat (profundidade, largura, velocidade da corrente, altitude,
  distância da nascente ou da foz, cobertura vegetal, tipo de substrato).
- **Uma variável biológica por estação**: riqueza de espécies de peixes, de
  preferência; também servem abundância total, CPUE ou biomassa de peixes, ou
  riqueza de macroinvertebrados como segunda opção.
- **Um fator de grupo com 2 a 5 níveis**, que divida as estações: trecho do
  rio (alto, médio, baixo), zona do estuário, estação do ano, uso do solo,
  impactado ou de referência, rio ou bacia.
- **Bônus (não obrigatório):** coordenadas geográficas de cada estação (para
  um mapa de pontos) e a tabela de espécies por estação (para exercícios de
  comunidade).
- **Valores em unidades reais**, sem transformações já aplicadas (o Doubs
  original traz pH multiplicado por 10, por exemplo; não queremos isso).

## Licença

- Aceito: **CC0**, **CC BY 4.0** ou domínio público (órgão governamental).
- Não aceito: CC BY-NC, CC BY-ND, GPL, "disponível a pedido", "uso
  acadêmico apenas", ou dados sem licença declarada.
- **Confira a licença na página do próprio repositório** e informe onde ela
  aparece. Não deduza a licença pelo periódico do artigo.

## Ordem de preferência das áreas

1. Ecologia de peixes em rios, estuários, manguezais ou reservatórios, com
   estações ao longo de um gradiente (de preferência na Amazônia ou em outro
   lugar do Brasil ou da América do Sul);
2. Qualidade da água e comunidade aquática em áreas de pesca ou de
   aquicultura (bacias com pisciculturas, estuários com cultivo de ostras ou
   camarão);
3. Ecologia aquática em geral (macroinvertebrados, monitoramento de rios),
   em qualquer país.

Só passe para a área seguinte se não achar bons candidatos na anterior.

## Onde procurar

Dryad (quase sempre CC0), Zenodo, figshare, Mendeley Data, PANGAEA,
Environmental Data Initiative (EDI, dados de LTER), BCO-DMO, OSF, SiBBr e o
repositório do PPBio (Brasil), conjuntos de "sampling event" do GBIF, dados de
órgãos públicos (USGS, EPA, ANA, agências estaduais de meio ambiente), e os
dados suplementares de *Data in Brief*, *Scientific Data*, *Neotropical
Ichthyology*, *Hydrobiologia*, *Ecological Indicators*, *Freshwater Biology* e
PLOS ONE (que exige dados abertos).

## Regras de honestidade

- Não invente DOI, link, número de linhas nem nome de coluna. Se não conseguiu
  abrir o arquivo de dados, diga isso e informe o que viu na página.
- Separe o que você **conferiu** (abriu a página, viu o arquivo, leu a
  licença) do que você **supõe**.
- Se só encontrar candidatos que falham em algum critério, apresente-os mesmo
  assim e diga qual critério falha.

## O que entregar

Para cada candidato (de dois a quatro):

1. Título do conjunto, autores, ano, DOI ou link do repositório e o artigo
   associado (com DOI).
2. Licença e onde ela aparece na página.
3. Link direto para o arquivo de dados e o formato (CSV, XLSX…).
4. Unidade amostral (o que é uma linha), número de estações e de campanhas, e
   número de linhas e colunas.
5. A lista das variáveis ambientais, com a unidade de cada uma.
6. A variável biológica (riqueza, abundância, CPUE) e como foi obtida.
7. O fator de grupo: os níveis e quantas estações há em cada um.
8. Se há coordenadas e a tabela de espécies por estação.
9. Problemas para limpar (NA, colunas desnecessárias, códigos sem legenda,
   dados em formato largo, várias tabelas a juntar).
10. Quais análises ele cobre: PCA, HCA, correlação, regressão da riqueza
    sobre o gradiente, mapa de pontos, ou outras.
11. Uma pergunta de pesquisa simples que um aluno responderia com ele.

No fim, uma tabela comparando os candidatos e qual você recomenda, e por quê.
Um conjunto que cubra mais análises vale mais, desde que continue simples de
explicar.
