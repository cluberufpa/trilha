# Busca 02 — gradiente ambiental (rio, estuário, viveiros ou outro)

Substitui: `doubs_ambiente` (`ade4::doubs`, GPL). Escrito em 12/10/2026,
atualizado no mesmo dia (acréscimos e contexto dos conjuntos de PCA que já
existem). Cole o texto abaixo da linha numa IA com busca na web.

> Por que este conjunto, se a ClaRa já tem dados para PCA: os de PCA que
> existem são de **morfometria** (`peixes_morfometria_multivariada`),
> **composição corporal** (`peixes_nutricao_portugal`) e **ácidos graxos**
> (`truta_acidos_graxos`, `qfasa_*`). O `doubs` é o único de **gradiente
> ambiental**: estações de um rio descritas por variáveis de água e de habitat,
> que se ordenam da nascente para a foz, com a riqueza de peixes e o trecho
> como variáveis suplementares. É o exemplo que ensina PCA como ordenação de
> estações e HCA para agrupar trechos, coisa que os de morfometria (em que o
> primeiro eixo é só tamanho) e de composição não mostram.

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
principais (PCA) e agrupamento hierárquico (HCA) de **unidades de coleta**
descritas por variáveis de qualidade da água e do ambiente. O aluno deve ver as
unidades se ordenarem ao longo de um gradiente e relacionar esse gradiente com
uma resposta biológica ou produtiva.

**O gradiente não precisa ser um rio.** Qualquer um destes serve:

- **espacial**: da nascente para a foz, do rio para o estuário, da margem para
  o centro de um reservatório, do trecho preservado para o impactado;
- **de salinidade ou de maré**: estações num estuário, manguezal, baía ou
  lagoa costeira;
- **de sistema de cultivo**: viveiros, tanques ou fazendas de aquicultura
  (por exemplo camarão, tilápia, ostra) descritos pela água, em sistemas
  intensivo, semi-intensivo ou extensivo;
- **de tempo**: o mesmo local em estação seca e chuvosa, ou ao longo do ciclo
  de cultivo.

O modelo de referência é o clássico rio Doubs (Verneaux, 1973): 30 estações com
distância da nascente, altitude, vazão, pH, dureza, nutrientes, oxigênio e DBO,
mais a riqueza de peixes. **Não quero uma cópia dele.** Quero a mesma ideia
(muitas variáveis ambientais, poucas dezenas de unidades, uma resposta
biológica e um fator de grupo), com licença aberta e, de preferência, em
contexto de pesca ou aquicultura, de preferência na América do Sul.

## Estrutura exigida

- **Uma linha por unidade de coleta**: estação, viveiro, tanque ou fazenda (ou
  por unidade e campanha, se houver mais de uma; nesse caso, diga quantas
  campanhas há por unidade).
- **De 20 a 60 unidades.**
- **De 8 a 15 variáveis ambientais numéricas**, com unidade conhecida:
  físico-químicas da água (temperatura, oxigênio dissolvido, pH,
  condutividade, turbidez, salinidade, nutrientes, DBO, clorofila) e de
  habitat (profundidade, largura, velocidade da corrente, altitude,
  distância da nascente ou da foz, cobertura vegetal, tipo de substrato).
- **Uma variável de resposta por unidade**, biológica ou produtiva: riqueza de
  espécies de peixes, abundância total, CPUE ou biomassa; em aquicultura,
  produtividade, ganho de peso, taxa de sobrevivência ou conversão alimentar;
  riqueza de macroinvertebrados como última opção.
- **Um fator de grupo com 2 a 5 níveis**, que divida as unidades: trecho do
  rio (alto, médio, baixo), zona do estuário, estação do ano, uso do solo,
  sistema de cultivo (intensivo, semi-intensivo, extensivo), impactado ou de
  referência, rio ou bacia, fazenda.
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

1. **Aquicultura e pesca**: qualidade da água de viveiros, tanques ou fazendas
   (camarão, tilápia, tambaqui, ostra, peixes marinhos) com uma resposta
   produtiva; ou ecologia de peixes em rios, estuários, manguezais ou
   reservatórios, com estações ao longo de um gradiente (de preferência no
   Brasil ou na América do Sul);
2. Qualidade da água e comunidade aquática em áreas de pesca ou de
   aquicultura (bacias com pisciculturas, estuários com cultivo de ostras ou
   camarão);
3. Ecologia aquática em geral (macroinvertebrados, monitoramento de rios,
   lagos), em qualquer país.

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

## O que o pacote já tem (não repita)

O pacote já tem conjuntos de PCA de **morfometria de peixes**, de **composição
corporal** e de **ácidos graxos**. Não preciso de mais um desses. Procuro
especificamente **variáveis ambientais** (água e habitat) medidas em **estações
de coleta**.

## Acréscimos (lições das buscas anteriores)

- **Abra o arquivo de verdade.** Dryad e Mendeley às vezes devolvem uma página
  HTML de verificação no lugar do CSV. Se isso acontecer, diga que não
  conseguiu abrir o arquivo e não invente colunas nem contagens.
- **Confira o que declarou:** número de linhas e colunas, NA por coluna, unidade
  de cada variável e se há valores já transformados.
- **Se o arquivo abrir,** guarde uma cópia da fonte e informe o SHA-256.
- **Não incorpore nada** a pacote algum. Entregue só o parecer, com links.
- **Estação não é réplica independente** se houver várias campanhas na mesma
  estação. Diga isso se for o caso.
- **Dependência espacial:** estações ao longo de um mesmo rio não são
  independentes (a vizinha rio abaixo recebe o que vem de cima). Registre a
  ressalva e diga se ela afeta a PCA.
- **Papéis para a PCA:** indique qual variável serviria como **quantitativa
  suplementar** (como a riqueza de peixes) e qual fator serviria como
  **qualitativa suplementar** (como o trecho do rio). A tela de PCA da Trilha
  sugere essas duas por padrão.
- **Teste a PCA de verdade:** se o arquivo abrir, rode uma PCA padronizada e
  diga quanto da variância os dois primeiros eixos explicam e se as estações se
  ordenam ao longo do gradiente. Um conjunto em que a PCA não mostra nada não
  serve, por mais limpo que seja.
