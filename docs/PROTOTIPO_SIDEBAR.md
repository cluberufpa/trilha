# Protótipo local: navegação lateral com flyout

Branch de trabalho: `feat/layout-sidebar`. Ajustes locais realizados em 14/10/2026; nada publicado no remoto.

## Comportamento atual

Os menus principais permanecem na barra, organizados em Pesquisa, Análises e Aprender e comunicar. Um clique abre um único painel flutuante à direita; outro menu troca o conteúdo, e repetir o clique fecha o painel. Selecionar um módulo (inclusive o já ativo), clicar fora, usar o botão de fechar ou pressionar Esc também fecha. O menu ativo, a indicação “Em uso” e o caminho do módulo são preservados.

A largura do painel é medida pelos nomes reais com a fonte carregada no navegador e limitada ao espaço disponível; no refinamento atual, variou de 260 a 338 px. Seu topo acompanha o menu acionado e é corrigido para caber na janela; redimensionamento e rolagem da barra recalculam a posição. Cabeçalho e rodapé ficam separados da lista, que tem rolagem própria. Menus com oito ou mais módulos oferecem busca local pelo nome, ignorando maiúsculas e acentos; grupos sem resultados ficam ocultos durante a busca.

Enter ou Espaço abre/fecha o menu; seta direita/baixo entra no painel. Setas, Home/End e Tab permitem percorrer os controles, e Esc devolve o foco ao botão de origem. O painel é não modal: a área central e os outros menus continuam acessíveis.

A fonte dos menus e módulos permanece em 14,5 px, inclusive nas janelas menores. Os rótulos não são escondidos, abreviados ou transformados em reticências. A lista principal e o flyout têm rolagem própria; quando a janela é estreita demais para comportar fisicamente os nomes, há também rolagem horizontal para mantê-los em uma linha. O painel continua inteiramente dentro da janela e à direita da barra.
## Preservação dos módulos

A UI continua usando os mesmos painéis `nav_panel` e servidores. Os links originais ficam ocultos na navbar, preservando `data-value`, a seleção de abas e o binding `main_navbar` do Shiny. O flyout contém atalhos que acionam esses links; os campos dos módulos não são movidos, removidos ou recriados.

O painel é anexado ao corpo da página com posição fixa e camada 1040. Assim, os contêineres de rolagem da barra não o cortam. Ele sobrepõe parte do conteúdo central, começando depois da borda direita da barra, sem deslocar o layout. A regra responsiva do tema que deslocava a lista principal para fora da barra foi corrigida.

Não foram alterados nomes, agrupamentos internos, campos, IDs, abas, regras, cálculos, fichas ou exportadores dos módulos. Variantes, UA-conjunto e Código R continuam para a etapa própria de `PLANO_VARIANTES.md`. Nenhum arquivo foi movido ou dependência de produção acrescentada. O trabalho local não rastreado que já existia foi preservado.

## Executar e revisar

No R/RStudio, com TRILHA como diretório de trabalho:

```r
shiny::runApp("inst/app", launch.browser = TRUE)
```

Reinicie o app para carregar esta versão da UI. Os endereços de CSS e JavaScript foram versionados para evitar cópias antigas em cache. O botão de três barras continua recolhendo/reabrindo a própria sidebar e fecha o flyout, se estiver aberto.

A sessão de teste separada usou `http://127.0.0.1:4624`. Neste ambiente, foi necessário ajustar somente a sessão R antes da execução:

```r
Sys.setlocale("LC_ALL", "Portuguese_Brazil.utf8")
```

O protótipo não muda a configuração regional do computador.

## Validação desta mudança

O teste `inst/app/tests/test_layout_flyout.cjs` foi executado contra o app real em uma sessão isolada do Chrome já instalado, usando o Playwright disponível no ambiente de desenvolvimento. Terminou com status 0.

Foi verificado:

- abertura por clique sem mudar as posições dos menus principais;
- um único painel, troca de menu e fechamento no clique repetido;
- busca com resultado e sem resultado, e destaque do módulo ativo;
- fechamento por seleção, clique externo, botão e Esc;
- seleção repetida do Transversal já ativo;
- Enter, setas, Home/End e retorno do foco ao menu de origem;
- preservação da pergunta preenchida e de 7 UAs no primeiro grupo do Transversal; o mesmo elemento de input permaneceu no DOM;
- posição dentro da janela em larguras de 320, 480, 600, 900 e 1440 px, sem cobrir a barra;
- menus principais dentro da barra também em janelas estreitas;
- posição de menu próximo ao rodapé e ausência de busca em menu curto;
- rolagem da lista sem deslocar o cabeçalho;
- ausência de erros JavaScript na sessão de teste.

A sintaxe JavaScript e `git diff --check` passaram. A comparação das expressões R confirmou menus, corpos dos painéis e servidor preservados; a UI também foi gerada. Essa verificação R apresentou os resumos OK, mas o subprocesso voltou a devolver status 1 após eles, como nas verificações anteriores deste ambiente; esse resultado não foi tratado como saída limpa de teste R. A sessão Shiny real foi inicializada e usada pelo teste de interação.

Capturas de conferência: `outputs/sidebar-flyout/flyout-desktop.png` e `outputs/sidebar-flyout/flyout-estreito.png`, inspecionadas visualmente. A ferramenta de navegador interativo continuou com erro ao iniciar; a validação foi concluída por teste automatizado em navegador separado.

Para repetir o teste, com o app já iniciado e Playwright disponível no `NODE_PATH`:

```text
node inst/app/tests/test_layout_flyout.cjs http://127.0.0.1:4624
```

Ele é separado da suíte R oficial e não instala pacotes ou navegadores.

## Limites

Esta etapa valida a navegação e sua integração com o Transversal. Não certifica o conteúdo ou os downloads de todos os módulos, dispositivos de toque ou todos os leitores de tela. A suíte R completa não foi repetida; as falhas prévias relatadas em `test_transversal_saidas.R`, gradiente e longitudinal não foram alteradas nem usadas como falhas novas desta navegação. Avaliar os layouts internos dos demais módulos continua sendo uma etapa própria.

## Arquivos da mudança

- `inst/app/app.R`: versão dos recursos de navegação.
- `inst/app/www/layout-sidebar.css`: sidebar, flyout e adaptação de largura.
- `inst/app/www/layout-sidebar.js`: atalhos, busca, posição, seleção e foco.
- `inst/app/tests/test_layout_flyout.cjs`: teste de interação no app local.
- `docs/PROTOTIPO_SIDEBAR.md`: escopo, execução, validação e limites.
## Refinamento de legibilidade (14/10/2026)

- Sidebar medida em **300 px**, contra 356 px da versão anterior. Itens em **14,5 px**, ícones em **20 px**, coluna de ícones de 22 px e seta alinhada à direita. O nome mais longo é medido com peso 600 para manter o encaixe quando ficar ativo. Se fonte ou nomes mudarem, o cálculo ajusta a largura necessária.
- Flyout em **313 px** no Planejamento e entre **260 e 338 px** nos treze menus. Itens em **14,5 px**, ícones em **19 px**, nomes integrais em uma linha. A largura considera o nome mais longo, o título e os grupos.
- Menos espaçamento vertical: links principais com 4 px acima/abaixo, opções do flyout com 5 px, e separadores mais compactos. Em **1280 × 720 px de área útil**, todos os menus principais e as 14 opções do Planejamento couberam sem rolagem vertical. Em **1024 × 640 px**, as listas usam rolagem independente; nenhum item é removido para caber.
- **Aberto**: contorno claro, fundo azul intermediário e seta para baixo. **Em uso**: fundo azul-petróleo, marca à esquerda e indicação do módulo. O teste selecionou “Visualizar e suavizar” em Séries Temporais e depois abriu Planejamento, conferindo que os dois estados coexistem em menus diferentes.
- Marca original `inst/app/www/logo_trilha_transparente.png`: **2078 × 757 px**, sem slogan incorporado. O arquivo não foi alterado; é exibido inteiro em **192 × 69,94 px**, com proporção conferida. O slogan separado é exatamente **“Da pesquisa ao relatório, uma só trilha em R.”**, em duas linhas, com fonte de 12,5 px. O cabeçalho completo mede aproximadamente 120 px de altura.

### Verificações desta revisão

`test_layout_flyout.cjs` passou com status 0 contra o app real, em Chrome isolado, com zoom/escala visual de **100%**. Foram medidos os **13 menus e 87 opções**: todos os nomes preservados, em uma linha, sem overflow horizontal no desktop. O teste verificou fonte, proporção da marca, slogan, distinção dos estados, busca, teclado, fechamento, posição, preservação dos campos e retorno ao Transversal depois de trocar de módulo.

As áreas úteis testadas foram **1440 × 900**, **1366 × 768**, **1280 × 720**, **1024 × 640**, além de larguras menores de 600, 480 e 320 px para conferir contenção e rolagem. Medidas detalhadas em `outputs/sidebar-refino/medidas.json`.

Comparação das expressões R com o commit anterior: menus, corpos dos módulos e servidor idênticos. Sintaxe R/JavaScript e `git diff --check` sem erro. Nenhuma dependência de produção foi acrescentada. Os cálculos e exportadores não foram alterados; a suíte estatística completa não foi repetida. Ao abrir Séries com os dados iniciais, o módulo emitiu avisos gráficos sobre escala de cores e linhas ausentes; essas saídas estatísticas não foram revalidadas nesta tarefa de layout.

Capturas inspecionadas: `outputs/sidebar-refino/flyout-estados.png` (1440 × 900), `flyout-estados-1280.png` (1280 × 720), `flyout-1024.png` (1024 × 640) e `flyout-estreito.png`. A ferramenta interativa não conseguiu ler a janela pessoal do autor; os tamanhos acima são as áreas úteis reais das sessões locais de teste. A UI mede a janela e a fonte novamente ao carregar, ao mudar de tamanho e após o carregamento de fontes, sem depender das dimensões da captura de referência.