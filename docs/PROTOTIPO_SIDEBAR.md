# Protótipo local: navegação lateral com flyout

Branch de trabalho: `feat/layout-sidebar`. Ajustes locais realizados em 14/10/2026; nada publicado no remoto.

## Comportamento atual

Os menus principais permanecem na barra, organizados em Pesquisa, Análises e Aprender e comunicar. Um clique abre um único painel flutuante à direita; outro menu troca o conteúdo, e repetir o clique fecha o painel. Selecionar um módulo (inclusive o já ativo), clicar fora, usar o botão de fechar ou pressionar Esc também fecha. O menu ativo, a indicação “Em uso” e o caminho do módulo são preservados.

A largura do painel é medida pelos nomes reais com a fonte carregada no navegador e limitada ao espaço disponível; no refinamento atual, variou de 260 a 350 px. Seu topo acompanha o menu acionado e é corrigido para caber na janela; redimensionamento e rolagem da barra recalculam a posição. A ponta à esquerda acompanha o centro do menu de origem. Cabeçalho e rodapé ficam separados da lista, que tem rolagem própria. Menus com oito ou mais módulos oferecem busca local pelo nome, ignorando maiúsculas e acentos; grupos sem resultados ficam ocultos durante a busca.

Enter ou Espaço abre/fecha o menu; seta direita/baixo entra no painel. Setas, Home/End e Tab permitem percorrer os controles, e Esc devolve o foco ao botão de origem. O painel é não modal: a área central e os outros menus continuam acessíveis.

A fonte dos menus varia de 14,5 a 15 px conforme a altura útil e o encaixe dos nomes na barra compacta; os módulos permanecem em 14,5 px. Os rótulos não são escondidos, abreviados ou transformados em reticências. A lista principal e o flyout têm rolagem própria; quando a janela é estreita demais para comportar fisicamente os nomes, há também rolagem horizontal para mantê-los em uma linha. O painel continua inteiramente dentro da janela e à direita da barra.
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

A sessão de teste atual está em `http://127.0.0.1:4625`. Neste ambiente, foi necessário ajustar somente a sessão R antes da execução:

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
node inst/app/tests/test_layout_flyout.cjs http://127.0.0.1:4625
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

## Tema escuro e distribuição adaptável (14/10/2026)

Esta revisão mantém a sidebar compacta em **300 px CSS**. O JavaScript mede a altura útil depois da marca e usa o espaço restante para aumentar moderadamente o preenchimento vertical das linhas, de **4 até 12 px** acima e abaixo, além do intervalo dos três grupos. Não estica a marca nem muda a posição dos menus ao abrir o flyout. Em alturas maiores, a fonte sobe de **14,5 para 15 px** e os ícones de **20 para 21 px**, desde que os nomes completos continuem cabendo na largura compacta. O preenchimento volta ao mínimo antes de precisar de rolagem. O limite superior evita grandes intervalos em monitores altos.

O painel usa **#123E5B**, textos **#F2F7FB**, grupos **#B6D5E6**, hover **#244E6D** e seleção teal **#086786**. Cabeçalho, busca, botão de fechar, rodapé e rolagem seguem a mesma paleta. Contraste medido: **10,44:1** nos textos principais e **7,32:1** nos títulos dos grupos. Opções mantêm fonte de **14,5 px**, ícones de **19 px** em uma coluna de 20 px e 6 px de preenchimento vertical. O conjunto ícone + nome tem **12 px de recuo** em relação aos títulos, feito por padding. Os títulos continuam sendo organizadores estáticos.

A largura incorpora o recuo ao medir os nomes: **292 px** em Regressões, **325 px** em Planejamento e **260–350 px** nos treze menus. A ponta tem 8 px de profundidade e 16 px de altura, ocupa o intervalo entre sidebar e painel e usa o mesmo fundo. Sua posição vertical vem do centro da linha acionada, depois de corrigir o topo do painel para a janela. O painel continua no corpo da página; seu overflow permite exibir a ponta, enquanto somente a lista rola.

### Validação em 75% e 100%

Os testes `test_layout_flyout.cjs` e `test_layout_zoom.cjs` passaram com **status 0** contra o app real em `http://127.0.0.1:4625`. O segundo usa zoom nativo do Chrome, em perfis temporários separados, sem mudar o navegador pessoal ou simular zoom por CSS. A configuração da partição padrão segue o [código do Chromium](https://chromium.googlesource.com/chromium/src/+/caa5e0d1c9d58de7bbcf686857034253d0a26ac8/chrome/browser/ui/zoom/chrome_zoom_level_prefs.cc). O zoom foi confirmado por `devicePixelRatio` de 1 ou 0,75, com escala visual de 1 e dimensões correspondentes. As capturas usam a área útil física da janela para evitar área vazia adicional no zoom reduzido.

| Área útil física | Janela CSS a 100% | Janela CSS a 75% |
| --- | --- | --- |
| 1440 × 900 | 1440 × 900 | 1920 × 1200 |
| 1280 × 720 | 1280 × 720 | 1706 × 960 |
| 1024 × 640 | 1024 × 640 | 1365 × 853 |

Em **1280 × 720 físicos**, todos os menus principais ficaram acessíveis sem rolagem nos dois zooms. A 75%, fonte de 15 px, ícones de 21 px e preenchimento vertical de 11,75 px; a 100%, fonte de 14,5 px, ícones de 20 px e preenchimento de 5,5 px. Em 1024 × 640 a 100%, a sidebar e a lista longa de Planejamento usam rolagem própria. O teste de navegação também conferiu larguras de 600, 480 e 320 px, preservando acesso aos nomes integrais por rolagem quando não há largura física suficiente.

Nos dois zooms foram conferidos os **13 menus e 87 módulos**, contraste, textos em uma linha, alinhamento, recuo, ponta alinhada, contenção na janela e abertura sem deslocamento dos menus. Busca, fechamento, Esc e foco continuaram funcionando. A pergunta preenchida e as 7 UAs no Transversal foram preservadas, com o mesmo elemento no DOM, inclusive após visitar Séries Temporais. Planejamento aberto e Séries em uso continuam visualmente distintos. Nenhum erro JavaScript foi registrado.

Sintaxe R/JavaScript e comparação das expressões R passaram: menus, corpos dos módulos e servidor idênticos à base, excluindo a versão dos recursos de layout. A suíte estatística completa não foi repetida; os avisos gráficos ao abrir Séries permanecem fora do escopo deste acabamento. Houve espera ampliada para a renderização inicial dos campos dinâmicos e um aviso de cópia temporária de recurso do bslib em uma das sessões; as rodadas concluídas não registraram erros JavaScript. Nenhum pacote foi atualizado ou acrescentado.

Medidas em `outputs/sidebar-escuro/medidas.json` e `medidas-zoom.json`. Capturas finais: `regressoes-75.png`, `regressoes-100.png`, `planejamento-75.png` e `planejamento-100.png`, dentro de `outputs/sidebar-escuro/`.

Arquivo adicional de verificação: `inst/app/tests/test_layout_zoom.cjs`. Para repetir com o app iniciado e o Playwright de desenvolvimento no NODE_PATH:

```text
node inst/app/tests/test_layout_zoom.cjs http://127.0.0.1:4625
```